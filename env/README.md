# Ansible Runner Environment

The env directory contains settings and sensitive files that inform certain aspects of the invocation of the Ansible process, an example of which can be found in the demo env directory. Each of these files can also be represented by a named pipe providing a bit of an extra layer of security. The formatting and expectation of these files differs slightly depending on what they are representing.

https://ansible-runner.readthedocs.io/en/stable/intro/#the-env-directory