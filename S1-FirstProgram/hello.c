/* hello.c 0.0.5                    UTF-8                      dh:2021-10-16
*---|----1----|----2----|----3----|----4----|----5----|----6----|----7----|--*

                     The "Your First Program" Exercise

    These narrative comments are not part of the exercise.  You don't need
    to include any of the comments in your own solution.

    This simple program demonstrates
      * two flavors of comment, the // end-of-line ones and the /* .... style
      * the connection to a standard library via "header" inclusion, stdio.h
      * the definition of a main() function for where the program will start
      * the use of a simple output operation to deliver (put) lines of text
      * simple statements, performed in sequence, within the body of main().

      * a simple procedure for editing, compiling, running, rinse-repeat is
        used in the narrated demonstration

    There is also a particular style of annotation and layout of code
    exhibited here.  Yours can and will vary.  If you were working on this
    project and contributing to it, it is expected that the style of the
    existing code would be preserved and honored in your contributions.  That
    will vary from project to project.
*/

#include <stdio.h>
        // using the C Language header for C-standard input-output, the source
        // of definition of puts() operations.

int main(void)
        // defining the one required function.  This is where the operating
        // system will start the program when it is executed.  Here, the
        // program is completely contained in the body, { ... }, of main().
{
    puts("hello 0.0.5 My First Program Exercise \n");
        // say who this is, and skip a line after
    puts("Hello, my name is Dennis");
        // who is reporting
    puts("My home town was Tacoma, Washington.");
        // what is the home town
    puts("My favorite hobby is playing cinematic games.");
        // what is the favorite activity
    }

/*
   0.0.5 2016-10-16T20:23Z more adjustments for taking the C/C++ Clean C route
         here.
   0.0.4 switched from printf() to puts() for simplest and most direct use of
         Standard C APIs.
   0.0.3 renamed to hello.c and tidied up a little for orcmid/FP_CPP clean C
   0.0.2 with comments
   0.0.1 calling printf() two more times.
   0.0.0 the simple printf
   */
