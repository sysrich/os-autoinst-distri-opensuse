# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

use strict;
use base "y2logsstep";
use testapi;
use Time::HiRes qw(sleep);

sub run() {
    my $self = shift;
       # 		***** GRUB PHASE ******
       #See EOF, for def of little funct. Workaround needed for grub2 timeout
       moveup_and_down();
       assert_screen "grub2", 30;
       # this hack needed to stop surely the timeout, with previous function. 
       # i tested, without this send_key sometimes test fails.
       send_key 'esc'; 	
	
	if (get_var("BOOT_TO_SNAPSHOT")) {
            send_key_until_needlematch("boot-menu-snapshot", 'down', 10, 10);
            send_key 'ret';
            assert_screen("boot-menu-snapshot-list");
            send_key 'ret';
            assert_screen("boot-menu-snapshot-bootmenu");
            send_key 'down', 1;
            save_screenshot;
        }
      if (get_var("XEN")) {
            send_key_until_needlematch("bootmenu-xen-kernel", 'down', 10, 10);
        }
      # if BOOT_TO_SNAPSHOT and XEN VARIABLE NOT SET, we press ret and boot normally
      send_key "ret";

    # 	      ****** after booting, machine on the Terminal-LOGIN PHASE ******

    if (check_var('DESKTOP', 'textmode')) {
        assert_screen 'linux-login', 200;
        return;
    }

    if (get_var("NOAUTOLOGIN")) {
        my $ret = assert_screen 'displaymanager', 200;
        mouse_hide();
        if (get_var('DM_NEEDS_USERNAME')) {
            type_string $username;
        }
        if ($ret->{needle}->has_tag("sddm")) {
            # make sure choose plasma5 session
            assert_and_click "sddm-sessions-list";
            assert_and_click "sddm-sessions-plasma5";
            assert_and_click "sddm-password-input";
        }
        else {
            send_key "ret";
            wait_idle;
        }
        type_string "$password";
        send_key "ret";
    }

    # 2 is not magic number here, we're using 400 seconds in the past,
    # decrease the timeout to 300 seconds now thus doing two times.
    my $retry = 2;
    # Check for errors during first boot
    while ($retry) {
        # GNOME and KDE get into screenlock after 5 minutes without activities.
        # using 300 seconds here then we can get the wrong desktop screenshot at least
        # in case desktop screenshot changed, otherwise we get the screenlock screenshot.
        my $ret = check_screen "generic-desktop", 300;
        if ($ret) {
            mouse_hide();
            last;
        }
        else {
            # special case for KDE
            if (check_var("DESKTOP", "kde")) {
                # KDE Greeter was removed from Leap 42.1 though
                if (check_screen "kde-greeter", 60) {
                    send_key "esc";
                    next;
                }
                if (check_screen "drkonqi-crash") {
                    # handle for KDE greeter crashed and drkonqi popup
                    send_key "alt-d";

                    # maximize
                    send_key "alt-shift-f3";
                    sleep 8;
                    save_screenshot;
                    send_key "alt-c";
                    next;

                }
            }
        }
        $retry--;
    }
    # get the last screenshot
    assert_screen "generic-desktop", 5;
}

sub test_flags() {
    return {fatal => 1, milestone => 1};
}

sub post_fail_hook() {
    my $self = shift;
    $self->export_logs();
}


sub moveup_and_down {
      for (my $i=0; $i <=10; $i++) {
       send_key 'down';
       send_key 'up';
     }
}

1;

# vim: set sw=4 et:
