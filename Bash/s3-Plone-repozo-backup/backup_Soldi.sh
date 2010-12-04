#!/bin/sh

#  Plone_backup.sh
#  Scripts
#


REPOZO_BIN=/usr/local/Plone/Soldi/bin/repozo
SOURCE_DATA_FS=/usr/local/Plone/Soldi/var/filestorage/Data.fs
BACUP_DIR=/usr/local/PloneRepository/Soldi/repozoBackup

SETT=/usr/local/PloneRepository/backup/soldi-backup-settimanale
GIOR=/usr/local/PloneRepository/backup/soldi-backup-giornaliero

S3PARAMS="--reduced-redundancy --no-encrypt --bucket-location=EU --recursive --skip-existing --delete-removed "

EXIT_SUCCESS=0
EXIT_FAILURE=1


utilizzo () {

    echo -e "esegue backup di plone giornalieri grazie a repozo \n"
    echo -e "$(basename $0) giorno|sett \n"
    echo "-b per configurare il binario da eseguire, default $REPOZO_BIN"
    echo "-f il dile da backuppare def: $SOURCE_DATA_FS"
    echo "-x dir giornaliera $GIOR"
    echo "-y dir settimanale $SETT"
    exit $EXIT_FAILURE
}


#si puo aggiungere -v per il verbose
# f forza il backup completo

#$REPOZO_BIN -BzQ -r $BACUP_DIR -f $SOURCE_DATA_FS


if [ $# -ne 1 ]
then
	utilizzo
	exit
fi

case "$1" in
	"giorno") 	
			$REPOZO_BIN -BzQ -r $GIOR -f $SOURCE_DATA_FS
	    	;;
	"sett")  
			$REPOZO_BIN -BzQF -r $SETT -f $SOURCE_DATA_FS
			cd  /usr/local/Plone/Soldi
			tar -czf /usr/local/PloneRepository/backup/soldi-backup-settimanale/soldi-prodotti-settimanale/$(date +soldi-prodotti-%Y-%m-%d).tgz products
			tar -czf /usr/local/PloneRepository/backup/soldi-backup-settimanale/soldi-tema-settimanale/$(date +soldi-temi-%Y-%m-%d).tgz src
			tar -czf /usr/local/PloneRepository/backup/soldi-backup-settimanale/soldi-bildout.cfg-settimanale/$(date +soldi-buildout.cfg-%Y-%m-%d).tgz buildout.cfg
			#find $SETT -atime -30 -type d exec rm -rf '{}' \;
	    	;;
	"gior-sync") 	
			/usr/bin/s3cmd sync $S3PARAMS $GIOR/* s3://soldi/backup2/giornaliero/
	    	;;
	"sett-sync")  
			/usr/bin/s3cmd sync $S3PARAMS $SETT/* s3://soldi/backup2/settimanale/
			/bin/rm $GIOR/*
			/usr/bin/find $SETT -ctime -1 -type f -exec /bin/cp {} $GIOR/ \;
	    	;;
	*)  
		echo "errore parametri"
	    utilizzo
		exit $EXIT_FAILURE
	    ;;
esac

