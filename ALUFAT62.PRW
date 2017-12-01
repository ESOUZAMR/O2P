#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"
#include "MSGRAPHI.CH"
#include "SIGAWIN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#include "RWMAKE.CH"         // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ALUFAT62  ³ Autor ³ Luiz Cesar            ³ Data ³ 22/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Geracao de Notas Fiscais                       ³±±
±±³          ³ Operador Logistico                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ALUFAT62()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Crown                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado Por ³ Data     ³CHAMADO³ Manutencao Efetuada                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima ³30/11/2010| Alter. para entrar direto em estoque - PIA   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto ³04/03/2011| Alter. do tamanho da tela para possibilitar  ³±±
±±³             ³          | a rolagem da tela de geracao de embarque     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto ³05/03/2011| Inclusao validacao do estado da trasnport.   ³±±
±±³             ³          | Alteracao para solicitar os dados do embarque³±±
±±³             ³          | apenas quando o usuario clicar no botao 'OK' ³±±
±±³             ³          | e nao na primeira tela da rotina.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³J.Francisco  ³14/03/2011| Criando campo Loja do estado da trasnport.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³J.Francisco  ³14/03/2011| Criacao do pedido de embalagem               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³24/03/2011| Alteracao da origem da etiqueta para "P"     ³±±
±±³             ³          | identificando que a etiqueta teve origem no  ³±±
±±³             ³          | PIA                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto ³06/04/2011|Inclusao do campo PAH_A_OPER no browse        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto ³07/04/2011|Alteracao na validacao do cliente.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³29/04/2011|Informar o fornecedor na query que seleciona  ³±±
±±³             ³          |a nota de retorno do operador logistico.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³29/04/2011|Informar o fornecedor na query que seleciona  ³±±
±±³             ³          |a nota de retorno do operador logistico.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³05/05/2011|Mostrar na tela de faturamento a qtde de      ³±±
±±³             ³          |pallets e a data de geracao do processo.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³05/05/2011|Alteracao no tamanho da tela.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³05/05/2011|Correcao na liberacao do material de embalag. ³±±
±±³             ³          |que estava duplicando a liberacao no SC9.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³17/05/2011|Projeto SPED PIS COFINS. Utilizar TES         ³±±
±±³             ³          |diferentes para produtos com PIS/COFINS por   ³±±
±±³             ³          |pauta e PIS/COFINS por aliquota.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³25/05/2011|Projeto SPED PIS COFINS. Correcao no          ³±±
±±³             ³          |posicionamento da tabela SF4.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³01/06/2011³Gravacao da tabela de preco no cadastro de    ³±±
±±³             ³          ³cliente.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto      ³12/07/2011³Tratamento para aglutinar a qtde do material  ³±±
±±³             ³          ³de embalagem com base na nota fiscal de       ³±±
±±³             ³          ³retorno dor armazem externo. Chamado 222.693. ³±±
±±³             ³          ³Projeto melhoria PIA.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe       ³26/08/2011³Busca o tipo do frete na tabela PBS e nao mais³±±
±±³             ³          ³na tabela SZR                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe (MRC) ³20/09/2011³ Atualiza a variavel ddatabase com a funcao   ³±±
±±³			    ³		   ³ date() para evitar o faturamento com data    ³±±
±±³			    ³		   ³ errada se o usuario estiver conectado desde  ³±±
±±³			    ³		   ³ o dia anterior								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe (MRC) ³21/03/2013³ PROJETO ARUMA TERESINA - CHAMADO 265299	  ³±±
±±³             ³          ³Ajuste de dbseek apos compartilhamento do ca- ³±±
±±³             ³          ³dastro de clientes, fornecedores e transporta-³±±
±±³             ³          ³doras										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto(MRC) ³29/04/2013³ Chamado 264820-Tratamento para receber xml em³±±
±±³			    ³		   ³ contingencia.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto(MRC) ³02/05/2013³ Chamado 264820-Gerar movimento de entrada    ³±±
±±³			    ³		   ³ para faturamento gerado com etiqueta recebida³±±
±±³			    ³		   ³ em contigencia pela KMC.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto(MRC) ³10/05/2013³ Chamado 264820-Incluido o campo PAH_A_ST no  ³±±
±±³			    ³		   ³ browse da tabela temporaria                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto(MRC) ³10/05/2013³ Chamado 264820-Se for fat.em contingencia    ³±±
±±³			    ³		   ³ gerar o pedido de embalagem com base nas     ³±±
±±³			    ³		   ³ etiquetas do CB0 e nao com base na nota      ³±±
±±³			    ³		   ³ fiscal de retorno da KMC.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto(MRC) ³02/10/2013³ Chamado 280605-Nao gerar mov.interna para    ³±±
±±³			    ³		   ³ nota recebida em contingencia, pois essa nota³±±
±±³			    ³		   ³ passou a ser recebida pelo PIA no primeiro   ³±±
±±³			    ³		   ³ xml sem a chave da nfe.Incluido disarmtransc ³±±
±±³			    ³		   ³ qdo tabela de preco nao encontrada.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto(MRC) ³10/10/2013³ Chamado 280605-Qdo se tratar de faturamento  ³±±
±±³			    ³		   ³ de uma etiqueta recebida em contingencia,    ³±±
±±³			    ³		   ³ gerar o pedido de venda da embalagem com base³±±
±±³			    ³		   ³ na nota de entrada.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³25/02/2014³ 292175 ³ Implementação dos botoes de retorno ³±±
±±³			    ³		   ³        ³ e estorno                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³ 18/07/14 ³ 292175 ³ Problema da geração do RE5 ao       ³±±
±±³			    ³		   ³        ³ estornar e gerar endereçamento da NF³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³ 14/08/14 ³ 292175 ³ Error Log funcao EstRet no array    ³±±
±±³			    ³		   ³        ³ aITENSEst.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³ 15/08/14 ³ 292175 ³ Correçao na função ESTRET           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Adriano      ³ 04/09/14 ³ 302901 ³ Pegar Numero de camadas da  		  ³±±
±±³Guedes       ³          ³        ³ SBM->bm_a_qtdca                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³ 25/09/14 ³ 305348 ³Problema na atualização da qtd do    ³±±
±±³			    ³		   ³        ³ saldo em estoque SB2, SBF.          ³±±
±±³			    ³		   ³        ³Informar o Num OP na geração da Mov. ³±±
±±³			    ³          ³        ³ interna para valorização da OP das  ³±±
±±³			    ³          ³        ³ novas etiquetas   				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe       ³ 01/10/14 ³ 306119 ³ Projeto A010/14 - Calcula o preco em³±±
±±³Geraldo      ³          ³        ³ reais utilizando a valor da PTAX D-1³±±
±±³             ³          ³        ³ conforme o cliente				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÂÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³14/10/14³ Projeto A007/13 - CHAMADO 279402 		      ³±±
±±³               ³        ³ Alteracao do nome do campo NOT para NOTA para³±±
±±³               ³        ³ evitar conflito de criacao de indice no ctre ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³05/12/14³ CHAMADO 299000 - Inclusao de operacao        ³±±
±±³               ³        ³triangular para a operacao do PIA.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³13/03/15³CHAMADO 317443 - Problema no posicionamento da³±±
±±³               ³        ³ordem de produção.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÁÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima ³ 14/08/15 ³ 326180 ³ Muda pedido de embalagem para frete ³±±
±±³			    ³		   ³        ³ CIF, para ser integrado ao GFE.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³ 14/10/15 ³ 332976 ³ Tipo de frete do pedido de venda de ³±±
±±³			    ³		   ³        ³ embalagem igual ao pedido de lata.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima ³ 08/12/15 ³ 336887 ³ VALIDA SE A TABELA DE PRECO ESTA    ³±±
±±³			    ³		   ³        ³ APROVADA.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe       ³ 23/02/16 ³ 303631 ³ PROJETO A002/14 - UNIFIC. CADASTRO  ³±±
±±³Geraldo      ³          ³        ³ Busca dados no ZZG e nao mais no SA1³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima ³ 16/03/16 ³ 342688 ³ muda tipo de moviente de retorno ao ³±±
±±³			    ³		   ³        ³ estoque                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges  ³ 02/08/16 ³ 350242 ³ Projeto A025/15. Implementacao nova ³±±
±±³			    ³		   ³        ³ operação triangular. Atendimento tbm³±±
±±³			    ³		   ³        ³ ao chamado 345324 TES PIA           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA ³01/09/16  ³ 354705 ³ inclui a quantidade de pallet no    ³±±
±±³             ³          ³        ³pedido para ingressar na nota fiscal ³±±
±±³             ³          ³        ³como unitizador que sera usado no GFE³±±
±±³             ³          ³        ³para calculo de frete por pallet.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA ³21/03/17  ³ 362908 ³inclui analise de credito e retira   ³±±
±±³             ³          ³        ³Validacao do campo ZZG_a_TES5.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA ³04/09/17  ³ 369903 ³ Atualiza Saldo de Estoque no O2P por³±±
±±³             ³          ³        ³ Conexao ao WS                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALUFAT62()

Private _nOpca1	:= 0
Private _aOldArea :=GetArea()
Private _nUsado	:= 0
Private aHeader	:= {}
Private aCols   := {}
Private _nItens:=0
Private _lInverte	:= .F.
Private _cMarca    := Getmark()
Private aRotina := {{"","",0,1},{"","",0,2},{"","",0,3},{"","",0,4},{"","",0,5},{"","",0,6},{"","",0,7}}
Private aSize  	:= MsAdvSize(,.F.,400)
Private aObjects:= { { 50, 25, .T., .F. } , { 250, 900, .T., .T. }}
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private _aButton := {}
Private _aCores := {{'PAH_A_OK = "  "', 'BR_AMARELO' }}

Private _nMarcadas := 0

//Private _nOpca1:=0

Private _cCodArm := space(8)

*------------------------------------*
*Alberto - 05/03/11                      *
*Alteracao no posicionamento da variavel *
*------------------------------------*
Private _cCliente := CriaVar("A1_COD",.F.)
//J.Francisco  ³14/03/2011| Criando variavel Loja
Private _aEmbPro  := {}
Private _cPedidoE  := CriaVar("C5_NUM",.F.)
Private _cLoja    := CriaVar("A1_LOJA",.F.)
Private _cPedido  := CriaVar("C5_NUM",.F.)
Private _cTransp  := CriaVar("A4_COD",.F.)
Private _cPlaca   := CriaVar("F2_A_PLACA",.F.)
Private _cUf      := CriaVar("F2_A_UFP",.F.)

//Luis Alberto - 05/12/14- Chamado 299000 - inclusao de operacao triangular para o PIA
Private _cOpTri    := "N"   //
//Private _cCliTri   := " "  // Cliente operacao triangular  //Alex Borges - 02/08/2016 - Chamado 350242
//Private _cLjTri    := " "  // Loja operacao triangular //Alex Borges - 02/08/2016 - Chamado 350242
Private _cCliTri   := CriaVar("A1_COD",.F.)
Private _cLjTri    := CriaVar("A1_LOJA",.F.)
Private _cCpTri    := " "  // Condicao pagamento operacao triangular
Private _cFreteTri := " "  //Tipo frete operacao triangular
Private _cTesAlTri := " "  //Tes Aliquota operacao triangular
Private _cTesPaTri := " "  //Tes Pauta operacao triangular
Private _cTesIsTri := " "  //Tes Pis Cofins isento operacao triangular
Private _cTesTri   := " "  //Tes operacao triangular
Private _cPauta    := " "
Private _cTabTri:= " "  //Codigo tabela cliente operacao triangular
Private _cNotaTri  := " "  //Nota  operacao triangular
Private _cNomeTri  := " "
Private _cEndTri   := " "
Private _cCNPJTri  := " "
Private _cIETri    := " "
Private _cNomeCli  := " "
Private _cEndCli   := " "
Private _cCNPJCli  := " "
Private _cIECli    := " "
private _cPedTri:= Space(6) //Pedido operacao tringular
private _cPtaxD1 := ""
private _lNota :=.t.

// RICARDO LIMA - 16/03/16
Private _TMCRWRET := getmv("CE_TMCRWRET")

// Cria Arquivo de Trabalho
_cxCodArm := " "

aadd(_aButton,{'RETESTOQ',{|| RetEstoq()},"Retorno Estoque"})
aadd(_aButton,{'ESTRET',{|| EstRet()},"Estornar Retorno"})

define msDialog _oDlg title 'Faturamento Deposito Externo (PIA)' from 00,00 to 480,980 pixel

// Criacao da tabela de Trabalho para mostrar os processos gerados
lQuery := .T.

_aCampos2 := {}
//Alberto - 05/05/11 - Incluido o campo PAH_A_DTRT e a funcao count(*) na query
//Alberto - 10/05/13 - Incluido o campo PAH_A_ST para tratamento dos processos recebidos em contingencia
_cQuery := " SELECT DISTINCT PAH_A_OK,PAH_A_PROD,PAH_A_PRFT,PAH_A_OPER,PAH_A_DTRT,PAH_A_NFRT,PAH_A_SRRT,PAH_A_PROD,PAH_A_ARM,PAH_A_ST,PAH_FILIAL,PAH_A_DTCT,PAH_A_NFCT,PAH_A_SRCT,SUM(PAH_A_QTD) PAH_A_QTD,COUNT(*) PALLETS "  //Alberto - 06/04/11- Inclusao do campo PAH_A_OPER
_cQuery += "  FROM "+RETSQLNAME('PAH')
_cQuery += "  WHERE PAH_FILIAL='"+xFilial("PAH")+"' "
_cQuery += "   AND PAH_A_ST IN('L','C')"  //Alberto- 29/04/13-Tratamento para receber xml em contingencia
_cQuery += "   AND D_E_L_E_T_<>'*' "
_cQuery += " GROUP BY PAH_A_OK,PAH_A_PRFT,PAH_A_OPER,PAH_A_DTRT,PAH_A_NFRT,PAH_A_SRRT,PAH_A_PROD,PAH_A_ARM,PAH_A_ST,PAH_FILIAL,PAH_A_DTCT,PAH_A_NFCT,PAH_A_SRCT "
_cQuery += "  ORDER BY PAH_A_OK,PAH_A_PRFT "
memowrite("TAB1PAH.SQL",_cQuery)

If ( Select ( "TRBPAH" ) <> 0 )
	dbSelectArea ("TRBPAH")
	dbCloseArea()
Endif

_aStru := PAH->(dbstruct())
aadd(_aStru,{'PALLETS','N',3,0})  //Alberto - 05/05/11- Adiciona o campo PALLETS para aparecer no browse
_cArqTrab := Criatrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrab,"TRBPAH",.T.,.F.)
Processa({||SqlToTrb(_cQuery, _aStru, "TRBPAH")}) // Cria arquivo temporario

TRBPAH->(dbgotop())

//Alberto - 10/05/13 - Incluido o campo PAH_A_ST para tratamento dos processos recebidos em contingencia
_aCpo := {"PAH_A_OK","PAH_A_PRFT","PAH_A_OPER","PAH_A_ARM","PAH_A_DTRT","PAH_A_NFRT","PAH_A_PROD","PAH_A_QTD","PALLETS","PAH_A_SRRT","PAH_A_ST","PAH_A_DTCT","PAH_A_NFCT","PAH_A_SRCT"}  //Alberto - 06/04/11- Inclusao do campo PAH_A_OPER

For _ni:=1 to Len(_aCpo)
	SX3->(dbsetorder(2))
	IF SX3->(dbseek(_aCpo[_ni]))
		aadd(_aCampos2,{SX3->X3_CAMPO,,SX3->X3_TITULO,SX3->X3_PICTURE,""}) // Formatacao Browse
		If ALLTRIM(SX3->X3_CAMPO)='PAH_A_QTD'
			aadd(_aCampos2,{'PALLETS',,'Pallets','@E 999',""}) // Formatacao Browse //Alberto - 05/05/11- Adicionado o campo PALLETS para aparecer no browse
		Endif
	endif
next

TRBPAH->(DbGotop())
_oMark:=MsSelect():New("TRBPAH","PAH_A_OK","",_aCampos2,_lInverte,@_cMarca,{010, 005, 240, 490},,,,,_aCores)  //Alberto - 04/04/11 - Alteracao do tamanho da tela para possibilitar a rolagem de tela
_oMark:bMark:= {|| FECHMark(_cMarca)}
_oMark:oBrowse:bAllMark := {||RdMarkAll("TRBPAH", _oMark, _cMarca,"PAH_A_OK")}
_oMark:oBrowse:lhasMark = .T.   // Erro ?
_oMark:oBrowse:lCanAllmark := .F.

_nOpca1    := 0

ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar(_oDlg,{||iif(VldTela(),(_nOpca1:=1,_oDlg:End()),_oDlg:refresh())},{||(_nOpca1:=2, _oDlg:End())},,_aButton)

If _nOpca1 == 1 // Se confirmado o processamento
	While .t.

		/*if !DigArmazem()
			Return
		endif

		If MsgYesNo("Confirma Dados para Faturamento?","AVISO")
			Exit
		endif*/// Alex Borges - 03/08/2016 - Chamado 350242

		If !DigArmazem()
			Return
		Else
			If MsgYesNo("Confirma Dados para Faturamento?","AVISO")
				Processa({|| ProcPAH()},"Aguarde, Gerando dados!.")
				Exit
			Else
				Exit
			Endif
		Endif

	end
	//Processa({|| ProcPAH()},"Aguarde, Gerando dados!.") // Alex Borges - 03/08/2016 - Chamado 350242
Endif

If SELECT("TRBPAH")<>0
	TRBPAH->(dbclosearea())
