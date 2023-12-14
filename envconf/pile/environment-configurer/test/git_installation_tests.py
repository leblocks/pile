import os
import unittest

from testcontainers.general import DockerContainer


class GitTests(unittest.TestCase):
    def setUp(self):
        self.container = DockerContainer('python:3.9.16-bullseye')
        self.container.with_volume_mapping(
            os.getcwd() + '/configurer', '/configurer')
        self.container.with_command('tail -f /dev/null')
        self.container.with_kwargs(tty=True)
        self.container.start()

    def test_list_flag(self):
        exit_code, output = self.container.exec(
            'python /configurer/configure.py --script git')

        print(output)
        self.assertEqual(exit_code, 0)

        exit_code, output = self.container.exec('ls /root -la')

        for line in output.decode('utf-8').split('\n'):
            print(line)

        self.assertEqual(exit_code, 0)

    def tearDown(self):
        self.container.stop()


if __name__ == '__main__':
    unittest.main()
