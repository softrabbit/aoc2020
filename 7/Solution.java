// Advent of Code 2020, day 7 puzzles. A cup of Java, or two.
import java.util.HashSet;
import java.util.HashMap;
// import javafx.util.Pair;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

// Nope, not going to install javaFX now to get something this simple.
// The Java situation on my box is wonky enough already...
class MyPair {
    public Bag b;
    public Integer i;
    public MyPair(Bag B, int I) {
	b = B;
	i = I;
    }
}

// Represent a bag type
class Bag {
    public String name;
    // What does this contain
    public HashSet<MyPair> contents;
    // what other bags can contain this
    public HashSet<Bag> contained_by;
    public Bag(String n) {
	name = n;
	contents = new HashSet<MyPair>();
	contained_by = new HashSet<Bag>();
    }

    // These two for part 1 
    public int ultimatelyContainedBy() {
	// Starting point for the count of containers
	HashSet<Bag> seen  = new HashSet<Bag>();
	this.containedRecursion(seen);
	return seen.size();
    }
    
    private void containedRecursion(HashSet<Bag> seen) {
	for(Bag b: this.contained_by) {
	    if(!seen.contains(b) ) {
		seen.add(b);
		b.containedRecursion(seen);
	    }
	}
    }
    
    // This for part 2, I assume there can be no loops if there is an exact count to be had
    public int getTotalContents() {
	int count = 0;
	for(MyPair mp: this.contents) {	    
	    count += mp.i * (1 + mp.b.getTotalContents() );
	}
	return count;
    }

}




// Find out how many bags eventually can contain a shiny gold bag...
// smells like a graph to me.
class Solution {

    
    public static void main(String[] args) {
	// Keep all our bags in this
	HashMap<String, Bag> bagCollection = new HashMap<String,Bag>();
	BufferedReader r;
	String line;
	// "shiny teal bags contain 5 vibrant tan bags, 1 posh blue bag, 5 dotted gray bags."
	// "bright fuchsia bags contain no other bags."
	Pattern first = Pattern.compile("^(.*) bags contain (.*)\\.$");
	Pattern contained = Pattern.compile("([0-9]+) ([^0-9]*) bags?,?");
	// Read input file and create bag graph
	try {
	    r = new BufferedReader(new FileReader("input.txt"));
	    while(null != (line = r.readLine()) ) {
		Matcher m = first.matcher(line);
		if(m.find() ) {
		    // System.out.println(m.group(1) + ": " + m.group(2));
		    String bagname = m.group(1);
		    String contents = m.group(2);
		    Bag b = bagCollection.get(bagname);
		    if(b == null) {
			b = new Bag(bagname);
			bagCollection.put(bagname, b);
		    }
		    if(contents.equals("no other bags")) {
			// System.out.println("   EMPTY");
		    } else {
			m = contained.matcher(contents);
			while(m.find()) {
			    String inner_bag = m.group(2);
			    int count = Integer.parseInt(m.group(1));
			    Bag ib = bagCollection.get(inner_bag);
			    if(ib == null) {
				ib = new Bag(inner_bag);
				bagCollection.put(inner_bag, ib);
			    }
			    ib.contained_by.add(b);
			    b.contents.add(new MyPair(ib, count) );
			    // System.out.println("   " + m.group(1) );
			}
		    }
		}
	    }
	    r.close();
	    System.out.println(bagCollection.size() + " bags on the wall...");

	    // Part 1
	    Bag start = bagCollection.get("shiny gold");
	    System.out.println("... and "+ start.ultimatelyContainedBy() + " can contain shiny gold");

	    // Part 2
	    System.out.println("... but a shiny gold bag must contain "+ start.getTotalContents() + " bags.");
	    
	} catch(Exception e) {
	    e.printStackTrace();
	}
	
	// 
    }
}
