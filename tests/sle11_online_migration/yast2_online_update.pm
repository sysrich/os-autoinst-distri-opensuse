use base "consoletest";
use strict;
use testapi;

sub packagekitd() {
    #packagekitd locked sometimes appear
    while ( my $ret = check_screen( [qw/packagekitd refresh-repos/], 15 )) {
        last if $ret->{needle}->has_tag("refresh-repos");
        send_key "alt-y";
    }
}

sub run() {
    my $self = shift;
    
    # online update may take very long time, so make sure that vm image was fully updated 
    type_string "yast2 online_update\n";
    packagekitd();
    assert_screen 'online-update-overview', 500;
    send_key "alt-a";
    
    assert_screen 'online-update-started', 20;

    # black screen may appear dut to low speed and type a key to active screen
    my $timeout = 1000;
    while ( my $ret = check_screen( [qw/blackscreen online-update-finish/], $timeout )) {
        last if $ret->{needle}->has_tag("online-update-finish");
        send_key "ctrl";
    }
}

1;
# vim: set sw=4 et:
