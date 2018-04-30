Common Lisp projects generator
==============================
This is a simple command-line tool to generate Common Lisp projects. Its just a few lines wrapper around [fukamachi's cl-project](https://github.com/fukamachi/cl-project)

Works with SBCL.

Usage:
- Create a *skeleton* directory somewhere having your files. Use [original skeleton](https://github.com/fukamachi/cl-project/tree/master/skeleton) as an example.
- Edit *Makefile* and *lw-project.lisp* to match your paths.
In my case all my CL projects resides in **~/Sources/lisp**
and quicklisp distribution in default location **~/quicklisp.**, and skeleton is in **~/Sources/lisp/skeleton**.

- Run make

The command-line tool *cl-project* will be created.
Usage of this tool:

./cl-project project-name

will create the directory **~/Sources/lisp/project-name** based on skeleton from ~/Sources/lisp/skeleton.
