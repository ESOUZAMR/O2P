#INCLUDE "TOTVSWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATD0
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Webservice Server de Integracao para o Sistema O2P - PV  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################


WSSERVICE WS_ALUFATD0 DESCRIPTION "WS Pedido de Venda" NameSpace "protheusweb.crowncork.com.br:8091"
	WSDATA cUserID   AS string
	WSDATA sJsonO2P  AS string
	WSDATA cDadosSai AS string
	WSMETHOD PEDIDOVENDA DESCRIPTION "<b>Método que retorna o Numero do Pedido Gerado a partir de dados Recebidos"
ENDWSSERVICE

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß//
// METODO PARA RETORNAR OS PV INTEGRADO   //
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß//

WSMETHOD PEDIDOVENDA WSRECEIVE cUserID, sJsonO2P  WSSEND cDadosSai WSSERVICE WS_ALUFATD0

//Variaveis Locais
Local cJson
Local oObj
Local aCab   := {}
Local aItens := {}
Local nItem  := 0
Local _cPtaxD1 := ""
Local _nPerPtx := 0
Local _nNewPrc := 0
Local ctpPV    := "V"
Local _cCondPg := ""
Local _cCodTab := ""
Local _cEmpresa := ""
Local _cFilial  := ""
Local cTransp   := ""
local cCliente  := ""
Local cLoja     := ""
Local _cMenNF   := ""
Local _nQtdSC6  :=0
Local _lOpTri   := .F.
Local _nPrcUGrp := 0
Local _nPrcRGrp := 0
Local _cTes     := ""
Local _nPtxTab  := 0
Local NopcP     := 3
Local _oDadSai

Private _lExporta  := .F.
private _nUltPtx   := 0
Private lMSErroAuto := .F.
Private cPedido  := ""
Private PedidoMS := ""

RPCSETType(3) //Nao utiliza licenca
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" //Abro o ambiente Manaus

Begin transaction

cJson := sJsonO2P

