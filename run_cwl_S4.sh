RABIX="/Users/mwyczalk/src/rabix-cli-1.0.4/rabix"
CWL="s4_parse_varscan.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"



$RABIX $RABIX_ARGS $CWL -- " \
--varscan_indel_raw /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/s2_run_varscan-2018-03-24-133230.292/root/varscan/varscan_out/varscan.out.som_indel.vcf \
--varscan_snv_raw /Users/mwyczalk/Projects/Rabix/SomaticWrapper.CWL1/results/s2_run_varscan-2018-03-24-133230.292/root/varscan/varscan_out/varscan.out.som_snv.vcf "


#--assembly GRCh37  \
#--use_vep_db 1 \
#--output_vep 1 \
#--strelka_config /usr/local/somaticwrapper/params/strelka.WES.ini \
#--results_dir . \
#--dbsnp_db /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz \
#--annotate_intermediate 1 \