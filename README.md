# Industrialisation-of-applications-build-in-embedded-environement

This repository contain a solution to build application in embeddedenvironement

You need docker
Follows : <https://docs.docker.com/engine/installation/>

## install configuration

In Industrialisation-of-applications-build-in-embedded-environement directory run

```bash
./scripts/init.sh 
```
## Current use

Insatll sdk as it tel on the prompt after configuration (there was three diferente sdk in the demonstration example)

```shell
xds-cli sdks install sdk_id
```

then go to jenkins UI

```shell
xdg-open http://localhost:8080
```
click on Blue ocean 
then launch the job!

