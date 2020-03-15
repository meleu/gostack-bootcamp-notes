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
  entry: path.resolve(__dirname, 'src', 'index.js'),
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

Create the `public/bundle.js` automatically by running:
```
yarn build
```

Launch the application and check it on your browser by running:
```
yarn dev
```


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

render(<App />, document.getElementById('app'));
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

Call it in the `src/App.js`:
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

## Class Components

```
yarn add @babel/plugin-proposal-class-properties -D
```

Add `plugins` property to the `babel.config.js`:
```js
  plugins: [
    '@babel/plugin-proposal-class-properties'
  ]
```

### Basic Component

Create the class `src/components/TechList.js`:
```js
import React, { Component } from 'react';

class TechList extends Component {
  state = {
    techs: [
      'Node.js',
      'ReactJS',
      'React Native'
    ]
  };

  render() {
    return (
      <ul>
        {this.state.techs.map(tech => <li key={tech}>{tech}</li>)}
      </ul>
    )
  }
```

Change the `src/App.js`:
```js
import React from 'react';
import './App.css';

import TechList from './components/TechList';

function App() {
  return <TechList />
}

export default App;
```


### State and Immutability

Components properties are immutable. So, in order to change `state`'s content, it's mandatory to use `this.setState()` method.

Update the `src/components/TechList.js`:
```js
import React, { Component } from 'react';

class TechList extends Component {
  state = {
    newTech: '',
    techs: [
      'Node.js',
      'ReactJS',
      'React Native'
    ]
  };

  handleInputChange = e => {
    this.setState({ newTech: e.target.value });
  }

  handleSubmit = e => {
    e.preventDefault(); // avoiding page reload

    this.setState({
      techs: [... this.state.techs, this.state.newTech],
      newTech: ''
    });
  }

  handleDelete = tech => {
    this.setState({ techs: this.state.techs.filter(t => t !== tech) });
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <ul>
          {this.state.techs.map(tech => (
            <li key={tech}>
              {tech}
              <button onClick={() => this.handleDelete(tech)} type="button">
                Remover
              </button>
            </li>
          ))}
        </ul>
        <input
          type='text'
          onChange={this.handleInputChange}
          value={this.state.newTech}
        />
        <button type="submit">Enviar</button>
      </form>
    )
  }
}

export default TechList;
```

**Note**: the `handle*` functions needs to be declared as "arrow-functions" in order to have access to `this`.

**Note 2**: the function in `onClick={}` must be an anonymous function calling the method, otherwise the method will be called when the page is loaded (resulting in deleting all items).


## React Properties

Separating the `<li>` items from `TechList.js`.

First, create `src/components/TechItem.js`:
```js
import React from 'react';

function TechItem({ tech, onDelete }) {
  return (
    <li>
      {tech}
      <button onClick={onDelete} type="button">Remover</button>
    </li>
  );
}

export default TechItem;
```

And change the `<ul>` part of `src/components/TechList.js`:
```js
// ...
import TechItem from './TechItem';

// ...
        <ul>
          {this.state.techs.map(tech => (
            <TechItem
              key={tech}
              tech={tech}
              onDelete={() => this.handleDelete(tech)}
            />
          ))}
        </ul>
// ...
```

**Note**: passing the `key` is mandatory, and it can't have repeated values.

