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

# Apply new color scheme
mkdir tmp_colorscheme
pushd ./tmp_colorscheme
git clone https://github.com/flazz/vim-colorschemes.git
mv vim-colorschemes/colors ~/.vim/
popd
rm -rf tmp_colorscheme

# Build CodeQuery
mkdir tmp_codequery
pushd ./tmp_codequery
git clone https://github.com/ruben2020/codequery.git
cd codequery
mkdir build
cd build

# Install clang-format
sudo apt-get install clang-format

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

# Install rbenv for ruby > 2.0
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev \
    libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
pushd $HOME/
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

rbenv global 2.2.3
sudo gem install starscope  # Javascript, Ruby, Go

popd

