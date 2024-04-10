template = '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: terraform
  name: terraform
spec:
  containers:
  - command:
    - sleep
    - "3600"
    image: hashicorp/terraform
    imagePullPolicy: Always
    name: terraform
    '''

    podTemplate(cloud: 'kubernetes', label: 'terraform', yaml: template) {
    node ("terraform") {
    container ("terraform") {
    stage ("Checkout SCM") {
        git branch: 'main', url: 'https://github.com/herabakirova/heraproject.git'
    }
    stage ("Keys") {
        sh '''
        ssh-keygen -b 2048 -t rsa -f /home/jenkins/agent/workspace/project/id_rsa -q -N ""
        '''
    }
    withCredentials([
        usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY ', usernameVariable: 'AWS_ACCESS_KEY_ID')
        ]) {
    stage ("AWS") {
        sh '''
        terraform init
        terraform apply --auto-approve
        '''
    }
    }
    }
    }
    }
