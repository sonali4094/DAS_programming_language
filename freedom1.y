%{
void yyerror (char *s);
int yylex();
int yyerrok;
int yyclearin;

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>



int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
int i = 0;
int dataEXP[2];
int dataFUN[3];
int dataFUNC[2];

%}

/* Yacc definitions */


%union {int num; char id; char *pr;}         
%union {char *child;}

%start program

%token scanner comma mod not_equals lb rb show and trap_until when default equals big_or_equals small_or_equals big small cmnt START END or semicolon func deliver funcname EQUIV IMPL not flag 

%token <num> num
%token <id> identifier
%token <pr> sntc

%type <id> assignmentStatement
%type <num> exp term boolExpression
%type <num> boolStatement
%type <num> whileStatement

%%

/* descriptions of expected inputs     corresponding actions (in C) */



program: /* empty */
	| START program END
        | statements program
	| program statements
	| statements
        | error /*error handling*/
	;


statements:
	statements
        | printnumberStatement
        | scannerStatement
        | IfElseStatement
        | whileStatement
        | commentStatement
        | assignmentStatement
    	| printStringStatement
    	| boolStatement
	| funcStatement
	| funcSingleParameterStatement
	| funcDoubleParameterStatement
        ;


expression:
    	comparisonExpression
        | orExpression
        | andExpression
        | boolExpression
        ;


printStringStatement:
    	deliver sntc            	{ printf("%s\n",$2); }
    	;

printnumberStatement:
        deliver term     			{printf("%d\n", $2);}
        ;

assignmentStatement:
        identifier '=' exp          	{ updateSymbolVal($1,$3); }
        ;

exp:
         term                         	{$$ = $1; dataEXP[0]=$1;}
        | exp '+' term              	{$$ = $1 + $3; dataEXP[1]=$3;}
        | exp '-' term              	{$$ = $1 - $3; dataEXP[1]=($3*-1);}
        | exp '*' term              	{$$ = $1 * $3; dataEXP[1]=($3);}
	| exp mod term			{$$ = (int)($1 % $3); dataFUN[2]=(int)($1 % $3);}
	| funcname lb term comma term rb 		{$$=dataFUN[1];}
        ;
term :
    	num				{$$ = $1;}
        | identifier			{$$ = symbolVal($1);}
        ;


boolExpression:
          term equals term            	{ $$ = $1 == $3;}
        | term big term             	{ $$ = $1 > $3;}
        | term small term             { $$ = $1 < $3;}
        | term big_or_equals term       { $$ = $1 >= $3;}
        | term small_or_equals term      { $$ = $1 <= $3;}
	| term and term			{ $$ = $1 && $3;}
	| term or term			{ $$ = $1 || $3;}	
        ;



funcStatement:
	func funcname statements deliver statements semicolon
	;

funcSingleParameterStatement:
	func funcname lb term rb deliver {dataFUNC[0]=$4;}
	;				 

funcDoubleParameterStatement:
	func funcname lb term comma term rb deliver IfElseStatement {dataFUN[0]=$4;
									      dataFUN[1]=$6;}
	;


commentStatement:
        cmnt
        ;

scannerStatement:
        scanner
        ;
    

boolStatement:
    
     	num equals num 		{ $$ = $1 == $3 ;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	| num big num 	{ $$ = $1 > $3;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	| num small num 		{$$ = $1 < $3;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                    			}
    	| num big_or_equals num 		{ $$ = $1 >= $3;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	| num small_or_equals num 	{ $$ = $1 <= $3;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	| num and num 		{ $$ = $1 && $3;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	| num or num 			{ $$ = $1 || $3;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	| '(' boolStatement ')'    	{ $$ = $2;
                    			if($$==1){
                                	printf("TRUE\n");
                                	}
                               		else{
                                	printf("FALSE\n");
                                	}
                			}
    	;


IfElseStatement:
        when boolExpression exp default exp 		                { if($2==1){
                                            			printf("%d\n", $3);
                                               			}else {
                                               			printf("%d\n", $5);} }
	;

	|when boolExpression show term default show term 			{ if($2==1){
                                            				printf("%d\n", $4);
                                               				}else {
                                               				printf("%d\n", $7);} }
	;

	| when term equals term exp default				{ if($2==$4){
								  printf("%d\n", $5);
								}}
	;
        | when lb term mod term rb equals term 
	;
	| when term equals term show sntc default show sntc 		{if(dataFUNC[1] == dataFUNC[0]){
								  printf("%s\n",$6);}
								 else{printf("%s\n",$9);}}   
	;          


whileStatement:
         trap_until term small term deliver exp semicolon 	{if($2 < $4){printf("%d\n" , $$ = (($4-$2)*dataEXP[1])+dataEXP[0]);}}
 
        | trap_until term big term deliver exp semicolon 	{if($2 > $4){printf("%d\n", $$ = (dataEXP[0]+($4-$2)*dataEXP[1]));}}
    
    	| trap_until term small term deliver show exp semicolon {            while(i<$4-$2) {
                                        			printf("%d\n",$7);
                                        				i +=1;} 
                                        				i == 0;}
 
    	| trap_until term big term deliver show exp semicolon {            while(i<$2-$4) {
                                        				printf("%d\n",$7);
                                        				     i +=1;} 
									i==0; }

	| trap_until term small term deliver show sntc semicolon {           while(i<$4-$2){
									printf("%s\n",$7);
									i +=1;} i==0;}

	| trap_until term big term deliver show sntc semicolon {           while(i<$2-$4){
									printf("%s\n",$7);
									i +=1;} i==0;}

	| trap_until term not_equals term deliver term '=' term term '=' term assignmentStatement term {           
									while(dataFUN[2] > 0){
									dataFUN[0]=dataFUN[1];
									dataFUN[1]=dataFUN[2];
									dataFUN[2]=(int)((int)dataFUN[0] % (int)dataFUN[1]);
									if(dataFUN[2] <$4){dataFUN[2]=dataFUN[2]+1;}else{$4=$4+1;}}
									printf("%d\n",dataFUN[1]);}

	| trap_until term small term deliver			{ i=1; dataFUNC[1]=0;
									   while(i<dataFUNC[0]){
									    if((dataFUNC[0] % i) == 0){
										dataFUNC[1] += i; }
										i+=1;
									}}
	


comparisonExpression:
        num assignmentOperator num 
    	| identifier assignmentOperator num 
    	| identifier assignmentOperator num 
        ;

orExpression:
        flag || flag
        ;

andExpression:
        flag || flag 
        ;

assignmentOperator :
        equals | big_or_equals | small_or_equals | big | small
        ;



%%                     /* C code */


int computeSymbolIndex(char token)
{
    int idx = -1;
    if(islower(token)) {
        idx = token - 'a' + 26;
    } else if(isupper(token)) {
        idx = token - 'A';
    }
    return idx;
}

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

int main (void) {
    /* init symbol table */
    int i;
    for(i=0; i<52; i++) {
        symbols[i] = 0;
    }

    return yyparse ( );
}

extern int lineCounter;
void yyerror (char *s)
{
printf ("%s on line %d\n", s, lineCounter);
exit(EXIT_SUCCESS);
}
