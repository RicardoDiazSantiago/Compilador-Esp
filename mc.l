

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

%}
DIGITO [0-9]
%x flotante
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
{DIGITO}+"."{DIGITO}*    BEGIN(flotante);
<flotante>('^0')"."{DIGITO}         {adjust();
                                     yylval.fval=yytext;
                                     return FLOTANTE;
                                     } 
/* todo numero flotante que empieze con un cero*/
<flotante>{DIGITO}"."{DIGITO}*       {adjust();
                                     yylval.fval=yytext;
                                     return FLOTANTE;
                                     } 
/*todo numero flotante que empieze con numero y punto*/
<flotante>{DIGITO}+("."){DIGITO}*(E)(+|-){DIGITOS}+     {adjust();
                                     yylval.fval=yytext;
                                     return FLOTANTE;
                                     BEGIN(INITIAL);
                                     } 
/*numero flotante con mantisa */

{DIGITO}+     {adjust();
               yylval.ival=yytext;
               return ENTERO;}

  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}
