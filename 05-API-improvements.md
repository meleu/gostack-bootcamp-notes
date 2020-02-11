# Improving the API

## Uploading files

Allowing the user to have an avatar.


### multer

Install `multer` to handle Multipart Form data:
```
yarn add multer
```

Create a new folder: `tmp/uploads`.

Create a file `src/config/multer.js`:
```js
import multer from 'multer';
import crypto from 'crypto';
import { extname, resolve } from 'path';

export default {
  storage: multer.diskStorage({
    destination: resolve(__dirname, '..', '..', 'tmp', 'uploads'),
    filename: (req, file, cb) => {
      crypto.randomBytes(16, (err, res) => {
        return err
          ? cb(err)
          : cb(null, res.toString('hex') + extname(file.originalname));
      });
    },
  }),
};
```

Add multer stuff in `src/routes.js`:
```js
// importing multer stuff
import multer from 'multer';
import multerConfig from './config/multer';

// importing FileController
import FileController from './app/controllers/FileController';


// instantiate a multer object
const upload = multer(multerConfig);

// below the authentication middleware call
routes.post('/files', upload.single('file'), FileController.store);
```

### Database table for files

Create a migration for the `files` table:
```
yarn sequelize migration:create --name=create-files
```

File `src/database/migrations/XXXXXXX-create-files.js` contents:
```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('files', {
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
      path: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
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

  down: queryInterface => {
    return queryInterface.dropTable('files');
  },
};
```

Run the migration:
```
yarn sequelize db:migrate
```

### File Model

Create the file `src/app/models/File.js`:
```js
import Sequelize, { Model } from 'sequelize';

class File extends Model {
  static init(sequelize) {
    super.init(
      {
        name: Sequelize.STRING,
        path: Sequelize.STRING,
      },
      {
        sequelize,
      }
    );

    return this;
  }
}

export default File;
```

Import the `File.js` model in `src/database/index.js`.


### File Controller

Create the `src/app/controllers/FileController.js`:
```js
import File from '../models/File';

class FileController {
  async store(req, res) {
    const { originalname: name, filename: path } = req.file;

    const file = await File.create({ name, path });

    return res.json(file);
  }
}

export default new FileController();
```

### Add the `avatar_id` field to the `users` table

Create a new field for the `users` table:
```
yarn sequelize migration:create --name=add-avatar-field-to-users
```

Edit `src/database/migrations/XXXXXXX-add-avatar-field-to-users.js`:
```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('users', 'avatar_id', {
      type: Sequelize.INTEGER,
      references: { model: 'files', key: 'id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true,
    });
  },

  down: queryInterface => {
    return queryInterface.dropTable('users', 'avatar_id');
  },
};
```

Run the migration:
```
yarn sequelize db:migrate
```

### Associating the File with the User model

Add `associate` method to `src/app/models/User.js`:
```js
static associate(models) {
  this.belongsTo(models.File, { foreignKey: 'avatar_id' });
}
```

In `src/database/index.js`:
```js
  init() {
    this.connection = new Sequelize(databaseConfig);

    models
      .map(model => model.init(this.connection))
      .map(model => model.associate && model.associate(this.connection.models));
  }
```


## Making appointments

### List service providers

Create `src/app/controllers/ProviderController.js`:
```js
import User from '../models/User';
import File from '../models/File';

class ProviderController {
  async index(req, res) {
    const providers = await User.findAll({
      where: { provider: true },
      attributes: ['id', 'name', 'email', 'avatar_id'],
      include: [{
        model: File,
        as: 'avatar',
        attributes: ['name', 'path', 'url'],
      }],
    });

    return res.json(providers);
  }
}

export default new ProviderController();
```

In `src/app/models/User.js`, method `associate()`:
```js
  this.belongsTo(models.File, { foreignKey: 'avatar_id', as: 'avatar' });
```

In `src/app/models/File.js`, method `init()`:
```js
  super.init(
    {
      name: Sequelize.STRING,
      path: Sequelize.STRING,
      url: {
        type: Sequelize.VIRTUAL,
        get() {
          return `http://localhost:3333/files/${this.path}`;
        },
      },
    },
  // ...
```

Make the app able to serve static files: in the `src/app.js`, method `middlewares()`:
```js
// import path to resolve the path name
import path from 'path';

// inside middlewares()
  this.server.use(
    '/files',
    express.static(path.resolve(__dirname, '..', 'tmp', 'uploads'))
  );
```

Add a route for `/providers`:
```js
// import the controller
import ProviderController from './app/controllers/ProviderController';

