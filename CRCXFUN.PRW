#include "apvt100.ch"

#DEFINE POSPRODUTO  1
#DEFINE POSQTD      2
#DEFINE POSNOTA     4
#DEFINE POSSERIE    5
#DEFINE POSFORNECE  6
#DEFINE POSLOJA     7
#DEFINE POSLOCALI   9
#DEFINE POSLOCAL   10
#DEFINE POSOP      11
#DEFINE POSNUMSEQ  12
#DEFINE PROG "SUCATA"
#DEFINE REQ "Requisicao Pecas"
#DEFINE DEV "Devolucao Pecas"
#DEFINE TBREQ "Requisicao TB"

Static _cTurnoTB :=' '

Static cProg
Static aAponta := {}   // Array com todos os apontamentos gerados na DISTRIBUICAO
Static lExcCB0 := .T.
Static cMaqMovInt := Space(6)
Static _nOs  := 0
Static _cOs  := space(6) //Alberto 17/08/11- Projeto integracao estoque x man.ativo
Static cCracha := Space(6)
Static cTurno :=' '
Static _aApEtiq := {}   // Alberto -31/05/11-Projeto controle material embalagem. Array com todos os apontamentos gerados na DISTRIBUICAO utilizado para a movimentacao do mat.embalagem.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³CRCDistr  ³AUTOR: ³                       ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao que executa a distribuicao ou estorno               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alberto       ³30/08/13³Chamado 278756-Projeto HFI por lote.          ³±±
±±³               ³        ³Tratamento para nao chamar a funcao VTSAVE()  ³±±
±±³               ³        ³e VTRESTORE pois o programa ALUEST32-HFI por  ³±±
±±³               ³        ³lote esta sendo acionado pelo modulo estoque e³±±
±±³               ³        ³nao pelo ACD.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alex Borges   ³12/02/14³Chamado 315227 - Alteracao da função ACD060CF ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alex Borges   ³11/08/15³Chamado 328540 - Projeto A016/15. Permitir    ³±±
±±³               ³        ³retorno de HFI para fracionados.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alex Borges   ³16/10/15³Chamado 332825. O material de embalagem passa ³±±
±±³               ³        ³a ser pelo cadastro de produto.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alex Borges   ³04/11/15³Chamado 332825. Validar material de embalagem ³±±
±±³               ³        ³somente para lata.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Ricardo Lima  ³05/01/17³Chamado 354508. Inclui solicitante na movimen-³±±
±±³               ³        ³tacao pelo coletor                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Ricardo Lima  ³24/04/17³Ch: 361991. Inclui Validacao do solicitante   ³±±
±±³               ³        ³cadastrado, nao deixa continuar se informar   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Ricardo Lima  ³04/09/17³Ch:369903, Atualiza Estoque com Transferencia ³±±
±±³               ³        ³ de etiqueta para HFI.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRCDistr(cLocal,cLocaliz,cEti,lEstorno)

Local cItem    := ""
Local nX       := 0
Local aCab     := {}
Local aItens   := {}
Local aSave    := IIF(alltrim(Funname())="ALUEST32", GETAREA(),VTSAVE()) //Alberto - 30/08/13-Chamado 276756-Projeto HFI por lote

lEstorno := If (lEstorno == nil,.F.,lEstorno)

dbSelectArea("SD3")
dbSetOrder(4)

If !Empty(aEtiqueta[POSNUMSEQ]) .and. dbSeek(xFilial("SD3")+aEtiqueta[POSNUMSEQ])

	lMSErroAuto := .F.

	cItem := CRCITEM(lEstorno,cLocal)

	aCAB  :={{"DA_PRODUTO",aEtiqueta[POSPRODUTO]  , nil},;
	{"DA_LOCAL"  ,cLocal                 , nil},;
	{"DA_NUMSEQ" ,SD3->D3_NUMSEQ         , nil},; //relacionado ao campo D1_NUMSEQ
	{"DA_DOC"    ,SD3->D3_DOC            , nil}} //Relacionado ao campo F1_DOC ou D1_DOC

	aITENS:={{{"DB_ITEM"   ,cItem             , nil},;
	{"DB_LOCALIZ",cLocaliz          , nil},;
	{"DB_QUANT"  ,aEtiqueta[POSQTD] , nil},;
	{"DB_DATA"   ,U_RetData()       , nil}}}

	If lEstorno
		aadd(aItens[1],{"DB_ESTORNO"   ,"S"      , nil})
	EndIf

	//esta variavel deverah ser retirada mais tarde
	nModuloOld  := nModulo
	nModulo     := 4
	lMSHelpAuto := .T.
	msExecAuto({|x,y,z|mata265(x,y,z)},aCab,aItens,If (lEstorno,4,3))// 4=estorno 3=distribuicao
	nModulo := nModuloOld
	lMSHelpAuto := .F.

	//Grava novos dados na etiqueta
	If !lMSErroAuto
		If lEstorno
			cLocaliz :=""
		EndIf

		CBGrvEti("01",{NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,cLocaliz,cLocal},cEti)
		aEtiqueta := CBRetEti(cEti,"01")
	EndIf

EndIf

//Alberto - 30/08/13-Chamado 276756-Projeto HFI por lote
If alltrim(Funname())="ALUEST32"
	RestArea(aSave)
Else
	VtRestore(,,,,aSave)
Endif

Return !lMSErroAuto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ CRCITEM  ³AUTOR: ³                       ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao Auxiliar da User Function CRCDistr                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRCITEM(lEstorno,cAlmox)

Local cItem     := "0001"
Local cChavPesq := ""

lEstorno := If (lEstorno == nil,.F.,lEstorno)
cChavPesq := xFilial("SDB")+aEtiqueta[POSPRODUTO]+cAlmox+aEtiqueta[POSNUMSEQ]

SDB->(dbSetOrder(1))
SDB->(dbSeek(cChavPesq))
While SDB->(!EOF() .and. cChavPesq == SDB->DB_FILIAL+SDB->DB_PRODUTO+SDB->DB_LOCAL+SDB->DB_NUMSEQ)
	If lEstorno .and. StrZero(SDB->DB_QUANT,15,4) == StrZero(aEtiqueta[POSQTD],15,4) .AND. Empty(SDB->DB_ESTORNO)
		cItem := SDB->DB_ITEM
		Exit
	EndIf
	cItem := StrZero(Val(SDB->DB_ITEM)+1,4)
	SDB->(dbSkip())
End

Return cItem


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ CRCTra   ³AUTOR: ³                       ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao que executa Transferencia                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRCTra(aEtiqueta,cAlmoxOrig,cLocalOrig,cAlmoxDest,cLocalDest,cProdDest,cEti)

Local lRet    := .T.
Local aTransf := {}
Local cDoc
Local nH := u_SemD3Lock()
Local cProdOri
Local cDescOri
Local cUMOri
Local cDescDest
Local cUMDest
cLocalOrig := padr(cLocalOrig,15)
cLocalDest := padr(cLocalDest,15)
// LayÄout para transferencia
// 1,1 -  documento
// 1,2 -  data da emissao
// 2,1 -  produto de origem
// 2,2 -  descricao
// 2,3 -  unidade de medida
// 2,4 -  local
// 2,5 -  localizacao origem
// 2,6 -  produto destino
// 2,7 -  descricao
// 2,8 -  unidade de medida
// 2,9 -  local
// 2,10- localizacao destino
// 2,11- numero de serie
// 2,12- lote
// 2,13- sublote
// 2,14- data de validade
// 2,15- quantidade
// 2,16- quantidade na 2 unidade
// 2,17- estorno
// 2,18- numero de sequencia

lMsErroAuto := .F.
lMsHelpAuto := .T.
cDoc := u_ProxDoc()

SB1->(dbSeek(xFilial("SB1")+aEtiqueta[POSPRODUTO]))
cProdOri := SB1->B1_COD
cDescOri := SB1->B1_DESC
cUMOri   := SB1->B1_UM

If cProdDest # nil
	SB1->(dbSeek(xFilial("SB1")+cProdDest))
	cProdDest := SB1->B1_COD
	cDescDest := SB1->B1_DESC
	cUMDest   := SB1->B1_UM
Else
	cProdDest := cProdOri
	cDescDest := cDescOri
	cUMDest   := cUMOri
EndIf

aTransf:=Array(2)
aTransf[1] := { cDoc,U_RetData()}
aTransf[2] := {	cProdOri,;
cDescOri,;
cUMOri,;
cAlmoxOrig,;
cLocalOrig,;
cProdDest,;
cDescDest,;
cUMDest,;
cAlmoxDest,;
cLocalDest,;
criavar('D3_NUMSERI'),;
criavar('D3_LOTECTL'),;//lote
criavar('D3_NUMLOTE'),;//sublote
U_RetData(),;
criavar("D3_POTENCI"),;//potencia do lote
aEtiqueta[POSQTD],;
criavar("D3_QTSEGUM"),;//Qtde2.Un.Medida
criavar("D3_ESTORNO"),;//Estorno?
criavar("D3_NUMSEQ"),;
criavar('D3_LOTECTL'),;//lote
criavar('D3_DTVALID'),;
criavar('D3_ITEMGRD')}

MSExecAuto({|x| MATA261(x)},aTransf)
lMsHelpAuto := .F.

If !lMsErroAuto
	CBGrvEti("01",{NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,cLocalDest,cAlmoxDest},cEti)
	// Ricardo Lima - 04/09/17
	u_ALUFATC8( "H" , cProdOri , "" , "" , aEtiqueta[POSQTD] )
