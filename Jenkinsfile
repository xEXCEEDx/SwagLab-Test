pipeline {
    agent any

    environment {
        BROWSER = 'chrome'
        HEADLESS = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout โค้ดจาก Git repository
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
                    // ระบุ path ของ output.xml ที่อยู่ในไดเรกทอรี results
                    def resultFile = 'results/output.xml'
                    
                    // ตรวจสอบว่าไฟล์ output.xml มีอยู่หรือไม่
                    echo "Checking if file exists: ${resultFile}"

                    if (fileExists(resultFile)) {
                        // ใช้ junit เพื่อดูผลการทดสอบจากไฟล์ output.xml
                        junit '**/results/output.xml'  // ใช้คำสั่ง junit
                    } else {
                        echo "Output file does not exist!"
                    }
                }
            }
        }
    }

    post {
        always {
            // ทุกครั้งที่ build เสร็จ จะทำการ clean workspace
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
