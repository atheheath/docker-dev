##Docker Development Environment

This Repo is meant to serve as the terminal you open when you want to try new stuff so that you don't mess up anything going on in your base machine environment and end up uninstalling all of python on your machine and then having to reinstall your OS or something silly like that.

To build the container, run
```
docker build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" --tag docker-dev .
```

To run the jupyter notebook, run
```
docker run -p 8888:8888 docker-dev
```

To just open up a terminal real quick without needing a port,
```
docker run -it docker-dev bash
```

To give the container access to the host's IP and reference it as `outside` instead of `localhost`, run
```
HOST_IP=`ip -4 addr show scope global dev docker0 | grep inet | awk '{print \$2}' | cut -d / -f 1`
docker run --add-host outside:$HOST_IP -it docker-dev bash
```
