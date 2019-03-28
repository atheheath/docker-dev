FROM python:3.6

WORKDIR /root

RUN apt-get update && \
    apt-get install -y \
      vim \
      git \ 
      scala \
      nmap \
      postgresql-client

RUN pip install --upgrade pip

COPY requirements.txt ./

RUN pip install -r requirements.txt
RUN rm requirements.txt

# Add python2 jupyter kernel
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python2 get-pip.py && \
    python2 -m pip install ipykernel && \
    python2 -m ipykernel install --user

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD [ "jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''" ]
