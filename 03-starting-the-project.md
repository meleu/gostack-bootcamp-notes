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





> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE1MzI2OTc0MzAsOTQyMzk0MDMyXX0=
-->