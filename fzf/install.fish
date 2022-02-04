#!/usr/bin/env fish

# check requirements
if not type -q fzf
  echo 'fzf is not installed'
  exit 1
end

if not type -q fd
  echo 'fd is not installed'
  exit 1
end

if not type -q bat
  echo 'bat is not installed'
  exit 1
end