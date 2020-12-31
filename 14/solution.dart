import 'dart:io';

// Recursion part for the "masks" function
List<String> masks_internal(String mask) {
  var masks = new List<String>();
  if (mask.contains("X")) {
    masks.addAll(masks_internal(mask.replaceFirst("X", "0")));
    masks.addAll(masks_internal(mask.replaceFirst("X", "1")));
  } else {
    masks.add(mask);
  }
  return masks;
}

// Generate list of all bitmasks defined by "0000X100X00X"
// i.e. fill in all possible combinations of bits.
// This could grow up to be an Iterator some day?
List<int> masks(String mask) {
  var tmp = masks_internal(mask).map((S) => int.parse(S, radix: 2)).toList();
  // print(tmp);
  return tmp;
}

void main(List<String> argv) {
  if (argv.length == 0) {
    print("No input");
    exit(0);
  }

  // keep our simulated memory in this
  var memory = new Map<int, int>();

  File file = new File(argv[0]);
  List<String> lines = file.readAsLinesSync();
  var andmask = 0;
  var ormask = 0;
  RegExp mem_exp = new RegExp(r"mem\[([0-9]+)\]");

  // Parse and write to memory
  lines.forEach((l) {
    List<String> parts = l.split("=").map((S) => S.trim()).toList();

    if (parts[0] == "mask") {
      andmask = int.parse(parts[1].replaceAll("X", "1"), radix: 2);
      ormask = int.parse(parts[1].replaceAll("X", "0"), radix: 2);
      // print("$andmask : $ormask");
    } else {
      Match m = mem_exp.matchAsPrefix(parts[0]);
      int address = int.parse(m.group(1));
      int value = int.parse(parts[1]);
      int final_value = value & andmask | ormask;
      // print("$address = $value -> $final_value");
      memory[address] = final_value;
    }
  });

  // Sum and print
  var sum = 0;
  for (var v in memory.values) {
    sum += v;
  }
  print("Part 1 says: $sum");

  // On to part 2, where the mask string is applied to the memory address...
  memory = new Map<int, int>();
  // NB. this initializes to null, can't have it inside loop
  int firstmask;
  String masktemplate;
  var masklist;

  lines.forEach((l) {
    List<String> parts = l.split("=").map((S) => S.trim()).toList();

    if (parts[0] == "mask") {
      masktemplate = parts[1];
      // print(masktemplate);
      // This blocks all X-bits
      andmask = int.parse(
          masktemplate.replaceAll("0", "1").replaceAll("X", "0"),
          radix: 2);
      ormask = int.parse(masktemplate.replaceAll("X", "0"), radix: 2);

      // 1 in mask are forcing 1s in the output
      firstmask = int.parse(masktemplate.replaceAll("X", "0"), radix: 2);
      masklist = masks(masktemplate);
    } else {
      Match m = mem_exp.matchAsPrefix(parts[0]);
      int address = int.parse(m.group(1));
      int value = int.parse(parts[1]);
      int baseaddr = (address | firstmask) & andmask;

      masklist.forEach((item) {
        // print((baseaddr | (~andmask & item)).toString()+ " <- "+value.toString());
        memory[baseaddr | (~andmask & item)] = value;
      });
    }
  });

  sum = 0;
  for (var v in memory.values) {
    sum += v;
  }
  print("Part 2 says: $sum");
}
