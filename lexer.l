%{
#include <iostream>
#include <string>

#define YYSTYPE std::string

#include "y.tab.hh"
%}

%x COMMENT
%x MULTILINE_COMMENT
%x STRING_LITERAL

digit [0-9]*
identifier [A-Za-z]([A-Za-z]|[0-9])*

%%

"\/\/"                   { BEGIN(COMMENT);                }
<COMMENT>.               { yylval = yytext;               }
<COMMENT>\n\r|\r\n|\n|\r { yylineno++; BEGIN(INITIAL);    }

"\/*"                              { BEGIN(MULTILINE_COMMENT);      }
<MULTILINE_COMMENT>\n\r|\r\n|\n|\r { yylineno++;                    }
<MULTILINE_COMMENT>"*\/"           { BEGIN(INITIAL);                }
<MULTILINE_COMMENT>.               { yylval = yytext;               }

"\""                 { yylval.clear(); BEGIN(STRING_LITERAL);  }
<STRING_LITERAL>"\"" { BEGIN(INITIAL); return tkStringLiteral; }
<STRING_LITERAL>.    { yylval += yytext;                       }

\n\r|\r\n|\n|\r { yylineno++;                             }
#               {}
if              { yylval = yytext; return tkIf;           }
else            { yylval = yytext; return tkElse;         }
class           { yylval = yytext; return tkClass;        }
private         { yylval = yytext; return tkPrivate;      }
public          { yylval = yytext; return tkPublic;       }
protected       { yylval = yytext; return tkProtected;    }
return          { yylval = yytext; return tkReturn;       }
{digit}         { yylval = yytext; return tkDigit;        }
"=="            { yylval = yytext; return tkEqualsEquals; }
"="             { yylval = yytext; return tkEquals;       }
":"             { yylval = yytext; return tkColon;        }
";"             { yylval = yytext; return tkSemicolon;    }
"."             { yylval = yytext; return tkDot;          }
","             { yylval = yytext; return tkComma;        }
"("             { yylval = yytext; return tkLBrace;       }
")"             { yylval = yytext; return tkRBrace;       }
"{"             { yylval = yytext; return tkLCBrace;      }
"}"             { yylval = yytext; return tkRCBrace;      }
"["             { yylval = yytext; return tkLSBrace;      }
"]"             { yylval = yytext; return tkRSBrace;      }
"<"             { yylval = yytext; return tkLesser;       }
">"             { yylval = yytext; return tkGreater;      }
"*"             { yylval = yytext; return tkStar;         }
"/"             { yylval = yytext; return tkSlash;        }
"+"             { yylval = yytext; return tkPlus;         }
"-"             { yylval = yytext; return tkMinus;        }
"'"             { yylval = yytext; return tkQuote;        }
{identifier}    { yylval = yytext; return tkIdentifier;   }
[ \t]+          {}
.               { yylval = yytext;                        }
%%