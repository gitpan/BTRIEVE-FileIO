package BTRIEVE::FileIO;

$VERSION = '0.01';

use BTRIEVE::Native();

sub StepFirst    { $_[0]->_Step( 33 ) }
sub StepLast     { $_[0]->_Step( 34 ) }
sub StepNext     { $_[0]->_Step( 24 ) }
sub StepPrevious { $_[0]->_Step( 35 ) }

sub GetFirst     { $_[0]->_Get ( 12 ) }
sub GetLast      { $_[0]->_Get ( 13 ) }
sub GetEqual     { $_[0]->_Get (  5 ) }
sub GetGreater   { $_[0]->_Get (  8 ) }
sub GetNext      { $_[0]->_Get (  6 ) }
sub GetPrevious  { $_[0]->_Get (  7 ) }

sub IsOk         { $_[0]->{Status} ? 0 : 1 }

# -----------------------------------------------------------------------------
sub Open
# -----------------------------------------------------------------------------
{
  my $class = shift;
  my $File  = shift;
  my $self  = {};

  $self->{Pos}    = "\0" x 128;
  $self->{Size}   = 255;
  $self->{Data}   = "\0" x $self->{Size};
  $self->{Key }   = "\0" x 255;
  $self->{KeyNum} = 0;
  $self->{Status} = 0;

  $self->{Status} = BTRIEVE::Native::Call
  (
    0
  , $self->{Pos}
  , $self->{Data}
  , $self->{Size}
  , $File
  , 0
  );
  bless $self, $class;
}
# -----------------------------------------------------------------------------
sub Close
# -----------------------------------------------------------------------------
{
  my $self = shift;

  $self->{Status} = BTRIEVE::Native::Call
  (
    1
  , $self->{Pos}
  , $self->{Data}
  , $self->{Size}
  , $self->{Key}
  , 0
  );
  $self->IsOk;
}
# -----------------------------------------------------------------------------
sub _Step
# -----------------------------------------------------------------------------
{
  my $self = shift;
  my $Op   = shift;

  $self->{Data} = "\0" x $self->{Size};

  $self->{Status} = BTRIEVE::Native::Call
  (
    $Op
  , $self->{Pos}
  , $self->{Data}
  , $self->{Size}
  , $self->{Key}
  , 0
  );
  $self->IsOk;
}
# -----------------------------------------------------------------------------
sub _Get
# -----------------------------------------------------------------------------
{
  my $self = shift;
  my $Op   = shift;

  $self->{Data} = "\0" x $self->{Size};

  $self->{Status} = BTRIEVE::Native::Call
  (
    $Op
  , $self->{Pos}
  , $self->{Data}
  , $self->{Size}
  , $self->{Key}
  , $self->{KeyNum}
  );
  $self->IsOk;
}
# -----------------------------------------------------------------------------
sub DESTROY
# -----------------------------------------------------------------------------
{
  my $self = shift;

  $self->Close;
}
# -----------------------------------------------------------------------------
1;

=head1 NAME

BTRIEVE::FileIO - Btrieve file I/O operations

=head1 SYNOPSIS

  use BTRIEVE::FileIO();

  BTRIEVE::FileIO->Open('TEST.BTR');

=head1 DESCRIPTION

This module provides methods for common Btrieve operations.

=head1 AUTHOR

Steffen Goeldner <sgoeldner@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2004 Steffen Goeldner. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<perl>.

=cut
