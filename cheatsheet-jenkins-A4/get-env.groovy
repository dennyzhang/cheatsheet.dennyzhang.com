// https://stackoverflow.com/questions/31707667/how-to-access-jenkins-environment-variables-with-dsl
def envVars = Jenkins.instance.getGlobalNodeProperties()[0].getEnvVars()
println envVars['myVar']

/*
import hudson.model.*;
import jenkins.model.*;

Thread.start {
      sleep 10000
      println "--> setting agent port for jnlp"
      def env = System.getenv()
      int port = env['JENKINS_SLAVE_AGENT_PORT'].toInteger()
      Jenkins.instance.setSlaveAgentPort(port)
      println "--> setting agent port for jnlp... done"
}
*/
