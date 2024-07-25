#!/bin/sh
# Akina the best!
# shellcheck disable=SC3037,SC2086,SC2162

RED="\033[41;4m"    # RED
YELLOW="\033[43;4m" # YELLOW
BLUE="\033[44;4m"   # BLUE
RESET="\033[0m"     # RESET

msg_info() {
  echo -e $2 "${BLUE}[INFO]${RESET}: $1"
}
msg_warn() {
  echo -e $2 "${YELLOW}[WARNING]${RESET}: $1"
}
msg_err() {
  echo -e $2 "${RED}[ERROR]${RESET}: $1"
}
for i in adb fastboot; do
  if ! (command -v $i >/dev/null 2>&1); then
    msg_err "No command \"$i\" found. Install it first."
    exit 127
  fi
done

# ROOT detect
#if [ "$(id -u)" -ne 0 ]; then
#  msg_fatal "No root. Aborted."
#fi

flash_rom() {
  msg_warn "Make sure your phone is connected. Will start in 3s."
  if [ -n "${FBROMPATH}" ]; then
    sh "${FBROMPATH}/flash_all.sh"
  else
    sh "./FT4ATMP/images*/flash_all.sh"
  fi
}

get_path() {
  msg_info "Do you have an archived fastboot rom package(.tgz file)? [Y|N]: " -n
  read i
  case $i in
  Y | y)
    msg_info "Enter the path to the folder you unarchived: " -n
    read FBROMFPATH
    if [ -f "${FBROMFPATH}" ]; then
      tar xvf $FBROMFPATH -C ./FT4ATMP || exit 1
    elif [ -d "${FBROMFPATH}" ];then
      msg_err "This is a folder,not a file! Aborted."
    else
      msg_err "No such file. Aborted."
      exit 1
    fi
    flash_rom
    ;;
  N | n)
    msg_info "Do you have one that's already unarchived? [Y|N]" -n
    read i
    case $i in
    Y | y)
      msg_info "Enter the path to that folder: " -n
      read FBROMPATH
      if [ -d "${FBROMPATH}" ]; then
        flash_rom
      elif [ -f "$FBROMPATH" ]; then
        msg_err "This is a file, not a folder! Aborted."
        exit 1
      else
        msg_err "No such directory. Aborted."
        exit 1
      fi
      ;;
    N | n)
      msg_err "Then what you have😅? Aborted."
      exit 1
      ;;
    esac
    ;;
  esac
}

main() {
  msg_warn "FT4A WARNING"
  msg_warn "Using this script means that you agree to dissociate yourself"
  msg_warn "from the author, Akina, in case of any loss."
  msg_warn ""
  msg_warn "Do you want to continue? [Y|N]: " -n
  read i
  case $i in
  Y | y)
    get_path
    ;;
  N | n)
    msg_info "Aborted."
    exit 0
    ;;
  esac
}
main
