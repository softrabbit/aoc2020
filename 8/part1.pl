#!/usr/bin/perl

use strict;
# Check for empty args and STDIN on terminal
if($#ARGV == -1 && -t STDIN) {
    print "Usage: $0 input.txt # or using a pipe\n";
    exit;
}

# Load program
my @program = ();
my $cmd;
my $arg;
while(<>) {
    ($cmd, $arg) = split;
    push(@program, {"cmd" => $cmd, "arg" => $arg, "seen" => 0});
}
print(scalar @program);
print "\n";

#Run until loop detected
my $pc = 0; 
my $acc = 0;
my $seen;
while(1) {
    my %cur = %{$program[$pc]};
    if($cur{"seen"} != 0) {
	print $acc;
	print "\n";
	exit;
    } else {
	$program[$pc]{"seen"} = 1;
	if   ($cur{"cmd"} eq "acc") { $acc += $cur{"arg"}; $pc = $pc + 1; }		
	elsif($cur{"cmd"} eq "jmp") { $pc = $pc + ($cur{"arg"} + 0); }
	elsif($cur{"cmd"} eq "nop") { $pc = $pc + 1; }
    }
}