// add the route
routes.get('/providers', ProviderController.index);
```

Test with insomnia...


### Appointment migration and model

```
yarn sequelize migration:create --name=create-appointments
```

Edit `src/database/migrations/XXXXX-create-appointments.js
```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('appointments', {
      id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      date: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      user_id: {
        type: Sequelize.INTEGER,
        references: { model: 'users', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
        allowNull: true,
      },
      provider_id: {
        type: Sequelize.INTEGER,
        references: { model: 'users', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
        allowNull: true,
      },
      cancelled_at: {
        type: Sequelize.DATE,
        allowNull: true,
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

  down: queryInterface => {
    return queryInterface.dropTable('appointments');
  },
};
```

```
yarn sequelize db:migrate
```

Create an appointment model `src/app/models/Appointment.js`:
```js
import Sequelize, { Model } from 'sequelize';

class Appointment extends Model {
  static init(sequelize) {
    super.init(
      {
        date: Sequelize.DATE,
        canceled_at: Sequelize.DATE,
      },
      {
        sequelize,
      }
    );
    return this;
  }

  static associate(models) {
    this.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
    this.belongsTo(models.User, { foreignKey: 'provider_id', as: 'provider' });
  }
}

export default Appointment;
```

Add the model to `src/database/index.js`:
```
// import the model and add it to the array of models
import Appointment from '../app/models/Appointment.js';

// ...
const models = [User, File, Appointment];
```

### Making an appointment

Create a controller `src/app/controllers/AppointmentController.js`:
```js
import * as Yup from 'yup';
import Appointment from '../models/Appointment';
import User from '../models/User';

class AppointmentController {
  async store(req, res) {
    const schema = Yup.object().shape({
      provider_id: Yup.number().required(),
      date: Yup.date().required(),
    });

    if (!(await schema.isValid(req.body))) {
      return res.status(400).json({ error: 'Validation fails' });
    }

    const { provider_id, date } = req.body;

    const isProvider = await User.findOne({
      where: { id: provider_id, provider: true },
    });

    if (!isProvider) {
      return res.status(400).json({ error: 'You must inform a provider user' });
    }

    const appointment = await Appointment.create({
      user_id: req.userId,
      provider_id,
      date,
    });

    return res.json(appointment);
  }
}

export default new AppointmentController();
```

Create a route for appointments in `src/routes.js`:
```js
// import the controller
import AppointmentController from './src/app/controllers/AppointmentController.js';

// put this bellow the authentication
routes.post('/appointments', AppointmentsController.store);
```

### Validating appointments

Let's assure the appointment is not scheduled to a past date-time and that the provider is available.

```
yarn add date-fns
```

In `src/app/controllers/AppointmentController.js`:
```js
import { startOfHour, parseISO, isBefore } from 'date-fns';

// right below checking if the user is a provider
    const hourStart = startOfHour(parseISO(date));
    if (isBefore(hourStart, new Date())) {
      return res.status(400).json({ error: 'Past dates are not permitted' });
    }

    const isNotAvailable = await Appointment.findOne({
      where: {
        provider_id,
        canceled_at: null,
        date: hourStart,
      },
    });
    if (isNotAvailable) {
      return res.status(400).json({
        error: 'The provider is not available at the given date-time',
      });
    }
```


Test with insomnia...


### Listing user's appointments

Add the route in `src/routes.js`:
```js
routes.get('/appointments', AppointmentController.index);
```

In `src/app/controllers/AppointmentController.js`:
```js
// import file model
import File from '../models/File';

  async index(req, res) {
    const { page = 1 } = req.query;

    const appointments = await Appointment.findAll({
      where: {
        user_id: req.userId,
        canceled_at: null,
      },
      order: ['date'],
      attributes: ['id', 'date'],
      limit: 20,
      offset: (page - 1) * 20,
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'name'],
          include: [
            {
              model: File,
              as: 'avatar',
              attributes: ['id', 'path', 'url'],
            },
          ],
        },
      ],
    });

    return res.json(appointments);
  }
```


### Listing provider's schedule

Create the controller `src/app/controllers/ScheduleController.js`:
```js
import { startOfDay, endOfDay, parseISO } from 'date-fns';
import { Op } from 'sequelize';

import User from '../models/User';
import Appointment from '../models/Appointment';

class ScheduleController {
  async index(req, res) {
    const isProvider = await User.findOne({
      where: {
        id: req.userId,
        provider: true,
      },
    });
    if (!isProvider) {
      return res.status(401).json({ error: 'User is not a provider' });
    }

    const parsedDate = parseISO(req.query.date);

    const appointments = await Appointment.findAll({
      where: {
        provider_id: req.userId,
        canceled_at: null,
        date: {
          [Op.between]: [startOfDay(parsedDate), endOfDay(parsedDate)],
        },
      },
      order: ['date'],
    });

    return res.json(appointments);
  }
}

export default new ScheduleController();
```

Create the route in `src/routes.js`:
```js
import ScheduleController from './app/controllers/ScheduleController';


// below the authentication
routes.get('/schedule', ScheduleController.index);
```
