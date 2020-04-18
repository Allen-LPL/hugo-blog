#!/usr/bin/env sh

cd blog
if [ ! -f "run.sh" ]; then
    /bin/sh run.sh
fi
