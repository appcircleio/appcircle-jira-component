# Appcircle _Jira Comment_ component

Add comment to Jira Issue and optionally change the status.

## Required Inputs

- `AC_JIRA_HOST`: Jira Host. Your Jira subdomain. Example: `mysubdomain.atlassian.net`
- `AC_JIRA_ISSUE`: Jira Issue. The ID or key of the issue. Please check [documentation](https://docs.appcircle.io/integrations/jira-integration) to learn how you can get this information from branch names or commit messages.
- `AC_JIRA_TEMPLATE`: Comment Template. This comment template will be used to post a comment. Variables donated with `$` will be replaced during the build.

## Optional Inputs

- `AC_JIRA_EMAIL`: Email of Jira user. This field is **required** for those using API tokens (`AC_JIRA_TOKEN`) instead of PAT. Please add this using **locked** environment variables.
- `AC_JIRA_TOKEN`: User's API Token. Please add this using **locked** environment variables. If this value is set, the Jira e-mail field must be filled for Basic Authentication. You can create your token from [here](https://id.atlassian.com/manage-profile/security/api-tokens).
- `AC_JIRA_PAT`: Specify the Personal Access Token (PAT) for Jira authentication. If you have filled in this field for authentication, you do not need to fill in the `AC_JIRA_TOKEN` and `AC_JIRA_EMAIL` fields.
- `AC_JIRA_REST_API_VERSION`: Specify the REST API version of Jira. Cloud Jira users generally use the latest version (currently `3`) of the API, but Jira enterprise users can use different API versions.
- `AC_JIRA_FAIL_TRANSITION`: Error Transition. Transition ID or name for the failed step. If the previous state succeeds, you can optionally change the status of your issue.
- `AC_JIRA_SUCCESS_TRANSITION`: Success Transition. Transition ID or name for the successful step. If the previous state succeeds, you can optionally change the status of your issue.
