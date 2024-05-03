#!/bin/bash

#Defaults
export ID=$SCRIPTDIR/input
export OD=$SCRIPTDIR/output
export WD=$SCRIPTDIR

export VINALVL=4
export NUM_MODES=2

usage() {
	echo "Usage: $O [options]"
	echo "Options:"
	echo "  --input <value>    Input directory (default: $ID)"
	echo "  --output <value>    Output directory (default: $OD)"
	echo "  --vinalvl <value>    Level of exhaustiveness used by vina (default: $VINALVL)"
	echo "  --num_modes <value>    Maximum number of binding modes to generate (default: $NUM_MODES)"
	echo "  --chains <chain1,chain2,...>    Chains to run the docking on (default: all)"
}

while [[ "$#" -gt 0 ]]; do
	case $1 in 
		--input) export ID="$2"; shift ;;
		--output) export OD="$2"; shift ;;
		--vinalvl) export VINALVL="$2"; shift ;;
		--num_modes) export NUM_MODES="$2"; shift ;;
		--chains) export CHAINS="$2"; shift ;;
		--) shift; break ;;
		*) usage; exit 1;;
	esac
	shift
done

cd $WD
./sanitize
./ligand.sh
./receptor.sh
./pocket.sh
./box.sh
./dock.sh

awk -f $WD/pocketindices.awk $OD/receptor.pdbqt_predictions.csv > $OD/resfile
