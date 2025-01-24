#!/bin/bash
# Questo script permetterà di sincronizzare il contenuto di una cartella di questo pc ($1) con il contenuto di una cartella del telefono android ($2)
# $1 percorso alla cartella "da sincronzzare" (pc)
# $2 percorso alla cartella di destinazione (telefono)

# e.g. $1 = /Users/macpro/Documents/vault 
#      $2 = /sdcard/Documents/vault
# e.g. $1 = /Users/macpro/Music/playlists
#      $2 = /sdcard/Music/playlists

# COSTANTI E FUNZIONI
FORMATO_DATA_DI_MODIFICA="+%Y%m%d%H%M"
LISTA_FILE_TELEFONO_CON_DATA_DI_MODIFICA="tmp"
COLOR_OFF='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;34m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
H_RED='\033[0;41m'
H_GREEN='\033[0;42m'
H_YELLOW='\033[0;43m'
H_PURPLE='\033[0;44m'
H_PINK='\033[0;45m'
H_CYAN='\033[0;46m'


# $1 text
# $2 color
# $3 se -n allora non va a capo
print__() {
    if [[ $3 = "-n" ]]; then
        printf "$2$1$COLOR_OFF"
    else
        printf "$2$1$COLOR_OFF\n"
    fi
}





########################################################################################
## 0. CONTROLLO PARAMETRI DI INPUT
########################################################################################

