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

### basic structure of a HTTP request




> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjA1NzY1NTAyOF19
-->