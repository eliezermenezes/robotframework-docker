# Docker Image

See [Docker](https://www.docker.com/) for more documentation.

## Installing Docker

* [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

* [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/)

* [Install Docker Desktop on Windows](https://docs.docker.com/docker-for-windows/install/)

## Building Docker Image

```bash
docker build -t <image-name> <path-to-dockerfile>

# e.g
docker build -t robotframework-image .

# or
docker build -t robotframework-image docker
```

## Running Automated Tests

```bash
docker run --rm --name <container-name> -e ROBOT_THREADS <processes> -v <host-tests-directory>:<docker-tests-directory> -v <host-reports-directory>:<docker-reports-directory> <image-name> <robot-arguments> <robot-tests>

# e.g parallel execution
docker run --rm --name robotframework -e ROBOT_THREADS 4 -v $(pwd):/opt/robotframework/tests -v $(pwd)/reports:/opt/robotframework/reports robotframework-image:latest --tagstatinclude sanity -v browser:firefox -i sanity -d reports home.robot

# e.g sequential execution
docker run --rm --name robotframework -v $(pwd):/opt/robotframework/tests -v $(pwd)/reports:/opt/robotframework/reports robotframework-image:latest --tagstatinclude sanity -v browser:firefox -i sanity -d reports home.robot
```