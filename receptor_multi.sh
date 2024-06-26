#!/bin/bash

WD=$SCRIPTDIR
ADFRDIR=$HOMEDIR/.local/src/adfr/ADFRsuite-1.0/bin
#ADFRDIR=$HOMEDIR/ADFRsuite-1.0/bin

cd $ADFRDIR
echo -e "\e[1m\e[36m>>\e[39m preparing receptor...\033[0m"
./reduce $OD/receptor.pdb >> $OD/receptorH.pdb
./prepare_receptor -r $OD/receptorH.pdb -o $OD/receptor.pdbqt

rm -f $WD/receptor.pyc #TODO: es necesario borrar receptor.pyc?
