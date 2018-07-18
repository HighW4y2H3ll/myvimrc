#!/bin/bash

# Disable system vimrc?
#mv /etc/vim/vimrc /etc/vim/vimrc_bak
cp vimrc $HOME/.vimrc

mkdir -p $HOME/.vim/autoload
cp vim-plug/plug.vim $HOME/.vim/autoload

# Config Vim-Plug
mkdir -p $HOME/.vim/plugged
