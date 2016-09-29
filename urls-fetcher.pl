#!/usr/bin/perl

# Необходимо разрработать консольное приложение на базе фреймворка AnyEvent которое принимает список URL'ов
# на STDIN и вызывает их все сразу в неблокирующем режиме, выводя на экран полученные ответы по мере их
# получения и статистику по скорости вызова каждого урла после завершения всех вызовов.

use v5.14;
use warnings;
use strict;

use EV;
use AnyEvent;
use AnyEvent::HTTP;

my $wait_for_end = AnyEvent->condvar;

my %stats;

my $requests_count = 0;
my $requests_done = 0;

while (<STDIN>) {
  chomp $_;
  $requests_count++;
  sub {
    my ($url, $request_start_time) = @_;
    http_get $_, sub {
      my ($data) = @_;
      print "$data\n";
      $stats{$url} = AnyEvent->now - $request_start_time;
      $requests_done++;
      if( $requests_count == $requests_done ) {
        $wait_for_end->send;
      }
    }
  }->($_, AnyEvent->now);
}

$wait_for_end->recv;

foreach (sort keys %stats) {
  print "$_ ... $stats{$_}\n";
}
