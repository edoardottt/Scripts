for dir in $(ls -d $(pwd)/*/)
do
	echo ==== $dir ====
	cd $dir
	git pull
done