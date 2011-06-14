package Tapper::Action::Plugin::resume::OSRC;

=head1 NAME

Tapper::Action::Plugin::resume::OSRC - action plugin - resume::OSRC

=head1 ABOUT

The Tapper action daemon accepts messages to execute actions. This
plugin here handles the "resume" action specifically for the OSRC.

=head1 FUNCTIONS

=head2 execute

Send "resume" signal to machine.

@param scalar - Tapper::Action instance

@param hashref - message details

@param hashref - general plugin options

=cut

sub execute
{
        my ($action, $message, $options) = @_;

        $SIG{CHLD} = 'IGNORE';
        my $pid = fork();
        
        $action->log->error("Can not fork: $!") if not defined $pid;
        if ($pid == 0) {
                my $host = $message->{host};
                sleep( $message->{after} || $action->cfg->{action}{resume_default_sleeptime} || 0);
                my $cmd  = $action->cfg->{actions}{resume};
                $cmd    .= " $host";
                my ($error, $retval) = $action->log_and_exec($cmd);
                exit 0;
        }
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
