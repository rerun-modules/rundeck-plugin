
Use *model-source* to generate a Resource Model Source plugin for the specified command.
You can specify multiple modules in case your command depends on them.
(You can specify a list of modules using a glob pattern.)


Imagine you have a module as described below:

	$ rerun my-cmdb-client
	Available commands in module, "my-cmdb-client":
	get-nodes: "list the nodes in the cmdb"
	    --server <"">: "the inventory server"
	    --api-key <"">: "the API Key used to access the server"
	    --timeout <30>: "timeout in seconds"

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
