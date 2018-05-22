typedef union {
   int pos;
   int ival;
   string sval;
} YYSTYPE;
#define SI        262
#define OTRO      263
#define ENTERO    269
#define IDENTIFICADOR 270
#define FLOTANTE  271
extern YYSTYPE yylval;
