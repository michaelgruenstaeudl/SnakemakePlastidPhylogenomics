configfile: "snakefile.config.yaml"

## TO-DO
#   1. Improve logging by using in-built log function

rule all:
    input:
        "{sample}_assembly.log"

rule readmapping_with_Script05:
    input:
        RAWREADS = expand("{mysrc}/{{sample}}_{R}.fastq.gz", mysrc=config['READ_DIR'], R=[1,2])
    params:
        SCR5_EXE = config['SCR5_PTH'],
        REFG_PTH = config['REFG_DIR']+"/"+config['REFG_FLE'],
        REFG_NME = config['REFG_FLE'].strip(".fasta")
    output:
        (
        expand("{{sample}}.MappedAgainst.{refg_nme}_R1.fastq.gz", refg_nme=config['REFG_FLE'].strip(".fasta")),
        expand("{{sample}}.MappedAgainst.{refg_nme}_R2.fastq.gz", refg_nme=config['REFG_FLE'].strip(".fasta"))
        )
    shell:
        """
        echo {wildcards.sample} > {wildcards.sample}_readmapping.log ;
        bash {params.SCR5_EXE} {input.RAWREADS} {params.REFG_PTH} {wildcards.sample}_readmapping.log {wildcards.sample} ;
        rm {wildcards.sample}.MappedAgainst.{params.REFG_NME}.bam ;
        rm {wildcards.sample}.MappedAgainst.{params.REFG_NME}.fastq ;
        rm {wildcards.sample}.MappedAgainst.{params.REFG_NME}.*.stats ;
        rm {wildcards.sample}.MappedAgainst.{params.REFG_NME}.refdb.log ;
        gzip {wildcards.sample}.MappedAgainst.{params.REFG_NME}_R1.fastq ;
        gzip {wildcards.sample}.MappedAgainst.{params.REFG_NME}_R2.fastq ;
        """

rule assembly_with_NOVOPlasty:
    input:
        rules.readmapping_with_Script05.output
    params:
        NOVO_DIR = config['NOVO_DIR'],
        NOVO_EXE = config['NOVO_DIR']+"/NOVOPlasty3.8.3.pl",
        NOVO_CFG = config['NOVO_DIR']+"/config.txt",
        MAPREADS1 = rules.readmapping_with_Script05.output[0],
        MAPREADS2 = rules.readmapping_with_Script05.output[1],
        REFG_FLE = config['REFG_FLE'],
        REFG_PTH = config['REFG_DIR']+"/"+config['REFG_FLE']
    output:
        "{sample}_assembly.log"
    shell:
        """
        cp {params.NOVO_EXE} . ;
        cp {params.NOVO_CFG} ./{wildcards.sample}_config.txt ;
        cp {params.REFG_PTH} . ;
        echo {wildcards.sample} > {wildcards.sample}_assembly.log ;
        set +o pipefail ; ## Necessary for pipe operators in following line
        zcat {params.MAPREADS1} | head -n2 | sed 's/@/>/' > seed.fasta ;
        sed -i "s/Test/{wildcards.sample}/" {wildcards.sample}_config.txt ;
        sed -i "s/mito/chloro/" {wildcards.sample}_config.txt ;
        sed -i "s/12000-22000/140000-180000/" {wildcards.sample}_config.txt ;
        sed -i "s/\/path\/to\/seed_file\/Seed.fasta/seed.fasta/" {wildcards.sample}_config.txt ;
        sed -i "s/\/path\/to\/reads\/reads_1.fastq/{params.MAPREADS1}/" {wildcards.sample}_config.txt ;
        sed -i "s/\/path\/to\/reads\/reads_2.fastq/{params.MAPREADS2}/" {wildcards.sample}_config.txt ;
        sed -i "s/\/path\/to\/reference_file\/reference.fasta (optional)/{params.REFG_FLE}/" {wildcards.sample}_config.txt ;
        #perl {params.NOVO_EXE} -c {wildcards.sample}_config.txt >> {wildcards.sample}_assembly.log
        """
