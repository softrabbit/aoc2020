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

# Change one instruction at a time, run the whole program and see if it works.
# Not as efficient as only running from a checkpoint onwards, but ATM I'll 
# favor clarity over cleverity.
for(my $p = 0; $p< $#program; $p++) {
    if($program[$p]{"cmd"} eq "jmp") {
	$program[$p]{"cmd"} = "nop";
    } elsif($program[$p]{"cmd"} eq "nop") {
	$program[$p]{"cmd"} = "jmp";
    } else {
	# Why try if no change
	next;
    }
    # print "Swapped $p\n";
    # Clear the run status before next try
    for(my $p2 = 0; $p2< $#program; $p2++) {
	# TODO: figure out foreach looping over array of references
	$program[$p2]{"seen"} = 0;
    }

    my($success, $acc) = run_program();
    if($success) {
	print "ACC: ${acc}\n";
	exit;
    } else {
	# Restore modified instruction after trying
	if($program[$p]{"cmd"} eq "jmp") {
	    $program[$p]{"cmd"} = "nop";
	} elsif($program[$p]{"cmd"} eq "nop") {
	    $program[$p]{"cmd"} = "jmp";
	}
    }
    print "Failed?\n";
}

sub run_program {
    my $pc = 0; 
    my $acc = 0;

    while(1) {
	if($pc == $#program + 1) {
	    return (1,$acc);
	} elsif( $pc > $#program || $pc < 0) {
	    return (0,0);
	} 
	my %cur = %{$program[$pc]};
	if( $cur{"seen"} != 0) {
	    return(0,0);
	} else {
	    $program[$pc]{"seen"} = 1;
	    if   ($cur{"cmd"} eq "acc") { $acc += $cur{"arg"}; $pc = $pc + 1; }		
	    elsif($cur{"cmd"} eq "jmp") { $pc = $pc + ($cur{"arg"} + 0); }
	    elsif($cur{"cmd"} eq "nop") { $pc = $pc + 1; }
	}
    }

}
