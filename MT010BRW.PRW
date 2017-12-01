#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : MT010BRW
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Produto  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function MT010BRW()

Local aRotUser := {}

//Define Array contendo as Rotinas a executar do programa
// ----------- Elementos contidos por dimensao ------------
// 1. Nome a aparecer no cabecalho
// 2. Nome da Rotina associada
// 3. Usado pela rotina
// 4. Tipo de Transacao a ser efetuada
//    1 - Pesquisa e Posiciona em um Banco de Dados
//    2 - Simplesmente Mostra os Campos
//    3 - Inclui registros no Bancos de Dados
//    4 - Altera o registro corrente
//    5 - Remove o registro corrente do Banco de Dados
//    6 - Altera determinados campos sem incluir novos Regs

AAdd( aRotUser , { 'Atualiza O2P' , 'u_ALUFATD3()' , 0 , 2 } )

Return( aRotUser )



// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATD3
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Produto  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function ALUFATD3

	MsgRun("Aguarde, Processando Atualização do O2P", " ", { || CursorWait() , u_ALUFATD1( "" ) } )

Return