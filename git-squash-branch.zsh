#! /bin/zsh

compdef _git-squash-branch git-squash-branch

_git-squash-branch() {
    _arguments \
        ':branch-name:__branch_names'
}


function git-squash-branch() {
    if (( ! $# == 1 )); then
        echo "Usage: $0 (branch built from)"
        exit -1
    fi
    local branch=$1
    
    local commit=$(git rev-parse HEAD)

    local count_commits=$(git rev-list --count HEAD ^${branch})
    echo "Number of commits since '$branch': $count_commits"

    git reset --soft HEAD~$count_commits
    
    git commit
    if (( $? == 0 )); then
        echo Done
    else
        verify "Would you like to reset? (y/n)"
        if (( $? == 0 )); then
            git reset --soft $commit
            echo "Reset to commit $commit: $(git log --format=%B -n 1 ${commit})"
        fi
    fi
        
}
