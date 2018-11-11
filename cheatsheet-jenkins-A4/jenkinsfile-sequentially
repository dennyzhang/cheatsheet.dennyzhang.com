stage('stage1') {
    echo 'Hello World'
}


stage('stage2') {
   build 'dennyjob1'
}

stage('stage3') {
   build job: 'dennyjob2', parameters: [string(name: 'env1', value: 'value3')]
}