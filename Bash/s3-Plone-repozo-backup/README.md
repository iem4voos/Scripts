# Plone-repozo-backup

### Descrizione

Scipt Bash che permette di eseguire Backup del database zfs di [Plone][2] e di salvare i file su un buket s3 Amazon usando [s3cmd][1].

Lo script riceve un parametro,e in base a questo esegue o un backup di plone oppure sicronizza i file con il buket s3.

Per il backup viene usato [Repozo][3] fornito di default con Plone

#### ![edit_icon][4]  Funzionamento

I backup vengono organizzati in cartelle in base alla cadenza (mensile o settimanale). 

Il bakup giornaliero esegue salvataggi incrementali, quello settimanale prende il file completi (non gli incrementi) dalla cartella dei backup giornalieri e lo aggiunge a quella settimanale.

Le cartelle vengono sincronizzate con lo storage remoto di Amazon

[1]: http://s3tools.org/s3cmd
[2]: http://plone.org/
[3]: http://wiki.zope.org/zope2/RepozoPy
[4]: https://github.com/iem4voos/Scripts/raw/master/Bash/s3-Plone-repozo-backup/images/action_edit_no.gif