EndIf

u_SemD3UnLock(nH)

Return !lMsErroAuto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ CRCGrPA1 ³AUTOR: ³                       ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Grava em arquivo de retrabalho - PA1                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRCGrPA1(cOP,aEtiq,cTipo)

Local  nX := 0

cTipo := If (cTipo == NIL,"S",cTipo)

For nX := 1 to Len(aEtiq)
	RecLock('PA1',.T.)
	PA1->PA1_FILIAL := xFilial('PA1')
	PA1->PA1_OP     := cOP
	PA1->PA1_CODETI := aEtiq[nX]
	PA1->PA1_TIPO   := cTipo
	PA1->(msUnLock())
Next

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ CRCGrPA2 ³AUTOR: ³                       ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Grava em arquivo de retrabalho - PA2                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRCGrPA2(cTipo)

Local lRet := .T.

If cTipo == "ENTRADAHFI"
	RecLock('PA2',.T.)
	PA2->PA2_FILIAL := xFilial('PA2')
	PA2->PA2_CODETI := M->PA2_CODETI
	PA2->PA2_CODMOT := M->PA2_CODMOT
	PA2->PA2_OBS    := M->PA2_OBS
	PA2->PA2_DTENT  := U_RetData()
	PA2->PA2_HRENT  := U_RETTIME()
	PA2->(MsUnLock())
ElseIf cTipo == "SAIDAHFI"
	PA2->(dbSetOrder(1))
	If PA2->(dbSeek(xFilial("PA2")+M->PA2_CODETI))

		While PA2->(!Eof() .and. PA2_FILIAL+PA2_CODETI ==xFilial("PA2")+M->PA2_CODETI)
			PA2->(DbSkip())
		EndDo

		PA2->(DbSkip(-1))
		RecLock('PA2',.F.)
		PA2->PA2_DTSAI := U_RetData()
		PA2->PA2_HRSAI := U_RETTIME()
		PA2->PA2_DESSAI:= M->PA2_DESSAI
		PA2->(MsUnLock())

	Else

		lRet := .F.

	EndIF
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ CRCArea  ³AUTOR: ³                       ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Verif. se esta em area permitida p/processo a ser executado³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³               ³        ³                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alex Borges   ³10/06/15³Projeto A003/15. Chamado 324218. Implementação³±±
±±³               ³        ³da localização de pallets fracionados         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CRCArea(cEnv,cEtiqueta)

Local lRet := .T.

dbSelectArea('SB1')
cbRetEti(cEtiqueta,'01')

IF cEnv == 'SUCATA'
	If CB0->CB0_CCAREA == "S"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet ja foi transferido para sucata.","AVISO",.T.,3500)
	ElseIf CB0->CB0_CCAREA == "R"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet nao pode ser transferido pois esta em retrabalho.","AVISO",.T.,5000)
	ElseIf Empty(CB0->CB0_CCAREA)
		lRet := .F.
		VTBEEP(2)
		VTALERT("O pallet deve estar no HFI antes de ser enviado para sucata.","AVISO",.T.,7000)
	EndIf
ElseIf cEnv == 'RETRABALHO'
	If CB0->CB0_CCAREA == "R"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet ja foi transferido para retrabalho.","AVISO",.T.,4000)
	EndIf

	If alltrim(Funname()) <> "U_CRC050" // Se for retrabalho, nao permite retrabalhar. CRC050=Sucata
		// Alex Borges - 10/06/2015 - Chamado 324218
		//Verifica se o pallet é fracionado, se for nao podera ser retornado ao estoque.
		// Busca a quantidade de latas do produto e do pallet
		nQtdProd := Posicione("SB5",1,xFilial("SB5")+CB0->CB0_CODPRO,"B5_QPA")
		nQtdPall := CB0->CB0_QTDE

		If nQtdProd <> nQtdPall
			lRet := .F.
			VTBEEP(2)
			VTALERT("Nao é possivel fazer retrabalho de pallet Fracionado. Este pallet só poderá ser sucateado. ","AVISO",.T.,5000)
		EndIf
	EndIf
ElseIf cEnv == 'LIBERAHFI'
	If CB0->CB0_CCAREA # "H"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet nao foi transferido para HFI, impossivel libera-lo.","AVISO",.T.,5000)
	EndIf

	// Alex Borges - 10/06/2015 - Chamado 324218
	//lLibFrac := GetNewPar("CE_LIBFRAC",".F.")// Parametro que permite retornar pallet fracionado no almoxarifado 01.
	//Alex Borges - 10/08/15 - Chamado 328540
	If (Alltrim(GetAdvFVal("SB1","B1_A_LFRAC",XFILIAL("SB1")+CB0->CB0_CODPRO,1,"")) = 'S')
		lLibFrac := .T.
	Else
		lLibFrac := .F.
	End

	If !lLibFrac
		//Verifica se o pallet é fracionado, se for nao podera ser retornado ao estoque.
		// Busca a quantidade de latas do produto e do pallet
		nQtdProd := Posicione("SB5",1,xFilial("SB5")+CB0->CB0_CODPRO,"B5_QPA")
		nQtdPall := CB0->CB0_QTDE

		If nQtdProd <> nQtdPall
			lRet := .F.
			VTBEEP(2)
			VTALERT("Nao é possivel fazer retorno de pallet Fracionado. Este pallet só poderá ser sucateado. ","AVISO",.T.,5000)
		EndIf
	EndIf
ElseIf cEnv == 'HFI'
	If CB0->CB0_CCAREA == "R"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet esta em processo de retrabalho, nao podera ser transferido.","AVISO",.T.,6000)
	ElseIf CB0->CB0_CCAREA == "S"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet foi transferido para sucata, nao podera ser transferido.","AVISO",.T.,7000)
	ElseIf CB0->CB0_CCAREA == "H"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet ja esta no HFI.","AVISO",.T.,3000)
	ElseIf !Empty(CB0->CB0_NFSAI)
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet foi ja foi embarcado, nao podera ser transferido.","AVISO",.T.,5000)
	EndIf
ElseIf cEnv == 'DISTRIBUICAO'
	If !Empty(CB0->CB0_CCAREA)
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet nao esta disponivel para distribuicao.","AVISO",.T.,5000)
	EndIF
ElseIf cEnv == 'FRACIONADO' // Alex Borges - 10/06/2015 - Chamado 324218
	If CB0->CB0_CCAREA == "R"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet esta em processo de retrabalho, nao podera ser transferido.","AVISO",.T.,6000)
	ElseIf CB0->CB0_CCAREA == "S"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet foi transferido para sucata, nao podera ser transferido.","AVISO",.T.,7000)
	ElseIf CB0->CB0_CCAREA == "H"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet foi transferido para HFI, nao podera ser transferido","AVISO",.T.,3000)
		ElseIf CB0->CB0_CCAREA == "F"
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet foi transferido para o Almoxarifado de Fracionados, nao podera ser transferido","AVISO",.T.,3000)
	ElseIf !Empty(CB0->CB0_NFSAI)
		lRet := .F.
		VTBEEP(2)
		VTALERT("Pallet foi ja foi embarcado, nao podera ser transferido.","AVISO",.T.,5000)
	EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ SemD3Lock ³AUTOR: ³                      ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao para controle de semaforo no SD3                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe        ³25/08/11³Arquivo de semafaro por empresa e filial      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SemD3Lock()

Local nSem := -1
Local aTela

If IsTelNet()
	aTela:= VTSave()
EndIF

While nSem  < 0
	//	nSem  := MSFCreate("SD3CTRL.SEM")
	//  Felipe - 25/08/2011 - Semaforo por filial
	nSem  := MSFCreate( "SD3CTRL" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL) + ".SEM" )
	IF  nSem  < 0
		SLeep(50)
		If IsTelNet()
			VTMsg('Tentativa de Lock',4)
		EndIf
	Endif
End

If IsTelNet()
	VTRestore(,,,,aTela)
EndIF

Return nSem


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ SemD3UnLock ³AUTOR: ³                    ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao para controle de semaforo no SD3                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe        ³25/08/11³Arquivo de semafaro por empresa e filial      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SemD3UnLock(nSem)

Fclose(nSem)
//FErase("SD3CTRL.SEM")
//Felipe - 25/08/2011 - Semaforo por filial
FErase( "SD3CTRL" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL) + ".SEM" )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ ProxDoc   ³AUTOR: ³                      ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao para retornar o proximo numero de D3_DOC            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe        ³25/08/11³Retirada do while e inclusao de alerta, pois  ³±±
±±³               ³        ³quando chega no documento ZZZZZ o sistema tra-³±±
±±³               ³        ³vava										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe        ³05/06/14³CHAMADO 298418 - Inclusao da funcao A261INV p/³±±
±±³               ³        ³retirar os documentos (D3_DOC) conteudo INVENT³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function ProxDoc()

Local aSvAlias:=GetArea()
Local aSvAliasD3:=GetArea('SD3')
Local cDoc

dbSelectArea("SD3")
dbSetOrder(2)

//Felipe - 25/08/2011 - Controle numeracao D3_DOC

//While .t.
//	cDoc :=  NextNumero("SD3",2,"D3_DOC",.T.)
//	If ! dbSeek(xFilial("SD3")+cDoc)
//		exit
//	EndIf
//End

