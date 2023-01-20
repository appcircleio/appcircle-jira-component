# Appcircle _Jira Comment_ component

Add comment to Jira Issue and optionally change the status.

## Required Inputs

- `AC_JIRA_HOST`: Jira Host. Your Jira subdomain. Example: `mysubdomain.atlassian.net`
- `AC_JIRA_EMAIL`: Jira Email. Email of Jira user. Please add this using **locked** environment variables.
- `AC_JIRA_TOKEN`: API Token. User's API Token. Please add this using **locked** environment variables. You can create your token from [here](https://id.atlassian.com/manage-profile/security/api-tokens)
- `AC_JIRA_ISSUE`: Jira Issue. The ID or key of the issue. Please check [documentation](https://docs.appcircle.io) to learn how you can get this information from branch names or commit messages.
- `AC_JIRA_TEMPLATE`: Comment Template. This comment template will be used to post a comment. Variables donated with `$` will be replaced during the build. Please check [documentation](https://docs.appcircle.io) for more information.

## Optional Inputs

- `AC_JIRA_FAIL_TRANSITION`: Error Transition. Transition ID or name for the failed step. If the previous state succeeds, you can optionally change the status of your issue.
- `AC_JIRA_SUCCESS_TRANSITION`: Success Transition. Transition ID or name for the successful step. If the previous state succeeds, you can optionally change the status of your issue.
