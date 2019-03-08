#!/bin/bash

OUTPUT_DIR="out/Debug"
PLATFORM="android"
CPU_ARCHS=("arm" "x86")

function get_options() {
    local OPTIND
    while getopts :o:a: opt; do
        case "$opt" in
            o)
                OUTPUT_DIR="out/$OPTARG"
                ;;
            a)
                CPU_ARCH=($OPTARG)
                ;;
            *)
                echo "Unknown option: $opt"
                ;;
        esac
    done

    echo "output dir: ${OUTPUT_DIR}"
    echo "platform: ${PLATFORM}"
    echo "cpu architecture: ${CPU_ARCH[@]}"
}

function build_webrtc() {
	cd /webrtc/webrtc_sourcecode/src
    echo "${CPU_ARCHS}"
    for arch in "${CPU_ARCHS[@]}"; do
        output_dir="${OUTPUT_DIR}_${arch}"
        echo "$output_dir"
        gn gen ${output_dir} --args='target_os="'${PLATFORM}'" target_cpu="'${arch}'"'
        ninja -C ${output_dir}
    done
}

function combine_lib() {
    lib_webrtc=($(find . -name 'libwebrtc.jar'))
    mkdir -p out/libs
    cp ${lib_webrtc[0]} out/libs
    for arch in "${CPU_ARCHS[@]}"; do
        output_dir="${OUTPUT_DIR}_${arch}"
        output_dir="${OUTPUT_DIR}_${arch}"
        mkdir -p out/libs/${arch}
        cp ${output_dir}/libjingle_peerconnection_so.so out/libs/${arch}
    done
}

get_options "$@"
build_webrtc
combine_lib