//Felipe - 05/06/14 - Inclusao da funcao A261RetINV
//cDoc := NextNumero("SD3",2,"D3_DOC",.T.)
cDoc := A261RetINV(NextNumero("SD3",2,"D3_DOC",.T.))
If dbSeek( xFilial("SD3") + cDoc )
	cDoc := "" //Se ja existe um registro com o numero do documento deve abortar o processo
	If IsTelNet()
		VTMsg("Numero de Documento (D3_DOC) ja utilizado. Entre em contato imediatamente com a equipe de TI!!!",4)
	Else
		Aviso("ERRO","Numero de Documento (D3_DOC) ja utilizado. Entre em contato imediatamente com a equipe de TI!!!",{"OK"})
	EndIf
EndIf

RestArea(aSvAliasD3)
RestArea(aSvAlias)

Return cDoc

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ RetData   ³AUTOR: ³                      ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao para retorno de determinada data                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³ Luiz Cesar    ³17092008³Correcao do tratamento para 00 horas          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetData()

Local dData := Date()
Local _nFuso:= GetMv("MV_CRWHORA")
Local _nDif := 24-(_nFuso*-1)

_nDif := StrZero(_nDif,2)
_nDif := Substr(_nDif,1,2)

if Substring(U_RETTIME(),1,2) < "06"
	dData--
EndIf

If _nFuso <> 0

	// Luiz Cesar - 17/09/08 - Considerado >= pois Quando for 00 horas deve subtrair a data na diferenca de fuso
	//	If Substring(u_RetTime(),1,2) > _nDif
	If Substring(u_RetTime(),1,2) >= _nDif

		If  Substring(u_RetTime(),1,2) < "24"
			dData--
		Endif

	Endif

Endif

Return dData

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Fifo      ³AUTOR: ³                      ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao para retorno de array com dados de etiquetas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fifo(cProduto)

Local aDados:={}

CB0->(DborderNickName("CB0NFSAI"))  // NOTA+SERIE+PRODUTO+DT_NASCIMENTO+ARMAZEM+ENDERECO
CB0->(DbSeek(xFilial("CB0")+Space(12)+cProduto))
While CB0->(! Eof() .and. CB0_FILIAL+CB0_NFSAI+CB0_SERIES+CB0_CODPRO==;
	xFilial("CB0")+Space(12)+cProduto)

	If ! Empty(CB0->CB0_LOCALI) .and. CB0->CB0_LOCAL =="01"
		nPos := 	Ascan(aDados,{|x| x[1]+Dtos(x[2]) == CB0->CB0_LOCALI+Dtos(CB0->CB0_DTNASC)})
		If empty(nPos)
			aadd(aDados,{CB0->CB0_LOCALI,CB0->CB0_DTNASC,CB0->CB0_QTDE})
		Else
			aDados[nPos,3]+= CB0->CB0_QTDE
		EndIF
	EndIf
	CB0->(DbSkip())
End

Return aDados

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ SD3250E  ³ Autor ³ Fernando Alves        ³ Data ³ 11/06/01   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada executado apos o estorno do apontamento     ³±±
±±³          ³ Deleta as etiquetas e estona as quantidades impressas refer. ³±±
±±³          ³ a etiqueta, restaurando o saldo a ser impresso da mesma      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ SIGAFAT                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³Chamado³  Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe       ³08/06/06³       ³ Nao atualiza o SC2 caso seja algum estor³±±
±±³              ³        ³       ³ no disparado por rotinas do ACD. Qdo o  ³±±
±±³              ³        ³       ³ operardor pressionava ESC apos ler a eti³±±
±±³              ³        ³       ³ na rotina de distribuicao, o campo eti- ³±±
±±³              ³        ³       ³ quetas impressas era diminuido          ³±±
±±³ Felipe       ³19/07/06³       ³ Retirado a estorno das Movimentacoes 013³±±
±±³              ³        ³       ³ qdo estorna uma movemntacao 012 		³±±
±±³ Alberto      ³06/12/10³       ³ Incluido tratamento para Ponta Grossa   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alberto       ³31/05/11³ Chamada da funcao EST18I() para geracao de mov. ³±±
±±³			     ³	      ³ na tabela PBW-Movimento material embalagem.     ³±±
±±³			     ³	      ³ Chamado 213421 Projeto Controle Mat.de Embalagem³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo³09/10/13³284710 ³PROJETO A027/13 - ARUMA TERESINA FASE II ³±±
±±³              ³        ³       ³Tratamentos p/ nova filial ARUMA Teresina³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SD3250E()

If ! Empty(CBRetEti(Trim(SD3->D3_ETIQ),"01"))
	Reclock("CB0",.F.)
	If lExcCB0
		CB0->(DbDelete())
	Else
		CB0->CB0_NUMSEQ := ""
	EndIf
	CB0->(MsUnlock())
Endif

dbSelectArea("SD3")
dbOrderNickName("D3ETIQ")
dbSeek(xFilial("SD3")+SD3->D3_ETIQ)

RecLock("SD3",.f.)
Replace D3_EMBARCA with "S"
Replace D3_DTSAIDA with dDataBase
MsUnlock()

*------------------------------------------------------*
* Alberto - 31/05/11 - Projeto Controle Mat.Embalagem  *
*------------------------------------------------------*
_cFlagME  := GetMv("CE_FLAGME") //Alberto 14/06/11 - Projeto controle mat.embalagem(parametro que identifica se a rotina sera utilizada na filial)
If _cFlagME ='S'
	_cCodCli:= SUBSTR(GetMv("CE_CODEMP"),1,6)
	_cLojCli:= SUBSTR(GetMv("CE_CODEMP"),7,2)
	U_EST18E("PBW",0,5,SD1->D1_COD,_cCodCli,_cLojCli,SD1->D1_DTDIGIT,"E",SD1->D1_SERIE,SD1->D1_DOC)
	U_EST18E("PBW",0,5,SD1->D1_COD,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_DTDIGIT,"S",SD1->D1_SERIE,SD1->D1_DOC)
Endif

//Alberto - 06/12/10 - Incluido tratamento para Ponta Grossa
//Felipe - 09/10/13 - Retirada da condicao pois deve entrar para todas as empresas que tem movimentacao de estoque
//If SM0->M0_CODFIL == "01" .OR. SM0->M0_CODFIL == "02" .OR. SM0->M0_CODIGO+SM0->M0_CODFIL $ '0104'

If FUNNAME() $ "MATA250/MATA680/MATA681"
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SD3->D3_OP)
		If Reclock("SC2",.F.)
			SC2->C2_CRWQIMP := SC2->C2_CRWQIMP - SD3->D3_QUANT
			MsUnlock()
		Endif
	Endif
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ACD060CA ³ Autor ³ Eduardo Motta         ³ Data ³ 25/02/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto quando operador pressiona <ESC> no campo de etiqueta   ³±±
±±³          ³ Ele esta no cancelamento do enderecamento que executa o es-  ³±±
±±³          ³ estorno do apontamento de producao (MATA250)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe       ³08/06/06³      ³ Atualiza o campo C2_APNA                 ³±±
±±³ Felipe       ³19/07/06³      ³ Retirado o estorno da movimentacao 013   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACD060CA()

Local _carea
Local nI
Local aMata250
Local cCodCB0
Local aEtiq := {}

Private lMSErroAuto := .F.

For nI := 1 to Len(aAponta)
	cCodCB0  := aAponta[nI,1]
	CBRetEti(cCodCB0,"01")
	aMata250 := aClone(aAponta[nI,2])
	aadd(aMata250,{"D3_NUMSEQ",CB0->CB0_NUMSEQ,nil})
	aadd(aMata250,{"AUTSALDONEG",2,nil})
	aadd(aMata250,{"AUTLIBPRO",1,nil})
	aadd(aMata250,{"INDEX",8,nil})

	lExcCB0 := .F.
	MSExecAuto({|x,y|MATA250(x,y)},aMata250,5)  // opcao de estorno

	lExcCB0 := .T.
	If lMsErroAuto
		conout(replicate("-",80))
		conout("E R R O")
		conout("Falha no estorno do apontamento da producao")
		conout("Data: "+dtoc(ddataBase))
		conout("Hora: "+Time())
		conout("Verifique o arquivo AUTOERRO.LOG")
		conout(replicate("-",80))
		Aviso("ERRO","Falha no estorno do apontamento da producao, verifique o arquivo AUTOERRO.LOG para maiores detalhes.",{"OK"})
	Else
		_aArea1 := GetArea()
		DbSelectArea("SC2")
		DbSetOrder(1)
		DbSeek(xFilial("SC2")+CB0->CB0_OP)
		Reclock("SC2",.F.)
		SC2->C2_APNA := SC2->C2_APNA + CB0->CB0_QTDE
		MsUnlock()
		RestArea(_aArea1)
	EndIf
Next

aAponta := {}

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ACD060CF   ³ Autor ³ Eduardo Motta       ³ Data ³ 25/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada apos a confirmacao da distribuicao, onde  ³±±
±±³          ³ o programa limpa o array aAponta (Utilizado no apontamento ³±±
±±³          ³ da producao)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³ Alberto       ³31/05/11³Projeto controle mat.embalagem. Criada tela   ³±±
±±³               ³        ³para o operador informar no momento da distr. ³±±
±±³               ³        ³o tipo do pallet utilizado.                   ³±±
±±³ Alberto       ³17/06/11³Projeto controle mat.embalagem. Correcao no   ³±±
±±³               ³        ³calculo da qtde mat.embalagem.                ³±±
±±³ Alberto       ³14/07/11³Projeto controle mat.embalagem. Correcao na   ³±±
±±³               ³        ³validacao do material de embalagem            ³±±
±±³ Alex Borges   ³12/02/14³Chamado 315227 - Melhoria na validação do cod.³±±
±±³               ³        ³de material de embalagem.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD060CF()


