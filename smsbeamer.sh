#!/bin/sh

firefox smsbeamer.html &		#Avvia Firefox

echo "
***************************************************
***                                             ***
***     SMS2BEAMER - BRIGATA SCOUT LOCARNO      ***
***                                             ***
***              Jonas Pfaff 2011               ***
***                                             ***
***************************************************"


echo 
echo "PARTENZA... PRONTI... VIA"
echo "Tra moglie e marito l'Sms ci mette il dito"
echo

cp screen/messaggio.html messaggio.html
sed -e "s/<!--telefono-->.*/<!--telefono-->/g" -i messaggio.html	#Azzera tutto		
sed -e "s/<!--rimpiazza-->.*/<!--rimpiazza-->/g" -i messaggio.html
sed -e "s/<!--frame-->.*/<!--frame--><iframe style=\"position:fixed;right:200px;top:100px;\" src=\"messaggio.html\" width=1200 height=650 frameborder=0 scrolling=no> /g" -i smsbeamer.html
echo "SCREENS=\"0\"" > var/screens.sh						#niente schermate
echo "STOP=\"N\"" > var/stop.sh 						#niente stop
echo "ELIMINA=\"N\"" > var/elimina.sh						#nessun sms eliminato
echo "TEL=\"N\"" > var/tel.sh							#tel seminascosto
echo "CONTROL=\"N\"" > var/control.sh						#controllo parole automatico
echo "TEMPO=\"10\"" > var/tempo.sh						#Tempo standard --> 10s
echo "0" > var/contatot.sh								#Numero sms ricevuti
echo "0" > var/contapos.sh								#Numero sms visualizzati

CONTATOT="0"
CONTAPOS="0"

gammu-smsd --config gammu/gammu-smsdrc &  		#Avvia gammu-smsd

DIR=gammu/inbox/					#MODIFICA QUESTA RIGA SE CAMBIA LA CARTELLA

while :							#Loop infinito!
do

. var/control.sh					#Controlla impostazioni!	VARIABILE control,tel,tempo
. var/tel.sh
. var/tempo.sh

if [ "$(ls -A $DIR)" ]; then				#Cartella vuota?

	FILE=$(ls $DIR | head -1)			#Scegli il primo in ordine alfabetico (il più vecchio)
	echo $FILE					#Output del nome del file (sicurezza)

	CONTATOT=$(($CONTATOT+1))				#Incrementa numero SMS ricevuti
	echo "$CONTATOT" > var/contatot.sh
	. ./leggi.sh					#Richiama script "leggi info da file"

	rm $DIR$FILE					#Elimina File appena letto

	if [ "$CONTROL" = "S" ]; then			#IF Controllo manuale se il testo va bene...
		echo "Aspetto il via... [S/N]"
		read VIA
	else		
		VIA="S"				
		. ./parole.sh				#Richiama Script controllo parole!
	fi
	
	if [ "$VIA" = "S" ]; then			#IF Rimpiazza (o meno) i dati nel file html!
		sed -e "s/<!--telefono-->.*/<!--telefono-->$NO1 /g" -i messaggio.html		
		sed -e "s/<!--rimpiazza-->.*/<!--rimpiazza-->$TESTO /g" -i messaggio.html
		VIA="N"
		
		CONTAPOS=$(($CONTAPOS+1))				#Incrementa numero SMS visualizzati
		echo "$CONTAPOS" > var/contapos.sh

		K="0"
		while [ "$K" != "$TEMPO" ]			#Aspetta x secondi
		do
			sleep 1
			. var/elimina.sh
			if [ "$ELIMINA" = "S" ]; then		#Elimina "al volo" SMS non accettabili VARIABILE elimina
				VUOTO=" "
				echo "ELIMINA=\"N\"" > var/elimina.sh		#Il prossimo non sarà più eliminato.
				sed -e "s/<!--telefono-->.*/<!--telefono-->$VUOTO /g" -i messaggio.html		
				sed -e "s/<!--rimpiazza-->.*/<!--rimpiazza-->$VUOTO /g" -i messaggio.html
				break
			fi
			K=$((K+1))

			. var/screens.sh
			if [ "$SCREENS" != "0" ]; then				#Cambia Schermate / pubblicità VARIABILE screens

				sed -e "s/<!--frame-->.*/<!--frame--><iframe src=\"messaggio.html\" width=100% height=100% frameborder=0 scrolling=no> /g" -i smsbeamer.html
				cp screen/$SCREENS messaggio.html				
				echo "Mostro $SCREENS"
				while [ "$SCREENS" != "0" ]
				do
					. var/screens.sh
				done

				sed -e "s/<!--frame-->.*/<!--frame--><iframe style=\"position:fixed;right:200px;top:100px;\" src=\"messaggio.html\" width=1200 height=650 frameborder=0 scrolling=no> /g" -i smsbeamer.html
				cp screen/messaggio.html messaggio.html
			fi

			. var/stop.sh
			while [ "$STOP" = "S" ]			#Ferma il processo SMS VARIABILE stop
			do
			. var/stop.sh
			done
		done			
	fi
	echo
	echo Ci sono ancora $(ls $DIR | wc -l) messaggi nuovi!	#Informa quanti sms rimangono
	echo

else
    echo "$DIR is Empty"				#Nessun messaggio nuovo!
	sleep 5						#Aspetta 5 secondi
fi

	. var/elimina.sh
	if [ "$ELIMINA" = "S" ]; then	#Elimina "al volo" SMS non accettabili VARIABILE elimina (in caso non ci siano più sms nuovi e si vuole cmq eliminare quello attuale)
		VUOTO=" "
		echo "ELIMINA=\"N\"" > var/elimina.sh		#Il prossimo non sarà più eliminato.
		sed -e "s/<!--telefono-->.*/<!--telefono-->$VUOTO /g" -i messaggio.html		
		sed -e "s/<!--rimpiazza-->.*/<!--rimpiazza-->$VUOTO /g" -i messaggio.html
	fi

	. var/screens.sh
	if [ "$SCREENS" != "0" ]; then				#Cambia Schermate / pubblicità VARIABILE screens

		sed -e "s/<!--frame-->.*/<!--frame--><iframe src=\"messaggio.html\" width=100% height=100% frameborder=0 scrolling=no> /g" -i smsbeamer.html
		cp screen/$SCREENS messaggio.html
		echo "Mostro $SCREENS"
		while [ "$SCREENS" != "0" ]
		do
			. var/screens.sh
		done

		sed -e "s/<!--frame-->.*/<!--frame--><iframe style=\"position:fixed;right:200px;top:100px;\" src=\"messaggio.html\" width=1200 height=650 frameborder=0 scrolling=no> /g" -i smsbeamer.html
		cp screen/messaggio.html messaggio.html
	fi

	. var/stop.sh
	while [ "$STOP" = "S" ]			#Ferma il processo SMS VARIABILE stop
	do
		. var/stop.sh
	done

done
