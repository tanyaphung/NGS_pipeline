#!/bin/bash

. /u/local/Modules/default/init/modules.sh
module load bedtools

i=X
bedtools merge -i /path/to/input/file/ > /path/to/output/file/

for i in {1..38}
do
bedtools merge -i /path/to/input/file/ > /path/to/output/file/
done
