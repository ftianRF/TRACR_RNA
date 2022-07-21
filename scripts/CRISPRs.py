import argparse
import datetime
import glob
import os
import sys
#sys.path.append("scripts/")
#from CRISPRtools import PilerCRReader, MinCEDReader

parser = argparse.ArgumentParser(description="Detect CRISPR arrays")
parser.add_argument("-i", type=str, help="input path")
parser.add_argument("-o", type=str, help="output path")
args = parser.parse_args()

indir = args.i
outdir = args.o

assemblies = []
for ext in [".fa", ".fasta"]:
    assemblies.extend(glob.glob(os.path.join(indir, "*" + ext)))
assemblies = sorted(assemblies)
print ("Number of assemblies", len(assemblies))

if not os.path.exists(outdir):
    os.makedirs(outdir)
for assembly in assemblies:
    print(">", assembly)
    aid = os.path.splitext(os.path.basename(assembly))[0]
    # PilerCR
    if os.path.exists("%s/%s_pilerCR.out" % (outdir, aid)):
        print("{}/{}_pilerCR.out exists, skipped.".format(outdir, aid))
    else:
        pcmd = "pilercr -minid 0.85 -mincons 0.8 -noinfo -in %s -out %s/%s_pilerCR.out 2>%s/%s_pilerCR.err" %(assembly, outdir, aid, outdir, aid)
        retCode1 = os.system(pcmd)
        if retCode1 != 0:
            print(str(retCode1) + "  " + pcmd)
            break
    # minced
    if os.path.exists("%s/%s_minCED.out" % (outdir, aid)):
        print("{}/{}_minCED.out exists, skipped.".format(outdir, aid))
    else:
        mcmd = "minced -minRL 16 -maxRL 64 -minSL 8 -maxSL 64 -searchWL 6 %s %s/%s_minCED.out 2>%s/%s_minCED.err" % (assembly, outdir, aid, outdir, aid)
        retCode2 = os.system(mcmd)
        if retCode2 != 0:
            print(str(retCode2) + "  " + mcmd)
            break