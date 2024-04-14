#!/bin/sh

#
# --- setup ---------------------------------------------
# 
dir_base=$(cd $(dirname $0)/..; pwd)
dir_test=$(cd $(dirname $0); pwd)
dir_sh=$dir_base/lang/sh
dir_c=$dir_base/lang/c
tmp=/tmp/unhide-$$

printf "#==============================================================================\n"
printf "Shell Script\n"
printf "#==============================================================================\n"

#-------------------------------------------------------------------------------
printf "test single file: "
#-------------------------------------------------------------------------------

# --- arrange -------------------------------------------

touch ./.test-file-$$

# --- act -----------------------------------------------
$dir_sh/unhide ./.test-file-$$


# --- assert -------------------------------------------
[ $? -eq 0 ] || echo "Error exit code"
[ -e ./test-file-$$ ] && [ ! -e ./.test-file-$$ ] && echo "OK" || echo "NG"

# --- cleanup -------------------------------------------
rm ./test-file-$$


#-------------------------------------------------------------------------------
printf "test directory: "
#-------------------------------------------------------------------------------

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


printf "#==============================================================================\n"
printf "C Language\n"
printf "#==============================================================================\n"

gcc -o $tmp-exec $dir_c/unhide.c

#-------------------------------------------------------------------------------
printf "test single file: "
#-------------------------------------------------------------------------------

# arrange
touch ./.test-file-$$

# act
$tmp-exec ./.test-file-$$

# assert
[ $? -eq 0 ] || echo "Error exit code"
[ -e ./test-file-$$ ] && [ ! -e ./.test-file-$$ ] && echo "OK" || echo "NG"

# cleanup
rm ./test-file-$$

#-------------------------------------------------------------------------------
printf "test directory: "
# ------------------------------------------------------------------------------

# --- arrange -------------------------------------------
rm -rf $dir_test/testing
cp -r  $dir_test/from $dir_test/testing

# --- act -----------------------------------------------
find  $dir_test/testing                                 |
xargs $tmp-exec


# # --- assert -------------------------------------------
[ $? -eq 0 ] || echo "Error exit code"
diff -r $dir_test/testing $dir_test/to
[ $? -eq 0 ] && echo "OK" || echo "NG"

# --- cleanup -------------------------------------------
rm -rf $dir_test/testing

# --- teardown -------------------------------------------
rm $tmp-exec
