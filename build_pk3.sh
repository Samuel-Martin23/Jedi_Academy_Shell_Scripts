#!/usr/bin/env bash 
set -o errexit

asset_folder_name="Lightsabers"
pk3_name="Lightsabers.pk3"
app_name="openjk_sp.x86_64.app"
folder_in_contents="base"

ja_folder=$(mdfind -name ${asset_folder_name})
cd $ja_folder

zip -r $pk3_name .;
pk3_file_path="$ja_folder/$pk3_name"

while IFS='' read -r line; do swjkja_apps+=("$line"); done < <(mdfind SWJKJA.app)
for executable in "${swjkja_apps[@]}"
do
  if [[ $executable == *"SWJKJA.app"* ]]; then
    swjkja_app_path=$executable
    break
  fi
done

swjkja_app_path="${swjkja_app_path}/Contents/"
rm "${swjkja_app_path}/${folder_in_contents}/${pk3_name}"
mv $pk3_file_path "${swjkja_app_path}/${folder_in_contents}"
open "$swjkja_app_path/$app_name"