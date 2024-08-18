#!/usr/bin/env zsh


cat urls.txt | while read line
do
    curl ${line} -o $(basename "$line")
done

