#Sass4f v0.0.2
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom-lang.org/)
[![pod: v0.0.2](http://img.shields.io/badge/pod-v0.0.2-yellow.svg)](http://www.fantomfactory.org/pods/afSass4f)
![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)

## Overview

*Sass4f is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Sass4f is a wrapper around [libSass 3.2.5](http://sass-lang.com/libsass) - libSass 3.2.5 - the compiler for Sass and Scss files.

Sass4f is a simple command line utility program for compiling `.scss` files into `.css` files. It was created for compiling [Twitter Bootstrap 4](http://getbootstrap.com/) templates and has been successfully tested with Bootstrap v4.0.0-alpha.2.

Sass4f is a happy alternative to installing Sass, Node.js, Grunt, and half the Internet just to compile a couple of text files!

Quick start example:

    C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css

## Install

Install `Sass4f` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afSass4f

Or install `Sass4f` with [fanr](http://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afSass4f

To use in a [Fantom](http://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afSass4f 0.0"]

## Documentation

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

**TODO:** Add more cmd line options for source map generation. See API docs.

## Platforms

Sass4f is bundled with pre-compiled native binaries for the following platforms:

- `linux-x86`
- `linux-x86_64`
- `macosx-x86_64`
- `win32-x86`
- `win32-x86_64`

When Sass4f is first run, the appropriate binary is copied to `%FAN_HOME%/bin/` so it may be loaded by Java.

## Dependencies

Sass4f is designed to be used a standalone application and as such, comes bundled with the following jars:

- `jna-4.2.1.jar`
- `jna-platform-4.2.1.jar`
- `jnaerator-runtime-0.11.jar`

## Acknowledgements

Sass4f uses [JNAerator](https://github.com/nativelibs4java/JNAerator) to communicate with [libSass](http://sass-lang.com/libsass) - an idea taken from [sass-java](https://github.com/cathive/sass-java).