if cUserID == GetMv("CE_USRWSO2")

	If FWJsonDeserialize(cJson,@oObj)

		// Empresa e Filial Recebido
		_cEmpresa := "01"
		_cFilial  := alltrim(oObj:plant)
        
		Conout("==> ALUFATD0 ["+DtoC(Date())+" - "+Time()+"] <===")
		//Reinicia o ambiente agora com a filial correta
		RESET ENVIRONMENT
		RPCSETType(3) //Nao utiliza licenca
		PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial

		Memowrite("\system\O2P\Pedido_Venda_"+ alltrim(oObj:Docid) + alltrim(oObj:action) +".json" , cJson )
        Conout(cJson)
		// recebe numero de pedido
		//cPedido := RetNumPVE()

		IF oObj:action = "I"
         Conout("Action = Incluir")
		 NopcP := 3
		 cPedido := RetNumPVE()
         Conout("Pedido Protheus: "+cPedido)
         
		 DbSelectArea("SC5")
		 DbSetOrder(6)
		 if DbSeek( xFilial("SC5") + alltrim( oObj:Docid ) )

		  	_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Pedido": "'+ SC5->C5_NUM +'", "Mensagem": "Pedido Ja Existe"}'

			::cDadosSai := _oDadSai
			DisarmTransaction()
			Return( .T. )
		 endif
		elseIF oObj:action = "C"
         Conout("Action = Alterar")
		 NopcP := 4

		 DbSelectArea("SC5")
		 DbSetOrder(6)
		 if !DbSeek( xFilial("SC5") + alltrim( oObj:Docid ) )

		  	_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Pedido": "'+ alltrim( oObj:Docid ) +'","Mensagem": "Pedido Nao Existe"}'

			::cDadosSai := _oDadSai
			DisarmTransaction()
			Return( .T. )
		 else
		  cPedido := SC5->C5_NUM
		  Conout("Pedido Protheus: "+cPedido)
		 endif
		elseIF oObj:action = "D"
         Conout("Action = Deletar")
		 NopcP := 5

		 DbSelectArea("SC5")
		 DbSetOrder(6)
		 if !DbSeek( xFilial("SC5") + alltrim( oObj:Docid ) )

		  	_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Pedido": "'+ alltrim( oObj:Docid ) +'","Mensagem": "Pedido Nao Existe"}'

			::cDadosSai := _oDadSai
			DisarmTransaction()
			Return( .T. )
		 else
		  cPedido := SC5->C5_NUM
		  Conout("Pedido Protheus: "+cPedido)
		 endif
		ENDIF

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek( xFilial("SA1") + Right( oObj:customer,6) )
		cCliente := SA1->A1_COD
		cLoja    := SA1->A1_LOJA
		_cPTaxD1 := SA1->A1_A_PTXD1
		_nPerPtx := SA1->A1_A_PEPTX
		_nUltPtx  := U_GETPTAX2(Date())

		If SA1->A1_EST == "EX"
			_lExporta := .T.

			If SM0->M0_CODIGO + SM0->M0_CODFIL == "0101"
				aadd(aCab,{"C5_A_LOEMB"   ,"13226"               ,nil})
			ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0102"
				aadd(aCab,{"C5_A_LOEMB"   ,"41173"               ,nil})
			ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0104"
				aadd(aCab,{"C5_A_LOEMB"   ,"42285"               ,nil})
			ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0105"
				aadd(aCab,{"C5_A_LOEMB"   ,"32441"               ,nil})
			ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0106"
				aadd(aCab,{"C5_A_LOEMB"   ,"23205"               ,nil})
			EndIf
		Else
			_lExporta := .F.
		EndIf

		AtuTabPrc( SA1->A1_COD , SA1->A1_LOJA , "1" , "" ) 
		dbSelectArea("TRBTab")                             
		                             
		Conout("Eh final de arquivo: "+IIF(TRBTab->(Eof()),"Sim","Não"))
		If TRBTab->(Eof())
			_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Tabela de Preço fora de vigência"}'
			::cDadosSai := _oDadSai
			DisarmTransaction()
            Return()
        EndIf    

		_cCondPg := TRBTab->ZR_CONDPAG
		_cCodTab := TRBTab->ZR_CODTAB


		if !empty(oObj:customerTriangulation)
		 ctpPV := "T"
		 _lOpTri := .T.
		 aadd(aCab,{"C5_CLIR"  ,Right( oObj:customerTriangulation,6) ,nil})
		 aadd(aCab,{"C5_LOJAR" ,"01" ,nil})
		endif

		aadd(aCab,{"C5_NUM"       ,cPedido           ,nil})
		aadd(aCab,{"C5_TIPO"      ,'N'               ,nil})
		aadd(aCab,{"C5_CLIENTE"   ,cCliente          ,nil})
		aadd(aCab,{"C5_LOJACLI"   ,cLoja             ,nil})
		aadd(aCab,{"C5_CRWTIPO"   ,ctpPV             ,nil})
		aadd(aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
		If _lExporta
			aadd(aCab,{"C5_TIPOCLI"   ,"X"           ,nil})
		Else
			aadd(aCab,{"C5_TIPOCLI"   ,"R"           ,nil})
		EndIf
		aadd(aCab,{"C5_CONDPAG"   ,_cCondPg          ,nil})
		aadd(aCab,{"C5_TABELA"    ,_cCodTab          ,nil})
		aadd(aCab,{"C5_TPFRETE"   ,iif(oObj:shipmentType="CIF","C","F") ,nil})
		aadd(aCab,{"C5_MENNOTA"   ,_cMenNF           ,nil})
		aadd(aCab,{"C5_TRANSP"    ,cTransp           ,nil})
		aadd(aCab,{"C5_NRPVO2P"   ,oObj:Docid        ,nil})

	for o:= 1 to len(oObj:itens)

		SB1->(dbSeek(xFilial("SB1") + Right( oObj:itens[o]:skucode,9) ))
		DA1->(dbSeek(xFilial("DA1") + _cCodTab + Right( oObj:itens[o]:skucode,9) ))

		_nQtdSC6 := val(oObj:itens[o]:quantity)

		AtuTabPrc( cCliente , cLoja , "2" , SB1->B1_COD  )
		dbSelectArea("TRBTab")

		_nPrcUGrp := TRBTab->PBS_A_PVUS //Preco em dolar sem impostos
		_nPrcRGrp := TRBTab->PBS_A_PVRL //Preco em reais sem impostos
		_cTes     := TRBTab->ZR_A_TES
		_nPtxTab  := TRBTab->ZR_PTAX

		If _cPTaxD1 == "S" //Usa PTAX D-1

			_nNewPrc := U_ALUFATA4( SB1->B1_COD , SB1->B1_GRUPO , _nPrcUGrp , _nPrcRGrp , _nUltPtx , _cTes , _nPtxTab ) //Calcula o preco em reais com base na PTAX do dia

			aadd(aItens,{{"C6_ITEM"  , strzero(++nItem,2)           ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                       ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                        ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,Iif(_lOpTri,_nQtdSC6,0)           ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc		 	                ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *_nNewPrc,2)       ,NIL},;
						{"C6_PRUNIT" ,_nNewPrc			                ,NIL},;
						{"C6_TES"    ,_cTes                             ,NIL},;
						{"C6_LOCAL"  ,"01"                              ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                      ,NIL}})
		ElseIf _cPTaxD1 == "M" //Usa PTAX D-1 Medio

			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia

			aadd(aItens,{{"C6_ITEM"  ,strzero(++nItem,2)               ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                       ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                        ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,Iif(_lOpTri,_nQtdSC6,0)           ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc		 	                ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *_nNewPrc,2)       ,NIL},;
						{"C6_PRUNIT" ,_nNewPrc			                ,NIL},;
						{"C6_TES"    ,_cTes                             ,NIL},;
						{"C6_LOCAL"  ,"01"                              ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                      ,NIL}})
		Else // "N" ou Vazio

			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)               ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                       ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                        ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,Iif(_lOpTri,_nQtdSC6,0)           ,NIL},;
						{"C6_PRCVEN" ,DA1->DA1_PRCVEN                   ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *DA1->DA1_PRCVEN,2),NIL},;
						{"C6_PRUNIT" ,DA1->DA1_PRCVEN                   ,NIL},;
						{"C6_TES"    ,_cTes                             ,NIL},;
						{"C6_LOCAL"  ,"01"                              ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                      ,NIL}})
		EndIf

	next

		lMSHelpAuto := .T.
		MSExecAuto({|x,y,z|Mata410(x,y,z)} , aCab , aItens , NopcP )

		lMSHelpAuto := .F.
		If lMSErroAuto
			_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "'+ MostraErro() +'"}'

			::cDadosSai := _oDadSai
			DisarmTransaction()
		else
			_oDadSai := WSClassNew("cDadosSai")

			IF oObj:action = "I"
				_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Inclusão realizada com sucesso!"}'
			elseIF oObj:action = "C"
				_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Alteração realizada com sucesso!"}'
			elseIF oObj:action = "D"
				_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Exclusão realizada com sucesso!"}'
			ENDIF

			::cDadosSai := _oDadSai
		ENDIF

	Endif

