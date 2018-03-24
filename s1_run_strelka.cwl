class: CommandLineTool
cwlVersion: v1.0
id: s1_run_strelka
baseCommand:
  - /usr/bin/perl
  - /usr/local/somaticwrapper/SomaticWrapper.pl
inputs:
  - id: tumor_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--tumor_bam'
  - id: normal_bam
    type: File
    inputBinding:
      position: 0
      prefix: '--normal_bam'
  - id: reference_fasta
    type: File
    inputBinding:
      position: 0
      prefix: '--reference_fasta'
  - id: strelka_config
    type: File
    inputBinding:
      position: 0
      prefix: '--strelka_config'
outputs:
  - id: snvs_passed
    type: File
    outputBinding:
      glob: strelka/strelka_out/results/passed.somatic.snvs.vcf
  - id: indels_passed
    type: File
    outputBinding:
      glob: strelka/strelka_out/results/passed.somatic.indels.vcf
label: S1_run_strelka
arguments:
  - position: 99
    prefix: ''
    separate: false
    shellQuote: false
    valueFrom: '1'
  - position: 0
    prefix: '--results_dir'
    valueFrom: .
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl'
'sbg:job':
  inputs:
    tumor_bam:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    normal_bam:
      basename: n.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: 'n'
      path: /path/to/n.ext
      secondaryFiles: []
      size: 0
    reference_fasta:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
    strelka_config:
      basename: input.ext
      class: File
      contents: file contents
      nameext: .ext
      nameroot: input
      path: /path/to/input.ext
      secondaryFiles: []
      size: 0
  runtime:
    cores: 1
    ram: 1000