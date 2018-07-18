#!/bin/bash

# Note: For the First time to Run, run :PluginInstall inside Vim

qt=5
codequery_args="-DNO_GUI=ON"   # default codequery build options - no gui
while getopts "q:p:" opt; do
    case ${opt} in
        q ) # specify qt version, default Qt5
            qt=$OPTARG
            ;;
        p ) # specify prefix
            codequery_args=$codequery_args" -DCMAKE_INSTALL_PREFIX="`realpath $OPTARG`
            ;;
    esac
done

# Disable system vimrc?
#mv /etc/vim/vimrc /etc/vim/vimrc_bak
cp vimrc $HOME/.vimrc

mkdir -p $HOME/.vim/autoload
cp vim-plug/plug.vim $HOME/.vim/autoload

# Config Vim-Plug
mkdir -p $HOME/.vim/plugged

# Build CodeQuery
mkdir tmp_codequery
pushd ./tmp_codequery
git clone https://github.com/ruben2020/codequery.git
cd codequery
mkdir build
cd build

if (($qt == 5)); then
    echo "Building with Qt5"
    sudo apt-get install g++ git cmake sqlite3 libsqlite3-dev qt5-default qttools5-dev-tools cscope exuberant-ctags
    codequery_args=$codequery_args" -DBUILD_QT5=ON"
    cmake -G "Unix Makefiles"
elif (($qt == 4)); then
    echo "Building with Qt4"
    sudo apt-get install g++ git cmake sqlite3 libsqlite3-dev qt4-dev-tools cscope exuberant-ctags
    codequery_args=$codequery_args" -DBUILD_QT5=OFF"
fi

cmake -G "Unix Makefiles" $codequery_args ..
make && sudo make install

popd
rm -rf tmp_codequery

# Other ctags/cscope tools
sudo pip install pycscope   # Python
sudo gem install starscope  # Javascript, Ruby, Go