EndIf
RestArea(_aOldArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldTela   ºAutor  ³Luiz Cesar          º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a tela toda na Transferencia de FECHueta            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function VldTela()
local _lRet := .T.

If  _nItens<=0
	MsgStop("Não há itens marcados!!","ATENÇÃO!!!")
	_lRet:=.f.
elseif _nItens>1
	MsgStop("Deverá ser marcado apenas um item!! Favor Corrigir!!!","ATENÇÃO!!!")
	_lRet:=.f.
EndIf

If _lRet
	If MsgYesNo("CONFIRMA ?","AVISO")
	ELSE
		_lRet:=.F.
	ENDIF

Endif
return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FECHMark  ºAutor  ³Luiz Cesar          º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca ou desmarca as FECHuetas de selecao                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FECHMark(_cMarca)

// Desmarca o registro ja marcado

If !Empty(TRBPAH->PAH_A_OK)
	_lMarcart:=.f.
	_nItens++
	IsMark("PAH_A_OK",_cMarca,_lInverte)

Else
	_lMarcart:=.t.
	_nItens--
Endif

Return( .F. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DigArmazemºAutor  ³Luiz Cesar          º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Digitacao de armazen                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DigArmazem()

Local _oDLGArm
Local _oArm
Local _oBotaoOK
Local _oBotaoSair
Local _lok := .f.
Local _bOK := {|| _lok:= .t. , Close(_oDLGARM) ,.t.}
Local _bNOK := {|| _lok:= .f.,Alert("Preencher Dados") , .f.}

//Local _bValid := {|| if (VldCli(_cCliente,_cLoja) .and. VldTransp(_cTransp) .And. VldPla(_cPlaca) .and. !Empty(_cPlaca),Eval(_bOk),Eval(_bNOk)) } // Alex Borges - 03/08/16 - Chamado 350242
Local _bValid := {|| if (VldCli(_cCliente,_cLoja) .and. VldTransp(_cTransp) .And. VldPla(_cPlaca) .And. ExistCpo("SX5","12"+_cUF) .And. IIF(!Empty(_cCliTri),VldCli(_cCliTri,_cLjTri),.T.) ,Eval(_bOk),Eval(_bNOk)) }

DEFINE MSDIALOG _oDLGARM FROM 50, 10 TO 68, 57 TITLE OemToAnsi("INFORME DADOS PARA FATURAMENTO")
//J.Francisco  ³14/03/2011| Criando campo Loja

@ 012,010 SAY    'CLIENTE         ' OF _oDlgARM PIXEL SIZE 120 ,9
@ 027,010 SAY    'LOJA            ' OF _oDlgARM PIXEL SIZE 120 ,9
@ 042,010 SAY    'TRANSPORTADORA  ' OF _oDlgARM PIXEL SIZE 120 ,9
@ 057,010 SAY    'PLACA'            OF _oDlgARM PIXEL SIZE 120 ,9
@ 072,010 SAY    'ESTADO'           OF _oDlgARM PIXEL SIZE 120 ,9
//@ 087,010 SAY    'OPERACAO TRIANGULAR?' OF _oDlgARM PIXEL SIZE 120 ,9 //Alex Borges - 02/08/2016 - Chamado 350242
@ 087,010 SAY    'CLIENTE TRIANGULAR' OF _oDlgARM PIXEL SIZE 120 ,9
@ 102,010 SAY    'LOJA TRIANGULAR'  OF _oDlgARM PIXEL SIZE 120 ,9

@ 012,130 MSGET _cCliente Valid VldCli(_cCliente,_cLoja,1)    Picture '@!' F3 "SA1" SIZE 040,09 PIXEL OF _oDlgARM
@ 027,130 MSGET _cLoja    Valid VldCli(_cCliente,_cLoja,2)    Picture '@!'          SIZE 040,02 PIXEL OF _oDlgARM
@ 042,130 MSGET _cTransp  Valid VldTransp(_cTransp)         Picture '@!' F3 "SA4" SIZE 040,09 PIXEL OF _oDlgARM
@ 057,130 MSGET _cPlaca   Valid Eval({|| _cPlaca:=upper(_cPlaca),VldPla(_cPlaca)}) Picture "@! AAA9999" SIZE 040,09 PIXEL OF _oDlgARM
@ 072,130 MSGET _cUF      Valid ExistCpo("SX5","12"+_cUF) Picture "@!" F3 "12" SIZE 040,09 PIXEL OF _oDlgARM  //Alberto - 05/03/11 - Inclusao validacao do estado
//@ 087,130 MSGET _cOpTri    Valid VldOpe(_cOpTri) Picture "@!"  SIZE 040,09 PIXEL OF _oDlgARM   //Alex Borges - 02/08/2016 - Chamado 350242
@ 087,130 MSGET _cCliTri Valid VldCli(_cCliTri,_cLjTri,1)    Picture '@!' F3 "SA1" WHEN IIF(_cOpTri='S',.T.,.f.) SIZE 040,09 PIXEL OF _oDlgARM
@ 102,130 MSGET _cLjTri  Valid VldCli(_cCliTri,_cLjTri,2)    Picture '@!'          WHEN IIF(_cOpTri='S',.T.,.f.) SIZE 040,02 PIXEL OF _oDlgARM

//@ 102,080 BUTTON _oBotaoOk   prompt "Ok"      size 40,11 font _oDlgARM:oFont ACTION Eval(_bValid)   of _oDlgARM PIXEL //Alex Borges - 02/08/2016 - Chamado 350242
//@ 102,128 BUTTON _oBotaoSair prompt "Cancela" size 40,11 font _oDlgARM:oFont ACTION Close(_oDlgARM) of _oDlgARM PIXEL //Alex Borges - 02/08/2016 - Chamado 350242
@ 120,080 BUTTON _oBotaoOk   prompt "Ok"      size 40,11 font _oDlgARM:oFont ACTION Eval(_bValid)   of _oDlgARM PIXEL
@ 120,128 BUTTON _oBotaoSair prompt "Cancela" size 40,11 font _oDlgARM:oFont ACTION Close(_oDlgARM) of _oDlgARM PIXEL

ACTIVATE MSDIALOG _oDLGARM Centered ON INIT {||_oDLGARM:End()}

return (_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldCli    ºAutor  ³Luiz Cesar          º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de Cliente                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldCli(_cCli,_cLoj,_nOpc)

//Alberto - 07/04/11 - Alteracao na validacao do cliente
If _nOpc =1
	If Empty(_cCli)
		Alert("Informar Cliente ")
		return .f.
	EndIf
	SA1->(dbSetOrder(1))
	If ! SA1->(DbSeek(xFilial("SA1")+_cCli))
		Alert("Cliente nao existe.")
		Return .F.
	Else // Alex Borges - 03/08/2016 - Chamado 350242
		If SA1->A1_MSBLQL = "1"
			Alert("Cliente Bloqueado!")
			Return .F.
		EndIf
	EndIf
Elseif _nOpc=2
	If Empty(_cCli) .or. Empty(_cLoj)
		Alert("Informar Cliente e Loja")
		return .f.
	EndIf
	SA1->(dbSetOrder(1))
	If ! SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoj))
		Alert("Cliente nao existe.")
		Return .F.
	Else // Alex Borges - 03/08/2016 - Chamado 350242
		If SA1->A1_MSBLQL = "1"
			Alert("Cliente Bloqueado!")
			Return .F.
		EndIf
	EndIf
Endif

//Alex Borges - 01/08/2016 - Chamado 350242
dbSelectArea("ZZG")
dbSetOrder(1)
If dbSeek(xFilial("ZZG") + _cCliente + _cLoja)
	If ZZG->ZZG_A_TRIA = 'S'
    	If Empty(ZZG->ZZG_TESPIA)
			MsgInfo("O campo 'TES PIA Triangular' nao esta preenchido no cadastro auxiliar de clientes. Entrar em contato com depto comercial.")
			_cOpTri := "N"
			Return .F.
		Else
			_cOpTri := "S"
		Endif
    Else
    	_cOpTri := "N"
    EndIf
EndIf

Return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldPla    ºAutor  ³J.francisco         º Data ³  14/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao da Placa                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldPla(_cPla)

If Empty(_cPla)
	Alert("Informar Placa")
	return .f.
Else // Alex Borges - 03/08/2016 - Chamado 350242
	If Len(Alltrim(_cPla)) <> 7
		Alert("Placa Invalida")
		Return .f.
	EndIf
EndIf
if SUBSTR(_cPla,1,1) < 'A' .OR. SUBSTR(_cPla,1,1) > 'Z'
	Alert("Placa Invalida")
	Return .F.
Endif
if SUBSTR(_cPla,2,1) < 'A' .OR. SUBSTR(_cPla,2,1) > 'Z'
	Alert("Placa Invalida")
	Return .F.
Endif
if SUBSTR(_cPla,3,1) < 'A' .OR. SUBSTR(_cPla,3,1) > 'Z'
	Alert("Placa Invalida")
	Return .F.
Endif
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldTransp ºAutor  ³Luiz Cesar          º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de Transportador                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldTransp(_cTrp)
If Empty(_cTrp)
	Alert("Informar Transportadora")
	Return .F.
EndIf
SA4->(dbsetOrder(1))
If !SA4->(DbSeek(xFilial()+_cTrp))
	Alert("Transportadora nao cadastrada")
	Return .F.
Else // Alex Borges - 03/08/2016 - Chamado 350242
	If SA4->A4_MSBLQL = "1"
		Alert("Transportadora Bloqueada!")
		Return .F.
	EndIf
EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldOpe    ºAutor  ³Luis Alberto        º Data ³  05/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao operacao triangular                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldOpe(_cOpTri)

If Empty(_cOpTri)
	Alert("Informar operacao triangular. S ou N")
	return .f.
EndIf
if _cOpTri <> "S" .and. _cOpTri <>"N"
	Alert("Informar operacao triangular. S ou N")
	Return .F.
Endif
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROCPAH   ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta arquivo de trabalho e efetua faturamento             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcPAH()

//Felipe - 20/09/2011 - Parametro que permite ou nao faturamento com data retroativa
Local _cCRWDFAT := GetMV("MV_CRWDFAT")
Local _lGeraPedEmb := .T.
Local _cNota := ""

_nVol := 0
_nVolNFE := 0

//Felipe - 20/09/2011 - Atualiza a variavel ddatabase para nao permitir faturamento com data incorreta
If _cCRWDFAT == "N"
	DDATABASE := Date()
Endif

SA1->(dbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))

//Felipe - 23/02/16 - Chamado 303631 - Posiciona e busca informacoes no cadastro auxiliar do cliente ZZG
dbSelectArea("ZZG")
dbSetOrder(1)
If dbSeek(xFilial("ZZG") + SA1->A1_COD + SA1->A1_LOJA)
	If ZZG->ZZG_A_EMB <> "S"
		_lGeraPedEmb := .F.
	EndIf
Else
	Alert("Cliente sem cadastro auxiliar. Entrar em contato com depto comercial.","Aviso",.t.,3000)
	Return
EndIf

_cTabPRE := ""

TRBPAH->(dbgotop())

_lNota := .T.
_aFatu := {'',''}
Begin transaction

While !TRBPAH->(eof())

	_cxProd := TRBPAH->PAH_A_PROD
	_nxQtd    := TRBPAH->PAH_A_QTD
	_cALMOX   := POSICIONE("PAA",1,xFilial("PAA")+TRBPAH->PAH_A_ARM,"PAA_A_LOCP")
	_cALMOX   := '01'   // CESAR VERIFICAR PARAMETRO
	_cLOCALIZ := Space(15)
	_cPRFT    := space(6)

	dbselectArea("TRBPAH")
	While  !TRBPAH->(eof()) .and. TRBPAH->PAH_A_PROD=_cxProd

		if _nxQtd>0 .and. TRBPAH->PAH_A_OK <> '  '

			_nVolNFE := TRBPAH->PALLETS // Alex Borges - 03/08/2016 - Chamado 350242

			//Felipe - 26/08/2011 - Posiciona SB1 para posterior busca do tipo do frete na tabela PBS e nao mais na tabela SZR
			SB1->(DbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + TRBPAH->PAH_A_PROD) )

			// GERA PEDIDO
			if _nvol=0
				//Alberto - 02/05/13- Gerar mov.entrada para etiqueta recebida em contingencia.
                //Alberto - 02/10/13- Inibida a geracao da mov.interna pois a nota em contingencia passou a ser incluida no recebimento do PIA
//				If TRBPAH->PAH_A_ST ='C'
//					If !GeraEntr(TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_QTD,_cAlmox,TRBPAH->PAH_A_PRFT)
//						Return
//					Endif
//				Endif

				if !VldTabel()
					alert("Tabela de preco invalida !!")
					DisarmTransaction()  //Alberto - 02/10/13- Incluido disarmtransaction qdo nao encontrar tabela de preco
					Return
				endif

                /*//Alberto - 05/12/14- Operacao triangular
				If _cOpTri ='S'
					DbSelectArea("SA1")
					DbSetOrder(1)
					DbSeek(xFilial("SA1") + _cCliente+_cLoja)
				   If SA1->A1_A_CODCL = ' ' .OR. SA1->A1_A_LJCL =' '   .OR. SA1->A1_A_TESAL=' ' .OR. SA1->A1_A_TESPA=' '.OR.SA1->A1_A_TESIS=' '
						Alert("Os campos do cliente para operacao triangular nao estao preenchidos no cadastro de clientes. Entrar em contato com depto comercial.","Aviso",.t.,3000)
						DisarmTransaction()
						Return
				   Endif

				   _cCliTri := SA1->A1_A_CODCL  // Cliente operacao triangular
				   _cLjTri :=  SA1->A1_A_LJCL   // Loja operacao triangular
				   _cTesAlTri := SA1->A1_A_TESAL  //Tes Aliquota operacao triangular
				   _cTesPaTri := SA1->A1_A_TESPA  //Tes Pauta operacao triangular
				   _cTesIsTri := SA1->A1_A_TESPA  //Tes Pis Cofins isento operacao triangular
				   _cTesIsTri := SA1->A1_A_TESIS  //Tes Pis Cofins isento operacao triangular
			   	   _cPTaxSA1 := SA1->A1_A_PTXD1
				   _nPerTSA1 := SA1->A1_A_PEPTX
                   _cProd:= TRBPAH->PAH_A_PROD
					_cNomeCli:= ALLTRIM(SA1->A1_NOME)
					_cEndCli := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
					_cCNPJCli:= SA1->A1_CGC
					_cIECli  := ALLTRIM(SA1->A1_INSCR)
				   //Validar tabela de preco do cliente  da operacao triangular
				   _nRecSA1:=SA1->(recno())
					If !VldCliTri(_cCliTri,_cLjTri,_cProd)
						DisarmTransaction()
						Return
        		    Endif
				    SA1->(DbGoTo(_nRecSA1))

				Endif*/ //Alex Borges - 03/08/2016 - Chamado 350242

				If _cOpTri = 'S' //Alex Borges - 03/08/2016 - Chamado 350242

					If _cCliente+_cLoja = _cCliTri+_cLjTri
						_cOpTri := "N"
					Else
						dbSelectArea("SA1")
						DbSetOrder(1)
						DbSeek(xFilial("SA1") + _cCliente+_cLoja)
						_cNomeCli:= ALLTRIM(SA1->A1_NOME)
						_cEndCli := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
						_cCNPJCli:= SA1->A1_CGC
						_cIECli  := ALLTRIM(SA1->A1_INSCR)
					EndIf
				EndIf

				dbselectArea("TRBPAH")
				IncProc("Gerando Pedido de Venda...")// Alex Borges - 03/08/2016 - Chamado 350242
				if !GerPed(SA1->A1_COD,SA1->A1_LOJA,_cTabPre)
					alert("Nao foi gerado pedido automatico !!")
					DisarmTransaction()
					return
				endif

			    //Felipe - 23/02/16 - Chamado 303631 - Informacoes vindas do cadastro auxiliar do cliente ZZG
				//If SA1->A1_A_EMBAL == "S"   //Francisco - 14/03/11 - Criacao do pedido de embalagem
				//If _lGeraPedEmb // Alex Borges - 04/08/2016 - Chamado 350242
				If _lGeraPedEmb .OR. _cOpTri = "S"
					IncProc("Gerando Material de Embalagem...")// Alex Borges - 03/08/2016 - Chamado 350242
					if ! GerPedEmb(_cPedido) // gera pedido com material de embalagem
						alert("Nao foi gerado pedido material embalagem automatico !!")
						DisarmTransaction()
						return
					endif

				EndIf

				SC5->(dbsetorder(1))
				SC5->(dbseek(xfilial("SC5")+_cPedido))

				CRIANOT() // CRIA TABELA PARA OS PEDIDOS
			endif

			_cPRFT := TRBPAH->PAH_A_PRFT

			// Carrega tabela de preco por produto
			_lPrc:=AtuPrc(TRBPAH->PAH_A_PROD)
			If !_lPrc[1]
				DisarmTransaction() // Alex Borges - 03/08/2016 - Chamado 350242
				Return
			Endif
			AtuCab(Space(2),TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_PRFT,TRBPAH->PAH_A_QTD*_lPrc[2],TRBPAH->PAH_A_QTD)
			AtuItem(TRBPAH->PAH_A_PRFT,Space(6),Space(20),TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_QTD,_cLOCALIZ,_cALMOX,_cPLACA,_lPrc[2])
			if TRBPAH->(Reclock("TRBPAH",.F.))
				//Alberto - 29/04/13-Tratamento para recebimento xml em contigencia
				If TRBPAH->PAH_A_ST = "L"
					TRBPAH->PAH_A_ST := "F"
				Elseif TRBPAH->PAH_A_ST = "C"
					TRBPAH->PAH_A_ST := "G"
				Endif
				TRBPAH->(msunlock())
			endif
			_nxQtd := _nxQtd - 1

			_nVol := _nVol + 1
		endif

		TRBPAH->(dbskip())
	End
end

_cSerie:=""

_xcCF:=NIL

_cxTES := GetMv("CE_SERNFS")

SF4->(DbSetOrder(1))
If SF4->(DbSeek(xFilial("SF4")+_cxTES))
	_xcCF:=SF4->F4_CF
Endif

// DEFINE NUMERO DA NOTA FISCAL A SER GERADA
_aItens := {}

If Empty(_cSerie)  // VERIFICAR SERIE
	_cSerie:=SD2->D2_SERIE
Endif

_lNota := .T.


_cCliente:= SA1->A1_COD
_cPTaxD1 := SA1->A1_A_PTXD1

