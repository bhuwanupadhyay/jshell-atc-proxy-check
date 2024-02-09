# JSHELL Wrapper Script

This is a simple wrapper script to run a jshell script with a set of libraries and environment variables.

## Usage

```bash
./jshell-wrapper.sh <libs.properties> <env.sh> <java_script.sh>
```

## Example

The following example runs a jshell script that uses the HttpClient class to make a GET request to a URL. The script uses the `libs.properties` file to load the required libraries and the `env.sh` file to set the environment variable.

```bash
./jshell-wrapper.sh example/libs.properties example/env.sh example/HttpClientSystemProperties.sh
```
