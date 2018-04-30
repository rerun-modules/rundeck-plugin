# Shell functions for the rundeck-plugin module.
#/ usage: source RERUN_MODULE_DIR/lib/functions.sh command
#

# Read rerun's public functions
. $RERUN || {
    echo >&2 "ERROR: Failed sourcing rerun function library: \"$RERUN\""
    return 1
}

# Check usage. Argument should be command name.
[[ $# = 1 ]] || rerun_option_usage

# Source the option parser script.
#
if [[ -r $RERUN_MODULE_DIR/commands/$1/options.sh ]] 
then
    . $RERUN_MODULE_DIR/commands/$1/options.sh || {
        rerun_die "Failed loading options parser."
    }
fi

# - - -
# Your functions declared here.
# - - -
#
# generate_config_property - Generate a config entry for the plugin.yaml
#
generate_config_property() {
	(( $# == 2 )) || { printf >&2 'usage: generate_config_property module option' ; return 2; }
	local module=$1
	local option=$2	
	local option_dir="$MODULES_DIR/$module/options/$option"

	local arguments=$(rerun_property_get "$option_dir" ARGUMENTS)
	local default=$(rerun_property_get "$option_dir" DEFAULT)
	local description=$(rerun_property_get "$option_dir" DESCRIPTION)
	local type=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_TYPE)
	local scope=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_SCOPE)
	local displayType=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_RENDERINGOPTIONS_DISPLAYTYPE)
	local selectionAccessor=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_RENDERINGOPTIONS_SELECTIONACCESSOR)
	local valueConversion=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_RENDERINGOPTIONS_STORAGE_PATH_AUTOMATIC_READ)
	local storagePathRoot=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_RENDERINGOPTIONS_STORAGE_PATH_ROOT)
	local groupName=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_RENDERINGOPTIONS_GROUPNAME)

	if [[ "$arguments" == "false" ]]
	then
		# Generate a boolean property
		printf -- "    - type: Boolean\n"
		printf -- "        name: %s\n" "$option"
		printf -- "        title: '%s'\n" "$option"
		printf -- "        description: \"%s\"\n" "$description"
		printf -- "        default: false\n"
	else
		: ${type:=String};	# Default to a string property (or: String, Boolean, Integer, Long, *Select)
		printf -- "    - type: $type\n"
		printf -- "        name: %s\n" "$option"
		printf -- "        title: '%s'\n" "$option"
		printf -- "        description: \"%s\"\n" "$description"
		[[ -n "$default" ]] && {
		printf -- "        default: '%s'\n" "$default"
		}
		case ${type} in
			Select|FreeSelect)
				values=$(rerun_property_get "$option_dir" RUNDECK_PLUGIN_CONFIG_VALUES)
				printf -- "        values: %s\n" "${values:-}"
				;;
		esac
	fi
	[[ -n "$scope" ]] && printf -- "        scope: %s\n" "$scope"
	# Rendering options
	[[ -n "${groupName:-}" || -n "${displayType:-}" || -n "${selectionAccessor:-}" ]] && {
		printf -- "        renderingOptions:\n"
		[[ -n "$groupName" ]] && {
			printf -- "          grouping: %s\n" "secondary"
			printf -- "          groupName: %s\n" "$groupName"
		}
		[[ -n "$displayType" ]] && {
			printf -- "          displayType: %s\n" "$displayType"
		}
		[[ -n "$selectionAccessor" ]] && {
			printf -- "          selectionAccessor: %s\n" "$selectionAccessor"
			printf -- "          valueConversion: %s\n" "$valueConversion"
			printf -- "          storage-path-root: %s\n" "${storagePathRoot:-keys}"
		}		
	}
}


#
# generate_command_args - Generate command line argument string.
#
generate_command_args() {
	[[ $# = 2 ]] || { printf >&2 'usage: generate_command_args module option' ; return 2; }	
	local module=$1
	local command=$2
	local clopts=()
	for option in $(rerun_options $MODULES_DIR $module $command)
	do
		local option_dir="$MODULES_DIR/$module/options/$option"
		local arguments=$(rerun_property_get "$option_dir" ARGUMENTS)
		if [[ "$arguments" == "false" ]]
		then
			clopts=(${clopts[*]:-} --${option})
		else
		    local varname=$(printf "$option" | tr '[:lower:]' '[:upper:]' | tr  '-' '_')
			clopts=(${clopts[*]:-} "--${option} \"\${RD_CONFIG_${varname}}\"")
		fi
	done
	printf "%s" "${clopts[*]:-}"
}

create_build_hierarchy() {
	local build_dir=$1
	mkdir -pv "$build_dir"
	mkdir -pv "$build_dir/contents"
	mkdir -pv "$build_dir/resources"
} 

create_stubbs-archive() {
	local modules=$1
	local version=$2
	local dir=$3
	rerun stubbs:archive \
	--file "$BUILD_DIR/$NAME/contents/rerun.sh" \
	--format sh \
	--modules "$MODULES" \
	--version "$VERSION" \
	--template "$RERUN_MODULE_DIR/templates/archive"; # special template that populates answers file

}

