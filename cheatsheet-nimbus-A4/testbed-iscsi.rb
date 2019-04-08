# https://confluence.eng.vmware.com/display/NIMBUS/Deploy+Your+First+Nimbus+Testbed?preview=/214932734/214932731/Nimbus%20Demo%20Testbed%20Deploy.mp4
require 'nimbus/testbed-common.rb'

VIM = RbVmomi::VIM

oneGB = 1 * 1000 * 1000 # in KB
$testbed = Proc.new do |esxStyle, guestType|
  esxStyle ||= 'pxeBoot'
  guestType ||= 'win'

  numEsx = 1
  numEsx = numEsx.to_i

  esxStyle = esxStyle.to_s

  nameParts = ['vcqa', 'vmtools']
  nameParts << "#{numEsx}esx"
  nameParts << guestType

  testbed = {
    'version' => 3,
    'name' => nameParts.join('-'),
    'esx' => (0..1).map do |i|
      {
        'name' => "esx.#{i}",
#        "physical" => true,
        'style' => 'fullInstall',
        'disks' => [ 20 * oneGB, 20 * oneGB, 20 * oneGB],
        "ssds" => [10 * oneGB],
        'numMem' => 16 * 1024,
        'nics' => 2,
        'numCPUs' => 4,
        'staf' => false,
        'vmotionNics' => ['vmk0'],
        'freeSharedLuns' => 0,
        'freeLocalLuns' => 2,
        'iScsi' => ['iscsi.0'],
        'vc' => 'vc.0',
        'clusterName' => 'cluster1',
        'skip_liveness_check' => true,
        'guestOSlist' => [
          {
            'vmName' => "nest-vm",
            #'template' => true,
            #'datastore' => 'local',
            #'user' => 'worker',
            #'password' => 'ca$hc0w',
            #'skipReconfig' => true,
            'ovfuri' => 'http://sc1-rdops-isilon01.eng.vmware.com/new-templates/velocloud/velo-worker/velo-worker.ovf'
          },
        ],
      }
    end,
    'iscsi' => [
      {
        'name' => 'iscsi.0',
        'luns' => [30, 30, 20, 10],
        'iqnRandom' => 'test-iqn',
      },
#      {
#        'name' => 'iscsi.1',
#        'luns' => [20, 30],
#        'iqnRandom' => 'nimbus2',
#      },
    ],

    'vcs' => [
      {
        'name' => 'vc.0',
        'type' => 'vcva',
        'additionalScript' => [], # XXX: Create users
        'linuxCertFile' => '/mts/home1/tommyl/public_html/test_misc/certificate.pem',
        'dbType' => 'embedded',
#        'addHosts' => 'oneInClusterAndOneStandalone',
#        'clusterName' => 'cluster1',
         "clusters"=>[
           {
             "name"=>"cluster1",
             #'enableDrs' => true
           }
         ]
      },
    ],
    'beforePostBoot' => Proc.new do |runId, testbedSpec, vmList, catApi, logDir|
    end,
    'postBoot' => Proc.new do |runId, testbedSpec, vc, esxList, iscsiList|
    end,
    'postBootTimeout' => 10800
  }

  testbed
end

[:pxeBoot, :fullInstall].each do |esxStyle|
  [:win].each do |guestType|
    testbedSpec = $testbed.call(esxStyle, guestType)
    Nimbus::TestbedRegistry.registerTestbed testbedSpec
  end
end
