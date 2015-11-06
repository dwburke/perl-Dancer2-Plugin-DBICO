package Dancer2::Plugin::DBICO;

use strict;
use warnings;
use utf8;
use Dancer2::Plugin;
use DBIx::Class::Objects;


my $_config;
my $_objects = {};


sub _objects {
    my ($dsl, $name) = @_;
    $_config //= plugin_settings();

    my $cfg = config();

    if (not defined $name) {
        if (keys %$cfg == 1) {
            ($name) = keys %$cfg;
        } elsif (keys %$cfg) {
            $name = "default";
        } else {
            die "No schemas are configured";
        }
    }

    return $_objects->{ $name } if $_objects->{ $name };

    my $options = $cfg->{ $name } or die "The objects $name is not configured";

    my $objects = DBIx::Class::Objects->new({
        schema => schema( $name ),
        object_base => $options->{object_base},
        });

    $objects->load_objects;


    $_objects->{ $name } = $objects;
};

sub _oset {
    my ($dsl, $oset_name) = @_;
    return objects($dsl)->objectset($oset_name);
}

register objects   => \&_objects;
register objectset => \&_oset;
register oset      => \&_oset;
register_plugin;


# ABSTRACT: DBIx::Class::Objects interface for Dancer2 applications

=encoding utf8

=head1 SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::DBICO qw(objects objectset oset);

    get '/users/:user_id' => sub {
        my $user = objects('default')->objectset('User')->find(param 'user_id');

        # If you are accessing the 'default' schema, then all the following
        # are equivalent to the above:
        $user = schema->resultset('User')->find(param 'user_id');
        $user = resultset('User')->find(param 'user_id');
        $user = oset('User')->find(param 'user_id');

        template user_profile => {
            user => $user
        };
    };

    dance;

=head1 DESCRIPTION

Description.

=head1 CONFIGURATION

Configuration

=head1 FUNCTIONS

=head2 objects


=head2 objectset


=head2 oset


=head1 SCHEMA GENERATION

=cut


1;
