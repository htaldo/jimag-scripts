import chimera
import os

from chimera import runCommand

"""
modded version of receptor.py
currently, we can't have shell args, so instead of specifying input and output
like this, we'll use env vars
"""

inputfile = os.environ.get("IF")
outputfile = os.environ.get("OF")
chains = os.environ.get("CHAINS")


# MODULE

def del_res(recep, residue_list):
    for res_type in residue_list:
        for r in recep.residues:
            if r.type == res_type:
                recep.deleteResidue(r)


def prot_only(recep):
    for r in recep.residues:
        if r.isHet:
            recep.deleteResidue(r)


def chain_only(recep, chain_names):
    chains = recep.sequences(asDict=True)
    for chain in chains:
        if chain not in chain_names:
            for r in recep.sequence(chain).residues:
                if r is not None:
                    recep.deleteResidue(r)


# MAIN

model = chimera.openModels.open(inputfile)
recep = model[0]

if chains:
    chain_names = chains.split(",")
else:
    chain_names = recep.sequences(asDict=True)  # use all chains

chain_only(recep, chain_names)
prot_only(recep)
outputcmd = "write format pdb 0 %s" % outputfile
runCommand(outputcmd)
