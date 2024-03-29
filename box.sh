#!/bin/bash

echo -e "\e[1m\e[36m>>\e[39m getting gridbox (coarse)...\033[0m"
awk -f box.awk $OD/receptor.pdbqt | tee $OD/box.txt

#echo num_modes=1 >> $OD/coarse_box.txt #TODO: poner esto en el script de awk
