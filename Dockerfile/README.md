# build rust

```
$ cd rust
$ docker build -t rust-dev .
```

# use rust image

```
docker run -it --rm \
  --name rust-dev-container \
  -v "$PWD":/workspace \
  rust-dev
```
