TEMPLATE = 'http://sc-dbc1214.eng.vmware.com/chaol/concourse/chaol-concourse-template/chaol-concourse-template.ovf'

module NimbusConcourseTestbed
	CONCOURSE_DOWNLOAD_URL = {
		'4.2.2' => nil, # Embeded in the vm template
		'5.0.0' => 'https://github.com/concourse/concourse/releases/download/v5.0.0/concourse-5.0.0-linux-amd64.tgz',
	}

	def self.install_concourse_binary(nodes, version)
		return if version == '4.2.2'

		if CONCOURSE_DOWNLOAD_URL[version].nil?
			raise 'No Concourse binary download URL. This should be a bug of testbed spec.'
		end
		concourse_binary = CONCOURSE_DOWNLOAD_URL[version]

		nodes.each do |node|
			node.ssh do |ssh|
				ssh.exec!("sudo mkdir -p /usr/local")
				ssh.exec!("sudo sh -c 'curl \'#{concourse_binary}\' -L | tar xvfz - -C /usr/local'")
				ssh.exec!("sudo rm -rf /usr/bin/concourse")
				ssh.exec!("sudo ln -s /usr/local/concourse/bin/concourse /usr/bin/concourse")
			end
		end
	end

	def self.configure_web_node(node)
		puts "#{Time.now}: web: generating keys ..."
		node.ssh do |ssh|
			ssh.exec!("ssh-keygen -t rsa -f tsa_host_key -N ''")
			ssh.exec!("ssh-keygen -t rsa -f session_signing_key -N ''")
		end
	end

	def self.configure_worker_nodes(nodes, web_node)
		known_keys = ''
		tsa_key = ''

		puts "#{Time.now}: worker: generating keys ..."
		web_node.ssh do |ssh|
			tsa_key = ssh.exec!("cat tsa_host_key.pub")
		end

		nodes.each do |node|
			node.ssh do |ssh|
				ssh.exec!("ssh-keygen -t rsa -f worker_key -N ''")
				known_keys << ssh.exec!("cat worker_key.pub")
				ssh.exec!("echo '#{tsa_key}' > tsa.tsa_host_key.pub")
			end
		end

		puts "#{Time.now}: worker: copy worker public keys to web node ..."
		web_node.ssh do |ssh|
			ssh.exec!("echo '#{known_keys}' > authorized_worker_keys")
		end
	end

	def self.start_web_node(node)
		cmd = "concourse web --add-local-user test:123456 --main-team-local-user " \
		      "test --session-signing-key session_signing_key --tsa-host-key tsa_host_key " \
		      "--tsa-authorized-keys authorized_worker_keys --postgres-user=atc " \
		      "--postgres-password=atc --external-url=http://#{node.info['ip']}:8080 " \
		      "> web.out 2>&1"
		
		puts "#{Time.now}: web: starting ..."
		node.ssh do |ssh|
			ssh.exec!("sudo service postgresql start")
			ssh.exec!("bash -c 'echo \"nohup #{cmd} &\" > start_web.sh'")
			ssh.exec!("chmod +x start_web.sh")
			ssh.exec!("./start_web.sh")
		end
	end

	def self.start_worker_nodes(nodes, web_node)
		cmd = "concourse worker --work-dir=/home/worker/concourse-worker "\
		      "--tsa-host=#{web_node.info['ip']}:2222 --tsa-public-key=tsa_host_key.pub "\
		      "--tsa-worker-private-key=worker_key > worker.out 2>&1"
		nodes.each_with_index do |node, index|
			puts "#{Time.now}: worker-#{index}: starting ..."
			node.ssh do |ssh|
				ssh.exec!("bash -c 'echo \"sudo nohup #{cmd} &\" > start_worker.sh'")
				ssh.exec!("chmod +x start_worker.sh")
				ssh.exec!("./start_worker.sh")
			end
		end
	end
end

$testbed = Proc.new do |*args|
	argsH = {}
	args.each { |arg| k, v = arg.split('='); argsH[k] = v} if args
	workers = argsH['worker-count'].to_i rescue 0
	total = 1 + workers
	concourse_version = argsH['version'] || '5.0.0'
	Log.info("Deploy #{total} VMs ...")

	unless NimbusConcourseTestbed::CONCOURSE_DOWNLOAD_URL.key?(concourse_version)
		raise "Invalid concurse version #{concourse_version} specified! Valid versions are #{NimbusConcourseTestbed::CONCOURSE_DOWNLOAD_URL.keys}."
	end

	{
		'version' => 3,
		'name' => "concourse-testbed-#{workers}-workers",

		'ovfVm' => (1..total).map { |index|
			mem_mb = (total == 1 || index >= 1) ? 4096 : 2048
			{
				'ovfUrl' => TEMPLATE,
				'memory' => mem_mb,
				'cpus' => 2,
				'cpuReservation' => '800',
				'memoryReservation' => '1024',
				'userName' => 'worker',
				'password' => 'ca$hc0w'
			}
		},

		'postBoot' => Proc.new do |runId, testbedSpec, vmList, catApi, logDir|
			Log.info("Waiting for VM to boot up ...")
			sleep(20)

			nodes = vmList['ovfVm']

			# Configure web node on the first node
			web_node = nodes[0]
			# Configure worker nodes
			worker_nodes = if workers == 0
				nodes
			else
				nodes[1..-1]
			end

			NimbusConcourseTestbed.install_concourse_binary(nodes, concourse_version)
			NimbusConcourseTestbed.configure_web_node(web_node)
			NimbusConcourseTestbed.configure_worker_nodes(worker_nodes, web_node)
			NimbusConcourseTestbed.start_web_node(web_node)
			NimbusConcourseTestbed.start_worker_nodes(worker_nodes, web_node)
		end,

		'extraTestbedInfo' => Proc.new do |runId, testbedSpec, vmList, catApi, logDir|
			web_node = vmList['ovfVm'][0]
			{
				'concourse' => "http://#{web_node.info['ip']}:8080",
				'concourse_version' => concourse_version
			}
		end
	}
end
