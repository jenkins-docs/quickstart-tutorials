#!/bin/bash
# This script is used to update Jenkins plugins and create a pull request with the updates.
# It first checks if there is an existing pull request with the same title.
# If there is, it checks out the branch of the existing pull request.
# If there isn't, it creates and checks out a new branch.
# Then, it adds the updated plugins.txt file to the staging area and amends the latest commit with the changes.
# Finally, it pushes the changes to the 'origin' repository and creates a new pull request if there is no existing one.

# If changes are detected, a pull request is created or an existing one is modified.
echo "Plugins have been updated, creating a pull request or modifying an existing one if it exists"

# Set the default repository for the 'gh' command to 'gounthar/quickstart-tutorials'.
# gh repo set-default gounthar/quickstart-tutorials

# Define the title of the pull request.
PR_TITLE="chore(jenkins): Updates Jenkins plugins"

# Check if there is an existing pull request with the same title.
# If there is, get the branch name of the existing pull request.
# If there isn't, set EXISTING_PR_BRANCH to an empty string.
# shellcheck disable=SC1073
EXISTING_PR=$(gh pr list --search "$PR_TITLE" --json number,headRefName)
EXISTING_PR_BRANCH=$(echo "$EXISTING_PR" | jq -r 'if (type=="array" and length > 0) then .[0].data.repository.pullRequests.nodes[0].headRefName else "" end')

# If there is no existing pull request, create and checkout a new branch.
if [ -z "$EXISTING_PR_BRANCH" ]; then
  git checkout -b "$BRANCH_NAME"
else
  # If there is an existing pull request, checkout the existing branch.
  git checkout "$EXISTING_PR_BRANCH"
fi

# Add the updated plugins.txt file to the staging area.
git add dockerfiles/plugins.txt

# Amend the latest commit with the changes in the staging area. The commit message is not changed.
git commit --amend --no-edit

# Push the changes to the 'origin' repository. The '-u' option sets the upstream branch to 'origin/HEAD'.
git push -u origin HEAD

# If there is no existing pull request, create a new one.
if [ -z "$EXISTING_PR_BRANCH" ]; then
  gh pr create --title "$PR_TITLE" --body "This pull request updates the Jenkins plugins listed in \`plugins.txt\`." --base "$BASE_BRANCH" --head "$BRANCH_NAME"
fi
