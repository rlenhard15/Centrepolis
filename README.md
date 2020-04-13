# Trello Forms
# Preparation steps:
### 1. Prerequisites
  - git
  - Docker Compose
  - PostgreSQL

Instructions on how to setup postgres are linked below.

| OS  | Link |
| ------ | ------ |
| Mac | https://postgresapp.com|
| Linux | http://postgresguide.com/setup/install.html |

Instructions on how to setup Docker are linked below.

| OS  | Link |
| ---- | ---- |
| Mac | https://docs.docker.com/docker-for-mac|
| Linux | https://docs.docker.com/engine/install/ubuntu |

### 2. Download and build project from BitBucket

```sh
$ mkdir trello_forms
$ cd trello_forms
$ git clone LINK_TO_REMOTE_REPO
$ cd back-end.task-complete-service
$ docker-compose build || sudo docker-compose build
```
### 3. Setup and run server
```sh
$ cd back-end.task-complete-service
$ docker-compose run web rails db:setup
$ docker-compose up
```
##### Your server is located: http://localhost:3000
### 4. Required keys for .env
4.1. Create `.env` file.
4.2. Generate your secret keys and place it (without spaces) in your `.env` file.

- For authentication (can be any)
```
JWT_SECRET='secret_key'
JWT_EXPIRATION_HOURS=6
```
- For send emails (can be any)
```
SENDER_EMAIL='example@ex.com'
```
- For host link
```
ADMIN_PANEL_HOST='http://localhost:3000'
```
4.3. Restart server
```sh
$ Ctrl + C
$ docker-compose down
$ docker-compose up
```
### 5. Authorization requirements
- All requests require authentication.

### 6. Api documentation
##### Api docs is located: http://localhost:3000/apipie
The main page of the documentation is separeted into sections for each required resources, which contains their routes.
For more details abount each route, you must follow the link in subsection `Resource`, next to it is subsection with short `Description `.
On pages with routes contains detailed information about:
- Request headers
- Success response body
- Required params
- Descriptions
### 7. How to contribute
7.1 Create branch
```sh
$ cd back-end.task-complete-service
$ git checkout -b branch_name_date
```
7.2 Create pull request
```sh
$ git add .
$ git commit -m "Some text"
$ git push origin branch_name_date
```
Then you must follow link with pull request and confirm its creation on `Bitbucket`.

7.3 Update your master
```sh
$ git checkout master
$ git pull origin master
```
