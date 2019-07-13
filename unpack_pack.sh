#!/bin/bash
directory="$(pwd)"/$1 #directory in input
if [ $# -gt 1 ]; then
	echo "Uso: 2.sh [dir]" #troppi argomenti passati in input
	exit 10
fi

if [[ $# -gt 0 ]];
	then
	if [[ ! -d $directory ]]; then
		echo "La directory $1 non esiste" #controllo se directory in input esiste
		exit 20
	fi
fi

if [[ $# -gt 0 ]];
	then
	if [[ ! -r $directory ]]; then
		echo "Impossibile leggere la directory $1" #directory senza diritti di accesso in lettura
		exit 30
	fi
fi

if [[ -z $1 ]]; then #campo input vuoto
	dir="."
elif [[ ! -z $1 ]]; then #campo input con directory
	dir=$directory
fi

cd $dir
#--------------------------------------------------------------------------------------------------------------------------------------------
#UNTIL HERE DIR INPUT CHECKING/////////////////////////////////////////////////////
#--------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------
#TAR///////
#------------------------------

for file in $( find $dir -name "*.tar" ) 																#lista nomi file .tar
	do
	mkdir ${file: 0 : -4} 																								#crea directory con il suo nome senza estensione
	source=$file																													#source = file esaminato
	dest=${file: 0 : -4}																									#dest = directory appena creata
	mv $source $dest																											#sposta il file dentro la nuova directory
	dest2=$dest/$(basename $source)																				#dest2=dest/source
	cd $dest																															#muoviti in dest
	tar -xf $dest2																												#estrai il contenuto del file
	tar=0																																	#ciclo for con tar=0.
	for var in $(ls -A1)																									#conta quanti elementi ci sono nel file
		do
		tar=$((tar+1))
		done
	if [[ $tar == 2 ]]; then																							#se (oltre al file non decompattato)
		for variable in $(ls -A1)																						#c'è solo un elemento: 1) controlla che il file
			do																																#esaminato non sia il file non decompattato e :
			if [[ ! ${variable: -4} == .tar ]]; then													#1a) se è un file, parentdest=cartella superiore
				if [[ ! -d $variable ]]; then																		#newdir = dest[0,-1]
							parentdest="$( dirname "$dest")"													#rinomina dest con newdir
							newdir=${dest: 0 : -1}																		#muovi il file nella cartella parentdest
							mv $dest $newdir																					#spostati nella cartella parentdest e rimuovi
							mv $variable $parentdest																	#newdir.
							cd $parentdest																						#infine modifica secondo le regole descritte
							rm -Rf $newdir																						#il nome del file decompattato
							variable2=$(basename $source).$variable
							cd $parentdest
							mv $variable $variable2

				elif [[ -d $variable ]]; then																		#1b) se è una directory, parentdest = cartella superiore
					parentdest="$(dirname "$dest")"																#newdir = dest[0,-1], rinomina dest con newdir
					newdir=${dest: 0 : -1}																				#sposta la cartella in parentdest
					mv $dest $newdir																							#archive= nome del file esaminato
					mv $variable $parentdest																			#sposta il file compattato esaminato nella cartella
					archive=$(basename $dest2)																		#scompattata ed elimina la cartella d'appoggio.
					mv $archive $parentdest/$variable															#cambia il nome della cartella come descritto
					cd $parentdest																								#nelle specifiche.
					rm -Rf $newdir
					newname=$archive.$variable
					mv $variable $newname

				fi
			fi
			done

		fi

done
tar=0
#-----------------------------
#TGZ  ||  TAR.GZ///
#----------------------------

for file in $( find $dir -name "*.tgz" -o -name "*.tar.gz" )
	do
	if [ ${file: -4} == .tgz ]; then

		 mkdir ${file: 0 : -4}
		source=$file
		dest=${file: 0 : -4}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		tar -xzf $dest2
		tar=0
		for var in $(ls -A1)
			do
			tar=$((tar+1))
			done
		if [[ $tar == 2 ]]; then
			for variable in $(ls -A1)
				do
					if [[ ! ${variable: -4} == .tgz ]]; then
						if [[ ! -d $variable ]]; then
							parentdest="$( dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							cd $parentdest
							rm -Rf $newdir
							variable2=$(basename $source).$variable
							cd $parentdest
							mv $variable $variable2

						elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
						fi
					fi
				done

		fi

	fi
	if [ ${file: -7} == .tar.gz ]; then

		 mkdir ${file: 0 : -7}
		source=$file
		dest=${file: 0 : -7}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		tar -xzf $dest2
		tar=0
		for var in $(ls -A1)
			do
			tar=$((tar+1))
			done
		if [[ $tar == 2 ]]; then
			for variable in $(ls -A1)
				do
					if [[ ! ${variable: -7} == .tar.gz ]]; then
						if [[ ! -d $variable ]]; then
							parentdest="$( dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							cd $parentdest
							rm -Rf $newdir
							variable2=$(basename $source).$variable
							cd $parentdest
							mv $variable $variable2


						elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
						fi
					fi
				done

		fi

	fi
	done

#---------------------------
#GZ//////////
#--------------------------
for file in $( find $dir -name "*.gz" )
	do
	if [ ! ${file: -7} == .tar.gz ]; then

		mkdir ${file: 0 : -3}
		source=$file
		dest=${file: 0 : -3}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		gunzip -fk $dest2
		tar=0
		for var in $(ls -A1)
		do
		tar=$((tar+1))
		done
		if [[ $tar == 2 ]]; then
			for variable in $(ls -A1)
				do
					if [[ ! ${variable: -3} == .gz ]]; then
						if [[ ! -d $variable ]]; then
							parentdest="$( dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							cd $parentdest
							rm -Rf $newdir
							variable2=$(basename $source).$variable
							cd $parentdest
							mv $variable $variable2


						elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
						fi
					fi
				done

		fi

	fi
	done

#------------------------
#ZIP////////////
#----------------------

for file in $( find $dir -name "*.zip" )
	do

	 mkdir ${file: 0 : -4}
	source=$file
	dest=${file: 0 : -4}
	mv $source $dest
	dest2=$dest/$(basename $source)
	cd $dest
	unzip -qq $dest2
	tar=0
	for var in $(ls -A1)
		do
		tar=$((tar+1))
		done
	if [[ $tar == 2 ]]; then
		for variable in $(ls -A1)
			do
			if [[ ! ${variable: -4} == .zip ]]; then
				if [[ ! -d $variable ]]; then
					parentdest="$( dirname "$dest")"
					newdir=${dest: 0 : -1}
					mv $dest $newdir
					mv $variable $parentdest
					cd $parentdest
					rm -Rf $newdir
					variable2=$(basename $source).$variable
					cd $parentdest
					mv $variable $variable2


				elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
				fi
			fi
			done

		fi

	done

#-----------------------
#TBZ || TAR.BZ || TAR.BZ2
#-----------------------

for file in $( find $dir -name "*.tbz" -o -name "*.tar.bz" -o -name "*.tar.bz2" )
	do
	if [ ${file: -4} == .tbz ]; then
		 mkdir ${file: 0 : -4}
		source=$file
		dest=${file: 0 : -4}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		tar -xjf $dest2
		tar=0
		for var in $(ls -A1)
		do
		tar=$((tar+1))
		done
	if [[ $tar == 2 ]]; then
		for variable in $(ls -A1)
			do
			if [[ ! ${variable: -4} == .tbz ]]; then
				if [[ ! -d $variable ]]; then
					parentdest="$( dirname "$dest")"
					newdir=${dest: 0 : -1}
					mv $dest $newdir
					mv $variable $parentdest
					cd $parentdest
					rm -Rf $newdir
					variable2=$(basename $source).$variable
					cd $parentdest
					mv $variable $variable2


				elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
				fi
			fi
			done

		fi

	fi
	if [ ${file: -7} == .tar.bz ]; then
	 	mkdir ${file: 0 : -7}
		source=$file
		dest=${file: 0 : -7}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		tar -xjf $dest2
		tar=0
		for var in $(ls -A1)
		do
		tar=$((tar+1))
		done
	if [[ $tar == 2 ]]; then
		for variable in $(ls -A1)
			do
			if [[ ! ${variable: -7} == .tar.bz ]]; then
				if [[ ! -d $variable ]]; then
					parentdest="$( dirname "$dest")"
					newdir=${dest: 0 : -1}
					mv $dest $newdir
					mv $variable $parentdest
					cd $parentdest
					rm -Rf $newdir
					variable2=$(basename $source).$variable
					cd $parentdest
					mv $variable $variable2

				elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
				fi
			fi
			done

		fi

	fi
	if [ ${file: -8} == .tar.bz2 ]; then
		 mkdir ${file: 0 : -8}
		source=$file
		dest=${file: 0 : -8}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		tar -xjf $dest2
		tar=0
		for var in $(ls -A1)
		do
		tar=$((tar+1))
		done
	if [[ $tar == 2 ]]; then
		for variable in $(ls -A1)
			do
			if [[ ! ${variable: -8} == .tar.bz2 ]]; then
				if [[ ! -d $variable ]]; then
					parentdest="$( dirname "$dest")"
					newdir=${dest: 0 : -1}
					mv $dest $newdir
					mv $variable $parentdest
					cd $parentdest
					rm -Rf $newdir
					variable2=$(basename $source).$variable
					cd $parentdest
					mv $variable $variable2

				elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
				fi
			fi
			done

		fi

	fi
	done

#----------------------
#BZ || BZ2////
#---------------------

for file in $( find $dir -name "*.bz" -o -name "*.bz2" )
	do
	if [[ ! ${file: -7} == .tar.bz && ! ${file: -8} == .tar.bz2 ]]; then
		if [ ${file: -3} == .bz ]; then
		 mkdir ${file: 0 : -3}
		source=$file
		dest=${file: 0 : -3}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		bzip2 -dk $dest2
		tar=0
		for var in $(ls -A1)
			do
			tar=$((tar+1))
			done
		if [[ $tar == 2 ]]; then
			for variable in $(ls -A1)
				do
					if [[ ! ${variable: -3} == .bz ]]; then
						if [[ ! -d $variable ]]; then
							parentdest="$( dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							cd $parentdest
							rm -Rf $newdir
							variable2=$(basename $source).$variable
							cd $parentdest
							mv $variable $variable2

						elif [[ -d $variable ]]; then
							parentdest="$(dirname "$dest")"
							newdir=${dest: 0 : -1}
							mv $dest $newdir
							mv $variable $parentdest
							archive=$(basename $dest2)
							mv $archive $parentdest/$variable
							cd $parentdest
							rm -Rf $newdir
							newname=$archive.$variable
							mv $variable $newname
						fi
					fi
				done

		fi

	fi
	if [ ${file: -4} == .bz2 ]; then
	 	mkdir ${file: 0 : -4}
		source=$file
		dest=${file: 0 : -4}
		mv $source $dest
		dest2=$dest/$(basename $source)
		cd $dest
		bzip2 -dk $dest2
		tar=0
		for var in $(ls -A1)
			do
			tar=$((tar+1))
			done
		if [[ $tar == 2 ]]; then
			for variable in $(ls -A1)
				do
				if [[ ! ${variable: -4} == .bz2 ]]; then
					if [[ ! -d $variable ]]; then
						parentdest="$( dirname "$dest")"
						newdir=${dest: 0 : -1}
						mv $dest $newdir
						mv $variable $parentdest
						cd $parentdest
						rm -Rf $newdir
						variable2=$(basename $source).$variable
						cd $parentdest
						mv $variable $variable2

					elif [[ -d $variable ]]; then
						parentdest="$(dirname "$dest")"
						newdir=${dest: 0 : -1}
						mv $dest $newdir
						mv $variable $parentdest
						archive=$(basename $dest2)
						mv $archive $parentdest/$variable
						cd $parentdest
						rm -Rf $newdir
						newname=$archive.$variable
						mv $variable $newname
					fi
				fi
			done

		fi

		fi
	fi
	done 