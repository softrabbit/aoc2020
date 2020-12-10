// Read numbers from file, find the ones that add up to 2020
// and multiply them. Should be simple: sort, look for a fitting 
// number starting from both ends, adjusting the indexes for the
// candidates according to whether the sum is over or under

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
		let sum = lines[start] + lines[end];
		if (sum == target) {
			// We have a winner!
			console.log(lines[start] * lines[end]);
			return;
		} else if (sum > target) {
			end--;
		} else {
			start++;
		}
	}
});