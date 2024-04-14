#!/bin/sh

######################################################################
# Initial Configuration
######################################################################

# === Initialize shell environment ===================================
set -u
umask 0022
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH="$(command -p getconf PATH)${PATH+:}${PATH-}"
export POSIXLY_CORRECT=1 # to make Linux comply with POSIX
export UNIX_STD=2003     # to make HP-UX comply with POSIX

# === Define the functions for printing usage and error message ======
print_usage_and_exit () {
  cat <<-USAGE 1>&2
	Usage   : ${0##*/}
  OPTIONS : -d DIR  Specify the output directory
            -h       Print this message
	USAGE
  exit 1
}

error_exit() {
  ${2+:} false && echo "${0##*/}: Error: $2" 1>&2
  exit $1
}

# === Define the other parameters ====================================
Dir_base=$(d=${0%/*}/; [ "_$d" = "_$0/" ] && d='./'; cd "$d"; pwd)
Src_path="$Dir_base/lang/c/unhide.c"
Cmd_name="unhide"
Dir_bin=''
COMPILERS='clang gcc xlc cc c99 tcc'

######################################################################
# Parse Options
######################################################################
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) print_usage_and_exit;;
    -d       ) Dir_bin=$2; shift;;
    --) shift; break;;
     *) break;;
  esac
  shift
done

######################################################################
# Main
######################################################################

# === Get the output directory path ==================================
case "$Dir_bin" in '') Dir_bin='.';; esac
Dist_path="$Dir_bin/$Cmd_name"

# === Choose the compiler command ====================================
for cc in $COMPILERS; do
  type $cc >/dev/null 2>&1 && { CMD_cc=$cc; break; }
done
case "$CMD_cc" in
  '') s='No compiler found. Set an available compiler by -c,--compiler option'
      error_exit 1 "$s"                                                    ;;
   *) echo "use \"$CMD_cc\" as compiler" 1>&2                              ;;
esac

# === Compile the source code ========================================
cd $Dir_base || error_exit 1 "Cannot change directory to $Dir_base"

if [ ! -d "$Dir_bin" ]; then
  mkdir -p "$Dir_bin" || error_exit 1 "Cannot create directory $Dir_bin"
fi

if [ -f "$Dist_path" ]; then
  echo "The file $Dir_bin/unhide already exists" 1>&2
  exit 1
fi

$CMD_cc -o "$Dist_path" "$Src_path" || error_exit 1 "Compilation failed"
