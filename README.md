
You've created some awesome rerun modules and now
you would like to share them as automation building blocks.

Expose your rerun modules as RUNDECK plugins!
This gives a friendly user interface to those using your modules.
Also, exposed as a plugin, your job writers will be able
write jobs using your plugins as steps.

If your rerun commands require sensitive data only your administrator should
know, see the Configuration section below.

## Configuration

You can control if your command options should be treated as plugin configuration properties
by using the metadata key: `RUNDECK_PLUGIN_CONFIG_SCOPE`.

Here's how to make a command option configurable for a project:

	RUNDECK_PLUGIN_CONFIG_SCOPE=Project