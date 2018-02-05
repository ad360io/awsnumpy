# AWS NumPy

Automated build scripts to build NumPy with the linear algebra libraries in `/var/task/lib` using an AmazonLinux Docker instance, for any valid Python runtime.

## Use

In a Bash shell with Docker in the path, run:

```bash
./build
```

To use a different runtime than Python3.6, pass the `--runtime=XY` flag to `./build`, where `X` is the Python major version and `Y` is the Python minor version (for example, `--runtime=27`). This will create a `dist` folder, containing the built NumPy library and all the runtime dependencies. Simply copy the contents of the "dist" directory into your AWS project directory to integrate NumPy into a project.

## Dependencies

- docker (>= 1.9)
- getopt
- basename
- readlink

The user running the script **must** be run as root. If you are running SELinux, to test the NumPy install, you must temporarily disable SELinux (`sudo setenforce 0`).

## License

The built libraries are not covered by this license, and are subject to their originally licensing restrictions. The build scripts used to generate an AWS-compatible NumPy are distributed under an [Apache v2 license](/LICENSE).
