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
    my $ncc_code = get_var("NCC_CODE");

    assert_screen 'ncc-input-emailaddress', 20;
    type_string $emailaddr;
    $self->key_round('ncc-confirm-emailaddress', 'tab');
    type_string $emailaddr;
    $self->key_round('ncc-input-activationcode', 'tab');
    type_string $ncc_code;
    $self->key_round('ncc-submit', 'tab');
    send_key 'ret';

    $self->key_round('ncc-continue-process', 'tab');
    send_key 'ret';

    # import untrusted gnupg keys for sled11 
    for (1 .. 2) {
        if (check_screen('ncc-import-key', 60)) {
            send_key 'alt-i';
        }
    }

    assert_screen 'ncc-configuration-done', 60;
    send_key 'alt-o';
}

1;
