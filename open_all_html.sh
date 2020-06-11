echo ---------------STARTED-----------------


for dir in $(find . -type f)
do
	extension="${dir##*.}"
	if [[ $extension == "html" ]]; then
		code $dir
		echo $dir OPENED 
	fi
done

echo ---------------FINISHED-----------------