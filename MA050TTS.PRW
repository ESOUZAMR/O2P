#INCLUDE "RWMAKE.CH"


// ##############################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : MA050TTS
// ---------+-------------------+----------------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                      | Chamado
// ---------+-------------------+----------------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Transportadora | 369903
// ---------+-------------------+----------------------------------------------------------------+---------------
// ##############################################################################################################

User Function MA050TTS

IF INCLUI .OR.  ALTERA

	u_ALUFATC5( SA4->A4_COD )
ENDIF

Return( .T. )