TESTOP=$(echo $TESTO | tr '[:upper:]' '[:lower:]')	#Trasforma ogni lettera maiuscola in minuscolo										#per poter comparare case-insensitive
. var/stars.sh
	while read WORD; do					#Controlla se messaggio contiene parole vietate
	
		case "$TESTOP" in
  		# match exact string
  		"$WORD") 
			VIA="N"
			echo "Trovata parola o frase non accettata"
			if [ "$STARS" = "S" ]; then
				VIA="S"
				STAR=""
				LENGHT=${#WORD}
				while [ "$LENGHT" != "0" ]
				do
					STAR="${STAR}*"
					LENGHT=$((LENGHT-1))
				done
				TESTO=$(echo "$TESTO" | sed -e "s/$WORD/"$STAR"/g")
				echo "Metto stelline!"
			fi
			;;
  
  		# match start of string
  		"$WORD"*) 
			VIA="N"
			echo "Trovata parola o frase non accettata"
			if [ "$STARS" = "S" ]; then
				VIA="S"
				STAR=""
				LENGHT=${#WORD}
				while [ "$LENGHT" != "0" ]
				do
					STAR="${STAR}*"
					LENGHT=$((LENGHT-1))
				done
				TESTO=$(echo "$TESTO" | sed -e "s/$WORD/"$STAR"/g")
				echo "Metto stelline!"
			fi
			;;

  		# match end of string
  		*"$WORD") 
			VIA="N"
			echo "Trovata parola o frase non accettata"
			if [ "$STARS" = "S" ]; then
				VIA="S"
				STAR=""
				LENGHT=${#WORD}
				while [ "$LENGHT" != "0" ]
				do
					STAR="${STAR}*"
					LENGHT=$((LENGHT-1))
				done
				TESTO=$(echo "$TESTO" | sed -e "s/$WORD/"$STAR"/g")
				echo "Metto stelline!"
			fi
			;;

  		# searchString can be anywhere in this String
  		*"$WORD"*) 
			VIA="N"
			echo "Trovata parola o frase non accettata"
			if [ "$STARS" = "S" ]; then
				VIA="S"
				STAR=""
				LENGHT=${#WORD}
				while [ "$LENGHT" != "0" ]
				do
					STAR="${STAR}*"
					LENGHT=$((LENGHT-1))
				done
				TESTO=$(echo "$TESTO" | sed -e "s/$WORD/"$STAR"/g")
				echo "Metto stelline!"
			fi
			;;
  
  		*)
			;;
		esac

	done < parolevietate.txt
