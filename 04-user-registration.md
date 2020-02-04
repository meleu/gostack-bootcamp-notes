# User Registration and Authentication

## User's Migration

```
yarn sequelize migration:create --name=create-users
```

In the file `src/database/migrations/XXXX-create-users.js`:

```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('users', {
      id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
      },
      password_hash: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      provider: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
        allowNull: false,
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
      },
    });
  },
  // down: ...
}
```

And then run:
```
yarn sequelize db:migrate
```

If I need to undo last migration:
```
yarn sequelize db:migrate:undo
```

Undo all migrations
```
yarn sequelize db:migrate:undo:all
```

## User Model

in `src/app/models/User.js`:
```js
import Sequelize, { Model } from 'sequelize';

class User extends Model {
  static init(sequelize) {
    super.init(
      {
        name: Sequelize.STRING,
        email: Sequelize.STRING,
        password_hash: Sequelize.STRING,
        provider: Sequelize.BOOLEAN,
      },
      {
        sequelize,
      }
    );
  }
}

export default User;
```

**NOTE** the properties of the first argument of `super.ini()` above does NOT need to reflect the database table. You can use fields that are not present on the DB table.

## Model Loader

Create the file to connect to the database and load the models: `src/database/index.js`:

```js
import Sequelize from 'sequelize';
import User from '../app/models/User';

import databaseConfig from '../config/database';

const models = [User];

class Database {
  constructor() {
    this.init();
  }

  init() {
    this.connection = new Sequelize(databaseConfig);

    models.map(model => model.init(this.connection));
  }
}

export default new Database();
```

import the file in the `src/app.js`:
```js
// put this with the imports of the src/app.js
import './database'; // automatically imports the index.js
```

## Registering a new user

file `src/app/controllers/UserController.js`
```js
import User from '../models/User';

class UserController {
  async store(req, res) {
    const userExists = await User.findOne({
      where: { email: req.body.email },
    });

    if (userExists) {
      return res.status(400).json({ error: 'email is already in use.' });
    }

    const { id, name, email, provider } = await User.create(req.body);

    return res.json({
      id,
      name,
      email,
      provider,
    });
  }
}

export default new UserController();
```

in order to test, let's use this `src/routes.js`:
```js
import { Router } from 'express';

import UserController from './app/controllers/UserController';

const routes = new Router();

routes.post('/users', UserController.store);

export default routes;
```

## Generating Password Hash

```
yarn add bcryptjs
```

in the file `src/app/models/User.js`:
```js
// add the bcrypt import
import bcrypt from 'bcryptjs';

// add this as a property of the first argument of super.init() call
        password: Sequelize.VIRTUAL,

// call this method right after super.init()
    this.addHook('beforeSave', async (user) => {
      if (user.password) {
        user.password_hash = await bcrypt.hash(user.password, 8);
      }
    });

    return this;
```

**NOTES**:

- `Sequelize.VIRTUAL` is a field that doesn't exist in the database table.
- `this.addHook('beforeSave', callback)` runs the callback function before saving anything in the database.
- the second argument of `bcrypt.hash()` defines the number of rounds to be used to encrypt the password.

