#!/bin/bash

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
    key="$1"

    case $key in
        -t|--target)
            target="$2"
            shift # past argument
            ;;
        -u|--url)
            git_url_http="$2"
            shift # past argument
            ;;
        -p|--project-id)
            project_id="$2"
            shift # past argument
            ;;
        -c|--component-id)
            component_id="$2"
            shift # past argument
            ;;
        -t|--component-type)
            component_type="$2"
            shift # past argument
            ;;
        -s|--source)
            source="$2"
            shift # past argument
            ;;
        -i|--ods-image-tag)
            ods_image_tag="$2"
            shift # past argument
            ;;
        -r|--ods-git-ref)
            ods_git_ref="$2"
            shift # past argument
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
done



# replace placeholders
echo "target: $target, url: $git_url_http, project-id: $project_id, component-id: $component_id, component-type: $component_type, image-tag: $ods_image_tag, git-ref: $ods_git_ref"
sed 's|@project_id@|'$project_id'|g; s|@component_id@|'$component_id'|g; s|@component_type@|'$component_type'|g; s|@git_url_http@|'$git_url_http'|g;  s|@ods_image_tag@|'$ods_image_tag'|g; s|@ods_git_ref@|'$ods_git_ref'|g' $source > $target
