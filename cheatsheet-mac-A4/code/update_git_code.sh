#!/usr/bin/env bash
set -e

function update_codecommit(){
    local code_dir=${1?}
    repo_list="devops_blog blog_cdn"
    [ -d "$code_dir/codecommit" ] || mkdir -p "$code_dir/codecommit"
    cd "$code_dir/codecommit"
    for repo in ${repo_list[*]}; do
        if [ ! -d "$repo" ]; then
            echo "git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/${repo}"
            git clone "ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/${repo}"
        else
            echo "Update $repo"
            (cd "$repo" && git pull origin master)
        fi
    done
}

function update_bitbucket(){
    local code_dir=${1?}
    repo_list="intuit-market-design intuit-budget-advising"
    [ -d "$code_dir/bitbucket" ] || mkdir -p "$code_dir/bitbucket"
    cd "$code_dir/bitbucket"
    for repo in ${repo_list[*]}; do
        if [ ! -d "$repo" ]; then
            echo "git clone git@bitbucket.org:dennyzhang/${repo}.git"
            git clone "git@bitbucket.org:dennyzhang/${repo}.git"
        else
            echo "Update $repo"
            (cd "$repo" && git pull origin master)
        fi
    done
}

function update_github(){
    local code_dir=${1?}
    repo_list="devops_public code-with-docker chatops_slack cleanup_old_files dennytest detect_suspicious_process developer-free-saas devops_docker_image devops_jenkins directory-cli-tool droplet-neighbor-check elasticsearch-cli-tool images jenkins_image monitor-docker-slack monitoring nmap-scan-docker node_status_in_json python-hosts-tool python-selenium remote-commands-servers shadowsocks-vpn-docker sonarqube-by-docker terraform_jenkins_digitalocean today-learning my-slides challenges-aws-ecs kubernetes-scripts"
    [ -d "$code_dir/github" ] || mkdir -p "$code_dir/github"
    cd "$code_dir/github"
    for repo in ${repo_list[*]}; do
        if [ ! -d "$repo" ]; then
            echo "git clone git@github.com:dennyzhang/${repo}.git"
            git clone "git@github.com:dennyzhang/${repo}.git"
        else
            echo "Update $repo"
            (cd "$repo" && git pull origin master)
        fi
    done
}

update_github "$HOME/git_code"
update_codecommit "$HOME/git_code"
update_bitbucket "$HOME/git_code"
