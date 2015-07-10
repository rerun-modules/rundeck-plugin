#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m rundeck-plugin -p node-steps [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

# The Plan
# --------
describe "node-steps"

it_builds_a_WorkflowNodeStep_plugin() {
	BUILD_DIR=$(mktemp -d "/tmp/it_builds_a_WorkflowNodeStep_plugin.BASEDIR.XXX")
	PLUGIN_NAME=rundeck-plugin-dummy
	rerun rundeck-plugin:node-steps \
		--name $PLUGIN_NAME \
		--modules rundeck-plugin \
		--build-dir $BUILD_DIR

	# Verify build content was generated.
	test -d $BUILD_DIR/$PLUGIN_NAME
	test -f $BUILD_DIR/$PLUGIN_NAME/plugin.yaml
	grep 'service: WorkflowNodeStep' $BUILD_DIR/$PLUGIN_NAME/plugin.yaml > $BUILD_DIR/grep.list


	# Verify the rerun archive is created and can list.
	test -f $BUILD_DIR/$PLUGIN_NAME/contents/rerun.sh
	$BUILD_DIR/$PLUGIN_NAME/contents/rerun.sh 

	# Verify the plugin archive is intact.
	test -f $BUILD_DIR/$PLUGIN_NAME.zip
	unzip -l $BUILD_DIR/$PLUGIN_NAME.zip > $BUILD_DIR/zip.list
	grep "$PLUGIN_NAME/plugin.yaml"        $BUILD_DIR/zip.list
	grep "$PLUGIN_NAME/contents/rerun.sh"  $BUILD_DIR/zip.list

	rm -r $BUILD_DIR; # cleanup
}
