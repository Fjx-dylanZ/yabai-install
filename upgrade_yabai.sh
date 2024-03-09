#!/bin/zsh

brew_output=$(brew outdated yabai --fetch-HEAD | tee /dev/fd/2)
# check if yabai in list
if [[ $brew_output == *"yabai"* ]]; then
  echo "yabai is outdated"
  yabai --stop-service
  brew upgrade yabai --fetch-HEAD
  codesign -fs 'yabai-cert' $(brew --prefix yabai)/bin/yabai
  echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
  yabai --start-service && terminal-notifier -title "yabai" -message "yabai has been updated"
else
  echo "yabai is up to date"
fi