## What is this?

Simple setup of ansible in a docker container to make playbook testing and ansible study simple.

## What is inside?

* _./control-node.dockerfile_ -  An [alpine](https://hub.docker.com/_/alpine) based dockerfile with ansible and python 
installed. Python and ansible versions can be configured with docker _build-args_: _PYTHON_VERSION_ and _ANSIBLE_VERSION_.
Container launched from this dockerfile will serve as a [control node](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#control-node)

*  _./managed-node.dockerfile_ - A dockerfile based on a [openssh-server](https://hub.docker.com/r/linuxserver/openssh-server) 
image, containers launched from this image will serve as a 
[managed nodes](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html#managed-nodes)

## Example usage:

### Example with docker compose
* Start containers via docker compose:
    ```shell
    docker compose up -d
    ```

* _exec_ into a _control-node_ container via _docker exec_

### Example with pure docker
To run a sample playbook from this repository on a instance of a _managed_node:

* Build a _managed_node_ image:
    ```shell
    docker build -t managed-node -f ./managed-node.dockerfile .
    ```

* Run a container with a _managed-node_, for more fine tuning check out openssh-server [container](https://hub.docker.com/r/linuxserver/openssh-server)
docs:
    ```shell
    docker run -d \
      --rm \
      --name=managed-node-1 \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ=Europe/London \
      -e USER_NAME=test_user \
      -e USER_PASSWORD=test_password \
      -e PASSWORD_ACCESS=true \
      -p 2222:2222 \
      managed-node
  ```

* Build a _control_node_ image:
    ```shell
    docker build -t control-node -f ./control-node.dockerfile .
    ```

* Run the _control_node_ with mounted _sample_ folder:
    ```shell
    docker run \
        --rm \
        --interactive \
        --env ANSIBLE_HOST_KEY_CHECKING=False \ 
        --volume ./sample:/ansible/sample \
        control-node \
        bash
    ```
* In a prompted shell, type following command:
    ```shell
    ansible-playbook --inventory /ansible/inventory.yaml /ansible/playbook.yaml
    ```

