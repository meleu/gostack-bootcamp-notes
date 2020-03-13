# Introduction to React

## Configuring the structure

```
mkdir dirname
cd dirname
yarn init
yarn add @babel/core @babel/preset-env @babel/preset-react babel-loader webpack webpack-cli webpack-dev-server -D
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
  "build": "webpack --mode production"
  "dev": "webpack-dev-server --mode development"
},
```
**Note**: `--mode production` creates a minified version of `bundle.js`.

Launch your application with either
```
yarn dev # or...
yarn build
```

And then Check it on your browser.

