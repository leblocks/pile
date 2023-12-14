import os

if __name__ == '__main__':
    home = os.path.expanduser('~')
    source = os.path.join(os.path.dirname(__file__), '.gitconfig')
    target = os.path.join(home, '.gitconfig')
    print(f'symlinking .gitconfig from {source} to {target}')
    os.symlink(source, target)
