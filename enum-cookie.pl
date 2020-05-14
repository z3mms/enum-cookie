#!/usr/bin/perl
#
# Enumerate Cookie Values
#
# This program is a free software; you are free to copy, distribute, remix, 
# enhance and build off my work under the terms of the Creative Commons
# Zero 1.0 Universal (https://creativecommons.org/publicdomain/zero/1.0/)
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Author: Tengku Zahasman
# Date: 03/06/2009
#
# enum-cookie.pl -- Perl script to enumerate cookie values for analysis 
#
# Usage: ./enum-cookie.pl [options] [url]
#

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use LWP::UserAgent;
use HTTP::Cookies;

# usage information 
sub show_help {
        print <<HELP;
Usage: enum-cookie.pl [options] [url]
Options:
        -n      number of loops
        -u      username
        -p      password
        -h      help
HELP
        exit 1;
}

# MODIFY THESE MANUALLY IF NEEDED
my $usernameParam = "username";
my $passwordParam = "password";

# Declare Variables
my $username;
my $password;
my $loop = 1;
my $help = 0;
my $response;

GetOptions(
        "n=i" => \$loop,
        "u=s" => \$username,
        "p=s" => \$password,
        'h'   => \$help,
) or show_help;

$help and show_help;

my $url = shift;

defined $url or show_help;

#substr($url,-1) eq '/' or $url .= '/';

for (my $i=1; $i<=$loop; $i++) {
        my $ua = LWP::UserAgent->new(agent=>'Mozilla/4.0 (compatible; Windows 5.1)');
        #my $ua = LWP::UserAgent->new(agent=>'User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1');
        #my $ua = LWP::UserAgent->new(agent=>'NokiaE50-1/3.0 (06.27.1.0) SymbianOS/9.1 Series60/3.0');
        my $cookie_jar = HTTP::Cookies->new(ignore_discard => 1);
        $ua->cookie_jar($cookie_jar); # enable cookies

        if ($username && $password) {
                $response = $ua->post($url,[
                $usernameParam=>$username,
                $passwordParam=>$password
                ]);
        }
        else {
                $response = $ua->head($url);
        }
        
        $response->is_success or
                die "Failed: ", $response->header('HTTP'),"\n";

        print ($cookie_jar->as_string);
}
