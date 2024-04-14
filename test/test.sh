#!/bin/sh

#
# --- setup ---------------------------------------------
# 
dir_base=$(cd $(dirname $0)/..; pwd)
dir_test=$(cd $(dirname $0); pwd)
dir_sh=$dir_base/lang/sh
tmp=/tmp/unhide-$$

#===============================================================================
printf "test single file: "
#===============================================================================

# --- arrange -------------------------------------------

touch ./.test-file-$$

# --- act -----------------------------------------------
$dir_sh/unhide ./.test-file-$$


# --- assert -------------------------------------------
[ $? -eq 0 ] || echo "Error exit code"
[ -e ./test-file-$$ ] && [ ! -e ./.test-file-$$ ] && echo "OK" || echo "NG"

# --- cleanup -------------------------------------------
rm ./test-file-$$


#===============================================================================
printf "test directory: "
#===============================================================================

# --- arrange -------------------------------------------

rm -rf $dir_test/testing
cp -r  $dir_test/from $dir_test/testing

# --- act -----------------------------------------------
find  $dir_test/testing                                 |
xargs $dir_sh/unhide


# # --- assert -------------------------------------------
[ $? -eq 0 ] || echo "Error exit code"
diff -r $dir_test/testing $dir_test/to
[ $? -eq 0 ] && echo "OK" || echo "NG"


#
# --- cleanup -------------------------------------------
# 

rm -rf $dir_test/testing
