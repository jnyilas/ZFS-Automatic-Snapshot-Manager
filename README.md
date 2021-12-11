# ZFS-Automatic-Snapshot-Manager
Automatically create rolling snaphots for any ZFS filesystem || dataset which have a user specified maximum expiration date.

## Introduction

This tools was designed to manage the automatic creation and destruction of any zfs snapshot which needs to have a
limited life time. These types of snapshots are extremely useful for rolling backups and disaster recovery
procedures. This lifetime is expressed in a simple and natural way, thanks to Gnu date.
http://www.gnu.org/software/coreutils/

After the lifetime has expired, the expired zfs snapshot is automatically destroyed after it's replacement created. This completes the rolling snapshot cycle. Automation can be easy to implement with a simple cron wrapper. An example is provided below.

## Man Page
'''
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
