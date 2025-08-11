## Extracting Human Transcription factor upsteame region and Building Background files 
Firstly Download the two required files .fa using `wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/GRCh38.primary_assembly.genome.fa.gz` and \n
.gtf file using `wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.annotation.gtf.gz` \n
After that unzip them using command `gunzip *.gz` 

#### Run the script `./run_pipeline_fast.sh genome.fa annotation.gtf tf_gene_list.tsv` 
This will generate directoirs all the TF regulated Upstream region
