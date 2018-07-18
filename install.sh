#!/bin/bash

# Disable system vimrc?
#mv /etc/vim/vimrc /etc/vim/vimrc_bak
cp vimrc $HOME/.vimrc

mkdir $HOME/.vim/autoload
cp vim-plug/plug.vim $HOME/.vim/autoload
