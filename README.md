# Appcircle _Jira Comment_ component

Add comment to Jira Issue and optionally change the status.

## Required Inputs

- `AC_JIRA_HOST`: Jira Host. Your Jira subdomain. Example: `mysubdomain.atlassian.net`
- `AC_JIRA_ISSUE`: Jira Issue. The ID or key of the issue. Please check [documentation](https://docs.appcircle.io/integrations/jira-integration) to learn how you can get this information from branch names or commit messages.
- `AC_JIRA_TEMPLATE`: Comment Template. This comment template will be used to post a comment. Variables donated with `$` will be replaced during the build.
- `AC_JIRA_REST_API_VERSION`: Specify the REST API version of Jira. Cloud Jira users generally use the latest version (currently `3`) of the API, but Jira enterprise users can use different API versions. To modify the Jira API version, simply adjust it in the component version. For instance, to utilize API version `2`, update the component version to `2.*.*`. Explore the [Jira comment documentation](https://docs.appcircle.io/workflows/common-workflow-steps/jira-component) for further details.

## Optional Inputs

- `AC_JIRA_EMAIL`: Email of Jira user. This field is **required** for those using API tokens (`AC_JIRA_TOKEN`) instead of PAT. Please add this using **locked** environment variables.
- `AC_JIRA_TOKEN`: User's API Token. Please add this using **locked** environment variables. If this value is set, the Jira e-mail field must be filled for Basic Authentication. You can create your token from [here](https://id.atlassian.com/manage-profile/security/api-tokens).
- `AC_JIRA_PAT`: Specify the Personal Access Token (PAT) for Jira authentication. If you have filled in this field for authentication, you do not need to fill in the `AC_JIRA_TOKEN` and `AC_JIRA_EMAIL` fields.
- `AC_JIRA_FAIL_TRANSITION`: Error Transition. Transition ID or name for the failed step. If the previous state succeeds, you can optionally change the status of your issue.
- `AC_JIRA_SUCCESS_TRANSITION`: Success Transition. Transition ID or name for the successful step. If the previous state succeeds, you can optionally change the status of your issue.

## Contributing

When contributing to the **Jira Comment** repository, it's important to note that the comment input types depend on the Jira REST API version. Therefore, the repository has different versions in the [Workflow Components repository](https://github.com/appcircleio/appcircle-workflow-components): component version `2.*.*` for Jira API version 2 and component version `3.*.*` for Jira API version 3. Be sure to select the appropriate component version based on the Jira REST API version you are working with. For more detailed information, refer to the [Jira Comment](https://docs.appcircle.io/workflows/common-workflow-steps/jira-comment/#jira-rest-api-version-reference) documentation.