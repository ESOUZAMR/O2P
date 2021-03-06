#INCLUDE "RWMAKE.CH"


// ##############################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : MA050ROT
// ---------+-------------------+----------------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                      | Chamado
// ---------+-------------------+----------------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Transportadora | 369903
// ---------+-------------------+----------------------------------------------------------------+---------------
// ##############################################################################################################

User Function MA050ROT()

Local aRetorno := {}

AAdd( aRetorno, { "Atualiza O2P", "u_ALUFATD5()" , 2 , 0 } )

Return( aRetorno )

// #############################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATD5
// ---------+-------------------+----------------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                      | Chamado
// ---------+-------------------+----------------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Transportadora | 369903
// ---------+-------------------+----------------------------------------------------------------+---------------
// ##############################################################################################################

User Function ALUFATD5

	MsgRun("Aguarde, Processando Atualização do O2P", " ", { || CursorWait() , u_ALUFATC5( "" ) } )

Return