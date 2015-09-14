# Altmetric Technical Exercises Inbox

TODO/Discussion:

* Different articles having the same DOI e.g. 10.1234/altmetric997 is a duplicate.
This could lead to confusion over who authored what. The DOI uniquely identifies
an article so can suffice for comparing two articles;
* 'Check digits' of ISSNs and this ISSNs of the form \d{4}-\d{3}[\dxX] (see git branch 'issn')
X means check-digit of 10
* Articles with missing journals or authors are excluded at rendering time as a
conservative approach. Could model these with a concept such as MissingJournal and
no authors represented as an empty list but this depends on client usage.
