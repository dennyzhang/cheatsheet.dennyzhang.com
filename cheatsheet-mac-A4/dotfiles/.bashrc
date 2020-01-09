# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zdenny/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/zdenny/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zdenny/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/zdenny/google-cloud-sdk/completion.zsh.inc'; fi

alias ssh='nocorrect ssh'
export PATH=$PATH:/usr/local/opt/go/libexec/bin:/Library/TeX/texbin
source <(kubectl completion bash)
alias k='kubectl'
