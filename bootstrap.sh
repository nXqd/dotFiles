#!/bin/zsh
# newbootstrap.sh
# author: nXqd
# vim: set ts=2:sw=2
#############################

walk() {
  cmd=$1

  dotFiles=(`ls -da .* | grep -Pxv '\.git|\.gitmodules|\.gitconfig|\.arch|\.+'`)
  curDir=$(pwd)
  homeDir=(`cd ~;pwd`)

  echo "initializing submodules"
  git submodule init
  git submodule update

  for i in ${dotFiles[*]}; do
    target=$curDir"/"$i
    linkName=$homeDir"/"$i

    $cmd $target $linkName
  done

  echo "Updating submodules"
  git submodule foreach git pull origin master --recurse-submodules
}

install() {
  if [ -L $2 ]; then
    echo "Remove file or symlink: "$2
    rm -rf $2
  fi
  ln -s $1 $2
}

uninstall() {
  if [ -L $2 ]; then
    echo "Remove file or symlink: "$2
    rm -rf $2
  fi
}

cmd="$1"
if [ -z "$cmd" ]; then
    echo "Usage: go [command]"
    exit 1
fi

case "$cmd" in
    install)        walk install;;
    uninstall)      walk uninstall;;
    *) echo "Unknown command $cmd"
       exit 1
       ;;
esac
