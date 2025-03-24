pipeline {
    agent any

    environment {
        // ใช้ path ที่ติดตั้งบน Jenkins server
        PYTHON_PATH = 'C:\\Python313'
        ROBOT_PATH = "${PYTHON_PATH}\\Scripts"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/xEXCEEDx/SwagLab-Test.git',
                credentialsId: 'github-token'
            }
        }
        
        stage('Setup Environment') {
            steps {
                script {
                    // ตรวจสอบ Python ก่อนติดตั้ง
                    bat "\"${ROBOT_PATH}\\python.exe\" --version || echo Python not found"
                    
                    // ติดตั้ง dependencies
                    bat "\"${ROBOT_PATH}\\pip.exe\" install -r requirements.txt"
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // ลบผลลัพธ์เก่า (ถ้ามี)
                    bat 'if exist results rmdir /s /q results || echo No results to delete'
                    
                    // รันเทสต์แบบขนาน
                    bat "\"${ROBOT_PATH}\\pabot.exe\" --processes 3 --outputdir results test"
                }
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true
            robot outputPath: 'results'
        }
    }
}
