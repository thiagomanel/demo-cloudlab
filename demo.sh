#!/bin/bash

#input_dir stores the tiff files and MTL to generate ndvi
input_dir=$1

#working_dir is a local directory to be used during the job execution
working_dir=$2

#results_dir is a directory to store data after job execution
results_dir=$3

function setup {
    apt-get update
    apt-get install make
    apt-get install libtiff-dev

    apt-get install git

    #install image_magick
    apt-get update
    apt-get install imagemagick

    #build ndvi dep
    git clone https://github.com/simsab-ufcg/ndvi-gen.git
    cd ndvi-gen
    make
    cd -
}

function generate_ndvi {
    ./ndvi-gen/run $input_dir $working_dir
}

function export_to_png {
    #by convention, the output is named as ndvi.tif
    convert $working_dir/ndvi.tif $working_dir/ndvi.png
}

# This scripts generates the vegetation index
# for a given tiff file, exports the index
# as a png file and stores it in cloud storage.

# build dependencies
setup

# generate the vegetation index
generate_ndvi

# exports the vegetation index as a png file
export_to_png

# moves output to cloud storage
mv $working_dir/* $results_dir/
