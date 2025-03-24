pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://your-repository-url.git'
            }
        }
        
        stage('Setup Environment') {
            steps {
                script {
                    // ติดตั้ง Python dependencies
                    bat 'pip install -r requirements.txt'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // ล้างผลลัพธ์เก่า (ถ้ามี)
                    bat 'rmdir /s /q results || echo "No results folder to delete"'
                    
                    // รันเทสต์แบบขนานด้วย Pabot
                    bat 'pabot --processes 3 --outputdir results test'
                }
            }
        }
    }
    
    post {
        always {
            // Archive ผลลัพธ์
            archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true
            
            // Publish Robot Framework report
            robot outputPath: 'results'
        }
    }
}