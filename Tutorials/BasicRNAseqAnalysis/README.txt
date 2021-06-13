copied from /private6/common/Data/DataSets/Covid19_PRJNA660067/Fastq

Data of COVID-19 samples (blood)
PE

for srr in SRR12544667 SRR12544668 SRR12544529 SRR12544530 SRR12544647 SRR12544648 SRR12544421 SRR12544422; do
	head -n 400000 /private6/common/Data/DataSets/Covid19_PRJNA660067/Fastq/${srr}_1.fastq > /home/alu/fulther/Validations/IntroDays2021/RawData/${srr}_1.fastq;
	head -n 400000 /private6/common/Data/DataSets/Covid19_PRJNA660067/Fastq/${srr}_2.fastq > /home/alu/fulther/Validations/IntroDays2021/RawData/${srr}_2.fastq;
done


commands created with 
sh /home/alu/fulther/Scripts/bash/General/getGEODatasetCommands.50.pe.hg38.sh -d /home/alu/fu  lther/Validations/IntroDays2021 -t "/home/alu/fulther/Validations/IntroDays2021/SraRunTable_GSE157103.csv" -l "/  home/alu/fulther/Validations/IntroDays2021/SraRunTable_GSE157103.csv"