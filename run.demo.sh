# Set the location of the SonarQube Scanner
SONAR_SCANNER_HOME="/path/to/sonar-scanner"

# Set the SonarQube server URL and token
SONAR_URL="https://sonarqube.example.com"
SONAR_TOKEN="YOUR_SONARQUBE_TOKEN"

# Set the GitHub repository information
SOURCE_FOLDER_LOCATION="owner/repository"

# Set the branch and commit information
BRANCH_NAME="branch_name"

# Set the location of the SonarQube project properties file
SONAR_PROJECT_PROPERTIES="/path/to/sonar-project.properties"

# Set the location of the Git executable
GIT_EXECUTABLE="/path/to/git"

# Get the list of modified files in the current branch compared to the master branch
MODIFIED_FILES=$($GIT_EXECUTABLE diff --name-only master..$BRANCH_NAME | tr '\n' ',')

# Set the SonarQube project properties
SOURCE_echo "sonar.projectKey=${FOLDER_LOCATION}" > $SONAR_PROJECT_PROPERTIES
echo "sonar.host.url=${SONAR_URL}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.login=${SONAR_TOKEN}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.sources=${MODIFIED_FILES}" >> $SONAR_PROJECT_PROPERTIES
echo "sonar.exclusions=**/vendor/**,**/node_modules/**" >> $SONAR_PROJECT_PROPERTIES

# Run the SonarQube Scanner
${SONAR_SCANNER_HOME}/bin/sonar-scanner \
    -Dsonar.projectBaseDir=$PWD \
    -Dsonar
