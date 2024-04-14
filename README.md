# unhide
small command to open hidden file right there

# install

```terminal
$ cd unhide
$ ./install.sh  -d /usr/local/bin
```

# usage

```
unhide <file> ...
```

# example

```terminal
$ touch .a_file

$ ls
.a_file

$ unhide .a_file

$ ls
a_file
```
