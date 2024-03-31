#!/bin/bash
#Para simular el comportamiento de este script, correr primero blind.sh y luego dejar predictions solo en output
#example: ./multi.sh --vinalvl 2 --num_modes 5 --pockets 1,3

#Defaults
export ID=/home/aldo/pro/falcon/script4/input
export OD=/home/aldo/pro/falcon/script4/output
export WD=/home/aldo/pro/falcon/script4

export VINALVL=8
export NUM_MODES=9
export POCKETS=1

usage() {
	echo "Usage: $O [options] [--] [input file]"
	echo "Options:"
	echo "  --input <value>    Input directory (default: $ID)"
	echo "  --output <value>    Output directory (default: $OD)"
	echo "  --vinalvl <value>    Level of exhaustiveness used by vina (default: $VINALVL)"
	echo "  --num_modes <value>    Maximum number of binding modes to generate (default: $NUM_MODES)"
	echo "  --chains <chain1,chain2,...>    Chains to run the docking on (default: all)"
	echo "  --pockets <rank1, rank2, rank3,...>    Rank of pockets to run the docking on (default: $POCKETS)"
}

while [[ "$#" -gt 0 ]]; do
	case $1 in 
		--input) export ID="$2"; shift ;;
		--output) export OD="$2"; shift ;;
		--vinalvl) export VINALVL="$2"; shift ;;
		--num_modes) export NUM_MODES="$2"; shift ;;
		--chains) export CHAINS="$2"; shift ;;
		--pockets) export POCKETS="$2"; shift ;;
		--) shift; break ;;
		*) usage; exit 1;;
	esac
	shift
done

cd $WD
#./sanitize
./ligand.sh
./receptor.sh

OLD_IFS=$IFS
IFS=','
for rank in $POCKETS; do
	export CURRENT_POCKET=$rank
	export CURRENT_POCKET_DIR="$OD/pocket_{$CURRENT_POCKET}"
	IFS=$OLD_IFS
	mkdir $CURRENT_POCKET_DIR
	./box_multi.sh
	./dock_multi.sh
done

#awk -f $WD/pocketindices.awk $OD/receptor.pdbqt_predictions.csv > $OD/resfile
