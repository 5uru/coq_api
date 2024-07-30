FROM coqorg/coq

WORKDIR /code

USER root
RUN apt-get update && \
    apt-get install -y sudo opam strace python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists/* && \
    echo "coq ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coq

RUN python3 -m venv /home/coq/venv && \
    . /home/coq/venv/bin/activate && \
    pip install uv

# Copy requirements file
COPY ./requirements.txt /code/requirements.txt
COPY ./main.py /code/main.py

# Install Python dependencies
RUN . /home/coq/venv/bin/activate && \
    uv pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Set the entrypoint to use the virtual environment
ENTRYPOINT ["/bin/bash", "-c", "source /home/coq/venv/bin/activate && exec \"$@\"", "--"]

CMD ["python", "main.py"]
