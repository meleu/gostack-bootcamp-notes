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

### getting data from `req`

we can get some data from the `req` parameter:






> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTkzMDMxMjYzLC00MzA0Nzk0MzNdfQ==
-->