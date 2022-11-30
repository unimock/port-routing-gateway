#!/bin/bash

echo "#################################################"
echo "# starting container boot up script (start.sh)  #"
echo "#################################################"

cp /usr/share/zoneinfo/${TZ} /etc/localtime
echo "$TZ" > /etc/timezone


if [ "$CRON_STRINGS" != "" ] ; then
  echo -e "$CRON_STRINGS\n"                 > /etc/crontabs/root
#  echo "0 * * * * /usr/local/bin/logrotate" > /etc/crontabs/root
fi


list=$(ls -1 /boot.d/*)
for i in $list ; do
  echo "execute : <$i>"
  $i
  ret=$?
  if [ "$ret" != "0" ] ; then
    echo "error: start script <$i> returns an error <$ret>"
    exit $ret
  fi
done

echo "#################################################"
echo "# start supervisord"
echo "#"

trap 'kill -TERM $PID; wait $PID' TERM
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &
PID=$!
wait $PID


