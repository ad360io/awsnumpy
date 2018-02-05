#!/bin/bash
# 2018 QChain Inc. All Rights Reserved.
# License: Apache v2, see LICENSE.
#
#   host [runtime] [outdir] -- Build NumPy from within container.
#
#   Opts:
#       [runtime]    Python runtime (ex. "36").
#       [outdir]     Output directory (ex. "/var/task").
#

RUNTIME=$1
OUTDIR=$2
LIBDIR="$OUTDIR/lib"
PYTHON=python$RUNTIME

# FUNCTIONS
# ---------

# Long copy function, that takes a src name and gets all relative
# symlinks to the destination directory.
function copy_lib()
{
     # Pass the path
     for f in $1* ; do cp -P "$f" $2/. ; done
}

function copy_libs()
{
    # copy over the BLAS libraries
    blas=( "liblapack" "libptf77blas" "libf77blas" "libptcblas" "libcblas" "libatlas" "libptf77blas" )
    for n in "${blas[@]}"
    do
        name="/usr/lib64/atlas-sse3/$n.so"
        copy_lib "$name" "$1"
    done

    runtime=( "libgfortran" "libquadmath" )
    for n in "${runtime[@]}"
    do
        name="/usr/lib64/$n.so"
        copy_lib "$name" "$1"
    done
}

function build_numpy()
{
    # build NumPy
    cd /numpy
    $PYTHON setup.py build
    $PYTHON setup.py install --user
}

function copy_numpy
{
    # copy NumPy to $LIBDIR
    cd /
    site=$($PYTHON -c "import numpy; print(numpy.__path__[0])")
    cp -a "$site" "$OUTDIR"
}

# CALL
# ----

mkdir -p "$LIBDIR"
copy_libs "$LIBDIR"
build_numpy
copy_numpy "$OUTDIR"
