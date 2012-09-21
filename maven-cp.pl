#!/usr/bin/perl

#
# maven-cp.pl
#

# A script to output a Java classpath for the given Maven GAVs,
# including their dependencies.

# Requires command line mvn to be installed.

# Example of usage:
#   maven-cp.pl edu.ucar:netcdf:4.2.20

use strict;

unless (`which mvn`) {
	# no Maven installation
	exit 1;
}

# prefix to local Maven repository cache
my $repo = $ENV{'HOME'} . '/.m2/repository/';

# table mapping GAVs to repository path prefixes
my %gavHash;

# create combined dependency list of all GAV arguments
for my $gav (@ARGV) {
	process(\%gavHash, $gav);
}

# print the results as a classpath string
my $first = 1;
foreach my $gav (sort keys %gavHash) {
	if ($first) { $first = 0; }
	else { print ':'; }
	my $prefix = $gavHash{$gav};
	print "$prefix.jar";
}
print "\n";

# processes the given GAV, adding it + dependencies to the specified hash
sub process($$) {
	my $gavHash = shift;
	my $gav = shift;

	# have we already processed this GAV?
	if (exists $gavHash->{$gav}) {
		# nothing to do; we already parsed this GAV
		return;
	}

	# check that the GAV's POM exists
	my $prefix = pathPrefix($gav);
	$gavHash->{$gav} = $prefix;
	my $pom = "$prefix.pom";
	if (not -e $pom) {
		print STDERR "[WARNING] Non-existent POM: $pom\n";
		return;
	}

	# ask Maven for the dependencies (including transitive dependencies)
	my @depsOutput = `mvn -f "$pom" dependency:list`;
	my $inList = 0;
	for my $line (@depsOutput) {
		chop $line;
		if ($line =~ /The following files have been resolved:/) {
			$inList = 1;
			next;
		}
		if (not $inList) { next; }
		if ($line !~ /:/) { last; }
		my $gapvs = substr($line, 10);
		my ($groupId, $artifactId, $packaging, $version, $scope) =
			split(':', $gapvs);
		if ($packaging eq 'jar' && ($scope eq 'compile' || $scope eq 'runtime')) {
			my $depGAV = "$groupId:$artifactId:$version";
			my $depPrefix = pathPrefix($depGAV);
			$gavHash->{$depGAV} = $depPrefix;
		}
	}
}

# Returns the path in the local Maven repository cache, for the given GAV.
sub pathPrefix($) {
	my $gav = shift;
	(my $groupId, my $artifactId, my $version) = split(':', $gav);
	$groupId =~ s/\./\//g;
	$artifactId =~ s/\./\//g;
	return "$repo$groupId/$artifactId/$version/$artifactId-$version";
}
