SOURCE_FOLDER=""

# TODO: Change configuration here
PS3='Please enter your choice: '
options=("mkproduction" "aslan" "maple" "apollo" "woodstock" "spitz" "app-server-side")
select opt in "${options[@]}"
do
    case $opt in
        "aslan")
            echo "you chose choice $REPLY which is $opt"
            SOURCE_FOLDER="/Users/minh/Hapitas/aslan"
            break;
            ;;
        "maple")
            echo "you chose choice $REPLY which is $opt"
            SOURCE_FOLDER="/Users/minh/Hapitas/aslan"
            break;
            ;;
        "apollo")
            echo "you chose choice $REPLY which is $opt"
            SOURCE_FOLDER="/Users/minh/Hapitas/apollo"
            break;
            ;;
        "woodstock")
            echo "you chose choice $REPLY which is $opt"
            SOURCE_FOLDER="/Users/minh/Hapitas/woodstock"
            break;
            ;;
        "spitz")
            echo "you chose choice $REPLY which is $opt"
            SOURCE_FOLDER="/Users/minh/Hapitas/spitz"
            break;
            ;;
        "app-server-side")
            echo "you chose choice $REPLY which is $opt"
            SOURCE_FOLDER="/Users/minh/Hapitas/app-server-side"
            break;
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo "What base branch?"
read BASE_BRANCH_NAME

# Set the branch and commit information
echo "What branch to compare?"
read BRANCH_NAME

# Set the SonarQube server URL and token
# TODO: Change configuration here
SONAR_URL="http://localhost:9000"
# TODO: Change configuration here
SONAR_TOKEN="sqp_0fa8561c119afbd544833c77c4deef3b2e3b39e6"
# TODO: Change configuration here
# Set the GitHub repository information
GITHUB_REPOSITORY="test-project"

# Set the location of the SonarQube project properties file
SONAR_PROJECT_PROPERTIES="sonar-project.properties"

# Set the location of the Git executable
GIT_EXECUTABLE="git"

CURRENT_PATH=$PWD
rm -rf file_changes && mkdir file_changes

# Get the list of modified files in the current branch compared to the master branch
cd $SOURCE_FOLDER
for name in $($GIT_EXECUTABLE diff --name-only $BASE_BRANCH_NAME..$BRANCH_NAME); do cp $name $CURRENT_PATH/file_changes ; done
cd $CURRENT_PATH
MODIFIED_FILES=$(ls -d $CURRENT_PATH/file_changes/* | tr '\n' ',')

# Set the SonarQube project properties
echo "sonar.projectKey=${GITHUB_REPOSITORY}" > $SONAR_PROJECT_PROPERTIES
echo "sonar.host.url=${SONAR_URL}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.login=${SONAR_TOKEN}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.sources=${MODIFIED_FILES}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.scm.exclusions.disabled=true" >> $SONAR_PROJECT_PROPERTIES


# Run the SonarQube Scanner
sonar-scanner \
    -Dsonar.projectBaseDir=$CURRENT_PATH \
    -Dsonar
