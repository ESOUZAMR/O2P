#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBTREE.CH"
#include "MSGRAPHI.CH"
#include "SIGAWIN.CH"
#include "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ALUFAT86  ³ Autor ³ Luis Alberto          ³ Data ³ 21/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para geracao de faturamento em emergencia   do    ³±±
±±³          ³ Operador Logistico (Projeto PIA) chamado 264820            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ALUFAT86()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Crown                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado³ Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto     ³27/05/13³ 264820 ³Projeto melhorias PIA. Limitar a qtde   ³±±
±±³            ³        ³        ³maxima de pallets na geracao da nota    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto     ³03/06/13³ 264820 ³Chama programa ALUFAT87 p/enviar email  ³±±
±±³            ³        ³        ³aos usuarios com as etiquetas em        ³±±
±±³            ³        ³        ³emergencia ou contingencia.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto     ³02/10/13³ 280605 ³Criacao de parametro propio para movim. ³±±
±±³            ³        ³        ³do PIA.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe      ³01/10/14³ 306119 ³ Projeto A010/14 - Calcula o preco em   ³±±
±±³Geraldo     ³        ³        ³reais utilizando a valor da PTAX D-1    ³±±
±±³            ³        ³        ³conforme o cliente				  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto³14/10/14³279402  | Projeto A007/13          		      ³±±
±±³            ³        ³        |Alteracao do nome do campo NOT para NOTA³±±
±±³            ³        ³        |evitar conflito de criacao de indice no ³±±
±±³            ³        ³        |ctree                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima³04/09/15³ 326180 ³ Muda pedido de embalagem para frete    ³±±
±±³			   ³		³        ³ CIF, para ser integrado ao GFE.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima³08/12/15³ 336887 ³ VALIDA SE A TABELA DE PRECO ESTA       ³±±
±±³			   ³		³        ³ APROVADA.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe      ³29/12/15³ 338127 ³ Tipo de frete do pedido de embalagem   ³±±
±±³Geraldo     ³        ³        ³deve ser o mesmo do pedido da lata      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe      ³22/02/16³ 303631 ³ PROJETO A002/14 - UNIFICACAO CADASTRO  ³±±
±±³Geraldo     ³        ³        ³ Ajuste de dbseek apos compartilhamento ³±±
±±³            ³        ³        ³do cadastro de clientes, fornecedores e ³±±
±±³            ³        ³        ³transportadoras					      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe      ³23/02/16³ 303631 ³ PROJETO A002/14 - UNIFICACAO CADASTRO  ³±±
±±³Geraldo     ³        ³        ³ Busca dados no ZZG e nao mais no SA1   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges ³29/06/16³ 348149 ³ Correção para geração de Faturamento   ³±±
±±³            ³        ³        ³ emergencial                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges ³02/08/16³ 350242 ³ Projeto A025/15. Implementacao nova    ³±±
±±³			   ³		³        ³ operação triangular. Atendimento tbm   ³±±
±±³			   ³        ³        ³ ao chamado 345324 TES PIA              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA³01/09/16³ 354705 ³ inclui a quantidade de pallet no       ³±±
±±³            ³        ³        ³ pedido para ingressar na nota fiscal   ³±±
±±³            ³        ³        ³ como unitizador que sera usado no GFE  ³±±
±±³            ³        ³        ³ para calculo de frete por pallet.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA³21/03/17³ 362908 ³Retira Validacao do Campo ZZG_A_TES5.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA³04/09/17³ 369903 ³ Atualiza Saldo de Estoque no O2P por   ³±±
±±³            ³        ³        ³ Conexao ao WS                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ALUFAT86()

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
Private _aCores := {{'PAH_A_OK = "  "', 'BR_VERDE' }}

Private _nMarcadas := 0

Private _cCodArm := space(8)

Private _cCliente := CriaVar("A1_COD",.F.)
Private _aEmbPro  := {}
Private _cPedidoE  := CriaVar("C5_NUM",.F.)
Private _cLoja    := CriaVar("A1_LOJA",.F.)
Private _cPedido  := CriaVar("C5_NUM",.F.)
Private _cTransp  := CriaVar("A4_COD",.F.)
Private _cPlaca   := CriaVar("F2_A_PLACA",.F.)
Private _cUf      := CriaVar("F2_A_UFP",.F.)

Private _cOpLog := CriaVar("PAG_A_COD",.F.)
Private _cProd  := CriaVar("B1_COD",.F.)
Private _cCliTri   := CriaVar("A1_COD",.F.)
Private _cLjTri    := CriaVar("A1_LOJA",.F.)

//Alex Borges - 02/08/16 - Chamado 350242
//Implementação da Operacao Triangular
Private _cCpTri    := " "  // Condicao pagamento operacao triangular
Private _cFreteTri := " "  //Tipo frete operacao triangular
Private _cTesAlTri := " "  //Tes Aliquota operacao triangular
Private _cTesPaTri := " "  //Tes Pauta operacao triangular
Private _cTesIsTri := " "  //Tes Pis Cofins isento operacao triangular
Private _cTesTri   := " "  //Tes operacao triangular
Private _cPauta    := " "
Private _cTabTri   := " "  //Codigo tabela cliente operacao triangular
Private _cNotaTri  := " "  //Nota  operacao triangular
Private _cNomeTri  := " "
Private _cEndTri   := " "
Private _cCNPJTri  := " "
Private _cIETri    := " "
Private _cNomeCli  := " "
Private _cEndCli   := " "
Private _cCNPJCli  := " "
Private _cIECli    := " "
private _cPedTri   := Space(6) //Pedido operacao tringular
private _cPtaxD1   := ""
private _lNota     :=.t.
Private _cOpTri    := "N"

