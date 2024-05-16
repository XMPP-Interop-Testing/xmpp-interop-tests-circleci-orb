#!/bin/bash

VERSION=1.0

# Get variables from the environment
IP_ADDRESS=$(circleci env subst "${PARAM_IP_ADDRESS}")
DOMAIN=$(circleci env subst "${PARAM_DOMAIN}")
TIMEOUT=$(circleci env subst "${PARAM_TIMEOUT}")
ADMIN_ACCOUNT_USERNAME=$(circleci env subst "${PARAM_ADMIN_ACCOUNT_USERNAME}")
ADMIN_ACCOUNT_PASSWORD=$(circleci env subst "${PARAM_ADMIN_ACCOUNT_PASSWORD}")
DISABLED_TESTS=$(circleci env subst "${PARAM_DISABLED_TESTS}")

# Download the JAR file
curl -L "https://github.com/XMPP-Interop-Testing/smack-sint-server-extensions/releases/download/v$VERSION/smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar" -o "smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar"

echo "$IP_ADDRESS $DOMAIN" | sudo tee -a /etc/hosts

java \
    -Dsinttest.service="$DOMAIN" \
    -Dsinttest.securityMode=disabled \
    -Dsinttest.replyTimeout="$TIMEOUT" \
    -Dsinttest.adminAccountUsername="$ADMIN_ACCOUNT_USERNAME" \
    -Dsinttest.adminAccountPassword="$ADMIN_ACCOUNT_PASSWORD" \
    -Dsinttest.enabledConnections=tcp \
    -Dsinttest.dnsResolver=javax \
    -Dsinttest.disabledTests="$DISABLED_TESTS" \
    -jar "smack-sint-server-extensions-$VERSION-jar-with-dependencies.jar"
