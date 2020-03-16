# First ReactJS Project

## Starting From Scratch

```
yarn create react-app modulo05
```

In `package.json` delete the `eslintConfig` property.

Removing PWA stuff in `public`:

- `manifest.json`.
- In `index.html`, remove the line:
```html
<link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
```

Removing other files from `src` that we're going to create from scratch:

- `serviceWorker.js`
- `App.css`
- `App.test.js`
- `index.css`
- `logo.svg`

In `src/index.js`, delete the lines importing the `.css` and `servicWorker`, also the `serviceWorker.unregister()`.

In `src/App.js`, delete the lines importing the logo and the `.css`. Also delete everything between `<header>...</header>`. Put a `<h1>Hello World</h1>` as a placeholder.


## ESLint, Prettier and EditorConfig

`.editorconfig`:
```
root = true

[*]
end_of_line = lf
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

```
yarn add eslint prettier eslint-config-prettier eslint-plugin-prettier babel-eslint -D
yarn eslint --init
```

During the init, choose:

- check syntax, find problems and enforce code style
- JavaScript modules (import/export)
- Framework: React
- Browser
- Use a popular style guide
- Airbnb
- config file to be in JavaScript
- Downgrade yes
- accept installation with npm

Delete the `package-lock.json` and run `yarn`.

In the `.eslintrc.js`
```js
//...
extends: [
  'airbnb',
  'prettier',
  'prettier/react'
],
//...
parser: 'babel-eslint',
// parserOptions ...
plugins: [
  'react',
  'prettier'
],
rules: {
  'prettier/prettier': 'error',
  'react/jsx-filename-extension': [
    'warn',
    { etensions: ['.jsx', '.js'] }
  ],
  'import/prefer-default-export': 'off'
}
```

Create `.prettierrc`:
```json
{
  "singleQuote": true,
  "trailingComma": "es5"
}
```

## Routing

```
yarn add react-router-dom
```

Create `src/pages/Main/index.js`:
```js
import React from 'react';

function Main() {
  return <h1>Main</h1>
}

export default Main;
```

Create `src/pages/Repository/index.js`:
```js
import React from 'react';

function Repository() {
  return <h1>Repository</h1>
}

export default Repository;
```

Create `src/routes.js`:
```js
import React from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';

import Main from './pages/Main';
import Repository from './pages/Repository';

export default function Routes() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/" exact component={Main} />
        <Route path="/repository" component={Repository} />
      </Switch>
    </BrowserRouter>
  );
}
```

Now import and use it in `src/App.js`:
```js
import React from 'react';
import Routes from './routes';

function Repository() {
  return <Routes />;
}

export default Repository;
```

Test those routes with
```
yarn start
```

## Styled Components

```
yarn add styled-components
```


