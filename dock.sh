#!/bin/bash

WD=$SCRIPTDIR
VINADIR=$HOMEDIR/.local/src/autodock_vina_1_1_2_linux_x86/bin

echo -e "\e[1m\e[36m>>\e[39m docking...\033[0m"
cd $VINADIR
./vina --receptor $OD/receptor.pdbqt --ligand $OD/ligand.pdbqt\
	   --config $OD/box.txt --exhaustiveness=$VINALVL --out $OD/modes.pdbqt \
	   --num_modes $NUM_MODES \
	   | awk '/Refining/,/Writing/' | sed '1,2d;$d' >  $OD/scores.txt
cd $WD
