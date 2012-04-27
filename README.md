check_feeds
===========

Checks a list of feeds to see which ones (a) have not been updated in &#39x&#39; days, or (b) are broken.
Accepts a single file as input, containing one feed per line. Run it like this:

	./check_feeds <feeedlist.txt>

Bugs:
1. Does not handle broken feeds well.
2. Does not handle opml.
 