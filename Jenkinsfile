pipeline {
    agent any
    environment {
        BROWSER = 'chrome'
        HEADLESS = 'true'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/xEXCEEDx/SwagLab-Test.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    bat 'pip install -r requirements.txt'
                }
            }
        }
        stage('Run Robot Framework Tests') {
            steps {
                script {
                    // Run Robot Framework tests with Pabot
                    bat 'pabot --processes 5 --outputdir results --output output.xml --log log.html --report report.html --xunit xunit.xml "test/*.robot"'
                }
            }
        }
        stage('Publish Results') {
            steps {
                script {
                    // Verify result files exist
                    def outputFile = 'results/output.xml'
                    def logFile = 'results/log.html'
                    def reportFile = 'results/report.html'
                    def xunitFile = 'results/xunit.xml'
                    
                    // Use Robot Framework plugin for comprehensive reporting
                    robot outputPath: 'results', 
                          passThreshold: 100, 
                          unstableThreshold: 90,
                          onlyCritical: true
                    
                    // Additional JUnit reporting for compatibility
                    junit testResults: 'results/xunit.xml', 
                         allowEmptyResults: true
                }
            }
        }
    }
    post {
        always {
            // Archive all result files
            archiveArtifacts artifacts: 'results/*', 
                             allowEmptyArchive: true
            
            // Clean workspace after archiving
            cleanWs()
        }
        success {
            echo 'Build Successful!'
        }
        failure {
            echo 'Build Failed!'
        }
    }
}
