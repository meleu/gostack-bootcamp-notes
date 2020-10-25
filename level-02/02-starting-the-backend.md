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


