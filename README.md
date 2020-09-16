# `rust-cross-images`

This project is developed and maintained by the O.S. Systems team for use in
cross environments for testing and development. The images here are intended
to be used with the [cross][cross] tool.

## Supported targets

A target is considered as “supported” if `cross` can cross compile a
“non-trivial” (binary) crate, usually Cargo, for that target.

`cross` provides default Docker images and this project provide some other
targets when the default images are not enough. You can use the
`target.{{TARGET}}.image` field in `Cross.toml` to use our custom Docker images
for a specific target:

``` toml
[target.{{TARGET}}]
image = "ossystems/rust-cross:{{TAG}}"
```

Refer to the table below for the `TARGET` and `TAG` available combinations:

| Target                           | Image Tag                                        |  libc  |   GCC   | C++ | QEMU  | `test` |
|----------------------------------|--------------------------------------------------|-------:|--------:|:---:|------:|:------:|
| `i686-unknown-linux-gnu`         | `i686-linux-compat-0.2.1`                        | 2.11   | 4.4.5   | ✓   | N/A   |   ✓    |
| `x86_64-unknown-linux-gnu`       | `x86_64-linux-compat-0.2.1`                      | 2.11   | 4.4.5   | ✓   | N/A   |   ✓    |
| `aarch64-unknown-linux-gnu`      | `aarch64-unknown-linux-gnu-libarchive-0.2.1`     | 2.23   | 5.3.1   | ✓   | 4.2.0 |   ✓    |
| `armv7-unknown-linux-gnueabihf`  | `armv7-unknown-linux-gnueabihf-libarchive-0.2.1` | 2.23   | 5.3.1   | ✓   | 4.2.0 |   ✓    |

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or
  http://www.apache.org/licenses/LICENSE-2.0)
- MIT License ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.

[cross]: https://github.com/rust-embedded/cross
