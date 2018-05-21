typedef union {
   int pos;
   int ival;
   string sval;
} YYSTYPE;
#define ID	258
#define STRING	259
#define INT	260
#define DESPLIEGA 261
#define SI        262
#define SINO      263
#define ENTERO    269
#define PRINCIPAL 270
#define PARA      271
#define RETORNA   272
#define CONSTANTE 273

#define PARENTESISA 274
#define PARENTESISC 275
#define COMA 276
#define IGUAL 277
#define IGUALIGUAL 278
#define LLAVEA 279
#define LLAVEC 280
#define PUNTOCOMA 281
#define DOSPUNTOS 282
#define MAYORQUE 283
#define MENORQUE 284
#define SUMA 285
#define RESTA 286
#define MULTIPLICACION 287
#define DIVISION 288
#define AND 289
#define OR 290
#define COMILLA 291
extern YYSTYPE yylval;
