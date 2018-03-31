# Docker Quick-start Cheatsheet
This is a quick-start guide, more like a cheatsheet for Docker containers.

### Basic concepts
Container is like a virtual machine, which uses the Linux kernel of the host machine. Each container has its own independent Linux environment and namespace, but all of the containers running on a server share the same kernel. Docker is a tool for making and managing containers, just like VirtualBox is a tool for managing virtual machines.

### Benefits of containers
Containers provide several benefits:
1. Resource efficiency: Severs can run multiple independent Linux environments without the memory/energy/storage overhead from the operating systems of the virtual machines.
2. Maintenance: instead of writing lengthy, always outdated, instructions for installing and setting up libraries, tools, and dependencies of a project, everything can be contained in a `Dockerfile` that explains how the container image is formed, and everyone can use it to start the project development and deployment.
3. Development: Software developers, data scientists, designers, etc. can experiment with Linux environments that are identical to the deployment environment without time-consuming setup procedures for test servers.

### Getting started
Install Docker from docker.com and start Docker in terminal (If you are on mac, there is an app named "Docker Quickstart Terminal" in your Launchpad, which starts a Linux virtual machine and Docker inside it). To get help use
```Bash
docker --help
```
A Docker image is a snapshot of a container. An image does NOT save how the container is formed; it just saves the container in its last state. To get a list of Docker images on your machine run:
```Bash
docker images
```
To get help for a specific Docker command, e.g. `docker images`, use:
```Bash
docker images --help
```

### Basic commands
To get a Docker image from Docker Hub e.g. ubuntu image run:
```Bash
docker pull ubuntu
```
To verify if you have received the image, you can run again:
```Bash
docker images
```
Pay attention that this command gives image `REPOSITORY`, `TAG`, and `IMAGE-ID` as well. You can use these in other commands to refer to an image.

To delete an image:
```Bash
docker rmi IMAGE-ID
```

You can run an image by:
```Bash
docker run IMAGE-ID
```
or if you want an interactive terminal to remain open after running the image:
```Bash
docker run -it IMAGE-ID
```
Running an images makes a new container. 

You can get a full list of containers with:
```Bash
docker ps -a
```
Pay attention that many of the containers can be already closed (exited). You can run multiple containers starting from the same image, and their status would be independent of each other.

To restart an exited container use:
```Bash
docker restart CONTAINER-ID
```
and to attach it to the terminal use:
```Bash
docker attach CONTAINER-ID
```
You may have to press enter/return once more to see the result of the attaching.

To remove a container use:
```Bash
docker rm CONTAINER-ID
```

You can save the state of a container by making an image from it:
```Bash
docker commit CONTAINER-ID
```
But this is not the recommended way to save changes and generate and image because this leads to the [golden image problem](http://stackoverflow.com/questions/26110828/should-i-use-dockerfiles-or-image-commits/3#3 "See this explanation on Stack Overflow"), which essentially means you forget how you got the container to that state.

The right way to make the images is to write step by step procedure of forming them in a file named `Dockerfile`, and then building an image from it:
```Bash
docker build .
```
Make sure that you are in the directory of the `Dockerfile`, when running it as above. A sample `Dockerfile` is provided in this repository.

Once you have a Docker image that you want to save it on Docker Hub, make an account there, and back in the terminal login with:
```Bash
docker login
```
If your image is not named and tagged properly, tag it with:
```Bash
docker tag IMAGE-ID DOCKERHUB-USERNAME/IMAGE-NAME:IMAGE-TAG
```
e.g. `docker tag e051d77e98f8 atamahjoubfar/handy-ubuntu:latest`.

Then, send it to Docker Hub by running:
```Bash
docker push DOCKERHUB-USERNAME/IMAGE-NAME:IMAGE-TAG
```
e.g. `docker push atamahjoubfar/handy-ubuntu:latest`.

### Networking
By default, container ports are not exposed to the host machine. They can be used by processes inside the container, but not from outside of the container. If you want to expose a port, you should specify the ports that you want to be forwarded from the host machine. This can be done by running the `docker run` command with extra options about port forwarding:
```Bash
docker run -p HOST-PORTS:CONTAINER-PORTS IMAGE-ID
```
For example:
```Bash
docker run -p 4999-5003:4999-5003 -it 2592718a33b0
```
In addition, in Mac OS, you should forward the port from the host machine to the virtual Linux machine that docker is running on. The easy way to set this is to use the VirtualBox GUI for setting as shown in the image below:

![A snapshot image of VirtualBox port forwarding](VirtualBox%20port%20forwarding.png "VirtualBox port forwarding")

Also, note that in principle, one should be able to expose a port by `EXPOSE` instruction in `Dockerfile` and `docker run -P`, but I was not able to get it work on Mac. 

### Data volumes
Data volumes are used to preserve and share data between containers. You can get a full list of volumes by:
```Bash
docker volume list
```
and delete a volume by:
```Bash
docker volume rm VOLUME-NAME
```

I didn't find a direct way to check the contents of a volume, but I managed to do that by mounting it on a new container e.g.
```Bash
docker run -it --volume=VOLUME-NAME:/mydata/myvolume ubuntu bash
```
and then in the containers bash shell going to the mount directory and listing the files:
```Bash
cd /mydata/myvolume
ls -alh
```

### Services
It is possible to run multiple services in a single docker, but it is not the recommended way. One of the goals of using containers is to separate concerns regarding multiple services. 

To form a single package with multiple services, `docker-compose` should be used. `docker-compose` runs multiple containers linked to each other as a single package. The composition is defined in a file named `docker-compose.yml` and the following command can be used to update build of a package and run it:
```Bash
docker-compose up --build
```
To stop the containers press Control+C. To remove all the containers that are created and their volumes type:
```Bash
docker-compose down -v
```

If one of the images in the `docker-compose.yml` generates its own volume in its `Dockerfile`, you can find the mount destination of that volume in its container by `docker inspect CONTAINER-ID` and mount your own volume there to prevent container from making its own volume.

You can get into the shell of the containers that are running, by connecting to them in another terminal window. Use `docker ps -a` to get the `CONTAINER-ID`, and then run:
```
docker exec -it CONTAINER-ID bash
```
You will be logged in as a root user into the container. If the container doesn't have `bash`, try `sh` instead. Type `exit` to exit the container.

### Clean up

You can delete all of the containers by:
```Bash
docker rm $(docker ps -a -q)
```
Delete all of the images by:
```Bash
docker rmi $(docker images -q)
```
And delete all of the volumes by:
```Bash
docker volume rm $(docker volume list -q)
```
