#Sass4f v0.0.0
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v0.0.0](http://img.shields.io/badge/pod-v0.0.0-yellow.svg)](http://www.fantomfactory.org/pods/afSass4f)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

*Sass4f is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Sass4f is a wrapper around [LibSass 3.2.5](http://sass-lang.com/libsass) - LibSass 3.2.5 - the compiler for Sass and Scss files.

Sass4f is a simple command line utility program for compiling `.scss` files into `.css` files. It was created for compiling [Twitter Bootstrap v4](http://getbootstrap.com/) templates and has been successfully tested with Bootstrap v4 alpha-2.

Sass4f is a happy alternative to installing Sass, Node.js, Grunt, and half the internet just to compile a couple of text files!

Quickstart example:

    C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css

## Install

Install `Sass4f` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://pods.fantomfactory.org/fanr/ afSass4f

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afSass4f 0.0"]

## Documentation

Full API & fandocs are available on the [Fantom Pod Repository](http://pods.fantomfactory.org/pods/afSass4f/).

## Quick Start

Once installed, run `Sass4f` from the command line:

    C:\> fan afSass4j [-x] [-m] <sassIn> <cssOut>

Where `sassIn` and `cssOut` are files. OS dependent and / or URI notation may be used. Example:

    C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css
    
    C:\> fan afSass4j -x file:/C:/projects/website.scss file:/C:/projects/website.css

`-x` compresses the CSS output and `-m` generates a source map.

## Platforms

Sass4f is bundled with pre-compiled native binaries for the following platforms:

- `linux-x86`
- `linux-x86_64`
- `macosx-x86_64`
- `win32-x86`
- `win32-x86_64`

When Sass4f is first run, the appropiate binary is copied to `%FAN_HOME%/bin/` so it may be loaded by Java.

## Dependencies

Sass4f is designed to be used a standalone application and as such, comes bundled with the following jars:

- `jna-4.2.1.jar`
- `jna-platform-4.2.1.jar`
- `jnaerator-runtime-0.11.jar`

## Acknowledgements

Sass4f uses [JNAerator](https://github.com/nativelibs4java/JNAerator) to communicate with [LibSass](http://sass-lang.com/libsass). It's an idea taken from [sass-java](https://github.com/cathive/sass-java). In fact, both the native LibSass bineries and the JNAerated Java source file have been nabbed from sass-java.

To re-build, follow these commands (confirmed to work with Maven 3.3.1):

```
> git clone https://github.com/cathive/sass-java.git
> cd sass-java
> git checkout v4.0.0
> mvn clean generate-resources
```

`SassLibrary.java` may then be found in `/sass-java/target/generated-sources/jnaerator/`.

The pre-compiled native libsass binaries may be found in `/sass-java/src/main/resources/`. When copying them to `/res/`, ensure the directories are renamed appropiately to Fantom / OSGI standards.

