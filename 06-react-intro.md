# Introduction to React

## Creating your first root component

```
mkdir dirname
cd dirname
yarn init
yarn add @babel/core @babel/preset-env @babel/preset-react \
  babel-loader webpack webpack-cli webpack-dev-server -D
yarn add react react-dom
```

Create `babel.config.js`:
```js
module.exports = {
  presets: [
    "@babel/preset-env",
    "@babel/preset-react"
  ],
};
```

Create `webpack.config.js`:
```js
const path = require('path');

module.exports = {
  entry: path.resolve(__dirname, 'src', 'index.js');
  output: {
    path: path.resolve(__dirname, 'public'),
    filename: 'bundle.js'
  },
  devServer: {
    contentBase: path.resolve(__dirname, 'public'),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      }
    ]
  }
};
```

Create the `public/bundle.js` automatically by running:
```
yarn build
```

Create `public/index.html` (take advantage of the Emmet to create a html:5 snippet):
```html
<body>
  <h1>Hello World</h1>
  <script src="./bundle.js"></script>
</body>
```

Add to the `package.json`:
```json
"scripts": {
  "build": "webpack --mode production",
  "dev": "webpack-dev-server --mode development"
},
```
**Note**: `--mode production` creates a minified version of `bundle.js`.

Launch your application with either
```
yarn dev # or...
yarn build
```

And then check it on your browser.


Change the `public/index.html`, replacing the `<h1>` line with:
```html
<div id="app"></div>
```

Create the `src/App.js`:
```js
import React from 'react';

function App() {
  return <h1>Hello meleu</h1>
}

export default App;
```
**Question:** Why did you imported `react` if you not even using it?

**Answer:** Because it's needed in order to allow a syntax like `return <h1>Hello meleu</h1>`.


Create the `src/index.js`:
```js
import React from 'react';
import { render } from 'react-dom';

import App from './App';

render(<App />, document.getElementById('app');
```

## Importing assets

### Importing CSS

```
yarn add style-loader css-loader -D
```

Edit the `webpack.config.js` adding this rule:
```js
{
  test: /\.css$/,
  use: [
    { loader: 'style-loader' },
    { loader: 'css-loader' },
  ]
}
```

Create the `src/App.css`:
```css
body {
  background: #7159c1;
  color: #FFF;
  font-family: Arial, Helvetica, sans-serif;
}
```

Just add this line in `src/App.js`:
```js
import './App.css';
```

And then test it with:
```
yarn dev
```

### Importing Images

```
yarn add file-loader -D
```

Add a new rule to `webpack.config.js`:
```js
{
  test: /.*\.(gif|png|jpe?g)$/i,
  use: {
    loader: 'file-loader'
  }
}
```

Put an image file in `src/assets/`.

Test it in the `src/App.js`:
```js
import profile from './assets/file.png';

function App() {
  return <img src={profile} />
}
```

Note: in order to use a variable inside the html code, use the {curly brackets}.

And then test it with:
```
yarn dev
```

