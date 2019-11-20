# Ionic Quickstarter
Quickstarter created with Ionic 3.9.2

## Running unit tests
All files with the ending `.spec.ts` in the src folder will be tested with karma

Start unit test with `npm run test`

## Running end-to-end tests
All files with the ending `.e2e-spec.ts` in the e2e folder will be tested with protractor

Start e2e tests with `npm run e2e`

## Environments
The folder src/environments contains a config file for production, development and e2e.

The e2e environment will be injected when doing e2e tests, the production environment when doing a build with --prod and
the development environment with ionic serve / ionic build.

`import {ENV} from '@app/env';` imports the environment into the app

## Ionic Pro
Steps to enable Ionic Pro builds:

- Create a project in the [Ionic Pro Dashboard](https://dashboard.ionicframework.com) --> make sure you create the app in your organisation and not in your users account.
- Add the app id to the `ionic.config.json`
- Open the `Jenkinsfile` and add the username and repo name in Line 73 --> `{{ionic-user}}/{{ionic-project-name}}` (most likely `your-organisation-name/your-project-name-in-lower-case-with-minus-chars-as-spaces.git`)
- Switch the condition in line 62 of the `Jenkinsfile` from `false` to `true` --> it has to be deactivated initially because without the correct setup the initial build would fail

## Openshift Builds
Openshift builds are enabled per default. To disable the builds, set the `openshiftUpload` in the Jenkinsfile to false
