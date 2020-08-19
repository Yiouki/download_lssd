#!/usr/bin/env bash
# Contact: hugo.ruiz@lirmm.fr || hugo.ruiz.pro@gmail.com

function show_usage() {
  printf "This script is used to download the already developed LSSD database as well as RAW images from different databases.\n"
  printf "The architecture of the database downloaded, by default, is like in the PDF.\n"
  printf "\n"
  printf "Usage: $0 [options [parameters]]\n"
  printf "Example:\n"
  printf "\t LSSD: $0 -b LSSD_10k -t MAT -c Gray -n Stego_P02 -o ./tst_LSSD\n"
  printf "\t RAW: $0 -b RAW_ALASKA2 -o ./tst_RAW\n"
  printf "\n"
  printf "Options:\n"
  printf " -b|--base_name: Choose the base to download\n"
  printf " -t|--type: Type of images: JPEG || MAT\n"
  printf " -c|--coloring: Coloring of images: Color || Gray\n"
  printf " -n|--nature: Nature of images:  Cover || Stego (for Stego, put the payload after like this: Stego_P02)\n"
  printf " -o|--output (optional): Choose the output path where download files (default create './download')\n"
  printf " -h|--help, Print help\n"

  return 0
}

# Get the inputs from the user
while [ -n "$1" ]; do
  case "$1" in
  --base_name | -b)
    shift
    base_name="$1"
    ;;
  --type | -t)
    shift
    img_type="$1"
    ;;
  --coloring | -c)
    shift
    coloring="$1"
    ;;
  --nature | -n)
    shift
    nature="$1"
    ;;
  --output | -o)
    shift
    output="$1"
    ;;
  *)
    show_usage
    exit 1
    ;;
  esac
  shift
done

# To know if the user want RAW or LSSD
readarray -d _ -t base <<<"$base_name"
base_type="${base[0]}"

# Check that what the user wants is correct, otherwise don't do it
#if [ "$1" == "" ]; then
#  show_usage
#  exit 1
#fi
if [ "${base_name}" == "" ]; then
  printf "[ERROR] Missing base name to download\n"
  exit 1
elif [ "${nature}" != "" ] && [ "${nature}" != "Cover" ] && [[ ! "${nature}" == "Stego"* ]]; then
  printf "[ERROR] Please use 'Cover' or 'Stego' for option '-n|--nature' (case sensitive)\n"
  exit 1
elif [ "${base_type}" == "RAW" ] && [ "${nature}" != "" ]; then
  printf "[ERROR] There are no cover or stego for RAW images\n"
  exit 1
elif [ "${coloring}" != "" ] && [ "${coloring}" != "Color" ] && [ "${coloring}" != "Gray" ]; then
  printf "[ERROR] Please use 'Color' or 'Gray' for option '-c|--coloring' (case sensitive)\n"
  exit 1
elif [ "${coloring}" == "Color" ] && [ "${nature}" != "" ]; then
  printf "[ERROR] The LSSD don't have stego images for in color...\n"
  exit 1
#else
#  printf "[ERROR] Command not correct, please check it and refer to the PDF\n"
#  exit 1
fi

if [ "$base_type" == "LSSD" ]; then
  link_fold="${base_type}/${img_type}/${img_type}_${coloring}_${nature}/${base_name}"
else
  short_base_name="${base[1]::-1}"
  link_fold="${base_type}/${short_base_name}"
fi
fold_list="./Lists"
if [ "$output" = '' ]; then
  output_fold="./downloaded/$link_fold"
else
  output_fold=$output
fi
logs_fold="./logs/$link_fold"
if [ $base_type == "LSSD" ]; then
  logs_file="$logs_fold/${base_name}_log_downloads"
else
  logs_file="$logs_fold/${short_base_name}_log_downloads"
fi

# Beginning of the script; timestamp and creation of non-existing directory.
timeStart=$(date +%s)
if [ ! -d output_fold ]; then
  echo "Directory $output_fold where RAW images will be downloaded does not exist. It will be created."
  mkdir -p "$output_fold"
fi
if [ ! -d "$logs_fold" ]; then mkdir -p "$logs_fold"; fi
if [ -f "$logs_file" ]; then rm "$logs_file"; fi # Debug: remove the log file if it exists
if [ ! -d ./tmp ]; then mkdir -p ./tmp; fi

# Beginning of the download, reading each line of the list and calling the software wget to download the raw image from
# its URL.
rar_index=0
if [ $base_type == "LSSD" ]; then
  list="$fold_list/${base_type}/${img_type}/${img_type}_${coloring}_${nature}/list_${img_type}_${coloring}_${nature//_}_${base_name}.txt"
else
  list="$fold_list/${base_type}/list_${base_name}.txt"
fi

if [ ! -f "$list" ]; then
  printf "The list '%s' doesn't exists.\n" "$list"
  exit 1
fi

NB_rar_to_DL=$(wc -l <"$list")

while read -r rar_name; do
  # TODO: ne pas oubleir de changer l'URL (quand il sera connu)
  if [ $base_type == "LSSD" ]; then
    rar_url="https://rhea.lirmm.fr/lssd/Data/${base_type}/${img_type}/${img_type}_${coloring}_${nature}/${base_name}/$rar_name"
  else
    rar_url="https://rhea.lirmm.fr/lssd/Data/${base_type}/${short_base_name}/$rar_name"
  fi
  start_time=$(date +%s)
  if [ ! -f "$output_fold/$rar_name" ]; then
    ( wget --no-check-certificate -c -P ./tmp/ "$rar_url" && mv ./tmp/"$rar_name" "$output_fold"/"$rar_name" ) &>> "$logs_file"
    finish_time=$(date +%s)
    download_time=$finish_time-$start_time
    if [ ! -f "$output_fold/$rar_name" ]; then
      printf "[ERROR] %s can't be download\n" "$rar_name" "$download_time" >>"$logs_file"
    else
      printf "[DONE] %s downloaded (in %s)\n" "$rar_name" "$download_time" >>"$logs_file"
    fi
  else
    printf "[SKIP] %s already exists\n" "$rar_name" >>"$logs_file"
  fi

  rar_index=$((rar_index + 1))
  if [ "$((rar_index % 1))" -eq 0 ]; then
    currentTime=$(date +%s)
    echo "RAR number $rar_index / $NB_rar_to_DL downloaded ! Time Elapsed = $((currentTime - timeStart)) sec."
  fi
done <"$list"
