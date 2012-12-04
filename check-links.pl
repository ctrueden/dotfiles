#!/usr/bin/perl

#
# check-links.pl
#

# Simple script to check for broken URLs.

for my $file (@ARGV) {
  check($file);
}

sub check($) {
  my $file = shift;
  open FILE, $file or die $!;
  @pages = <FILE>;
  close(FILE);

  for $page (@pages) {
    chop $page;
    if ($page =~ /^http/) {
      @result = `curl -Is "$page"`;
      if ($result[0] !~ /200 OK/) {
        print "$page : $result[0]";
      }
    }
  }
}
