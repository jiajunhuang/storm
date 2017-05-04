pipeline {
  agent any
  stages {
    stage('pull') {
      steps {
        sh '''cd $WORKSPACE
git pull'''
        echo 'install cython'
        sh 'pip install cython'
      }
    }
    stage('echo') {
      steps {
        sh 'echo hello world'
      }
    }
  }
}