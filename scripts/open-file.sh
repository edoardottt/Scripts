echo -n "Enter extension: "
read extension
echo ---------------STARTED-----------------


for dir in $(find . -type f)
do
	ext="${dir##*.}"
	if [[ $ext == $extension ]]; then
		code $dir
		echo $dir OPENED 
	fi
done

echo ---------------FINISHED-----------------