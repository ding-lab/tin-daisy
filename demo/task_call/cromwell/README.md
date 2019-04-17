Testing of cromwell CWL engine for TinDaisy at MGI

* Tracking runs here: https://docs.google.com/spreadsheets/d/12ANLh3H1dgZcGFwmCjL3i-XZHtukeicw6DtboAjMT7E/edit#gid=0

# TODO
* When GBM is done, clean up cromwell directories into one clean directory, describe clean setup for production
* Add discussion about MutectDemo, whose YAML file is in ./config

# Run procedure

Preparation:
1. Possibly edit `config/cromwell-config-db.dat`
   -> this will define where the output of Cromwell goes, which can be large
   Currently, output directory is DATAD=`/gscmnt/gc2741/ding/cptac/cromwell-workdir`
   This file also defines hooks for connecting to MGI Cromwell DB, which a lot of workflow relies on (`cq` in particular)
2. Possibly `config/project_config.dat`.  For MGI, it has the following definitions
```
    * NORMAL_BAM - from BamMap
    * TUMOR_BAM  - from BamMap
    * REF        - /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh38.d1.vd1.fa
    * TD_ROOT    - /gscuser/mwyczalk/projects/TinDaisy/TinDaisy 
    * DBSNP_DB   - /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/dbSnP-COSMIC.GRCh38.d1.vd1.20190415.vcf.gz
                   see katmai:/home/mwyczalk_test/Projects/TinDaisy/sw1.3-compare/README.dbsnp.md for details
    * VEP_CACHE_GZ - /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/D_VEP/vep-cache.90_GRCh38.tar.gz
```
3. Create file `dat/cases.dat`, which lists all cases we'll be processing
   Note that entries here will be used to find BAMs in BamMap to populate YAML files

Start runs.  Here, assuming that will use `parallel` to run N Cromwell instances on MGI at once. Note that order
here is important so that processes are not stranded after you log out
4. Run `tmux new` on known machine (e.g., `virtual-workstation1`).  
5. `0_start_docker.sh`
6. `conda activate jq`.  This environment contains `jq`, `parallel`, and `tmux`
7. `1_make_yaml.sh` - this will generate start configuration files for all cases in `cases.dat`
8. Edit `2_run_tasks.sh` to define the number of cromwell jobs to run at once: `ARGS="-J N"`
   If `parallel` prints a bunch of citation information, run `parallel --citation` - this typically has to be done just once per system
9. Start runs with `2_run_tasks.sh`.  
   You can detach from `tmux` now and jobs will continue

Iteratively check status of runs
10. `cq` will list status of all runs.  `cq` is a utility in `TinDaisy/src` with a lot of options; run `cq -h` to learn more.  

When runs conclude  (this is undergoing revision)
11. Run `3_make_analysis_summary.sh` to collect all results
12. Clean run directories 

# Additional details

## Cases vs. WorkflowID

## Usage of `cq`

## Logs
Stashing of a log involves moving all output in `logs/` (CASE.out, CASE.err, CASE.log) and `yaml/CASE.yaml` to directory `logs/WID`

### logs/RunLog.dat

Keeps track of all runs which have been assigned a WorkflowID by cromwell. Consists of status entries, oldest on bottom,
with the following fields:
* `CASE`
* `WorkflowID`
* `Status`
* `StartTime`
* `EndTime`
* `Comment` - optional, may indicate whether a restart, etc.

Once logs are stashed, association between WorkflowID and CASE is made with the RunLog.  Note that can have
mutiple entries per case and/or WorkflowID (possibly with different Status); the most recent one is the one
used for WorkflowID / Case association.

### DATAD/DataLog.dat

Keeps track of run data and any cleaning that may take place following run completion.  There is one DataLog
per cromwell data directory, and is appended to 1) when a run is finalized and 2) when run data is cleaned.
DataLog has the following fields
* `CASE`
* `WorkflowID`
* `CleanLevel` - see below
* `Date`

## Cleaning

Levels of cleaning of run data in DATD for a given run.  DataLog keeps track of all such cleaning steps
* `original` - Status indicating data is as generated by completed workflow
* `inputs` - `inputs` subdirectories in all steps deleted.  This is assumed to occur for all levels below
* `compress` - All data in intermediate steps compressed but not deleted
* `prune` - All intermediate per-step data deleted.  Final per-step data and logs retained, compressed
* `final` - Keep only final outputs of each run
* `wipe` - Delete everything


# Additional development notes 

## VCF Parameters 

We wish to have the following flags for vcf invocation, per Bobo:
```
vep \
    --hgvs --shift_hgvs 1 --no_escape \
    --symbol --numbers --ccds --uniprot --xref_refseq --sift b \
    --tsl --canonical --total_length --allele_number \
    --variant_class --biotype       \
    --flag_pick_allele              \
    --pick_order tsl,biotype,rank,canonical,ccds,length
```

## Connect to db
Cromwell database on MGI is at https://genome-cromwell.gsc.wustl.edu/.  Can do a lot of manual queries here

Description of connection to Cromwell:
https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=CI&title=Cromwell#Cromwell-ConnectingtotheDatabase

## Disk space

Complete run data size of `C3L-00104` run, `/gscmnt/gc2741/ding/cptac/cromwell-workdir/cromwell-executions/tindaisy.cwl/6abf1c89-aac2-4b40-8ff4-8616fa728853`
-> 147G

This may not even account for all files, since some directories start with - and may not be reported.  For instance, with 50Gb tumor (?) bams staged
four times for four callers, would expect 200+Gb for that file alone.

### Cleanup notes
Running `rm -rf */inputs` reduces disk use to 663M
Compressing `call-mutect/execution/mutect_call_stats.txt` reduces file size from 435M to 95M

`call-parse_varscan_snv/execution/results/varscan/filter_snv_out/varscan.out.som_snv.Germline*.vcf` are two files which take up 27M and 29M, and
are not used

`call-run_strelka2/execution/results/strelka2/strelka_out/workspace` is a temp directory which is 97M in size, can be compressed or deleted

-> It is possible to reduce size of completed job significantly with a cleanup script

### Memory issues

Observed a failure of run_pindel with BusError (seems to correlate with memory
issues) (run 59433723-3ce6-4a1c-ad99-f17368c401ea) when run with 16Gb memory.
Increased memory in run_pindel CWL to 24000Mb

Note that metadata output seems to indicate how much memory is used.  This can be used to tune memory requirements
more precisely per-step.

### CPU issues

Both run_pindel and run_strelka2 have adjustable numbers of threads / CPUs to run at once.
This can be assessed using `cq -q timing`.  Current testing suggests 5 and 4 threads for pindel and strelka2, respectively,
seems to make run times roughly uniform.  Mutect and varscan don't seem to have an option to adjust thread counts.
