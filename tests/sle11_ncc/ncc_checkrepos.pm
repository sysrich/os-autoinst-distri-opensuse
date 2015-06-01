use base "consoletest";
use testapi;

sub run() {
    my $self = shift;
    wait_idle;
    save_screenshot;

    # switch to console
    send_key "ctrl-alt-f1";
    assert_screen "tty1-selected", 15;

    send_key "ctrl-alt-f4";
    assert_screen "tty4-selected", 10;
    assert_screen "text-login", 10;
    type_string "$username\n";
    assert_screen "password-prompt", 10;
    type_password;
    type_string "\n";

    my $script = 'zypper lr | tee zypper_lr.txt';
    validate_script_output $script, sub {m/nu_novell_com/}; # need a better output validation here

    # upload the output of repos
    type_string "clear\n";
    upload_logs "zypper_lr.txt";
    assert_screen "zypper_lr-log-uploaded";
}

1;
# vim: set sw=4 et:
