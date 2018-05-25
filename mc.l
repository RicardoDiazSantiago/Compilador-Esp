

%{
#include <string.h>
#include "util.h"
#include "y.tab.h"
#include "errormsg.h"

int charPos=1;

extern YYSTYPE yylval;

int yywrap(void)
{
 charPos=1;
 return 1;
}


void adjust(void)
{
 EM_tokPos=charPos;
 charPos+=yyleng;
}

//char bufer[256];char *apbufer;

#define MAX_STR_CONST   256
char string_buf[MAX_STR_CONST];
char *string_buf_ptr;

#define YYSTYPE double
#include <math.h>
#include <stdio.h>
int yylex (void);
void yyerror (char const *);

%}

%token NUM
%left '|' '&'
%left '>' '<' '=' '!'
%left '+' '-'
%left '*' '/' '%'
%right '^'

%x comentario
%x comentarioC
%x comentariocmas

"/*"         BEGIN(comentarioc);

<comentarioc>[^*\n]*       /* come todo lo que no sea '*' */
<comentarioc>"*"+[^*/\n]*  /* come '*'s no seguidos por '/' */
<comentarioc>\n            ++num_linea;
<comentarioc>"*"+"/"       BEGIN(INITIAL);printf("Se encontro un comentario tipo C \n");

"//"         BEGIN(comentariocmas);

<comentariocmas>[^\n]*
<comentariocmas>\n       BEGIN(INITIAL);printf("Se encontro un comentario tipo C++\n");
%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}

entero     {adjust(); return ENTERO;}

[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}

 /* Grammar rules and actions follow.  */

input:    /* empty */
             | input line
;

line:     '\n'
        | exp '\n'      { printf ("Sintacticamente correcto\n"); }
        ;

exp:      NUM    
	     | '!' exp 	       
             | exp '+' exp   
             | exp '-' exp   
             | exp '*' exp               
             | exp '/' exp
             | exp '%' exp
             | exp '^' exp
             | exp '>' exp  
             | exp '<' exp
             | exp '<''=' exp
             | exp '!''=' exp
             | exp '>''=' exp
             | exp '=''=' exp
             | exp '|''|' exp
             | exp '&''&' exp
             | '(' exp ')'
             | '[' exp ']'
             | '{' exp '}'
;

%%
     #include <ctype.h>
     #include <stdio.h>
     #include <math.h>

     int
     yylex (void)
     {
       int c;

       /* Skip white space.  */
       while ((c = getchar ()) == ' ' || c == '\t')
         ;
       /* Process numbers.  */
       if (c == '.' || isdigit (c))
         {
           ungetc (c, stdin);
           scanf ("%lf", &yylval);
           return NUM;
         }
       /* Return end-of-input.  */
       if (c == EOF)
         return 0;
       /* Return a single char.  */
       return c;
     }

     /* Called by yyparse on error.  */
     void
     yyerror (char const *s)
     {
       fprintf (stderr, "%s\n", s);
     }

     int main (void)
     {
       return yyparse ();
     }

  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}
