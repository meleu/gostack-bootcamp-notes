# Backend Summary

The goal here is to quickly achieve the final code of this module of the course but in a shorter path than the one taken during the course.

## Development Environment

Pre-requisites:

- VS Code
- Insomnia
- Docker


### EditorConfig

- Install `EditorConfig for VS Code` plugin
- right-click on the file structure and choose `Generate .editorconfig`
- put this content in the `.editorconfig` file:
```
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
end_of_line = lf
```

### ESLint

- Install `ESLint` plugin
- Press Ctrl+Shift+P and `open settings (json)`, and then add:
```json
"editor.codeActionsOnSave": {
  "source.fixAll.eslint": true
}
```

#### Node

For node, let's use the 6.8.0 version, as the new ones have some inconveniences.

[TODO: what are the inconveniences in the new version of eslint?]

```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. None of these
# 4. (use TypeScript?) Yes
# 5. (mark only Node with space bar and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No
# copy the packages shown on the question 9 above and then...
yarn add @typescript-eslint/eslint-plugin@latest eslint-config-airbnb-base@latest eslint-plugin-import@^2.21.2 @typescript-eslint/parser@latest -D
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslintignore` file:
```
/*.js
node_modules
dist
```

Edit `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "rules": {
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

Restart VS Code

### Prettier

It's the same for NodeJS, ReactJS and React Native.

```
yarn add prettier eslint-config-prettier eslint-plugin-prettier -D
```

Edit the `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    "prettier/@typescript-eslint",
    "plugin:prettier/recommended",
  ],
  // ...
  "plugins": [
    // ...
    "prettier"
  ],
  "rules": {
    // ...
    "prettier/prettier": "error"
  },
  // ...
}
```

#### Solving conflicts between ESLint and Prettier.

`prettier.config.js`
```js
module.exports = {
  singleQuote: true, 
  trailingComma: 'all',
  arrowParens: 'avoid',
}
```

`.eslintignore`:
```
# ...
/*.js
```

## Debugging in VS Code

- Click on the VS Code debugging icon.
- Click `create a launch.json file`.

`.vscode/launch.json`:
```json
{
  "version": "...",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "protocol": "inspector",
      "restart": true,
      "name": "Debug",
      "skipFiles": [
        "<node_internals>/**"
      ],
      "outFiles": [
        "${workspaceFolder}/**/*.js"
      ]
    }
  ]
}
```

`package.json`:
```json
  "dev:server": "ts-node-dev --inspect --transpile-only --ignore node_modules src/server.ts"
```

Now when launching `dev:server` the debugger will be listening and if you click in the debuggin icon it'll be attached
to the application's debugger.

Use the `WATCH` to add variables you want to check.

**Note**: when the debugger is attached, the bottom bar becomes red.


## Docker & Data Base

- Install docker following the instructions in <https://docs.docker.com/install/> and don’t forget to follow the post-install instructions.

- Installing a PostgreSQL container:
```
docker run --name gostack_postgresql -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres
#       --name=""
#          Assign a name to the container
#       -e, --env=[]
#          Set environment variables
#       -p, --publish ip:[hostPort]:containerPort | [hostPort:]containerPort
#          Publish a container's port, or range of ports, to the host.
#       -d, --detach=true|false
#          Detached mode: run the container in the background and print the new container ID. The default is false.
```

- Install DBeaver: <https://dbeaver.io/>

- Through DBeaver, create a database named `gostack_gobarber`.


### QueryFailedError: function uuid_generate_v4() does not exist

**IMPORTANT**: if while running a migration you receive this error:
```
QueryFailedError: function uuid_generate_v4() does not exist
```

Then run this command inside PostgreSQL, in the `gostack_gobarber` database:
```
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

## Kickstarting the Code

```
$ tree src/
src/
├── routes
│   └── index.ts
└── server.ts
```

The `server` uses the `routes/index` and launches the express server.

And the `routes/index` answer with a 'Hello World' message in a JSON.


## Handling Errors

Let's handle the errors right from the start.


## TypeORM

- Install:
```
yarn add typeorm pg reflect-metadata
```

- Add typeorm to the `packages.json`:
```json
"scripts": {
  "typeorm": "ts-node-dev ./node_modules/typeorm/cli.js"
}
```

- `ormconfig.json`:
```json
{
  "type": "postgres",
  "host": "localhost", // host of your database
  "port": 5432,
  "username": "postgres",
  "password": "docker",
  "database": "gostack_gobarber",
  "entities": [
    "./src/models/*.ts"
  ],
  "migrations": [
    "./src/database/migrations/*.ts"
  ],
  "cli": {
    "migrationsDir": "./src/database/migrations"
  }
}
```
- `src/database/index.ts` to connect to the database:
```ts
import { createConnection } from 'typeorm';

createConnection();
```

- `src/server.ts`:
```ts
import 'reflect-metadata';
// ...
import './database';
// ...
```


## Users

### API Endpoints

Before actually implementing the CRUD for the users, create some requests inside insomnia:

- GET /users/ [authenticated] - returns the individual user's data
- POST /users - body: name, email, password
- PUT /users/:id [authenticated] - body: name?, email?, password?
- PATCH /users/avatar [authenticated] - file: avatar image
- POST /sessions - body: email, password

Create the `src/routes/users.routes.ts` with a dummy JSON response for each one of those endpoints.

Import `user.routes` in `routes/index` and use it.

Test the endpoints with insomnia.

### Registering Users

- migration
```
yarn typeorm migration:create -n CreateUsers
```

- Columns to be created
  - id
  - name
  - email
  - password
  - avatar
  - created_at
  - updated_at

- run the migration:
```
yarn typeorm migration:run
``

- Check in the DBeaver if the table was really created.

- Create the `src/models/User.ts`.

- Install bcrypt in order to encrypt user's password before persisting it:
```
yarn add bcryptjs
yarn add -D @types/bcryptjs
``

- Create the `src/services/CreateUserService` and handle these business rules before persisting data:
  - password, name, email not empty
  - email is valid
  - encrypt password (using `{ hash } from 'bcryptjs'`)

- In the `users.routes`, make use of the `CreateUserService` and create a new user. **Note**: do not give the password in the response.


### Authentication


#### Requesting a Token

- Install
```
yarn add jsonwebtoken
yarn add -D @types/jsonwebtoken
```

- Create a `src/config/auth.ts` with the jwt `secret` and `expiresIn`.

- Create the `sessions.routes.ts` to receive the email and password, pass them to the service and give the token as response.

- Import the `sessions.routes` in the `routes/index.ts`.

- Create the `AuthenticateUserService.ts` to check if the email and password are both valid. If yes, generate a token.


#### Authentication Middleware

- Create `src/middlewares/ensureAuthenticated.ts` to check if the token given in the `request.headers.authorization` is valid (remember to deal with the `Bearer: `).
  - Create the `src/@types/express.d.ts`:
```ts
declare namespace Express {
  export interface Request {
    user: {
      id: string;
    };
  }
}
```

- Make use of the `ensureAuthenticated` middleware in the `/users/avatar` endpoint.


## Uploading The Avatar

TODO...



