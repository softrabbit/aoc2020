<?php

// Validate passport fields in file

$file="input.txt";
$handle = fopen($file, "r");
if($handle) {
    $passport = array();
    $counter1 = 0;
    $counter2 = 0;
    while($line = fgets($handle, 100) ) {
        $line = trim($line);
        if(feof($handle) ) {
        } else if($line=="") {
            $counter1 += check_passport($passport) ? 1 : 0;
            $counter2 += check_passport_2($passport) ? 1 : 0;
            $passport = array();
        } else {
            $fields = explode(" ", $line);
            foreach($fields as $f) {
                list($k,$v) = explode(":",$f);
                $passport[$k] = $v;
            }
        }
    }
    $counter1 += check_passport($passport) ? 1 : 0;
    $counter2 += check_passport_2($passport) ? 1 : 0;
    echo "{$counter1} -- {$counter2}\n";
}

// Simple passport check for part 1
function check_passport($p) {
    foreach(array("byr","iyr","eyr","hgt","hcl","ecl","pid") as $k) {
        if(!array_key_exists($k, $p)) {
            return false;
        }
    }
    return true;
}


// Helper, is $x between (including) $min and $max?
function between($x, $min, $max) {
    return ($min <= $max && $x >= $min && $x <=$max);
}

// Check part 2, more advanced
function check_passport_2($p) {
    // Avoid whining about undefined keys
    if(!check_passport($p)) return false;

    // byr (Birth Year) - four digits; at least 1920 and at most 2002.
    if( !between($p["byr"], 1920, 2002) ) return false;

    // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    if( !between($p["iyr"], 2010, 2020) ) return false;

    // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    if( !between($p["eyr"], 2020, 2030) ) return false;

    // hgt (Height) - a number followed by either cm or in:
    //     If cm, the number must be at least 150 and at most 193.
    //     If in, the number must be at least 59 and at most 76.
    if(preg_match("/^([0-9]+)(cm|in)$/", $p["hgt"], $m)) {
        if($m[2] == "cm" && !between($m[1], 150, 193) ) return false;
        if($m[2] == "in" && !between($m[1], 59,  76)  ) return false;
    } else {
        return false;
    }
    
    // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    if(!preg_match("/^#[0-9a-f]{6}$/", $p["hcl"])) return false;

    // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    if(!in_array($p["ecl"], array("amb", "blu", "brn", "gry", "grn", "hzl", "oth"))) {
        return false;
    }

    // pid (Passport ID) - a nine-digit number, including leading zeroes.
    if(!preg_match("/^[0-9]{9}$/", $p["pid"])) return false;

    // cid (Country ID) - ignored, missing or not.
    return true;
}

?>