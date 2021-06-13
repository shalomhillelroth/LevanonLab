# create argsparse
ARGPARSE_DESCRIPTION="Creates the commands for a GEO dataset"      # this is optional
source /private/common/Software/BashLibs/argparse-bash/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('-d', '--wanted_dir', type=str, help='Path of wanted analysis directory', required=True)
parser.add_argument('-s', '--dir_suffix',type=str, help='Suffix of directory and files', default="")
EOF

if [ "$DIR_SUFFIX" != "" ]; then 
    SUFFIX="_${DIR_SUFFIX}"
fi
# set -e
# # keep track of the last executed command
# trap 'last_command=\$current_command; current_command=\$BASH_COMMAND' DEBUG
# # echo an error message before exiting
# trap 'echo \"\"\${last_command}\" command filed with exit code \$?.\"' EXIT

# remove sra files
rm $WANTED_DIR/RawData/SRR*/SRR*.sra
rmdir $WANTED_DIR/RawData/SRR*/

# remove FastQC files
rm -r $WANTED_DIR/RawData/FastQC/*_fastqc $WANTED_DIR/RawData/FastQC$SUFFIX/*_fastqc.zip
rm -r $WANTED_DIR/RawData/FastQCRemovedDups/*_fastqc $WANTED_DIR/RawData/FastQCRemovedDups$SUFFIX/*_fastqc.zip
find $WANTED_DIR/RawData/FastQC -type d -name *_fastqc -exec rm -r '{}' \;
find $WANTED_DIR/RawData/FastQC$SUFFIX -type d -name *_fastqc -exec rm -r '{}' \;
find $WANTED_DIR/RawData/FastQCRemovedDups -type d -name *_fastqc -exec rm -r '{}' \;
find $WANTED_DIR/RawData/FastQCRemovedDups$SUFFIX -type d -name *_fastqc -exec rm -r '{}' \;

# remove salmon files and directories: leave .sf files
find $WANTED_DIR/Salmon_1.4.0$SUFFIX -type d -name aux_info -exec rm -r "{}" \;
find $WANTED_DIR/Salmon_1.4.0$SUFFIX -type d -name libParams -exec rm -r "{}" \;
find $WANTED_DIR/Salmon_1.4.0$SUFFIX -type d -name logs -exec rm -r "{}" \;
find $WANTED_DIR/Salmon_1.4.0$SUFFIX -type f -name '*.json' -delete

# remove out.tab STAR files
find $WANTED_DIR/STAR$SUFFIX -name '*out.tab*' -delete
