#!/usr/bin/env bash 
set -o errexit

code_folder="OpenJK"
bundle_name="OpenJK-Bundle/OpenJK"
app_name="openjk_sp.x86_64.app"

openjk_folder=$(mdfind -name ${code_folder})
openjk_folder="${openjk_folder}/build"

if [ ! -d "$openjk_folder" ]; then
    mkdir "$openjk_folder"
fi

cd "$openjk_folder"
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=OpenJK-Bundle -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_BUILD_TYPE=Release -DUseInternalPNG=On -DBuildMPEngine=Off -DBuildMPRdVanilla=Off -DBuildMPDed=Off -DBuildMPGame=Off -DBuildMPCGame=Off -DBuildMPUI=Off ../
make -j7
make
make install

openjk_app_path="$openjk_folder/$bundle_name/$app_name"

while IFS='' read -r line; do swjkja_apps+=("$line"); done < <(mdfind SWJKJA.app)
for executable in "${swjkja_apps[@]}"
do
  if [[ $executable == *"SWJKJA.app"* ]]; then
    swjkja_app_path=$executable
    break
  fi
done

swjkja_app_path="${swjkja_app_path}/Contents/"

if [ -d "${swjkja_app_path}${app_name}" ]; then
    rm -R "${swjkja_app_path}${app_name}"
fi

mv "$openjk_app_path" "$swjkja_app_path"
open "$swjkja_app_path""$app_name"