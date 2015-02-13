#!/usr/bin/env bash

# expect <<EOF
#   set send_slow {1 .1}
#   proc send {ignore arg} {
#     sleep .1
#     exp_send -s --$arg
#   }
#   spawn pacman -Syyu
#   expect {
#     -exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
#     -exact "(default=all): " { send -- "\r"; exp_continue }
#     -exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
#   }
# EOF

expect <<EOF
  set send_slow {1 .1}
  proc send {ignore arg} {
    sleep .1
    exp_send -s --$arg
  }
  set timeout 30000
  spawn pacman -S base-devel
  expect {
    -exact "\[Y/n\] " { send -- "n\r"; exp_continue }
  }
EOF
