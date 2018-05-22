typedef union {
   int pos;
   int ival;
   string sval;
   float fval; //estructura flotante
} YYSTYPE;
#define ID	258
#define STRING	259
#define ENTERO	260
#define DESPLIEGA 261
#define SI        262
#define OTRO      263
#define FLOTANTE    264
//Se agrego flotante como token

extern YYSTYPE yylval;
