package main

import( "fmt"
	"bufio"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// Interval, inclusive
type interval struct {
	from, to int
}

type field struct {
	label string
	legal_values []interval
}


// single return value atoi, because... well,
// you can't say { foo: strconv.Atoi(foostr), bar: strconv.Atoi(barstr) }
func atoi1(s string) int {
	i, e := strconv.Atoi(s)
	check(e)
	return i
}

// Convert slice of strings to ints
func atoi_slice(s []string) []int {
	var i []int
	for _,v := range s {
		i = append(i, atoi1(v))
	}
	return i
}


func main() {
	// Describes the ticket data fields
	var fields []field

	// Ticket data
	var myticket_fields []int
	var nearby [][]int

	// Status flags for what we're reading at the moment
	myticket := false
	nearbytickets := false

	// Parsing stuff, typical line "departure location: 36-269 or 275-973"
	var defRanges = regexp.MustCompile(`^([a-z ]+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)$`)
	var results []string

	// Read file, put data in some kind of structured variables
	f, err := os.Open("input.txt")
	check(err)
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		if myticket {
			// Previous line said this is my ticket
			myticket_fields = atoi_slice(strings.Split(scanner.Text(),","))
			myticket = false
		} else if nearbytickets {
			tmp := atoi_slice(strings.Split(scanner.Text(),","))
			nearby = append(nearby, tmp)
		}
		// Any field range definitions are handled here
		results = defRanges.FindStringSubmatch(scanner.Text())
		if results != nil {
			// fmt.Println(results)
			tmpfield := field {
				label: results[1],
			}
			tmpfield.legal_values =
				append(tmpfield.legal_values,
					interval { from: atoi1(results[2]),
						to: atoi1(results[3]), })
			tmpfield.legal_values =
				append(tmpfield.legal_values,
					interval { from: atoi1(results[4]),
						to: atoi1(results[5]), })
			// fmt.Println(tmpfield)
			fields = append(fields, tmpfield)
		} else {
			if scanner.Text() == "your ticket:" {
				myticket = true
			} else if scanner.Text() == "nearby tickets:" {
				nearbytickets = true
			}
		}
	}

	// Start by determining which tickets are completely invalid;
	// these contain values which aren't valid for any field (ignore your ticket for now)

	// Ugly brute force solution, should combine the intervals to one shorter list
	// for speed if this was real...
	sum := 0
	var to_remove []int
	for ticket := 0; ticket < (len(nearby)-1) ; ticket++ { // all tickets,
		ticket_OK := true
		for _, n := range nearby[ticket] {     // composed of numbers,
			OK := false
			for _,f := range fields { // checked against every fields...
				for _, i := range f.legal_values { // ...intervals of legal numbers
					if n >= i.from && n <= i.to {
						OK = true
					}
				}
			}
			if OK == false {
				sum += n
				ticket_OK = false
			}
		}
		if ticket_OK == false {
			// println(ticket,":",nearby[ticket])
			// Gather those to be discarded, don't know how to reslice inside loop
			to_remove = append(to_remove, ticket)			
		}
	}
	// Then remove...
	adjust := 0
	for _,r := range to_remove {
		// Reslice, with adjustment to the indexes for each removal.
		nearby = append(nearby[:r-adjust], nearby[r-adjust+1:]...)
		adjust += 1
	}	
	
	fmt.Println("Part 1: ",sum)


	// Part 2: figure out which field is which from the field intervals and ticket data
	var fieldarray [][]field
	for _ = range myticket_fields {
		fieldarray = append(fieldarray,fields)
	}

	// First loop through tickets and figure out possible fields for each position
	for _,t := range nearby { 	    
		for i := 0; i<len(t); i++ { 
			valid_fields := []field{}
			for _,fd := range fieldarray[i] { 
				for _,int := range fd.legal_values {
					if t[i] >= int.from && t[i] <= int.to {
						valid_fields = append(valid_fields, fd)
					}
				}
			}
			fieldarray[i] = valid_fields
		}
	}
	
	// Then keep finding lists of length 1 and remove their contents from the other lists.
	// Totally going to infinite loop if we get ambiguous input
	done := false
	eliminatable := []field{} // Elements of lists that have length 1 will be put here
	for !done {
		done = true
		for i := 0 ; i<len(fieldarray); i++ {
			if len(fieldarray[i]) > 1 {
				done = false 
				for _,f := range eliminatable {
					// Find f in fieldlist and remove
					for j:=0; j<len(fieldarray[i]); j++ {
						if fieldarray[i][j].label == f.label {
							fieldarray[i] =
								append(fieldarray[i][:j],fieldarray[i][j+1:]...)

						}
					}
					
				}
			} else if len(fieldarray[i]) == 1 {
				eliminatable = append(eliminatable, fieldarray[i][0])
			}
		}
	}

	// By now all fields should be unambiguous, so we can calculate the answer...
	// Sum of fields on my ticket that are named starting "departure"
	sum = 1
	for i := 0 ; i<len(fieldarray); i++ {
		m, e := regexp.MatchString(`^departure`, fieldarray[i][0].label);
		check(e)
		if m {
			sum *=  myticket_fields[i]
		}
	}
	fmt.Println("Part 2: ", sum)
	

}
