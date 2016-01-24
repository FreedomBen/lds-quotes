#!/bin/bash

for i in {1..52}; do
    echo "Requesting page $i"
    wget -O "p${i}.html" "http://www.ldsquotes.org/quotes?tab=popular&page=${i}"
    sleep 3
done
