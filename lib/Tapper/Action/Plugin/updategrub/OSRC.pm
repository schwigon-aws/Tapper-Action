package Tapper::Action::Plugin::updategrub::OSRC;

use strict;
use warnings;

use File::Copy;
use Tapper::Config;

=head1 NAME

Tapper::Action::Plugin::grub::OSRC - action plugin - Update grub for OSRC purpose

=head1 ABOUT

The Tapper action daemon accepts messages to execute actions. This
plugin here handles the "update_grub" action specifically for the OSRC.

=head1 FUNCTIONS

=head2 execute

Update grub according to options

@param scalar - Tapper::Action instance
@param hashref - message details
@param hashref - general plugin options

@return success - (0, undef)
@return error   - (1, error string)

=cut

sub execute
{
        my ($action, $message, $options) = @_;

        my $hostname = $message->{host} ||  $message->{hostname} or die "No hostname to update grub for in __PACKAGE__.\n";
        my $default_grubfile = Tapper::Config->subconfig->{files}{default_grubfile} // '';
        if (not -e $default_grubfile) {
                die "Default grubfile '$default_grubfile' does not exist\n";
        }
        my $filename    = Tapper::Config->subconfig->{paths}{grubpath}."/$hostname.lst";

        # use File::Copy to be as system independend as possible
        File::Copy::copy($default_grubfile, $filename) or die "Can't update grub file for $hostname: $!\n";
        return;
}

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tapper-action at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Action>.  I
will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tapper::Action::Plugin::resume::OSRC

=head1 COPYRIGHT & LICENSE

Copyright 2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

=cut

1; # End of Tapper::Action::Plugin::resume::OSRC
