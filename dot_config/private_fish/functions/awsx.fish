function awsx
  export AWS_PROFILE="$(aws configure list-profiles | fzf)"
  echo "Switched to profile ""$AWS_PROFILE""."
end
