#!/bin/bash
#Para simular el comportamiento de este script, correr primero blind.sh y luego dejar predictions solo en output
#example: ./multi.sh --vinalvl 2 --num_modes 5 --pockets 1,3
#NOTE: max_pockets = 1 and pockets = 1 should yield the same result

#Defaults
export ID=/home/aldo/pro/falcon/script4/input
export OD=/home/aldo/pro/falcon/script4/output
export WD=/home/aldo/pro/falcon/script4

export VINALVL=4
export NUM_MODES=5

usage() {
	echo "Usage: $O [options] [--] [input file]"
	echo "Options:"
	echo "  --input <value>    Input directory (default: $ID)"
	echo "  --output <value>    Output directory (default: $OD)"
	echo "  --vinalvl <value>    Level of exhaustiveness used by vina (default: $VINALVL)"
	echo "  --num_modes <value>    Maximum number of binding modes to generate (default: $NUM_MODES)"
	echo "  --chains <chain1,chain2,...>    Chains to run the docking on (default: all)"
	echo "  --pockets <rank1, rank2, rank3,...>    Rank of pockets to run the docking on (default: 1)"
	echo "  --max_pockets <value>    Maximum number of pockets to use (default: 1)"
	echo "  --preproc_done    Intended for webapp usage. Assumes clean protein and pocket files are already in output dir"
}

while [[ "$#" -gt 0 ]]; do
	case $1 in 
		--input) export ID="$2"; shift ;;
		--output) export OD="$2"; shift ;;
		--vinalvl) export VINALVL="$2"; shift ;;
		--num_modes) export NUM_MODES="$2"; shift ;;
		--chains) export CHAINS="$2"; shift ;;
		--pockets) export POCKETS="$2"; shift ;;
		--max_pockets) export MAX_POCKETS="$2"; shift ;;
		--preproc_done) export PREPROC=1; shift ;;
		--) shift; break ;;
		*) usage; exit 1;;
	esac
	shift
done

cd $WD
./sanitize
#if no preprocessing has been made, do the following as a part of full auto
if [[ -z "$PREPROC" ]]; then
	./receptor_pre.sh
fi
./ligand.sh
./receptor_multi.sh

#manage pockets
if [[ -n "$MAX_POCKETS" && -n "$POCKETS" ]]; then
	echo "WARNING: SET POCKETS AND MAX_POCKETS. IGNORING MAX_POCKETS"	
	export MAX_POCKETS=""
fi
if [[ -n "$MAX_POCKETS" && -z "$POCKETS" ]]; then
	# if max_pockets is greater than the pockets given by p2rank, fall back to the later
	PRANK_ROWS="$(wc -l < $OD/receptor.pdb_predictions.csv)"
	# subtract the headers row
	PREDICTED_POCKETS=$((PRANK_ROWS - 1))
	echo "WARNING: MAX_POCKETS GREATER THAN NUMBER OF PREDICTED POCKETS ($PREDICTED_POCKETS)"
	echo "WARNING: FALLING BACK TO PREDICTED_POCKETS"
	if [[ "$MAX_POCKETS" -gt "$PREDICTED_POCKETS" ]]; then
		MAX_POCKETS="$PREDICTED_POCKETS"
	fi
	#translate max_pockets to a pockets use case
	export POCKETS="$(./max2pockets $MAX_POCKETS)"
fi
if [[ -z "$MAX_POCKETS" && -z "$POCKETS" ]]; then
	#take only the first pocket (full auto)
	export POCKETS=1
fi
echo $POCKETS > "$OD/pockets" #this file will be used to update the docking instance

#perform docking on each pocket
OLD_IFS=$IFS
IFS=','

for rank in $POCKETS; do
	echo -e "\e[1m\e[36m>>\e[39m processing pocket $rank...\033[0m"
	export CURRENT_POCKET=$rank
	export CURRENT_POCKET_DIR="$OD/pocket_$CURRENT_POCKET"
	IFS=$OLD_IFS
	mkdir $CURRENT_POCKET_DIR
	./box_multi.sh
	./dock_multi.sh
	echo -e "\e[1m\e[36m>>\e[39m splitting conformers...\033[0m"
	obabel -ipdbqt "$CURRENT_POCKET_DIR/modes.pdbqt" -opdbqt -O "$CURRENT_POCKET_DIR/mode_.pdbqt" -m
done

#awk -f $WD/pocketindices.awk $OD/receptor.pdbqt_predictions.csv > $OD/resfile
