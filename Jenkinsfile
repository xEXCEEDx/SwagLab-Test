// Potential modifications to fix the test results reporting

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
                    // Use --output option to specify output XML path explicitly
                    bat 'pabot --processes 5 --outputdir results --output output.xml "test/*.robot"'
                }
            }
        }
        stage('Publish Results') {
            steps {
                script {
                    // Updated file path and error handling
                    def resultFile = 'results/output.xml'
                    
                    echo "Checking if file exists: ${resultFile}"
                    
                    // Improved file existence check
                    if (fileExists(resultFile)) {
                        // Use correct path for junit reporting
                        junit testResults: 'results/output.xml', allowEmptyResults: true
                        
                        // Additional logging for debugging
                        echo "Test results XML file found and processed"
                    } else {
                        echo "ERROR: Output file ${resultFile} does not exist!"
                        // You might want to fail the build if no results are found
                        error "No test results found"
                    }
                }
            }
        }
    }
    post {
        always {
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
