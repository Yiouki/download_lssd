![badge version](https://img.shields.io/static/v1?style=plastic&label=Version&message=0.7&color=yellow)
![code version](https://img.shields.io/static/v1?style=plastic&label=Code&message=up-to-date&color=brightgreen)
![upload version](https://img.shields.io/static/v1?style=plastic&label=Upload&message=current&color=critical)

# About the work
The goal of this script is to download the **Large Scale Steganalysis Database** (LSSD) developed by Hugo Ruiz in the
article [[1]]. All the information concerning the development of the base is in this article.

The database is hosted on the website: http://www.lirmm.fr/~chaumont/LSSD.html and gives access to **different versions of LSSD** but
also to the **original RAW images** allowing everyone to develop their own databases.

Thanks to this script, it is possible to download several image formats (JPEG, MAT & RAW), in color or grayscale, as
well as the so-called "Cover" or "Stego" images. In our case, there is only one payload for stego images: 0.2 bpnzacs.
 
All the hosted data represents a storage of more than 6 TB, the files to be downloaded are in RAR format with a size
of 10 GB (max). The number of files may vary depending on the overall size of the desired folder. The architecture of
the database is shown in the PDF [[2]], it allows to identify the downloadable databases. The biggest bases being very
large, the script identifies the elements that have already been downloaded and allows to have a follow-up in order
to avoid wasting time unnecessarily.
 
# Usage
## Download
### Options
 In order to facilitate access to the LSSD database, this script allows the user to directly download the database he
wants. To do so, it is necessary to provide a certain number of parameters :
- `-b` / `--base_name`: the name of the desired database (ex: LSSD_10k, ALASKA2)
- `t` / `--type`: the format requested if it is not a RAW (JPEG or MAT) base
- `-c` / `--coloring`: allows to choose if it's a color or grayscale image (Color or Gray)
- `-n` / `--nature`: choice between the images "Cover" & "Stego". In the case of the choice "Stego", it is necessary
to add the payload requested (ex: Stego_P02)
- `-o` / `--output` (optional): allows you to choose in which directory to download the files

In the case where the `-o` option is not used, the script recreates the same architecture as the initial DB in the
folder `./downloaded`.

For more information, you can use the script without any option `sh LSSD_download_script.sh` or with the option
 `-h` / `--help` like this `sh LSSD_download_script.sh -h`.

### Examples
To download the LSSD base in MAT format, with 10k gray images stego with a payload of 0.2 bpnzacs:

    sh LSSD_download_script.sh -b LSSD_10k -t MAT -c Gray -n Stego_P02 -o ./tst_LSSD

To download a RAW database, it's simpler because you only have to specify the name of the database you want by adding
"RAW_" in front of it. Here is the command line to be executed to download the ALASKA2 database:

    sh LSSD_download_script.sh -b RAW_ALASKA2

## Decompression
Once all the files have been downloaded, it is then possible to decompress them on the command line. First, go to the
folder that contains all the RAR files `cd path/where/are/all_rar`.

Then execute the following command:

    unrar x -e rar_name.part001.rar

Or this one if there is a single file:

    unrar x -e rar_name.rar

# Databases available
## LSSD
### Color
| Base name 	|  JPEG (Cover)	        |
|-----------	|:---------------:	    |
| LSSD_10k  	| :heavy_check_mark: 	|
| LSSD_50k  	| :heavy_check_mark:   	|
| LSSD_100k 	| :heavy_check_mark: 	|
| LSSD_500k 	| :heavy_check_mark: 	|
| LSSD_1M   	| :heavy_check_mark: 	|
| LSSD_2M   	| :heavy_check_mark: 	|
| TST_100k  	| :heavy_check_mark: 	|

### Grayscale
| Base name 	|    JPEG (Cover)    	|    JPEG (Stego)    	|     MAT (Cover)    	|     MAT (Stego)    	|
|-----------	|:------------------:	|:------------------:	|:------------------:	|:------------------:	|
| LSSD_10k  	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	|
| LSSD_50k  	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	|
| LSSD_100k 	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	|
| LSSD_500k 	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	| :heavy_check_mark: 	|
| LSSD_1M   	| :heavy_check_mark: 	| :heavy_check_mark:  	| :heavy_check_mark: 	| :heavy_check_mark: 	|
| LSSD_2M   	| :heavy_check_mark: 	| :heavy_check_mark:  	| :heavy_check_mark: 	| :heavy_check_mark: 	|
| TST_100k  	| :heavy_check_mark: 	| :heavy_check_mark:  	| :heavy_check_mark: 	| :heavy_check_mark: 	|

## RAW
| Base name  	|    JPEG (Cover)    	|
|------------	|:------------------:	|
| ALASKA2    	| :heavy_check_mark: 	|
| BOSS       	| :heavy_check_mark: 	|
| Dresden    	| :heavy_check_mark: 	|
| RAISE      	| :heavy_check_mark: 	|
| TST        	| :heavy_check_mark: 	|
| StegoApp   	| :heavy_check_mark: 	|
| Wesaturate 	| :heavy_check_mark: 	|

[1]: Creation_GrandeBase_Steganalyse_DL.pdf
[2]: DB_structure.pdf