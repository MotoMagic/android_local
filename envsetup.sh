# This script is a hack due to limitations in AOSP. If they ever
# go back to accepting community patches, we will add a hook to
# build/envsetup.sh so we can add and override functions.

# this file should be sourced from the top of the MM build tree
if [ ! -e build/envsetup.sh ] ; then
    echo
    echo "Please source this file by calling"
    echo
    echo "    . android_local/envsetup.sh"
    echo
    echo "from the top of your MM build tree. This will automatically"
    echo "source build/envsetup.sh"
    echo
    return;
fi

# source build/envsetup.sh then add our functions
source build/envsetup.sh

function ncpu() {
    case $(uname -s) in
        Darwin)
            sysctl hw.ncpu | cut -d" " -f2
            ;;
        *)
            cat /proc/cpuinfo | grep "^processor" | wc -l
            ;;
    esac
}

function reposync() {
    # if we are syncing everything, resync android_local first to update
    # our local_manifest.xml
    if [ -z "$@" ] ; then
        T=$(gettop)
        repo sync $T/android_local
    fi

    # now do advanced sync
    case $(uname -s) in
        Darwin)
            repo sync -j $(expr $(ncpu) + 1) "$@"
            ;;
        *)
            schedtool_cmd="schedtool -B -n 1 -e"
            ionice_cmd="ionice -n 1"

            if [ -z "$(which schedtool)" ] ; then
                echo "warning: reposync could not find schedtool. running without it"
                schedtool_cmd=""
            fi
            if [ -z "$(which ionice)" ] ; then
                echo "warning: reposync could not find ionice. running without it"
                ionice_cmd=""
            fi

            ${schedtool_cmd} ${ionice_cmd} repo sync -j $(expr $(ncpu) + 1) "$@"
            ;;
    esac
}

function mka() {
    case $(uname -s) in
        Darwin)
            make -j $(expr $(ncpu) + 1) "$@"
            ;;
        *)
            schedtool_cmd="schedtool -B -n 1 -e"
            ionice_cmd="ionice -n 1"

            if [ -z "$(which schedtool)" ] ; then
                echo "warning: mka could not find schedtool. running without it"
                schedtool_cmd=""
            fi
            if [ -z "$(which ionice)" ] ; then
                echo "warning: mka could not find ionice. running without it"
                ionice_cmd=""
            fi

            ${schedtool_cmd} ${ionice_cmd} make -j $(expr $(ncpu) + 1) "$@"
            ;;
    esac
}
