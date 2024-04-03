#!/bin/bash
#Para simular el comportamiento de este script, correr primero blind.sh y luego dejar predictions solo en output
#example: ./multi.sh --vinalvl 2 --num_modes 5 --pockets 1,3

#Defaults
export ID=/home/aldo/pro/falcon/script4/input
export OD=/home/aldo/pro/falcon/script4/output
export WD=/home/aldo/pro/falcon/script4

export VINALVL=8
export NUM_MODES=9
export POCKETS=1 #by default, use the highest ranked pocket only
#TODO: should have MAX_POCKETS=1 and POCKETS UNDEFINED INSTEAD
#	   this will require modifications to box_multi.awk, in order to support any of the two
#	   we can't have both, so that will be checked in this script

usage() {
	echo "Usage: $O [options] [--] [input file]"
	echo "Options:"
	echo "  --input <value>    Input directory (default: $ID)"
	echo "  --output <value>    Output directory (default: $OD)"
	echo "  --vinalvl <value>    Level of exhaustiveness used by vina (default: $VINALVL)"
	echo "  --num_modes <value>    Maximum number of binding modes to generate (default: $NUM_MODES)"
	echo "  --chains <chain1,chain2,...>    Chains to run the docking on (default: all)"
	echo "  --pockets <rank1, rank2, rank3,...>    Rank of pockets to run the docking on (default: $POCKETS)"
	#echo "  --max_pockets <value>    Maximum number of pockets to use (default: $MAX_POCKETS)"
}

while [[ "$#" -gt 0 ]]; do
	case $1 in 
		--input) export ID="$2"; shift ;;
		--output) export OD="$2"; shift ;;
		--vinalvl) export VINALVL="$2"; shift ;;
		--num_modes) export NUM_MODES="$2"; shift ;;
		--chains) export CHAINS="$2"; shift ;;
		--pockets) export POCKETS="$2"; shift ;;
		--pockets) export POCKETS="$2"; shift ;;
		--) shift; break ;;
		*) usage; exit 1;;
	esac
	shift
done

cd $WD
./sanitize
./receptor_pre.sh #comentar si se utiliza desde la aplicación web
./ligand.sh
./receptor_multi.sh

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
