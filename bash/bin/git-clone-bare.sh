#!/bin/bash
# usage: git-clone-bare ssh://git@gitstash.accretivetg.com/docs/engineering.documentation.git
#
# Does a bare clone of a repository and setup remote tracking. This is used in conjunction with git work trees

set -x

# Get the name of the clone repository and strip trailing `.git` from the name.
repo_name=$(basename ${1} .git)

git clone --bare ${1} ${repo_name}
cd ${repo_name}
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch --all

# Remove local branches that bare clone created (they now exist as remote refs)
for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    if [ "$branch" != "main" ] && [ "$branch" != "master" ]; then
        git branch -D "$branch"
    fi
done
