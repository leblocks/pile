## useful commands

* build container (from repo root)
    ```sh
    docker build -t archlinux-env -f ./images/archlinux.dockerfile .
    ```
* run container
   ```sh
   docker run --rm -i -t -u archie archlinux-env bash
   ```
