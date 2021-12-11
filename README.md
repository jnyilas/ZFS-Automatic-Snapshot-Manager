# ZFS-Automatic-Snapshot-Manager
Automatically create rolling snaphots for any ZFS filesystem || dataset which have a user specified maximum expiration date.

## Introduction

This tools was designed to manage the automatic creation and destruction of any zfs snapshot which needs to have a
limited life time. These types of snapshots are extremely useful for rolling backups and disaster recovery
procedures. This lifetime is expressed in a simple and natural way, thanks to Gnu date.
http://www.gnu.org/software/coreutils/

After the lifetime has expired, the expired zfs snapshot is automatically destroyed after it's replacement created. This completes the rolling snapshot cycle. Automation can be easy to implement with a simple cron wrapper. An example is provided below.

## Man Page

	NAME
		zfs_asm - ZFS Automatic Snapshot Manager
	SYNOPSIS
		zfs_asm [OPTION]... [ZFS_NAME]...

    DESCRIPTION
	Automatically create rolling snaphots for all (or any) specified ZFS
	filesystem which have a specified maximum expiration lifetime.
	This lifetime is expressed in a simple and natural way; 1hour, 6day,
	etc. The general form is N<unit>, where N is a positive integer and
	<unit> is any one of {sec min hour day week month year}.
	The default operation mode is as follows: A new snapshot is created
	for the specified ZFS having an expiration date "1day" in the
	future, and tagged with the name "Auto_D". After the successful
	creation of the snapshot, any managed and expired snapshots matching
	the tag on the specified (or all) ZFS are automatically destroyed.
	The default operation can be modified using the following options:
    
    OPTIONS
	-l
	   List mode: Just report on managed snapshots

	-L
	   Filtered List mode: Just report on expired managed snapshots

	-s
	   Snapshot mode: Just create new snapshots

	-d
	   Destroy mode: Just destroy expired snapshots

	-D
	   DESTROY mode: Use with caution.  Destroy *ALL* snapshots

	-t
	   Specify custom descriptive tag for the snapshot

	-e
	   Specify custom expiration date for the snapshot

	-a
	   Consider only mounted ZFS datasets and not a specified ZFS
	   When in list mode, report on all tags, too

	-A
	   Consider all ZFS datasets (including unmounted) and not a specified ZFS
	   When in list mode, report on all tags, too

	-f
	   Forcibly deletes unexpired snapshots matching the tag

	-r
	   Use recursion for snapshot creation and destruction

	-v
	   Verbose


## Examples

List all managed snapshots:

    ./zfs_asm  -al
                           Snapshot       Created         Expires           RIP
          DR/backup/kungfu@_M_:1332433727 22-Feb-12 11:28 22-Mar-12 12:28:47
          DR/backup/kungfu@_D_:1331414046 25-Feb-12 16:14 10-Mar-12 16:14:06 *
          DR/backup/kungfu@_D_:1331582495 27-Feb-12 15:01 12-Mar-12 16:01:35 *
          DR/backup/kungfu@_M_:1339009238 06-Mar-12 14:00 06-Jun-12 15:00:38
          DR/backup/kungfu@_D_:1332284791 06-Mar-12 18:06 20-Mar-12 19:06:31

Note that two snapshots have expired. Upon the next invocation using the default operating mode (create a new snapshot and destroyed expired ones), the expired snapshots will be destroyed.

Next, lets create a new daily snapshot tagged _D_. The default expiration, unless specified is 1 day:

    ./zfs_asm  -t _D_ DR/backup/kungfu

Here, we can see the new snapshot created (13-Mar)  and observe the expired snaps have been reaped automatically:

    ./zfs_asm  -al
                           Snapshot       Created         Expires           RIP
          DR/backup/kungfu@_M_:1332433727 22-Feb-12 11:28 22-Mar-12 12:28:47
          DR/backup/kungfu@_M_:1339009238 06-Mar-12 14:00 06-Jun-12 15:00:38
          DR/backup/kungfu@_D_:1332284791 06-Mar-12 18:06 20-Mar-12 19:06:31
          DR/backup/kungfu@_D_:1331750917 13-Mar-12 14:48 14-Mar-12 14:48:37

 Want to automate it? Put it in cron.hourly||cron.daily with a wrapper and edit it to your liking.
