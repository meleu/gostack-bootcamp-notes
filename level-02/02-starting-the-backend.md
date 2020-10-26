# Starting the Backend

## DataBase Abstractions

In order of level of abstraction, where 1 is the low level and 3 the high level.

1. **Native driver**: allows to write SQL queries directly.
2. **Query Builder**: allows to write SQL queries with a JavaScript abstraction.
3. **ORM - Object-Relational Mapping**: creates a relation between the application's models and the database tables.

It's recommended to use the ORM.


## docker

- creates an isolated environment (container).
- containers expose some ports for communications.

Installation instructions: <https://docs.docker.com/engine/install/ubuntu/>

### concepts: 

- **Image**: is a service offered via docker
- **Container**: is an instance of an image.
- **Docker Registry (Docker Hub)**: is a centralized service where docker images are stored.
- **Dockerfile - Image Recipe**: a script that starts a container.


## Creating a PostgreSQL Container

Before installing a postgresql container, check if you already have one available.

Basic docker commands:

```
docker ps                   # list active containers
docker ps -a                # list available containers in your machine
docker start containerName  # starts containerName
docker stop containerName   # stops containerName
docker logs containerName   # show containerName logs
docker run                  # runs a process in a new container

# by the way, here's a command to check if a specific port is open:
sudo lsof -i :portNumber
```

Installing a PostgreSQL container:
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

**Note**: in the option `-p`, the first number is the port of the "real" machine, and the number after `:` is the container's port.

### DB Clients

- DBeaver: <https://dbeaver.io/>
- Postbird: <https://www.electronjs.org/apps/postbird>
- Beekeeper Studio: <https://www.beekeeperstudio.io/>


## Configuring TypeORM

- video: <https://app.rocketseat.com.br/node/iniciando-back-end-do-app/group/banco-de-dados/lesson/configurando-type-orm>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/83179555b7caad2b6ff788aff0e64ebe66b24f08#diff-2efc37c87c194d03fc0dadbef51f8814>

TypeORM website: <https://typeorm.io/>

```
yarn add typeorm pg # pg for postgresql driver
```

Create a database named `gostack_gobarber` (using dbeaver or something).

`ormconfig.json`:
```json
{
  "type": "postgres",
  "host": "localhost", // host of your database
  "port": 5432,
  "username": "postgres",
  "password": "docker",
  "database": "gostack_gobarber"
}
```

`src/database/index.ts`:
```ts
import { createConnection } from 'typeorm';

createConnection();
```

`src/server.ts`:
```ts
import express from 'express';
import routes from './routes';

import './database'; // <-- this is enough to connect to the DB

const app = express();

app.use(express.json());
app.use(routes);

app.listen(3333, () => console.log('server started'));
```


## Creating the Appointments Table

- video: <https://app.rocketseat.com.br/node/iniciando-back-end-do-app/group/banco-de-dados/lesson/criando-tabela-de-agendamentos>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/3893bd76a55a451c1e91a9677260530eb4982229#diff-2efc37c87c194d03fc0dadbef51f8814>

1. add `migrations[]` and `cli.migrationsDir` to `ormconfig.json`.
2. add `scripts.typeorm` to `package.json`.

<!-- anki -->

```
# create a migration
yarn typeorm migration:create -n CreateAppointment

# run the migrations
yarn typeorm migration:run

# revert the migrations
yarn typeorm migration:revert

# show the executed migrations
yarn typeorm migration:show
```

`src/database/migrations/*-CreateAppointments.ts`.
```ts
import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export default class CreateAppointments
  implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'appointments',
        columns: [
          {
            name: 'id',
            type: 'varchar', // using varchar because it'll be an uuid
            isPrimary: true,
            generationStrategy: 'uuid',
          },
          {
            name: 'provider',
            type: 'varchar',
            isNullable: false,
          },
          {
            name: 'date',
            type: 'timestamp with time zone',
            isNullable: false,
          },
        ],
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('appointments');
  }
}
```

<!-- anki -->
Why migrations? - To assure the database is equal to every developer.

**IMPORTANT!!!**: You can only change a migration **BEFORE** commiting it to your version control system (git). Otherwise, create a new migration changing the table(s) the you way you need.

**Note**: If wanted, disable the eslint's `class-method-use-this` rule:

`.eslintrc.json`:
```json
{
  // ...
  "rules": {
    "clas-methods-use-this": "off",
    // ...
  }
  // ...
}
```
