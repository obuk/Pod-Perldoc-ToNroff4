package Pod::Perldoc::ToNroff4;
use 5.008001;
use strict;
use warnings;
use parent qw(Pod::Perldoc::ToNroff);

our $VERSION = "0.01";

use Pod::Man::TMAC ();
use File::Spec;

sub _elem {
  if (@_ > 2) { return $_[0]{$_[1]} = $_[2] }
  else        { return $_[0]{$_[1]}         }
}

for my $subname (qw/__pod2man __utf8 __lang __add_preamble __search_path/) {
  no strict 'refs';
  *$subname = do { use strict 'refs'; sub () { shift->_elem($subname, @_) } };
}

sub parse_from_file {
  my $self = shift;

  if (my ($file) = @_) {
    if (ref $file) {
      warn __PACKAGE__, ":: can't detect language code\n";
    } else {
      my $found = 0;
      my @dir = grep { $found || do { $found = 1 if /^POD2$/ } }
        File::Spec->splitdir((File::Spec->splitpath($file))[1]);
      defined && /./ && $self->__lang($_) for $dir[1];
    }
  }

  if ($self->__lang) {
    (my $pod2man = $self->__pod2man || '') =~ s/[\d\.\-]*$//;
    $self->__add_preamble($pod2man . lc($self->__lang) . '.tmac');
  }

  my @options =
    map {; $_, $self->{$_} }
      grep !m/^_/s,
        keys %$self
  ;

  push @options, utf8 => 1 if $self->__lang;
  for my $opt (qw/utf8 lang add_preamble search_path/) {
    my $formatter_switch = "__$opt";
    push @options, $opt => $self->$formatter_switch if defined $self->$formatter_switch;
  }

  defined(&Pod::Perldoc::DEBUG)
   and Pod::Perldoc::DEBUG()
   and print "About to call new Pod::Man::TMAC ",
    $Pod::Man::TMAC::VERSION ? "(v$Pod::Man::TMAC::VERSION) " : '',
    "with options: ",
    @options ? "[@options]" : "(nil)", "\n";

  Pod::Man::TMAC->new(@options)->parse_from_file(@_);
}

1;
__END__

=encoding utf-8

=head1 NAME

Pod::Perldoc::ToNroff4 - translated pods adds language dependent tmac
to pod2man preamble.

=head1 SYNOPSIS

    $ perldoc -o nroff4 -L XX ...

=head1 BUG

Since the language code is obtained from pod pathname, the module may
not be able to determine it, e.g. perldoc -v. In this cases, use
C<__lang=I<XX>> for now, as follows:

    $ perldoc -o nroff4 -L XX -w __lang=XX -v '$_'

=head1 SEE ALSO

L<Pod::Perldoc::ToNroff>, L<Pod::Man>

=head1 LICENSE

Copyright (C) KUBO, Koichi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

KUBO, Koichi E<lt>k@obuk.orgE<gt>

=cut

