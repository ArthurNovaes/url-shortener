# README

## API DOC

**GET /urls/:id**

Should returns a 301 redirect to the original address of the URL.
Receive a optional existing user login:
*{"login": "joao"}*
If not pass login, the hit will save without user_id.

Response:
```
301 Redirect
Location:
```
If id does not exist in the system, the return must be a 404 Not Found.

**POST /urls**

Register a new url.
Params:
*{"url": "http://www.google.com.br/t3st3"}*

The response is a JSON object equal to the call GET /stats/:id with code 201 Created.
```
{
  "id": "23094",
  "hits": 0,
  "url": "http://www.google.com.br/t3st3",
  "shortUrl": "http://<host>[:<port>]/asdfeiba"
}
```

**GET /stats**

Returns general statistics.
```
{
  "hits": 193841, // Quantidade de hits em todas as urls do sistema
  "urlCount": 2512, // Quantidade de urls cadastradas
  "topUrls": [
  {
    "id": "23094",
    "hits": 153,
    "url": "www.google.com.br/t3st3",
    "shortUrl": "http://<host>[:<port>]/asdfeiba"
  },
  {
    "id": "23090",
    "hits": 89,
    "url": "www.google.com.br/t3st3",
    "shortUrl": "http://<host>[:<port>]/asdfeiba"
  },
// ...
  ]
}
```

**GET /users/:userId/stats**

Returns statistics of a user's urls.
The result is the same as GET */stats* but with the scope within a user.
If the user does not exist the return must be code 404 Not Found.

**GET /stats/:id**

Returns statistics for a specific URL
```
{
  "id": "23094",
  "hits": 0,
  "url": "http://www.google.com.br/t3st3",
  "shortUrl": "http://short.url.com/asdfeiba"
}
```

**DELETE /urls/:id**

Deletes URL.

**POST /users**

Create a user. Receive the login:
*{"login": "joao"}*

Response:
```
{
  "id": 1,
  "login": "joao"
}
```

**DELETE /user/:userId**

Deletes a user.

## Technologies
* Ruby 2.5.1
* Rails 5.2.3
* PostgreSQL 9.4+
* Node.js 5.x.x+

This project can be configured and started on a docker container or directly in your machine.

## Setup without docker

**1. Environment Dependencies**

- Ruby: we recommend to use some version manager like [RVM](https://rvm.io/) or [rbenv](https://github.com/rbenv/rbenv) 
- [Node.js](https://nodejs.org/en/)

**2. Environment Variables**

Create a file named `.env` on the root of the project with the following content and replace with your the database info

```
DATABASE_HOST='REPLACE'
DATABASE_USERNAME='REPLACE'
DATABASE_PASSWORD='REPLACE'
DATABASE_NAME='REPLACE'
DATABASE_PORT=5432
```

**3. Database**

You must add the database variables on .env described above.
Create a database directly on **PostgreSQL** (with psql) or use:
```
  rails db:create // create a default database following .env
```
After that run:

```
  rails db:migrate // add tables
```

**4. Bundle**

	bundle install
	
**5. Run aplication**
```
  rails s
```
	
## Tests
Update your test env database:
	
	RAILS_ENV=test rails db:drop
	RAILS_ENV=test rails db:create
	RAILS_ENV=test rails db:migrate
	
And run the tests:

	rspec

## Docker Installation and enviroment configuration Guide

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

---
### Commands for container build, run and access

* To build the container
Add --tag for made run more easier
```
    sudo docker build . --tag url-shortener
```
* To start the container, with enviroments variables
```
    sudo docker run -it -p 3000:3000 -e DATABASE_HOST=REPLACE -e DATABASE_USERNAME=REPLACE -e DATABASE_PASSWORD=REPLACE -e DATABASE_NAME=REPLACE -e DATABASE_PORT=5432 url-shortener
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
    bundle exec rspec
```
