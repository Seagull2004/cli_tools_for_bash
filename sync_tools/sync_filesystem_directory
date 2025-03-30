#!/bin/bash
# Questo script permetterà di sincronizzare il contenuto di una cartella di questo pc ($1) con il contenuto di una nel file system ($2)
# $1 percorso alla cartella "da sincronzzare" (pc)
# $2 percorso alla cartella di destinazione (stesso file system)

# e.g. $1 = "/Users/macpro/Music/playlists"
#      $2 = "/Volumes/NO NAME"

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


# funzione di print personalizzata
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
if [[ !( -d "$1" ) ]]; then
  print__ "bad parameter:" $H_RED -n
  echo " $1 is not a directory" 
  exit 1
fi

if [[ !( -d "$2" ) ]]; then
  print__ "bad parameter:" $H_RED -n
  echo " $2 is not a directory" 
  exit 1
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
totalDirs=$(( `find "$1" -type d | wc -l | tr -d " "` * 2 ))
i=0

find "$1" -type d | sed "s|$1||g" | while read -r localDir; do

  fullPathToLocalDir="$1$localDir"
  fullPathToDestinationDir="$2$localDir"

  # STAMPA PERCENTUALE
  i=$(( $i + 1 ))
  percentage="`bc <<< "scale=2; $i/$totalDirs * 100" | cut -d. -f1` %"
  # FINE PERCENTUALE
 
  echo $percentage
  print__ "📁 $fullPathToLocalDir" $CYAN 
  mkdir -p "$fullPathToDestinationDir"


  ## MD5 test
  md5Local=`ls -l -D "%H:%M" "$1$localDir" | grep "^-" | tr -s " " " " | cut -d" " -f6- | md5`
  md5Destinaton=`ls -l -D "%H:%M" "$2$localDir" | grep "^-" | tr -s " " " " | cut -d" " -f6- | md5`
  if [[ $md5Destinaton = $md5Local ]]; then
    print__ "   - MD5 match! ALL GOOD HERE" $GREEN
    continue
  fi
  ## END OF MD5 TEST

  find "$fullPathToLocalDir" -type f -maxdepth 1 | sed "s|$fullPathToLocalDir||g" | while read -r file; do
    #echo -n " - $file"
    if [[ -f "$fullPathToDestinationDir$file" ]]; then
      lastModificationTimeFileLocal=`date -r "$fullPathToLocalDir$file" $FORMATO_DATA_DI_MODIFICA`
      lastModificationTimeFileDestination=`date -r "$fullPathToDestinationDir$file" $FORMATO_DATA_DI_MODIFICA`
      if [[ $lastModificationTimeFileLocal = $lastModificationTimeFileDestination ]]; then
        print__ "   - $file" $GREEN
      else
        print__ "   - $file" $YELLOW -n
        cp -p "$fullPathToLocalDir$file" "$fullPathToDestinationDir"
        if [[ $? == 0 ]]; then
          print__ " aggiornato!" $GREEN
        else
          print__ " errore!" $RED
        fi
      fi 
    else
      print__ "   - $file" $YELLOW -n
      cp -p "$fullPathToLocalDir$file" "$fullPathToDestinationDir"
      if [[ $? == 0 ]]; then
        print__ " aggiunto!" $GREEN
      else
        print__ " errore!" $RED
      fi
    fi
  done
done


echo
echo "##################################################################"
echo "## 2. PULIZIA DI FILE IN ECCESSO NELLA CARTELLA DI DESTINAZIONE ##"
echo "##################################################################"

# variabili utilizzate per permettere di fornire un'idea sull'avanzamento del lavoro
totalDirs=$(( `find "$2" -type d | wc -l | tr -d " "` * 2 ))
i=0

find "$2" -type d | sed "s|$2||g" | while read -r aDestinationDir; do

  # PERCENTUALE
  i=$(( $i + 1 ))
  percentage="`bc <<< "scale=2; 50 + $i/$totalDirs * 100" | cut -d. -f1` %"
  # FINE PERCENTUALE

  echo $percentage 
  print__ "📁 $2$aDestinationDir" $CYAN

  if test ! -d "$1$aDestinationDir"; then 
    print__ "   - LA DIRECTORY NON È PRESENTE SUL PC." $RED -n
    rm -r "$2$aDestinationDir" 
    if [[ $? == 0 ]]; then
      print__ " eliminata!" $GREEN
    else
      print__ " errore!" $RED
    fi
  else

    md5Local=`ls -l -D "%H:%M" "$1$aDestinationDir" | grep "^-" | tr -s " " " " | cut -d" " -f6- | md5`
    md5Destination=`ls -l -D "%H:%M" "$2$aDestinationDir" | grep "^-" | tr -s " " " " | cut -d" " -f6- | md5`

    if [[ $md5Destination = $md5Local ]]; then
      print__ "   - MD5 match! ALL GOOD HERE" $GREEN
      continue
    fi

    find "$2$aDestinationDir" -type f -maxdepth 1 | sed "s|$2$aDestinationDir||g" | while read -r file; do
      if test ! -f "$1$aDestinationDir$file"; then
        print__ "   - $file" $YELLOW -n
        rm "$2$aDestinationDir$file"
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

