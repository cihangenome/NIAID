#!/bin/bash

#ExampleRun: bash MultiQC.sh "/path/to/BATCH" "BATCH_QC" "snakejobs" {Note: Remove Quotes and do not include "/" after first argument}


cd $1
mkdir $2
cd $1/$2
mkdir $3
cd $1/$2

cp /hpcdata/dir/SCRIPTS/NCBR_github/NIAID/WES_QC/Multiqc.snakemake /hpcdata/dir/SCRIPTS/NCBR_github/NIAID/WES_QC/MultiQC.sh /hpcdata/dir/SCRIPTS/NCBR_github/NIAID/WES_QC/run.json /hpcdata/dir/SCRIPTS/NCBR_github/NIAID/WES_QC/cluster.json $1/$2

module load snakemake
CLUSTER_OPTS="qsub -pe threaded {cluster.threads} -l h_vmem={cluster.mem} -l virtual_free={cluster.vmem} -wd $1/$2/$3"
snakemake -k --stats snakemake.stats --rerun-incomplete --restart-times 10 -j 100  --cluster-config cluster.json --cluster "$CLUSTER_OPTS" --keep-going --snakefile Multiqc.snakemake --report $2.snakemakereport.html > log.txt 2>&1 &
