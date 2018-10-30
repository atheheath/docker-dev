## Docker Development Environment
This Repo is meant to serve as the terminal you open when you want to try new stuff so that you don't mess up anything going on in your base machine environment and end up uninstalling all of python on your machine and then having to reinstall your OS.

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