# il numero di parametri deve essere esattamente 2
if [[ $# -ne "2" ]]; then
    print__ "bad parameter:" $H_RED -n
    echo " wrong number of parameter"
    exit 1
fi

# entrami i parametri devono essere una directory
if [[ !( -d $1 ) ]]; then
    print__ "bad parameter:" $H_RED -n
    echo " $1 is not a directory" 
    exit 1
fi
if adb shell "test ! -d \"$2\""; then
    print__ "bad parameter:" $H_RED -n
    echo " $2 is not a directory"
    echo -n "want to create it? (y/n) "
    read answer
    if [[ $answer = "y" ]]; then
        adb shell "mkdir -p $2"
    else
        exit 1
    fi
fi

# entrai i parametri non devono avere '/' come carattere finale
lastCharFirstParameter=${1:0-1}
lastCharSecondParameter=${2:0-1}
if [[ $lastCharFirstParameter = '/' ]]; then
    print__ "bad parameter:" $H_RED -n
    echo " a directory must not end with '/' character" 
    exit 1
fi
if [[ $lastCharSecondParameter = '/' ]]; then
    print__ "bad parameter:" $H_RED -n
    echo " a directory must not end with '/' character" 
    exit 1
fi


print__ "#################################################"
print__ "## 1. COPIA DI OGNI FILE PRESENTE SUL COMPUTER ##"
print__ "#################################################"
## per leggere la data di ultima modifica di un file/dir su mac:        stat -f %m $file
## per leggere la data di ultima modifica di un file/dir su mac:        date -r $file "+%Y%m%d"
## per leggere la data di ultima modifica di un file/dir su mac:        stat -f %Sm -t %Y-%m-%d-%H-%M $file

## per leggere la data di ultima modifica di un file/dir su telefono:   stat -c %Y $file
## per leggere la data di ultima modifica di un file/dir su telefono:   date -r $file "+%Y%m%d"
## per leggere la data di ultima modifica di un file/dir su telefono:   stat -c %y file1.txt | cut -d: -f1-2 | tr " :" "--"

# variabili utilizzate per permettere di fornire un'idea sull'avanzamento del lavoro
# totalDirs directory totali da ciclare
# i directory attuale
totalDirs=$(( `find "$1" -type d | wc -l | tr -d " "` * 2 ))
i=0
# inizia il ciclo su tutte le directory e sottdirectory trovate
find "$1" -type d | sed "s|$1||g" | while read -r localDir;
do
    # ottengo percorsi per raggiungere la directory 
    fullPathToLocalDir="$1$localDir"
    fullPathToPhoneDir="$2$localDir"
    # stampa avanzamento
    i=$(( $i + 1 ))
    percentage="`bc <<< "scale=2; $i/$totalDirs * 100" | cut -d. -f1` %"
    # stampa info
    echo $percentage
    print__ "📁 $fullPathToLocalDir" $CYAN 
    adb shell "mkdir -p \"$fullPathToPhoneDir\"" < /dev/null
    ## md5 test
    fListWithModTimeLocal=`ls -l -D "%H:%M" "$fullPathToLocalDir" | grep "^-" | tr -s " " " " | cut -d" " -f6-`
    fListWithModTimePhone=`adb shell "ls -l \"$fullPathToPhoneDir\"" < /dev/null | grep "^-" | tr -s " " " " | cut -d" " -f7-`
    md5Local=`echo $fListWithModTimeLocal | md5`
    md5Phone=`echo $fListWithModTimePhone | md5`
    if [[ $md5Phone = $md5Local ]]; then
        print__ "   - MD5 match! ALL GOOD HERE" $GREEN
        continue
    else
        echo "$md5Local vs $md5Phone"
    fi
    # ciclo sui file
    find "$fullPathToLocalDir" -type f -maxdepth 1 | sed "s|$fullPathToLocalDir||g" | while read -r file;
    do
        #echo -n " - $file"
        if adb shell "test -f \"$fullPathToPhoneDir$file\""  < /dev/null; then
            lastModificationTimeFileLocal=`date -r "$fullPathToLocalDir$file" $FORMATO_DATA_DI_MODIFICA`
            lastModificationTimeFilePhone=`adb shell "date -r \"$fullPathToPhoneDir$file\" $FORMATO_DATA_DI_MODIFICA" < /dev/null`
            if [[ $lastModificationTimeFileLocal = $lastModificationTimeFilePhone ]]; then
                print__ "   - $file" $GREEN
            else
                print__ "   - $file" $YELLOW -n
                adb push "$fullPathToLocalDir$file" "$fullPathToPhoneDir" < /dev/null > /dev/null
                if [[ $? == 0 ]]; then
                    print__ " aggiornato!" $GREEN
                else
                    print__ " errore!" $RED
                fi
            fi 
        else
            print__ "   - $file" $YELLOW -n
            adb push "$fullPathToLocalDir$file" "$fullPathToPhoneDir" < /dev/null > /dev/null
            if [[ $? == 0 ]]; then
                print__ " aggiunto!" $GREEN
            else
                print__ " errore!" $RED
            fi
        fi
    done
done

echo
echo "#########################################################"
echo "## 2. PULIZIA DI FILE IN ECCESSO PRESENTI SUL TELEFONO ##"
echo "#########################################################"

# variabili utilizzate per permettere di fornire un'idea sull'avanzamento del lavoro
totalDirs=$(( `adb shell "find \"$2\" -type d" | wc -l | tr -d " "` * 2 ))
i=0


adb shell "find \"$2\" -type d" | sed "s|$2||g" | while read -r phoneDir; do

  # PERCENTUALE
  i=$(( $i + 1 ))
  percentage="`bc <<< "scale=2; 50 + $i/$totalDirs * 100" | cut -d. -f1` %"
  # FINE PERCENTUALE

  echo $percentage 
  print__ "📁 $2$phoneDir" $CYAN

  if test ! -d "$1$phoneDir"; then 
      print__ "   - LA DIRECTORY NON È PRESENTE SUL PC." $RED -n
      adb shell "rm -r \"$2$phoneDir\"" < /dev/null > /dev/null
      if [[ $? == 0 ]]; then
          print__ " eliminata!" $GREEN
      else
          print__ " errore!" $RED
      fi
  else

      md5Local=`ls -l -D "%H:%M" "$1$phoneDir" | grep "^-" | tr -s " " " " | cut -d" " -f6- | md5`
      md5Phone=`adb shell "ls -l \"$2$phoneDir\"" < /dev/null | grep "^-" | tr -s " " " " | cut -d" " -f7- | md5`

      if [[ $md5Phone = $md5Local ]]; then
          print__ "   - MD5 match! ALL GOOD HERE" $GREEN
          continue
      fi

      adb shell "find \"$2$phoneDir\" -type f -maxdepth 1" < /dev/null | sed "s|$2$phoneDir||g" | while read -r file; do
      if test ! -f "$1$phoneDir$file"; then
          print__ "   - $file" $YELLOW -n
          adb shell "rm \"$2$phoneDir$file\"" < /dev/null > /dev/null
          if [[ $? == 0 ]]; then
              print__ " elimanto!" $GREEN
          else
              print__ " errore!" $RED
          fi
      else
          print__ "   - $file" $GREEN
      fi
  done
  fi
done 

