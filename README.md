## sonar-runner-for-OZV
This is a script that can be used to run a SonarQube analysis on modified files in a Git repository. It is designed to be used with the OZV project.

### Prerequisites
Before running the script, you will need to configure the following variables:

```
SONAR_URL: The URL of the SonarQube server.
SONAR_TOKEN: The SonarQube token used to authenticate the analysis.
GITHUB_REPOSITORY: The name of the GitHub repository.
SONAR_PROJECT_PROPERTIES: The path to the SonarQube project properties file.
GIT_EXECUTABLE: The path to the Git executable.
```

### First setup
1. Run `make main`
2. Access http://localhost:9000
3. Change admin password (Default: admin/admin)
4. Create project name and project key (Default: `test-project`)
5. Set SONAR_TOKEN in `run.sh` file after Sonar generated token from admin page.
6. Run `make start`

### Note
- Make sure base branch and compared branch are up to date.

### License
This project is licensed under the MIT License - see the LICENSE file for details.
