# Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-mojolicious-plugin-logger is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Navel::Mojolicious::Plugin::Logger 0.1;

use Navel::Base;

use Mojo::Base 'Mojolicious::Plugin';

use Navel::Logger::Message;
use Navel::Utils 'blessed';

#-> methods

sub register {
    my ($self, $application, $register_options) = @_;
    
    $application->plugin('Navel::Mojolicious::Plugin::API::StdResponses');

    croak('register_options must be a HASH reference') unless ref $register_options eq 'HASH';

    croak('logger must be of Navel::Logger class') unless blessed($register_options->{logger}) && $register_options->{logger}->isa('Navel::Logger');

    $application->helper(
        'navel.logger.ok_ko' => sub {
            my $controller = shift;

            my $ok_ko = $controller->navel->api->definitions->ok_ko(@_);

            $register_options->{logger}->info(Navel::Logger::Message->stepped_message($_)) for (
                @{$ok_ko->{ok}},
                @{$ok_ko->{ko}}
            );


        }
    )
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Navel::Mojolicious::Plugin::Logger

=head1 COPYRIGHT

Copyright (C) 2015-2017 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-mojolicious-plugin-logger is licensed under the Apache License, Version 2.0

=cut
