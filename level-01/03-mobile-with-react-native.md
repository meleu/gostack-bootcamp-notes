# Mobile With Reach Native

## Concepts

What is React Native? A React version for mobile development.

Advantage: multiplatform (Android and iOS)

Architechture: JS -> Metro Bundler (packager) -> bundle -> bridge (connect js and native) -> Android or iOS

## Syntax

The use of components is identical to ReactJS, but we don't use html tags (no `div`, `span`, `p`, etc...).

Styles are aplied without classes or IDs.

There's no `h1`, `h2`, `p`, etc. There's only `Text` and it must be stylized.

Similarities:

- `div`: `View` 
- `button`: `TouchableOpacity`
- `p`, `h1`, etc.: `Text`

Styles are similar to the CSS, but with camelCase rather than hyphens, like this:

```js
const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
  },

  button: {
    backgroundColor: '#7159c1',
  },

  text: {
    fontWeight: 'bold',
  },
});
```

(thanks to yoga)


## Expo

SDK with a lot of ready to use functionalities (camera, video, integrations, etc.)

There's no need to install an emulator (with an app you can run the app in your device).

Why we won't use Expo in this bootcamp?

- limitations over controlling the native code.
- manu used libvraries do not support Expo.
- **Cool!**: Expo released their tools to be used outside from Expo.