_cPedido:=SC5->C5_NUM
fTrocaP(_cPRFT,_cPedido,Space(2),Space(20))
IncProc("Gerando Nota Fiscal...")// Alex Borges - 03/08/2016 - Chamado 350242
If _cOpTri = "S"
	_aFatu:=GerFat(_cPedido,"")
Else
	_aFatu:=GerFat(_cPedido,_cPedidoE)
EndIf
SF2->(dbsetorder(1))
if SF2->(dbseek(xfilial("SF2")+_aFatu[1]+_aFatu[2]))

	//Alex Borges - 03/08/2016 - Chamado 350242
	_cNota   := _aFatu[1]
   	_cSerie  := _aFatu[2]
	aAreaSF2 := SF2->(GetArea())

	//Se for operação triangular gera a segunda nota fiscal
   	If _cOpTri ='S'
		//Gera segunda nota
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+_cCliTri+_cLjTri))
		_cNomeTri:= ALLTRIM(SA1->A1_NOME)
		_cEndTri := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
		_cCNPJTri:= SA1->A1_CGC
		_cIETri := ALLTRIM(SA1->A1_INSCR)

		//GERA PEDIDO
		dbselectArea("TRBPAH")// Alex Borges - 22/09/2016 - Chamado 350242
        dbgotop()// Alex Borges - 22/09/2016 - Chamado 350242
		IncProc("Gerando Pedido de Venda Triangular...")// Alex Borges - 03/08/2016 - Chamado 350242
		if !GerPedTri(SA1->A1_COD,SA1->A1_LOJA,_cTabPre)
			alert("Nao foi gerado pedido automatico !!")
			DisarmTransaction()
			_lNota := .F.
			return
		endif

		SC5->(dbsetorder(1))
		SC5->(dbseek(xfilial("SC5")+_cPedTri))

		CRIANOT() // CRIA TABELA PARA OS PEDIDOS

		// Carrega tabela de preco por produto
		_lPrc:=AtuPrc(TRBPAH->PAH_A_PROD)
		_cALMOX   := '01'
		If !_lPrc[1]
			DisarmTransaction()// Alex Borges - 03/08/2016 - Chamado 350242
			Return
		Endif

		AtuCab(Space(2),TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_PRFT,TRBPAH->PAH_A_QTD*_lPrc[2],TRBPAH->PAH_A_QTD)
		AtuItem(TRBPAH->PAH_A_PRFT,Space(6),Space(20),TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_QTD,_cLOCALIZ,_cALMOX,_cPLACA,_lPrc[2])

		_nxQtd := _nxQtd - 1
		_nVol := _nVol + 1
		_lNota := .T.
		_cCliente:= SA1->A1_COD
		_cPedTri:=SC5->C5_NUM
		 fTrocaP(_cPRFT,_cPedTri,Space(2),Space(20))
		IncProc("Gerando Nota Fiscal Triangular...")// Alex Borges - 03/08/2016 - Chamado 350242
		//_aFatu:=GerFat(_cPedTri," ")// Alex Borges - 03/08/2016 - Chamado 350242
		_aFatu:=GerFat(_cPedTri,_cPedidoE)
        _cNotaTri  := _aFatu[1]
        _cSerieTri := _aFatu[2]

		Dbselectarea("SF2")
		Dbsetorder(1)
		RecLock('SF2',.f.)
		SF2->F2_A_PLACA  := _cPlaca
		SF2->F2_TRANSP   := _cTransp
		SF2->F2_VOLUME1  := _nVolNFE
		SF2->F2_A_UFP    := _cUf
		SF2->F2_A_DOCTR := _cNota
		SF2->F2_A_SERTR := _cSerie
		SF2->F2_VOLUME1 := TRBPAH->PALLETS
		SF2->(MSUNLOCK())

		//Atualiza mensagem no pedido remessa
		Dbselectarea("SC5")
		SC5->(dbsetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+_cPedido))
			RecLock('SC5',.f.)
			//Alex Borges - 26/09/16 - Chamado - 350242
			//SC5->C5_MENNOTA := " MERCADORIA ENVIADA POR CONTA E ORDEM DE "+_cNomeTri+"-"+_cEndTri+"-CNPJ "+_cCNPJTri+"-I.E."+_cIETri+"-"+" CONF. NF. "+_cNotaTri
			SC5->C5_MENNOTA := " Mercadoria enviada para fins de industrialização a "+_cNomeTri+"-"+_cEndTri+"-CNPJ "+_cCNPJTri+"-I.E."+_cIETri+"-"+" CONF. NF. "+_cNotaTri
			SC5->(MSUNLOCK())
		EndIf

		//Atualiza mensagem no pedido venda
		Dbselectarea("SC5")
		SC5->(dbsetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+_cPedTri))
			RecLock('SC5',.f.)
			//Alex Borges - 26/09/16 - Chamado - 350242
			//SC5->C5_MENNOTA := "A NF SEGUIU P/ "+_cNomeCli+"-"+_cEndCli+"-CNPJ "+_cCNPJCli+"-I.E."+_cIECli+"-"+" CONF. NF. "+_cNota
			SC5->C5_MENNOTA := "Mercadoria que segue para fins de indust. impostos já recolhido atraves da NF "+_cNota+", empresa "+_cNomeCli+"-"+_cEndCli+"-CNPJ "+_cCNPJCli+"-I.E."+_cIECli+"."
			SC5->(MSUNLOCK())
		EndIf
	Endif

	RestArea(aAreaSF2)
	RecLock('SF2',.f.)
	SF2->F2_A_PLACA  := _cPlaca
	SF2->F2_TRANSP   := _cTransp
	SF2->F2_VOLUME1  := _nVolNFE
	SF2->F2_A_DEPF   := "S"
	SF2->F2_A_UFP    := _cUf
	If _cOpTri ='S'
		SF2->F2_A_DOCTR := _cNotaTri
		SF2->F2_A_SERTR := _cSerieTri
	EndIf
	SF2->(MSUNLOCK())

	TRBPAH->(dbgotop())
	While !TRBPAH->(EOF())
		IF TRBPAH->PAH_A_OK <> '  '
		    IncProc("Finalizando Faturamento...")// Alex Borges - 03/08/2016 - Chamado 350242
			PAH->(dbsetorder(3))
			if PAH->(dbseek(xFilial("PAH")+TRBPAH->PAH_A_PRFT))

				While !PAH->(EOF()) ;
					.AND. PAH->PAH_A_PRFT = TRBPAH->PAH_A_PRFT

					If Reclock("PAH",.F.)
						PAH->PAH_A_DTFT  := dDataBase
						/*PAH->PAH_A_NFFT  := _aFatu[1]
						PAH->PAH_A_SERF  := _aFatu[2]*/ // Alex Borges - 03/08/2016 - Chamado 350242
						If _cOpTri ='S'
							PAH->PAH_A_NFFT := _cNotaTri
							PAH->PAH_A_SERF := _cSerieTri
						Else
							PAH->PAH_A_NFFT :=	_cNota
							PAH->PAH_A_SERF := 	_cSerie
						EndIf
						//Alberto - 29/04/13-Tratamento para recebimento xml em contigencia
						If PAH_A_ST = "L"
							PAH->PAH_A_ST := "F"
						Elseif PAH_A_ST = "C"
							PAH->PAH_A_ST := "G"
						Endif
						//						PAH->PAH_A_ST    :="F"
						MsUnlock()

						// Ricardo Lima - 04/09/17
						u_ALUFATC8( "S" , PAH->PAH_A_PROD , PAH->PAH_A_NFFT , "" , PAH->PAH_A_QTD )
					else
						_lNota := .F.
					Endif

					// Verifica se atualiza onsite
					IF SF2->F2_A_DEPF="S"
						_cIdentb6:=""
						DbSelectArea("SD2")
						DbsetOrder(3)
						DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
						While !Eof() .and.( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)=;
							(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If SD2->D2_COD=PAH->PAH_A_PROD
								_cIdentb6:=SD2->D2_IDENTB6
								Exit
							Endif
							DbSelectArea("SD2")
							DbSkip()
						End
						RecLock("PB5",.T.)
						PB5->PB5_FILIAL  := xFilial("PB5")
						PB5->PB5_CODONS  := SF2->F2_CLIENTE+SF2->F2_LOJA
						PB5->PB5_CODETI  := PAH->PAH_A_ETIQ
						PB5->PB5_CODPRO  := PAH->PAH_A_PROD
						PB5->PB5_HRORI   := SF2->F2_HORA
						PB5->PB5_DTORI	 := SF2->F2_EMISSAO
						PB5->PB5_QTDORI	 := PAH->PAH_A_QTD
						PB5->PB5_SALDO	 := PAH->PAH_A_QTD
						PB5->PB5_NFORI	 := SF2->F2_DOC
						PB5->PB5_SERORI  := SF2->F2_SERIE
						PB5->PB5_USUARI  := Substr(cUsuario,7,15)

						// Alterado por Ricardo Lima - 30/11/2010
						PB5->PB5_STATUS	 := "T"

						PB5->PB5_IDENTB  := _cIdentb6
						//Alberto - 24/03/2011- Alteracao da origem
						PB5->PB5_ORIGEM  := "P" //I=Deposito interno da Crown  E=Armazem externo P= PIA
						PB5->(MsUnLock())
					Endif
					_nVolNFE++ // contagem de volume da nota fiscal - Ricardo Lima
					PAH->(dbskip())

				End
			else
				_lNota := .F.
			Endif
		Endif
		TRBPAH->(dbskip())
	End

	/*if SF2->(Reclock("SF2",.F.))
		SF2->F2_A_PLACA  := _cPlaca
		SF2->F2_TRANSP   := _cTransp
		SF2->F2_VOLUME1  := _nVolNFE  //   _nVol // alterado por Ricardo Lima 27/10/10 _nVol nao tem contagem de itens correto.
		SF2->F2_A_DEPF   := "S"
		SF2->F2_A_UFP    := _cUf
		SF2->(MsUnlock())
	else
		_lNota := .F.
	endif*/ // Alex Borges - 03/08/2016 - Chamado 350242

   /*_cNota  := _aFatu[1]
   _cSerie := _aFatu[2]

   //Alberto - 05/12/14- Operacao triangular
   If _cOpTri ='S'
			//Gera segunda nota
			SA1->(dbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+_cCliTri+_cLjTri))
			_cNomeTri:= ALLTRIM(SA1->A1_NOME)
			_cEndTri := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
			_cCNPJTri:= SA1->A1_CGC
			_cIETri := ALLTRIM(SA1->A1_INSCR)

			//VALIDA TABELA
			If !VldCliTri(_cCliTri,_cLjTri,_cProd)
				alert("Tabela de preco invalida !!")
				DisarmTransaction()
				Return
   		    Endif

			//VALIDA PTAX D-1 DOS CLIENTES DA OPERACAO
			If SA1->A1_A_PTXD1 <> _cPtaxD1
				alert("Campo PTax D-1 divergente entre os clientes da op. triangular!")
				DisarmTransaction()
				Return
			EndIf

			//GERA PEDIDO
			dbselectArea("TRBPAH")
            dbgotop()
			if !GerPedTri(SA1->A1_COD,SA1->A1_LOJA,_cTabTri)
				alert("Nao foi gerado pedido automatico !!")
				DisarmTransaction()
				_lNota := .F.
				return
			endif

			SC5->(dbsetorder(1))
			SC5->(dbseek(xfilial("SC5")+_cPedTri))

			CRIANOT() // CRIA TABELA PARA OS PEDIDOS

			// Carrega tabela de preco por produto
			_lPrc:=AtuPrc(TRBPAH->PAH_A_PROD)
			_cALMOX   := '01'
			If !_lPrc[1]
				Return
			Endif

			AtuCab(Space(2),TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_PRFT,TRBPAH->PAH_A_QTD*_lPrc[2],TRBPAH->PAH_A_QTD)
			AtuItem(TRBPAH->PAH_A_PRFT,Space(6),Space(20),TRBPAH->PAH_A_PROD,TRBPAH->PAH_A_QTD,_cLOCALIZ,_cALMOX,_cPLACA,_lPrc[2])

			_nxQtd := _nxQtd - 1
			_nVol := _nVol + 1
			_lNota := .T.
			_cCliente:= SA1->A1_COD
			_cPedTri:=SC5->C5_NUM
			 fTrocaP(_cPRFT,_cPedTri,Space(2),Space(20))
			_aFatu:=GerFat(_cPedTri," ")
	        _cNotaTri  := _aFatu[1]
	        _cSerieTri := _aFatu[2]

			Dbselectarea("SF2")
			Dbsetorder(1)
			RecLock('SF2',.f.)
			SF2->F2_A_DOCTR := _cNota
			SF2->F2_A_SERTR := _cSerie
			SF2->(MSUNLOCK())

			If Dbseek(xfilial("SF2")+_cnota+_cSerie)
				RecLock('SF2',.f.)
				SF2->F2_A_DOCTR := _cNotaTri
				SF2->F2_A_SERTR := _cSerieTri
				SF2->(MSUNLOCK())
			Endif

			//Atualiza mensagem no pedido remessa
			Dbselectarea("SC5")
			SC5->(dbsetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+_cPedido))
				RecLock('SC5',.f.)
				SC5->C5_MENNOTA := " MERCADORIA ENVIADA POR CONTA E ORDEM DE "+_cNomeTri+"-"+_cEndTri+"-CNPJ "+_cCNPJTri+"-I.E."+_cIETri+"-"+" CONF. NF. "+_cNotaTri
				SC5->(MSUNLOCK())
			EndIf

			//Atualiza mensagem no pedido venda
			Dbselectarea("SC5")
			SC5->(dbsetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+_cPedTri))
				RecLock('SC5',.f.)
				SC5->C5_MENNOTA := "A NF SEGUIU P/ "+_cNomeCli+"-"+_cEndCli+"-CNPJ "+_cCNPJCli+"-I.E."+_cIECli+"-"+" CONF. NF. "+_cNota
				SC5->(MSUNLOCK())
			EndIf
   Endif */ // Alex Borges - 03/08/2016 - Chamado 350242

else
	_lNota := .F.
Endif

End transaction

//if _lNota .and. !empty(alltrim(_aFATU[1])) // Alex Borges - 03/08/2016 - Chamado 350242
If _lNota .and. !empty(alltrim(_cNota))
   If !empty(_cNotaTri) //Alberto - 05/12/14 - Operacao triangular
		//Alert("Foram geradas as notas fiscais "+_cNota+" "+_cNotaTri,"Aviso",.T.,6000) //Alex Borges - 03/08/2016 - Chamado 350242
		MsgInfo("Foram geradas as notas: "+CHR(13)+CHR(10) +_cNota + " e a "+_cNotaTri+" Serie - " + _cSerie )
   Else
		//alert("Nota - " + _cNota + " Serie - " + _cSerie + " gerada") //Alex Borges - 03/08/2016 - Chamado 350242
		MsgInfo("Foi gerado a Nota Fiscal : "+CHR(13)+CHR(10) +_cNota +" Serie - " + _cSerie )
   Endif
else
	alert("Processo de geracao de nota fiscal nao executado corretamente, favor verificar !!!")
endif

// GERA XML NA AREA DO FTP

U_fAltdBase(.f.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldTabel ºAutor  ³Luiz Cesar          º Data ³  29/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Tabela                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldTabel(_cCli,_cLj,_cProd)
Local _cret := .T.

If SELECT( "TRBNUM")<>0
	TRBNUM->(DbCloseArea())
EndIf

_cQueryN  := "SELECT MAX(ZR_CODTAB) ZR_CODTAB FROM " + RetSqlName("SZR") + " ZR, " + RetSqlName("SZS") + " ZS"
_cQueryN  += " WHERE ZR_FILIAL = '" + xFilial("SZR") + "'"
_cQueryN  += " AND   ZR.D_E_L_E_T_ = ' '"

//Esse campo identifica se o cliente é um deposito on site
//Nesse caso deve ser utilizada a tabela de preco do cliente identificado nesse campo
If empty(SA1->A1_A_FATUR)
	_cQueryN  += " AND   ZR_CLIENTE = '" + SA1->A1_COD + "'"
	_cQueryN  += " AND   ZR_LOJACLI = '" + SA1->A1_LOJA + "'"
Else
	_cCliDF  := substr(SA1->A1_A_FATUR,1,6)
	_cLojaDF := substr(SA1->A1_A_FATUR,7,2)
	_cQueryN += " AND   ZR_CLIENTE = '"+_cCliDF+"'"
	_cQueryN += " AND   ZR_LOJACLI = '"+_cLojaDF +"'"
Endif
_cQueryN  += " AND    SubStr(ZR_DATADE,1,6) <= '" + Str(Year(dDatabase),4)+Strzero(Month(dDatabase),2)+ "'" // RICARDO LIMA - 08/09/2010
_cQueryN  += " AND    SubStr(ZR_DATAATE,1,6) >= '" + Str(Year(dDatabase),4)+Strzero(Month(dDatabase),2)+ "'" // RICARDO LIMA - 08/09/2010
_cQueryN  += " AND   ZR_CODTAB = ZS_CODTAB "
_cQueryN  += " AND   ZS_CODPRO = '" + TRBPAH->PAH_A_PROD + "'"
_cQueryN  += " AND   ZR_STATUS = 'A' "  // RICARDO LIMA - 08/12/15
_cQueryN  += " AND   ZS.D_E_L_E_T_ <> '*' "
DbUseArea( .T., "TopConn", TCGenQry(,,_cQueryN), "TRBNUM", .F., .F. )
//_cTabPre  := Alltrim(TRBNUM->ZR_CODTAB) - Alex Borges 28/07/14 - Chamado 292175
_cTabPre  := TRBNUM->ZR_CODTAB

memowrite("TABZRPIA.SQL",_cQueryN)

If Empty(_cTabPre)
	Alert("Tabela de Preço não Encontrada ou Não Aprovada, Consulte o Setor Comercial!!!")  // Ricardo Lima - 08/12/15
	U_fAltdBase(.f.)
	_cRet := .F.
Endif

If !TabPrc(_cTabPre)
	_cRet := .F.
Endif

//Alberto - 01/06/11 - Atualizar o codigo da tabela de preco no cadastro de clientes, senao o sistema nao inclui o pedido de venda(mensagem tabela preco invalida)
IF ALLTRIM(SA1->A1_TABELA) <> _cTabPre
	Dbselectarea("SA1")
	Reclock("SA1",.F.)
	SA1->A1_TABELA := _cTabPre
	MsUnlock()
ENDIF

Return (_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaNOT   ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao de tabela auxiliar                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

***********************
Static Function CRIANOT()
***********************
Local _cChave4
Local _cChave3
Local _aStru
Local _cArqM := CriaTrab(NIL,.F.)
Local _cArq  := CriaTrab(NIL,.F.)

_aStru :={{"NOTA"   ,"C",02,00},; //Alberto -14/10/14-Alteracao do campo de NOT para NOTA para evitar conflito na cricao de indice no ctre
{"PEDIDO"  ,"C",06,00},;
{"PRODUTO" ,"C",15,00},;
{"VALOR"   ,"N",15,05},;
{"QTDE"    ,"N",15,03}}

If SELECT("CABNOT")<>0
	CABNOT->(DbCloseArea())
EndIf
DbCreate( _cArqm, _aStru)
dbUseArea(.T.,,_cArqM,'CABNOT',.t.,.F.) // COMPARTILHADO
_cChave4 := 'NOTA+PEDIDO+PRODUTO' //Alberto -14/10/14-Alteracao do campo de NOT para NOTA para evitar conflito na cricao de indice no ctre
IndRegua("CABNOT",CriaTrab(NIL,.F.),_cChave4,,,"Indexando Cabecalho de itens")
_aStru :={{"PEDIDO"  ,"C",06,00},;
{"TRANSP"  ,"C",06,00},;
{"IDETIQ"  ,"C",20,00},;
{"PRODUTO" ,"C",15,00},;
{"QTDE"    ,"N",15,03},;
{"LOCALIZ" ,"C",15,00},;
{"ALMOX"   ,"C",02,00},;
{"ALMO2"   ,"C",02,00},;
{"PLACA"   ,"C",08,00},;
{"PRECO"   ,"N",14,05}}
If SELECT("NOT")<>0
	NOT->(DbCloseArea())
EndIf
DBCreate( _cArq, _aStru)
dbUseArea(.T.,,_cArq,'NOT',.t.,.F.)
_cChave3:= 'IDETIQ+PRODUTO+PEDIDO+LOCALIZ+ALMOX'
IndRegua("NOT",CriaTrab(NIL,.F.),_cChave3,,,"Indexando Itens")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUPRC    ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Tabela de Preco                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*****************************
Static Function AtuPrc(_cCodPro)
*****************************
Local _aAliasAnt := GetArea()
Local _cPrecVen := 0
DbSelectArea("DA0")
DbSetOrder(1)
DbSeek(xFilial("DA0")+_cTabPre)
dbSelectArea("DA1")
dbSetorder(1)
If dbSeek(xFilial("DA1")+DA0->DA0_CODTAB+_cCodPro)
	_cPrecVen := DA1->DA1_PRCVEN
Else
	Alert("Tabela de precos nao localizada.Do Produto:"+_cTabpre+_cCodPro)
	Return {.f.,0}
Endif
RestArea(_aAliasAnt)
Return {.t.,_cPrecVen}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TABPRC    ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida e busca dados da tabela de preco                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*****************************
Static Function TabPrc(_cTabPre)
*****************************
Local _aAliasAnt := GetArea()
Local _lReturn:= .f.
cDatHoje:=dDataBase
DbSelectArea("DA0")
DbSetOrder(1)
IF DbSeek(xFilial()+_cTabPre)
	If DA0_DATATE >= cDatHoje
		_cCondPg := DA0_CONDPG
		_lReturn:= .T.
	ELSE
		IF cDatHoje - DA0_DATATE = 1 .AND. _nHrTabPrc < 6
			_cCondPg := DA0_CONDPG
			_lReturn:= .T.
		ELSE
			_cTabCliVen := SA1->A1_TABELA
			_dDtVenCli  := DA0->DA0_DATATE

			If SA1->A1_TABELA <> _cTabCliVen
				DbSelectArea("DA0")
				DbSetOrder(1)
				If DbSeek(xFilial("DA0")+SA1->A1_TABELA)
					If DA0->DA0_DATATE > _dDtVenCli .AND. DA0->DA0_DATATE >= cDatHoje
						_cTabPre := SA1->A1_TABELA
						_cCondPg := DA0->DA0_CONDPG
						_lReturn:= .T.
					Else
						Alert("Tabela de Preco cadastrada no cliente esta vencida")
						RestArea (_aAliasAnt)
						Return
					EndIf
				EndIf
			Else
				Alert("Tabela de Preco cadastrada no cliente esta vencida")
				RestArea (_aAliasAnt)
				Return
			EndIf
			RestArea (_aAliasAnt)
		ENDIF
	ENDIF
Else
	Alert("Tabela de preço não cadastrada!")
Endif
RestArea (_aAliasAnt)
Return(_lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERFAT    ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Nota Fiscal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************************************************************
Static Function GerFat(_cPedido,_cPedidoE)
********************************************************************************

// VARIAVEIS SAO DEFINIDAS COMO PRIVATE, POIS SAO UTILIZADAS INTERNAMENTE NA FUNCAO MaPvlNfs

Private nValor   := 0
Private nQtde    := 0  //quantidade atual
Private aPvlNfs:={}
Private cNota
Private lMSErroAuto := .F.
Private SERIE:=GetMv("CE_SERNFS") // SERIE ESPECIFICA PARA VENDA EM RESENDE
Padr(Serie,3)
Private lCredOK := .f.

If GetMV("MV_CRWCRED") # "S" .OR. SF4->F4_DUPLIC # "S"
	lCredOK:= .t.
Endif

If ! lCredOK

	If ! Credito(_cPedido)
		_lNota := .F.
		MostraErro()
		DisarmTransaction()
		Break
		Return .F.
	Endif
Endif

IF Empty(SERIE)
	SERIE := GetMv("CE_SERNFS")
Endif
Libera(_cpedido,_cPedidoE) // liberando pedido e empenhando
cNota := MaPvlNfs(aPvlNfs,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

// LUIZ CESAR - Correcao Retorno da funcao - 13/05/2009
RETURN({cNota,SERIE})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Credito   ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Avalia Credito                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************************************************************************
Static Function Credito(cPedido)
************************************************************************************
Local cBlqCred:= " "
Local lCredito:= .f.

nValor:= ValorNOT(cPedido)

SC5->(dbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+cPedido))
	lCredito := MaAvalCred(SC5->C5_CLIENTE,SC5->C5_LOJACLI,nValor,SC5->C5_MOEDA,.T.,@cBlqCred)
EndIf

If ! lCredito
	If cBlqCred == "04"
		Alert("Cliente com limite de credito vencido.")
	Else
		Alert("Excedeu o limite de credito do cliente.")
	Endif
	_lNota := .F.
	Return .f.
Endif
Return(lCredito)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Libera    ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Liberacao                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************************************************************
Static Function Libera(_cNumped,_cPedidoE)
********************************************************************************
Local _aProduto:={}
Local _aEmp:={}
Local _nX
Local _cAlmox

NOT->(DbGotop())
_cAlmox  := NOT->ALMOX

aPvlNfs  :={}
aPvlNfsR :={}

SC5->(dbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+_cNumPed))
_aProduto := aClone(ProdNOT())

For _nX:=1 to Len(_aProduto)
	_aEmp     := aClone(CarEmpen(_aProduto[_nx,1]))
	LibPed(_cNumPed,_aProduto[_nx,1],_aEmp[1],_aEmp[2])
	aadd(aPvlNfs , Prepara(_cNumped,_aProduto[_nx,1],_cAlmox) )
Next

//Libera pedido de embalagens e remessa quando for o caso
If !empty(_cPedidoE)  //Alberto - 05/12/14- Operacao triangular
	SC5->(dbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+_cPedidoE))

	For nX := 1 To Len(_aEmbPro)
		//	LibPed(_cPedidoE,_aEmbPro[nx,1],_aEmbPro[nx,2],{}) //Alberto - 05/05/11- Inibido pois estava liberando duas vezes o material de embalagem
		aadd(aPvlNfs,Prepara(_cPedidoE,_aEmbPro[nx,1],"01"))
	Next
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPed    ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Libera Pedido no SC6                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************************************************************
Static Function LibPed(_cNumPed,_cProd,_nQtde,_aEmp)
********************************************************************************
SC6->(DBSetOrder(2))
SC6->(DbSeek(xFilial("SC6")+_cProd+_cNumPed))
SC6->(DBSetOrder(1))
MaLibDoFat(SC6->(Recno()),;
_nQTDE,;
.T.,;
.T.,;
.F.,;
.F.,;
.F.,;
.F.,;
NIL,;
NIL,;
_aEmp)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CarEmpen      ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega Empenho                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************************************************************
Static Function CarEmpen(cProduto)
********************************************************************************
Local aEmp:={}
Local nPos:= 0
Local nTQtde:=0
NOT->(dbGotop())
While ! NOT->(Eof())
	If NOT->Produto == cProduto
		nPos :=ascan(aEmp,{|x| x[3] == NOT->LOCALIZ})
		If  nPos ==0
			aadd(aEmp,{"","",NOT->LOCALIZ,"",NOT->QTDE,0,ctod(""),"","","",NOT->ALMOX,CRIAVAR("C9_POTENCI")})
		Else
			aEmp[nPos,5] +=NOT->QTDE
		EndIF
		nTQtde +=NOT->QTDE
	Endif
	NOT->(DbSkip())
End
Return {nTQtde,aEmp}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Prepara       ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Prepara                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************************************************************
Static Function Prepara(cNumped,cProd,cLocal)
********************************************************************************
//posiciona cabecalho
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+cNumPed) )                         //FILIAL+NUMERO
//posiciona item
SC6->(DBSetOrder(2))
SC6->(DbSeek(xFilial()+cProd+cNumPed))
SC6->(DBSetOrder(1))
//posiciona itens liberados
SC9->(DbSetOrder(1))
SC9->(DbSeek(xFilial("SC9")+cNumPed+SC6->C6_ITEM) )                    //FILIAL+NUMERO+ITEM
While ! SC9->(Eof()) .and.  SC9->C9_FILIAL==xFilial("SC9") .and.;
	SC9->C9_PEDIDO==cNumPed .and. SC9->C9_ITEM == SC6->C6_ITEM
	If Empty(SC9->C9_NFISCAL)
		EXIT
	EndIf
	SC9->(DbSkip())
