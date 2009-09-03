#!/usr/bin/env perl

# ght.pl - a github script for package maintainers.

# Copyright (c) 2009 Lars Hartmann
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#    1. Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

use strict;
use warnings;

use Getopt::Std;
use Switch;

our $VERSION="0.0.99";

sub show_usage
{
     print STDERR <<EOF;
Usage: $0 [options]
 -u <user>      the github user
 -r <repo>      the github repo
 -T             list tags
 -B             list branches
 -t <tag>       head to use if -c or -g is given.
 -b <branch>    branch to use if -c or -g is given.
 -c             checkout given branch, tag or HEAD if none is given.
 -g             generate url to an archive for the given tag, branch or HEAD.
EOF

exit 1;
}

sub show_version
{
     print STDERR <<EOF;
ght-Version $VERSION
EOF
exit 1;
}

# print message and return
sub bailout
{
     print STDERR $_[0];
     exit 1;
}

# main()
my ($repo, $user, $tag, $branch, $lbranch, $ltag, $gurl, $co, %opts);

# tell getopt to exit silently on --help or --version
$Getopt::Std::STANDARD_HELP_VERSION = 23;
$Getopt::Std::OUTPUT_HELP_VERSION = 42;

getopts('hu:r:TBvcgt:b:', \%opts) || exit 1;
for ( keys %opts ) {
     switch () {
          case 'h' { show_usage; }
          case 'v' { show_version; }
          case 'u' { $user = $opts{$_}; }
          case 'r' { $repo = $opts{$_}; }
          case 't' { $tag = $opts{$_}; }
          case 'b' { $branch = $opts{$_}; }
          case 'B' { $lbranch = 1; }
          case 'T' { $ltag = 1; }
          case 'g' { $gurl = 1; }
          case 'c' { $co = 1; }
     }
}

# weed out illegal arg-combinations
bailout("you must set reponame and username!\n") if (!($repo && $user));
bailout("you can't set -g and -c at the same time!\n") if($gurl && $co);
bailout("you can't set -t and -b at the same time!\n") if ($tag && $branch);

exit 0;
