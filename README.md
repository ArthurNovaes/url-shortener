# README

Things you may want to cover:

* Database creation

* Database initialization

* Deployment instructions

## Docker Installation and enviroment configuration Guide

### Instalation guide for Ubuntu (18.04 ou 16.04)

### Docker instalation

The installation of the docker can be done in several ways. The standart guide for instalation 
can be found here [LINK](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

---
The installation from the repository can be done by following the steps below

* Repository configuration
```
1. sudo apt-get update
2. sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
3. curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
4. sudo apt-key fingerprint 0EBFCD88
5. sudo add-apt-repository 
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu 
   $(lsb_release -cs) 
   stable"
```
*  Docker CE installation **(Required)**
```
1. sudo apt-get update
2. sudo apt-get install docker-ce docker-ce-cli containerd.io 
```
---
The installation via package can be performed following the following steps (Optional)

```
1. download the package through this link:  https://download.docker.com/linux/ubuntu/dists/
2. Access the directory where the download was done
3. Execute the command: sudo dpkg -i /path/to/package.deb
```
---
### Script way installation (More faster)

if you want to install everything directly, in path  **script/docker/**, has one file **install-docker.sh**

```
1. In your local machine execute the permission for script: sudo chmod +x install-docker.sh
2. Execute the script: ./install-docker.sh
```

### Execute docker without Sudo (optional). 

By default the docker command can only be run by the root user or by a user in the docker group. 
this [LINK](https://www.digitalocean.com/community/tutorials/como-instalar-e-usar-o-docker-no-ubuntu-18-04-pt#passo-2-%E2%80%94-executando-o-comando-docker-sem-sudo-(opcional)) helps with running docker without sudo.

you can perform the following steps

* sudo usermod -aG docker ${USER}
* su - ${USER}
* id -nG
* sudo usermod -aG docker **user-name**

---
### Additional Information

In some situations, when the project is cloned recently, when trying to make several changes in the container, how to example the execution of **rails db:seed**, an error message appears. **FATAL: Listen error: unable to monitor directories for changes.**
this error basically consists of number of new files that have been inserted into the system. 
To carry out the correction it is necessary in your local machine execute the following command.
```
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```
---
### Commands for container build, run and access

* To build the container
Add --tag for made run more easier
```
    docker-compose build . --tag url-shortener
```
* To start the container, with enviroments variables
```
    sudo docker run -it -p 3000:3000 -e DATABASE_HOST=your_host -e DATABASE_USERNAME=user_database -e DATABASE_PASSWORD=database_password -e DATABASE_NAME=name -e DATABASE_PORT=port_database url-shortener
```
* Container access
```
    docker exec -it url-shortener bash
```
---
### How to run the test suite

* Enter on container
```
    docker exec -it url-shortener bash
```
* Run database configuration for test
```
    RAILS_ENV=test rails db:create
    RAILS_ENV=test rails db:migrate
```
* Run tests
```
    bundle exex rspec
```
