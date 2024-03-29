import chimera
import os

from chimera import runCommand

inputdir = os.environ.get("ID")
outputdir = os.environ.get("OD")
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


# TODO: delete this
# def chain_names(recep):
#     print(recep.sequences(asDict=True).keys())


def chain_only(recep, chain_names):
    chains = recep.sequences(asDict=True)
    for chain in chains:
        if chain not in chain_names:
            for r in recep.sequence(chain).residues:
                if r is not None:
                    recep.deleteResidue(r)


# MAIN
inputfile = "%s/receptor.pdb" % inputdir
model = chimera.openModels.open(inputfile)
recep = model[0]

# configfile = "%s/config" % inputdir
# chain_names = open(configfile, "r").read().split(",")

if chains:
    chain_names = chains.split(",")
else:
    chain_names = recep.sequences(asDict=True)  # use all chains

chain_only(recep, chain_names)
prot_only(recep)
outputfile = "write format pdb 0 %s/receptor.pdb" % outputdir
runCommand(outputfile)
