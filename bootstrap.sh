#!/bin/zsh
# newbootstrap.sh
# author: nXqd
# vim: set ts=2:sw=2
#############################

walk() {
  cmd=$1

  dotFiles=(`ls -da .* | grep -Pxv '\.git|\.+'`)
  curDir=$(pwd)
  homeDir=(`cd ~;pwd`)

  for i in ${dotFiles[*]}; do
    target=$curDir"/"$i
    linkName=$homeDir"/"$i

    $cmd
  done
}

install() {
  if [ -L $linkName ]; then
    echo "Remove file or symlink: "$linkName
    rm -rf $linkName
  fi
  ln -s $target $linkName
}

uninstall() {
  if [ -L $linkName ]; then
    echo "Remove file or symlink: "$linkName
    rm -rf $linkName
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
