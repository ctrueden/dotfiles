#!/usr/bin/perl

use strict;

open(IN, "ci.txt");
my @repos = <IN>;
close(IN);

foreach my $repo (@repos) {
  chop $repo;
  print "$repo\n";

  open(IN, "$repo/pom.xml");
  my @lines = <IN>;
  close(IN);

  my @output = ();
  foreach my $line (@lines) {
    chop $line;
    if ($line =~ /<scm>/) {
      push(@output, "\t<ciManagement>");
      push(@output, "\t\t<system>Jenkins</system>");
      push(@output, "\t\t<url>http://jenkins.imagej.net/job/$repo/</url>");
      push(@output, "\t</ciManagement>");
      push(@output, "");
    }
    push(@output, $line);
  }

  open(OUT, ">$repo/pom.xml");
  foreach my $out (@output) {
    print OUT "$out\n";
  }
  close(OUT);
}
