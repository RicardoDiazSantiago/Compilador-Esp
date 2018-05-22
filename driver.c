#include <stdio.h>
#include <stdlib.h>
#include "util.h"
#include "errormsg.h"
#include "y.tab.h"

YYSTYPE yylval;

int yylex(void); /* prototipo para la funcion de analisis lexico */

string tokname(int tok);

string toknames[] = {"SI","OTRO","ENTERO","IDENTIFICADOR","FLOTANTE"};


string tokname(tok) {
  return tok<258 || tok>299 ? "TOKEN NO VALIDO" : toknames[tok-258];
}

int main(int argc, char **argv) {
 string fname; int tok;
 if (argc!=2) {fprintf(stderr,"uso: %s archivo.mc\n",argv[0]); exit(1);}
 fname=argv[1];
 EM_reset(fname);
 for(;;) {
   tok=yylex();
   if (tok==0) break;
   else if(tok<=255)
     printf("%c \n",tok);
     else
       switch(tok) {
         case ENTERO:
           printf("%10s %4d %d\n",tokname(tok),EM_tokPos,yylval.ival);
           break;
         case FLOTANTE:
           printf("%10s %4d %d\n",tokname(tok),EM_tokPos,yylval.fval);
         default:
           printf("%10s %4d\n",tokname(tok),EM_tokPos);
           
       }
 }
 return 0;

}
