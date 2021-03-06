#!perl

use strict;
use warnings;

use Test::More;
use Test::LWP::UserAgent;

use IO::String;
use HTTP::Response;

use Pinto::Remote;
use Pinto::Chrome::Term;
use Pinto::Constants qw(:server);

#-----------------------------------------------------------------------------

{

  my $res = HTTP::Response->new(200);
  $res->content("DATA-GOES-HERE\n## DIAG-MSG-HERE\n$PINTO_SERVER_STATUS_OK\n");

  my $ua = Test::LWP::UserAgent->new;
  $ua->map_response(qr{.*}, $res);

  my $out_buffer = '';
  my $out_fh = IO::String->new(\$out_buffer);

  my $err_buffer = '';
  my $err_fh = IO::String->new(\$err_buffer);

  my $chrome = Pinto::Chrome::Term->new(stdout => $out_fh, stderr => $err_fh);
  my $pinto  = Pinto::Remote->new(ua => $ua, chrome => $chrome, root => 'localhost');
  my $result = $pinto->run('List');

  is $result->was_successful, 1,
      'Got successful result' or diag $err_buffer;

  is $out_buffer, "DATA-GOES-HERE\n", 
      'Got correct data output';

  is $err_buffer, "DIAG-MSG-HERE\n", 
      'Got correct diagnostic output';
}

#-----------------------------------------------------------------------------

done_testing;
