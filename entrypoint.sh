
#!/bin/sh
set -ebm

setup_ssh() {
  echo "Create App Services root password"
  echo "root:Docker!" | chpasswd

  echo "Create ssh host keys"
  ssh-keygen -A

  echo "Start ssh server"
  /usr/sbin/sshd
}

start_app(){
  echo "the app starts"
  exec http-echo
}

# only start ssh when necessary
echo $ENABLE_SSH | grep -qi true && setup_ssh

start_app