def sampleMap = ['Key#1':'Value#1', 'Key#2':'Value#2']
println sampleMap['Key#1']
node{
    // itertate over stages
    for (key in sampleMap.keySet()){
        val = "${sampleMap[key]}"
        println key
        println val
        stage('Run Key'){
            println "Ran ${key}"
        }

        stage('Ran Value for that Key'){
            println "Ran ${val}"
        }

        stage('Clean Up'){
            println "Ran Some sort of Cleanup"
        }
    }
}
