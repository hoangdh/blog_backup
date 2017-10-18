#!/bin/bash
# SMS Notify by HoangDH
#######
#
# Register free account: http://nexmo.com/
#
########

KEY="074ec1e2"
SECRET="d6d8f98d91ed7e59"

if [ "$NOTIFY_WHAT" = "HOST" ]
then
        INFO=$(echo -e "$NOTIFY_HOSTNAME - $NOTIFY_WHAT: $NOTIFY_HOSTSTATE\nAt: $NOTIFY_DATE\n")
else
        INFO=$(echo -e "HOST: $NOTIFY_HOSTNAME - $NOTIFY_WHAT: $NOTIFY_SERVICEDESC - $NOTIFY_SERVICEOUTPUT\nAt: $NOTIFY_DATE\n")
fi


curl -X POST https://rest.nexmo.com/sms/json \
-d api_key=$KEY \
-d api_secret=$SECRET \
-d to=$NOTIFY_CONTACTPAGER \
-d from="NEXMO" \
-d text="$INFO" >> /var/log/hoangsms.log




