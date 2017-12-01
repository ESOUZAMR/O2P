#INCLUDE "RWMAKE.CH"


// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : MT370ATU
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Clientes | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################


User Function MT370ATU

Local cMsg := ""

cMsg := cMsg

	// Atualiza Cliente
	u_ALUFATC6( SA7->A7_CLIENTE )

	// Atualiza Produto
	u_ALUFATD1( SA7->A7_PRODUTO )

Return( .T. )