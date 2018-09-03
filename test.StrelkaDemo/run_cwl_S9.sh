cd ..
source project_config.sh
CWL="cwl/s9_vep_annotate.cwl"

# try to have all output go to output_dir
mkdir -p $RESULTS_DIR
RABIX_ARGS="--basedir $RESULTS_DIR"

# Output of previous run to use as input here
OLD_RUN="/Users/mwyczalk/Projects/Rabix/TinDaisy/results/s8_merge_vcf-2018-08-22-123300.128"
INPUT_VCF="$OLD_RUN/root/results/merged/merged.filtered.vcf"

# Specific to denali:
VEP_CACHE_GZ="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP/vep-cache.90_GRCh37.tar.gz"
VEP_CACHE_DIR="/diskmnt/Projects/Users/mwyczalk/data/docker/data/D_VEP"

ARGS_DB="\
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
--vep_cache_version 90 \
--assembly GRCh37 \
--vep_cache_gz $CACHE_GZ \
"

ARGS_GZ="\
$ARGS_DB \
--vep_cache_version 90 \
--assembly GRCh37 \
--vep_cache_gz $VEP_CACHE_GZ \
"

#echo $ARGS_DB
#echo $ARGS_GZ

# We rely on online VEP cache lookup for initial testing, so vep_cache_dir is not specified

<<<<<<< Updated upstream
$RABIX $RABIX_ARGS $CWL -- $ARGS_GZ


||||||| merged common ancestors
$RABIX $RABIX_ARGS $CWL -- $ARGS


=======
$RABIX $RABIX_ARGS $CWL -- $ARGS
>>>>>>> Stashed changes
