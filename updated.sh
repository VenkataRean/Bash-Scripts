#!/bin/bash
set -x
usage()
{
	echo "Usage: $0 [-l <name_of_logfile>][-d <1..730>][-n <option_name_of_bucket>][-p <option_local_path>][-x <option_log_rotate>][-f <fetch|find_logfile>][-s <option_copy_to_s3>][-c <option_copy_to_local>][-t <option_truncate>][-r <option_remove>]" 1>&2;
exit 1;
}

while getopts l:d:n:p:x:fsctr take1 ; do
case "$take1" in
	l)
		# Checking whether argument is valid
		if ! [ `expr "$str" : ".*[^a-zA-Z0-9_.,-].*"` -gt 0 ]
		then 
			log_file=$OPTARG
		else
			echo "Given an INVALID Argument, Should be a alphanumeric and symblos _ . , -"
		fi
		;;
	d)
		# Checking whether argument is valid
		if [ ${OPTARG} -gt 0 ] && [ ${OPTARG} -le 750 ]
		then
			days=$OPTARG	
		else
			echo "Entered an invalid option"
		fi
		;;
	n)
		# Checking whether argument is valid
		if ! [ `expr "$str" : ".*[^a-zA-Z0-9_.,-].*"` -gt 0 ] 
		then 
			S3_BUCKET_NAME=$OPTARG
		else
			echo "Given an INVALID Argument, Should be a alphanumeric and symblos _ . , -"
		fi
		;;
	p)
		local_path=$OPTARG
		;;
	x)
		logrotate_conf_file=$OPTARG
		;;
	f)
		logfile=`sudo find /home $log_file -type f -mtime +$days | grep $log_file`
		;;	
	s)
		#Copy rotate file to s3 bucket
		aws s3 cp $logfile s3://$S3_BUCKET_NAME/`date +%Y-%m-%d`/
		;;
	c)
		#Copy the log file to local path
		cp $logfile $local_path
		;;
	t)
		#Copy log file into the rotate log files
		logrotate $logrotate_conf_file

		#Truncate existing log files
		truncate -s 0 $logfile
		;;
	r)
		#Remove rotating log files from the instance
		rm -rf $logfile
		;;
	*)
		usage
esac
done

shift $((OPTIND-1))
