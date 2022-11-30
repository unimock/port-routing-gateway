#!/bin/bash

if [ -f /var/users/$USER.config ] ; then
  . /var/users/$USER.config
fi
if [ "$USERS_TYPE" = "service" ] ; then
  /usr/local/bin/chs state
  echo ""
  echo "Use \"chs\" for managing the system."
  echo ""
fi

