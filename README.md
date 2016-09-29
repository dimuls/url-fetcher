# How to use?

1) Install [carton](http://search.cpan.org/~miyagawa/Carton-v1.0.28/lib/Carton.pm):
```
$ sudo apt install carton
```

2) Install dependencies:
```
$ carton install
```

3) Run script with test URLs:
```
$ cat test-urls | carton exec perl urls-fetcher.pl
```
