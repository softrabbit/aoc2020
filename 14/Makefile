solution.exe:	solution.dart
	dart compile exe solution.dart

test:		test-expect-51-208.txt solution.exe
	./solution.exe test-expect-51-208.txt

run:		input.txt solution.exe
	./solution.exe input.txt
clean:
	rm solution.exe
.PHONY:	clean