// Cria Arquivo de Trabalho
_cxCodArm := " "

if !InfParam()
	Return
endif

define msDialog _oDlg title 'Faturamento Deposito Externo (PIA)-Emergencia' from 00,00 to 480,980 pixel

// Criacao da tabela de Trabalho para mostrar os processos gerados
lQuery := .T.

_aCampos2 := {}
_cQuery := " SELECT PAH_A_OK,PAH_A_ETIQ,PAH_A_OPER,PAH_A_DTRT,PAH_A_NFRT,PAH_A_SRRT,PAH_A_PROD,PAH_A_ARM,PAH_A_QTD,PAH_A_PRFT "
_cQuery += "  FROM "+RETSQLNAME('PAH')
_cQuery += "  WHERE PAH_FILIAL='"+xFilial("PAH")+"' "
_cQuery += "   AND PAH_A_OPER ='"+_cOpLog  +"' "
_cQuery += "   AND PAH_A_PROD ='"+_cProd   +"' "
_cQuery += "   AND PAH_A_ST IN('E')"
_cQuery += "   AND PAH_A_PRFT =' '"
_cQuery += "   AND D_E_L_E_T_<>'*' "
_cQuery += "  ORDER BY PAH_A_OK,PAH_A_ETIQ "
memowrite("TAB1PAH.SQL",_cQuery)

If ( Select ( "TRBPAH" ) <> 0 )
	dbSelectArea ("TRBPAH")
	dbCloseArea()
Endif

_aStru := PAH->(dbstruct())
_cArqTrab := Criatrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrab,"TRBPAH",.T.,.F.)
Processa({||SqlToTrb(_cQuery, _aStru, "TRBPAH")}) // Cria arquivo temporario

TRBPAH->(dbgotop())

_aCpo := {"PAH_A_OK","PAH_A_ETIQ","PAH_A_OPER","PAH_A_ARM","PAH_A_DTRT","PAH_A_NFRT","PAH_A_PROD","PAH_A_QTD","PAH_A_SRRT"}

For _ni:=1 to Len(_aCpo)
	SX3->(dbsetorder(2))
	IF SX3->(dbseek(_aCpo[_ni]))
		aadd(_aCampos2,{SX3->X3_CAMPO,,SX3->X3_TITULO,SX3->X3_PICTURE,""}) // Formatacao Browse
	endif
next

TRBPAH->(DbGotop())
_oMark:=MsSelect():New("TRBPAH","PAH_A_OK","",_aCampos2,_lInverte,@_cMarca,{010, 005, 240, 490},,,,,_aCores)  //Alberto - 04/04/11 - Alteracao do tamanho da tela para possibilitar a rolagem de tela
_oMark:bMark:= {|| FECHMark(_cMarca)}
_oMark:oBrowse:bAllMark := {||RdMarkAll("TRBPAH", _oMark, _cMarca,"PAH_A_OK")}
_oMark:oBrowse:lhasMark = .T.
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
±±ºPrograma  ³VldTela   ºAutor  ³Luis Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a tela toda na Transferencia de FECHueta            º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function VldTela()
local _lRet := .T.

If  _nItens<=0
	MsgStop("Não há itens marcados!!","ATENÇÃO!!!")
	_lRet:=.f.
EndIf

//Alberto-
If  _nItens >25
	MsgStop("Excedeu 25 pallets por nota. Foram selecionados " +  alltrim(str(_nItens))+" pallets","ATENÇÃO!!!")
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
±±ºPrograma  ³FECHMark  ºAutor  ³Luiz Albert         º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca ou desmarca as FECHuetas de selecao                  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ºPrograma  ³DigArmazemºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Digitacao de armazen                                       º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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

@ 012,010 SAY    'CLIENTE         '   OF _oDlgARM PIXEL SIZE 120 ,9
@ 027,010 SAY    'LOJA            '   OF _oDlgARM PIXEL SIZE 120 ,9
@ 042,010 SAY    'TRANSPORTADORA  '   OF _oDlgARM PIXEL SIZE 120 ,9
@ 057,010 SAY    'PLACA'              OF _oDlgARM PIXEL SIZE 120 ,9
@ 072,010 SAY    'ESTADO'             OF _oDlgARM PIXEL SIZE 120 ,9
@ 087,010 SAY    'CLIENTE TRIANGULAR' OF _oDlgARM PIXEL SIZE 120 ,9
@ 102,010 SAY    'LOJA TRIANGULAR'    OF _oDlgARM PIXEL SIZE 120 ,9

