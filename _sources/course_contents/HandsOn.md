# Docker Hands-on beginners training

Inspired by Nextflow training: <https://training.nextflow.io/basic_training/containers/>

In this hands on, we assume you already have an environment with docker installed, either locally, or remotely in a place such as github codespaces which we have made ready for you in this occation.

Once the docker daemon is running you can run containers, we will start with the `hello-world` container, which is hosted on Docker Hub.

In your command line, a docker container can be run with the following syntax: 
```
docker run <container-name>
```

Excercise:

Run the publicly available `hello-world` container.

Solution:

```
docker run hello-world
```



We notice that docker first tried to check if we had the container locally, as we did not, the online container repositories were checked.
As the container was found, it was donwloaded, and run.

We can also break down the step and only download an image without running it. This is done with the `pull` command using the following syntax:
```
docker pull <container-name>
```

To check which containers you have pulled, you can use `images` with the following syntax:
```
docker images
```





Excercise:

Pull the publicly available `debian:bullseye-slim` container and verify it has been downloaded

Solution:

```
docker pull debian:bullseye-slim
docker images
```



While we would rather reccomend using _virtual environments_ for running speciffic environments interactively, it can be handy to be familiar with dockers ability to run a container in interactive mode.

this is done by adding the two commandline inputs to the `docker run` command `--interactive` and `--tty`  which have the equivalents `-i` and `-t`. 
They can thus be run with the following syntax:

```
docker run -it <container-name> <command>
```

Excercise:

launch the BASH shell (`bash`) in the publicly available `debian:bullseye-slim` container.

Solution:

```
docker run -it debian:bullseye-slim bash
```


Making a docker image to spin it up as a docker container:
Docker images are created from a textfile called `Dockerfile`.
A dockerfile can use an existing image, and build on top of it.

For the most fundamental dockerfile, we will learn the keywords: `FROM`, `LABEL`, `RUN`, and `ENV`


Excercise:

what do you think these four keywords indicate in the following `Dockerfile`?
```
FROM debian:bullseye-slim

LABEL image.author.name="Your Name Here"
LABEL image.author.email="your@email.here"

RUN apt-get update && apt-get install -y curl

ENV PATH=$PATH:/usr/games/
```


When you have a dockerfile, you can build it to a docker image with the `build` command using the following syntax:

```
docker build --tag <my-image-name:my-optional-image-tag> <my-location-path>
```
here `--tag` is equivalent to `-t` and local location path can be referenced with `.`

Exercise:
* go ahead and make a dockerfile based on debian slim, with both `curl` and `cowsay` added.
* Build your docker file to an image
* run the command `docker run <my-image-name> cowsay 'Hej DTU!'`






Excercise:
make your own dockerfile inspired by the one above and build it




Say you have identified a container that you want to run with your scrip, but a key piece of software is missing.
We can modify the container by adding some lines ot code to the Dockerfile which is used to generate the docker image used to spin up the docker container which we will use.





