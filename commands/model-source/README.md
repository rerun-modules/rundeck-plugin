
Use *model-source* to generate a 
[Resource Model Source plugin](http://rundeck.org/docs/developer/resource-model-source-plugin.html) 
for the specified command.
You can specify multiple modules in case your command depends on them.
(You can specify a list of modules using a glob pattern.)


Imagine you have a module to access your in-house CMDB for node inventory data.
The module has a command that outputs "resourceyaml" format data.
The module contains a command, "get-nodes", that has usage as described below. The
get-nodes command takes several options needed to connect to the CMDB.

	$ rerun my-cmdb-client
	Available commands in module, "my-cmdb-client":
	get-nodes: "output the nodes in the cmdb as resourceyaml"
	    --server <"">: "the inventory server"
	    --api-key <"">: "the API Key used to access the server"
	    --timeout <30>: "timeout in seconds"

You can turn that module into a Resource Model Source plugin by using the
*model-source* command. 

    rerun rundeck-plugin:model-source \
        --modules my-cmdb-client \
    	--name my-cmdb-inventory \
    	--command my-cmdb-client:get-nodes

The `--modules` option specifies which modules to include in the plugin.
The `--name` option specifies the name of the plugin as it will be seen in the project configuration.
The `command` specifies the command the plugin will invoke anytime node data is needed.
Each of these options will be exposed as configuration properties your Rundeck administrator can manage.

This will produce a plugin Zip file you can deploy to Rundeck and use in a project.

### Deploying the plugin

Copy the plugin archive to your rundeck:

    cp ./build/my-cmdb-inventory.zip $RDECK_BASE/libext

You should immediately be able to use the plugin.

### Adding your plugin as a model source to your project.

Via the GUI:

Go to the configuration page for your project. Click 'Add Source' button.
Find the 'my-cmdb-inventory' plugin and press the '+' button.
You'll see a form presented with textfields corresponding to your command options.


Via the rd-project CLI:	

The [rd-project](http://rundeck.org/docs/man1/rd-project.html) command 
supports `[ --property=value ]` arguments to pass configuration keys.
Since a project can have multiple model sources they are indexed by a number.
The example below indicates the plugin will be the second model source:

	rd-project -a create -p myproject \
		--resources.source.2.type=my-cmdb-inventory \	
		--resources.source.2.config.server=cmdb.acme.com \
		--resources.source.2.config.api-key=D7DFDE1D-E2A1-4F97-B86A-305405C70DB4 \		
		--resources.source.2.config.timeout=30 

*Note*: Each of the options for the rerun command are exposed as configuration properties.