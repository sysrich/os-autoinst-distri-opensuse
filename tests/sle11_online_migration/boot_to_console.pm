use base "basetest";
use strict;
use testapi;
use Time::HiRes qw(sleep);

sub run() {
    assert_screen "inst-bootmenu", 30;
    sleep 2;
    send_key "ret";    # boot

    assert_screen "grub2", 15;
    sleep 1;
    send_key "ret";

    assert_screen "displaymanager", 200;
    type_string $username. "\n";
    sleep 1;
    type_string $password. "\n";

    assert_screen 'generic-desktop', 300;
    mouse_hide(1);

    # switch to text console
    wait_idle;
    save_screenshot;

    send_key "ctrl-alt-f1";
    assert_screen "tty1-selected", 15;

    send_key "ctrl-alt-f4";
    assert_screen "tty4-selected", 10;
    assert_screen "text-login", 10;
    type_string "$username\n";
    assert_screen "password-prompt", 10;
    type_password;
    type_string "\n";
    sleep 1;
}

sub test_flags() {
    return { 'fatal' => 1 };
}

1;
# vim: set sw=4 et:
