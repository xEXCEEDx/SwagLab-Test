pipeline {
    agent any

    environment {
        BROWSER = 'chrome'
        HEADLESS = 'true'
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
                    // รัน Robot Framework โดยใช้ pabot
                    bat 'pabot --processes 5 --outputdir results "test/*.robot"'
                }
            }
        }

        stage('Publish Results') {
            steps {
                script {
                    // ตรวจสอบว่าไฟล์ผลลัพธ์มีอยู่ในโฟลเดอร์ results หรือไม่
                    def resultsDir = 'results'
                    def outputFile = "${resultsDir}/output.xml"
                    if (fileExists(outputFile)) {
                        // แสดงผลการทดสอบ Robot Framework
                        robot outputFile
                    } else {
                        error "Robot Framework results not found!"
                    }
                }
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
