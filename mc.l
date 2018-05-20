

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

%x cade 
%x comentario
%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}

entero     {adjust(); return ENTERO;}

[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}


\"              {adjust(); string_buf_ptr = string_buf;  
                 BEGIN(cade);
                 /*Regla que da inicio a la condicion de arranque mostrada arriba %x cade especificando las comillas que inician
		  *Para la especificación de una cadena "cadena"
		 */
                } 

<cade>\"        { /* Se encuenta la comilla que cierrra en la cadena para finalizar su análisis*/
                   adjust();
                   BEGIN(INITIAL); 
                   *string_buf_ptr = '\0'; 
                   yylval.sval=String(string_buf); 
                   return STRING; 
                   /* 
                    * Se ajusta la posición del analizador
		    * BEGIN vuelve al estado inicial para cualquier otra condicion
                    * *string_buf_ptr = '\0' el apuntador ahora llega al fin de cadena
                    * retorna el token STRING definido para una cadena y
                    * el valor para el analizador sintáctico
                    */
                   
                   }

<cade>\n        {
                   /* genera un mensaje de error ya que una cadena no puede estar separada en código por un salto de linea */
                   }

<cade>\\[0-7]{1,3} {
                   /* secuencia de escape en octal */
                   adjust();
                   int resultado;

                   (void) sscanf( yytext + 1, "%o", &resultado );

                   if ( resultado > 0xff )
                           /* error, constante fuera de rango */

                   *string_buf_ptr++ = resultado;
                   }

<cade>\\[0-9]+ {
                   /* genera un error - secuencia de escape errónea;
                    * algo como '\48' o '\0777777'
                    */
                   }

<cade>\\n    {adjust(); *string_buf_ptr++ = '\n';} 
<cade>\\t    {adjust(); *string_buf_ptr++ = '\t';}
<cade>\\r    {adjust(); *string_buf_ptr++ = '\r';}
<cade>\\b    {adjust(); *string_buf_ptr++ = '\b';}
<cade>\\f    {adjust(); *string_buf_ptr++ = '\f';
              /*Devuelve el tipo caracter cada que encuentra un salto de linea, un tabulador, etc. especificado dentro de la cadena*/
              }

<cade>\\(.|\n)  {
                /*Encuenta una linea nueva y aumenta el número de líneas contadas*/
                adjust(); EM_newline(); *string_buf_ptr++ = yytext[1]; } 

<cade>[^\\\n\"]+  {
                    adjust();
                    char *yptr = yytext;
                    while ( *yptr )
                           *string_buf_ptr++ = *yptr++;
                    /*Va a tomar todo lo que no sea un salto de línea seguido del cierre de comillas simples
                      cada caracter leído se guarda en el apuntador a STRING   
                    */
                   }


  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}
