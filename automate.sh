#!/bin/bash -e
function my_test {
   for f in $(find . -name README.org); do
        dirname=$(basename $(dirname $f))
        echo "Update for $f"
        # sed -ie "s/github.com\/DennyZhang\/challenges-leetcode-interesting\/tree\/master/github.com\/DennyZhang\/challenges-leetcode-interesting\/tree\/master\/problems/g" $f
        # sed -ie "s/url-external://g" $f
        # rm -rf $dirname/README.orge
        #exit
   done
}

function refresh_wordpress {
    local max_days=${MAX_DAYS:-"7"}
    echo "Use emacs to update wordpress posts"
    for f in $(find . -name 'README.org' -mtime -${max_days} | grep -v '^./README.org$'); do
        echo "Update $f"
        dirname=$(basename $(dirname $f))
        cd $dirname
        /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_10 --batch -l ../emacs-update.el
        cd ..
    done
}

function refresh_cheatsheet {
    local max_days=${MAX_DAYS:-"7"}
    echo "Use emacs to update cheatsheet pdf"
    for f in $(find . -name 'README.org' -mtime -${max_days} | grep -v '^./README.org$'); do
        echo "Update $f"
        dirname=$(basename $(dirname $f))
        cd $dirname
        /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_10 --batch -l ../emacs-update-cheatsheet.el
        rm -rf *.tex
        cd ..
    done
}

function git_pull {
    for d in $(ls -1); do
        if [ -d "$d" ] && [ -f "$d/.git" ] ; then
            cd "$d"
            echo "In ${d}, git pull"
            git pull origin master
            cd ..
        fi
    done
    git pull origin
}

function git_push {
    for d in $(ls -1); do
        if [ -d "$d" ] && [ -f "$d/.git" ] ; then
            cd "$d"
            echo "In ${d}, git commit and push"
            git checkout master
            git add *.org
            git add *.pdf
            # git commit -am "update doc"
            git commit --amend --no-edit
            git push origin master --force
            cd ..
        fi
    done
    git commit -am "update doc"
    git push origin
    # git submodule update
}

function refresh_link {
    echo "refresh link"
    git status
    for f in $(ls -1t */README.org); do
        dirname=$(basename $(dirname $f))
        echo "Update $dirname"
        if ! grep "\- Blog URL: https:\/\/cheatsheet.dennyzhang.com\/$dirname" $f 1>/dev/null 2>&1; then
            echo "Update blog url for $f"
            sed -i "" "s#- Blog URL: https://cheatsheet.dennyzhang.com/.*#- Blog URL: https://cheatsheet.dennyzhang.com/$dirname#g" $f
        fi

        if ! grep ":export_file_name: $dirname.pdf" $f 1>/dev/null 2>&1; then
            sed -i "" "s/\:export_file_name\:.*/\:export_file_name\: $dirname.pdf/g" "$f"
        fi

        if [ -f ${dirname}/.git ]; then
            github_link="https://github.com/dennyzhang/$dirname"
            pdf_link="https://github.com/dennyzhang/${dirname}/blob/master/${dirname}.pdf"
        else
            github_link="https://github.com/dennyzhang/cheatsheet.dennyzhang.com/tree/master/$dirname"
            pdf_link="https://github.com/dennyzhang/cheatsheet.dennyzhang.com/blob/master/${dirname}/${dirname}.pdf"
        fi

        if ! grep "<a href=\"${github_link}\">" $f 1>/dev/null 2>&1; then
            echo "Update github url for $f"
            sed -i "" "s#<a href=\"https://github.com/dennyzhang/[^\"]*\">#<a href=\"$github_link\">#g" $f
        fi

        # TODO update the changed file
        # echo "Update pdf url for $f"
        sed -i "" "s#^- PDF Link: [^,]*,#- PDF Link: [[${pdf_link}][${dirname}.pdf]],#g" "$f"

        # echo "Update latex blog url for $f"
        sed -i "" "s#\+LATEX_HEADER: \\\lfoot{\\\href{https://github.com/dennyzhang.*#\+LATEX_HEADER: \\\lfoot{\\\href{$github_link}{GitHub: $github_link}}#g" "$f"
        sed -i "" "s#\+LATEX_HEADER: \\\lhead{\\\href{https://cheatsheet.dennyzhang.com.*#\+LATEX_HEADER: \\\lhead{\\\href{https://cheatsheet.dennyzhang.com/${dirname}}{Blog URL: https://cheatsheet.dennyzhang.com/${dirname}}}#g" "$f"

    done
    git status
}

action=${1?}
eval "$action"
