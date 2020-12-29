class: AdventOfCode.class

run: AdventOfCode.class
	scala -classpath . AdventOfCode input.txt
clean:
	rm *.class

test:	AdventOfCode.class
	scala -classpath . AdventOfCode test.expect-1068781.txt

AdventOfCode.class: solution.scala
	scalac solution.scala

.PHONY:	clean
