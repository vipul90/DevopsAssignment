pipeline{
	agent any

environment
{
    scannerHome = tool name: 'sonar_scanner_dotnet', type: 'hudson.plugins.sonar.MsBuildSQRunnerInstallation'   
}
options
   {
      timeout(time: 1, unit: 'HOURS')
      
      // Discard old builds after 5 days or 5 builds count.
      buildDiscarder(logRotator(daysToKeepStr: '5', numToKeepStr: '5'))
	  
	  //To avoid concurrent builds to avoid multiple checkouts
	  disableConcurrentBuilds()
   }
     
stages
{
	stage ('checkout')
    {
		steps
		{
			echo  " ********** Clone starts ******************"
		    checkout scm	 
		}
    }
    stage ('nuget')
    {
		steps
		{
			sh "dotnet restore"	 
		}
    }
	stage ('Start sonarqube analysis')
	{
		steps
		{
			withSonarQubeEnv('Test_Sonar')
			{
				sh "dotnet ${scannerHome}/SonarScanner.MSBuild.dll begin /k:$JOB_NAME /n:$JOB_NAME /v:1.0 "    
			}
		}
	}
	stage ('build')
	{
		steps
		{
			sh "dotnet build -c Release -o WebApplication4/app/build"
		}	
	}
	stage ('SonarQube Analysis end')
	{	
		steps
		{
		    withSonarQubeEnv('Test_Sonar')
			{
				sh "dotnet ${scannerHome}/SonarScanner.MSBuild.dll end"
			}
		}
	}
	stage ('Release Artifacts')
	{
	    steps
	    {
	        sh "dotnet publish -c Release -o WebApplication4/app/publish"
	    }
	}
	stage ('Docker Image')
	{
		steps
		{
		    sh returnStdout: true, script: '/bin/docker build --no-cache -t dtr.nagarro.com:443/dotnetcoreapp_vipulchohan:${BUILD_NUMBER} .'
		}
	}
	stage ('Push to DTR')
	{
		steps
		{
			sh returnStdout: true, script: '/bin/docker push dtr.nagarro.com:443/dotnetcoreapp_vipulchohan:${BUILD_NUMBER}'
		}
	}
	stage ('Stop Running container')
	{
	    steps
	    {
	        sh '''
                ContainerID=$(docker ps | grep 5250 | cut -d " " -f 1)
                if [  $ContainerID ]
                then
                    docker stop $ContainerID
                    docker rm -f $ContainerID
                fi
            '''
	    }
	}
	stage ('Docker deployment')
	{
	    steps
	    {
	       sh 'docker run --name dotnetcoreapp_vipulchohan -d -p 5250:80 dtr.nagarro.com:443/dotnetcoreapp_vipulchohan:${BUILD_NUMBER}'
	    }
	}
	
}

 post {
        always 
		{
			echo "*********** Executing post tasks like Email notifications *****************"
        }
    }
}
