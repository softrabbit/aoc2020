// Read numbers from file, find three ones that add up to 2020
// and multiply them. 

// So... sort, scan two indices from each end of the array,
// and if their sum is less than 2020 try to find a third one
// in between that satisfies the condition?

let fs = require("fs");
const filename = "expense-report.txt";
const target = 2020;

fs.readFile(filename, "utf8", function (err, data) {
	if (err) throw err;

	let lines = data.split(/\r?\n/).map(Number);
	lines.sort((a, b) => ((a == b) ? 0 : (a > b) ? 1 : -1));

	let start = 0;
	let end = lines.length - 1;
	while (start <= end) {
		// Lower end until we're in range.
		// (as all numbers in between are >= lines[start] we can do a *2 to narrow the range)
		while (lines[start] * 2 + lines[end] > target && end > 0) {
			end--;
		}

		let x = target - (lines[start] + lines[end]);
		let mid = start + 1;
		while (mid < end && lines[mid] < x) {
			mid++;
		}
		if (lines[mid] == x) {
			console.log(lines[mid] + lines[start] + lines[end]);
			console.log(lines[mid] * lines[start] * lines[end]);
			return;
		}
		start++;
	}
});