#!/bin/bash

# copy the raw shared table
cp /Volumes/GoogleDrive/My\ Drive/E4Ldrugdevice/regulation_table.csv ../data/

# run the R script to build html table
Rscript regulation_table.R

# final formatting
## For multiple tables on one html page, the <script>s used cause both tables to disappear. Therefore for table 2, edit the output to only contain only the <body> ... </body> content from the bottom of the document. The scripts in table 1 will be applied on both. You must also comment out the <!DOCTYPE html> for table 1. grep with the flag “-A” to print number of lines “After” match,
cd ../output
grep -v "<!DOCTYPE html" regulation_table.html > regulation_table_clean.html
grep -A 20 "<body " regulation_table_summary.html | grep -v "</html>" > regulation_table_summary_clean.html

cd ../src
printf "\nmultiple table page formatting scripts cleaned\n"

# Labour illustration
cp /Volumes/GoogleDrive/My\ Drive/E4Ldrugdevice/dylan_notes_docs/yed_maps/development_plan.* ../output/
