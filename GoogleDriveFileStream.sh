#!/bin/bash

# Variables
SupportContactInfo="the help desk at extension 8988"
dmgfile="GoogDriveFileStream.dmg"
volname="Install Google Drive File Stream"
logfile="/Library/Logs/GoogleDriveFileStreamInstallScript.log"

url='https://dl.google.com/drive-file-stream/GoogleDriveFileStream.dmg'

# Download and Install File Stream
/bin/echo "--" >> ${logfile}
/bin/echo "`date`: Downloading latest version." >> ${logfile}
/usr/bin/curl -s -o /tmp/${dmgfile} ${url}
/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet
/bin/echo "`date`: Installing..." >> ${logfile}
installer -store -pkg "/Volumes/${volname}/GoogleDriveFileStream.pkg" -target /
/bin/sleep 45
# Clean Up
/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet
/bin/sleep 4
/bin/echo "`date`: Deleting disk image." >> ${logfile}
/bin/rm /tmp/"${dmgfile}"
/bin/sleep 3
# Look for Google Drive
if [ -d /Applications/Google\ Drive.app/ ]; then
  /bin/echo "`date`: Found depricated version of Google Drive. Stopping Drive service." >> ${logfile}
  /usr/bin/osascript -e 'tell application "Google Drive" to quit'
  /bin/echo "`date`: Deleting Google Drive Application." >> ${logfile}
  rm -Rf /Applications/Google\ Drive.app/
  /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper  -title "Google Drive Version Found" -windowType hud -description "Google Drive Version Found" -description "While installing Google Drive File Stream we found an older version of Google Drive. Since they are not compatible, we removed the older version. However, you still have data stored in your home folder under Google Drive. These files will no longer be synced, so you should either move them or delete them. If you have any addional questions please reach out to ${SupportContactInfo}." &
fi
/bin/sleep 5
# Launch File Stream
/bin/echo "`date`: Launching File Stream" >> ${logfile}
open -a /Applications/Google\ Drive\ File\ Stream.app/
/bin/echo "`date`: Finished." >> ${logfile}
/bin/sleep 3

exit 0
