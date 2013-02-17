#!/usr/bin/perl
use strict;
use Net::DNS;
use Net::IP;

# Adapted from a script by Scrapheap of EliteHackers:
# http://www.elitehackers.info/forums/showthread.php?t=824

# Check our arguments are valid and if not then bail out.
my $network = $ARGV[0];
if ($network !~ /^\d+\.\d+\.\d+\.\d+\/\d+$/) {
  print "Usage: $0 x.x.x.x/x\n";
  print "Where x.x.x.x/x is the network to list\n";
  print "Suggested: x.x.x.0/24\n";
  exit;
}

# Create a resolver for resolving our reverse DNS lookups.
my $res = Net::DNS::Resolver->new;

# Create an IP object to save us from having
# to write some complex code to work out IPs.
my $IP = new Net::IP($network)
  or die("Unable to create network object for $network\n");

# Loop through each IP in the range
do {
  # create the reverse lookup DNS name (note that the
  # octets in the IP address need to be reversed).
  my $target_IP = join('.', reverse split(/\./, $IP->ip())).".in-addr.arpa";

  # Perform a query on the produced name.
  # (note we want the PTR records for the name).
  my $q = $res->query("$target_IP", "PTR");

  if ($q) {
    # If the query was valid then get the answer.
    my $r = ($q->answer)[0];
    # If the query produces something other than
    # a PTR record there is something wrong so die.
    if ($r->type ne "PTR") { die "not PTR"; }
    # If we get here then everything is fine and we can display our answer.
    print $r->rdatastr."\t".$target_IP."\n";
  }
}
while (++$IP); # Keep looping though IPs until we have tried them all.
