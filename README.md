SnakemakePlastidPhylogenomics
=============================
*Version: 2022.05.03, Author: Michael Gruenstaeudl*

Snakemake workflow for StandardizedPlastidPhylogenomics

INTRODUCTION
------------
Prerequisites:
- [snakemake](https://snakemake.github.io/)
- [bowtie2](https://github.com/BenLangmead/bowtie2)
- [samtools](https://github.com/samtools/samtools)
- [bedtools](https://github.com/arq5x/bedtools2)

USAGE
-----

#### Mandatory files
```
$ ls
Snakefile
snakefile.config.yaml
```

#### Conducting assemblies
```
snakemake -j 1 output_sample1/
snakemake -j 1 output_sample2/
snakemake -j 1 output_sample3/
```

#### Vizualizing graphs
```
snakemake --dag output_{sample1,sample2,sample3} | dot -Tsvg > dag.svg
```


NOTE
----
`Script05.sh` is taken from:

Gruenstaeudl M, Gerschler N, Borsch T. Bioinformatic Workflows for Generating Complete Plastid Genome Sequences—An Example from Cabomba (Cabombaceae) in the Context of the Phylogenomic Analysis of the Water-Lily Clade. Life. 2018; 8(3):25. [https://doi.org/10.3390/life8030025](https://doi.org/10.3390/life8030025)