EndDo
SE4->(DbSetOrder(1))
SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+cProd ))           //FILIAL+PRODUTO
SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB2")+cProd+cLocal) )    //FILIAL+PRODUTO+LOCAL
SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )     //FILIAL+CODIGO
Return { SC9->C9_PEDIDO,;
SC9->C9_ITEM,;
SC9->C9_SEQUEN,;
SC9->C9_QTDLIB,;
SC9->C9_PRCVEN,;
SC9->C9_PRODUTO,;
(SF4->F4_ISS=="S"),;
SC9->(RecNo()),;
SC5->(RecNo()),;
SC6->(RecNo()),;
SE4->(RecNo()),;
SB1->(RecNo()),;
SB2->(RecNo()),;
SF4->(RecNo())}
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProdNOT       ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************************************************************************
Static function ProdNOT()
************************************************************************************
Local aProduto:={}
Local aQtd:={}
Local nPos:=0
NOT->(DBGoTop())
While ! NOT->(Eof())
	nPos:= ascan(aProduto,{|x| x[1]==NOT->PRODUTO})
	If  nPos==0
		AADD(aProduto,{NOT->PRODUTO,NOT->QTDE})
	Else
		aProduto[nPos,2]+=NOT->QTDE
	EndIf
	NOT->(DbSkip())
End
Return aProduto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValorNOT      ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************************************************************
Static Function ValorNOT(cPedido)
********************************************************************************
Local nValor:= 0
DbSelectArea("NOT")
NOT->(DBGOTOP())
While ! NOT->(Eof())
	If  NOT->PEDIDO==cPedido
		SC6->(dbSetOrder(2))
		If SC6->(DbSeek(xFilial("SC6")+NOT->PRODUTO+NOT->PEDIDO))
			nValor:= nValor+(NOT->QTDE*SC6->C6_PRCVEN)
		Endif
	Endif
	NOT->(DbSkip())
Enddo
Return(nValor)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ATUCAB        ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
***************************************************
Static Function AtuCab(cNot,cProduto,cPedido,nValor,nQTD)
***************************************************
DbSelectArea("CABNOT")
If RecLock("CABNOT",!DbSeek(cNOT+cPEDIDO))
	CABNOT->NOTA    := cNot //Alberto -14/10/14-Alteracao do campo de NOT para NOTA para evitar conflito na cricao de indice no ctre
	CABNOT->PEDIDO := cPedido
	CABNOT->PRODUTO:= cProduto
	CABNOT->VALOR  := CABNOT->VALOR+nValor
	CABNOT->QTDE   := CABNOT->QTDE+nQTD
	MsUnlock()
Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuITEM       ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************************************************************************
Static Function AtuItem(cPEDIDO,_cTransp,cIDETIQ,cPRODUTO,nQTDE,cLOCALIZ,cALMOX,cPLACA,nPRECO)
************************************************************************************
DbSelectArea("NOT")
If RecLock("NOT",!DbSeek(cIDETIQ+cPRODUTO+cPEDIDO+cLOCALIZ+cALMOX ))
	NOT->PEDIDO  := cPEDIDO
	NOT->TRANSP  := _cTransp
	NOT->IDETIQ  := cIDETIQ
	NOT->PRODUTO := cPRODUTO
	NOT->QTDE    := NOT->QTDE+nQTDE
	NOT->LOCALIZ := cLOCALIZ
	NOT->ALMOX   := cALMOX
	NOT->PLACA   := cPLACA
	NOT->PRECO   := nPRECO
	MsUnlock()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fTrocaP       ºAutor  ³Luiz Cesar          º Data ³  22/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************************************************************************
Static Function fTrocaP(cNumProc,cPedido,cNot,cIDETIQ)
************************************************************************************
//CABNOT
//_cChave4 := 'NOT+PEDIDO+PRODUTO'
DbSelectArea("CABNOT")
While Dbseek(cNot+cNumProc)
	If RecLock("CABNOT",.f.)
		CABNOT->PEDIDO := cPedido
		MsUnlock()
	Endif
	DbSelectArea("CABNOT")
End
//"NOT"
//_cChave3:= 'IDETIQ+PRODUTO+PEDIDO+LOCALIZ+ALMOX'
DbSelectArea("NOT")
DbGotop()
While !Eof()
	If      NOT->PEDIDO=cNumProc
		If RecLock("NOT",.f.)
			NOT->PEDIDO:=cPedido
			MsUnlock()
		Endif
	Endif
	Dbskip()
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPed   ³ Autor ³ Luiz Cesar            ³ Data ³ 27/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de venda automatico                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerPed(_cCliente,_cLoja,_cTabPre)

Local _aCab     := {}
Local _aItens   := {}
Local _nItem    := 0
Local _lGerouPV := .F.
Local _anArea := GetArea()

//Felipe - 01/10/14 - Variaveis para PTAX D-1 e PTAX Medio
Local _nPtxTab := 0  //PTAX da tabela de precos utilizada
Local _cPtaxD1 := "" //Flag se usa PTAX D-1 Sim, Nao ou Medio
Local _nPerPtx := 0  //Percentual da PTAX da tabela de preco que PTAX D-1 eh Medio
Local _nUltPtx := 0  //PTAX a ser utilizado
Local _nNewPrc := 0  //Novo Preco em reais
Local _nPrcUGrp := 0 //Preco em dolar sem impostos
Local _nPrcRGrp := 0 //Preco em reais sem impostos

// Ricardo Lima - 06/03/17
LOCAL lAvalCred	:= .F.
LOCAL cBlqCred	:= ""
Local nValor := 0

//_cPedido := RetNumPVE()
_cPedido := GETSX8NUM("SC5","C5_NUM")
ConfirmSx8()

//Felipe - 26/08/2011 - Posiciona PBS para busca do tipo do frete na tabela PBS e nao mais na tabela SZR
PBS->(DbSetOrder(1))
PBS->(dbseek(xFilial("PBS")+_cTabPre+SB1->B1_GRUPO))

SZR->(DbSetOrder(1))
SZR->(dbseek(xfilial("SZR")+_cTabPre))

//Felipe - 26/08/2011 - Tipo do frete na tabela PBS e nao mais na tabela SZR
_cTpFre   := PBS->PBS_A_TPFR  //SZR->ZR_A_TPFRE  //Tipo do frete C=CIF F=FOB
_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
_cCondPG  := SZR->ZR_CONDPAG  //Cond.Pagto
_cMenNF   := SZR->ZR_A_MENNF  //Mensagem NF
_cCodTab  := SZR->ZR_CODTAB
/*///Alberto - 17/05/11 - Projeto SPED PIS/COFINS
_cFlagPC := GetMv("CE_FLAGPC")
If _cFlagPC =="S"
	_cTESPauta:= SZR->ZR_A_TES1
Else
	_cTESPauta:= SZR->ZR_A_TES
	//_cTESPauta:= SZR->ZR_A_TESPIA // Alex Borges Chamado 292175
Endif
_cTESAliq:=  SZR->ZR_A_TES
//_cTESAliq:=  SZR->ZR_A_TESPIA // Alex Borges Chamado 292175 */ //Alex Borges - 03/08/2016 - 350242

_cFlagPC := GetMv("CE_FLAGPC")
If _cOpTri = 'N'
	_cTESAliq:=  SZR->ZR_TESPIA
Else
	_cTESAliq:=  ZZG->ZZG_TESPIA
EndIf

_nPtxTab := SZR->ZR_PTAX //Felipe Geraldo - 01/10/14 - PTax da tabela de precos utilizada

SA1->(DbSetOrder(1))
SA1->(DbSeek( xFilial("SA1")+_cCliente+_cLoja ))

