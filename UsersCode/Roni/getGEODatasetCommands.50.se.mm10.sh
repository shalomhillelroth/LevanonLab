# create argsparse
ARGPARSE_DESCRIPTION="Creates the commands for a GEO dataset"      # this is optional
source /private/common/Software/BashLibs/argparse-bash/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('-d', '--wanted_dir', type=str, help='Path of wanted analysis directory', required=True)
parser.add_argument('-l', '--srr_acc_list',type=str, help='SRR accession list with SRR of the wanted samples', required=True)
parser.add_argument('-s', '--dir_suffix',type=str, help='Suffix of directory and files', default="")
EOF

if [ "$DIR_SUFFIX" != "" ]; then 
    SUFFIX="_${DIR_SUFFIX}"
fi

echo "set -e" > $WANTED_DIR/commands$SUFFIX.sh
# keep track of the last executed command
echo "trap 'last_command=\$current_command; current_command=\$BASH_COMMAND' DEBUG" >> $WANTED_DIR/commands$SUFFIX.sh
# echo an error message before exiting
echo "trap 'echo \"\"\${last_command}\" command filed with exit code \$?.\"' EXIT" >> $WANTED_DIR/commands$SUFFIX.sh

echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh
echo "WANTED_DIR=${WANTED_DIR}" >> $WANTED_DIR/commands$SUFFIX.sh
echo "SUFFIX=${SUFFIX}" >> $WANTED_DIR/commands$SUFFIX.sh
echo "email=ronif10@gmail.com" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# check if directory exists and create if not
echo "[ ! -d \$WANTED_DIR/RawData/Logs ] && mkdir -p \$WANTED_DIR/RawData/Logs" >> $WANTED_DIR/commands$SUFFIX.sh
echo "[ ! -d \$WANTED_DIR/RawData/FastQC\${SUFFIX} ] && mkdir -p \$WANTED_DIR/RawData/FastQC\${SUFFIX}" >> $WANTED_DIR/commands$SUFFIX.sh
echo "[ ! -d \$WANTED_DIR/RawData/FastQCRemovedDups\${SUFFIX} ] && mkdir -p \$WANTED_DIR/RawData/FastQCRemovedDups\${SUFFIX}" >> $WANTED_DIR/commands$SUFFIX.sh
echo "[ ! -d \$WANTED_DIR/RawData/RemovedDupsFASTQ\${SUFFIX} ] && mkdir -p \$WANTED_DIR/RawData/RemovedDupsFASTQ\${SUFFIX}" >> $WANTED_DIR/commands$SUFFIX.sh

