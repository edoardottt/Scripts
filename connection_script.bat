:: Execute this with admin priviledges
:: This batch file checks for network connection problems
:: and saves the output to a .txt file(connection_stat.txt).
DATE /T >> connection_stat.txt
TIME /T >> connection_stat.txt
:: View network connection details
ipconfig /all >>  connection_stat.txt
::Active connection
netstat -a >> connection_stat.txt
for /F "tokens=3" %%i in (appoggio.txt) do ping %%i >> results.txt 
ECHO ----------------------------------------------------------------------------------------------------------------------------------------------- >> connection_stat.txt