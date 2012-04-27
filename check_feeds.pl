#!/usr/bin/perl
use strict;
use warnings;
use XML::Feed;
use DateTime;

# Change $older_than to x to check feeds older than x days.
my $older_than=60;

my $today = DateTime->now->set_time_zone( 'local' );
my $post_age; my $dur; my $postdate;
my @old_feeds; my @bad_feeds;

# Get file from argv and open for reading
my $file = shift @ARGV;
open(my $fh,'<',$file) or die "Couldn't open $file for reading.\n";

while (my $line = <$fh>) {
  if (my $feed = XML::Feed->parse(URI->new($line))) {
    for my $entry ($feed->entries) {
      if (defined($entry->issued)) {
	$postdate = $entry->issued;
      } elsif (defined($entry->modified)) {
	$postdate = $entry->modified;
      } elsif (defined($entry->updated)) {
	$postdate = $entry->updated;
      } else {
	# If we got in here, we couldn't extract the date, so flag this as a bad feed.
	push @bad_feeds, $line;
	last;
      }
      $dur = $today->delta_days($postdate);
      $post_age = $dur->in_units("days");
      # Uncomment this line if you want the Feed Title and Date
      # print $feed->title, " - ", $post_age, "\n";
      if ($post_age > $older_than) {
	# If we got in here, the post is older than $older_than days
	push @old_feeds, $line;
      }
      last;
    }
  } else {
    # If we got in here, XML::Feed failed, so we flag this one as a dead feed.
    push @bad_feeds, $line;
  }
}
print "Feeds older than", $older_than, " days  are: \n";
print @old_feeds, "\n";
print "Dead feeds that could not be read are: \n ";
print @bad_feeds, "\n";
