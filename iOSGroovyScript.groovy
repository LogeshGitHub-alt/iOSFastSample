pipeline {
    agent any

    environment {
        KEYCHAIN_PATH = '/Users/digitalpayments/Library/Keychains/login.keychain-db'
        KEYCHAIN_PASSWORD = 'Narawlog@123' // Consider using Jenkins credentials for security
        PROJECT_NAME = 'WebView'
        SCHEME = 'WebView'
        EXPORT_OPTIONS_PLIST = '/Users/digitalpayments/Documents/Dummy/webView/ExportOptions.plist'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/LogeshGitHub-alt/iOSFastSample.git'
            }
        }

        stage('Unlock Keychain') {
            steps {
                sh '''
                security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
                '''
            }
        }

        stage('Build') {
            steps {
                script {
                    if (fileExists("${PROJECT_NAME}.xcworkspace")) {
                        sh '''
                        xcodebuild -workspace ${PROJECT_NAME}.xcworkspace \
                                   -scheme ${SCHEME} \
                                   -sdk iphoneos \
                                   -configuration Release \
                                   -archivePath $WORKSPACE/build/${PROJECT_NAME}.xcarchive archive
                        '''
                    } else {
                        sh '''
                        xcodebuild -project ${PROJECT_NAME}.xcodeproj \
                                   -scheme ${SCHEME} \
                                   -sdk iphoneos \
                                   -configuration Release \
                                   -archivePath $WORKSPACE/build/${PROJECT_NAME}.xcarchive archive
                        '''
                    }
                }
            }
        }

        stage('Export IPA') {
            steps {
                sh '''
                xcodebuild -exportArchive \
                           -archivePath $WORKSPACE/build/${PROJECT_NAME}.xcarchive \
                           -exportPath $WORKSPACE/build \
                           -exportOptionsPlist ${EXPORT_OPTIONS_PLIST}
                '''
            }
        }

        // stage('Run Script') {
        //     steps {
        //         // Change 'scripts/build_script.sh' to the relative path of your script
        //         sh 'scripts/build_script.sh'
        //     }
        // }
    }

    post {
        always {
            archiveArtifacts artifacts: 'build/*.ipa', fingerprint: true
        }
    }
}
