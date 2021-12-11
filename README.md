# ZFS-Automatic-Snapshot-Manager
Automatically create rolling snaphots for any ZFS filesystem || dataset which have a user specified maximum expiration date.

## Introduction

This tools was designed to manage the automatic creation and destruction of any zfs snapshot which needs to have a
limited life time. These types of snapshots are extremely useful for rolling backups and disaster recovery
procedures. This lifetime is expressed in a simple and natural way, thanks to Gnu date.
http://www.gnu.org/software/coreutils/

After the lifetime has expired, the expired zfs snapshot is automatically destroyed after it's replacement created. This completes the rolling snapshot cycle. Automation can be easy to implement with a simple cron wrapper. An example is provided below.
