<h1 align="center">

<img src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/BashBits-Social-800x400-X.png" alt="Bash Bits Modular Bash Library" />
<br />
<img src="https://raw.githubusercontent.com/bash-bits/.github/master/.github/media/bash_logo-128x128.png" alt="Bourne Again Shell" />

</h1>

<h1 align="center"><a href="https://github.com/bash-bits/bb-import/wiki">BB-Functions Documentation v-1.0.0</a></h1>

<h3 align="center">In-Repository Documentation for the<br /><br />`Bash-Bits Functions Module`<br /><br /><em>The Hardest-Working Module in the Stack!</em></h3>

<h2><a name="toc">📖 Table of Contents</a></h2>

- [API](api.md)



### [📂 Importing / Installing BB-Functions](README.md)

Like all of `Bash-Bits`, the easiest way to install `BB-Functions` is using `BB-Import`!

However, because BB-Functions itself is made up of a collection of smaller files, BB-Import works a little differently here.

If you use an `Implicit Import` to import BB-Functions, then BB-Import will cache every `type` file used by BB-Functions as well: 

```shell
#!/usr/bin/env bash

bb::import bb-functions
```

If you use what looks like a Namespaced Import (but is actually a special kind of Implicit Import) to import BB-Functions, then BB-Import will import ONLY the type file that you've specified with the import command for now.

```shell
#!/usr/bin/env bash

bb::import bb-functions/array
```

If you don't want to import any more type files than you need for the moment, that's fine - BB-Import will gradually import the remaining files over the next few hours.