//Felipe - 01/10/14 - Variaveis para PTAX D-1 e PTAX Medio
_cPTaxD1 := SA1->A1_A_PTXD1
_nPerPtx := SA1->A1_A_PEPTX

aadd(_aCab,{"C5_NUM"       ,_cPedido          ,nil})
aadd(_aCab,{"C5_TIPO"      ,'N'               ,nil})
aadd(_aCab,{"C5_CLIENTE"   ,_cCliente          ,nil})
aadd(_aCab,{"C5_LOJACLI"   ,_cLoja            ,nil})
If !EMPTY(SA1->A1_DEPFECH)
	aadd(_aCab,{"C5_DEPOSITO"   ,SA1->A1_DEPFECH         ,nil})
	aadd(_aCab,{"C5_CRWTIPO"   ,"R"           ,nil})
Else
	aadd(_aCab,{"C5_CRWTIPO"   ,"V"           ,nil})
Endif
aadd(_aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
aadd(_aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
aadd(_aCab,{"C5_CONDPAG"   ,_cCondPg          ,nil})
aadd(_aCab,{"C5_TABELA"    ,_cCodTab    ,nil})
aadd(_aCab,{"C5_TPFRETE"   ,_cTpfre           ,nil})
aadd(_aCab,{"C5_MENNOTA"   ,_cMenNF           ,nil})

_nitem := 0
_nrec := TRBPAH->(Recno())

//Felipe - 01/10/14 - Busca a PTAX da data e valida se nao eh 0
_nUltPtx := U_GETPTAX2(Date())
If _nUltPtx <= 0 .AND. ( _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" )
	Aviso("Não concluído","Taxa do dólar não cadastrado para a data. Entrar em contato com depto financeiro.",{"Ok"})
	Return .F.
EndIf

dbSelectArea("TRBPAH")
While !TRBPAH->(eof())

	if !EMPTY( ALLTRIM(TRBPAH->PAH_A_OK) )
		SB1->(dbSeek(xFilial("SB1")+TRBPAH->PAH_A_PROD) )
		DA1->(dbSeek(xFilial("DA1")+_cCodTab+TRBPAH->PAH_A_PROD) )
		// Alberto - 17/05/11 - Projeto SPED PIS/COFINS
		_cPauta   := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO, "BM_A_PCPTA")

		/*If _cPauta == 'S'
			If _cTESPauta = ' '
				Alert("Campo TES Pauta nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.")
				Return .F.
			Else
				_cTES := _cTESPauta
			Endif
		Else
			If _cTESAliq = ' '
				Alert("Campo TES PIA nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.")
				Return .F.
			Else
				_cTES := _cTESAliq
			Endif
		Endif*/ //Alex Borges - 29/08/16 - Chamado 350242

		If Empty(_cTESAliq)
			Alert("Campo TES PIA nao esta preenchido.Nao podera ser embarcado.Verificar com depto comercial.")
			Return .F.
		Else
			_cTES := _cTESAliq
		Endif


		//Alberto - 25/05/11 - Projeto SPED PIS COFINS. Alteracao no posicionamento da tabela SF4
		SF4->(dbsetorder(1))
		SF4->(dbseek(xfilial("SF4")+_cTES))

		//Felipe - 01/10/14 - Calculos para clientes que utilizam PTAX D-1
		If _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" //Usa PTAX D-1 ou D-1 Medio
			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia
			aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)       ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                  ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                   ,NIL},;
						{"C6_QTDVEN" ,TRBPAH->PAH_A_QTD            ,NIL},;
						{"C6_QTDLIB" ,0                            ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc			           ,NIL},;
						{"C6_VALOR"  ,ROUND(TRBPAH->PAH_A_QTD*_nNewPrc,2),NIL},;
						{"C6_PRUNIT" ,_nNewPrc		              ,NIL},;
						{"C6_TES"    ,_cTes                       ,NIL},;
						{"C6_LOCAL"  ,"01"                        ,NIL},;
						{"C6_LOCALIZ","0008"                      ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                ,NIL}})
		nValor := nValor + ROUND(TRBPAH->PAH_A_QTD*_nNewPrc,2)
		Else
			aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)       ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                  ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                   ,NIL},;
						{"C6_QTDVEN" ,TRBPAH->PAH_A_QTD            ,NIL},;
						{"C6_QTDLIB" ,0                            ,NIL},;
						{"C6_PRCVEN" ,DA1->DA1_PRCVEN              ,NIL},;
						{"C6_VALOR"  ,ROUND(TRBPAH->PAH_A_QTD*DA1->DA1_PRCVEN,2),NIL},;
						{"C6_PRUNIT" ,DA1->DA1_PRCVEN              ,NIL},;
						{"C6_TES"    ,_cTes                        ,NIL},;
						{"C6_LOCAL"  ,"01"                         ,NIL},;
						{"C6_LOCALIZ","0008"                       ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                 ,NIL}})
		nValor := nValor + ROUND(TRBPAH->PAH_A_QTD*DA1->DA1_PRCVEN,2)
		EndIf
	endif
	TRBPAH->(dbskip())
end

dbSelectArea("TRBPAH")
go _nRec

If len(_aItens) > 0
	lMSHelpAuto := .T.
	lMSErroAuto := .F.
	Mata410(_aCab,_aItens,3)
	lMSHelpAuto := .F.
	If lMSErroAuto
		_lGerouPV :=.f.
		MostraErro()
		DisarmTransaction()
		BREAK
	Else
	// Ricardo Lima - 06/03/17
	   IIF( GetAdvFVal("SF4", "F4_DUPLIC", xFilial("SF4") + _cTES, 1, "" ) == "S", lAvalCred := .T., lAvalCred := .F. )
	  If lAvalCred
	   lCredOk := MaAvalCred( _cCliente, _cLoja, nValor, 1 , .T., @cBlqCred )
	    If !lCredOk
		  If cBlqCred == "04"
			Alert("Cliente com Limite de Crédito vencido" + CRLF+CRLF + "Pallets não podem ser embarcados" )
			Alert("Contate Depto Comercial para liberação" )
		  Else
			Alert("Pallets excedem o Limite de Crédito do Cliente" + CRLF+CRLF + "Pallets não podem ser embarcados" )
			Alert("Contate Depto Comercial para liberação" )
		  Endif
		  _lGerouPV := .f.
	    else
	     _lGerouPV := .t.
	    Endif
	  Else
	   _lGerouPV := .t.
	  Endif
	EndIf
Endif

RestArea(_anArea)

Return(_lGerouPV)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPedEmb³ Autor ³ Jose Francisco        ³ Data ³ 15/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de embalagem e verifica se o item do pedido    ³±±
±±³          ³ principal tambem entra na nota de remessa.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ PIA / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerPedEmb(_cPedido)

Local _aCab   := {}
Local _aItens := {}
Local _nItem  := 0
Local _lGerouPEmb := .F.
Local _aArea  := GetArea()
Local _cCliOL := " "
Local _cLjOL := " "
Local _cGrpEmb  // Adriano Guedes  chamado 302901
Local _nQtdCamA := 0  // Adriano Guedes  chamado 302901
Local _nQtdPFol := 0 // Adriano Guedes  chamado 302901
Local _nQtdFol := 0 // Adriano Guedes  chamado 302901

Local nQtdVol := 0  // Ricardo Lima - 01/09/16

_cEol := CHR(13)+CHR(10)

//Alberto - 29/04/11- Identifica o codigo do operador logistico para selecionar a nota de retorno

_cQuery  := "SELECT * FROM " + RetSqlName("SA1") +" SA1 "     + _cEol
_cQuery  += " WHERE A1_FILIAL = '" + xFilial("SA1")     + "'" + _cEol
_cQuery  += " AND   A1_A_OPER    = '" + TRBPAH->PAH_A_OPER + "'" + _cEol
_cQuery  += " AND   SA1.D_E_L_E_T_ = ' '"
memowrite("ALUFAT62CLI.SQL",_cQuery)
_cQuery  := ChangeQuery(_cQuery)
DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSA1", .F., .F. )

DbSelectArea("TRBSA1")
Dbgotop()
If !eof()
	_cCliOL := TRBSA1->A1_COD
	_cLjOL := TRBSA1->A1_LOJA
Endif

//Alberto - 10/05/13- Se for um processo em contingencia gerar o material de embalagem com base nas etiquetas do CB0
//Alberto - 10/10/13- Como a nota em contingencia passou a ser incluida no SF1,SD1 o material de embalagem nao precisa mais ser gerado com base nas etiquetas do CBO
/*/
If TRBPAH->PAH_A_ST ='C'
	_aMatEmb:={}
	_nQtdEmb:=0
	_nPosEmb:=0

	dbselectArea("PAH")
	dbsetorder(3)
	Dbseek(xfilial("PAH")+TRBPAH->PAH_A_PRFT)
	While  !PAH->(eof()) .AND. PAH->PAH_FILIAL+PAH->PAH_A_PRFT = TRBPAH->PAH_FILIAL+TRBPAH->PAH_A_PRFT

			dbselectArea("CB0")
			If Dbseek(xfilial("CB0")+PAH->PAH_A_ETIQ)

				PBZ->(dbSeek(xFilial("PBZ")+CB0->CB0_A_TPEM))
				//Pallet
				nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_PAL})
				If  nPos==0
					AADD(_aMatEmb,{PBZ->PBZ_A_PAL,1,1})
				Else
					_aMatEmb[nPos,2]+=1
					_aMatEmb[nPos,3]+=1
				EndIf

				//Folha
				_cGrupo   := Posicione("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO, "B1_GRUPO")
				_nQtdCam := Posicione("SBM",1,xFilial("SBM")+_cGrupo, "BM_A_QTDCA")  //Calcula qtde de camadas
				If _nQtdCam > 0
					_nQtdCam := Round(_nQtdCam/1000,3)
				Endif
				_nQtdFol:= Int(CB0->CB0_QTDE / _nQtdCam) + 1                               //Calcula qtde de folhas no pallet
				nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_FOL})
				If  nPos==0
					AADD(_aMatEmb,{PBZ->PBZ_A_FOL,_nQtdFol,1})
				Else
					_aMatEmb[nPos,2]+=_nQtdFol
					_aMatEmb[nPos,3]+=1
				EndIf

				//Quadro
				nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_QUA})
				If  nPos==0
					AADD(_aMatEmb,{PBZ->PBZ_A_QUA,1,1})
				Else
					_aMatEmb[nPos,2]+=1
					_aMatEmb[nPos,3]+=1
				EndIf
			Endif
		dbselectArea("PAH")
		PAH->(dbskip())
	Enddo



	_cEol := CHR(13)+CHR(10)



	_cPedidoE := GETSX8NUM("SC5","C5_NUM")
	ConfirmSx8()

	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+_cPedido))
	If UPPER(SC5->C5_CRWTIPO) == "R"
		SC6->(dbSeek(xFilial("SC6")+_cPedido))
	EndIf

	aadd(_aCab,{"C5_NUM"       ,_cPedidoE           ,nil})
	aadd(_aCab,{"C5_TIPO"      ,'N'               ,nil})
	aadd(_aCab,{"C5_CLIENTE"   ,SC5->C5_CLIENTE   ,nil})
	aadd(_aCab,{"C5_LOJACLI"   ,SC5->C5_LOJACLI   ,nil})
	aadd(_aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
	aadd(_aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
	aadd(_aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
	aadd(_aCab,{"C5_DEPOSIT"   ,SC5->C5_DEPOSIT   ,nil})
	aadd(_aCab,{"C5_CONDPAG"   ,SC5->C5_CONDPAG   ,nil})
	aadd(_aCab,{"C5_TABELA"    ,SC5->C5_TABELA    ,nil})
	aadd(_aCab,{"C5_TPFRETE"   ,"F"               ,nil})

	For nX:=1 to Len(_aMatEmb)
		If !empty(_aMatEmb[nx,1])

			//Pallet
			SB1->(dbSeek(xFilial("SB1")+_aMatEmb[nx,1]))
			aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,_aMatEmb[nx,2]    ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                     ,NIL},;
			{"C6_VALOR"  ,_aMatEmb[nx,2]*SB1->B1_PRV1,NIL},;
			{"C6_TES"    ,RetTes()                         ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
			aadd(_aEmbPro,{_aMatEmb[nx,1],_aMatEmb[nx,2]})

		Endif

	Next

	If SELECT("TRBSA1")<>0
		TRBSA1->(dbclosearea())
	EndIf

	If len(_aItens) > 0
		lMSHelpAuto := .T.
		lMSErroAuto := .F.
		Mata410(_aCab,_aItens,3)
		lMSHelpAuto := .F.
		If lMSErroAuto
			_lGerouPEmb :=.f.
			MostraErro()
			DisarmTransaction()
			BREAK
		Else
			_lGerouPEmb :=.t.
		EndIf
	Endif


Else
/*/
	//Alberto - 12/07/11- Aglutinar as qtdes por codigo

// Adriano Guedes chamado 302901

  _cGrpEmb := Posicione("SB1",1,xFilial("SB1")+TRBPAH->PAH_A_PROD, "B1_GRUPO")
  _nQtdCamA := Posicione("SBM",1,xFilial("SBM")+_cGrpEmb, "BM_A_QTDCA")

			If _nQtdCamA > 0
					_nQtdCamA := Round(_nQtdCamA/1000,3)
			Endif


