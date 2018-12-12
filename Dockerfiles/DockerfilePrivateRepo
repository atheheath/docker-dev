# this is our first build stage, it will not persist in the final image
# we will use this to install requirements that require ssh access touch
# private repos

FROM python:3.6 AS intermediate

# create and change working directory
WORKDIR /home

# Add credentials on build
# remember to use a temporary variable for this
ARG SSH_PRIVATE_KEY

RUN mkdir /root/.ssh/

# This private key shouldn't be saved in env files
RUN echo "${SSH_PRIVATE_KEY}" >> /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

COPY ./requirements_private_repos.txt /home/


RUN pip install -r requirements_private_repos.txt

FROM python:3.6


WORKDIR /root

COPY requirements.txt ./

# Copy the python packages from the intermediate image.
# We put the site packages in tmp so that when we merge the two
# site-packages, we can copy them over without overwriting (the -n option).
# This is where we would resolve any conflicting python dependencies
# between the two containers
RUN mkdir /tmp/site-packages
COPY --from=intermediate /usr/local/lib/python3.6/site-packages/ /tmp/site-packages/
RUN cp -r -n /tmp/site-packages/* /usr/local/lib/python3.6/site-packages

RUN apt-get update && \
    apt-get install -y \
      vim \
      git

RUN pip install --upgrade pip

COPY requirements.txt ./

RUN pip install -r requirements.txt
RUN rm requirements.txt

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD [ "jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''" ]
