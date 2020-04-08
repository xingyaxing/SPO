#!/bin/bash

string="Name, Extension, Duration, Size, Date of Change"
string+="
"

file_info() {

#counter - счётчик входов во внутренние папки. исходно он равен нулю, тк считаем,
#что выше нашей папки ничего для нам интересного нет
local counter
counter="$1"

#shif - флаг выхода на уровень выше
shif=0

for FILE in $(ls)
do
EXT="${FILE##*.}"

NAME="${FILE%.*}"
CH_DATE=$(date -r $FILE)
extra_size=$(du -h $FILE | awk '{gsub(",", ".", $0)} 1')
SIZE="${extra_size%	*}"

if [[ "$EXT" == "avi" || "$EXT" == "mkv" || "$EXT" == "mpeg" || "$EXT" == "webm" || "$EXT" == "mp3" || "$EXT" == "wav" || "$EXT" == "mp4" ]]; then
DURATION=$(mediainfo --Output='General;%Duration/String1%' "$FILE")
else
DURATION="-"
fi

#если папка - заходим
if [[ "$NAME" == "$FILE" ]]; then
cd "$FILE"
((counter += 1))
file_info "$counter"

if [[ "$counter" -ne 0 ]]; then
cd ..
shif=1
fi
fi

if [[ "$shif" -eq 1 ]]; then
shif=0
continue
fi


string+="$NAME, $EXT, $DURATION, $SIZE,  $CH_DATE"
string+="
"

done
}

file_info 0
echo "$string"
echo "$string" > output.csv
