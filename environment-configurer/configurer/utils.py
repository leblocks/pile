import os
import subprocess
import threading


def get_process_output_reader(prefix):
    def reader(process):
        for line in iter(process.stdout):
            pref = f"[{prefix}] " if prefix else ""
            print(f"{pref}{line.decode('utf-8').rstrip()}")
    return reader


def run_command(command, prefix='', env=os.environ):
    process = subprocess.Popen(command,
                               bufsize=0,
                               env=env,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT)

    output_reader = get_process_output_reader(prefix)
    thread = threading.Thread(target=output_reader, args=(process,))
    thread.start()
    thread.join()
