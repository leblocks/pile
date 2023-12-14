import os
import unittest

import utils
from testcontainers.general import DockerContainer


class CliTests(unittest.TestCase):
    def setUp(self):
        self.container = DockerContainer('python:3.9.16-bullseye')
        self.container.with_volume_mapping(
            os.getcwd() + '/configurer', '/configurer')
        self.container.with_command('tail -f /dev/null')
        self.container.with_kwargs(tty=True)
        self.container.start()

    def test_list_long_flag(self):
        exit_code, output = self.container.exec(
            'python /configurer/configure.py --list')

        output_lines = utils.parse_command_output(output)

        self.assertEqual(exit_code, 0)
        self.assertIn('tmux', output_lines)
        self.assertIn('git', output_lines)

    def test_list_short_flag(self):
        exit_code, output = self.container.exec(
            'python /configurer/configure.py -l')

        output_lines = utils.parse_command_output(output)

        self.assertEqual(exit_code, 0)
        self.assertIn('tmux', output_lines)
        self.assertIn('git', output_lines)

    def test_exclusive_flags(self):
        exit_code, _ = self.container.exec(
            'python /configurer/configure.py --all --list')
        self.assertEqual(exit_code, 2)

    def tearDown(self):
        self.container.stop()


if __name__ == '__main__':
    unittest.main()
