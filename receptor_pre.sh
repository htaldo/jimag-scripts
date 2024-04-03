#!/bin/bash
#Simula las funciones realizadas por process_pockets en jobs/tasks.py
SCRIPTPATH=/home/aldo/pro/falcon/script4/receptor_pre.py
CHIMERACMD=/home/aldo/.local/src/chimera/bin/chimera
#CHIMERADIR=/home/aldo/.local/src/chimera/bin
PRANKCMD=/home/aldo/.local/src/p2rank_2.4/prank
PRANKCONF=/home/aldo/pro/falcon/script4/configs/blind.groovy

#remember: receptor_pre.py takes env variables
export IF=$ID/receptor.pdb
export OF=$OD/receptor.pdb

$CHIMERACMD --nogui $SCRIPTPATH
#cd $CHIMERADIR
#./chimera --nogui $WD/receptor_pre.py
#cd $WD
$PRANKCMD predict -c $PRANKCONF -f $OF -o $OD
