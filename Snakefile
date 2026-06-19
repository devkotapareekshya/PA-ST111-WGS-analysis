import os

# 1. Automatically find any .fasta files in the assemblies folder
SAMPLES, = glob_wildcards("assemblies/{sample}.fasta")

# 2. The final targets we want to generate for every sample found
rule all:
    input:
        expand("results/{sample}/oprd_summary.tsv", sample=SAMPLES)

# 3. The core rule that runs your custom Python script
rule run_oprd_screen:
    input:
        assembly = "assemblies/{sample}.fasta",
        reference = "oprD_reference.fasta"
    output:
        summary = "results/{sample}/oprd_summary.tsv",
        plot = "results/{sample}/oprd_coverage_plot.png"
    message:
        "[*] Screen processing for sample: {wildcards.sample}"
    shell:
        """
        python detect_oprd_disruption.py \
            --assembly {input.assembly} \
            --reference {input.reference} \
            --outdir results/{wildcards.sample}
        """
