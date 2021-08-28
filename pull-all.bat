Rem NOT WORKING
FOR %%directory IN (dir /b /a:d) DO (
	cd %directory%
	git pull
	cd ..)