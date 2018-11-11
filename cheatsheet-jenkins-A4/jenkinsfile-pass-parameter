node {
  def seconds = readFile("/tmp/test.txt")

    echo "seconds begin"
    echo seconds
    echo "seconds done"
    parallel firstBranch: {
    // do something
    build job: 'SleepAnHour', parameters: [string(name: 'sleep_seconds', value: seconds)]
  }, secondBranch: {
    // do something else
    build job: 'SleepTwoHours', parameters: [string(name: 'sleep_seconds', value: seconds)]
      },
       failFast: true
    }
