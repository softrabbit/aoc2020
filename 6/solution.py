#!/usr/bin/env python3

# Part 1: Sum of counts of unique characters in each group

total = 0

with open("input.txt") as f:
    group = set()
    for line in f:
        line = line.strip()
        if(line == ""):
            # At end of group 
            # count elements in set and add to total
            total = total + len(group)
            group = set()
        else:
            group = group.union(set(line))
                
    # Last add after EOF
    total = total + len(group)
print( total )


#Part 2: Sum of counts of "questions to which everyone answered yes"
total = 0
with open("input.txt") as f:
    group = set()
    first = True
    for line in f:
        line = line.strip()
        if(line == ""):
            # At end of group 
            # count elements in set and add to total
            total = total + len(group)
            first = True
        else:
            if first:
                # Init group from first line in group, intersect with empty would be stupid
                group = set(line)
                first = False
            else:
                group = group.intersection(set(line))
                
    # Last add after EOF
    total = total + len(group)


print( total )
