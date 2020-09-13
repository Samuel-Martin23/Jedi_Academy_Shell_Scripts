#!/usr/bin/env bash
set -o errexit

folder_name="Sound_Files"

audio_files=()
folder_name_path=$(mdfind -name $folder_name | head -n 1)
folder_converted_path=""$folder_name_path"_Converted"

if [ -d "$folder_converted_path" ]; then
  rm -r "$folder_converted_path"
fi

cd "$folder_name_path"
mkdir "$folder_converted_path"
while IFS='' read -r line; do audio_files+=("$line"); done < <(ls)

for file in "${audio_files[@]}"
do
    dd bs=58 skip=1 if="$file" of=""$folder_converted_path"/$file"
done