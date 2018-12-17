#!/bin/bash

# Download tar if doesn't exist

PROJ="tmux-2.8.tar.gz"
SRC=https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8.tar.gz

if [ ! -e ${PROJ} ]
then
    wget ${SRC}
fi

