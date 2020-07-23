#!/bin/bash

set -e

dotdir=$HOME/.dotfiles
declare -A files=(
  [.tmux.conf]=$dotdir/tmux/tmux.conf
  [.vimrc]=$dotdir/vim/vimrc
  [.gitconfig]=$dotdir/gitconfig
  [.bashrc]=$dotdir/bashrc
  [.bin]=$dotdir/bin
)


backupdir=/tmp/backup_dotfile_replace/
if [ ! -d $backdupdir ]
then
    mkdir -v $backupdir
fi


#set -x
for file in ${!files[@]}
do
    # don't want to fidget with "stat" differences in mac (freebsd) and linux
    current="$(ls -l $HOME/$file 2>/dev/null | awk '{ print $NF }')"
    target=${files[$file]}
    if [[ "$current" != "$target" ]]
    then
        if [ -e "$current" ]
        then
            echo "replacing ungoverned "$current" with link to "$target""
            mv -v "$current" "$backupdir/$file-$(date +%Y-%m-%d_%H:%M:%S)"
        else
            echo "$file does not yet exist, creating link to "$target""
        fi

        ln -sf "$target" "$HOME/$file"

    fi
done
