#!/bin/sh
## Joe Nyilas created this.
## ZFS_Snapper

PATH=/sbin:/usr/sbin:/usr/bin:/usr/local/bin
# Automatically generate snaps for critical file systems
# Put in cron for every hour
# Default Setup:
#snap every 1 hours; expire in 48 hours
#snap daily; expire in 1 week
#snap weekly; expire in 1 month
#snap monthly; expire in 4 months

#Critical file systems:
ZFS="DR/backup ZPOOL/jumpstart"

#obtain numerical day of the week: 0=Sunday
DOW=`date +%w`
#obtain numerical month
MM=`date +%m`

#find the last month we ran
if [ -f /usr/local/sbin/.last_snap_month ]; then
        last_mrun=`cat /usr/local/sbin/.last_snap_month`
else
        last_mrun="XX"
fi

# create hourly snap (each time cron fires)
#tagged as Auto_H_ and expiring in 32 hours
# the default modes creates new and destroys expired snaps
./zfs_asm -t Auto_H -e48hour "${ZFS}"

# create daily, weekly, and monthly snaps at noon
hr=`date +%H`
if [ "${hr}" = "12" ]; then
        #daily, expiring in 1 week
        ./zfs_asm -t Auto_D -e1week "${ZFS}"

        #weekly on Monday, expiring in a month
        if [ "${DOW}" -eq 1 ]; then
                ./zfs_asm -t Auto_W -e1month "${ZFS}"
        fi

        if [ "${MM}" != "${last_mrun}" ]; then
                #monthly, expiring in three months
                ./zfs_asm -t Auto_M -e4month "${ZFS}"
                echo "${MM}" > /usr/local/sbin/.last_snap_month
        fi
fi
exit 0
