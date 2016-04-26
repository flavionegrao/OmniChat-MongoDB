FROM ubuntu:latest
MAINTAINER flavio@omni.chat

# Install Percona Mongo
RUN sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
RUN echo "deb http://repo.percona.com/apt "$(lsb_release -sc)" main" | sudo tee /etc/apt/sources.list.d/percona.list
RUN echo "deb-src http://repo.percona.com/apt "$(lsb_release -sc)" main" | sudo tee -a /etc/apt/sources.list.d/percona.list
RUN sudo apt-get update && apt-get install -y \
percona-server-mongodb

COPY mongo* /opt/
RUN mkdir -p /data/db
# Install Go Lang
RUN sudo apt-get update && apt-get install -y curl git
RUN curl https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz | sudo tar xzf - -C /usr/local
RUN sudo mkdir /go
RUN sudo chmod 0777 /go
ENV PATH="/usr/local/go/bin:${PATH}:"
ENV GOPATH=/go'

# Installing strata for incrementals backups
RUN go get github.com/facebookgo/rocks-strata/strata/cmd/mongo/lreplica_s3storage_driver/strata
RUN go install github.com/facebookgo/rocks-strata/strata/cmd/mongo/lreplica_s3storage_driver/strata

ENTRYPOINT ["mongod","--storageEngine","rocksdb","--smallfiles"]
