#!/bin/bash -e
function my_test() {
   for f in $(find . -name README.org); do
        dirname=$(basename $(dirname $f))
        echo "Update for $f"
        # sed -ie "s/github.com\/DennyZhang\/challenges-leetcode-interesting\/tree\/master/github.com\/DennyZhang\/challenges-leetcode-interesting\/tree\/master\/problems/g" $f
        # sed -ie "s/url-external://g" $f
        # rm -rf $dirname/README.orge
        #exit
   done
}

function refresh_wordpress() {
    local max_days=${MAX_DAYS:-"7"}
    echo "Use emacs to update wordpress posts"
    for f in $(find * -name 'README.org' -mtime -${max_days} | grep -v '^README.org$'); do
        echo "Update $f"
        dirname=$(basename $(dirname $f))
        cd $dirname
        /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_10 --batch -l ../emacs-update.el
        cd ..
    done
}

function refresh_cheatsheet() {
    local max_days=${MAX_DAYS:-"7"}
    echo "Use emacs to update cheatsheet pdf"
    for f in $(find * -name 'README.org' -mtime -${max_days} | grep -v '^README.org$'); do
        echo "Update $f"
        dirname=$(basename $(dirname $f))
        cd $dirname
        /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_10 --batch -l ../emacs-update-cheatsheet.el
        cd ..
    done
}

function git_pull() {
    for d in $(ls -1); do
        if [ -d "$d" ] && [ -f "$d/.git" ] ; then
            cd "$d"
            echo "In ${d}, git commit and push"
            git pull origin master
            cd ..
        fi
    done
    git pull origin
}

function git_push() {
    for d in $(ls -1); do
        if [ -d "$d" ] && [ -f "$d/.git" ] ; then
            cd "$d"
            echo "In ${d}, git commit and push"
            git commit -am "update doc"
            git push origin
            cd ..
        fi
    done
    git commit -am "update doc"
    git push origin
}

function refresh_link() {
    echo "refresh link"
    for f in $(ls -1t */README.org); do
        dirname=$(basename $(dirname $f))
        if ! grep ":export_file_name: $dirname.pdf" $f 1>/dev/null 2>&1; then
            sed -ie "s/\:export_file_name\:.*/\:export_file_name\: $dirname.pdf/g" "$f"
            rm -rf $dirname/README.orge            
        fi

        if ! grep "PDF Link: \\[\\[https:\\/\\/github.com/dennyzhang/.*$dirname.pdf" $f 1>/dev/null 2>&1; then
            echo "Update pdf url for $f"
            sed -ie "s/PDF Link: .*/PDF Link: \\[\\[https:\\/\\/github.com\\/dennyzhang\\/${dirname}\\/blob\\/master\\/${dirname}.pdf\\]\\[$dirname.pdf\\]\\]/g" "$f"
            rm -rf $dirname/README.orge
        fi

##         if ! grep "Blog link: https:\/\/code.dennyzhang.com.*$dirname" $f 1>/dev/null 2>&1; then
##             echo "Update blog url for $f"
##             sed -ie "s/Blog link: https:\/\/code.dennyzhang.com\/.*/Blog link: https:\/\/code.dennyzhang.com\/$dirname/g" $f
##             rm -rf $dirname/README.orge
##         fi
## 
##         if ! grep "tree\/master.*$dirname" $f 1>/dev/null 2>&1; then
##             echo "Update GitHub url for $f"
##             sed -ie "s/tree\/master\/.*/tree\/master\/$dirname][challenges-leetcode-interesting]]/g" $f
##             rm -rf $dirname/README.orge
##         fi
##
    done
}

action=${1?}
eval "$action"
