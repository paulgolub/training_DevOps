def repositoryUrl = "https://github.com/paulgolub/training_DevOps.git"
def gitUrl = "paulgolub/training_DevOps.git"
def tree = "task3"
def gradleProp = "gradle.properties"
def artifact = "task3.war"
def WAR = "./build/libs/task3.war"
def tomwar = "./test.war"
def GitUser = "paulgolub"
def GitUserEmail = "g@gmail.com"
def tomcatNode = ['tomcatnode1', 'tomcatnode2']
def tomcats = ['tomcat1', 'tomcat2']

node () {
    stage ('GitHub. git branch...'){
		git branch: tree, url: repositoryUrl
	}

    stage ('Build. Gradle script.'){
		sh('chmod +x ./gradlew && ./gradlew task increment && ./gradlew clean build')
	}
	
	def propFile = readFile gradleProp
	def version = propFile.substring(8)
	
	stage('Copy files to Nexus repository.') {
		withCredentials([usernamePassword(credentialsId: 'nexuscredentials', passwordVariable: 'NEXUS_PASS', usernameVariable: 'NEXUS_U')]) {
			sh "curl -Lv -u ${NEXUS_U}:${NEXUS_PASS} -T ${WAR} \"http://192.168.10.21:8081/nexus/content/repositories/snapshots/${tree}/${version}/\""
		} 
	}

	if(tomcats.size()>0){
		int i = 0
		for (tomcat in tomcats){
			stage("Deploy WAR-artifact to "+tomcat.toString()+""){
				
                def temp = "http://127.0.0.1:80/jkmanager/?cmd=update&from=list&w=balance&sw=${tomcatNode[i]}&vwa=1"
				httpRequest httpMode: 'POST', url: temp

                withCredentials([usernamePassword(credentialsId: 'tomcatctrdentials', passwordVariable: 'Tom_Pass', usernameVariable: 'Tom_U')]) {
						sh "curl -o test.war \"http://192.168.10.21:8081/nexus/content/repositories/snapshots/${tree}/${version}/${artifact}\" | curl -u ${Tom_U}:${Tom_Pass} \"http://${tomcat}:8080/manager/text/undeploy?path=/test\" && curl -XPUT -T ${tomwar} -u ${Tom_U}:${Tom_Pass} \"http://${tomcat}:8080/manager/text/deploy?path=/test&update=true\" && curl -vv -u ${Tom_U}:${Tom_Pass} \"http://${tomcat}:8080/manager/text/reload?path=/test\""
				}
				
                sh "sleep 20" 
				
                temp = "http://127.0.0.1:80/jkmanager/?cmd=update&from=list&w=balance&sw=${tomcatNode[i]}&vwa=0"
				httpRequest httpMode: 'POST', url: temp
				
                i++
			}
	    }
	}
	
	stage('Push to GIT') {
		withCredentials([usernamePassword(credentialsId: 'gitcredentials', passwordVariable: 'git_pass', usernameVariable: 'git_login')]) {
			sh("git config --global user.name \"${GitUser}\"")
			sh("git config --global user.email \"${GitUserEmail}\"")
			sh("git add ${gradleProp}")
			sh("git status")
			sh("git tag ${version}")
			sh("git commit -am \"Jenkins commit. Build - ${version}.${BUILD_NUMBER}\"")
			sh("git push --tags https://${git_login}:${git_pass}@github.com/${gitUrl} ${tree}")
			sh("git checkout master")
			sh("git merge task3")
			sh("git tag ${version}_master")
			sh("git push --tags https://${git_login}:${git_pass}@github.com/${gitUrl} master")
		}
	}
}
	
