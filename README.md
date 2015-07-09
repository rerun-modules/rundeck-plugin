
You've created some awesome rerun modules and now
you would like to share them as automation building blocks.

Expose your rerun modules as RUNDECK plugins!
Rundeck provides a friendly user interface to people using your modules.

You can expose your commands as different kinds of Rundeck plugins.

### What kind of plugins?

*rundeck-plugin* lets you create several kinds of Rundeck plugins:

* Job steps: Execute your rerun commands on remote nodes. See *remote-node-steps* command.
* Model source: Write a command that provides node information to your Rundeck projects.  See *model-source* command.
* Node Executor: Write a command that takes a command string and executes it on a remote node. See *node-executor* command.

### What if my command depends on other modules?

That's OK. You can specify multiple modules to the rundeck-plugin commands.
When your plugin is built, these other plugins will be included as a rerun
archive.


