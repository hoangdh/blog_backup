#!/bin/bash
# SMS Notify by HoangDH
#######
#
# Register free account: http://nexmo.com/
#
########

KEY="XXXXXXXX"
SECRET="XXXXXXXXXXXXXXX"

if [ "$NOTIFY_WHAT" == "SERVICE" ]
then
	INFO=$(echo -e "HOST: $NOTIFY_HOSTNAME - $NOTIFY_WHAT: $NOTIFY_SERVICEDESC - $NOTIFY_SERVICEOUTPUT At: $NOTIFY_SHORTDATETIME")
else	
	INFO=$(echo -e "$NOTIFY_HOSTNAME - $NOTIFY_WHAT: $NOTIFY_HOSTSTATE At: $NOTIFY_SHORTDATETIME")
fi

curl -X POST https://rest.nexmo.com/sms/json \
-d api_key=$KEY \
-d api_secret=$SECRET \
-d to=$NOTIFY_CONTACTPAGER \
-d from="NEXMO" \
-d text="$INFO" >> /var/log/api_sms_gateway.log

echo $INFO >> /var/log/omd_notify_sms.log