@ 012,130 MSGET _cCliente Valid VldCli(_cCliente,_cLoja,1)    Picture '@!' F3 "SA1" SIZE 040,09 PIXEL OF _oDlgARM
@ 027,130 MSGET _cLoja    Valid VldCli(_cCliente,_cLoja,2)    Picture '@!'          SIZE 040,02 PIXEL OF _oDlgARM
@ 042,130 MSGET _cTransp  Valid VldTransp(_cTransp)         Picture '@!' F3 "SA4" SIZE 040,09 PIXEL OF _oDlgARM
@ 057,130 MSGET _cPlaca   Valid Eval({|| _cPlaca:=upper(_cPlaca),VldPla(_cPlaca)}) Picture "@! AAA9999" SIZE 040,09 PIXEL OF _oDlgARM
@ 072,130 MSGET _cUF      Valid ExistCpo("SX5","12"+_cUF) Picture "@!" F3 "12" SIZE 040,09 PIXEL OF _oDlgARM  //Alberto - 05/03/11 - Inclusao validacao do estado
@ 087,130 MSGET _cCliTri Valid VldCli(_cCliTri,_cLjTri,1)    Picture '@!' F3 "SA1" WHEN IIF(_cOpTri='S',.T.,.f.) SIZE 040,09 PIXEL OF _oDlgARM //Alex Borges - 05/08/2016 - Chamado 350242
@ 102,130 MSGET _cLjTri  Valid VldCli(_cCliTri,_cLjTri,2)    Picture '@!'          WHEN IIF(_cOpTri='S',.T.,.f.) SIZE 040,02 PIXEL OF _oDlgARM //Alex Borges - 05/08/2016 - Chamado 350242

//@ 092,080 BUTTON _oBotaoOk   prompt "Ok"      size 40,11 font _oDlgARM:oFont ACTION Eval(_bValid)   of _oDlgARM PIXEL //Alex Borges - 05/08/2016 - Chamado 350242
//@ 092,128 BUTTON _oBotaoSair prompt "Cancela" size 40,11 font _oDlgARM:oFont ACTION Close(_oDlgARM) of _oDlgARM PIXEL //Alex Borges - 05/08/2016 - Chamado 350242
@ 120,080 BUTTON _oBotaoOk   prompt "Ok"      size 40,11 font _oDlgARM:oFont ACTION Eval(_bValid)   of _oDlgARM PIXEL
@ 120,128 BUTTON _oBotaoSair prompt "Cancela" size 40,11 font _oDlgARM:oFont ACTION Close(_oDlgARM) of _oDlgARM PIXEL

ACTIVATE MSDIALOG _oDLGARM Centered ON INIT {||_oDLGARM:End()}

return (_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldCli    ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de Cliente                                       º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldCli(_cCli,_cLoj,_nOpc)

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
±±ºPrograma  ³VldPla    ºAutor  ³Luis Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao da Placa                                         º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldPla(_cPla)

If Empty(_cPla)
	Alert("Informar Placa")
	return .f.
Else // Alex Borges - 05/08/2016 - Chamado 350242
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
±±ºPrograma  ³VldTransp ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao de Transportador                                 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
Else // Alex Borges - 05/08/2016 - Chamado 350242
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
±±ºPrograma  ³PROCPAH   ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta arquivo de trabalho e efetua faturamento             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcPAH()

Local _cCRWDFAT := GetMV("MV_CRWDFAT")
Local _lGeraPedEmb := .T.

_nVol := 0
_nVolNFE := 0

If _cCRWDFAT == "N"
	DDATABASE := Date()
Endif

SA1->(dbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))

//Felipe - 23/02/16 - Chamado 303631 - Posiciona e busca informacoes no cadastro auxiliar do cliente ZZG
dbSelectArea("ZZG")
dbSetOrder(1)
//If dbSeek(xFilial("ZZG") + SA1->A1_COD + SA1->A1_LOJA) .AND. ZZG->ZZG_A_EMB <> "S" //Alex Borges - 29/06/2016 - Chamado 348149
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

_cxProd := TRBPAH->PAH_A_PROD
SB1->(DbSetOrder(1))
SB1->(dbSeek(xFilial("SB1") + TRBPAH->PAH_A_PROD) )
_nxQtd    := 0
_cALMOX   := '01'
_cLOCALIZ := Space(15)
_cPRFT    := space(6)

// CALCULA PROXIMO NUMERO PROCESSO DE FATURAMENTO
If SELECT("TRB1PR")<>0
	TRB1PR->(dbclosearea())
EndIf

_cQuery := "SELECT MAX(PAH_A_PRFT) PAH_A_PRFT FROM " + RetSqlName("PAH")
_cQuery += " WHERE PAH_FILIAL = '" + xFilial("PAH") + "'"
_cQuery += " AND   D_E_L_E_T_ <> '*' "
DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRB1PR", .F., .F. )

TRB1PR->(dbgotop())

_cPRFT := strzero(val(TRB1PR->PAH_A_PRFT)+1,6)
TRB1PR->(dbclosearea())


dbselectArea("TRBPAH")
While  !TRBPAH->(eof()) .and. TRBPAH->PAH_A_PROD=_cxProd

	if TRBPAH->PAH_A_OK <> '  '
		_nxQtd += TRBPAH->PAH_A_QTD
		_nVol  += 1
	Endif
	TRBPAH->(dbskip())
