#!/bin/bash

for i in {1..256}; do
	echo "array size == $i"
       ./cache $i
done       
