


Use *node-executor* to generate a 
[Node Executor plugin](http://rundeck.org/docs/developer/node-executor-plugin.html) 
for the specified command.
You can specify multiple modules in case your command depends on them.
(You can specify a list of modules using a glob pattern.)


Imagine you have a module as described below:

	$ rerun rerun-executor
	Available commands in module, "rerun-executor":
	execute: "execute the command string"
	    --command <"">: "command string"


Create a plugin for it:

    rerun rundeck-plugin:model-source --modules my-cmdb-client \
    	--name my-cmdb-inventory \
    	--command my-cmdb-client:get-nodes

### Deploying the plugin

Copy the plugin archive to your rundeck:

    cp ./build/my-cmdb-inventory.zip $RDECK_BASE/libext

You should immediately be able

### Adding it as a source to your project.

Via the GUI:

Go to the configuration page for your project. Click 'Add Source' button.
Find the 'my-cmdb-inventory' plugin and press the '+' button.
You'll see a form presented with textfields corresponding to your command options.
