%{

#define TITLE 300
#define SPORT 301
#define NAME 302
#define YEARS 303
#define YEAR_NUM 304
#define THROUGH 305
#define COMMA 306
#define SINCE 307
#define ALL 308


union {
  int ival;
  char str [80];
} yylval;

#include <string.h> 

extern int atoi (const char *);
int current_row=1;
%}

%option noyywrap

/* exclusive start condition -- deals with C++ style comments */ 
%x COMMENT


%%

"Olympic Games" { strcpy(yylval.str, yytext); return TITLE; }
"<sport>" { strcpy(yylval.str, yytext); return SPORT; }
\[[A-Za-z ]+\] { strcpy(yylval.str, yytext); return NAME;}
"<years>" { strcpy(yylval.str, yytext); return YEARS; }
[12][0-9]{3} { yylval.ival= atoi(yytext) ; return YEAR_NUM; }
-|through { strcpy(yylval.str,yytext); return THROUGH; }
all { strcpy(yylval.str,yytext); return ALL; }
, { strcpy(yylval.str,yytext); return COMMA;}
since { strcpy(yylval.str,yytext); return SINCE;}
[\t ]+  /* skip white space */
\n  { current_row++;}

.          { fprintf (stderr, "unrecognized token %s in row %d\n", yytext,current_row); }

%%
char* removeLastAndFirstChar(char* in, char* buffer) {
    buffer = (char*)malloc(strlen(in));
    // copy without the last char (removes ])
    strncpy(buffer,in,strlen(in)-1);
    // remove [
    return buffer+1;
}

int main(int argc, char **argv)
{
    int token,year_num;
    char* buffer;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: mylex <input file name>\n %s", argv[0]);
        exit(1);
    }

    yyin = fopen(argv[1], "r");

    printf("TOKEN\t\tLEXEME\t\tSEMANTIC VALUE\n");
    printf("----------------------------------------------\n");
    while ((token = yylex()) != 0)
        switch (token)
        {
        case TITLE:
            printf("TITLE\t\t%s\n", yylval.str);
            break;
        case SPORT:
            printf("SPORT\t\t%s\n", yylval.str);
            break;
        case NAME:
            printf("NAME\t\t%s\t%s\n", yylval.str,removeLastAndFirstChar(yylval.str,buffer));
            free(buffer);
            break;
        case YEARS:
            printf("YEARS\t\t%s\n", yylval.str);
            break;
        case YEAR_NUM:
            year_num=yylval.ival==2020?++yylval.ival:yylval.ival;
            printf("YEAR_NUM\t%d\t\t%d\n",year_num,year_num);
            break;
        case ALL:
            printf("ALL\t\t%s\n", yylval.str);
            break;    
        case THROUGH:
            printf("THROUGH\t\t%s\n", yylval.str);
            break;
        case COMMA:
            printf("COMMA\t\t%s\n", yylval.str);
            break;
        case SINCE:
            printf("SINCE\t\t%s\n", yylval.str);
            break;
        default:
            fprintf(stderr, "error ... \n");
            exit(1);
        }
    fclose(yyin);
    exit(0);
}

