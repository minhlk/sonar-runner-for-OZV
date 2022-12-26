#!/bin/bash

# Set the base branch and commit information
BASE_BRANCH_NAME="master"

# Set the SonarQube server URL and token
SONAR_URL="http://localhost:9000"
SONAR_TOKEN="sqp_0fa8561c119afbd544833c77c4deef3b2e3b39e6"

# Set the GitHub repository information
GITHUB_REPOSITORY="test-project"

# Set the location of the SonarQube project properties file
SONAR_PROJECT_PROPERTIES="sonar-project.properties"

# Set the location of the Git executable
GIT_EXECUTABLE="git"

# Set the list of options and corresponding project paths
options=(
    "aslan"
    "maple"
    "apollo"
    "woodstock"
    "spitz"
    "app-server-side"
)
project_paths=(
    "/Users/minh/Hapitas/aslan"
    "/Users/minh/Hapitas/aslan"
    "/Users/minh/Hapitas/apollo"
    "/Users/minh/Hapitas/woodstock"
    "/Users/minh/Hapitas/spitz"
    "/Users/minh/Hapitas/app-server-side"
)

# Prompt the user to select a project
PS3='Please enter your choice: '
select opt in "${options[@]}"
do
    if [[ "$REPLY" -le ${#options[@]} ]]; then
        SOURCE_FOLDER=${project_paths[$((REPLY-1))]}
        break
    else
        echo "Invalid option $REPLY"
    fi
done

# Prompt the user to enter the branch to compare
echo "What base branch?"
read BASE_BRANCH_NAME

# Prompt the user to enter the branch to compare
echo "What branch to compare?"
read BRANCH_NAME

# Set the current path and create a file_changes directory
CURRENT_PATH=$PWD
rm -rf file_changes && mkdir file_changes

# Change to the project directory and get the list of modified files
cd "$SOURCE_FOLDER"
MODIFIED_FILES=$($GIT_EXECUTABLE diff --name-only "$BASE_BRANCH_NAME".."$BRANCH_NAME" | xargs -I{} cp {} "$CURRENT_PATH/file_changes")

# Return to the current path and set the modified files list
cd "$CURRENT_PATH"
MODIFIED_FILES=$(ls -d "$CURRENT_PATH/file_changes"/* | tr '\n' ',')

# Set the SonarQube project properties
echo "sonar.projectKey=${GITHUB_REPOSITORY}" > "$SONAR_PROJECT_PROPERTIES"
echo "sonar.host.url=${SONAR_URL}" >> "$SONAR_PROJECT_PROPERTIES"
echo "sonar.login=${SONAR_TOKEN}" >> "$SONAR_PROJECT_PROPERTIES"
echo "sonar.sources=${MODIFIED_FILES}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.scm.exclusions.disabled=true" >> $SONAR_PROJECT_PROPERTIES


# Run the SonarQube Scanner
sonar-scanner \
    -Dsonar.projectBaseDir=$CURRENT_PATH \
    -Dsonar
