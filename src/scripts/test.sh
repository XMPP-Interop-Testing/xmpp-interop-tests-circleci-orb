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
ENABLED_SPECIFICATIONS=$(circleci env subst "${PARAM_ENABLED_SPECIFICATIONS}")
ENABLED_TESTS=$(circleci env subst "${PARAM_ENABLED_TESTS}")
LOG_DIR=$(circleci env subst "${PARAM_LOG_DIR}")

# Download the JAR file
curl -L "https://github.com/XMPP-Interop-Testing/smack-sint-server-extensions/releases/download/v$VERSION/smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar" -o "smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar"

JAVACMD=()
JAVACMD+=("java")
JAVACMD+=("-Dsinttest.service=$DOMAIN")
JAVACMD+=("-Dsinttest.host=$HOST")
JAVACMD+=("-Dsinttest.securityMode=disabled")
JAVACMD+=("-Dsinttest.replyTimeout=$TIMEOUT")

if [ "$ADMIN_ACCOUNT_USERNAME" != "" ]; then
JAVACMD+=("-Dsinttest.adminAccountUsername=$ADMIN_ACCOUNT_USERNAME")
fi
if [ "$ADMIN_ACCOUNT_PASSWORD" != "" ]; then
JAVACMD+=("-Dsinttest.adminAccountPassword=$ADMIN_ACCOUNT_PASSWORD")
fi
JAVACMD+=("-Dsinttest.enabledConnections=tcp")
JAVACMD+=("-Dsinttest.dnsResolver=javax")
if [ "$DISABLED_SPECIFICATIONS" != "" ]; then
    JAVACMD+=("-Dsinttest.disabledSpecifications=$DISABLED_SPECIFICATIONS")
fi
if [ "$DISABLED_TESTS" != "" ]; then
    JAVACMD+=("-Dsinttest.disabledTests=$DISABLED_TESTS")
fi
if [ "$ENABLED_SPECIFICATIONS" != "" ]; then
    JAVACMD+=("-Dsinttest.enabledSpecifications=$ENABLED_SPECIFICATIONS")
fi
if [ "$ENABLED_TESTS" != "" ]; then
    JAVACMD+=("-Dsinttest.enabledTests=$ENABLED_TESTS")
fi
JAVACMD+=("-Dsinttest.testRunResultProcessors=org.igniterealtime.smack.inttest.util.StdOutTestRunResultProcessor,org.igniterealtime.smack.inttest.util.JUnitXmlTestRunResultProcessor")
JAVACMD+=("-Dsinttest.debugger=org.igniterealtime.smack.inttest.util.FileLoggerFactory")
JAVACMD+=("-DlogDir=$LOG_DIR")
JAVACMD+=("-jar")
JAVACMD+=("smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar")

"${JAVACMD[@]}"
