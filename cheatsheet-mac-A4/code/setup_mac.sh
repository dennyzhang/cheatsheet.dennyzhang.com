#!/usr/bin/env bash -e
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT
## https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: setup_mac.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2017-12-04>
## Updated: Time-stamp: <2020-07-03 08:07:24>
##-------------------------------------------------------------------
set -e

function brew_install {
    echo "Brew install packages"
    chmod u+w /usr/local/bin /usr/local/lib /usr/local/sbin
    brew install wget jq ansible direnv
    brew install gpg aspell w3m shadowsocks-libev wget imagemagick msmtp
    brew install telnet shellcheck go getmail tmux
    brew install python3 getmail
    brew install pt
    brew install reattach-to-user-namespace
    brew install chruby
    brew cask install ngrok
    # TODO: change this
    # brew cask install iterm2
}

function brew_install_devkit {
    echo "Brew install devkit"
    brew install mysql mosh
}

function brew_install_personal {
    echo "Brew install personal preferred packages"
    brew install ledger
}

function python_setup {
    pip3 install pylint
}

function download_files {
    echo "Download files"
    wget -O /usr/local/bin/gh-md-toc https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
    chmod a+x /usr/local/bin/gh-md-toc
    which gh-md-toc
    if [ ! -f ~/.git-prompt.sh ]; then
        curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
        echo 'source ~/.git-prompt.sh' > /usr/local/etc/bash_completion.d/git-prompt.sh
    fi
}

function fix_gpg {
    # https://github.com/Homebrew/homebrew-core/issues/14737
    brew install pinentry-mac
    [ -d ~/.gnupg ] || mkdir -p ~/.gnupg
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    killall gpg-agent
}

function setup_email {
    echo "Setup email configurations"
    [ -d ~/.getmail ] || mkdir -p ~/.getmail
    cp ~/Dropbox/private_data/emacs_stuff/backup_small/fetch_mail/.msmtprc ~/.msmtprc
    chmod 400 ~/.msmtprc
}

function create_crontab {
    echo "Define crontab"
    if [ ! -d /var/log/cron ]; then
        sudo mkdir -p chmod 755 /var/log/cron/ && sudo chmod 755 /var/log/cron/
    fi
    # ~/Dropbox/private_data/emacs_stuff/backup_small/hourly_cron.sh
    # ~/Dropbox/private_data/emacs_stuff/backup_small/monthly_cron.sh
    # ~/Dropbox/private_data/emacs_stuff/backup_small/weekly_cron.sh
}

function ssh_config {
    if [ ! ~/.ssh/config ]; then
       ln ~/Dropbox/private_data/emacs_stuff/backup_small/ssh_key/config ~/.ssh/config
    fi
    # TODO: change this
    chmod 600 ~/Dropbox/private_data/emacs_stuff/backup_small/ssh_key/aws/denny-ssh-key1
    chmod 600 ~/Dropbox/private_data/emacs_stuff/backup_small/ssh_key/id_rsa.txt
    for f in $(find ~/Dropbox/private_data/emacs_stuff/backup_small/ssh_key -name "*_id_rsa"); do
        echo "chmod 600 $f"
        chmod 600 $f
    done
}

function config_bashrc {
    if [ ! -f ~/.zshrc ]; then
        # https://github.com/robbyrussell/oh-my-zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    if [ ! ~/.bashrc ]; then
       ln ~/Dropbox/private_data/emacs_stuff/backup_small/bashrc ~/.bashrc
    fi
}

function config_git {
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
}

SKIP_PERSONAL=${SKIP_PERSONAL-"no"}

config_git
create_crontab
ssh_config
# setup_email

brew_install
brew_install_devkit
if [ "$SKIP_PERSONAL" = "no" ]; then
    brew_install_personal
fi
download_files
fix_gpg

## File: setup_mac.sh ends
