# Sass4f v0.1.0
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](https://fantom-lang.org/)
[![pod: v0.1.0](http://img.shields.io/badge/pod-v0.1.0-yellow.svg)](http://eggbox.fantomfactory.org/pods/afSass4f)
![Licence: The MIT Licence](http://img.shields.io/badge/licence-The%20MIT%20Licence-blue.svg)

## Overview

*Sass4f is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Sass4f is a wrapper around [jsass/5.10.3](https://github.com/bit3/jsass) and [libsass/3.6.3](https://sass-lang.com/libsass) - the compiler for Sass and Scss files.

Sass4f is a simple command line utility program for compiling `.scss` files into `.css` files. It was created for compiling [Twitter Bootstrap](http://getbootstrap.com/) templates and has been successfully tested with Bootstrap v4.4.1.

Sass4f is a happy alternative to installing Sass, Node.js, Grunt, and half the Internet just to compile a couple of text files!

Quick start example:

    C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css

## <a name="Install"></a>Install

Install `Sass4f` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afSass4f

Or install `Sass4f` with [fanr](https://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afSass4f

To use in a [Fantom](https://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afSass4f 0.1"]

## <a name="documentation"></a>Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afSass4f/) - the Fantom Pod Repository.

## Quick Start

Once installed, run `Sass4f` from the command line:

    C:\> fan afSass4j [-x] [-m] <sassIn> <cssOut>

Where `sassIn` and `cssOut` are files. OS dependent and / or URI notation may be used. Example:

    C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css
    
    C:\> fan afSass4j -x file:/C:/projects/website.scss file:/C:/projects/website.css

`-x` compresses the CSS output, `-m` generates a source map, and `-w` continuously watches for file updates.

Note that `cssOut` may also be a directory, for example:

    C:\> fan afSass4j -x -m -w scss\website.scss css\

will generate `css\website.css` and re-compile it should any file in the `scss/` directory be updated.

## Platforms

Sass4f is bundled with pre-compiled native binaries for the following platforms:

* `linux-x86`
* `linux-x86_64`
* `macosx-x86_64`
* `win32-x86`
* `win32-x86_64`


## Dependencies

Sass4f is designed to be used a standalone application and as such, comes bundled with the following jars:

* `commons-io-2.6.jar`
* `commons-lang3-3.9.jar`
* `commons-text-1.8.jar`
* `jsass-5.10.3.jar`
* `mjson-1.4.1.jar`
* `slf4j-api-1.7.28.jar`


