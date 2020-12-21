#!/usr/bin/perl

use strict;

#if(scalar @ARGV == 0 ) {
#	print "Usage: $0 input.txt\n";
#	exit;
#}

# Load program
my @program = [];
my $cmd;
my $arg;
while(<>) {
	($cmd, $arg) = split;
	push(@program, {"cmd" => $cmd, "arg" => $arg, "seen" => 0});
}
print(scalar @program);
print "\n";

#Run
my $pc = 1; # For some reason the @program array starts from 1, thought it should be from 0
my $acc = 0;
my $seen;
while(1) {
	print "${pc} : ${acc}\n";
	my %cur = %{$program[$pc]};
	if($cur{"seen"} != 0) {
		print "Terminated " + $acc + "\n";
		exit;
	} else {
		$program[$pc]{"seen"} = 1;
		if   ($cur{"cmd"} eq "acc") { $acc += $cur{"arg"}; $pc = $pc + 1; print "+\n";}		
		elsif($cur{"cmd"} eq "jmp") { $pc = $pc + ($cur{"arg"} + 0); print ">\n";}
		elsif($cur{"cmd"} eq "nop") { $pc = $pc + 1; print ".\n";}
	}
}
