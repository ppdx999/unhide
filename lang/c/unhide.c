/*#####################################################################
#
# unhide - disclose hidden files
#
# USAGE: unhide <file> ...
#
# Written by fujis (ppdx999@gmail) on 2024-04-10
#
# This is a public-domain software (CC0). It means that all of the
# people can use this for any purposes with no restrictions at all.
# By the way, We are fed up with the side effects which are brought
# about by the major licenses.
#
# The latest version is distributed at the following page.
# https://github.com/ppdx999/unhide
#
####################################################################*/

/*####################################################################
# Initial Configuration
####################################################################*/

/*=== Initial Setting ==============================================*/

/*--- headers ------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <stdarg.h>
#include <unistd.h>

/*--- constants ----------------------------------------------------*/
#define MAX_FILE_NAME_LENGTH 256

/*--- global variables ---------------------------------------------*/
char* gpszCmdname ; /* The name of the command                      */

/*=== Define the functions for printing usage and error ============*/
void print_usage_and_exit(void) {
  fprintf(stderr,
    "unhide - disclose hidden files\n"
    "\n"
    "Usage   : %s <file> ...\n"
    "Args    : file ...... filepath to be disclosed\n"
    "Retuen  : return 0 only when finished successfully\n"
    "Version : 2024-04-14\n"
    "          (POSIX C language)\n"
    "\n"
    "fujis(ppdx999@gmail.com), No rights reserved.\n"
    "This is public domain software. (CC0)\n"
    "\n"
    "The latest version is distributed at the following page.\n"
    "https://github.com/ppdx999/unhide\n"
    , gpszCmdname);
  exit(1);
}

void warning(const char* szFormat, ...) {
  va_list va;
  va_start(va, szFormat);
  fprintf(stderr,"%s: ",gpszCmdname);
  vfprintf(stderr,szFormat,va);
  va_end(va);
  return;
}

void error(const char* szFormat, ...) {
  va_list va;
  va_start(va, szFormat);
  fprintf(stderr,"%s: ",gpszCmdname);
  vfprintf(stderr,szFormat,va);
  va_end(va);
  exit(1);
}

/*####################################################################
# Main
####################################################################*/
int main(int argc, char *argv[]) {

/*--- Variables ----------------------------------------------------*/
char*  pszFileName              ; /* The name of the file           */
char*  pszNewFileName           ; /* The new name of the file       */
char*  pszBasename              ; /* The base name of the file      */
size_t oldFileNameLength        ; /* The length of the old file     */
size_t newFileNameLength        ; /* The length of the new file     */
int    dirLength                ; /* The length of the directory    */
int    i                        ; /* all-purpose int                */
int    iNerror                  ; /* The number of errors occurred  */

gpszCmdname = argv[0];
for (i=0; *(gpszCmdname+i)!='\0'; i++) {
  if (*(gpszCmdname+i)=='/') {gpszCmdname = gpszCmdname+i+1;}
}

while ((i=getopt(argc,argv,"h")) != -1) {
  switch (i) {
    case 'h': print_usage_and_exit(); break;
    default : print_usage_and_exit();
  }
}
argc -= optind;
argv += optind;

iNerror = 0;
for (i=0; i<argc; i++) {
    pszFileName = argv[i];
    pszBasename = basename(pszFileName);

    oldFileNameLength = strlen(pszFileName);
    if (oldFileNameLength > MAX_FILE_NAME_LENGTH) {
      warning("The file name is too long: %s\n", pszFileName);
      iNerror++;
      continue;
    }

    if (pszBasename[0] == '.') {
      newFileNameLength = oldFileNameLength - 1;

      pszNewFileName = (char*)malloc(newFileNameLength+1);
      if (pszNewFileName == NULL) {
        error("Memory allocation error\n");
      }

      // calculate the length of the directory
      dirLength = oldFileNameLength - strlen(pszBasename);
      strncpy(pszNewFileName, pszFileName, dirLength);
      strncpy(pszNewFileName+dirLength, pszBasename+1, newFileNameLength-dirLength);
      pszNewFileName[newFileNameLength] = '\0';

      if (rename(pszFileName, pszNewFileName) != 0) {
        warning("Failed to rename: %s\n", pszFileName);
        free(pszNewFileName);
        iNerror++;
        continue;
      }

      free(pszNewFileName);
    }
}

if (iNerror>0) { return 1; }
return 0;}
