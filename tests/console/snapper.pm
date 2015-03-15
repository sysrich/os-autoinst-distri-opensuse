use base "consoletest";
use testapi;

sub run() {

    become_root;

    type_string "PS1=\"# \"\n";

    validate_script_output "snapper list-configs", sub { m/root   \| \// }, 20;
}

sub test_flags() {
    return { 'important' => 1, };
}

1;
# vim: set sw=4 et:
