#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ALUEST39  ³AUTOR: ³Alex Borges            ³DATA: ³ 15/07/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€ŽO:³ Projeto A013/15.Ch326639 Geração de OP Adicional (OP Filha)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Estoque e Custos                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€ŽO INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alex Borges   ³21/08/15³ Chamado 329033. Não estava gerando Empenho	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Ricardo Lima  ³04/09/17³ Chamado 369903. Atualiza WS O2P com nova OP  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALUEST39()

Private nQtdDia   := GETMV("CE_QTDIAET")
Private dDataEtiq := sTod("")
Private dData     := dToS(date() - nQtdDia)
Private _numOP    := ""
Private cCadastro := "Abertura de OP Adicional"
Private aRotina   := { { "Pesquisar         "  ,"AxPesqui"   , 0 , 1 },;
					   { "Visualizar        "  ,"AxVisual"   , 0 , 2 },;
					   { "Gera OP Adicional "  ,"U_EST39GER" , 0 , 4 },;
				       { "Legenda           "  ,"U_EST39LEG" , 0 , 2 }}

_aCores := { {"Empty(SC2->C2_DATRF)  ", "BR_VERDE"    },;
             {"!Empty(SC2->C2_DATRF) ", "BR_VERMELHO" }}

dbSelectArea("SC2")
dbSetOrder(1)
dbGoTop()

_cFiltro :=	 " Empty(C2_A_OPFIL) .AND. C2_A_QTFIL > 0 .AND. C2_QUANT = C2_QUJE "

set filter to  &(_cFiltro)

mBrowse(6,1,22,75,"SC2",,,,,,_aCores)


Return


User Function EST39LEG()

Local _aLegenda := {{"BR_VERMELHO" , "Encerrada"  },;
					{"BR_VERDE"    , "Em Aberto" }}

BrwLegenda( "Status da Ordem de Producao" , "Status" , _aLegenda )

Return

User Function Est39Ger

If VldOP()
	If MsgYesNo("Deseja Continuar ?" ,"AVISO")
		Begin Transaction
			If Geraop()
				//Grava os registros de log
				dbSelectArea("PCI")
				dbSetOrder(1)
				If !dbSeek(xFilial("PCI")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					If PCI->(Reclock("PCI",.T.))
						PCI->PCI_FILIAL := xFilial("PCI")
						PCI->PCI_OPPAI  := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
						PCI->PCI_OPFILH := _numOP+SC2->C2_ITEM+SC2->C2_SEQUEN
						PCI->PCI_DATA   := Date()
						PCI->PCI_HORA   := Substr(Time(),1,5)
						PCI->PCI_QTDFIL := SC2->C2_A_QTFIL
						PCI->PCI_USUARI := Alltrim(cUserName)
						PCI->(MsUnlock())
					EndIf
				EndIf

				MsgInfo("Foi gerada a OP "+_numOP+SC2->C2_ITEM+SC2->C2_SEQUEN)

			Else
				DisarmTransaction()
				Return
			EndIf
		End Transaction
	EndIf
EndIf

Return

Static Function VldOP

lRet := .T.

//Verifica se ja foi geradalex.silvaa a OP filha
If !Empty(SC2->C2_A_OPFIL)
	Alert("OP filha ja foi gerada anteriormente. OP "+Alltrim(SC2->C2_A_OPFIL)+".")
	lRet := .F.
EndIf

If SELECT("TRBCB0") <> 0
	TRBCB0->(dbCloseArea())
EndIf

cQuery := "SELECT Max(CB0_DTNASC) ETIQ "
cQuery += "  FROM "+ RetSqlName("CB0")
cQuery += " WHERE CB0_FILIAL = '"+xFilial("CB0")+"' "
cQuery += "   AND CB0_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' "
cQuery += "   AND D_E_L_E_T_ <> '*' "

cQuery  := ChangeQuery(cQuery)
DbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRBCB0", .F., .F. )

DbSelectArea("TRBCB0")
Do While !Eof()
	dDataEtiq := TRBCB0->ETIQ
	TRBCB0->(dbSkip())
EndDo

//Verifica se a ultima etiqueta gerada esta a mais de x dias
If !Empty(dDataEtiq)
	If dDataEtiq < dData
		cMsg :="Não é possivel gerar OP Filha, pois a ordem de produção está a mais de "+Alltrim(Str(nQtdDia))+" dias sem imprimir etiqueta."+CHR(13)+CHR(10)
		cMsg += " A ultima etiqueta foi gerada dia "+dToc(sTod(dDataEtiq))+"."
		Alert(cMsg)
		lRet := .F.
	EndIf
EndIf

Return lRet


Static Function Geraop

_aMATA250 := {}
_cDoc     := ' '
lMSErroAuto := .F.
_cAlias := SC2->(GetArea())

_numOP := GetSX8Num("SC2","C2_NUM")

aMata650 := {{"C2_NUM"      ,_numOP           ,NIL},;
  			 {"C2_FILIAL"   ,xFilial("SC2")   ,NIL},;
			 {"C2_ITEM"     ,SC2->C2_ITEM     ,NIL},;
			 {"C2_SEQUEN"   ,SC2->C2_SEQUEN   ,NIL},;
			 {"C2_PRODUTO"  ,SC2->C2_PRODUTO  ,NIL},;
			 {"C2_LOCAL"    ,SC2->C2_LOCAL    ,NIL},;
			 {"C2_CLINHA"   ,SC2->C2_CLINHA   ,NIL},;
			 {"C2_CTURNO"   ,SC2->C2_CTURNO   ,NIL},;
			 {"C2_QUANT"    ,SC2->C2_A_QTFIL  ,NIL},;
			 {"C2_UM"       ,SC2->C2_UM       ,NIL},;
			 {"C2_CRWTM"    ,SC2->C2_CRWTM    ,NIL}}

MsgRun("Gerando OP Adicional...",,{|| msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3) })

If lMSErroAuto
	MostraErro()
	Return .F.
Else
	// Alex Borges - 21/08/15 -  Chamado 329033
	aAreaSC2 := SC2->(GetArea())
   	U_GeraEmpOP(.F.,SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
	RestArea(aAreaSC2)

	//Retorna o posicionamento da OP Pai
	RestArea(_cAlias)
	//Grava o numero da OP Filha na OP Pai
	If SC2->(Reclock("SC2",.F.))
		SC2->C2_A_OPFIL := _numOP+SC2->C2_ITEM+SC2->C2_SEQUEN
		SC2->(MsUnlock())
	EndIf
	// Ricardo Lima - 04/09/2017
	u_ALUEST71( _numOP , SC2->C2_NUM , SC2->C2_A_QTFIL )

EndIf

Return .T.