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
Pay attention that many of the containers can be already closed (exited). You can run multiple containers starting from the same image, and their status would be independent.

To remove a container use:
```Bash
docker rm CONTAINER-ID
```

You can save the state of a container by making an image from it:
To remove a container use:
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
