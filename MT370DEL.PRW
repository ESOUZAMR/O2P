#INCLUDE "RWMAKE.CH"


// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : MT370DEL
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 21/11/17 | Eduardo Souza     | Cliente de Integracao com o Webservice da O2P - Clientes | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################


User Function MT370DEL

Local cMsg := ""

cMsg := cMsg
nOp := PARAMIXB[1] // 1- Cancelou ; 2-OK

If nOp = 2 // Verifica se o usuario confirmou a exclusao.
	
	// Atualiza Cliente
	u_ALUFATC6( SA7->A7_CLIENTE )

	// Atualiza Produto
	u_ALUFATD1( SA7->A7_PRODUTO )

EndIf

Return( .T. )