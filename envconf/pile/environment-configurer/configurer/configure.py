import argparse
import glob
import os

import utils


def parse_args():
    parser = argparse.ArgumentParser()
    flags = parser.add_mutually_exclusive_group()

    flags.add_argument(
        '-l',
        '--list',
        action='store_true',
        help='list all available scripts for configuration',
    )

    flags.add_argument(
        '-a',
        '--all',
        action='store_true',
        help='run all configuration scripts',
    )

    flags.add_argument(
        '-s',
        '--scripts',
        dest='scripts',
        action='extend',
        nargs='+',
        help='list of configuration scripts to run',
    )

    return parser.parse_args()


def get_script_name(script_path):
    return os.path.basename(script_path).replace('.py', '')


def get_all_scripts():
    path_to_scripts_folder = os.path.dirname(__file__)
    return glob.glob(path_to_scripts_folder + '/scripts/**/*.py')


def run_script(script_path):
    script_name = get_script_name(script_path)
    # set PYTHONPATH so scripts will see utils library
    env = dict(os.environ, PYTHONPATH=os.path.dirname(__file__))
    utils.run_command(['python', script_path], script_name, env)


if __name__ == '__main__':
    args = parse_args()

    # -l --list flag
    if args.list:
        for script_path in get_all_scripts():
            print(get_script_name(script_path))

    # -s --scripts flag
    if args.scripts:
        for script_name in args.scripts:
            script_path = [
                p for p in get_all_scripts() if script_name == os.path.basename(p).replace(
                    '.py', '')]
            if script_path:
                run_script(script_path[0])

    # -a --all flag
    if args.all:
        for script_path in get_all_scripts():
            run_script(script_path)
