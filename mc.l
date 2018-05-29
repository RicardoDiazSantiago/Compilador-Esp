

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

//Anadido de codigo Equipo 7 funciones

//DECLARACION DE LA SENTENCIA DE IDENTIFICADOR
ID 			[A-Z][a-z]+[0-9]*?


//Sentencias de Control
"si" {return(SI)}
"sino" {return(SINO)}
"PARA" {return(PARA)}

//Funciones Generales
"principal" {return(PRINCIPAL)}
"despliega" {return(DESPLIEGA)}
"retorna" {return(RETORNA)}

//ID ACCION
{ID} 		{yylval.texto=strdup(yytext); return(ID);}

//Delimitadores ****

"(" 	{return(PARENTESISA);}
")" 	{return(PARENTESISC);}
"," 	{return(COMA);}
"=" 	{return(IGUAL);}
"==" {return(IGUALIGUAL)}
"{" 	{return(LLAVEA);}
"}" 	{return(LLAVEC);}
";" 	{return(PUNTOCOMOA);}
":"		{return(DOSPUNTOS);}
">" 	{return(MAYORQUE);}
"<"		{return(MENORQUE);}
"+"		{return(MAS);}
"-"		{return(MENOS);}
"*"		{return(MULTIPLICACION);}
"/"		{return(DIVISION);}
"&"		{return(AND);}
"|"		{return(OR);}
"'"		{return(COMILLA);}




%x comentario
%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}

entero     {adjust(); return ENTERO;}

[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}





  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/
.        {adjust(); EM_error(EM_tokPos,"token ilegal");}
