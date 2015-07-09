
You've created some awesome rerun modules and now
you would like to share them as automation building blocks.

Expose your rerun modules as RUNDECK plugins!
This gives a friendly user interface to those using your modules.
Also, exposed as a plugin, your job writers will be able
write jobs using your plugins as steps.

### What kind of plugins?

*rundeck-plugin* can support several kinds of plugin use cases.

* Job steps that execute remote nodes. See *node-steps* command.
* Provide node information to your Rundeck projects.  See *model-source* command.
* Execute commands on remote nodes. See *node-executor* command.

### What if my command depends on other modules?

That's OK. You can specify multiple modules to the rundeck-plugin commands.
When your plugin is built, these other plugins will be included as a rerun
archive.


