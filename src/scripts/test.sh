#!/bin/bash

VERSION=1.4.0

# Get variables from the environment
HOST=$(circleci env subst "${PARAM_HOST}")
DOMAIN=$(circleci env subst "${PARAM_DOMAIN}")
TIMEOUT=$(circleci env subst "${PARAM_TIMEOUT}")
ADMIN_ACCOUNT_USERNAME=$(circleci env subst "${PARAM_ADMIN_ACCOUNT_USERNAME}")
ADMIN_ACCOUNT_PASSWORD=$(circleci env subst "${PARAM_ADMIN_ACCOUNT_PASSWORD}")
DISABLED_SPECIFICATIONS=$(circleci env subst "${PARAM_DISABLED_SPECIFICATIONS}")
DISABLED_TESTS=$(circleci env subst "${PARAM_DISABLED_TESTS}")
LOG_DIR=$(circleci env subst "${PARAM_LOG_DIR}")

# Download the JAR file
curl -L "https://github.com/XMPP-Interop-Testing/smack-sint-server-extensions/releases/download/v$VERSION/smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar" -o "smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar"

java \
    -Dsinttest.service="$DOMAIN" \
    -Dsinttest.host="$HOST" \
    -Dsinttest.securityMode=disabled \
    -Dsinttest.replyTimeout="$TIMEOUT" \
    -Dsinttest.adminAccountUsername="$ADMIN_ACCOUNT_USERNAME" \
    -Dsinttest.adminAccountPassword="$ADMIN_ACCOUNT_PASSWORD" \
    -Dsinttest.enabledConnections=tcp \
    -Dsinttest.dnsResolver=javax \
    -Dsinttest.disabledSpecifications="$DISABLED_SPECIFICATIONS"  \
    -Dsinttest.disabledTests="$DISABLED_TESTS" \
    -Dsinttest.testRunResultProcessors=org.igniterealtime.smack.inttest.util.StdOutTestRunResultProcessor,org.igniterealtime.smack.inttest.util.JUnitXmlTestRunResultProcessor \
    -Dsinttest.debugger="org.igniterealtime.smack.inttest.util.FileLoggerFactory" \
    -DlogDir="$LOG_DIR" \
    -jar "smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar"