Enddo
// GERA PEDIDO
if _nxQtd>0

	//Gera movimento de entrada no local 01 para haver saldo na geracao da nf saida
	If !GeraEntr(_cxProd,_nxQtd,_cAlmox,_cPRFT)
		Return
	Endif

	if !VldTabel(_cxProd)
		DisarmTransaction() // RICARDO LIMA - 08/12/15
		Return
	endif

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
	IncProc("Gerando Pedido de Venda...")// Alex Borges - 05/08/2016 - Chamado 350242
	if !GerPed(SA1->A1_COD,SA1->A1_LOJA,_cTabPre,_cxProd,_nxQtd)
		alert("Nao foi gerado pedido automatico !!")
		DisarmTransaction()
		Break
		return
	endif

    //Felipe - 23/02/16 - Chamado 303631 - Informacoes vindas do cadastro auxiliar do cliente ZZG
	//If SA1->A1_A_EMBAL == "S"
	//If _lGeraPedEmb // Alex Borges - 04/08/2016 - Chamado 350242
	If _lGeraPedEmb .OR. _cOpTri = "S"
		IncProc("Gerando Material de Embalagem...")// Alex Borges - 03/08/2016 - Chamado 350242
		if ! GerPedEmb(_cPedido) // gera pedido com material de embalagem
			alert("Nao foi gerado pedido de embalagem automatico !!")
			DisarmTransaction()
			Break
			return
		endif

	EndIf

	SC5->(dbsetorder(1))
	SC5->(dbseek(xfilial("SC5")+_cPedido))

	CRIANOT() // CRIA TABELA PARA OS PEDIDOS
endif


// Carrega tabela de preco por produto
_lPrc:=AtuPrc(_cxProd)
If !_lPrc[1]
	DisarmTransaction() // Alex Borges - 03/08/2016 - Chamado 350242
	Return
Endif
AtuCab(Space(2),_cxProd,_cPRFT,_nxQtd*_lPrc[2],_nxQtd)
AtuItem(_cPRFT,Space(6),Space(20),_cxProd,_nxQtd,_cLOCALIZ,_cALMOX,_cPLACA,_lPrc[2])

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

cCliente:= SA1->A1_COD

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

	//Alex Borges - 05/08/2016 - Chamado 350242
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
		dbselectArea("TRBPAH")
        dbgotop()
		IncProc("Gerando Pedido de Venda Triangular...")
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
		_lPrc:=AtuPrc(_cxProd)
		_cALMOX   := '01'
		If !_lPrc[1]
			DisarmTransaction()
			Return
		Endif

		AtuCab(Space(2),_cxProd,_cPRFT,_nxQtd*_lPrc[2],_nxQtd)
		AtuItem(_cPRFT,Space(6),Space(20),_cxProd,_nxQtd,_cLOCALIZ,_cALMOX,_cPLACA,_lPrc[2])

		_nxQtd     := _nxQtd - 1
		_nVol      := _nVol + 1
		_lNota     := .T.
		_cCliente  := SA1->A1_COD
		_cPedTri   := SC5->C5_NUM
		 fTrocaP(_cPRFT,_cPedTri,Space(2),Space(20))
		IncProc("Gerando Nota Fiscal Triangular...")
		_aFatu     := GerFat(_cPedTri,_cPedidoE)
        _cNotaTri  := _aFatu[1]
        _cSerieTri := _aFatu[2]

		Dbselectarea("SF2")
		Dbsetorder(1)
		RecLock('SF2',.f.)
		SF2->F2_A_PLACA  := _cPlaca
		SF2->F2_TRANSP   := _cTransp
		SF2->F2_VOLUME1  := _nVolNFE
		SF2->F2_A_UFP    := _cUf
		SF2->F2_A_DOCTR  := _cNota
		SF2->F2_A_SERTR  := _cSerie
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
			PAH->(dbsetorder(1))
			if PAH->(dbseek(xFilial("PAH")+TRBPAH->PAH_A_ETIQ))

				While !PAH->(EOF()) .AND. PAH->PAH_A_ETIQ = TRBPAH->PAH_A_ETIQ

					If Reclock("PAH",.F.)
						PAH->PAH_A_DTFT  := dDataBase
						PAH->PAH_A_NFFT  := _aFatu[1]
						PAH->PAH_A_SERF  := _aFatu[2]
						PAH->PAH_A_ST    := "M"
						PAH->PAH_A_CONT  := "EME"
						PAH->PAH_A_PRFT  := _cPRFT
						MsUnlock()
							// Ricardo Lima - 04/09/17
							u_ALUFATC8( "S" , PAH->PAH_A_PROD , PAH->PAH_A_NFFT , "" , PAH->PAH_A_QTD )
					else
						_lNota := .F.
					Endif

					// Verifica se atualiza onsite
					IF SF2->F2_A_DEPF = "S"
						_cIdentb6 := ""
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
						//Alterado por Ricardo Lima - 30/11/2010
						PB5->PB5_STATUS	 := "T"
						PB5->PB5_IDENTB  := _cIdentb6
						PB5->PB5_ORIGEM  := "P" //I=Deposito interno da Crown  E=Armazem externo P= PIA
						PB5->(MsUnLock())
					Endif
					_nVolNFE++ // contagem de volume da nota fiscal
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


else
	_lNota := .F.
Endif

