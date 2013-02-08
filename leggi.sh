NO1=$(echo $FILE | awk -F _ '{print $4}')	#Estrai numero di telefono dal nome del file

echo $NO1
	
if [ "$TEL" = "N" ]; then			#Taglia parte del numero di telefono
	NO1=$(echo $NO1 | cut -c-8)
	NO1=$NO1****
fi
echo $NO1					

TESTO=$(cat $DIR$FILE)				#Testo copiato dal messaggio

TESTO=$(echo $TESTO | awk -F"/" '{$1=$1}1' OFS="\/")	#Evitare problemi con caratteri speciali,
TESTO=$(echo $TESTO | awk -F"&" '{$1=$1}1' OFS="\&")	#quindi vengono rimpiazzati

echo $TESTO					#Output del testo definitivo
