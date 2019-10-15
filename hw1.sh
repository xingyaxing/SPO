#! /bin/bash
filepath=$(cd $(dirname $0); pwd)
echo "filepath,filename,extension,size(KB),modify date" >> "$filepath/hw.csv"
function file_name() {
	for file in `ls $1`
	do
		path=$1/$file
		if [ -f $path ]
		then
			size=`wc -c $path|awk '{print int($1/1024)}'`
			date=`date -r "$path"`
			echo "$1,${file%.*},${file##*.},$size,$date" >> "$filepath/hw.csv"
		else
			file_name $1/$file
		fi
	done
}
file_name $filepath
