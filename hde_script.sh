#!/bin/bash

# USAGE: ./run_pipeline_fast.sh genome.fa annotation.gtf tf_gene_list.tsv

# === INPUT ARGUMENTS ===
GENOME_FA="$1"
GTF_FILE="$2"
TF_GENE_FILE="$3"

#Output Folder/Directories creation 
BED_DIR="tf_beds"
FASTA_DIR="tf_fastas"

mkdir -p "$BED_DIR" "$FASTA_DIR"

# Build Chorome.sizes if needed later
echo 'Creating Chorme.sizes'
 if [ ! -f "${GENOME_FA}.fai" ]; then
    samtools faidx "$GENOME_FA"
fi
cut -f1,2 "${GENOME_FA}.fai" > chrom.sizes


# Extracte Gene_name -> chr , Tss and strand Map
echo "Extracting TSS Info"
awk '$3=="gene" {
    match($0, /gene_name "([^"]+)"/, a)
    if (a[1] != "") {
        tss = ($7 == "+" ? $4 : $5)
        print a[1]"\t"$1"\t"tss"\t"$7
    }
}' "$GTF_FILE" > all_genes_tss.tsv

#Join TF–gene list + gene TSS info, and Write Tf Beds
echo "Building Bed files"
awk 'FNR==NR {
    gene_map[$1]=$2"\t"$3"\t"$4
    next
}
{
    tf=$1; gene=$2
    if (gene in gene_map) {
        split(gene_map[gene], a, "\t")
        chr=a[1]; tss=a[2]; strand=a[3]
        if (strand == "+") {
            start = tss - 2000; end = tss + 500
        } else {
            start = tss - 500; end = tss + 2000
        }
        if (start < 0) start = 0
        out = "'"$BED_DIR"'/"tf".bed"
        print chr"\t"start"\t"end"\t"tf"_"gene"\t0\t"strand >> out
    }
}' all_genes_tss.tsv "$TF_GENE_FILE"

# Extracting Fasta per TF
echo "Extracting Fasta form bed"
for bed in "$BED_DIR"/*.bed; do
    tf=$(basename "$bed" .bed)
    bedtools getfasta -fi "$GENOME_FA" -bed "$bed" -s -name -fo "$FASTA_DIR/$tf.fa"
done

echo "[DONE] Upstream FASTAs saved in $FASTA_DIR/"

