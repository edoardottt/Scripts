for dir in $(ls -d $(pwd)/*/)
do
	echo ==== $dir ====
	cd $dir
	git config pull.rebase false
	echo done!
done
