

%{
#include <string.h>
#include "util.h"
#include "y.tab.h"
#include "errormsg.h"
#include <math.h> // Se agrega math.h para el uso de atof y atoi 

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

%}

DIGITO [0-9]

%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}
 /* Enteros y flotantes */
{DIGITO}+     {adjust();yylval.ival=atoi(yytext);return ENTERO;}

{DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+  {adjust();yylval.fval=atof(yytext);return FLOTANTE;}









  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}
