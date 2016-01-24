#!/bin/bash
# Remove those pesky unicode chars and save to lds-quotes-file.txt
cat p*.out | sed 's/[“”]/"/g' | sed 's/–/-/g' | sed 's/\r/"/g' > lds-quotes-file.txt
