#!/bin/sh

# path-insert.sh: Library functions for safely modifying PATH.


# log MESSAGE...
#
# Prints the provided arguments to standard error if the DEBUG variable is set to 'y'.
log() {
    test "$DEBUG" = "y" && ( echo -n 'DEBUG: ' && echo "$@" ) >&2
}

# path_exists PATH_ENTRY
#
# Returns true if the specified path entry exists within $PATH, and false otherwise.
path_exists() {
    path="$1" && shift
    echo "$PATH" | tr ':' '\n' | while read path_entry ; do
        test "$path" = "$path_entry" && return 0
    done && return 0

    return 1
}

# prepend_path PATH_ENTRY
#
# Pushes PATH_ENTRY to the beginning of $PATH, provided that PATH_ENTRY does not already exist in $PATH.
prepend_path() {
    path="$1" && shift

    if ! path_exists "$path" ; then
        log "prepend_path - Prepending $path to PATH..."
        export PATH="$path:$PATH"
    else
        log "prepend_path - $path is already present in PATH, nothing to do."
    fi
}

# append_path PATH_ENTRY
#
# Pushes PATH_ENTRY to the end of $PATH, provided that PATH_ENTRY does not already exist in $PATH.
append_path() {
    path="$1" && shift

    if ! path_exists "$path" ; then
        log "append_path - Appending $path to PATH..."
        export PATH="$PATH:$path"
    else
        log "append_path - $path is already present in PATH, nothing to do."
    fi
}

# examples
prepend_path "/opt/something-vendored/bin"
append_path "/usr/local/bin"

# clean up, leave no trace
unset append_path prepend_path path_exists log
