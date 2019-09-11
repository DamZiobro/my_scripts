#!/bin/zsh
# Send text through adb by Madura A.
# https://market.android.com/details?id=org.jraf.android.nolock
# Please use the above app(or similar) to keep it from locking while
# using this script

# FIX: Android 4.1.1 suggested by samox86
PATH=$PATH:/system/xbin:/system/bin

# Change path if necessary
ADB=/usr/bin/adb

# If screen is off, turn it on and unlock it (Only works with slide to unlock)
if adb shell dumpsys input_method | grep -q mScreenOn=false; then
	$ADB shell input keyevent 26
	$ADB shell input swipe 250 650 1000 650
	sleep 1
fi

# Check if sms app is already running and close it if it does
test=$($ADB shell ps | grep com.android.mms | awk '{print $9}');
if [ ! -z $test  ]; then
        $ADB shell am force-stop com.android.mms
fi

# Launch an intent to send an sms with the number and text passed in parameters
$ADB shell am start -a android.intent.action.SENDTO -d sms:$1 --es sms_body "$2" --ez exit_on_sent true
sleep 1

# Press send button
$ADB shell input keyevent 22
sleep 1
$ADB shell input keyevent 66