End transaction

/*if _lNota .and. !empty(alltrim(_aFATU[1]))
    //Alberto- 03/06/13-Chama o programa ALUFAT87 para enviar email aos usuarios com as etiquetas em emergencia ou contingencia
    U_ALUFAT87()
	alert("Nota - " + _aFatu[1] + " Serie - " + _aFatu[2] + " gerada")
else
	alert("Processo de geracao de nota fiscal nao executado corretamente, favor verificar !!!")
endif */ //Alex Borges - 08/08/2016 - Chamado 350242


If _lNota .and. !empty(alltrim(_cNota))
   If !empty(_cNotaTri)
		MsgInfo("Foram geradas as notas: "+CHR(13)+CHR(10) +_cNota + " e a "+_cNotaTri+" Serie - " + _cSerie )
   Else
		MsgInfo("Foi gerado a Nota Fiscal : "+CHR(13)+CHR(10) +_cNota +" Serie - " + _cSerie )
   Endif
   Processa({|| U_ALUFAT87()},"Enviando email para o Operador Logistico...")
else
	alert("Processo de geracao de nota fiscal nao executado corretamente, favor verificar !!!")
endif

U_fAltdBase(.f.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldTabel ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Tabela                                              º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado³Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldTabel(_cxProd)

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
_cQueryN  += " AND    SubStr(ZR_DATADE,1,6) <= '" + Str(Year(dDatabase),4)+Strzero(Month(dDatabase),2)+ "'"
_cQueryN  += " AND    SubStr(ZR_DATAATE,1,6) >= '" + Str(Year(dDatabase),4)+Strzero(Month(dDatabase),2)+ "'"
_cQueryN  += " AND   ZR_CODTAB = ZS_CODTAB "
_cQueryN  += " AND   ZS_CODPRO = '" + _cxProd + "'"
_cQueryN  += " AND   ZR_STATUS = 'A' "  // RICARDO LIMA - 08/12/15
_cQueryN  += " AND   ZS.D_E_L_E_T_ <> '*' "
DbUseArea( .T., "TopConn", TCGenQry(,,_cQueryN), "TRBNUM", .F., .F. )
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

IF ALLTRIM(SA1->A1_TABELA) <> Alltrim(_cTabPre)
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
±±ºPrograma  ³CriaNOT   ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao de tabela auxiliar                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ºPrograma  ³ATUPRC    ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Tabela de Preco                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ºPrograma  ³TABPRC    ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida e busca dados da tabela de preco                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ºPrograma  ³GERFAT    ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Nota Fiscal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************************************************************
Static Function GerFat(cPedido,_cPedidoE)
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

	If ! Credito(cPedido)
		MostraErro()
		DisarmTransaction()
		Break
		Return .F.
	Endif
Endif

IF Empty(SERIE)
	SERIE := GetMv("CE_SERNFS")
Endif
//Libera(_cpedido,_cPedidoE) // liberando pedido e empenhando //Alex Borges - 08/08/2016 - Chamado 350242
Libera(cPedido,_cPedidoE) // liberando pedido e empenhando
cNota := MaPvlNfs(aPvlNfs,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

RETURN({cNota,SERIE})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Credito   ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Avalia Credito                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
	Return .f.
Endif
Return(lCredito)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Libera    ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Liberacao                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
If !empty(_cPedidoE) //Alex Borges - 03/08/2016 - Chamado 350242
	SC5->(dbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+_cPedidoE))

	For nX := 1 To Len(_aEmbPro)
		//	LibPed(_cPedidoE,_aEmbPro[nx,1],_aEmbPro[nx,2],{})
		aadd(aPvlNfs,Prepara(_cPedidoE,_aEmbPro[nx,1],"01"))
	Next
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPed    ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Libera Pedido no SC6                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                           º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ºPrograma  ³ CarEmpen      ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega Empenho                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Crown                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarEmpen(cProduto)

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
±±ºPrograma  ³ Prepara       ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
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
SC5->(DbSeek(xFilial("SC5")+cNumPed) )
//posiciona item
SC6->(DBSetOrder(2))
SC6->(DbSeek(xFilial()+cProd+cNumPed))
SC6->(DBSetOrder(1))
//posiciona itens liberados
SC9->(DbSetOrder(1))
SC9->(DbSeek(xFilial("SC9")+cNumPed+SC6->C6_ITEM) )
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
SB1->(DbSeek(xFilial("SB1")+cProd ))
SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB2")+cProd+cLocal) )
SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )
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
±±ºPrograma  ³ ProdNOT       ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
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
±±ºPrograma  ³ ValorNOT      ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
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
±±ºPrograma  ³ ATUCAB        ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
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
±±ºPrograma  ³ AtuITEM       ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
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
±±ºPrograma  ³ fTrocaP       ºAutor  ³Luiz Alberto        º Data ³  21/03/13   º±±
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
±±³PROGRAMA: ³ GerPed   ³ Autor ³ Luiz Alberto          ³ Data ³ 21/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de venda automatico                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GerPed(_cCliente,_cLoja,_cTabPre,_cxProd,_nxQtd)

Local _aCab     := {}
Local _aItens   := {}
Local _nItem    := 0
Local _lGerouPV := .F.
Local _anArea := GetArea()

