oneGB = 1 * 1024 * 1024 # in KB

numEsxStr = ENV.fetch('NUM_ESX', '3')
numEsx = Integer(numEsxStr)
esxStyle = ENV.fetch('ESX_STYLE', 'fullInstall')

$testbed = Proc.new do
  testbed = {
    'name' => "chengch-#{numEsx}-esx-#{esxStyle}",
    'esx' => (0..(numEsx-1)).map do |i|
      {
        'name' => "esx.#{i}",
        'numCPUs' => 8,
        'style' => esxStyle,
        'numMem' => 32 * 1024,
        'ssd' => [ 80 * oneGB ] * 3,
        'freeLocalLuns' => 2,
        'nicType' => 'vmxnet3',
        'nics' => 4,
        'staf' => false,
        'desiredPassword' => 'ca$hc0w',
        'vmotionNics' => ['vmk0'],
        'physical' => false,
        'vsanNics' => ['vmk1'],
        'mountNfs' => ['nfs.0:/exports/nfsMount1'],
        'mountNfsWithPath' => true
      }
    end,

    'vc' => {
      'name' => 'vc.0',
      'type' => 'vcva',
      'numMem' => 16 * 1024,
      'dbType' => 'embedded',
      'dcName' => 'datacenter',
      'clusterName' => 'cluster',
      'addHosts' => 'allInSameCluster'
    },

   'nfs' => [
      {
        'name' => "nfs.0",
        'disks' =>  [ 100 * oneGB ],
        'mountPoints' => ['nfsMount1']
      },
    ],

   'vsan' => true
  }

  testbed
end

testbedSpec = $testbed.call()
Nimbus::TestbedRegistry.registerTestbed testbedSpec
