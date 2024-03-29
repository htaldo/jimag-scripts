#!/bin/bash

echo -e "\e[1m\e[36m>>\e[39m cleaning receptor...\033[0m"
cd $CHIMDIR; ./chimera --nogui $WD/receptor.py