//Felipe - 01/10/14 - Variaveis para PTAX D-1 e PTAX Medio
Local _cPtaxD1  := "" //Flag se usa PTAX D-1 Sim, Nao ou Medio
Local _nPtxTab  := 0  //PTAX da tabela de precos utilizada
Local _nPerPtx  := 0  //Percentual da PTAX da tabela de preco que PTAX D-1 eh Medio
Local _nUltPtx  := 0  //PTAX a ser utilizado
Local _nNewPrc  := 0  //Novo Preco em reais
Local _nPrcUGrp := 0 //Preco em dolar sem impostos
Local _nPrcRGrp := 0 //Preco em reais sem impostos

_cPedido := GETSX8NUM("SC5","C5_NUM")
ConfirmSx8()

//Felipe - 26/08/2011 - Posiciona PBS para busca do tipo do frete na tabela PBS e nao mais na tabela SZR
PBS->(DbSetOrder(1))
PBS->(dbseek(xFilial("PBS")+_cTabPre+SB1->B1_GRUPO))

SZR->(DbSetOrder(1))
SZR->(dbseek(xfilial("SZR")+_cTabPre))

_cTpFre   := PBS->PBS_A_TPFR  //SZR->ZR_A_TPFRE  //Tipo do frete C=CIF F=FOB
_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
_cCondPG  := SZR->ZR_CONDPAG  //Cond.Pagto
_cMenNF   := SZR->ZR_A_MENNF  //Mensagem NF
_cCodTab  := SZR->ZR_CODTAB
/*
_cFlagPC  := GetMv("CE_FLAGPC")
If _cFlagPC =="S"
	_cTESPauta:= SZR->ZR_A_TES1
Else
	_cTESPauta:= SZR->ZR_A_TES
Endif
_cTESAliq:=  SZR->ZR_A_TES
//_cTESAliq:=  SZR->ZR_A_TESPIA // Alex Borges Chamado 292175 */ //Alex Borges - 03/08/2016 - 350242

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
aadd(_aCab,{"C5_TRANSP"    ,_cTransp          ,nil})  // Ricardo Lima - 04/09/15
aadd(_aCab,{"C5_MENNOTA"   ,_cMenNF           ,nil})

_nitem := 0

SB1->(dbSeek(xFilial("SB1")+_cxProd) )
DA1->(dbSeek(xFilial("DA1")+_cCodTab+_cxProd) )
_cPauta := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO, "BM_A_PCPTA")

