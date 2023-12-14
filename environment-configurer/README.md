
## What is it?
I've decided to create a configuration script to efficiently set up and update my development tools. 
Initially, I used a set of shell scripts, but it only worked on linux and was challenging to develop. 
Afterward, I thought about using [ansible](https://www.ansible.com/), but it seemed too cumbersome to bootstrap 
it on a fresh installation. Instead, I opted for a series of Python scripts to get the job done.

Update: It turned out that to develop python script was more challenging than I thought. :D

## Requirements
* simple cli interface to perform environment maintanance
* vanilla python, ideally should work on any python3 distribution
* simple bootstrapt scripts (both for windows and linux)
* testing and linting against multiple python versions and system distributions



### Stuff
* Format code:
    ```shell
    autopep8 --in-place --aggressive --aggressive --recursive . && isort .
    ```

* Run tests:
    ```shell
    python test\cli_tests.py -v
    ```
