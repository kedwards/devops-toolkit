# Cache

Cache plugins allow Ansible to store gathered facts or inventory source data without the performance hit of retrieving them from source.

The default cache plugin is the memory plugin, which only caches the data for the current execution of Ansible. Other plugins with persistent storage are available to allow caching the data across runs. Some of these cache plugins write to files, others write to databases.

You can use different cache plugins for inventory and facts. If you enable inventory caching without setting an inventory-specific cache plugin, Ansible uses the fact cache plugin for both facts and inventory. If necessary, you can create custom cache plugins.

## Enabling fact cache plugins

Fact caching is always enabled. However, only one fact cache plugin can be active at a time. You can select the cache plugin to use for fact caching in the Ansible configuration, either with an environment variable:

```
export ANSIBLE_CACHE_PLUGIN=jsonfile
```

or in the ansible.cfg file:

```
[inventory]
cache=True
```

or if the inventory plugin accepts a YAML configuration source, in the configuration file:

```
# dev.aws_ec2.yaml
plugin: aws_ec2
cache: True
```