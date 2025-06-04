#!/usr/bin/env bash
# Workflow parameter and description configuration shared by CLI scripts

# Each entry lists a human-readable description followed by its parameters.
# A trailing '*' marks a required parameter and '(value)' gives a default.

declare -A workflow_definitions=(
    [download_databases]="Install Databases (Kneaddata, Metaphlan, Humann) | outdir(results)"
    [qc_dna]="Quality Control for DNA | input* outdir(results)"
    [qc_rna]="Quality Control for RNA | input* outdir(results)"
    [microbial_profiles]="Get microbial profiles with Metaphlan and Humann | input* outdir(results)"
    [gene_call]="Assemble contigs and predict genes with Megahit and Prodigal | input* catalog outdir(results)"
)
