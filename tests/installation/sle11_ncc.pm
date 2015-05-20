use base "y2logsstep";
use strict;
use testapi;

sub run(){
    my $self=shift;

    assert_screen 'novell-customer-center', 30;

    # configure ncc now
    send_key $cmd{'next'};
    assert_screen 'ncc-manual-interaction', 60; # contacting server take time
    send_key 'alt-o';
    assert_screen 'ncc-security-warning', 30;
    send_key 'ret';

    my $emailaddr = get_var("NCC_EMAIL");
    my $activation_code = "";
    $activation_code = get_var("NCC_SLED_CODE") if (check_var('FLAVOR', 'Desktop-DVD'));
    $activation_code = get_var("NCC_SLES_CODE") if (check_var('FLAVOR', 'Server-DVD'));

    assert_screen 'ncc-input-emailaddress', 20;
    type_string $emailaddr;
    $self->key_round('ncc-confirm-emailaddress', 'tab');
    type_string $emailaddr;
    $self->key_round('ncc-input-activationcode', 'tab');
    type_string $activation_code;
    $self->key_round('ncc-submit', 'tab');
    send_key 'ret';

    sleep 5;
    $self->key_round('ncc-continue-process', 'tab');
    send_key 'ret';

    # import untrusted gnupg keys for sled11 
    for (1 .. 2) {
        if (check_screen('ncc-import-key', 60)) {
            send_key 'alt-i';
        }
        sleep 5;
    }

    assert_screen 'ncc-configuration-done', 60;
    send_key 'alt-o';
}

1;
