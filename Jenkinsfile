pipeline {
    agent any

    environment {
        BROWSER = 'chrome'         // กำหนดเบราว์เซอร์ที่ใช้
        HEADLESS = 'true'          // กำหนดให้ใช้โหมด headless
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout โค้ดจาก Git repository โดยระบุ branch ที่ถูกต้อง
                git branch: 'main', url: 'https://github.com/xEXCEEDx/SwagLab-Test.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // ติดตั้ง dependencies ที่จำเป็น เช่น Robot Framework และ pabot
                    bat 'pip install -r requirements.txt'
                }
            }
        }

        stage('Run Robot Framework Tests') {
            steps {
                script {
                    // ใช้คำสั่ง pabot เพื่อรัน Robot Framework tests ในโหมด headless
                    bat 'pabot --processes 5 --outputdir results --variable BROWSER:${BROWSER} --variable HEADLESS:${HEADLESS} "test/*.robot"'
                }
            }
        }

        stage('Publish Results') {
            steps {
                // แสดงผลการทดสอบ Robot Framework
                robot results
            }
        }
    }

    post {
        always {
            // ทุกครั้งที่ build เสร็จ จะ cleanup workspace
            cleanWs()
        }
        success {
            // ถ้า build สำเร็จ
            echo 'Build Successful!'
        }
        failure {
            // ถ้า build ล้มเหลว
            echo 'Build Failed!'
        }
    }
}

