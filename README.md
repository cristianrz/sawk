# soup - wrapper around gawk

## Dependencies

* `gawk`

## Installing

```shell
$ cat src/main.sh > "$HOME/bin/soup"
$ chmod +x "$HOME/bin/soup"
```

## Usage

Let's create a couple (bad) awk script:

```awk
# hello.awk
BEGIN {
  print "Hello, "
}
```

```awk
# world.awk
@include "hello.awk"
BEGIN {
  a = "world!"

  print b
}
```

Now let's check for errors:

```terminal
$ soup run world.awk
Hello, 
gawk: world.awk:6: fatal: reference to uninitialized variable `b'
```

Let's now fix it:

```awk
# world.awk

@include "hello.awk"
BEGIN {
  b = "world!"

  print b
}
```

and try again:

```terminal
$ soup run world.awk
Hello,
world!
```

Now we are ready build our portable script:

```terminal
$ soup build world.awk > hello-world
```

and our POSIX script is ready to run on systems without gawk:

```terminal
$ chmod +x hello-world
$ ./hello-world
Hello,
world!
```


