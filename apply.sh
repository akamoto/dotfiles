#!/usr/bin/env bash

set -e

dotdir=$HOME/.dotfiles
declare -A files=(
  [.tmux.conf]=$dotdir/tmux/tmux.conf
  [.vimrc]=$dotdir/vim/vimrc
  [.gitconfig]=$dotdir/git/config
  [.bashrc]=$dotdir/bashrc
  [.bin]=$dotdir/bin
  [.inputrc]=$dotdir/inputrc
  [.hgrc]=$dotdir/hgrc
)

declare -A dirfiles=(
  [.w3m/config]=$dotdir/w3m/config
  [.config/nvim/init.lua]=$dotdir/nvim/init.lua
)

declare -A files_mac=(
  [.hammerspoon]=$dotdir/hammerspoon
)


backupdir=/tmp/backup_dotfile_replace/
if [ ! -d $backupdir ]
then
    mkdir $backupdir
fi


#set -x
for file in ${!files[@]}
do
    # don't want to fidget with "stat" differences in mac (freebsd) and linux
    current="$(ls -ld $HOME/$file 2>/dev/null | awk '{ print $NF }')"
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

#set -x
for file in ${!dirfiles[@]}
do
    # don't want to fidget with "stat" differences in mac (freebsd) and linux
    current="$(ls -ld $HOME/$file 2>/dev/null | awk '{ print $NF }')"
    target=${dirfiles[$file]}
    if [[ "$current" != "$target" ]]
    then
        if [ -e "$current" ]
        then
            echo "replacing ungoverned "$current" with link to "$target""
            mkdir -p $backupdir/${file%/*}
            mv -v "$current" "$backupdir/$file-$(date +%Y-%m-%d_%H:%M:%S)"
        else
            echo "$file does not yet exist, creating link to "$target""
        fi
        if [ ! -d $HOME/${file%/*} ]
        then
            mkdir -p $HOME/${file%/*}
        fi
        ln -sf "$target" "$HOME/$file"
    fi
done


if [ "$(uname)" == Darwin ]
then
    for file in ${!files_mac[@]}
    do
        # don't want to fidget with "stat" differences in mac (freebsd) and linux
        current="$(ls -ld $HOME/$file 2>/dev/null | awk '{ print $NF }')"
        target=${files_mac[$file]}
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
fi

git submodule update --init --recursive --depth 1

# create vim backup/swap/tmp folder
mkdir -p ~/.vim/tmp/{backup,swap,undo}
# update helptags / documentation in case a new plugin was added
vim --cmd ":helptags ALL" --cmd :q
