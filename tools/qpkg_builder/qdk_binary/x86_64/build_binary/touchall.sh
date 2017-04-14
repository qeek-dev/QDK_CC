#!/bin/bash
mytime=$(date "+%Y%m%d%H%M.%S")
find . \
-path ./Kernel -prune \
-o -print0 | xargs -0 touch -t $mytime