//-----------------------------------------

	_cQuery  := "SELECT D1_COD,SUM(D1_QUANT) AS D1_QUANT FROM " + RetSqlName("SD1") +" SD1 "     + _cEol
	_cQuery  += " WHERE D1_FILIAL = '" + xFilial("SD1")     + "'" + _cEol
	_cQuery  += " AND   D1_DOC    = '" + TRBPAH->PAH_A_NFRT + "'" + _cEol
	_cQuery  += " AND   D1_SERIE  = '" + TRBPAH->PAH_A_SRRT + "'" + _cEol
	_cQuery  += " AND   D1_FORNECE = '" + _cCliOL + "'" + _cEol
	_cQuery  += " AND   D1_LOJA    = '" + _cLjOL + "'" + _cEol
	_cQuery  += " AND   D1_TIPO    = 'B'" + _cEol
	_cQuery  += " AND   D1_TP NOT IN ('PA','PI') " + _cEol
	_cQuery  += " AND   SD1.D_E_L_E_T_ = ' '"
	_cQuery  += " GROUP BY D1_COD"
	memowrite("ALUFAT62EMB.SQL",_cQuery)
	_cQuery  := ChangeQuery(_cQuery)
	DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSD1", .F., .F. )

	DbSelectArea("TRBSD1")
	Dbgotop()

	If !eof()


		_cPedidoE := GETSX8NUM("SC5","C5_NUM")
		ConfirmSx8()

		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xFilial("SC5")+_cPedido))
		If UPPER(SC5->C5_CRWTIPO) == "R"
			SC6->(dbSeek(xFilial("SC6")+_cPedido))
		EndIf

		If _cOpTri = 'S'
			SA1->(DbSetOrder(1))
			SA1->(DbSeek( xFilial("SA1")+_cCliTri+_cLjTri ))

			//Alex Borges - 22/09/2016 - Chamado 350242
			If ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(SC5->C5_TABELA)
				Reclock("SA1",.F.)
				SA1->A1_TABELA := SC5->C5_TABELA
				MsUnlock()
			EndIf
		EndIf

		aadd(_aCab,{"C5_NUM"       ,_cPedidoE           ,nil})
		aadd(_aCab,{"C5_TIPO"      ,'N'               ,nil})
		/*aadd(_aCab,{"C5_CLIENTE"   ,SC5->C5_CLIENTE   ,nil})
		aadd(_aCab,{"C5_LOJACLI"   ,SC5->C5_LOJACLI   ,nil})*/ // Alex Borges - 03/08/2016 - Chamado 350242
		If _cOpTri = 'S' // Alex Borges - 03/08/2016 - Chamado 350242
			aadd(_aCab,{"C5_CLIENTE"   ,_cCliTri           ,nil})
			aadd(_aCab,{"C5_LOJACLI"   ,_cLjTri            ,nil})
		Else
			aadd(_aCab,{"C5_CLIENTE"   ,SC5->C5_CLIENTE   ,nil})
			aadd(_aCab,{"C5_LOJACLI"   ,SC5->C5_LOJACLI   ,nil})
		EndIf
		aadd(_aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
		aadd(_aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
		aadd(_aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
		aadd(_aCab,{"C5_DEPOSIT"   ,SC5->C5_DEPOSIT   ,nil})
		aadd(_aCab,{"C5_CONDPAG"   ,SC5->C5_CONDPAG   ,nil})
		aadd(_aCab,{"C5_TABELA"    ,SC5->C5_TABELA    ,nil})
		//aadd(_aCab,{"C5_TPFRETE"   ,"C"               ,nil})  // Ricardo Lima - 14/08/15 - Alex Borges 14/10/15 Chamado 332976
		aadd(_aCab,{"C5_TPFRETE"   ,SC5->C5_TPFRETE   ,nil})  //Alex Borges - 14/10/15 - Chamado 332976
		aadd(_aCab,{"C5_TRANSP"    ,_cTransp          ,nil})  // Ricardo Lima - 04/09/15

		WHILE !TRBSD1->(eof())
		 // Adriano Guedes   chamado302901
		  _nQtdPFol := Int((((TRBPAH->PAH_A_QTD / TRBPAH->PALLETS)/_nQtdCamA)+1))
		  _nQtdFol  := _nQtdPFol * TRBPAH->PALLETS

		  // Rciardo Lima - 01/09/16
		  nQtdVol := TRBPAH->PALLETS

			//PALLET DE MADEITA
			SB1->(dbSeek(xFilial("SB1")+PADR(TRBSD1->D1_COD,15)))
		If Alltrim(SB1->B1_COD) == '032093006'
			aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,_nQtdFol     ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                     ,NIL},;
			{"C6_VALOR"  ,_nQtdFol *SB1->B1_PRV1,NIL},;
			{"C6_TES"    ,RetTes()                         ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
		Else
		    aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,TRBSD1->D1_QUANT    ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                     ,NIL},;
			{"C6_VALOR"  ,TRBSD1->D1_QUANT*SB1->B1_PRV1,NIL},;
			{"C6_TES"    ,RetTes()                         ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
		Endif
			aadd(_aEmbPro,{TRBSD1->D1_COD,TRBSD1->D1_QUANT})
			TRBSD1->(dbskip())
		//-------------------------------------------------------------------------
		Enddo

		// Rciardo Lima - 01/09/16
		aadd(_aCab,{"C5_VOLUME1" , nQtdVol , nil })

		If SELECT("TRBSD1")<>0
			TRBSD1->(dbclosearea())
		EndIf

		If SELECT("TRBSA1")<>0
			TRBSA1->(dbclosearea())
		EndIf

		If len(_aItens) > 0
			lMSHelpAuto := .T.
			lMSErroAuto := .F.
			Mata410(_aCab,_aItens,3)
			lMSHelpAuto := .F.
			If lMSErroAuto
				_lGerouPEmb :=.f.
				MostraErro()
				DisarmTransaction()
				BREAK
			Else
				_lGerouPEmb :=.t.
			EndIf
		Endif
	Endif
//Endif
RestArea(_aArea)

Return(_lGerouPEmb)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ RetTes   ³ Autor ³ Jose Francisco        ³ Data ³ 15/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Retorno de TES a ser utilizado pelo programa   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ PIA / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetTes()

Local _cTES := ''
Local _aSave := SC6->(GetArea())
Local _cASC5 := SC5->(GetArea())
Local _cCliEmb := .f.

//Felipe - 21/03/13 - Ajuste do dbseek passando xFilial do SA1
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	_cCliEmb := IIf(SA1->A1_A_IMPE = "S",.T.,.F.)
Endif

SC5->(RestArea(_cASC5))

If _cCliEmb
	_cTES := Alltrim(GETMV("CE_TESEMB"))
Elseif UPPER(SC5->C5_CRWTIPO) == "V"
	_cTES := SB1->B1_TS
Else
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+_cPedido))
	_cTES := SC6->C6_TES
	SC6->(RestArea(_aSave))
EndIf

Return(_cTES)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraEntr  ºAutor  ³Luis Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar movimento entrada para gerar saldo para a nf saida   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraEntr(_cxProd,_nxQtd,_cAlmox,_cPRFT)
_lRet:=.t.
_xTmdev := GETMV("MV_X_TMNV")
_cUsuar  := substr(cUsuario,7,15)

aVetor := {}
lMsErroAuto := .F.
_cProxDoc    := U_ProxDoc()
_aVetor:={ {"D3_CF" , "DE6", NIL},;
{"D3_FILIAL"  , xFilial() , NIL},;
{"D3_UM"      , SB1->B1_UM, NIL},;
{"D3_OP"      , ""        , NIL},;
{"D3_LOCAL"   , _cAlmox   , NIL},;
{"D3_COD"     , _cxProd  , NIL},;
{"D3_QUANT"   , _nxQtd   , NIL},;
{"D3_EMISSAO" , ddatabase , NIL},;
{"D3_CUSTO1"  , 0   	  , NIL},;
{"D3_TIPO"    , SB1->B1_TIPO , NIL},;
{"D3_DOC"     , _cProxDoc   , NIL},;
{"D3_ORIGEM"  , "PIA"+_cPRFT , NIL},;
{"D3_USUARIO" , _cUsuar   , NIL},;
{"D3_TM"      , _xTmdev   , NIL},;
{"D3_CHAVE"   , "E0"      , NIL},;
{"D3_CONTA"   , SB1->B1_CONTA, NIL},;
{"AUTEXPLODE" , "S"       , NIL}}

SD3->(DbSetOrder(2))
SD3->(DbSeek(xFilial("SD3")+_cProxDoc))
MSExecAuto({|x,y| Mata240(x,y)},_aVetor,3)
If lMsErroAuto
	_lRet:=.f.

	_cFileLog := ""
	cPath := ""

	AutoGrLog("INICIANDO O LOG")
	AutoGrLog("---------------")
	AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
	AutoGrLog("DATA...............: "+Dtoc(MsDate()))
	AutoGrLog("HORA...............: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
	AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
	AutoGrLog("VERSÃO.............: "+GetVersao())
	AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUÁRIO............: "+cUsername)

	_cFileLog := NomeAutoLog()

	If _cFileLog <> ""
		MostraErro(cPath,_cFileLog)
	Endif
EndIf
IF SB1->B1_LOCALIZ =="S"

	DBSELECTAREA("SDA")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SDA")+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ+SD3->D3_DOC)
		DBSELECTAREA("SBE")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SBE")+SDA->DA_LOCAL+"0008")

		cItem := '0001'
		aCAB  :={{"DA_PRODUTO",SDA->DA_PRODUTO				, nil},;
		{"DA_LOCAL"  ,SDA->DA_LOCAL 				, nil},;
		{"DA_NUMSEQ" ,SDA->DA_NUMSEQ				, nil},;
		{"DA_DOC"    ,SDA->DA_DOC					, nil}}

		aITENS:={{{"DB_ITEM"   ,cItem   					, nil},;
		{"DB_LOCALIZ",SBE->BE_LOCALIZ            	, nil},;
		{"DB_QUANT"  ,_nxQtd             		, nil},;
		{"DB_DATA"   ,dDataBase     				, nil}}}

		nModuloOld  := nModulo
		nModulo     := 4
		lMSHelpAuto := .T.
		lMSErroAuto := .F.
		SX3->(DbSetOrder(1))
		msExecAuto({|x,y,z|mata265(x,y,z)},aCab,aItens,3)
		nModulo := nModuloOld
		lMSHelpAuto := .F.
		If lMsErroAuto
			_lRet:=.f.
			_cFileLog := ""
			cPath := ""

			AutoGrLog("INICIANDO O LOG")
			AutoGrLog("---------------")
			AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
			AutoGrLog("DATA...............: "+Dtoc(MsDate()))
			AutoGrLog("HORA...............: "+Time())
			AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
			AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
			AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
			AutoGrLog("VERSÃO.............: "+GetVersao())
			AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
			AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
			AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
			AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
			AutoGrLog("USUÁRIO............: "+cUsername)

			_cFileLog := NomeAutoLog()

			If _cFileLog <> ""
				MostraErro(cPath,_cFileLog)
			Endif
		EndIf


	ENDIF

ENDIF
Return (_lRet)


Static Function RetEstoq

If MsgYesNo("Deseja realizar o Retorno em Estoque ?" ,"AVISO")
	Processa({|| GeraOP()},"Gerando retorno para o estoque!.")
EndIf

Return

Static Function GeraOP

_aMATA250 := {}
_cDoc     := ' '
lMSErroAuto := .F.

TRBPAH->(dbgotop())

Begin transaction

While !TRBPAH->(eof())

	_cxProd := TRBPAH->PAH_A_PROD
	_nxQtd    := TRBPAH->PAH_A_QTD

	dbselectArea("TRBPAH")
	While  !TRBPAH->(eof()) .and. TRBPAH->PAH_A_PROD=_cxProd

		if _nxQtd>0 .and. TRBPAH->PAH_A_OK <> '  '

			// RICARDO LIMA - 16/03/16
			_numOP := GetSX8Num("SC2","C2_NUM")
			aMata650 :={{"C2_NUM"      ,_numOP           ,NIL},;
				  	 	{"C2_FILIAL"   ,xFilial("SC2")   ,NIL},;
						{"C2_ITEM"     ,"01"             ,NIL},;
						{"C2_SEQUEN"   ,"001"            ,NIL},;
						{"C2_PRODUTO"  ,_cxProd          ,NIL},;
						{"C2_LOCAL"    ,"01"             ,NIL},;
						{"C2_CLINHA"   ,"1"              ,NIL},;
						{"C2_CTURNO"   ,"A"              ,NIL},;
						{"C2_QUANT"    ,_nxQtd           ,NIL},;
						{"C2_UM"       ,"MI"             ,NIL},;
						{"C2_DATPRI"   ,dDataBase        ,NIL},;
						{"C2_DATPRF"   ,dDataBase        ,NIL},;
						{"C2_EMISSAO"  ,dDataBase        ,NIL},;
						{"C2_TPOP"     ,"F"              ,NIL},;
						{"C2_REVISAO"  ,"001"            ,NIL},;
						{"C2_CRWTM"    ,_TMCRWRET        ,NIL}}

			IncProc("Aguarde! Gerando Ordem de Producao...")
			msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)

			If lMSErroAuto

				_cFileLog := ""
				cPath := ""

				AutoGrLog("INICIANDO O LOG")
				AutoGrLog("---------------")
				AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
				AutoGrLog("DATA...............: "+Dtoc(MsDate()))
				AutoGrLog("HORA...............: "+Time())
				AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
				AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
				AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
				AutoGrLog("VERSÃO.............: "+GetVersao())
				AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
				AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
				AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
				AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
				AutoGrLog("USUÁRIO............: "+cUsername)

				_cFileLog := NomeAutoLog()

				If _cFileLog <> ""
					MostraErro(cPath,_cFileLog)
				Endif

				DisarmTransaction()
				return

			Else
				aAreaSC2 := SC2->(GetArea()) //Alex Borges - 13/03/15 - CHAMADO 317443
			   	U_GeraEmpOP(.F.,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)) //Alex Borges  ³15/08/2014³ Chamado 292175 Nao estava gerando empenho
				RestArea(aAreaSC2) //Alex Borges - 13/03/15 - CHAMADO 317443

			    //Alex Borges -25/09/14 - Chamado 305348 Comentado este trecho para nao utilizar estorno de endereçamento.
			    // Pois utilizando o estorno de endereçamento não estava atualizando o saldo nas tabelas SB2 e SBF.

			    _lMesmoMes := .T.

			    _cQuery  := " SELECT D1_NFORI,D1_SERIORI,D1_DTDIGIT,D1_ITEM,D1_COD,D1_UM,D1_QUANT,D1_LOCAL,D1_TP,D1_CUSTO,D1_CUSTO2 "
   				_cQuery  += "   FROM " + RetSqlName("SD1") +" D1, "
        		_cQuery  += "        " + RetSqlName("SA1") +" A1 "
  				_cQuery  += "WHERE D1.D1_FORNECE = A1.A1_COD "
			    _cQuery  += "  AND D1.D1_LOJA    = A1.A1_LOJA "
			    _cQuery  += "  AND D1.D1_FILIAL  = '"+xFilial("SD1")+"' "
			    _cQuery  += "  AND D1.D1_DOC     = '"+TRBPAH->PAH_A_NFRT+"' "
			    _cQuery  += "  AND D1.D1_SERIE   = '"+TRBPAH->PAH_A_SRRT+"' "
			    _cQuery  += "  AND D1.D1_COD     = '"+TRBPAH->PAH_A_PROD+"' "
			    _cQuery  += "  AND A1.A1_FILIAL  = '"+xFilial("SA1")+"' "
			    _cQuery  += "  AND A1.A1_A_OPER  = '"+TRBPAH->PAH_A_OPER+"' "
			    _cQuery  += "  AND D1.D_E_L_E_T_ <> '*' "
			    _cQuery  += "  AND A1.D_E_L_E_T_ <> '*' "

				DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBNF", .F., .F. )

			    DbSelectArea("TRBNF")
				Dbgotop()
				While TRBNF->(!eof())
					// Para cada item da NF de entrada irá efetuar requisição, pois depende da nota fiscal de origem para identificar se a requisição sera valorizada ou nao

					If !Empty(TRBNF->D1_NFORI)
						//Identifica se a NF de origem esta dentro do proprio mes
						_aAreaSF2 := SF2->(GetArea())
						dbSelectArea("SF2")
						dbSetOrder(1)
						If dbSeek( xFilial("SF2") + TRBNF->D1_NFORI + TRBNF->D1_SERIORI )
							If Alltrim(Str(Month(SF2->F2_EMISSAO))) + Alltrim(Str(Year(SF2->F2_EMISSAO))) <> Alltrim(Str(Month(sTod(TRBNF->D1_DTDIGIT)))) + Alltrim(Str(Year(sTod(TRBNF->D1_DTDIGIT))))
								_lMesmoMes := .F.
							EndIf
						Else
							Alert("Nao encontrada a nota fiscal de saida de origem!")
							Return
						EndIf
						RestArea(_aAreaSF2)

						cProxDoc    := U_ProxDoc()
						_cOrig      := XFILIAL("SD3")+TRBNF->D1_NFORI+TRBNF->D1_SERIORI+TRBNF->D1_ITEM

						//Trecho baseado no ponto de entrada SF1100I
						aMovimentos := {}
						aadd (aMovimentos, {"D3_FILIAL"   , XFILIAL("SD3")            ,   Nil})
	   					aadd (aMovimentos, {"D3_CF"       , "RE6"                     ,   Nil})
	   					aadd (aMovimentos, {"D3_UM"       , TRBNF->D1_UM              ,   Nil})
	   					aadd (aMovimentos, {"D3_LOCAL"    , TRBNF->D1_LOCAL           ,   Nil})
	   					aadd (aMovimentos, {"D3_LOCALIZ"  , "0008           "         ,   Nil})
	   					aadd (aMovimentos, {"D3_COD"      , TRBNF->D1_COD             ,   Nil})
	   					aadd (aMovimentos, {"D3_CTURNO"   , "A"             		  ,   Nil})
	   					aadd (aMovimentos, {"D3_DOC"      , cProxDoc              	  ,   Nil})
	   					aadd (aMovimentos, {"D3_QUANT"    , TRBNF->D1_QUANT           ,   Nil})
	   					aadd (aMovimentos, {"D3_TIPO"     , TRBNF->D1_TP              ,   Nil})
	   			   		aadd (aMovimentos, {"D3_USUARIO"  , substr(cUsuario,7,15)     ,   Nil})
						If !_lMesmoMes // Se nao for do mesmo mes gera movimentacao valorizada
							aadd (aMovimentos, {"D3_CUSTO1"   , TRBNF->D1_CUSTO               ,   Nil})
	   				   		aadd (aMovimentos, {"D3_CUSTO2"   , TRBNF->D1_CUSTO2              ,   Nil})
	   						aadd (aMovimentos, {"D3_TM"       , GetNewPar("CE_BXAMZEX","")    ,   Nil})
						Else
							aadd (aMovimentos, {"D3_TM"       , GETMV("MV_X_TMRV")          ,   Nil})
						EndIf
						aadd (aMovimentos, {"D3_CHAVE"    , "E0"                     ,   Nil})
						aadd (aMovimentos, {"D3_ORIGEM"   , _cOrig                   ,   Nil})
	   					//aadd (aMovimentos, {"D3_OP"       , SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)	,   Nil})// Alex Borges 25/09/14 - Chamado 305348
	   					aadd (aMovimentos, {"D3_OP"       , _numOP+"01001"	,   Nil})                    // Alex Borges 13/03/15 - CHAMADO 317443
	   					aadd (aMovimentos, {"AUTEXPLODE"  , "S"                      		,   Nil})

		   				lMsErroAuto := .F.

						MsgRun("Gerando as baixa de estoque da NF de entrada...",,{|| MSExecAuto({|x,y| Mata240(x,y)},aMovimentos,3) })

						If lMsErroAuto
							_cFileLog := ""
							cPath := ""

							AutoGrLog("INICIANDO O LOG")
							AutoGrLog("---------------")
							AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
							AutoGrLog("DATA...............: "+Dtoc(MsDate()))
							AutoGrLog("HORA...............: "+Time())
							AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
							AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
							AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
							AutoGrLog("VERSÃO.............: "+GetVersao())
							AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
							AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
							AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
							AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
							AutoGrLog("USUÁRIO............: "+cUsername)

							_cFileLog := NomeAutoLog()

							If _cFileLog <> ""
								MostraErro(cPath,_cFileLog)
							Endif

							DisarmTransaction()
							return
						EndIf
					Else
						Alert("Nao encontrada a nota fiscal de origem!")
						Return
					EndIf
					TRBNF->(dbSkip())
				EndDo
			    TRBNF->(dbCloseArea())
			    /*
			    // ±±³Alex Borges  ³12/08/2014³ Chamado 292175 - Alterado a ordem da atualização da OP da NF para geracao do RE5.
				If SELECT("TRBSA1CLI") <> 0
	   				TRBSA1CLI->(dbCloseArea())
				EndIf
				_cQuery  := "SELECT * FROM " + RetSqlName("SA1") +" SA1 "
				_cQuery  += " WHERE A1_FILIAL = '" + xFilial("SA1")     + "'"
				_cQuery  += " AND   A1_A_OPER    = '" + TRBPAH->PAH_A_OPER + "'"
				_cQuery  += " AND   SA1.D_E_L_E_T_ = ' '"
				_cQuery  := ChangeQuery(_cQuery)
				DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSA1CLI", .F., .F. )

				DbSelectArea("TRBSA1CLI")
				Dbgotop()
				If !eof()
					_cCliOL := TRBSA1CLI->A1_COD
					_cLjOL := TRBSA1CLI->A1_LOJA
				Endif

				// ±±³Alex Borges  ³18/07/2014³ Chamado 292175 - Alterado a ordem da atualização da OP da NF para geracao do RE5.
				dbSelectArea("SD1")
				DbSetOrder(1)
				If DbSeek(xFilial("SD1")+TRBPAH->PAH_A_NFRT+TRBPAH->PAH_A_SRRT+_cCliOL+_cLjOL+TRBPAH->PAH_A_PROD)
					If Reclock("SD1",.f.)
				  		SD1->D1_OP := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
				   		MsUnlock()
			    	EndIf
				EndIf

			    // Efetua o estorno do endereçamento. Para posteriormente gerar o movimento RE5.
				cItem     := ""
				aITENSEnd := {}
				aITENSEst := {}
				aCAB      := {}
				SDA->(DbSetOrder(2))
				If SDA->(DbSeek(xFilial("SDA")+TRBPAH->PAH_A_NFRT))
					While !SDA->(eof()) .AND. SDA->DA_DOC = TRBPAH->PAH_A_NFRT
						IF SDA->DA_FILIAL = XFILIAL("SDA")  .AND. SDA->DA_PRODUTO = TRBPAH->PAH_A_PROD .AND. SDA->DA_DOC = TRBPAH->PAH_A_NFRT .AND. SDA->DA_SERIE = TRBPAH->PAH_A_SRRT
							aCAB  := {	{"DA_PRODUTO",TRBPAH->PAH_A_PROD 		, nil},;
										{"DA_LOCAL"  ,SDA->DA_LOCAL      , nil},;
						   				{"DA_NUMSEQ" ,SDA->DA_NUMSEQ     , nil},; //relacionado ao campo D1_NUMSEQ
						   				{"DA_DOC"    ,TRBPAH->PAH_A_NFRT , nil}} //Relacionado ao campo F1_DOC ou D1_DOC

							nSaldo := SDA->DA_SALDO
							If nSaldo = 0
							    cItem := CRCITEM(.T.,TRBPAH->PAH_A_PROD,SDA->DA_LOCAL,SDA->DA_NUMSEQ)
								aITENSEst:={{{"DB_ITEM"   ,cItem             , nil},;
											{"DB_LOCALIZ" ,"0008"            , nil},;
											{"DB_DATA"    ,dDataBase         , nil},;
											{"DB_ESTORNO" ,"S"       		 , nil}}}
							EndIf

							cItem := CRCITEM(.F.,TRBPAH->PAH_A_PROD,SDA->DA_LOCAL,SDA->DA_NUMSEQ)
						   	aITENSEnd   :={{{"DB_ITEM"    ,cItem             , nil},;
						   					{"DB_LOCALIZ" ,"0008"            , nil},;
											{"DB_QUANT"   ,SDA->DA_QTDORI    , nil},;
											{"DB_HRINI"   ,Time()            , nil},;
											{"DB_DATA"    ,dDataBase         , nil},;
											{"DB_ESTORNO" ,""                , nil},;
										    {"DB_X_ORI"   ,XFILIAL("SDB")+ TRBPAH->PAH_A_NFRT +TRBPAH->PAH_A_SRRT  , nil}}}

						EndIf
					 	SDA->(DBSkip())
					EndDo

					If Len(aITENSEnd) > 0

						// Se estiver endereçado faz o estorno
						If len(aItensEst) > 0

							lMSErroAuto := .F.
							msExecAuto({|x,y,z|mata265(x,y,z)},aCab,aItensEst,4)// 4=estorno

							If lMsErroAuto
								cFileLog := ""
								cPath    := ""

								AutoGrLog("INICIANDO O LOG")
								AutoGrLog("---------------")
								AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
								AutoGrLog("DATA...............: "+Dtoc(MsDate()))
								AutoGrLog("HORA...............: "+Time())
								AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
								AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
								AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
								AutoGrLog("VERSÃO.............: "+GetVersao())
								AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
								AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
								AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
								AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
								AutoGrLog("USUÁRIO............: "+cUsername)

								cFileLog := NomeAutoLog()

								If cFileLog <> ""
									MostraErro(cPath,cFileLog)
								Endif
								DisarmTransaction()
								return

							EndIf

						EndIf

						// Faz o endereçamento para geração do RE5
						lMSErroAuto := .F.
						msExecAuto({|x,y,z|mata265(x,y,z)},aCab,aITENSEnd,3)// 3=Endereçamento

						If lMsErroAuto
							cFileLog := ""
							cPath    := ""

							AutoGrLog("INICIANDO O LOG")
							AutoGrLog("---------------")
							AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
							AutoGrLog("DATA...............: "+Dtoc(MsDate()))
							AutoGrLog("HORA...............: "+Time())
							AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
							AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
							AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
							AutoGrLog("VERSÃO.............: "+GetVersao())
							AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
							AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
							AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
							AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
							AutoGrLog("USUÁRIO............: "+cUsername)

							cFileLog := NomeAutoLog()

							If cFileLog <> ""
								MostraErro(cPath,cFileLog)
							Endif
							DisarmTransaction()
							return

						EndIf

					EndIf
				Else
					MsgAlert("Não foi possivel encontrar o endereçamento da nota fiscal de retorno "+TRBPAH->PAH_A_NFRT)
				Endif */

				If !lMsErroAuto
					dbSelectArea("PAH")
					DbSetOrder(4)
				   	If DbSeek(xFilial("PAH")+TRBPAH->PAH_A_NFRT+TRBPAH->PAH_A_SRRT)
						While !PAH->(eof()) .AND. PAH->PAH_FILIAL = xFilial("PAH") .AND. PAH->PAH_A_NFRT = TRBPAH->PAH_A_NFRT .AND. PAH->PAH_A_SRRT = TRBPAH->PAH_A_SRRT
							If Reclock("PAH",.F.)
								PAH->PAH_A_ST := "D"
								PAH->PAH_A_OP := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
								MsUnlock()
							EndIf
							PAH->(DbSkip())
						EndDo
					Endif
					/* ±±³Alex Borges  ³18/07/2014³ Chamado 292175
					If SELECT("TRBSA1CLI") <> 0
	   					TRBSA1CLI->(dbCloseArea())
					EndIf
					_cQuery  := "SELECT * FROM " + RetSqlName("SA1") +" SA1 "
					_cQuery  += " WHERE A1_FILIAL = '" + xFilial("SA1")     + "'"
					_cQuery  += " AND   A1_A_OPER    = '" + TRBPAH->PAH_A_OPER + "'"
					_cQuery  += " AND   SA1.D_E_L_E_T_ = ' '"
					_cQuery  := ChangeQuery(_cQuery)
					DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSA1CLI", .F., .F. )

					DbSelectArea("TRBSA1CLI")
					Dbgotop()
					If !eof()
						_cCliOL := TRBSA1CLI->A1_COD
						_cLjOL := TRBSA1CLI->A1_LOJA
					Endif

					DbSelectArea("SD1")
					DbSetOrder(1)
				   	If DbSeek(xFilial("SD1")+TRBPAH->PAH_A_NFRT+TRBPAH->PAH_A_SRRT+_cCliOL+_cLjOL+TRBPAH->PAH_A_PROD)
				   		If Reclock("SD1",.f.)
				    		SD1->D1_OP := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
				     		MsUnlock()
			     		EndIf
					EndIf */

					If Reclock("TRBPAH",.F.)
						TRBPAH->(dbdelete())
					Endif
					MsgInfo("Atencao Gerada a OP "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
				EndIf
			EndIf


		endif

		TRBPAH->(dbskip())
	End
end

End Transaction

TRBPAH->(dbgotop())

Return


Static Function EstRet

_cPerg      :=  "ALUFAT62"
lMSErroAuto := .F.

PutSX1(_cPerg,"01","Serie                ?","","","mv_ch1","C",3,0,0,"G","NaoVazio()",""	,"",,"mv_par01","","","","","","","","","","","","","","","","",)
PutSX1(_cPerg,"02","Nf Retorno           ?","","","mv_ch2","C",9,0,0,"G","NaoVazio()",""	,"",,"mv_par02","","","","","","","","","","","","","","","","",)

If pergunte(_cPerg,.T.)

	If MsgYesNo("Deseja Estornar o Retorno em Estoque ?" ,"AVISO")
		Processa({|| EstornaOP()},"Gerando estorno...")
	EndIf

EndIf
dbSelectArea("TRBPAH")
TRBPAH->(dbgotop())

Return

Static Function EstornaOP

dbSelectArea("PAH")
PAH->(dbgotop())
PAH->(dbSetOrder(4))
If !dbSeek(XFILIAL("PAH")+MV_PAR02+MV_PAR01)
	Alert("Não existe a Nota Fiscal "+alltrim(MV_PAR02)+ ". Favor verificar!")
	Return
Else
	IF PAH->PAH_A_ST = 'D'
		If !Empty(PAH->PAH_A_OP)

				////Alex Borges  ³15/08/2014³ Chamado 292175 implementação das variaveis
				cNumOP    := PAH->PAH_A_OP
				cProduto  := PAH->PAH_A_PROD
				cOper     := PAH->PAH_A_OPER
				cNfRet    := PAH->PAH_A_NFRT
				cSerieRet := PAH->PAH_A_SRRT
				nQtd      := PAH->PAH_A_QTD
				cOper     := TRBPAH->PAH_A_OPER
				cItem     := ""
				aITENSEst := {}
				aCAB      := {}

				//Alex Borges -25/09/14 - Chamado 305348
				// Query para buscar as notas fiscais de origem, para estornar os movimentos internos
				_cQuery  := " SELECT D1_FILIAL,D1_NFORI,D1_SERIORI,D1_DTDIGIT,D1_ITEM,D1_COD,D1_UM,D1_QUANT,D1_LOCAL,D1_TP,D1_CUSTO,D1_CUSTO2 "
   				_cQuery  += "   FROM " + RetSqlName("SD1") +" D1, "
        		_cQuery  += "        " + RetSqlName("SA1") +" A1 "
  				_cQuery  += "WHERE D1.D1_FORNECE = A1.A1_COD "
			    _cQuery  += "  AND D1.D1_LOJA    = A1.A1_LOJA "
			    _cQuery  += "  AND D1.D1_FILIAL  = '"+xFilial("SD1")+"' "
			    _cQuery  += "  AND D1.D1_DOC     = '"+cNfRet+"' "
			    _cQuery  += "  AND D1.D1_SERIE   = '"+cSerieRet+"' "
			    _cQuery  += "  AND D1.D1_COD     = '"+cProduto+"' "
			    _cQuery  += "  AND A1.A1_FILIAL  = '"+xFilial("SA1")+"' "
			    _cQuery  += "  AND A1.A1_A_OPER  = '"+cOper+"' "
			    _cQuery  += "  AND D1.D_E_L_E_T_ <> '*' "
			    _cQuery  += "  AND A1.D_E_L_E_T_ <> '*' "

				DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBNF", .F., .F. )

			    DbSelectArea("TRBNF")
				Dbgotop()
				While TRBNF->(!eof())
					// Para cada item da NF de entrada irá efetuar o estorno da requisição

					If !Empty(TRBNF->D1_NFORI)

						_cOrig := TRBNF->D1_FILIAL+TRBNF->D1_NFORI+TRBNF->D1_SERIORI+TRBNF->D1_ITEM

						DbSelectArea("SD3")
						SD3->(dbOrderNickName("D3ORIGEM"))
						If DbSeek(xFilial("SD3") + _cOrig)
		                	While !eof() .and. D3_ORIGEM = _cOrig
								If SD3->D3_ESTORNO = "S"
							    	SD3->(dbskip())
							    	Loop
							    Endif

		                        aMovimentos := {}
		                        aadd (aMovimentos, {"D3_FILIAL"   , XFILIAL("SD3")     ,   Nil})
		                        aadd (aMovimentos, {"D3_DOC"      , SD3->D3_DOC        ,   Nil})
		                        aadd (aMovimentos, {"D3_NUMSEQ"   , SD3->D3_NUMSEQ     ,   Nil})
		                        aadd (aMovimentos, {"INDEX"       , 8                  ,   Nil})

		                        lMsErroAuto := .F.

								MsgRun("Estornando movimento de estoque",,{|| MSExecAuto({|x,y| Mata240(x,y)},aMovimentos,5) })

								If lMsErroAuto
									_cFileLog := ""
									cPath := ""

									AutoGrLog("INICIANDO O LOG")
									AutoGrLog("---------------")
									AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
									AutoGrLog("DATA...............: "+Dtoc(MsDate()))
									AutoGrLog("HORA...............: "+Time())
									AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
									AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
									AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
									AutoGrLog("VERSÃO.............: "+GetVersao())
									AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
									AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
									AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
									AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
									AutoGrLog("USUÁRIO............: "+cUsername)

									_cFileLog := NomeAutoLog()

									If _cFileLog <> ""
										MostraErro(cPath,_cFileLog)
									Endif

									DisarmTransaction()
									return
								EndIf
								SD3->(Dbskip())
						   Enddo
						Endif
					Else
						Alert("Nao encontrada a nota fiscal de origem!")
						Return
					EndIf
					TRBNF->(dbSkip())
				EndDo
			    TRBNF->(dbCloseArea())


				/* //Alex Borges -25/09/14 - Chamado 305348  -
				dbSelectArea("SDA")
				SDA->(dbgotop())
				SDA->(DbSetOrder(2))
				If SDA->(DbSeek(xFilial("SDA")+cNfRet))
					While !SDA->(eof()) .AND. SDA->DA_DOC = cNfRet
						IF SDA->DA_FILIAL = XFILIAL("SDA")  .AND. SDA->DA_PRODUTO = cProduto .AND. SDA->DA_DOC = cNfRet .AND. SDA->DA_SERIE = cSerieRet
							aCAB  := {	{"DA_PRODUTO",cProduto    	      , nil},;
										{"DA_LOCAL"  ,SDA->DA_LOCAL       , nil},;
						   				{"DA_NUMSEQ" ,SDA->DA_NUMSEQ      , nil},;
						   				{"DA_DOC"    ,cNfRet              , nil}}

							nSaldo := SDA->DA_SALDO
							If nSaldo = 0
							    cItem := CRCITEM(.T.,cProduto,SDA->DA_LOCAL,SDA->DA_NUMSEQ)
								aITENSEst:={{{"DB_ITEM"   ,cItem             , nil},;
											{"DB_LOCALIZ" ,"0008"            , nil},;
											{"DB_DATA"    ,dDataBase         , nil},;
											{"DB_ESTORNO" ,"S"       		 , nil}}}
							Else
								If nSaldo < SDA->DA_QTDORI
									cItem := CRCITEM(.T.,cProduto,SDA->DA_LOCAL,SDA->DA_NUMSEQ)
									aITENSEst:={{{"DB_ITEM"   ,cItem                 , nil},;
												{"DB_LOCALIZ" ,"0008"                , nil},;
												{"DB_DATA"    ,dDataBase             , nil},;
												{"DB_QUANT"   ,SDA->DA_QTDORI-nSaldo , nil},;
												{"DB_ESTORNO" ,"S"       		     , nil}}}
								EndIf
							EndIf

						EndIf
					 	SDA->(DBSkip())
					EndDo

					// Se estiver endereçado faz o estorno
					If len(aItensEst) > 0

						lMSErroAuto := .F.
						msExecAuto({|x,y,z|mata265(x,y,z)},aCab,aItensEst,4)// 4=estorno

						If lMsErroAuto
							cFileLog := ""
							cPath    := ""

							AutoGrLog("INICIANDO O LOG")
							AutoGrLog("---------------")
							AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
							AutoGrLog("DATA...............: "+Dtoc(MsDate()))
							AutoGrLog("HORA...............: "+Time())
							AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
							AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
							AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
							AutoGrLog("VERSÃO.............: "+GetVersao())
							AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
							AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
							AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
							AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
							AutoGrLog("USUÁRIO............: "+cUsername)

							cFileLog := NomeAutoLog()

							If cFileLog <> ""
								MostraErro(cPath,cFileLog)
							Endif
							DisarmTransaction()
							return
					    EndIf
				    EndIf
				EndIf */

				// Exclui a OP
				dbSelectArea("SC2")
				If DbSeek(xFilial("SC2")+cNumOP)
					If SC2->C2_QUJE <> 0
						Alert("Nao sera possivel estornar a Nota Fiscal "+alltrim(MV_PAR02)+", pois foi apontado producao para a OP "+cNumOP+".")
						Return
					Else
                        Begin Transaction

						// Estornando a OP
						aMata650 :={{"C2_NUM"      ,SUBSTR(cNumOP,1,6)         ,NIL},;
							  	 	{"C2_FILIAL"   ,xFilial("SC2")             ,NIL},;
									{"C2_ITEM"     ,"01"                       ,NIL},;
									{"C2_SEQUEN"   ,"001"                      ,NIL},;
									{"C2_PRODUTO"  ,cProduto                   ,NIL}}

						IncProc("Aguarde! Excluindo Ordem de Producao...")
						msExecAuto({|x,Y| Mata650(x,Y)},aMata650,5)

						If lMSErroAuto

							_cFileLog := ""
							cPath := ""

							AutoGrLog("INICIANDO O LOG")
							AutoGrLog("---------------")
							AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
							AutoGrLog("DATA...............: "+Dtoc(MsDate()))
							AutoGrLog("HORA...............: "+Time())
							AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
							AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
							AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
							AutoGrLog("VERSÃO.............: "+GetVersao())
							AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
							AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
							AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
							AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
							AutoGrLog("USUÁRIO............: "+cUsername)

							_cFileLog := NomeAutoLog()

							If _cFileLog <> ""
								MostraErro(cPath,_cFileLog)
							Endif

							DisarmTransaction()
							return

						Else
							/* //Alex Borges -25/09/14 - Chamado 305348
							If SELECT("TRBSA1CLI") <> 0
			   					TRBSA1CLI->(dbCloseArea())
							EndIf
							_cQuery  := "SELECT * FROM " + RetSqlName("SA1") +" SA1 "
							_cQuery  += " WHERE A1_FILIAL = '" + xFilial("SA1")     + "'"
							_cQuery  += " AND   A1_A_OPER    = '" + cOPer + "'"
							_cQuery  += " AND   SA1.D_E_L_E_T_ = ' '"
							_cQuery  := ChangeQuery(_cQuery)
							DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSA1CLI", .F., .F. )

							DbSelectArea("TRBSA1CLI")
							Dbgotop()
							If !eof()
								_cCliOL := TRBSA1CLI->A1_COD
								_cLjOL := TRBSA1CLI->A1_LOJA
							Endif

							DbSelectArea("SD1")
							DbSetOrder(1)
						   	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
						   	If DbSeek(xFilial("SD1")+cNfRet+cSerieRet+_cCliOL+_cLjOL+cProduto)
						   		If Reclock("SD1",.f.)
						    		SD1->D1_OP := ""
						     		MsUnlock()
					     		EndIf
							EndIf*/

						    /*nTam := TAMSX3("BF_LOCALIZ")[1] - LEN(GETMV("MV_LOCASUC"))
						    DbSelectArea("SBF")
							DbSetOrder(1)
						   	If DbSeek(xFilial("SBF")+GETMV("MV_ALMOSUC")+GETMV("MV_LOCASUC")+replicate(" ",nTam)+PAH->PAH_A_PROD)
						   		If Reclock("SBF",.f.)
						    		dbdelete()
						     		MsUnlock()
					     		EndIf
							EndIf*/
						    //Alex Borges  ³15/08/2014³ Chamado 292175
						    While !PAH->(eof()) .AND. PAH->PAH_FILIAL = xFilial("PAH") .AND. PAH->PAH_A_NFRT = cNfRet .AND. PAH->PAH_A_SRRT = cSerieRet
								If Reclock("PAH",.F.)
									PAH->PAH_A_ST := "L"
							   		PAH->PAH_A_OP := ""
									MsUnlock()
								EndIf
								PAH->(DbSkip())
							EndDo

							MsgInfo("Estorno realizado com sucesso!")

						EndIf

						End Transaction

					EndIf
				Else
					Alert("Não existe a OP da Nota Fiscal "+alltrim(MV_PAR02)+". Favor entrar em contato com o administrador do sistema.")
				EndIf
		Else
			Alert("Não foi possivel identificar a OP da Nota Fiscal "+alltrim(MV_PAR02)+". Favor entrar em contato com o administrador do sistema.")
		EndIf
	Else
		Alert("O status da Nota Fiscal "+alltrim(MV_PAR02)+" não esta como 'D-DEVOLUCAO'. Favor verificar!")
	EndIf
EndIf

Return


//Funcao auxiliar para retorno do item:
Static Function CRCITEM(lEstorno,cProduto,cAlmox,cNumSeq)

Local cItem     := "0001"
Local cChavPesq := ""

lEstorno := If (lEstorno == nil,.F.,lEstorno)
cChavPesq := xFilial("SDB")+cProduto+cAlmox+cNumSeq

SDB->(dbSetOrder(1))
SDB->(dbSeek(cChavPesq))
While SDB->(!EOF() .and. cChavPesq == SDB->DB_FILIAL+SDB->DB_PRODUTO+SDB->DB_LOCAL+SDB->DB_NUMSEQ)
	If lEstorno .AND. Empty(SDB->DB_ESTORNO)
		If SDB->DB_ORIGEM = 'SD1' //Alex Borges  ³15/08/2014³ Chamado 292175
			cItem := SDB->DB_ITEM
			Exit
		EndIf
	EndIf
	cItem := StrZero(Val(SDB->DB_ITEM)+1,4)
	SDB->(dbSkip())
End

Return cItem

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³VldCliTri ³ Autor ³ Alberto               ³ Data ³ 05/12/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Efetuar a Validacao do cliente operacao        ³±±
±±³          ³ triangular.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCliTri(_cCliente,_cLoja,_cProd1)

If Empty(_cCliente)
	Alert("Cliente nao pode ser branco","Aviso",.t.,3000)
	Return .F.
EndIf

SA1->(dbsetOrder(1))
If empty(_cLoja)
	If ! SA1->(DbSeek(xFilial("SA1")+_cCliente))
		Alert("Cliente nao cadastrado","Aviso",.t.,3000)
		Return .F.
	Else
		_cLoja := SA1->A1_LOJA
	EndIf
Else
	If ! SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))
		Alert("Cliente nao cadastrado","Aviso",.t.,3000)
		Return .F.
	Else
		If ( _cPTaxSA1 <> SA1->A1_A_PTXD1 ) .OR. ( _nPerTSA1 <> SA1->A1_A_PEPTX ) //Verifica se o campo esta igual nos 2 clientes
			Alert("Campo PTax D-1 divergente entre os clientes da op. triangular!","Aviso",.t.,3000)
			Return .F.
		EndIf
	Endif