/*If _cPauta == 'S'
	If _cTESPauta = ' '
		Alert("Campo TES Pauta nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.")
		Return .F.
	Else
		_cTES := _cTESPauta
	Endif
Else
	If _cTESAliq = ' '
				//Alert("Campo TES Aliquota nao esta preenchido.Nao podera ser embarcado.Verificar tabela de preco com depto comercial.") //Alex Borges - 02/08/16 - Chamado 350242
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

//Felipe - 01/10/14 - Busca a PTAX da data e valida se nao eh 0
_nUltPtx := U_GETPTAX2(Date())
If _nUltPtx <= 0 .AND. ( _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" )
	Aviso("Não concluído","Taxa do dólar não cadastrado para a data. Entrar em contato com depto financeiro.",{"Ok"})
	Return .F.
EndIf

SF4->(dbsetorder(1))
SF4->(dbseek(xfilial("SF4")+_cTES))

//Felipe - 01/10/14 - Calculos para clientes que utilizam PTAX D-1
If _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" //Usa PTAX D-1 ou D-1 Medio
	_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia
	aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)       ,NIL},;
				{"C6_PRODUTO",SB1->B1_COD                  ,NIL},;
				{"C6_UM"     ,SB1->B1_UM                   ,NIL},;
				{"C6_QTDVEN" ,_nxQtd            		   ,NIL},;
				{"C6_QTDLIB" ,0                            ,NIL},;
				{"C6_PRCVEN" ,_nNewPrc			           ,NIL},;
				{"C6_VALOR"  ,ROUND(_nxQtd*_nNewPrc,2)    ,NIL},;
				{"C6_PRUNIT" ,_nNewPrc 			           ,NIL},;
				{"C6_TES"    ,_cTes                        ,NIL},;
				{"C6_LOCAL"  ,"01"                         ,NIL},;
				{"C6_LOCALIZ","0008"                       ,NIL},;
				{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
Else // "N" ou Vazio
	aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)      ,NIL},;
				{"C6_PRODUTO",SB1->B1_COD                  ,NIL},;
				{"C6_UM"     ,SB1->B1_UM                   ,NIL},;
				{"C6_QTDVEN" ,_nxQtd            ,NIL},;
				{"C6_QTDLIB" ,0                            ,NIL},;
				{"C6_PRCVEN" ,DA1->DA1_PRCVEN              ,NIL},;
				{"C6_VALOR"  ,ROUND(_nxQtd*DA1->DA1_PRCVEN,2),NIL},;
				{"C6_PRUNIT" ,DA1->DA1_PRCVEN              ,NIL},;
				{"C6_TES"    ,_cTes                        ,NIL},;
				{"C6_LOCAL"  ,"01"                         ,NIL},;
				{"C6_LOCALIZ","0008"                       ,NIL},;
				{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
EndIf

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

Return(_lGerouPV)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPedEmb³ Autor ³ Luis Alberto          ³ Data ³ 21/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de embalagem e verifica se o item do pedido    ³±±
±±³          ³ principal tambem entra na nota de remessa.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ PIA / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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

Local nQtdVol := 0  // Ricardo Lima - 01/09/16

//Identifica o material de embalagem pela etiqueta

_aMatEmb:={}
_nQtdEmb:=0
_nPosEmb:=0

dbselectArea("TRBPAH")
dbgotop()
While  !TRBPAH->(eof())

	if TRBPAH->PAH_A_OK <> '  '
		dbselectArea("CB0")
		If Dbseek(xfilial("CB0")+TRBPAH->PAH_A_ETIQ)

			PBZ->(dbSeek(xFilial("PBZ")+CB0->CB0_A_TPEM))
			//Pallet
			nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_PAL})
			If  nPos==0
				AADD(_aMatEmb,{PBZ->PBZ_A_PAL,1,1})
			Else
				_aMatEmb[nPos,2]+=1
				_aMatEmb[nPos,3]+=1
			EndIf
			nQtdVol += VAL(PBZ->PBZ_A_PAL)  // Ricardo Lima - 01/09/16

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
	Endif
	dbselectArea("TRBPAH")
	TRBPAH->(dbskip())
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
aadd(_aCab,{"C5_TPFRETE"   ,SC5->C5_TPFRETE   ,nil})  //Felipe - 29/12/15 - 338127 - Tipo de frete do pedido de embalagem deve ser o mesmo do pedido da lata
aadd(_aCab,{"C5_TRANSP"    ,_cTransp          ,nil})  // Ricardo Lima - 04/09/15
aadd(_aCab,{"C5_VOLUME1"   ,nQtdVol           ,nil})  // Ricardo Lima - 01/09/16

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

RestArea(_aArea)

Return(_lGerouPEmb)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ RetTes   ³ Autor ³ Luis Alberto          ³ Data ³ 21/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Retorno de TES a ser utilizado pelo programa   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ PIA / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetTes()

Local _cTES := ''
Local _aSave := SC6->(GetArea())
Local _cASC5 := SC5->(GetArea())
Local _cCliEmb := .f.

//Felipe - 22/02/16 - Chamado 303631 - Ajuste do dbseek passando xFilial do SA1
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
±±ºPrograma  ³InfParam  ºAutor  ³Luis Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informacao dos parametros                                  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function InfParam()

Local _oDLGArm
Local _oArm
Local _oBotaoOK
Local _oBotaoSair
Local _lok := .f.
Local _bOK := {|| _lok:= .t. , Close(_oDLGARM) ,.t.}
Local _bNOK := {|| _lok:= .f.,Alert("Preencher Dados") , .f.}

Local _bValid := {|| if (VldOpe(_cOpLog) .and. VldProd(_cProd),Eval(_bOk),Eval(_bNOk)) }

DEFINE MSDIALOG _oDLGARM FROM 50, 10 TO 68, 57 TITLE OemToAnsi("Infome os dados para faturamento em Contingencia")

@ 012,010 SAY    'Operador Logistico' OF _oDlgARM PIXEL SIZE 120 ,9
@ 027,010 SAY    'Produto           ' OF _oDlgARM PIXEL SIZE 120 ,9

@ 012,100 MSGET _cOpLog   Valid VldOpe(_cOpLog)             Picture '@!' F3 "PAG" SIZE 040,09 PIXEL OF _oDlgARM
@ 027,100 MSGET _cProd    Valid VldProd(_cProd)             Picture '@!' F3 "SB1" SIZE 070,02 PIXEL OF _oDlgARM

@ 092,080 BUTTON _oBotaoOk   prompt "Ok"      size 40,11 font _oDlgARM:oFont ACTION Eval(_bValid)   of _oDlgARM PIXEL
@ 092,128 BUTTON _oBotaoSair prompt "Cancela" size 40,11 font _oDlgARM:oFont ACTION Close(_oDlgARM) of _oDlgARM PIXEL

ACTIVATE MSDIALOG _oDLGARM Centered ON INIT {||_oDLGARM:End()}

return (_lOk)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldOpe    ºAutor  ³Luis Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do operador logistico                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldOpe(_cOpLog)

If Empty(_cOpLog)
	Alert("Informar Operador Logistico ")
	return .f.
EndIf
PAG->(dbSetOrder(1))
If ! PAG->(DbSeek(xFilial("PAG")+_cOpLog))
	Alert("Operador Logistico nao existe.")
	Return .F.
EndIf
Return .t.
/*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldProd   ºAutor  ³Luis Alberto        º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao do produto                                       º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado por³ Data   ³ Chamado|Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³        ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldProd(_cProd)
If Empty(_cProd)
	Alert("Informar produto")
	Return .F.
EndIf
SB1->(dbsetOrder(1))
If !SB1->(DbSeek(xFilial()+_cProd))
	Alert("Produto nao cadastrado")
	Return .F.
EndIf
Return .t.


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
//_xTmdev := GETMV("MV_X_TMNV")
_xTmdev := GETMV("CE_TMPIAEN")  //Alberto - 02/10/13- Novo parametro com tm para movimentacao do PIA
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPedTri³ Autor ³ Alex Borges           ³ Data ³ 05/08/16 ³±±
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

Local _nPtxTab := 0  //PTAX da tabela de precos utilizada
Local _cPtaxD1 := "" //Flag se usa PTAX D-1 Sim, Nao ou Medio
Local _nPerPtx := 0  //Percentual da PTAX da tabela de preco que PTAX D-1 eh Medio
Local _nUltPtx := 0  //PTAX a ser utilizado
Local _nNewPrc := 0  //Novo Preco em reais
Local _nPrcUGrp := 0 //Preco em dolar sem impostos
Local _nPrcRGrp := 0 //Preco em reais sem impostos

_cPedTri := GETSX8NUM("SC5","C5_NUM")
ConfirmSx8()

PBS->(DbSetOrder(1))
PBS->(dbseek(xFilial("PBS")+_cTabPre+SB1->B1_GRUPO))

SZR->(DbSetOrder(1))
SZR->(dbseek(xfilial("SZR")+_cTabPre))

_cFreteTri := PBS->PBS_A_TPFR //Tipo do frete C=CIF F=FOB
_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
_cCondPG  := SZR->ZR_CONDPAG  //Cond.Pagto
_cMenNF   := SZR->ZR_A_MENNF  //Mensagem NF
_cCodTab  := SZR->ZR_CODTAB
_cFlagPC := GetMv("CE_FLAGPC")

// Ricardo Lima - 21/03/17
_cTESPauta:= ZZG->ZZG_A_TES4
_cTESAliq:=  ZZG->ZZG_A_TES4

_nPtxTab := SZR->ZR_PTAX

SA1->(DbSetOrder(1))
SA1->(DbSeek( xFilial("SA1")+_cCliente+_cLoja ))

//Alex Borges - 22/09/2016 - Chamado 350242
If ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(_cCodTab)
	Reclock("SA1",.F.)
	SA1->A1_TABELA := _cCodTab
	MsUnlock()
EndIf

_cPTaxD1 := SA1->A1_A_PTXD1
_nPerPtx := SA1->A1_A_PEPTX

_cNomeTri := ALLTRIM(SA1->A1_NOME)
_cEndTri  := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
_cCNPJTri := SA1->A1_CGC
_cIETri   := ALLTRIM(SA1->A1_INSCR)

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
aadd(_aCab,{"C5_CONDPAG"   ,_cCondPG          ,nil})
aadd(_aCab,{"C5_TABELA"    ,_cCodTab          ,nil})
aadd(_aCab,{"C5_TPFRETE"   ,_cFreteTri        ,nil})


DA1->(dbSeek(xFilial("DA1")+_cCodTab+SB1->B1_COD) )
_cPauta   := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO, "BM_A_PCPTA")

If _cPauta == 'S'
	If _cTESPauta = ' '
		Alert("Campo TES Pauta nao esta preenchido. Verificar cadastro clientes adicionais com depto comercial.")
		Return .F.
	Else
		_cTES := _cTESPauta
	Endif
Else
	If _cTESAliq = ' '
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

//Posiciona a nova TES
SF4->(dbsetorder(1))
SF4->(dbSeek(xFilial("SF4")+_cTES))

//Calculos para clientes que utilizam PTAX D-1
If _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" //Usa PTAX D-1 ou D-1 Medio
	_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia
	aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)           ,NIL},;
				{"C6_PRODUTO",SB1->B1_COD                     ,NIL},;
				{"C6_UM"     ,SB1->B1_UM                      ,NIL},;
				{"C6_QTDVEN" ,_nxQtd            		      ,NIL},;
				{"C6_QTDLIB" ,0                               ,NIL},;
				{"C6_PRCVEN" ,_nNewPrc			              ,NIL},;
				{"C6_VALOR"  ,ROUND(_nxQtd*_nNewPrc,2)        ,NIL},;
				{"C6_PRUNIT" ,_nNewPrc 			              ,NIL},;
				{"C6_TES"    ,_cTes                           ,NIL},;
				{"C6_LOCAL"  ,"01"                            ,NIL},;
				{"C6_DESCRI" ,SB1->B1_DESC                    ,NIL}})
Else // "N" ou Vazio
	aadd(_aItens,{{"C6_ITEM"   ,strzero(++_nItem,2)           ,NIL},;
				{"C6_PRODUTO",SB1->B1_COD                     ,NIL},;
				{"C6_UM"     ,SB1->B1_UM                      ,NIL},;
				{"C6_QTDVEN" ,_nxQtd                          ,NIL},;
				{"C6_QTDLIB" ,0                               ,NIL},;
				{"C6_PRCVEN" ,DA1->DA1_PRCVEN                 ,NIL},;
				{"C6_VALOR"  ,ROUND(_nxQtd*DA1->DA1_PRCVEN,2) ,NIL},;
				{"C6_PRUNIT" ,DA1->DA1_PRCVEN                 ,NIL},;
				{"C6_TES"    ,_cTes                           ,NIL},;
				{"C6_LOCAL"  ,"01"                            ,NIL},;
				{"C6_DESCRI" ,SB1->B1_DESC                    ,NIL}})
EndIf

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

Return(_lGerouPV)

