# !/bin/bash

#Downloading genome file , if not downloaded already 
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip hg38.fa.gz

#Converting it to index file
samtools faidx hg38.fa

#Generate Random 2500 regions
bedtools random -l 2500 -n 100 -g hg38.fa.fai > random_region.bed

# Extract sequence
bedtools getfasta -fi hg38.fa -bed random_region.bed -fo Human_bg_seq.fa
