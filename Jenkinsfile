pipeline {
    agent any

    environment {
        // กำหนด path ไปยัง Python และ Robot Framework
        PYTHON_PATH = 'C:\\Users\\Nutta\\AppData\\Local\\Programs\\Python\\Python313-32'
        ROBOT_PATH = "${PYTHON_PATH}\\Scripts"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/xEXCEEDx/SwagLab-Test.git',
                credentialsId: 'github-token'  // หาก repository เป็น private
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // ใช้ full path ในการเรียก pip
                    bat "\"${ROBOT_PATH}\\pip.exe\" install --upgrade pip"
                    bat "\"${ROBOT_PATH}\\pip.exe\" install -r requirements.txt"
                    
                    // ตรวจสอบ version เพื่อยืนยันการติดตั้ง
                    bat "\"${ROBOT_PATH}\\python.exe\" --version"
                    bat "\"${ROBOT_PATH}\\pip.exe\" --version"
                    bat "\"${ROBOT_PATH}\\robot.bat\" --version"
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // ลบผลลัพธ์เก่า (ถ้ามี)
                    bat 'if exist results rmdir /s /q results'
                    
                    // รันเทสต์แบบขนานด้วย Pabot โดยใช้ full path
                    bat "\"${ROBOT_PATH}\\pabot.exe\" --processes 3 --outputdir results test"
                    
                    // หรือใช้ robot.bat หากต้องการรันแบบปกติ
                    // bat "\"${ROBOT_PATH}\\robot.bat\" --outputdir results test\\*.robot"
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
