#!/usr/bin/perl

# fix-github-remotes.pl

# This script updates GitHub remotes to use the more performant
# git:// protocol when fetching (while leaving the push URLs alone).

use strict;

my @remotes = `git remote -v`;

# parse remotes
my %fetch = ();
my %push = ();
for my $remote (@remotes) {
  chop $remote;
  (my $name, my $url, my $type) = split(/\s/, $remote);
  if ($type eq '(fetch)') {
    $fetch{$name} = $url;
  }
  elsif ($type eq '(push)') {
    $push{$name} = $url;
  }
  else {
    print STDERR "Ignoring remote: $remote\n";
  }
}

my $pushPattern = '^git@github.com:';
my $fetchPattern = 'git://github.com/';

for my $name (keys %fetch) {
  if (not defined $push{$name}) { next; }
  my $pushURL = $push{$name};
  if ($pushURL !~ /$pushPattern/) { next; }
  if ($pushURL !~ /\.git/) {
    # append missing .git suffix
    $pushURL .= '.git';
  }
  my $fetchURL = $pushURL;
  $fetchURL =~ s/$pushPattern/$fetchPattern/;
  my $fetchChanged = 0;
  if ($fetch{$name} ne $fetchURL) {
    # fetch URL does not match; update it
    my $cmd = "git remote set-url $name $fetchURL";
    print "$cmd\n";
    `$cmd`;
    $fetchChanged = 1;
  }
  if ($fetchChanged || $push{$name} ne $pushURL) {
    # push URL does not match; update it
    my $cmd = "git remote set-url --push $name $pushURL";
    print "$cmd\n";
    `$cmd`;
  }
}