Endif

_cEol := CHR(13)+CHR(10)

//Localiza a tabela de preco valida para o cliente
If _cLoja <> ' ' .or. _cProd1<>NIL //.and. !empty(_cProduto)  //Luiz Cesar -29/03/10- Projeto lata importada. Inclusao do codigo de produto
	_cQuery  := "SELECT ZR_CODTAB,ZR_DATADE,ZR_DATAATE,ZR_CONDPAG,ZR_CLIENTE,ZR_LOJACLI,ZR_STATUS,ZR_A_TPFRE,ZR_A_TES,ZR_A_TES1,ZR_A_MENNF,ZR_A_FRETE,ZR_PTAX,ZR_A_TES2 FROM " + RetSqlName("SZR") +" SZR, "+RetSqlName("DA0")+" DA0, "+ RetSqlName("SZS") +" SZS "+ _cEol //Alberto -11/05/11- Projeto SPED PIS/COFINS (Adicionado o campo ZR_A_TES1
	_cQuery  += " WHERE ZR_FILIAL = '" + xFilial("SZR") + "'" + _cEol
    _cQuery  += " AND   ZR_FILIAL = DA0_FILIAL" + _cEol
	_cQuery  += " AND   ZR_CODTAB = DA0_CODTAB" + _cEol
	_cQuery  += " AND   ZR_CODTAB = ZS_CODTAB" + _cEol
	_cQuery  += " AND   ZR_DATADE <= '"   + DToS( dDatabase )+ "' "+ _cEol
	_cQuery  += " AND   ZR_DATAATE >= '"  + DToS( dDatabase )+ "' "+ _cEol

    //Esse campo identifica se o cliente é um deposito on site
    //Nesse caso deve ser utilizada a tabela de preco do cliente identificado nesse campo
	If empty(SA1->A1_A_FATUR)
		_cQuery  += " AND   ZR_CLIENTE = '"+_cCliente+"'" + _cEol
		_cQuery  += " AND   ZR_LOJACLI = '"+_cLoja +"'" + _cEol
    Else
        _cCliDF := substr(SA1->A1_A_FATUR,1,6)
        _cLojaDF := substr(SA1->A1_A_FATUR,7,2)
		_cQuery  += " AND   ZR_CLIENTE = '"+_cCliDF+"'" + _cEol
		_cQuery  += " AND   ZR_LOJACLI = '"+_cLojaDF +"'" + _cEol
    Endif
	_cQuery  += " AND   ZR_STATUS = 'A'" + _cEol
	_cQuery  += " AND   SZR.D_E_L_E_T_ = ' '"
	_cQuery  += " AND   SZS.D_E_L_E_T_ = ' '"
	_cQuery  += " AND   DA0.D_E_L_E_T_ = ' '"
    if _cProd1<>NIL // Luiz Cesar - 29/03/2010 - Importacao de Latas
	   _cQuery  += " AND   ZS_CODPRO = '"+_cProd1+"'" + _cEol
	endif

	memowrite("CRC010tri.SQL",_cQuery)

	_cQuery  := ChangeQuery(_cQuery)

	DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSZR", .F., .F. )
	TcSetField("TRBSZR","ZR_DATADE"   ,"D",08,0)
	TcSetField("TRBSZR","ZR_DATAATE"  ,"D",08,0)

	DbSelectArea("TRBSZR")
	Dbgotop()
	If eof()
		Alert("Nao existe tabela de preco criada para o cliente "+_cCliente+" ref operacao triangular.Entrar em contato com depto comercial.","Aviso",.t.,3000)
		DbCloseArea()
		Return .F.
	Else
        If empty(TRBSZR->ZR_CONDPAG)
			Alert("Condicao de pagto nao esta cadastrada corretamente na tabela de preco do cliente "+_cCliente+" ref operacao triangular.Entrar em contato com depto comercial.","Aviso",.t.,3000)
			DbCloseArea()
			Return .F.
        Endif
        If empty(TRBSZR->ZR_A_TES)
			Alert("TES nao esta cadastrado corretamente na tabela de preco do cliente "+_cCliente+" ref operacao triangular.Entrar em contato com depto comercial.","Aviso",.t.,3000)
			DbCloseArea()
			Return .F.
        Endif

		_cCpTri := TRBSZR->ZR_CONDPAG  //Cond.Pagto
		_cMenNFTri  := TRBSZR->ZR_A_MENNF   //Mensagem NF
		_cTabTri := TRBSZR->ZR_CODTAB
		_nValFrete := TRBSZR->ZR_A_FRETE  * TRBSZR->ZR_PTAX //Felipe Geraldo - 25/04/12 - Tratamento para PIS/COFINS Isento

		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))


		IF ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(TRBSZR->ZR_CODTAB)
			Reclock("SA1",.F.)
			SA1->A1_TABELA := TRBSZR->ZR_CODTAB
			MsUnlock()
		ENDIF

		DbSelectArea("TRBSZR")
		DbCloseArea()

		Return .t.
	Endif
