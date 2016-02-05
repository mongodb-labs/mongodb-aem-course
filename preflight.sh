#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
VBOX_INSTALL_URL="https://www.virtualbox.org/wiki/Downloads"
VAGRANT_INSTALL_URL="https://www.vagrantup.com/docs/installation/"
SOMETHING_MISSING=0
function print_error {
  printf "${RED}$1${NC}\n"
  SOMETHING_MISSING=1
}

function print_good {
  printf "${GREEN}$1${NC}\n"
}

function check_virtualbox {
  vbox=$(VBoxManage --version)
  if [ ! -z $vbox ]
  then
    print_good "running VirtualBox version $vbox "
  else
    print_error "VirtualBox could not be found!"
    print_error "please check the instructions at"
    print_error "$VBOX_INSTALL_URL"
  fi
}

function check_vagrant {
  vagrant_exec=$(whereis vagrant)
  if [ ! -z $vagrant_exec ]
  then
    vagrant_version=$($vagrant_exec -v)
    print_good "running $vagrant_version"
  else
    print_error "vagrant is required to run the course exercises!"
    print_error "please check the instructions at"
    print_error "$VAGRANT_INSTALL_URL"
  fi

}

function final_notes {
  if [ $SOMETHING_MISSING == 1 ]
  then
    print_error "Some requirements are missing! Make sure you have all correctly installed"
  else
    print_good "ALL SET - Ready to go!"
  fi
}

function check_aem_installed {
  file="AEM/author/cq-author-p4502.jar"
  if [ -f $file ]
  then
    print_good "AEM jar file on the expected location: $file"
  else
    print_error "AEM jar \`$file\` not found"
  fi
}

check_vagrant
check_virtualbox
check_aem_installed
final_notes
