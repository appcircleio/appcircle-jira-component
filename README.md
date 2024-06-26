# Appcircle _Jira Comment_ component

Add comment to Jira Issue and optionally change the status.

## Required Inputs

- `AC_JIRA_HOST`: Jira Host. Your Jira subdomain. Example: `https://mysubdomain.atlassian.net`
- `AC_JIRA_ISSUE`: Jira Issue. The ID or key of the issue. Please check [documentation](https://docs.appcircle.io/workflows/common-workflow-steps/jira-comment) to learn how you can get this information from branch names or commit messages.
- `AC_JIRA_TEMPLATE`: Comment Template. This comment template will be used to post a comment. Variables donated with `$` will be replaced during the build. Refer to [documentation](https://docs.appcircle.io/workflows/common-workflow-steps/jira-comment#changing-template) to modify the template.

## Optional Inputs

- `AC_JIRA_EMAIL`: Email of Jira user. This field is **required** for those using API tokens instead of PAT. Please add this using **locked** environment variables.
- `AC_JIRA_TOKEN`: User's API Token. If this value is filled, the Jira e-mail field must also be filled. Only Jira Cloud users can use API token. You can create token from [here](https://id.atlassian.com/manage-profile/security/api-tokens).
- `AC_JIRA_PAT`: Specify the Personal Access Token (PAT) for Jira authentication. Only Jira On-Prem users can use PAT.
- `AC_JIRA_FAIL_TRANSITION`: Transition ID or name for the failed step. Optionally change the status of your issue if the previous state fails. Ensure that the "Always run this step even if the previous steps fail" switch is enabled for this feature to work.
- `AC_JIRA_SUCCESS_TRANSITION`: Transition ID or name for the successful step. Optionally change the status of your issue if the previous state succeeds.

## Contributing

When contributing to the **Jira Comment** repository, it's important to note that the comment input types depend on the Jira REST API version. Therefore, the repository has different versions in the [Workflow Components](https://github.com/appcircleio/appcircle-workflow-components) repository:

- component version `2.*.*` for Jira API version 2
- component version `3.*.*` for Jira API version 3

Be sure to select the appropriate component version based on the Jira REST API version you are working with. For more detailed information, refer to the [Jira Comment](https://docs.appcircle.io/workflows/common-workflow-steps/jira-comment#jira-rest-api-version-reference) documentation.
