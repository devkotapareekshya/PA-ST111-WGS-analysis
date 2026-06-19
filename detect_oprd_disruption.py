import os
import argparse
import subprocess
import pandas as pd
import matplotlib.pyplot as plt

def setup_blast_db(assembly_path):
    print(f"[*] Creating BLAST database for {assembly_path}...")
    cmd = f"makeblastdb -in {assembly_path} -dbtype nucl -out assembly_db"
    subprocess.run(cmd, shell=True, check=True, stdout=subprocess.DEVNULL)

def run_blast(ref_path):
    print(f"[*] Running BLASTn against reference...")
    out_cols = "qseqid sseqid length qlen pident evalue sstart send"
    cmd = f"blastn -query {ref_path} -db assembly_db -outfmt '6 {out_cols}' -out blast_results.tsv"
    subprocess.run(cmd, shell=True, check=True)

def classify_hits(blast_file):
    # IF FILE IS EMPTY (GENE ABSENT)
    if os.stat(blast_file).st_size == 0:
        print("[!] No BLAST hits found. Gene is completely absent.")
        # Return an empty DataFrame with the correct column structure
        return pd.DataFrame(columns=['sseqid', 'length', 'qlen', 'coverage', 'pident', 'classification', 'color'])
        
    cols = ['qseqid', 'sseqid', 'length', 'qlen', 'pident', 'evalue', 'sstart', 'send']
    df = pd.read_csv(blast_file, sep='\t', names=cols)
    
    df['coverage'] = (df['length'] / df['qlen']) * 100
    
    classifications = []
    colors = []
    
    for idx, row in df.iterrows():
        if row['coverage'] >= 90 and row['pident'] >= 95:
            cls = "Full-length (Intact)"
            color = "green"
        elif 50 <= row['coverage'] < 90:
            cls = "Truncated"
            color = "orange"
        elif row['coverage'] < 50 and row['evalue'] < 1e-5:
            cls = "Pseudogene / Fragment"
            color = "red"
        else:
            cls = "Unclassified / Weak Hit"
            color = "gray"
            
        classifications.append(cls)
        colors.append(color)
        
    df['classification'] = classifications
    df['color'] = colors
    return df

def generate_plot(df, outdir):
    plt.figure(figsize=(10, 4))
    
    if df.empty:
        # Draw a clear message indicating target deletion
        plt.text(0.5, 0.5, 'OprD Porin Gene:\nCOMPLETELY ABSENT / DELETED', 
                 ha='center', va='center', color='red', fontsize=16, fontweight='bold')
        plt.xticks([])
        plt.yticks([])
    else:
        bars = plt.barh(df['sseqid'].astype(str) + f" ({df['classification'].str.split(' ').str[0]})", 
                        df['coverage'], 
                        color=df['color'], 
                        edgecolor='black')
        plt.xlim(0, 110)
        plt.xlabel('Reference Gene Coverage (%)', fontweight='bold')
        for bar in bars:
            width = bar.get_width()
            plt.text(width + 1, bar.get_y() + bar.get_height()/2, f'{width:.1f}%', 
                     va='center', ha='left', fontsize=9, fontweight='bold')
                 
    plt.title('OprD Status and Coverage Profile across Contigs', fontweight='bold', fontsize=14)
    plt.tight_layout()
    plot_path = os.path.join(outdir, 'oprd_coverage_plot.png')
    plt.savefig(plot_path, dpi=300)
    print(f"[+] Diagnostic plot saved to: {plot_path}")

def main():
    parser = argparse.ArgumentParser(description="Automated OprD Disruption Detection Script")
    parser.add_argument('--assembly', required=True, help="Path to assembly FASTA")
    parser.add_argument('--reference', required=True, help="Path to reference gene FASTA")
    parser.add_argument('--outdir', default="oprd_results", help="Output directory name")
    args = parser.parse_args()
    
    os.makedirs(args.outdir, exist_ok=True)
    
    setup_blast_db(args.assembly)
    run_blast(args.reference)
    
    df = classify_hits("blast_results.tsv")
    
    summary_path = os.path.join(args.outdir, 'oprd_summary.tsv')
    if df.empty:
        # Save a clean placeholder table so the workflow never breaks
        with open(summary_path, 'w') as f:
            f.write("sseqid\tlength\tqlen\tcoverage\tpident\tclassification\n")
            f.write("None\t0\t1332\t0.0\t0.0\tAbsent (Completely Deleted)\n")
        print(f"[+] Summary report saved to: {summary_path}")
    else:
        df[['sseqid', 'length', 'qlen', 'coverage', 'pident', 'classification']].to_csv(summary_path, sep='\t', index=False)
        print(f"[+] Summary report saved to: {summary_path}")
        
    generate_plot(df, args.outdir)
    
    if not df.empty:
        print("\n--- RUN SUMMARY ---")
        print(df[['sseqid', 'coverage', 'pident', 'classification']].to_string(index=False))
        
    for ext in ['.nhr', '.nin', '.nsq']:
        if os.path.exists("assembly_db" + ext):
            os.remove("assembly_db" + ext)
    if os.path.exists("blast_results.tsv"):
        os.remove("blast_results.tsv")

if __name__ == "__main__":
    main()
