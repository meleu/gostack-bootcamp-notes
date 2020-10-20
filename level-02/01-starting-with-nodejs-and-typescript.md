# Starting With NodeJS and TypeScript

## Project Structure

```
mkdir projeto
yarn init -y
yarn add express
yarn add typescript @types/express ts-node-dev -D
yarn tsc --init # generates the tsconfig.json
mkdir src
```

`tsconfig.json`:
```json
{
  //...
  "outDir": "./dist",
  "rootDir": "./src",
  //...
}
```

`package.json`:
```json
{
  //...
  "scripts": {
    "build": "tsc",
    "dev:server": "ts-node-dev --transpile-only --ignore-watch node_modules src/server.ts"
  },
  //...
}
```

## EditorConfig, ESLint and Prettier

### EditorConfig

- Install `EditorConfig for VS Code` plugin
- right-click on the file structure and choose `Generate .editorconfig`
- put this content in the `.editorconfig` file:
```
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
end_of_line = lf
```

### ESLint

- Install `ESLint` plugin
- Press Ctrl+Shift+P and `open settings (json)`, and then add:
```json
"editor.codeActionsOnSave": {
  "source.fixAll.eslint": true
}
```

#### Node

For node, let's use the 6.8.0 version, as the new ones have some inconveniences.

[TODO: what are the inconveniences in the new version of eslint?]

```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. None of these
# 4. (use TypeScript?) Yes
# 5. (mark only Node with space bar and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No
# copy the packages shown on the question 9 above and then...
yarn add @typescript-eslint/eslint-plugin@latest eslint-config-airbnb-base@latest eslint-plugin-import@^2.21.2 @typescript-eslint/parser@latest -D
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslingignore` file:
```
/*.js
node_modules
dist
```

Edit `eslintrc.json`:
```json
{
  // ...
  "extends": [
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "rules": {
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

#### ReactJS

Assuming the project was created with `create-react-app`.

In the `package.json` **REMOVE** this part:
```json
"eslintConfig": {
  "extends": "react-app"
},
```

Install eslint 6.8.0 and initialize it:
```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. React
# 4. (use TypeScript?) Yes
# 5. (mark only Browser with space bar and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No

# copy the packages shown on the question 9 except 'eslint@^5.16.0 || ^6.8.0'
# because we already have it, and remove 1.7.0 from
# 'eslint-plugin-react-hooks@^2.5.0 || ^1.7.0'. The command will become like this:
yarn add eslint-plugin-react@^7.19.0 @typescript-eslint/eslint-plugin@latest eslint-config-airbnb@latest eslint-plugin-import@^2.20.1 eslint-plugin-jsx-a11y@^6.2.3 eslint-plugin-react-hooks@^2.5.0 @typescript-eslint/parser@latest -D

# making ReactJS undertand TypeScrpt
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslingignore` file:
```
**/*.js
node_modules
build
/src/react-app-env.d.ts
```

Edit `eslintrc.json`:
```json
{
  // ...
  "extends": [
    "plugin:react/recommended"
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "plugins": [
    // ...
    "react-hooks",
    "@typescript-eslint"
  ],
  "rules": {
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
    "import/prefer-default-export": "off",
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never",
        "tsx": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

**Note**: if you're facing a warning like `'React' was used before it was defined`, add this to the `.eslintrc.json`:
```json
"rules": {
  // ...
  "no-use-before-define": "off",
  // ...
},
```

Restart VS Code.

#### React Native

Install eslint 6.8.0 and initialize it:
```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. React
# 4. (use TypeScript?) Yes
# 5. (unmark every option and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No

# copy the packages shown on the question 9 except 'eslint@^5.16.0 || ^6.8.0'
# because we already have it, and remove 1.7.0 from
# 'eslint-plugin-react-hooks@^2.5.0 || ^1.7.0'. The command will become like this:
yarn add eslint-plugin-react@^7.19.0 @typescript-eslint/eslint-plugin@latest eslint-config-airbnb@latest eslint-plugin-import@^2.20.1 eslint-plugin-jsx-a11y@^6.2.3 eslint-plugin-react-hooks@^2.5.0 @typescript-eslint/parser@latest -D

# making ReactJS undertand TypeScrpt
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslingignore` file:
```
**/*.js
node_modules
build
```

Edit `eslintrc.json`:
```json
{
  // ...
  "extends": [
    "plugin:react/recommended"
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "globals": {
    // ...
    "__DEV__": "readonly"
  },
  "plugins": [
    // ...
    "react-hooks",
    "@typescript-eslint"
  ],
  "rules": {
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
    "react/jsx-filename-extension": [1, { "extensions": [".tsx"] }],
    "import/prefer-default-export": "off",
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never",
        "tsx": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

**Note**: if you're facing a warning like `'React' was used before it was defined`, add this to the `.eslintrc.json`:
```json
"rules": {
  // ...
  "no-use-before-define": "off",
  // ...
},
```

Restart VS Code.


### Prettier

It's the same for NodeJS, ReactJS and React Native.

```
yarn add prettier eslint-config-prettier eslint-plugin-prettier -D
```

Edit the `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    "prettier/@typescript-eslint",
    "plugin:prettier/recommended",
  ],
  // ...
  "plugins": [
  // ...
  "prettier"
  ],
  "rules": {
    // ...
    "prettier/prettier": "error"
  },
  // ...
}
```

#### Solving conflicts between ESLint and Prettier.

`prettier.config.js`
```js
module.exports = {
  singleQuote: true, 
  trailingComma: 'all',
	arrowParens: 'avoid',
}
```

`.eslintignore`:
```
# ...
/*.js
```