*------------------------------------------------------*
* Alberto - 31/05/11 - Projeto Controle Mat.Embalagem  *
*------------------------------------------------------*

_cFlagME  := GetMv("CE_FLAGME")
If _cFlagME ="S"
	_cModDist:=SPACE(2)
	_lDistr  := .f.

	cAlias := GetArea()
	//For nI := 1 to Len(aAponta)
	For nI := 1 to Len(_aApEtiq)
		_cCodCB0  := _aApEtiq[nI,1]

		//Identifica se o produto pertence ao grupo de latas
		Dbselectarea("CB0")
		Dbsetorder(1)
		If Dbseek(xfilial("CB0")+_cCodCB0)
			Dbselectarea("SB1")
			Dbsetorder(1)
			If Dbseek(xfilial("SB1")+CB0->CB0_CODPRO)
				If Posicione("SBM",1,xFilial("SBM") + SB1->B1_GRUPO, "BM_A_TIPO") $ "L"
					_lDistr := .t.
				Endif
			Endif

		Endif
	Next
	RestArea(cAlias)
	/*While EMPTY(_cModDist) .and. _lDistr

		@ 3,0 VtSay Space(20)
		@ 4,0 VtSay Padr("Material de Embalagem",20)
		@ 5,0 VtSay Space(20)
		//		@ 5,0 VtGet _cModDist Pict "99" Valid !Empty(_cModDist) .and. VTExistCpo("PBZ",_cModDist) F3 "PBZ"
		@ 5,0 VtGet _cModDist Pict "99" Valid !Empty(_cModDist) .and. VldEmb(_cModDist) F3 "PBZ" //Alberto - 14/07/11 - Incluida validacao do material de embalagem
		VtRead

		If !empty(_cModDist)
			// Alex Borges - 12/02/14 - Chamado 315227
			//Valida o codigo de embalagem
			If VldEmb(_cModDist)
				If VTYesNo("Confirma distribuicao? Codigo: "+_cModDist,"Material de embalagem do pallet",.t.)
					cAlias := GetArea()
					For nI := 1 to Len(_aApEtiq)
						_cCodCB0  := _aApEtiq[nI,1]

						Dbselectarea("CB0")
						Dbsetorder(1)
						If Dbseek(xfilial("CB0")+_cCodCB0)
							RecLock('CB0',.F.)
							CB0->CB0_A_TPEM := _cModDist
							CB0->(MsUnLock())
							//1=Nao se aplica;2=Entrada Crown;3=Entrada Crown Saida Cliente;4=Saida Crown Entrada Cliente;5=Saida Crown
							_cCodCli:= SUBSTR(GetMv("CE_CODEMP"),1,6)
							_cLojCli:= SUBSTR(GetMv("CE_CODEMP"),7,2)
							Dbselectarea("PBZ")
							Dbsetorder(1)
							Dbseek(xfilial("PBZ")+_cModDist)
							//Alberto - 17/06/11 - Projeto controle material embalagem. Correção no calculo da qtde
							U_EST18I("PBW",0,3,"SD3","S",PBZ->PBZ_A_PAL," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"1","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
							U_EST18I("PBW",0,3,"SD3","E",PBZ->PBZ_A_PAL," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"2","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
							_nQtdPapel:=Int(CB0->CB0_QTDE/0.389)+1
							U_EST18I("PBW",0,3,"SD3","S",PBZ->PBZ_A_FOL," ",SD3->D3_DOC,_cCodCli,_cLojCli,_nQtdPapel,"1","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
							U_EST18I("PBW",0,3,"SD3","E",PBZ->PBZ_A_FOL," ",SD3->D3_DOC,_cCodCli,_cLojCli,_nQtdPapel,"2","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
							U_EST18I("PBW",0,3,"SD3","S",PBZ->PBZ_A_QUA," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"1","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
							U_EST18I("PBW",0,3,"SD3","E",PBZ->PBZ_A_QUA," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"2","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
						Endif
					Next
					RestArea(cAlias)
				Else
					_cModDist:=SPACE(2)
					Loop
				Endif
			Else
				_cModDist:=SPACE(2)
				Loop
			EndIf
		Endif


	Enddo*/  //Alex Borges - 16/10/15 - Chamado 332825

    _cFilLata := GetMv("CE_FILLATA")
	If SM0->M0_CODIGO+SM0->M0_CODFIL $ _cFilLata  //Alex Borges - 04/11/15 - Chamado 332825
		_cModDist:= GetAdvFVal("SB1","B1_A_TPEMB",XFILIAL("SB1")+CB0->CB0_CODPRO,1,"")

		If !empty(_cModDist)
			//Valida o codigo de embalagem
			If VldEmb(_cModDist)
				cAlias := GetArea()
				For nI := 1 to Len(_aApEtiq)
					_cCodCB0  := _aApEtiq[nI,1]

					Dbselectarea("CB0")
					Dbsetorder(1)
					If Dbseek(xfilial("CB0")+_cCodCB0)
						RecLock('CB0',.F.)
						CB0->CB0_A_TPEM := _cModDist
						CB0->(MsUnLock())
						//1=Nao se aplica;2=Entrada Crown;3=Entrada Crown Saida Cliente;4=Saida Crown Entrada Cliente;5=Saida Crown
						_cCodCli:= SUBSTR(GetMv("CE_CODEMP"),1,6)
						_cLojCli:= SUBSTR(GetMv("CE_CODEMP"),7,2)
						Dbselectarea("PBZ")
						Dbsetorder(1)
						Dbseek(xfilial("PBZ")+_cModDist)
						//Alberto - 17/06/11 - Projeto controle material embalagem. Correção no calculo da qtde
						U_EST18I("PBW",0,3,"SD3","S",PBZ->PBZ_A_PAL," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"1","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
						U_EST18I("PBW",0,3,"SD3","E",PBZ->PBZ_A_PAL," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"2","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
						_nQtdPapel:=Int(CB0->CB0_QTDE/0.389)+1
						U_EST18I("PBW",0,3,"SD3","S",PBZ->PBZ_A_FOL," ",SD3->D3_DOC,_cCodCli,_cLojCli,_nQtdPapel,"1","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
						U_EST18I("PBW",0,3,"SD3","E",PBZ->PBZ_A_FOL," ",SD3->D3_DOC,_cCodCli,_cLojCli,_nQtdPapel,"2","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
						U_EST18I("PBW",0,3,"SD3","S",PBZ->PBZ_A_QUA," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"1","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
						U_EST18I("PBW",0,3,"SD3","E",PBZ->PBZ_A_QUA," ",SD3->D3_DOC,_cCodCli,_cLojCli,1,"2","DISTRIBUICAO ETIQUETA "+CB0->CB0_CODETI)
					Endif
				Next
				RestArea(cAlias)
			Else
				VtBeep(3)
				VtAlert("Mat.embalagem no cadastro de produto nao existe","Aviso",.t.,6000)
				VtKeyboard(Chr(20))
				Return .F.
			EndIf
		Else
			VtBeep(3)
			VtAlert("Mat.embalagem em branco no cadastro de produto","Aviso",.t.,6000)
			VtKeyboard(Chr(20))
			Return .F.
		Endif
	EndIf

Endif
*--------------------------------------------------------------------*
* Alberto - 31/05/11 - Fim alteracao Projeto Controle Mat.Embalagem  *
*--------------------------------------------------------------------*

aAponta := {}
_aApEtiq:= {}
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ACD060ES   ³ Autor ³ Eduardo Motta       ³ Data ³ 25/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada no estorno do produto na distribuicao     ³±±
±±³          ³ Executa o estorno do apontamento da producao.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³ Alberto       ³14/07/11³Estornar etiqueta do array que controla o     ³±±
±±³               ³        ³material de embalagem.Projeto controle        ³±±
±±³               ³        ³material de embalagem.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD060ES()

Local cCodCB0 := Paramixb[1]
Local nQtde   := Paramixb[2]
Local nPos    := aScan(aAponta,{|x|AllTrim(x[1])==AllTrim(cCodCB0)})
Local _nPosME := aScan(_aApEtiq,{|x|AllTrim(x[1])==AllTrim(cCodCB0)}) //Alberto - 14/07/11- Estornar etiqueta do array que controlaa o material de embalagem

Private lMSErroAuto := .F.
If _nPosME > 0
	aDel(_aApEtiq,_nPosME) //Alberto - 14/07/11- Estornar etiqueta do array que controlaa o material de embalagem
	aSize(_aApEtiq,Len(_aApEtiq)-1)
EndIf


If nPos == 0
	Return
EndIf

cCodCB0  := aAponta[nPos,1]
CBRetEti(cCodCB0,"01")
aMata250 := aClone(aAponta[nPos,2])
nPosDoc := aScan(aMata250,{|x|x[1]=="D3_DOC"})
nPosTM  := aScan(aMata250,{|x|x[1]=="D3_TM"})

aadd(aMata250,{"D3_NUMSEQ",CB0->CB0_NUMSEQ,nil})
aadd(aMata250,{"AUTSALDONEG",2,nil})
aadd(aMata250,{"AUTLIBPRO",1,nil})
aadd(aMata250,{"INDEX",8,nil})

lExcCB0 := .F.
MSExecAuto({|x,y|MATA250(x,y)},aMata250,5)  // opcao de estorno

lExcCB0 := .T.
If lMsErroAuto
	conout(replicate("-",80))
	conout("E R R O")
	conout("Falha no estorno do apontamento da producao")
	conout("Data: "+dtoc(ddataBase))
	conout("Hora: "+Time())
	conout("Verifique o arquivo AUTOERRO.LOG")
	conout(replicate("-",80))
	Aviso("ERRO","Falha no estorno do apontamento da producao, verifique o arquivo AUTOERRO.LOG para maiores detalhes.",{"OK"})
EndIf

aDel(aAponta,nPos)
aSize(aAponta,Len(aAponta)-1)


Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ AI130DGR  ³AUTOR: ³                      ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada depois que foi feita a movimentacao       ³±±
±±³          ³ Atualiza as Etiquetas                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marion        ³20/07/06³Requisicao de Tampa Basica para CEA           ³±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³ Luiz Cesar    ³13102008³Projeto Tintas                                ³±±
±±³ Marion        ³14/11/08³Projeto Aruma                                 ³±±
±±³ Alberto       ³06/12/10³Projeto Ponta Grossa                          ³±±
±±³	Fabricio	  ³01/11/11³Tratamento plantas CH 231247                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AI130DGR()

Local cAlias := {}

If cProg == PROG

	cAlias := GetArea()
	RecLock('CB0',.F.)
	CB0->CB0_CCAREA := "S"
	CB0->(MsUnLock())

	dbSelectarea("PA2")  // *** Felipe em 03/02/06 -> Qdo transferir p/ Sucata gravar saida no PA2
	dbSetorder(1)
	If dbSeek(xFilial("PA2")+CB0->CB0_CODETI)
		While CB0->CB0_CODETI = PA2->PA2_CODETI
			If EMPTY(PA2->PA2_DTSAI)
				RecLock('PA2',.F.)
				PA2->PA2_DTSAI  := U_RetData()
				PA2->PA2_HRSAI  := U_RETTIME()
				PA2->PA2_DESSAI := '3'
				PA2->(MsUnLock())
				Dbskip()
				Loop
			Else
				DbSkip()
				Loop
			EndIf
		End
	EndIf

	RestArea(cAlias)

ElseIf cProg == DEV

	If CBProdUnit(CB0->CB0_CODPRO)
		RecLock('CB0',.F.)
		CB0->CB0_CC := "   "
		aetiqueta[19] := '   '
		CB0->CB0_USUARIO := __cUserID
		CB0->CB0_MAQUIN   := ""
		CB0->CB0_CTURNO   := ""
		CB0->(MsUnLock())
	EndIf

ElseIf cProg == REQ

	//------------------------------------------------
	// Alterado por Marion em 14/11/08 - Projeto Aruma
	//------------------------------------------------
	// Alterado por Alberto em 06/12/10 - Projeto Ponta Grossa
	//Fabrício - 01/11/11 - Com a integração com o Mnt a rotina esta liberada para todas as plantas.
	If CB0->CB0_CODPRO >= GETMV("CE_PRODINI") .AND. CB0->CB0_CODPRO <= GETMV("CE_PRODFIN") //.AND. SM0->M0_CODIGO+SM0->M0_CODFIL $ '0102/0301/0104'
		//------------------------------------------------
		If CBProdUnit(CB0->CB0_CODPRO)
			RecLock('CB0',.F.)
			CB0->CB0_CC      := "MAQ"
			aetiqueta[19]    := "MAQ"
			CB0->CB0_A_OS    := _nOS
			CB0->CB0_USUARIO := __cUserID
			CB0->CB0_MAQUIN  := cMaqMovInt
			CB0->CB0_CTURNO  := cTurno
			CB0->(MsUnLock())
		EndIf


		// LUIZ CESAR - 13/10/08 - PROJETO DE TINTAS - TRATAMENTO DE REQUISICOES VIA COLETOR
	elseif U_ALUEST08("CE_PRODREQ",CB0->CB0_CODPRO)

		If CBProdUnit(CB0->CB0_CODPRO)
			RecLock('CB0',.F.)
			CB0->CB0_CC      := "DIV"
			CB0->CB0_USUARIO := __cUserID
			CB0->CB0_CTURNO  := cTurno
			CB0->(MsUnLock())
		EndIf

	Endif

ElseIf cProg == TBREQ

	cAlias := GetArea()
	RecLock('CB0',.F.)
	CB0->CB0_NFSAI  := SD3->D3_DOC
	CB0->CB0_SERIES := "REQ"
	CB0->(MsUnLock())
	RestArea(cAlias)

EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AI130GMI   ³ Autor ³ Fernando Alves      ³ Data ³ 24/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada para atualizar o array de rotina automat. ³±±
±±³          ³ antes de gravar a movimentacao interna. Grava informacoes  ³±±
±±³          ³ como: maquina, Turno, Etiqueta.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Crown Cork        	    								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Marion   ³20/07/06³ Requisicao de Tampa Basica para CEA				  ³±±
±±³ Katia    ³27/11/06³ Alteracao para gravar tp manutencao corretiva/pre ³±±
±±³          ³        ³ ventiva.                                          ³±±
±±³ Marion   ³05/03/07³ Alteracao para gravar numero da OS - Integracao   ³±±
±±³          ³        ³ SIM x Microsiga.                                  ³±±
±±³ Marion   ³06/07/07³ Alteracao para tratamento de varias requisicoes   ³±±
±±³          ³        ³ para cada OS SIM.                                 ³±±
±±³ Marion   ³14/11/08³ Projeto Aruma                                     ³±±
±±³ Alberto  ³06/12/10³ Projeto Ponta Grossa                              ³±±
±±³	Fabricio ³01/11/11³Tratamento plantas CH 231247                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AI130GMI()

Local aRet := aclone(PARAMIXB)
Local nPos := 0
Local _cSolCRA := CriaVar("D3_A_SOLTK")

If cProg == PROG

	nPos := aScan(aRet,{|x| upper(alltrim(x[1])) == "D3_LOCAL"})
	aRet[nPos,2] := padr(GetNewPar("MV_ALMOHFI","90"),2)
	aadd(aRet,{"D3_LOCALIZ",padr(GetNewPar("MV_LOCAHFI","HFI"),15),NIL})

ElseIf cProg == DEV	.or. cProg == REQ
	// Ricardo Lima - 24/04/17
	if empty(cMaqMovInt)
		VTClear()
		@ 02,00 VtSay "Maquina"
		@ 03,00 VtGet cMaqMovInt // // Ricardo Lima - 24/04/17
		VTRead
	endif
	if empty(cTurno)
	  cTurno := "A"
	endif

	aadd(aRet,{"D3_CRWMAQ",cMaqMovInt,NIL}) //CRWMAQ ??
	aadd(aRet,{"D3_CTURNO" ,cTurno	,NIL})	// CARACTER 1

	//Alberto - 06/12/10- Incluido tratament para Ponta Grossa
	//	If CB0->CB0_CODPRO >= GETMV("CE_PRODINI") .AND. CB0->CB0_CODPRO <= GETMV("CE_PRODFIN") .AND. SM0->M0_CODIGO+SM0->M0_CODFIL == '0102'
	//Fabrício - 01/11/11 - Com a integração com o Mnt a rotina esta liberada para todas as plantas.
	If CB0->CB0_CODPRO >= GETMV("CE_PRODINI") .AND. CB0->CB0_CODPRO <= GETMV("CE_PRODFIN") //.AND. SM0->M0_CODIGO+SM0->M0_CODFIL $ '0102/0104'
		//		aadd(aRet,{"D3_A_OS" ,_nOs,NIL})
		aadd(aRet,{"D3_A_OS" ,1,NIL})
		aadd(aRet,{"D3_ORDEM" ,_cOs,NIL})  //Alberto - 17/08/11 - Projeto integracao estoque x man.ativo
		//		aadd(aRet,{"D3_OP" ,_cOs+"OS001",NIL})  //Alberto - 17/08/11 - Projeto integracao estoque x man.ativo
	Endif

	aadd(aRet,{"D3_USUARIO" ,__cUserID	,NIL})   // D3_USUARIO
	aadd(aRet,{"D3_DOC"     ,U_PROXDOC(),NIL})   // D3_DOC
	aadd(aRet,{"D3_ETIQ"    ,CB0->CB0_CODETI,NIL})   // D3_ETIQ

	// Ricardo Lima - 05/01/17
	VTClear()
   	@ 02,00 VtSay "Solicitante (Cracha):"
	@ 03,00 VtGet _cSolCRA Valid VTExistCpo("PCL",_cSolCRA) // Ricardo Lima - 24/04/17
	VTRead

	if !empty(_cSolCRA)
	 aadd(aRet,{"D3_A_SOLTK" , SUBSTR(_cSolCRA,2,LEN(_cSolCRA)-1) ,NIL})
	endif
//

ElseIf cProg == TBREQ

	aadd(aRet,{"D3_CTURNO"  ,_cTurnoTB	,NIL})
	aadd(aRet,{"D3_USUARIO" ,__cUserID	,NIL})
	aadd(aRet,{"D3_DOC"     ,U_PROXDOC(),NIL})
	aadd(aRet,{"D3_ORIGEM"  ,CB0->CB0_CODETI,NIL})

EndIf

//Alberto - 06/12/10- Incluido tratament para Ponta Grossa
//If CB0->CB0_CODPRO >= GETMV("CE_PRODINI") .AND. CB0->CB0_CODPRO <= GETMV("CE_PRODFIN") .AND. SM0->M0_CODIGO+SM0->M0_CODFIL == '0102'
//Fabrício - 01/11/11 - Com a integração com o Mnt a rotina esta liberada para todas as plantas.
If CB0->CB0_CODPRO >= GETMV("CE_PRODINI") .AND. CB0->CB0_CODPRO <= GETMV("CE_PRODFIN") //.AND. SM0->M0_CODIGO+SM0->M0_CODFIL $ '0102/0104'
	//	VTALERT("Últ.OS = "+ Alltrim(Str(_nos)) ,"INFO",.F.,3500)
	VTALERT("Últ.OS = "+ Alltrim(_cos) ,"INFO",.F.,3500)  //Alberto - 18/08/11 - Integracao estoque x man.ativo
Endif

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AI130TM    ³ Autor ³ Fernando Alves      ³ Data ³ 17/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada para validacao do tipo de movimento       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marion        ³20/07/06³Requisicao de Tampa Basica para CEA           ³±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AI130TM()

Local cTM := "   "
Local aTela

If PARAMIXB == PROG
	cTM := GetMV("MV_CCTMSUC")
ELSEIf PARAMIXB == DEV
	cTM := GetMV("MV_CCTMDMQ")  // TIPO DE MOVIMENTACAO DE DEVOLUCAO DE PECAS DE MAQUINAS
ELSEIf PARAMIXB == REQ
	cTM := GetMV("MV_CCTMRMQ")// TIPO DE MOVIMENTACAO DE REQUISICAO DE PECAS DE MAQUINAS
ELSEIf PARAMIXB == TBREQ
	cTM := GetMV("CE_TMREQTB")
EndIf

If PARAMIXB == DEV .or. PARAMIXB == REQ

	Pergunte("CTURNO",.F.)

	While MudaTurno()
		VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		Pergunte("CTURNO",.t.)
	End

	cTurno := Upper(MV_PAR01)

EndIf

cProg := PARAMIXB // asv implementar o tm automatico

Return cTM


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AI130VCB   ³ Autor ³ Fernando Alves      ³ Data ³ 11/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada na Rotina de Transferencia do ACD, na va- ³±±
±±³          ³ lidacao da Etiqueta. Caso haja necessidade o programa soli-³±±
±±³          ³ cita a mudanca do turno e da maquina.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±³ Luiz Cesar    ³13102008³Projeto de Tintas                             ³±±
±±³ Marion        ³14/11/08³Projeto Aruma                                 ³±±
±±³ Alberto       ³06/12/10³Projeto Ponta Grossa                          ³±±
±±³ Alberto       ³17/08/11³Projeto A009/11-Integracao Estoque x Manut.   ³±±
±±³               ³        ³Ativos                                        ³±±
±±³ Fabricio      ³05/09/11³Projeto A009/11-Integracao Estoque x Manut.   ³±±
±±³               ³        ³Ativos                                        ³±±
±±³	Fabricio	  ³16/09/11³Tratamento maquina                            ³±±
±±³	Fabricio	  ³20/09/11³Tratamento maquina qdo nao for amarrada OS    ³±±
±±³	Fabricio	  ³01/11/11³Tratamento plantas CH 231247                  ³±±
±±³	Alberto  	  ³28/09/12³Chamado 235.285-Bloquear a requisicao de latas³±±
±±³	         	  ³        ³ou de produtos que nao devam ser requisitados ³±±
±±³	         	  ³        ³pela rotina "Req.PC maquinas"                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AI130VCB()

Local lRet := .T.
Local aTela:= VtSave()

If cProg == 'SUCATA'

	lRet := U_CRCArea('SUCATA',PARAMIXB)

ElseIf cProg == DEV	.or. cProg == REQ

	If CBProdUnit(CB0->CB0_CODPRO)
		If cProg == REQ	.and. ! Empty(CB0->CB0_CC)
			VTAlert("Etiqueta ja requisitada","Atencao",.t.,3000,3)
			Return .f.
		EndIf
		If cProg == DEV	.and. Empty(CB0->CB0_CC) .and. ! Empty(CB0->CB0_NUMSEQ)
			VTAlert("Etiqueta ja devolvida","Atencao",.t.,3000,3)
			Return .f.
		EndIf
	EndIf

    //Alberto - 28/09/12 - Chamado 235.285 - Bloquear a requisicao de latas atraves dessa rotina
	_cTipoProd := GetAdvFVal("SBM","BM_A_TIPO",XFILIAL("SBM")+SB1->B1_GRUPO,1,"")
    IF _cTipoProd $ "L/T"
		VtBeep(3)
		VtAlert("Atencao. Etiqueta:"+ALLTRIM(CB0->CB0_CODETI)+" invalida. Produto:"+ALLTRIM(CB0->CB0_CODPRO),"Aviso",.t.,6000)
		VtKeyboard(Chr(20))
		lRet := .F.
    Endif

	While MudaTurno()
		VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		Pergunte("CTURNO",.t.)
	End

	cMaqMovInt:=Space(6)

	//Fabrício - 01/11/11 - Com a integração com o Mnt a rotina esta liberada para todas as plantas.
	If CB0->CB0_CODPRO >= GETMV("CE_PRODINI") .AND. CB0->CB0_CODPRO <= GETMV("CE_PRODFIN") //.AND. SM0->M0_CODIGO+SM0->M0_CODFIL $ '0102/0104'

		_lTelaOS := .t.
		_nTrbOS := 0

		//Alberto - 17/08/11 - Projeto integracao estoque x Man.Ativo
		_cOs := space(6)
		While EMPTY(_cOs) .and. _lTelaOS

			@ 6,0 VtSay Space(35)
			@ 6,0 VtSay Padr("Numero da OS (Man.Ativo)",35)
			@ 7,0 VtSay Space(20)
			@ 7,0 VtGet _cOs Pict "999999" Valid VldOS(_cOs) F3 "STJ"
			VtRead

			If !empty(_cOs)
				If !VTYesNo("Confirma Ordem de Servico: "+_cOs,"Ordem de Servico",.t.)
					_cOs:=SPACE(6)
					Loop
				Endif
			Else
				//Fabrício - 05/09/11 - Projeto integracao estoque x Man.Ativo
				//Inclusao de uma OS Corretiva utilizando rotina "automatica"
				If VTYesNo("Criar uma nova OS Corretiva?","Ordem de Servico",.t.)
					cAlias := GetArea()

					_cBem := Space(16)
					_cServ := Space(6)
					_cOBS := Space(50)
					_cTipoMan := ""
					_cCodArea := ""

					While (Len(AllTrim(_cBem)) <= 0 .OR. Len(AllTrim(_cServ)) <= 0) .AND. VTLastkey() # 27
						VTClear()
						@ 0,00 VtSay "Abertura de OS Corretiva"
						@ 2,00 VtSay "Bem: "
						@ 2,10 VtGet _cBem Valid VldBem(_cBem) F3 "T9MAQ"
						@ 4,00 VtSay "Servico: "
						@ 4,10 VtGet _cServ Valid VldSrv(_cServ) F3 "ST4"
						@ 6,00 VtSay "Obs.: "
						@ 6,10 VtGet _cOBS
						VtRead
					EndDo

					If  Len(AllTrim(_cBem)) > 0 .AND. Len(AllTrim(_cServ)) > 0
						aRotAuto:= {;
						{"TJ_CODBEM"	,_cBem   	,NIL},;
						{"TJ_DTORIG"	,dDataBase  ,NIL},;
						{"TJ_SITUACA"	,"L"  	 	,NIL},;
						{"TJ_TIPOOS"	,"B"  		,NIL},;
						{"TJ_CODAREA"	,_cCodArea 	,NIL},;
						{"TJ_SERVICO"	,_cServ  	,NIL},;
						{"TJ_PLANO"		,"000000"  	,NIL},;
						{"TJ_SEQRELA"	,"0"   		,NIL},;
						{"TJ_OBSERVA"	,_cOBS  	,NIL},;
						{"TJ_TIPO"		,_cTipoMan 	,NIL}}

						TIPOACOM := .T.
						INCLUI := .T.
						lCORRET := .T.

						nOpc := 3
						lMSErroAuto := .F.

						aRotina := {;
						{ "" , "AxPesqui"    , 0 , 1},;
						{ "" , "AxVisual"    , 0 , 2},;
						{ "" , "U_m420Auto"  , 0 , 3}}

						MsRotAuto(nOpc,aRotAuto,"STJ")

						If !lMSErroAuto
							_cOs := STJ->TJ_ORDEM
							VtBeep(3)
							VtAlert("Atencao. Gerada a OS: "+_cOs,"Aviso",.t.,6000)
							VtKeyboard(Chr(20))
						Else
							cFileLog := NomeAutoLog()
							If VALTYPE(cFileLog) == "C"
								VTDispFile(NomeAutoLog(),.t.)
							Endif
							VtBeep(3)
							VtAlert("Atencao. OS Não Gerada.","Aviso",.t.,6000)
							VtKeyboard(Chr(20))
							lRet := .F.
						EndIf
					EndIf
					RestArea(cAlias)
				Else
					If VTYesNo("Confirma requisicao sem Ordem de Servico? ","Ordem de Servico",.t.)
						_cOs:=SPACE(6)
						_lTelaOS := .F.
						//Fabrício - 20/09/11 - Inclusão do trecho abaixo, para caso não seja informada um OS o usuario possa amarrar a maquina.
						if !U_ALUEST08("CE_PRODREQ",CB0->CB0_CODPRO)
							@ 5,0 VtSay Space(20)
							@ 6,0 VtSay Padr("Maquina",20)
							@ 7,0 VtSay Space(20)
							@ 7,0 VtGet cMaqMovInt Pict "@!" Valid !Empty(cMaqMovInt) .and. VTExistCpo("ZZ9",cMaqMovInt) F3 "ZZ9"
							VtRead
							If VtLastKey() == 27
								cMaqMovInt:=Space(6)
								VtRestore(,,,,aTela)
								Return .f.
							EndIf
						Endif
					Endif
				Endif
			Endif
		Enddo

	Endif


	VtRestore(,,,,aTela)

ElseIf cProg == TBREQ

	If !Substr(SB1->B1_GRUPO,1,2) == "TB" //Tramento de Tampa Basica
		VTAlert("Produto nao pertence ao grupo Tampa Basica","Atencao",.t.,3000,3)
		Return .f.
	ElseIf !Empty(CB0->CB0_NFSAI) .and. CB0->CB0_SERIES == "REQ"
		VTAlert("Etiqueta ja requisitada","Atencao",.t.,3000,3)
		Return .f.
	ElseIf !Empty(CB0->CB0_NFSAI) .and. !CB0->CB0_SERIES $ "REQ"
		VTAlert("Etiqueta ja faturada","Atencao",.t.,3000,3)
		Return .f.
	ElseIf CB0->CB0_CCAREA $ "H"
		VTAlert("Etiqueta em HFI","Atencao",.t.,3000,3)
		Return .f.
	ElseIf CB0->CB0_CCAREA $ "R"
		VTAlert("Etiqueta em Retrabalho","Atencao",.t.,3000,3)
		Return .f.
	ElseIf CB0->CB0_CCAREA $ "S"
		VTAlert("Etiqueta em Sucata","Atencao",.t.,3000,3)
		Return .f.
	ElseIf Empty(CB0->CB0_LOCALI)
		VTAlert("Etiqueta nao distribuida","Atencao",.t.,3000,3)
		Return .f.
	Endif

	Do While .t.
		_cTurnoTB:=Space(1)
		@ 5,0 VtSay Space(20)
		@ 6,0 VtSay Padr("Turno",20)
		@ 7,0 VtSay Space(20)
		@ 7,0 VtGet _cTurnoTB Pict "@!" Valid !Empty(_cTurnoTB)
		VtRead

		If VtLastKey() == 27
			_cTurnoTB:=Space(1)
			VtRestore(,,,,aTela)
			Return .f.
		EndIf

		VtRestore(,,,,aTela)

		If VlTurnoTB(_cTurnoTB)
			Exit
		Endif
	End

EndIf

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AIC060VPR³ Autor ³ Fernando Alves        ³ Data ³ 11/06/01     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada da distribuicao, na validacao da etiqueta     ³±±
±±³          ³ Efetua o apontamento da producao simples e atualiza etiquetas  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ SIGAFAT                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³chamado³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe       ³08/06/06³       ³ Atualiza o campo C2_APNA corretamente     ³±±
±±³ Felipe       ³19/07/06³       ³ Retirado a gercaoo das Movimentacoes 013  ³±±
±±³              ³        ³       ³ na producao de sucata (012)     		  ³±±
±±³ ALBERTO      ³06/07/07³       ³ Tratamento para Distribuidora.            ³±±
±±³ ALBERTO      ³07/01/11³       ³ Correcao no posicionamento SC2.Chamado    ³±±
±±³              ³        ³       ³ 208.430(Projeto Ponta Grossa)			  ³±±
±±³ CRISTIANE    ³15/05/12³ 243604 ³ Procurar pelo documento e tipo do produto³±±
±±³ CRISTIANE    ³05/09/12³ 243604 ³ Procurar se tem a etiqueta preenchida    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AIC060VPR()

Local aMATA250 := {}
Local cDoc
Local cNumSeq
Local nH
Local aArea:= GetArea('SD3')
Local codeti := CB0->CB0_CODETI  //ROBERTO

Private lMSErroAuto := .F.

conout(CODETI) //ROBERTO

If SM0->M0_CODIGO+SM0->M0_CODFIL $ '0901'
	Return .t.
Endif

If ! U_CRCArea('DISTRIBUICAO',PARAMIXB[1])
	Return .f.
EndIf

If ! Empty(CB0->CB0_NUMSEQ)
	aadd(_aApEtiq,{CB0->CB0_CODETI,aClone(aMata250)}) //Alberto - 31/05/11- Projeto controle material de embalagem
	Return .t.
EndIf

SD3->(DbOrderNickName("D3ETIQ"))
If SD3->(DbSeek(xFilial('SD3')+substr(CODETI,1,6))) .AND. Empty(SD3->D3_ESTORNO) //If SD3->(DbSeek(xFilial('SD3')+CB0->CB0_CODETI))
	if cb0->(dbseek(xFilial('CB0')+CODETI)) //ROBERTO
		RecLock("CB0",.f.)
		CB0->CB0_NUMSEQ := SD3->D3_NUMSEQ
		MsUnlock()
		RestArea(aArea)
		Return .t.
	ELSE
		CONOUT("NÃO ACHOU")
	ENDIF    //ROBERTO
EndIf

dbSelectarea("SC2")
dbSetorder(1)
dbSeek(xFilial("SC2")+CB0->CB0_OP)

RestArea(aArea)

nH := u_SemD3Lock()
cDoc := u_ProxDoc()
aMata250      :={{"D3_TM"     ,CB0->CB0_TM		, NIL},;
{"D3_COD"    ,CB0->CB0_CODPRO	, NIL},;
{"D3_UM"     ,SC2->C2_UM		, NIL},;
{"D3_OP"     ,CB0->CB0_OP		, NIL},;
{"D3_LOCAL"  ,CB0->CB0_LOCAL	, NIL},;
{"D3_CLINHA" ,CB0->CB0_CLINHA	, NIL},;
{"D3_CTURNO" ,CB0->CB0_CTURNO	, NIL},;
{"D3_EMISSAO",CB0->CB0_DTNASC	, NIL},;
{"D3_DOC"    ,cDoc 				, NIL},;
{"D3_QUANT"  ,CB0->CB0_QTDE  	, NIL},;
{"D3_ETIQ"   ,CB0->CB0_CODETI	, NIL},;
{"D3_HORA"   ,CB0->CB0_CRWHOR	, NIL},;
{"D3_CRWSEQ" ,CB0->CB0_CRWSEQ	, NIL}}

MSExecAuto({|x|MATA250(x)},aMata250)

If lMsErroAuto

	u_SemD3UnLock(nH)
	conout(replicate("-",80))
	conout("E R R O")
	conout("Falha no apontamento da producao")
	conout("Data: "+dtoc(ddataBase))
	conout("Hora: "+Time())
	conout("Verifique o arquivo AUTOERRO.LOG")
	conout(replicate("-",80))

	If IsTelNet()
		VTDispFile(NomeAutoLog(),.t.)
	Else
		Aviso("ERRO","Falha no apontamento da producao, verifique o arquivo AUTOERRO.LOG para maiores detalhes.",{"OK"})
	EndIf

Else

	dbSelectArea("SC2")
	//Alberto - 07/01/11 - Correcao posicionamento tabela SC2
	dbSetorder(1)
	dbSeek(xFilial("SC2")+CB0->CB0_OP)
	If RecLock("SC2",.F.)
		SC2->C2_APNA := SC2->C2_APNA - CB0->CB0_QTDE
		msUnLock()
	EndIf

	DbSelectArea("SD3")
	DbSetOrder(2)
	DbSeek(xFilial("SD3") + cDoc)
	While SD3->(! Eof() .and. xFilial('SD3')+cDoc == D3_FILIAL+D3_DOC)
		If SD3->D3_CF=='PR0' .AND. SD3->D3_ETIQ <> ' '   // Cristiane 15/05/12  - 05/09/12
			RecLock("CB0",.f.)
			CB0->CB0_NUMSEQ := SD3->D3_NUMSEQ
			MsUnlock()
		EndIf
		SD3->(DbSkip())
	Enddo

	aadd(aAponta,{CB0->CB0_CODETI,aClone(aMata250)})
	aadd(_aApEtiq,{CB0->CB0_CODETI,aClone(aMata250)}) //Alberto - 31/05/11- Projeto controle material de embalagem
	u_SemD3UnLock(nH)

EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ MudaTurno ³AUTOR: ³                      ³DATA: ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Funcao de verificação de mudança de turno                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³07/01/15³ Projeto A001/15 - Chamado: 312366 			  ³±±
±±³               ³        ³ Tratamento para turnos 1, 2 e 3 com horarios ³±±
±±³               ³        ³ distintos em cada filial					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MudaTurno()

Local cHora := Stuff(Left(time(),5),3,1,"")
Local cTurno:=''
Local cTpTurno := GetMv("MV_TURNOTP")
Local _nFusoH := GetMv("MV_CRWHORA")

//Felipe - 07/01/15 - Hora de cada turno fica em parametros
Local cHrTur1 := GetNewPar("CE_HRTURN1","0600")
Local cHrTur2 := GetNewPar("CE_HRTURN2","1400")
Local cHrTur3 := GetNewPar("CE_HRTURN3","2200")

cHora := Alltrim(StrZERO(Val(Substr(chora,1,2))+_nfusoh,2)+Substr(cHora,3,2))

If Empty(MV_PAR01)
	Return .t.
EndIf

If cTpTurno == "1"

	//Felipe - 07/01/15 - Utiliza variaveis vindas de parametros
	If cHora >= cHrTur1 .and. cHora < cHrTur2
		cTurno:='1'
	ElseIf cHora >= cHrTur2 .and. cHora < cHrTur3
		cTurno:='2'
	Else
		cTurno:='3'
	EndIf

	If Alltrim(MV_PAR01) <> Alltrim(cTurno)
		Return .f.
	EndIf
Else
	If cHora >= '0600' .and. cHora < "1800"
		cTurno:='AC'
	Else
		cTurno:='BD'
	EndIf
	If (MV_PAR01 $ "AC" .and. cTurno == "BD") .or. (MV_PAR01 $ "BD" .and. cTurno == "AC")
		Return .t.
	Else
		Return .f.
	EndIf
Endif

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VlTurnoTB  ³ Autor ³ Marion              ³ Data ³ 20/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida turno na requisicao de etiqueta basica - cea         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³12062008³Cabecalhos e Identacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³07/01/15³ Projeto A001/15 - Chamado: 312366 			  ³±±
±±³               ³        ³ Tratamento para turnos 1, 2 e 3 com horarios ³±±
±±³               ³        ³ distintos em cada filial					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VlTurnoTB(_cTurnoTB)

Local _cHora    := Stuff(Left(time(),5),3,1,"")
Local _cTpTurno := GetMv("MV_TURNOTP")
Local _lRetTb   := .f.
Local _nFusoH := GetMv("MV_CRWHORA")

//Felipe - 07/01/15 - Hora de cada turno fica em parametros
Local cHrTur1 := GetNewPar("CE_HRTURN1","0600")
Local cHrTur2 := GetNewPar("CE_HRTURN2","1400")
Local cHrTur3 := GetNewPar("CE_HRTURN3","2200")

_cHora := Alltrim(Str(Val(Substr(_chora,1,2))+_nfusoh)+Substr(_cHora,3,2))

If _cTpTurno == "1"

	//Felipe - 07/01/15 - Utiliza variaveis vindas de parametros
	If _cHora >= cHrTur1 .and. _cHora < cHrTur2
		If _cTurnoTB $ "1"
			_lRetTb = .t.
		Else
			VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		EndIf
	ElseIf _cHora >= cHrTur2 .and. _cHora < cHrTur3
		If _cTurnoTB $ "2"
			_lRetTb = .t.
		Else
			VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		EndIf
	Else
		If _cTurnoTB $ "3"
			_lRetTb = .t.
		Else
			VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		EndIf
	EndIf
Else
	If _cHora >= '0600' .and. _cHora < "1800"
		If _cTurnoTB $ 'AC'
			_lRetTb = .t.
		Else
			VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		EndIf
	Else
		If _cTurnoTB $ 'BD'
			_lRetTb = .t.
		Else
			VTAlert("Turno","Favor mudar o turno",.t.,2000,3)
		EndIf
	EndIf
Endif

Return _lRetTB
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ AV130AVL ³AUTOR: ³Alberto                ³DATA: ³07/07/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto de entrada para validar a etiqueta na rotina de      ³±±
±±³          ³ requisicao devolucao pecaas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD - Crown Tampas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AV130AVL()

Local cAlias := {}

If cProg == DEV
	cAlias := GetArea()
	Dbselectarea("CB0")
	Dbsetorder(1)
	IF Dbseek(xfilial("CB0")+cEti)
		If CB0_NUMSEQ ='INISB2' // Esse campo identifica que a etiqueta foi gerada pela rotina 'Etiq Produto SB2',nao sendo uma etiqueta gerada por op
			RecLock('CB0',.F.)
			CB0->CB0_STATUS := "1"
			CB0->(MsUnLock())
		EndIf
	Endif
	RestArea(cAlias)

ElseIf cProg == REQ

	cAlias := GetArea()
	Dbselectarea("CB0")
	Dbsetorder(1)
	IF Dbseek(xfilial("CB0")+cEti)
		If CB0_NUMSEQ ='INISB2' // Esse campo identifica que a etiqueta foi gerada pela rotina 'Etiq Produto SB2',nao sendo uma etiqueta gerada por op
			RecLock('CB0',.F.)
			CB0->CB0_STATUS := " "
			CB0->(MsUnLock())
		EndIf
	Endif
	RestArea(cAlias)

EndIf

Return(cEti)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldEmb   ³ Autor ³ Alberto               ³ Data ³ 14/07/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Validacao do mat.embalagem. Projeto controle material de   ³±±
±±³          ³ embalagem                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldEmb(_cMatEmb)


VtClearBuffer()

dbSelectArea("PBZ")
If !Dbseek(xfilial("PBZ")+_cMatEmb)
	VtBeep(3)
	VtAlert("Mat.embalagem invalido.","Aviso",.t.,6000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldOs    ³ Autor ³ Alberto               ³ Data ³ 17/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Validacao da Ordem de Servico                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	Fabricio	  ³16092011³ Tratamento maquina                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldOs(_cOs)


VtClearBuffer()

If !empty(_cOs)
	dbSelectArea("STJ")
	If !Dbseek(xfilial("STJ")+_cOs)
		VtBeep(3)
		VtAlert("Ordem de servico invalida.","Aviso",.t.,6000)
		VtKeyboard(Chr(20))
		Return .F.
	Else
		dbSelectArea("ST9")
		dbSetOrder(1)
		If Dbseek(xfilial("ST9")+STJ->TJ_CODBEM)
			cMaqMovInt := ST9->T9_A_MAQ
		EndIf
	EndIf
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldBem   ³ Autor ³ Fabrício              ³ Data ³ 05/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Validacao do Codigo do Bem                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	Fabricio	  ³16092011³ Tratamento maquina                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldBem(_cBem)


VtClearBuffer()

If !empty(_cBem)
	dbSelectArea("ST9")
	dbSetOrder(1)
	If !Dbseek(xfilial("ST9")+_cBem)
		VtBeep(3)
		VtAlert("Bem invalido.","Aviso",.t.,6000)
		VtKeyboard(Chr(20))
		Return .F.
	Else
		cMaqMovInt := ST9->T9_A_MAQ
	EndIf
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldSrv   ³ Autor ³ Fabrício              ³ Data ³ 05/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Validacao do Codigo do Servico                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldSrv(_cSrv)


VtClearBuffer()

If !empty(_cSrv)
	If !ST4->(DbSeek(xFilial('ST4') + _cSrv))
		Help(" ",1,"SERVICONAOEXIST")
		Return .f.
	EndIf

	_cTipoMan := ST4->T4_TIPOMAN
	_cCodArea := ST4->T4_CODAREA

	If !STE->(DbSeek(xFilial('STE') + ST4->T4_TIPOMAN))
		Help(" ",1,"TIPONAOEXIST")
		Return .f.
	EndIf

	If STE->TE_CARACTE != "C"
		Help(" ",1,"SERVNAOCORRET")
		Return .f.
	EndIf
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ m420Auto   ³ Autor ³ Fabrício            ³ Data ³ 06/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Rotina automatica para inclusão de O.S. Corretiva          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function m420Auto(cAlias,nReg,nOpc)
Begin Transaction
If AxIncluiAuto( cAlias) == 1
	cCODPRO  := GetMV("MV_PRODMNT")
	cOP      := STJ->TJ_ORDEM + "OS001"
	GERAOP(cCODPRO, 1, cOP, STJ->TJ_DTORIGI, STJ->TJ_DTORIGI)
	//-- Grava os Campos Especificos na OP
	If SC2->C2_FILIAL == STJ->TJ_FILIAL .AND. SC2->C2_NUM == STJ->TJ_ORDEM .AND. SC2->C2_ITEM == "OS"
		DbSelectArea('SC2')
		RecLock('SC2', .F.)
		SC2->C2_STATUS  := 'U'
		SC2->C2_OBS     := 'PLANO 000000'
		MsUnlock('SC2')
		If __lSX8
			ConfirmSX8()
		EndIf
	Else
		lMsErroAuto := .T.
	EndIf
EndIf
If lMsErroAuto
	If __lSX8
		RollBackSX8()
	EndIf
EndIf
End Transaction

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VLD3TURNO³ Autor ³ Felipe Geraldo        ³ Data ³ 07/01/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Validacao do campo D3_CTURNO						          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Projeto A001/15 - Chamado: 312366 - X3_VLDUSER (D3_CTURNO) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³CHAMADO³ ALTERACAO 					          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               ³        ³       ³                         			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VLD3TURNO()

Local _lRet := .T.
Local _cTpTurno := Alltrim(GetNewPar("MV_TURNOTP","A"))

If _cTpTurno == "A"
	If !M->D3_CTURNO $ "ABCD"
		_lRet := .F.
		If IsTelNet()
			VTBEEP(3)
			VTALERT("Turno Invalido","AVISO",.T.,3500)
		Else
			MsgAlert("Turno Inválido. Informe Turno A, B, C ou D!")
		EndIf
	EndIf
Else
	If !M->D3_CTURNO $ "123"
		_lRet := .F.
		If IsTelNet()
			VTBEEP(3)
			VTALERT("Turno Invalido","AVISO",.T.,3500)
		Else
			MsgAlert("Turno Inválido. Informe Turno 1, 2, ou 3!")
		EndIf
	EndIf
EndIf

Return _lRet