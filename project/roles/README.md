# Ansible Roles

## Role directory structure

An Ansible role has a defined directory structure with eight main standard directories. You must include at least one of these directories in each role. You can omit any directories the role does not use. For example:

```
# playbooks
site.yml
webservers.yml
fooservers.yml
roles/
    common/
        tasks/
        handlers/
        library/
        files/
        templates/
        vars/
        defaults/
        meta/
    webservers/
        tasks/
        defaults/
        meta/
```

By default Ansible will look in each directory within a role for a main.yml file for relevant content (also main.yaml and main):

tasks/main.yml - the main list of tasks that the role executes.

handlers/main.yml - handlers, which may be used within or outside this role.

library/my_module.py - modules, which may be used within this role (see Embedding modules and plugins in roles for more information).

defaults/main.yml - default variables for the role (see Using Variables for more information). These variables have the lowest priority of any variables available, and can be easily overridden by any other variable, including inventory variables.

vars/main.yml - other variables for the role (see Using Variables for more information).

files/main.yml - files that the role deploys.

templates/main.yml - templates that the role deploys.

meta/main.yml - metadata for the role, including role dependencies.

# Ansible Roles

This designates the following behaviors, for each role ‘x’:

If roles/x/tasks/main.yml exists, tasks listed therein will be added to the play

If roles/x/handlers/main.yml exists, handlers listed therein will be added to the play

If roles/x/vars/main.yml exists, variables listed therein will be added to the play

If roles/x/defaults/main.yml exists, variables listed therein will be added to the play

If roles/x/meta/main.yml exists, any role dependencies listed therein will be added to the list of roles (1.3 and later)

If roles/x/files/. files to be moved from localhost to remote server

If roles/x/templates/. templates

Any copy, script, template or include tasks (in the role) can reference files in roles/x/{files,templates,tasks}/ (dir depends on task) without having to path them relatively or absolutely