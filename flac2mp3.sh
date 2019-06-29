#!/bin/bash
if [ "${1}" == '' ]; then
shellDir="$PWD"
else
shellDir="${1}"
fi

prefix=/home/f0x/_mp3
find "${shellDir}" -name '*.flac' -print | while read fn;
do
  ARTIST=`metaflac "$fn" --show-tag=ARTIST | sed s/.*=//g`
  TITLE=`metaflac "$fn" --show-tag=TITLE | sed s/.*=//g`
  ALBUM=`metaflac "$fn" --show-tag=ALBUM | sed s/.*=//g`
  GENRE=`metaflac "$fn" --show-tag=GENRE | sed s/.*=//g`
  TRACKNUMBER=`metaflac "$fn" --show-tag=TRACKNUMBER | sed s/.*=//g`
  DATE=`metaflac "$fn" --show-tag=DATE | sed s/.*=//g`

newpath="${prefix}/$ARTIST/$ALBUM"
newfile=${TITLE}.mp3
echo $newfile
mkdir -p "${newpath}"

flac -c -d "${fn}" | lame -m j -q 0 --vbr-new -V 0 -s 44.1 - "${newpath}/${newfile}"
id3 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "${newpath}/${newfile}"

done

