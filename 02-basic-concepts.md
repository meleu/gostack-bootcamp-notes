# Basic Concepts

## Node.js

Using [nvm](https://github.com/nvm-sh/nvm) is better than install node from your distro's official package (avoid problems with different versions of node).

Use `yarn` instead of `npm` (that comes with node by default) to manage JS packages/dependencies. (**note**: I still didn't find why `yarn` is considered a better option, but let's keep going...)

Node.js features:

- event-loop architecture:
    - event based (in a web context it means *routes*)
    - call stack (a LIFO)
- single thread
    - behind the scenes, C++ and libuv allows multithread
    - background threads
- non blocking I/O

## frameworks

ExpressJS (good for starters):

- Non-opnionated (generalist)

Opnionated frameworks:

- AdonisJS
- NestJS


## REST APIs

HTTP verbs:

-  GET http://minhaapi.com/users
-  POST http://minhaapi.com/users
-  PUT http://minhaapi.com/users/1
-  DELETE [http://minhaapi.com/users/1

data flows in JSON format

## basic structure of a HTTP request

```
GET http://api.com/company/1/users?page=2
# route -----------^       ^ ^     ^
# route parameter ---------' |     |
# route ---------------------'     |
# query parameters ----------------'
```

The POST and PUT methods also use the `body` field.

Another commonly used field is the `Header`.


## HTTP Codes

Commonly used HTTP codes:

-   1xx: informational
-   2xx: success
    -   200: SUCCESS
    -   201: CREATED
-   3xx: Redirection
    -   301: MOVED PERMANENTLY
    -   302: MOVED
-   4xx: Client Error
    -   400: BAD REQUEST
    -   401: UNAUTHORIZED
    -   404: NOT FOUND
-   5xx: Server Error
    -   500: INTERNAL SERVER ERROR


## ExpressJS

**Hello World**
```js
const express = require('express');
const server = express();

server.get('/hello', (req, res) => {
  return res.json({ message: 'Hello World!' });
});

server.listen(3000)
```

### getting HTTP data from `req`

we can get some HTTP data from the `req` parameter.

URL example
```
GET http://api.com/company/1/users?page=2
# route -----------^       ^ ^     ^
# route parameter ---------' |     |
# route ---------------------'     |
# query parameters ----------------'
```
#### route parameter

example to get the company ID from `/company/:id`
```js
server.get('/company/:id', (req, res) => {
  const { id } = req.params;
  // ...
}
```

#### query params

example to get the page value from `?page=2`:
```js
server.get('/users/:id', (req, res) => {
  const { page } = req.query;
  // ...
}
```

#### body properties

example to get the name and email from the body `{ "name": "meleu", "email": "meleu@mailserver.com" }`:
```js
server.post('/user', (req, res) => {
  const { name, email } = req.body;
  // ...
}
```

## nodemon

Using `nodemon` is a nice way to restart your application right after saving your code.
```
yarn add nodemon -D
```
then add to your `package.json`:
```json
  "scripts": {
    "dev": "nodemon index.js"
  }
```

now, just execute `yarn dev` (ou `npm run dev`).

## CRUD

dumb example using an array named `users`:
```js
// Create
server.post('/users', (req, res) => {
    const { name } = req.body;
    users.push(name);
    return res.json(users);
});

// Read all
server.get('/users', (req, res) => {
    return res.json(users);
});

// Read
server.get('/users/:id', (req, res) => {
    const { id } = req.params;
    return res.json(users[id]);
});

// Update
server.put('/users/:id', (req, res) => {
    const { id } = req.params;
    const { name } = req.body;
    users[id] = name;
    return res.json(users);
});

// Delete
server.delete('/users/:id', (req, res) => {
    const { id } = req.params;
    users.splice(id, 1);
    return res.send();
});
```

see also: https://github.com/meleu/bootcamp-gostack-challenge-01/blob/master/index.js


## middleware

It's a function/method executed in a sequence with other functions/methods.

Example:

```js
// a middleware function
function checkBodyHasName(req, res, next) {
  if (!req.body.name) {
    return res.status(400).json({ error: 'User name is required' });
  }
  return next();
}

// middleware function being used:
server.post('/users', checkBodyHasName, (req, res) => {
  const { name } = req.body;
  users.push(name);
  return res.json(users);
});
```

**Note**: to use a middleware in all requests, `server.use(middlewareFunction)`

## Sequelize

ORM = Object-Relational Mapping

With an ORM we can abstract the database:

- tables become models
- no need to use SQL code (just JavaScript)


### Migrations

- database version control.
- files with instrcutions to create, change and delete tables/fields in a database.
- each file is a migration and they are sorted by date-time.
- database updated between all contributors and production.
- **IMPORTANT** once a migration is shared between contributors and/or production it can **NEVER** be edited again
- each migrations changes only one table

### Seeds

- populate a database:
    - for development
    - for tests
- not used in production
- if data need to go to production, they should go on a migration, not a seed.

## MVC Architecture

MVC = Model View Controller

Separate the files/directories responsibilities.


### Model

- Represents a database abstraction.
- Used to manipulate data in database tables.
- A Model do **NOT** have responsibility for the business rule of the application.


### Controller

- Starting point of the requests of our application.
- A route is usually associated with a Controller method.
- A good portion of the business rules are implemented in the controllers.
- A controller is a class.
- Always returns a JSON.
- Do not calls other controller/method.
- Every Model has a Controller, but there are Controllers for entities that are not Models.
- Only 5 methods:

```js
// example
class UserController {
  index() { }  // list all users
  show() { }   // show details of an user
  store() { }  // create a new user
  update() { } // change user's info
  delete() { } // remove user's entry
}
```

### View

- What is returned to the client.
- In applications that do not use REST APIs, it can be HTML.
- In our case it'll be a JSON to be sent to the front-end and manipulated by React[Native].


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY2NTM4NTYwMSwtMTYwMjk5MjQxOCwtOT
g5NTMxOTIwLC0xMTY5NDkzODAzLC00MzA0Nzk0MzNdfQ==
-->