# create download command
echo "# download" >> $WANTED_DIR/commands$SUFFIX.sh
echo "sh /home/alu/fulther/Scripts/bash/General/downloadSequentialFasterqDump.sh -o \$WANTED_DIR/RawData/ -l $SRR_ACC_LIST > \$WANTED_DIR/RawData/Logs/downloadLog.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# remove duplicates + FastQC command" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/hillelr/scripts/GGPS/Session/PipelineManger.py -c /home/alu/fulther/ConfigsHillel/downloadFixup.SE.conf -d \$WANTED_DIR/RawData -t 0,2 -f fastq -o \$WANTED_DIR/RawData -l \$WANTED_DIR/RawData/Logs --no_extensions>> \$WANTED_DIR/RawData/Logs/deduperAndFastQC_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "### # download + remove duplicates + FastQC command" >> $WANTED_DIR/commands$SUFFIX.sh
echo "### python /home/alu/fulther/Scripts/scripts_python/General/DownloadWithPrefetchFasterqDump_FastQC_RemoveDups.py -o \$WANTED_DIR/RawData -l \$WANTED_DIR/RawData/Logs -s $SRR_ACC_LIST -t $SRA_RUN_TABLE --rmdups --fastqc > \$WANTED_DIR/RawData/Logs/downloadLog.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# summarize FastQC command" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/fulther/Scripts/scripts_python/General/fastqc_summarizer.py -d \$WANTED_DIR/RawData/FastQC\$SUFFIX -o \$WANTED_DIR/RawData/FastQC\$SUFFIX/analysis" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/fulther/Scripts/scripts_python/General/fastqc_summarizer.py -d \$WANTED_DIR/RawData/FastQCRemovedDups\$SUFFIX -o \$WANTED_DIR/RawData/FastQCRemovedDups\$SUFFIX/analysis" >> $WANTED_DIR/commands$SUFFIX.sh
echo "/home/alu/kobish/Exec/MLTQC/multiqc_wrapper/multiqc_wrapper -d \$WANTED_DIR/RawData/FastQC\$SUFFIX -o \$WANTED_DIR/RawData/FastQC\$SUFFIX/analysis" >> $WANTED_DIR/commands$SUFFIX.sh
echo "/home/alu/kobish/Exec/MLTQC/multiqc_wrapper/multiqc_wrapper -d \$WANTED_DIR/RawData/FastQCRemovedDups\$SUFFIX -o \$WANTED_DIR/RawData/FastQCRemovedDups\$SUFFIX/analysis" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# Salmon
# notice genome
# Salmon 1.4.0 - starting 9/2/2021
echo "#[ ! -d \$WANTED_DIR/Salmon\$SUFFIX ] && mkdir -p \$WANTED_DIR/Salmon\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "[ ! -d \$WANTED_DIR/Salmon_1.4.0\$SUFFIX ] && mkdir -p \$WANTED_DIR/Salmon_1.4.0\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# Run Salmon command: notice organism + gencode version" >> $WANTED_DIR/commands$SUFFIX.sh
echo "#python /home/alu/fulther/Scripts/scripts_python/General/SalmonQuantification.py -i \$WANTED_DIR/RawData/RemovedDupsFASTQ\$SUFFIX -o \$WANTED_DIR/Salmon\$SUFFIX -t 0,2 -f fastq.lzma -s /private/dropbox/Salmon_0.11.2/salmon_index/mm10_VM20_index -g /private/dropbox/Salmon_0.11.2/gtf/mm10_VM20/transcriptIDtoGene_name> \$WANTED_DIR/Salmon\$SUFFIX/runSalmon_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/hillelr/scripts/GGPS/Session/PipelineManger.py -c /private/common/Software/PipelineConfigs/runSalmon_1.4.0.conf -d \$WANTED_DIR/RawData/RemovedDupsFASTQ\$SUFFIX -t 0,2 -f fastq.lzma -o \$WANTED_DIR/Salmon_1.4.0\$SUFFIX -l \$WANTED_DIR/Salmon_1.4.0\$SUFFIX -a transcripts_index=\'/private/dropbox/Salmon_1.4.0/salmon_index/mm10\' tx2id_geneMap=\'/private/dropbox/Salmon_1.4.0/salmon_index/mm10/gencode_VM23.transcriptToGeneID.tab\' >> \$WANTED_DIR/Salmon_1.4.0\$SUFFIX/runSalmon_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# unite output" >> $WANTED_DIR/commands$SUFFIX.sh
echo "Rscript /home/alu/fulther/Scripts/scripts_R/General/uniteSalmonFIles.R -i \$WANTED_DIR/Salmon_1.4.0\$SUFFIX -o \$WANTED_DIR/Salmon_1.4.0\$SUFFIX --wide_samples" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# STAR
# notice genome + read length
echo "[ ! -d \$WANTED_DIR/STAR\$SUFFIX ] && mkdir -p \$WANTED_DIR/STAR\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# Run STAR command: notice genome + read length" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/hillelr/scripts/GGPS/Session/PipelineManger.py -c /private/common/Software/PipelineConfigs/runSTAR.conf -d \$WANTED_DIR/RawData/RemovedDupsFASTQ\$SUFFIX -t 0,2 -f fastq.lzma -o \$WANTED_DIR/STAR\$SUFFIX -l \$WANTED_DIR/STAR\$SUFFIX -a STAR_genome=\'/private/dropbox/Genomes/Mouse/mm10.STAR.7.ReadsLn50.gencodeM18\' >> \$WANTED_DIR/STAR\$SUFFIX/runSTAR_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# summarize STAR command" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/fulther/Scripts/scripts_python/General/STARstatsV2.py -r \$WANTED_DIR/STAR\$SUFFIX -o \$WANTED_DIR/summary/STAR --plot -po \$WANTED_DIR/summary/plots/STAR --prefix '$DIR_SUFFIX' &" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# AEI
# notice genome
echo "[ ! -d \$WANTED_DIR/AluEditingIndex\$SUFFIX ] && mkdir -p \$WANTED_DIR/AluEditingIndex\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# Run AEI command: notice genome" >> $WANTED_DIR/commands$SUFFIX.sh
echo "RNAEditingIndex1.1 -d \$WANTED_DIR/STAR\$SUFFIX -l \$WANTED_DIR/AluEditingIndex\$SUFFIX -o \$WANTED_DIR/AluEditingIndex\$SUFFIX -os \$WANTED_DIR/AluEditingIndex\$SUFFIX --genome mm10 >> \$WANTED_DIR/AluEditingIndex\$SUFFIX/runAluIndex_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# HE
# notice genome
echo "[ ! -d \$WANTED_DIR/HE\$SUFFIX ] && mkdir -p \$WANTED_DIR/HE\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# Run HE command: notice genome" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/hillelr/scripts/GGPS/Tools/HyperEditing/HyperEditingRunner.py -d  \$WANTED_DIR/STAR\$SUFFIX -o \$WANTED_DIR/HE\$SUFFIX -os \$WANTED_DIR/HE\$SUFFIX/summary -so \$WANTED_DIR/STAR\$SUFFIX --no_recurring_reads -f lzma -mp 'Unmapped.out.mate' -m2 No2Mate -u lzcat -se -gf /private/dropbox/Genomes/Mouse/mm10/all.fa -gi /private/dropbox/Genomes/Mouse/mm10/all -gti /private/dropbox/Genomes/Mouse/mm10/all>> \$WANTED_DIR/HE\$SUFFIX/runHE_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# HE stats command" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/fulther/Scripts/scripts_python/General/AnalyzeStatisticsHE.py -d \$WANTED_DIR/HE\$SUFFIX -i SE_0.05_0.6_30_0.6_0.1_0.8_0.2 -o \$WANTED_DIR/summary/HE\$SUFFIX -po \$WANTED_DIR/summary/plots/HE\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# HE new parameters
# notice genome
echo "[ ! -d \$WANTED_DIR/HE\$SUFFIX ] && mkdir -p \$WANTED_DIR/HE\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# Run HE command: notice genome" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/hillelr/scripts/GGPS/Tools/HyperEditing/HyperEditingRunner.py -d  \$WANTED_DIR/STAR\$SUFFIX -o \$WANTED_DIR/HE\$SUFFIX -os \$WANTED_DIR/HE\$SUFFIX/summary -so \$WANTED_DIR/STAR\$SUFFIX --no_recurring_reads -f lzma -mp 'Unmapped.out.mate' -m2 No2Mate -u lzcat -se -gf /private/dropbox/Genomes/Mouse/mm10/all.fa -gi /private/dropbox/Genomes/Mouse/mm10/all -gti /private/dropbox/Genomes/Mouse/mm10/all --he_to_mm_ratio 0.8>> \$WANTED_DIR/HE\$SUFFIX/runHE_Log.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# HE stats command" >> $WANTED_DIR/commands$SUFFIX.sh
echo "python /home/alu/fulther/Scripts/scripts_python/General/AnalyzeStatisticsHE.py -d \$WANTED_DIR/HE\$SUFFIX -i SE_0.05_0.8_30_0.6_0.1_0.8_0.2 -o \$WANTED_DIR/summary/HE\$SUFFIX -po \$WANTED_DIR/summary/plots/HE\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# ISG
# notice orgnism
echo "[ ! -d \$WANTED_DIR/ISG\$SUFFIX ] && mkdir -p \$WANTED_DIR/ISG\$SUFFIX" >> $WANTED_DIR/commands$SUFFIX.sh
echo "# Run ISG command: notice organism" >> $WANTED_DIR/commands$SUFFIX.sh
echo "Rscript /home/alu/fulther/Scripts/scripts_R/General/ZMAD_ScoreCalc_V2.R -i \$WANTED_DIR/Salmon_1.4.0\$SUFFIX/SalmonTPM.wideSamples.csv -o \$WANTED_DIR/ISG\$SUFFIX -p ArticleCalcLog2 --log2 --isg /home/alu/fulther/GeneralData/ISG/ISG_sorted_mouse.txt" >> $WANTED_DIR/commands$SUFFIX.sh
echo -e "\n" >> $WANTED_DIR/commands$SUFFIX.sh

# send final email
echo "mail -s 'Analysis of \${WANTED_DIR} Has Finished' $email <<< 'Analysis for \$WANTED_DIR \\$SUFFIX is done. Enjoy :)'" >> $WANTED_DIR/commands$SUFFIX.sh
