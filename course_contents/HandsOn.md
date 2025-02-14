# Docker Hands-on beginners training

Inspired by Nextflow training: <https://training.nextflow.io/basic_training/containers/>

In this hands on, we assume you already have an environment with docker installed, either locally, or remotely in a place such as github codespaces which we have made ready for you in this occation.

Once the docker daemon is running you can run containers, we will start with the `hello-world` container, which is hosted on Docker Hub.

In your command line, run the publicly available `hello-world` container:

```
docker run hello-world
```

We notice that docker first tried to check if we had the container locally, as we did not, the online container repositories were checked.
As the container was found, it was donwloaded, and run.

Pull the publicly available `debian:bookworm-slim` container and verify it has been downloaded:
```
docker pull debian:bookworm-slim
```

To check which containers you have pulled, you can use `images` with the following syntax:
```
docker images
```


While we would rather reccomend using _virtual environments_ for running speciffic environments interactively, it can be handy to be familiar with dockers ability to run a container in interactive mode.

this is done by adding the two commandline inputs to the `docker run` command `--interactive` and `--tty`  which have the equivalents `-i` and `-t`. 
They can thus be run with the following syntax: `docker run -it <container-name> <command>`

We will launch the BASH shell (`bash`) in the publicly available `debian:bookworm-slim` container:

```
docker run -it debian:bookworm-slim bash
```
and exit the container with `exit`.

Making a docker image to spin it up as a docker container:
Docker images are created from a textfile called `Dockerfile`.
A dockerfile can use an existing image, and build on top of it.

For the most fundamental dockerfile, we will learn the keywords: `FROM`, `LABEL`, `RUN`, and `ENV`

```
FROM debian:bookworm-slim

LABEL image.author.name="Your Name Here"
LABEL image.author.email="your@email.here"

RUN apt-get update && apt-get install -y curl cowsay

ENV PATH=$PATH:/usr/games/
```
_here the cowsay program is stored in games and we must add that directory to our PATH for the terminal to be able to find it._

When you have a dockerfile, you can build it to a docker image with the `build` command using the following syntax:
`docker build --tag <my-image-name:my-optional-image-tag> <my-location-path>` here `--tag` is equivalent to `-t` and local location path can be referenced with `.`

We will now:
* go ahead and make a dockerfile based on debian slim, with both `curl` and `cowsay` added.
* Build your docker file to an image
* run the command `docker run <my-image-name> cowsay 'Hej DTU!'`

`code Dockerfile` opens a new file called Dockerfile in out editor, and we copy the content from above into this file and save it.

we can then do 
```
docker build -t demo1 .
```

```
docker run demo1 cowsay "Hej DTU"
```
Lets make our image for cowsay only by setting an ENTRYPOINT. add the line
```
ENTRYPOINT [ "cowsay" ]
```
and `docker build -t demo1 .` again

now we run without specifying which program to use:
```
docker run demo1 "Hej DTU"
```

Say you have identified a container that you want to run with your scrip, but a key piece of software is missing.
We can modify the container by adding some lines ot code to the Dockerfile which is used to generate the docker image used to spin up the docker container which we will use.

Not all tools needed can be installed with `apt-get` and we may need to download from a particular URL, luckily we know how to make an image with curl installed.

we can add the following lines in the bottom of our dockerfile to download and extract the tool `salmon`

```
RUN curl -sSL https://github.com/COMBINE-lab/salmon/releases/download/v1.5.2/salmon-1.5.2_linux_x86_64.tar.gz | tar xz \
&& mv /salmon-*/bin/* /usr/bin/ \
&& mv /salmon-*/lib/* /usr/lib/
```

We will now:
* Build an image with `salmon` installed. Do this by updating your `Dockerfile` accordingly, and build it with the same command as before.
* Check that you have your new image available


Update the `Dockerfile` to also have the lines from above, remove the line with `ENTRYPOINT`

and then run the command
```
docker build -t demo2 .
```

finally confirm with 
```
docker images
```

if you used the same name and tag you should notice that even if names are the same, images will have different ID.

verifying that salmon is correctly installed can be done with the following command:

```
docker run demo2 salmon --version
```

in case this fails, pleas try this alternative:
```
docker run nextflow/rnaseq-nf salmon --version
```

You can even launch a container in an interactive mode by using the following command:
```
docker run -it my-image bash
```
Use the `exit` command to terminate the interactive session.

We know our images are localy available. We also want to check if our containers are still existing.
this is done by `docker ps -a` 

When we do this we can see that they are still existing. There is no reason for this as these containers are supposed to just do one job based on the docker image.

we can keep our space tidy by adding `--rm` to the run command to make sure the container is wiped after usage.




File system mounts:
Containers run in a completely separate file system and it cannot access the hosting file system by default.

We can use the `--volume <host-directrory>:<container-directory>` syntax to make a file or a folder available inside our container 

Without linking directories like this, we dont have access to outside files, inside the container. I.e. running the following command that is attempting to generate a genome index using the Salmon tool will fail because Salmon cannot access the input file:

```
docker run my-image \
    salmon index -t $PWD/course_content/data/ggal/transcriptome.fa -i transcript-index
```

To mount a filesystem within a Docker container, you can use the `--volume` command-line option when running the container. Its argument consists of two fields separated by a colon (`:`):

Host source directory path
Container target directory path
For example:

```
docker run --volume ./course_contents/data/ggal/transcriptome.fa:/transcriptome.fa <image-name> head /transcriptome.fa
```
to use current folder like this:

```
docker run --volume $PWD:$PWD --workdir $PWD demo2 salmon index -t $PWD/course_contents/data/ggal/transcriptome.fa -i transcript-index
```

To keep everything more tidy, we can set a folder we want to mount as an environmental variable, called `DATA`:

```
DATA=/workspaces/dsp_docker_training/course_contents/data/
docker run --volume $DATA:$DATA --workdir $DATA demo2 salmon index -t $DATA/ggal/transcriptome.fa -i transcript-index
```

You can check the content of the transcript-index folder by entering the command:

```
ls -la /workspaces/dsp_docker_training/course_contents/data/transcript-index
```

Note that the permissions for files created by the Docker execution is root.

We will now make two mounted volumes, a read-only for input, and a writable for output, `-v` is equivalent to `--volume`.
We can also add the entrypoint, and specify input and output parameters to match with what our command in salmon expects:
```
# docker run -v $DATA:$DATA -v  --workdir $DATA demo2 salmon index -t $DATA/ggal/transcriptome.fa -i transcript-index
```





Upload the container in the Docker Hub (optional)
You can also publish your container in the Docker Hub to share it with other people.

Create an account on the https://hub.docker.com website. Then from your shell terminal run the following command, entering the user name and password you specified when registering in the Hub:
```
docker login
```
Rename the image to include your Docker user name account:
```
docker tag my-image <user-name>/my-image
```
Finally push it to the Docker Hub:

```
docker push <user-name>/my-image
```
After that anyone will be able to download it by using the command:

```
docker pull <user-name>/my-image
```
Note how after a pull and push operation, Docker prints the container digest number e.g.
```
Output

Digest: sha256:aeacbd7ea1154f263cda972a96920fb228b2033544c2641476350b9317dab266
Status: Downloaded newer image for nextflow/rnaseq-nf:latest
```
This is a unique and immutable identifier that can be used to reference a container image in a univocally manner. For example:

`docker pull nextflow/rnaseq-nf@sha256:aeacbd7ea1154f263cda972a96920fb228b2033544c2641476350b9317dab266`


