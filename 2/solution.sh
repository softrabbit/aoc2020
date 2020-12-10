#!/bin/sh

# Part 1
# Validate lines in the format [min]-[max] [char]: [string]
# so that the character occurs between min and max times in the string

INPUT=input.txt
awk '/^([[:digit:]]+)-([[:digit:]]+) ([a-z]): (.*)$/ { \
	line=$0 \
	split($1, limits, "-"); # get high and low \
	gsub(/:$/, "", $2); # remove colon \
	matches = gsub($2, "", $3);\
	if(matches >= limits[1] && matches <= limits[2]) { print line; } \
}' <$INPUT |wc -l


# Part 2
# For the same input, validate that the char the character occurs exactly once 
# in the positions min and max in the string

INPUT=input.txt
awk '/^([[:digit:]]+)-([[:digit:]]+) ([a-z]): (.*)$/ { \
	line=$0 \
	split($1, limits, "-"); # get high and low \
	gsub(/:$/, "", $2); # remove colon \
	split($3, a, ""); # split string \
	if( (a[limits[1]] == $2 || a[limits[2]] == $2) && a[limits[1]] != a[limits[2]] ) { \
		print line; \
	} \	
}' <$INPUT |wc -l