ENDIF

End transaction

Return( .T. )


// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : RetNumPVE
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Retorna o Numero do Pedido de Venda                      |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
Static Function RetNumPVE()

Local aArea := GetArea()
Local cNumPV := GetSx8Num("SC5")

//Verifica se o numero do pedido existe
While SC5->(dbSeek(xFilial("SC5")+cNumPV))
	cNumPV := soma1(alltrim(cNumPV))
End

RestArea(aArea)

Return cNumPV

// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : AtuTabPrc
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Retorna Dados da tabela de preco                         |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
Static Function AtuTabPrc( A1COD , A1LOJA , cOpc , cCodPro )

Local cQuery   := ""
Local cCliente := A1COD
Local cLoja    := A1LOJA

		If SELECT("TRBTab") > 0
			dbSelectArea("TRBTab")
			dbCloseArea()
		Endif

		cQuery  := " SELECT "
		cQuery	+= "     SZR.ZR_CODTAB, SZR.ZR_DATADE, SZR.ZR_DATAATE, SZR.ZR_CONDPAG, SZR.ZR_CLIENTE, SZR.ZR_LOJACLI, "
		cQuery	+= "     SZR.ZR_STATUS, SZR.ZR_A_TPFRE, SZR.ZR_A_TES, SZR.ZR_A_TES1, ZR_TESPIA, SZR.ZR_A_MENNF, SZR.ZR_A_FRETE, "
		cQuery	+= "     SZR.ZR_PTAX, SZR.ZR_A_TES2, SZS.ZS_ITEM, SZS.ZS_CODPRO, SZS.ZS_PRCVEN, DA1.DA1_PRCVEN, SZS.ZS_A_PEDCL, SZS.ZS_A_ITPCL, SZS.ZS_TESPRIO, "
		cQuery	+= "	 SA1.A1_COD, SA1.A1_LOJA, SA1.A1_EST, SA1.A1_A_PTXD1, SA1.A1_A_PEPTX, "
		cQuery	+= "	 B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO, "
		cQuery	+= "	 SBM.BM_GRUPO, SBM.BM_A_PCPTA, "
		cQuery	+= "	 PBS.PBS_A_CODT, PBS.PBS_A_CODG, PBS.PBS_A_PVUS, PBS.PBS_A_PVRL, PBS.PBS_A_PRUS, PBS.PBS_A_PRRL, PBS.PBS_A_TIPG, PBS.PBS_A_TPFR, PBS.PBS_A_VLPR, PBS.PBS_A_VLFR "
		cQuery	+= " FROM " + RetSQLName("SZR") + " SZR, " + RetSqlName("SZS") + " SZS, " + RetSqlName("DA0") + " DA0, " + RetSqlName("SA1") + " SA1, " + RetSqlName("SB1") + " B1, " + RetSqlName("SBM") + " SBM, " + RetSqlName("PBS") + " PBS, " + RetSqlName("DA1") + " DA1 "
		cQuery	+= " WHERE "
		cQuery	+= "     SZR.ZR_FILIAL  = '" + xFilial("SZR") + "'"
		cQuery	+= " AND SZS.ZS_FILIAL  = SZR.ZR_FILIAL"
		cQuery	+= " AND DA0.DA0_FILIAL = SZR.ZR_FILIAL"
		cQuery	+= " AND PBS.PBS_FILIAL = SZR.ZR_FILIAL"
		cQuery	+= " AND DA1.DA1_FILIAL = DA0.DA0_FILIAL"
		cQuery	+= " AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
		cQuery	+= " AND B1.B1_FILIAL   = SZR.ZR_FILIAL"
		cQuery	+= " AND SBM.BM_FILIAL  = B1.B1_FILIAL"
		cQuery	+= " AND SZS.ZS_CODTAB  = SZR.ZR_CODTAB"
		cQuery	+= " AND DA0.DA0_CODTAB = SZR.ZR_CODTAB"
		cQuery	+= " AND DA1.DA1_CODTAB = DA0.DA0_CODTAB"
		cQuery	+= " AND SA1.A1_COD     = SZR.ZR_CLIENTE"
		cQuery	+= " AND SA1.A1_LOJA    = SZR.ZR_LOJACLI"
		cQuery	+= " AND B1.B1_COD      = SZS.ZS_CODPRO"
		cQuery	+= " AND SBM.BM_GRUPO   = B1.B1_GRUPO"
		cQuery	+= " AND DA1.DA1_CODPRO = SZS.ZS_CODPRO"
		cQuery	+= " AND PBS.PBS_A_CODT = SZR.ZR_CODTAB"
		cQuery	+= " AND PBS.PBS_A_CODG = B1.B1_GRUPO"
		cQuery	+= " AND SZR.ZR_DATADE  <= '" + DTOS( dDatabase )+ "'"
		cQuery	+= " AND SZR.ZR_DATAATE >= '" + DTOS( dDatabase )+ "'"
		cQuery	+= " AND SZR.ZR_CLIENTE = '" + cCliente + "'"
		cQuery	+= " AND SZR.ZR_LOJACLI = '" + cLoja + "'"
		IF cOpc = "2"
			cQuery	+= " AND SZS.ZS_CODPRO = '"+ cCodPro +"' "
		ENDIF
		cQuery	+= " AND SZR.ZR_STATUS  = 'A'"
		cQuery	+= " AND SZR.D_E_L_E_T_ = ' '"
		cQuery	+= " AND SZS.D_E_L_E_T_ = ' '"
		cQuery	+= " AND DA0.D_E_L_E_T_ = ' '"
		cQuery	+= " AND SA1.D_E_L_E_T_ = ' '"
		cQuery	+= " AND B1.D_E_L_E_T_  = ' '"
		cQuery	+= " AND SBM.D_E_L_E_T_ = ' '"
		cQuery	+= " AND PBS.D_E_L_E_T_ = ' '"
		cQuery	+= " AND DA1.D_E_L_E_T_ = ' '"
		cQuery	+= " GROUP BY "
		cQuery	+= "     SZR.ZR_CODTAB, SZR.ZR_DATADE, SZR.ZR_DATAATE, SZR.ZR_CONDPAG, SZR.ZR_CLIENTE, SZR.ZR_LOJACLI, "
		cQuery	+= "     SZR.ZR_STATUS, SZR.ZR_A_TPFRE, SZR.ZR_A_TES, SZR.ZR_A_TES1, ZR_TESPIA, SZR.ZR_A_MENNF, SZR.ZR_A_FRETE, "
		cQuery	+= "     SZR.ZR_PTAX, SZR.ZR_A_TES2, SZS.ZS_ITEM, SZS.ZS_CODPRO, SZS.ZS_PRCVEN, DA1.DA1_PRCVEN, SZS.ZS_A_PEDCL, SZS.ZS_A_ITPCL, SZS.ZS_TESPRIO, "
		cQuery	+= "	 SA1.A1_COD, SA1.A1_LOJA, SA1.A1_EST, SA1.A1_A_PTXD1, SA1.A1_A_PEPTX, "
		cQuery	+= "	 B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO, "
		cQuery	+= "	 SBM.BM_GRUPO, SBM.BM_A_PCPTA, "
		cQuery	+= "	 PBS.PBS_A_CODT, PBS.PBS_A_CODG, PBS.PBS_A_PVUS, PBS.PBS_A_PVRL, PBS.PBS_A_PRUS, PBS.PBS_A_PRRL, PBS.PBS_A_TIPG, PBS.PBS_A_TPFR, PBS.PBS_A_VLPR, PBS.PBS_A_VLFR "
		cQuery	+= " ORDER BY "
		cQuery	+= "     SZS.ZS_CODPRO"

		Memowrite("\system\ALUFATD0.sql" , cQuery )

		cQuery	:= ChangeQuery( cQuery )

		dbUseArea(.T., "TopConn", TCGenQry(, , cQuery), "TRBTab", .F., .F. )

		dbSelectArea("TRBTab")


Return( .T. )