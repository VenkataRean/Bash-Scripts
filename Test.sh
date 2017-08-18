#!/bin/bash
set -x
#define the log file
log_file=$1
# define logrotate configuration file here
logrotate_conf_file=$2
#define Name of S3 Bucket
S3_BUCKET_NAME=$3
#define the Path of local to cp log file
local_path=$4
#define the number of days file u want to list
days=$5
#define the Function
take1=$6
take2=$7
take3=$8
take4=$9
do_processing()
{	
#Locate the Log file
logfile=`sudo find /home $log_file -type f -mtime +$days | grep $log_file`
case "$take1" in
	"copytos3" | "COPYTOS3")
		#Copy rotate file to s3 bucket
		aws s3 cp $logfile s3://$S3_BUCKET_NAME/`date +%Y-%m-%d`/
		;;
	"copytolocal" | "COPYTOLOCAL")
		#Copy the log file to local path
		cp $logfile $local_path
		;;
	"truncate" | "TRUNCATE")
		#Copy log file into the rotate log files
		logrotate $logrotate_conf_file

		#Truncate existing log files
		truncate -s 0 $logfile
		;;
	"REMOVE" | "DELETE" | "remove" | "delete")
		#Remove rotating log files from the instance
		rm -rf $logfile
		;;
esac
case "$take2" in
	"copytos3" | "COPYTOS3")
		#Copy rotate file to s3 bucket
		aws s3 cp $logfile s3://$S3_BUCKET_NAME/`date +%Y-%m-%d`/
		;;
	"copytolocal" | "COPYTOLOCAL")
		#Copy the log file to local path
		cp $logfile $local_path
		;;
	"truncate" | "TRUNCATE")
		#Copy log file into the rotate log files
		logrotate $logrotate_conf_file

		#Truncate existing log files
		truncate -s 0 $logfile
		;;
	"REMOVE" | "DELETE" | "remove" | "delete")
		#Remove rotating log files from the instance
		rm -rf $logfile
		;;
esac
case "$take3" in
	"copytos3" | "COPYTOS3")
		#Copy rotate file to s3 bucket
		aws s3 cp $logfile s3://$S3_BUCKET_NAME/`date +%Y-%m-%d`/
		;;
	"copytolocal" | "COPYTOLOCAL")
		#Copy the log file to local path
		cp $logfile $local_path
		;;
	"truncate" | "TRUNCATE")
		#Copy log file into the rotate log files
		logrotate $logrotate_conf_file

		#Truncate existing log files
		truncate -s 0 $logfile
		;;
	"REMOVE" | "DELETE" | "remove" | "delete")
		#Remove rotating log files from the instance
		rm -rf $logfile
		;;
esac
case "$take4" in
	"copytos3" | "COPYTOS3")
		#Copy rotate file to s3 bucket
		aws s3 cp $logfile s3://$S3_BUCKET_NAME/`date +%Y-%m-%d`/
		;;
	"copytolocal" | "COPYTOLOCAL")
		#Copy the log file to local path
		cp $logfile $local_path
		;;
	"truncate" | "TRUNCATE")
		#Copy log file into the rotate log files
		logrotate $logrotate_conf_file

		#Truncate existing log files
		truncate -s 0 $logfile
		;;
	"REMOVE" | "DELETE" | "remove" | "delete")
		#Remove rotating log files from the instance
		rm -rf $logfile
		;;
esac

}
do_processing
