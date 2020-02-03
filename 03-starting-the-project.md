# Starting the project

## structure

Source code goes in `src/`

Common files are: `app.js`, `server.js` and `routes.js`.


## sucrase and nodemon

```
yarn sucrase nodemon -D
```

in `package.json`:
```json
  "scripts": {
    "dev": "nodemon --config nodemon.json src/server.js",
  }
```

in `.nodemon.json`:
```json
{
  "execMap": {
    "js": "node --require sucrase/register"
  }
}
```

sucrase allow us to use the "import-from" syntax:

```js
// thanks to sucrase we can use 'import ... from ...'
import express from 'express';

class App {
  constructor() {
    this.server = express()
    // ...
  }

  // ...
}

// thanks to sucrase we can use 'export default ...'
export default new App().server;
```

### debugging

add `dev:debug` in `package.json`, like this:
```json
  "scripts": {
    "dev": "nodemon --config nodemon.json src/server.js",
    "dev:debug": "nodemon --inspect src/server.js"
  }
```

Go to the debug section in VSCode and start a new `launch.json`. In this file, remove the line with the `program` property and change the ones listed below:

```json
{
  "configurations": [
    {
      "request": "attach",
      "restart": true,
      "protocol": "inspector"
    }
  ]
}
```

## docker

Install docker following the instructions in [https://docs.docker.com/install/](https://docs.docker.com/install/) and don't forget to follow the Post-install instructions.

basic commands:

```
docker ps                   # list active containers
docker ps -a                # list available containers in this machine
docker stop containerName   # quite obvious
docker start containerName  # idem
docker log containerName    # idem
docker run  # ??
```

## PostgreSQL

Installing a PostgreSQL container:

docker: [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)

install:
```
docker run --name database -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres
```

**note**: in the `-p` option, the first number is the port in the actual machine, the number at the right of the `:` is the port of the container.


### Postbird

A neat GUI to access a PostgreSQL database (runs on Linux):
[https://www.electronjs.org/apps/postbird](https://www.electronjs.org/apps/postbird)


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






> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwNjUxMjAyOTgsLTE1MjU2NTQ2OCwtMT
UzMjY5NzQzMCw5NDIzOTQwMzJdfQ==
-->