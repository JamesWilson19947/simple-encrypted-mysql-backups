#!/bin/bash

schemas=( 
	"example"  
	)

# iterate over each element in turn
for schema in "${schemas[@]}"; do
  ./backup.sh $schema
done


