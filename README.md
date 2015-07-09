
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

### What if my command takes on option I'd like to manage as a configuration property?

You might want a command option treated like a project configuration setting
managed by the Rudneck administrator. For the option in question, add a new metadata key: 

`RUNDECK_PLUGIN_CONFIG_SCOPE=Project`

See [Property Scopes](http://rundeck.org/docs/developer/plugin-development.html#property-scopes) for a list.

### Besides Boolean and String, what other plugin config property types can I use for my command options?

The *rundeck-plugin* command supports two default ways of treating your command options.
If they take an argument the option is treated like a string otherwise it's treated like a boolean.

You can control this however by specifying the "type" as a metadata property for the option.

    RUNDECK_PLUGIN_CONFIG_TYPE={Boolean | String | Integer | Long | Select | FreeSelect}

* Boolean: Generated for command options that don't take an argument.
* String: Generated for options that take an argument. (Default)
* Integer: 
* Long:
* Select: must be one of a set of values
* FreeSelect may be one of a set of values

This gives more control over how the options are rendered in the GUI and how the input validation works.

*Note*: If you specify Select or FreeSelect you should also specify the comma separated list of values. 

    RUNDECK_PLUGIN_CONFIG_VALUES="val1,val2,val3"

### How do I control how the text field is rendered for my option (eg for passwords)?

For command options that are Strings you can control how they are rendered. 

	RUNDECK_PLUGIN_CONFIG_RENDERINGOPTIONS_DISPLAYTYPE={SINGLE_LINE | MULTI_LINE | PASSWORD}

* SINGLE_LINE - display input as a single text field. (default)
* MULTI_LINE - display input as a multi-line text area.
* PASSWORD - display input as a password field. The value will be rendered with "`*****`".

