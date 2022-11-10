#!/bin/bash
Save webpage is source
copy <body> to new file
cd data
# cat ichwebpage.html | sed -n 's/.*href="\([^"]*\).*/\1/p' > ichwebpage_href.txt
# This does not work correctly. Rewrite
