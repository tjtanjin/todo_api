<p align="center">
  <img src="https://i.imgur.com/5vut1a3.png" />
  <h1 align="center">Todo Manager API</h1>
</p>

## Table of Contents
* [Introduction](#introduction)
* [Features](#features)
* [Technologies](#technologies)
* [Setup](#setup)
* [Team](#team)
* [Contributing](#contributing)
* [Others](#others)

### Introduction
Todo Manager API is one of three small projects that form up the Todo Manager project that can be found here:
```
https://github.com/tjtanjin/CVWO-Assignment
```
This repository contains work concerning the backend API server for Todo Manager, which serves our other two projects for the updating and retrieving of information.

Application link:
```
https://todo-manager.tjtanjin.com
```

### Features
Apart from providing basic create, read, update and delete functionalities pertaining to tasks, the API also provides a variety of means for updating users in order to deliver features that enhance user experience such as email notifications and password reset/verification features. The API is also responsible for deciding when to send which emails to our users so that they will always be kept up to date with the relevant information.

If you are interested in the full list of our application features, please refer to our user guide:
```
https://github.com/tjtanjin/todo_website/wiki/User-Guide
```

### Technologies
Technologies used by Todo Manager API is as below:
##### Done with:

<p align="center">
  <img height="150" width="150" src="https://i.ya-webdesign.com/images/ruby-transparent-rail-logo-4.png" />
</p>
<p align="center">
Ruby on Rails
</p>
<p align="center">
  <img height="150" width="150" src="https://img.icons8.com/color/240/000000/postgreesql.png" />
</p>
<p align="center">
PostgreSQL
</p>

##### Deployed on:
<p align="center">
  <img height="150" width="150" src="https://img.icons8.com/color/240/000000/heroku.png" />
</p>
<p align="center">
Heroku
</p>

##### Project Repository
```
https://github.com/tjtanjin/todo_api
```

### Setup
The following section will guide you through setting up your own Todo API!
* As this project is hosted on heroku, it would be easier to fork this repository instead of cloning it locally so as to facilitate easier automatic deploys later on in the guide. However, if you wish to clone this repository, go ahead and cd to where you wish to store the project and clone it as shown in the example below:
```
$ cd /home/user/exampleuser/projects/
$ git clone https://github.com/tjtanjin/todo_api.git
```
* Within the heroku dashboard, configure either heroku git or github for automatic deploys (hence my suggestion to fork instead of cloning the repository).
* Next, owing to the complexity of this project, you will need to add 13 environment variables as listed below:
```
API_DOMAIN
DATABASE_URL
LANG
NEW_SENDGRID_KEY
NEW_SENDGRID_PASSWORD
RACK_ENV
RAILS_ENV
RAILS_LOG_TO_STDOUT
RAILS_SERVE_STATIC_FILES
SECRET_KEY_BASE
SENDGRID_PASSWORD
SENDGRID_SENDER
SENDGRID_USERNAME
```
The names of the variables above are quite self-explanatory and I will not be diving into the details of how to obtain the values for all of them. If you have a strong reason for replicating this project/setting up this Todo API, kindly email me for assistance at: cjtanjin@gmail.com

### Team
* [Tan Jin](https://github.com/tjtanjin)

### Contributing
If you have code to contribute to the project, open a pull request and describe clearly the changes and what they are intended to do (enhancement, bug fixes etc). Alternatively, you may simply raise bugs or suggestions by opening an issue.

### Others
If there are any questions pertaining to the application itself, kindly use the chatbot found at the bottom right corner of our application (https://todo-manager.tjtanjin.com).

For any questions regarding the implementation of the project, please drop me an email at: cjtanjin@gmail.com.
