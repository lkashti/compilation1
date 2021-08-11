%{

#define NUM 300
#define ID 301
#define STRING 302
#define SPORT 303
#define TITLE 304

union {
  int ival;
  char name [30];
  char str [80];
} yylval;

#include <string.h> 

extern int atoi (const char *);
%}

%option noyywrap

/* exclusive start condition -- deals with C++ style comments */ 
%x COMMENT


%%

"<sport>" { strcpy (yylval.str, yytext); return SPORT; }
"Olympic Games" { strcpy (yylval.str, yytext); return TITLE; }

.          { fprintf (stderr, "unrecognized token %c\n", yytext[0]); }

%%

int main (int argc, char **argv)
{
   int token;

   if (argc != 2) {
      fprintf(stderr, "Usage: mylex <input file name>\n %s", argv [0]);
      exit (1);
   }

   yyin = fopen (argv[1], "r");

   while ((token = yylex ()) != 0)
     switch (token) {
        case NUM: printf("NUMBER : %d\n", yylval.ival);
                      break;
        case ID:     printf ("ID  : %s\n", yylval.name);
                      break;
        case STRING: printf ("STRING: %s\n", yylval.str);
                      break;
        case SPORT: printf("SPORT: %s\n", yylval.str);
                      break;
        case TITLE: printf("TITLE: %s\n", yylval.str);
                break;
              default:     fprintf (stderr, "error ... \n"); exit (1);
     } 
   fclose (yyin);
   exit (0);
}

