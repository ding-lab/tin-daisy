# Demonstration of running StrelkaDemo workflow using Rabix Executor and YAML configuration
#
# Note that for this demonstration is optimized for quick execution and minimal preparation.
# Production runs should be based on example in test.C3N-01649, which 
# uses VEP cache and deletes intermediate files

# The TinDaisy installation directory
TDD="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy"

CWL="cwl/workflows/tindaisy.cwl"

cd $TDD
YAML="demo/C3L-01032-katmai-demo/C3L-01032.katmai.yaml"

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

echo rabix $RABIX_ARGS $CWL $YAML
