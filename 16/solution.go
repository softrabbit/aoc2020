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

// Interval, 
type interval struct {
	from, to int
}

type field struct {
	label string
	legal_values []interval
}

// single return value atoi, because... well.
func atoi1(s string) int {
	i, e := strconv.Atoi(s)
	check(e)
	return i
}

func atoi_slice(s []string) []int {
	var i []int
	for _,v := range s {
		i = append(i, atoi1(v))
	}
	return i
}

func main() {
	var defRanges = regexp.MustCompile(`^([a-z ]+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)$`)
	var results []string
	var fields []field

	var myticket_fields []int
	var nearbyticket_fields [][]int
	
	myticket := false
	nearbytickets := false
	
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
			nearbyticket_fields = append(nearbyticket_fields, tmp)
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
			fmt.Println(tmpfield)
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

	// Ugly brute force solution
	sum := 0
	for _, ticket := range nearbyticket_fields { // all tickets,
		for _, n := range ticket {     // composed of numbers
			OK := false
		CheckLoop:
			for _,f := range fields { // checked against every fields
				for _, i := range f.legal_values { // intervals of legal numbers
					if n >= i.from && n <= i.to {
						OK = true
						break CheckLoop
					}
				}
			}
			if OK == false {
				sum += n
			}
		}
	}

	fmt.Println(sum)
	fmt.Println(myticket_fields)
	// fmt.Println(nearbyticket_fields)
	
	
}
