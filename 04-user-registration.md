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
        allowNull: false
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

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5MjcyNzUxNjNdfQ==
-->