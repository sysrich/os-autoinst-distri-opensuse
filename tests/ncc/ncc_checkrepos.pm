use base "x11test";
use testapi;

sub run() {
    my $self = shift;
    mouse_hide(1);
    x11_start_program("gnome-terminal");
    sleep 2;
    send_key "alt-f10";
    sleep 1;
    type_string "zypper lr\n";
    sleep 2;
    assert_screen 'ncc-check-repos', 5;
    send_key "alt-f4";
}

1;
# vim: set sw=4 et:
