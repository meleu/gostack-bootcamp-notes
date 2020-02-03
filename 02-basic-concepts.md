# Basic Concepts

Using [nvm](https://github.com/nvm-sh/nvm) is better than install node from your distro's official package (avoid problems with different versions of node).

Use `yarn` instead of `npm` (that comes with node by default) to manage JS packages/dependencies. (**note**: I still didn't find why `yarn` is considered a better option, but let's keep going...)

Node.js features:

- event-loop architecture:
    - event based (in a web context it means *routes*)
    - call stack (a LIFO)
- single thread
    - behind the scenes, C++ and libuv allows multithread
    - background threads
- non blocking I/O

## frameworks

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwNTQ1Njc0MTZdfQ==
-->