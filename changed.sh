#!/bin/bash
#set -x
usage()
{
	echo "Usage: $0 [-l <name_of_logfile>][-d <1..730>][-n <option_name_of_bucket>][-p <option_local_path>][-x <option_log_rotate>][-f <fetch|find_logfile>][-s <option_copy_to_s3>][-c <option_copy_to_local>][-t <option_truncate>][-r <option_remove>]" 1>&2;
exit 1;
}
fetch()
{
        if [ -n "$log_file" ] && [ -n "$days" ]; then
		logfile=`sudo find /home $log_file -type f -mtime +$days | grep $log_file`;
		echo "Fetching was done";
	else
		echo "Both name of <-l arg..>log file and number of days <-d ..> older should be specified" && usage;
	fi
}
copytos3()
{
        #Copy rotate file to s3 bucket
	if [ -n "$logfile" ] && [ -n "$S3_BUCKET_NAME" ]; then
		aws s3 cp $logfile s3://$S3_BUCKET_NAME/`date +%Y-%m-%d`/;
		echo "File has been copied to s3";
	else
		echo "Check that aws was configured, existance of bucket, fetching <-f> the log file <-l arg..> and name of s3 buckect <-n arg..> must be specified" && usage;
	fi
}
copytolocal()
{
        #Copy the log file to local path
        if [ -n "$logfile" ] && [ -n "$local_path" ]; then
		cp $logfile $local_path;
		echo "File has been copied to local path";
	else
		echo "Both fetching <-f> the log file <-l arg..> and local path <-p arg> to copy must be specified" && usage;
	fi
}
truncate()
{
	#Copy log file into the rotate log files
	logrotate $logrotate_conf_file;
	echo "logrotate is done";
	#Truncate existing log files
	if [ -n "$logfile" ]; then
		truncate -s 0 $logfile;
		echo "truncate is done";
	else
		echo "fetching <-f> the log file <-l arg..> must be specified" && usage;
	fi
}
remove()
{
	#Remove rotating log files from the instance
	if [ -n "$logfile" ]; then
		rm -rf $logfile;
		echo "file was removed from location";
	else
		echo "fetching <-f> the log file <-l arg..> must be specified" && usage;
	fi
}
											
while getopts ":l:d:n:p:x:fsctr" take1 ; do
case "$take1" in
	l)
		# Checking whether argument is valid
		if ! [ `expr "$str" : ".*[^a-zA-Z0-9_.,-].*"` -gt 0 ]
		then 
			log_file=$OPTARG
		else
			echo "Given an INVALID Argument, Should be a alphanumeric and symblos _ . , -" && usage
		fi
		;;
	d)
		# Checking whether argument is valid
		if [ ${OPTARG} -gt 0 ] && [ ${OPTARG} -le 750 ]
		then
			days=$OPTARG	
		else
			echo "Entered an invalid option" && usage
		fi
		;;
	n)
		# Checking whether argument is valid
		if ! [ `expr "$str" : ".*[^a-zA-Z0-9_.,-].*"` -gt 0 ] 
		then 
			S3_BUCKET_NAME=$OPTARG
		else
			echo "Given an INVALID Argument, Should be a alphanumeric and symblos _ . , -" && usage
		fi
		;;
	p)
		local_path=$OPTARG
		;;
	x)
		logrotate_conf_file=$OPTARG
		;;
	f)
		fetch
		;;	
	s)
		copytos3
		;;
	c)
		copytolocal
		;;
	t)
		truncate
		;;
	r)
		remove
		;;
	*)
		usage
esac
done
#shift $((OPTIND-1))
