# xmpp-interop-tests-circleci-orb

[![CircleCI Build Status](https://circleci.com/gh/XMPP-Interop-Testing/xmpp-interop-tests-circleci-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/XMPP-Interop-Testing/xmpp-interop-tests-circleci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/xmpp-interop-tests/test.svg)](https://circleci.com/developer/orbs/orb/xmpp-interop-test/test) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/XMPP-Interop-Testing/xmpp-interop-tests-circleci-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

A CircleCI Orb that performs XMPP interoperability tests on an XMPP domain.

For more information, please visit our project website at https://xmpp-interop-testing.github.io/

## Test Account Provisioning

The Orb will typically execute various tests. Each test will use a fresh set of XMPP user accounts. These are
automatically provisioned by the testing framework. They will be removed after the test execution.

The following strategies for test account provisioning are supported:

- By default, the test accounts are provisioned using XMPP's "In-band Registration" functionality (as defined in
  [XEP-0077](https://xmpp.org/extensions/xep-0077.html)).
- Alternatively, test accounts can be provisioned using XMPP 'Ad-hoc commands', as specified in
  [XEP-0133: Service Administration](https://xmpp.org/extensions/xep-0133.html). To enable this way of provisioning, the
  Orb's configuration must include the optional `adminAccountUsername` and `adminAccountPassword` inputs (as
  documented below).

## Inputs

The Orb can be configured using the following inputs:

- `host`: IP address or DNS name of the XMPP service to run the tests on. Default value: `127.0.0.1`
- `domain`: the XMPP domain name of server under test. Default value: `example.org`
- `timeout`: the amount of milliseconds after which an XMPP action (typically an IQ request) is considered timed out. Default value: `5000` (five seconds)
- `adminAccountUsername`: _(optional)_ The account name of a pre-existing user that is allowed to create other users, per [XEP-0133](https://xmpp.org/extensions/xep-0133.html). See: "[Provisioning Test Accounts](#provisioning-test-accounts)"
- `adminAccountPassword`: _(optional)_ The password of the admin account.
- `accountOneUsername`: _(optional)_ The first account name of a set of three accounts used for testing. See: "[Provisioning Test Accounts](#provisioning-test-accounts)"
- `accountOnePassword`: _(optional)_ The password of the accountOneUsername account.
- `accountTwoUsername`: _(optional)_ The second account name of a set of three accounts used for testing. See: "[Provisioning Test Accounts](#provisioning-test-accounts)"
- `accountTwoPassword`: _(optional)_ The password of the accountTwoUsername account
- `accountThreeUsername`: _(optional)_ The third account name of a set of three accounts used for testing. See: "[Provisioning Test Accounts](#provisioning-test-accounts)"
- `accountThreePassword`: _(optional)_ The password of the accountThreeUsername account.
- `disabledTests`: _(optional)_ A comma-separated list of tests that are to be skipped. For example: `EntityCapsTest,SoftwareInfoIntegrationTest`
- `disabledSpecifications`: _(optional)_ A comma-separated list of specifications (not case-sensitive) that are to be skipped. For example: `XEP-0045,XEP-0060`
- `enabledTests`: _(optional)_ A comma-separated list of tests that are to be run. For example: `EntityCapsTest,SoftwareInfoIntegrationTest`
- `enabledSpecifications`: _(optional)_ A comma-separated list of specifications (not case-sensitive) that are to be run. For example: `XEP-0045,XEP-0060`
- `failOnImpossibleTest`: _(optional)_ If set to 'true', fails the test run if any configured tests were impossible to execute. (default: 'false')
- `logDir`: _(optional)_ The directory in which the test output and logs are to be stored. This directory will be created, if it does not already exist. Default value: `./output`

### Provisioning Test Accounts

To be able to run the tests, the server that is being tested needs to be provisioned with test accounts. Three different mechanisms can be used for this:
- **Admin Account** - By configuring the username and password of a pre-existing administrative user, using the `adminAccountUsername` and `adminAccountPassword` configuration options, three test accounts will be created using [XEP-0133: Service Administration](https://xmpp.org/extensions/xep-0133.html) functionality.
- **Explicit Test Accounts** - You can configure three pre-existing accounts that will be used for testing, using the `accountOneUsername`, `accountOnePassword`, `accountTwoUsername`, `accountTwoPassword`, `accountThreeUsername` and `accountThreePassword` configuration options.
- **In-Band Registration** - If no admin account and no explicit test accounts are provided, in-band registration ([XEP-0077](https://xmpp.org/extensions/xep-0077.html)) will be used to provision accounts.

For more information on provisioning accounts, consult the ['Test Account Provisioning' guide](https://xmpp-interop-testing.github.io/documentation/provisioning-accounts).

## Basic Configuration

```yaml
- xmpp-interop-tests/test:
    host: 127.0.0.1
    domain: example.org
    timeout: 5000
    adminAccountUsername: admin
    adminAccountPassword: password
    disabledTests: EntityCapsTest,SoftwareInfoIntegrationTest
    enabledSpecifications: XEP-0352
    logDir: ./logs
```

## Usage Example

It is expected that this Orb is used in a continuous integration flow that creates a new build of the XMPP server
that is to be the subject of the tests.

Very generically, the xmpp-interop-tests-circleci-orb is expected to be part of such a flow in this manner:

1. Compile and build server software
2. Start server
3. **Invoke xmpp-interop-tests-circleci-orb**

This could look something like the flow below. Note that all but the third step in this flow are placeholders. They need to be replaced by steps that are specific to the server that is being build and tested.

```yaml
description: >
  Run an interop tests step as part of an XMPP server build process

usage:
  version: 2.1

  orbs:
    interop-tests: xmpp-interop-tests/test@9.9.9

  jobs:
    build:
      docker:
        - image: cimg/base:2024.02
      steps:
        - run: echo "Build your server here"
        - persist_to_workspace:
            paths:
              - ./my-server
    test:
      docker:
        - image: cimg/openjdk:17.0
      steps:
        - attach_workspace:
          at: .
        - run:
            command: ./my-server/run.sh
            background: true
        - interop-tests/test:
            host: 127.0.0.1
            domain: example.org
            timeout: 5000
            adminAccountUsername: admin
            adminAccountPassword: password
            disabledTests: EntityCapsTest,SoftwareInfoIntegrationTest

  workflows:
    build-and-test-my-server:
      jobs:
        - build
        - test:
            requires:
              - build
```