Endif


Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPedTri³ Autor ³ Luiz Cesar            ³ Data ³ 05/12/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de venda automatico operacao triangular        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerPedTri(_cCliente,_cLoja,_cTabPre)

Local _aCab     := {}
Local _aItens   := {}
Local _nItem    := 0
Local _lGerouPV := .F.
Local _anArea := GetArea()

//Felipe - 01/10/14 - Variaveis para PTAX D-1 e PTAX Medio
Local _nPtxTab := 0  //PTAX da tabela de precos utilizada
Local _cPtaxD1 := "" //Flag se usa PTAX D-1 Sim, Nao ou Medio
Local _nPerPtx := 0  //Percentual da PTAX da tabela de preco que PTAX D-1 eh Medio
Local _nUltPtx := 0  //PTAX a ser utilizado
Local _nNewPrc := 0  //Novo Preco em reais
Local _nPrcUGrp := 0 //Preco em dolar sem impostos
Local _nPrcRGrp := 0 //Preco em reais sem impostos

_cPedTri := GETSX8NUM("SC5","C5_NUM")
ConfirmSx8()

//Felipe - 26/08/2011 - Posiciona PBS para busca do tipo do frete na tabela PBS e nao mais na tabela SZR
PBS->(DbSetOrder(1))
PBS->(dbseek(xFilial("PBS")+_cTabPre+SB1->B1_GRUPO))

SZR->(DbSetOrder(1))
SZR->(dbseek(xfilial("SZR")+_cTabPre))

//Felipe - 26/08/2011 - Tipo do frete na tabela PBS e nao mais na tabela SZR
_cFreteTri := PBS->PBS_A_TPFR //Tipo do frete C=CIF F=FOB
_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
_cCondPG  := SZR->ZR_CONDPAG  //Cond.Pagto
_cMenNF   := SZR->ZR_A_MENNF  //Mensagem NF
_cCodTab  := SZR->ZR_CODTAB
//Alberto - 17/05/11 - Projeto SPED PIS/COFINS
_cFlagPC := GetMv("CE_FLAGPC")
/*If _cFlagPC =="S"
	_cTESPauta:= SZR->ZR_A_TES1
Else
	_cTESPauta:= SZR->ZR_A_TES
	//_cTESPauta:= SZR->ZR_A_TESPIA // Alex Borges Chamado 292175
Endif
_cTESAliq:=  SZR->ZR_A_TES
//_cTESAliq:=  SZR->ZR_A_TESPIA // Alex Borges Chamado 292175*/ //Alex Borges - 03/08/2016 - Chamado 350242

// Ricardo Lima - 21/03/17
_cTESPauta:= ZZG->ZZG_A_TES4
_cTESAliq:=  ZZG->ZZG_A_TES4

_nPtxTab := SZR->ZR_PTAX //Felipe Geraldo - 01/10/14 - PTax da tabela de precos utilizada

SA1->(DbSetOrder(1))
SA1->(DbSeek( xFilial("SA1")+_cCliente+_cLoja ))

//Felipe - 01/10/14 - Variaveis para PTAX D-1 e PTAX Medio
_cPTaxD1 := SA1->A1_A_PTXD1
_nPerPtx := SA1->A1_A_PEPTX

_cNomeTri:= ALLTRIM(SA1->A1_NOME)
_cEndTri := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
_cCNPJTri:= SA1->A1_CGC
_cIETri := ALLTRIM(SA1->A1_INSCR)

aadd(_aCab,{"C5_NUM"       ,_cPedTri          ,nil})
aadd(_aCab,{"C5_TIPO"      ,'N'               ,nil})
aadd(_aCab,{"C5_CLIENTE"   ,_cCliTri          ,nil})
aadd(_aCab,{"C5_LOJACLI"   ,_cLjTri           ,nil})
If !EMPTY(SA1->A1_DEPFECH)
	aadd(_aCab,{"C5_DEPOSITO"   ,SA1->A1_DEPFECH   ,nil})
	aadd(_aCab,{"C5_CRWTIPO"   ,"R"                ,nil})
Else
	aadd(_aCab,{"C5_CRWTIPO"   ,"V"           ,nil})
Endif
aadd(_aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
aadd(_aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
//aadd(_aCab,{"C5_CONDPAG"   ,_cCpTri         ,nil}) //Alex Borges - 03/08/2016 - Chamado 350242
aadd(_aCab,{"C5_CONDPAG"   ,_cCondPG          ,nil})
//aadd(_aCab,{"C5_TABELA"    ,_cTabTri        ,nil}) //Alex Borges - 03/08/2016 - Chamado 350242
aadd(_aCab,{"C5_TABELA"    ,_cCodTab          ,nil})
aadd(_aCab,{"C5_TPFRETE"   ,_cFreteTri        ,nil})
//aadd(_aCab,{"C5_MENNOTA"   ,_cMenNF         ,nil})

_nitem := 0
//_nrec := TRBPAH->(Recno())

//Felipe - 01/10/14 - Busca a PTAX da data e valida se nao eh 0
_nUltPtx := U_GETPTAX2(Date())
If _nUltPtx <= 0 .AND. ( _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" )
	Aviso("Não concluído","Taxa do dólar não cadastrado para a data. Entrar em contato com depto financeiro.",{"Ok"})
	Return .F.
EndIf

dbSelectArea("TRBPAH")
While !TRBPAH->(eof())

	if !EMPTY( ALLTRIM(TRBPAH->PAH_A_OK) )
		_nrec := TRBPAH->(Recno())
		SB1->(dbSeek(xFilial("SB1")+TRBPAH->PAH_A_PROD) )
		DA1->(dbSeek(xFilial("DA1")+_cCodTab+TRBPAH->PAH_A_PROD) )
		// Alberto - 17/05/11 - Projeto SPED PIS/COFINS
		_cPauta   := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO, "BM_A_PCPTA")

		/*If _cPauta == 'S'
			If _cTESPauta = ' '
				Alert("Campo TES Pauta nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.")
				Return .F.
			Else
				_cTES := _cTesPaTri
			Endif
		Else
			If _cTESAliq = ' '
				Alert("Campo TES Aliquota nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.")
				Return .F.
			Else
				_cTES := _cTesAlTri
			Endif
		Endif*/ //Alex Borges - 03/08/2016 - Chamado 350242
		If _cPauta == 'S'
			If _cTESPauta = ' '
				//Alert("Campo TES Pauta nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.") // Alex Borges - 03/08/2016 - Chamado 350242
				Alert("Campo TES Pauta nao esta preenchido. Verificar cadastro clientes adicionais com depto comercial.")
				Return .F.
			Else
				_cTES := _cTESPauta
			Endif
		Else
			If _cTESAliq = ' '
				//Alert("Campo TES Aliquota nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.") // Alex Borges - 03/08/2016 - Chamado 350242
				Alert("Campo TES Aliquota nao esta preenchido. Verificar cadastro clientes adicionais com depto comercial.")
				Return .F.
			Else
				_cTES := _cTESAliq
			Endif
		Endif

		SF4->(dbsetorder(1))
		If SF4->(dbSeek(xFilial("SF4")+_cTES))
			If SF4->F4_A_OPTRI <> 'S'
				Alert("No cadastro da TES " + _cTES + " o campo 'OP. Triangular' nao esta parametrizado para operação triangular.")
				Return .F.
			Else
				If Empty(SF4->F4_A_TESRP)
					Alert("No cadastro da TES " + _cTES + " o campo 'TES Tri PIA' nao esta cadastrado a TES de remessa.","Aviso")
					Return .F.
				Else
					_cTES := SF4->F4_A_TESRP
				EndIf
			EndIf
		EndIf

		/*//Alberto - 25/05/11 - Projeto SPED PIS COFINS. Alteracao no posicionamento da tabela SF4
		SF4->(dbsetorder(1))
		SF4->(dbseek(xfilial("SF4")+_cTES))*/ // Alex Borges - 03/08/2016 - Chamado 350242

		//Felipe - 01/10/14 - Calculos para clientes que utilizam PTAX D-1
		If _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" //Usa PTAX D-1 ou D-1 Medio
			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia
			aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)       ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                  ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                   ,NIL},;
						{"C6_QTDVEN" ,TRBPAH->PAH_A_QTD            ,NIL},;
						{"C6_QTDLIB" ,0                            ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc			           ,NIL},;
						{"C6_VALOR"  ,ROUND(TRBPAH->PAH_A_QTD*_nNewPrc,2),NIL},;
						{"C6_PRUNIT" ,_nNewPrc		              ,NIL},;
						{"C6_TES"    ,_cTes                       ,NIL},;
						{"C6_LOCAL"  ,"01"                        ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                ,NIL}})
		Else
			aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)       ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                  ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                   ,NIL},;
						{"C6_QTDVEN" ,TRBPAH->PAH_A_QTD            ,NIL},;
						{"C6_QTDLIB" ,0                            ,NIL},;
						{"C6_PRCVEN" ,DA1->DA1_PRCVEN              ,NIL},;
						{"C6_VALOR"  ,ROUND(TRBPAH->PAH_A_QTD*DA1->DA1_PRCVEN,2),NIL},;
						{"C6_PRUNIT" ,DA1->DA1_PRCVEN              ,NIL},;
						{"C6_TES"    ,_cTes                        ,NIL},;
						{"C6_LOCAL"  ,"01"                         ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                 ,NIL}})
		EndIf
	endif
	TRBPAH->(dbskip())
end

//dbSelectArea("TRBPAH")
//go _nRec

If len(_aItens) > 0
	lMSHelpAuto := .T.
	lMSErroAuto := .F.
	Mata410(_aCab,_aItens,3)
	lMSHelpAuto := .F.
	If lMSErroAuto
		_lGerouPV :=.f.
		MostraErro()
		DisarmTransaction()
		BREAK
	Else
		_lGerouPV :=.t.
	EndIf
Endif

RestArea(_anArea)

dbSelectArea("TRBPAH")
go _nRec

Return(_lGerouPV)
