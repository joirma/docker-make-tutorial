# docker-make-tutorial
## Pre-requisitos
- Host linux
- Docker instalado en el host
'''
$ yum install -y docker
$ systemctl enable docker
$ systemctl start docker
'''
- Make instalado en el host
'''
$ yum install -y make
'''



Demo
$ docker run --rm --name registry -p 5000:5000 docker.io/registry
