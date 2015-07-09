#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m rundeck-plugin -p model-source [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

# The Plan
# --------
describe "model-source"



it_builds_a_ResourceModelSource_plugin() {
	BUILD_DIR=$(mktemp -d "/tmp/it_builds_a_ResourceModelSource_plugin.BASEDIR.XXX")
	PLUGIN_NAME=rundeck-plugin-dummy
	rerun rundeck-plugin:model-source \
		--name $PLUGIN_NAME \
		--modules rundeck-plugin \
		--command rundeck-plugin:model-source \
		--build-dir $BUILD_DIR

	# Verify build content was generated.
	test -d $BUILD_DIR/$PLUGIN_NAME
	test -f $BUILD_DIR/$PLUGIN_NAME/plugin.yaml
	grep 'service: ResourceModelSource' $BUILD_DIR/$PLUGIN_NAME/plugin.yaml

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


