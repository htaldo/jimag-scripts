#!/bin/bash

WD=$SCRIPTDIR
ADFRDIR=$HOMEDIR/.local/src/adfr/ADFRsuite-1.0/bin
CHIMDIR=$HOMEDIR/.local/src/chimera/bin

echo -e "\e[1m\e[36m>>\e[39m CHAINS: '$CHAINS' \033[0m"
echo -e "\e[1m\e[36m>>\e[39m cleaning receptor...\033[0m"

export IF=$ID/receptor.pdb
export OF=$OD/receptor.pdb
cd $CHIMDIR; ./chimera --nogui $WD/receptor.py
cd $ADFRDIR
echo -e "\e[1m\e[36m>>\e[39m preparing receptor...\033[0m"
./reduce $OD/receptor.pdb >> $OD/receptorH.pdb
./prepare_receptor -r $OD/receptorH.pdb -o $OD/receptor.pdbqt

rm -f $WD/receptor.pyc
