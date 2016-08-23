#!/usr/bin/perl
use strict;
use warnings;

use lib ('/srv/zotero/zss/');

use ZSS;

my $app = ZSS->new();

$app->psgi_callback();
