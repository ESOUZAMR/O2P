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

WSSERVICE WS_ALUFATD0 DESCRIPTION "WS Pedido de Venda" NameSpace "192.168.10.210:8092"
	WSDATA cUserID   AS string
	WSDATA sJsonO2P  AS string
	WSDATA cDadosSai AS string
	WSMETHOD PEDIDOVENDA DESCRIPTION "<b>M�todo que retorna o Numero do Pedido Gerado a partir de dados Recebidos"
ENDWSSERVICE

// #########################################
// METODO PARA RETORNAR OS PV INTEGRADO   ||
// #########################################


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
Local nTotItem := 0    
Local nMoeda   := 1
Local cLoja    := "01"
Local cBlqCred:= ""

Private _lExporta  := .F.
private _nUltPtx   := 0
Private lMSErroAuto := .F.
Private cPedido  := ""
Private PedidoMS := ""

RPCSETType(3) //Nao utiliza licenca
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" //Abro o ambiente Manaus

Conout("...:ALUFATD0:...")
Conout(DtoC(Date())+ " - " + Time())


//Begin transaction

cJson := sJsonO2P

If cUserID == GetMv("CE_USRWSO2")
	Conout("Autenticou o usuario => "+cUserID)
	
	If FWJsonDeserialize(cJson,@oObj)
		Conout("Fez o deserialize do json:"+ cJson)
		
		// Empresa e Filial Recebido
		_cEmpresa := "01"
		_cFilial  := alltrim(oObj:plant)
		
		//Reinicia o ambiente agora com a filial correta
		RESET ENVIRONMENT
		RPCSETType(3) //Nao utiliza licenca
		PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial
		
		Memowrite("\system\O2P\Pedido_Venda_"+ alltrim(oObj:Docid) + alltrim(oObj:action) +".json" , cJson )
		
		// recebe numero de pedido
		//cPedido := RetNumPVE()
		
		If oObj:action = "I"
			
			NopcP := 3
			cPedido := RetNumPVE()
			
			DbSelectArea("SC5")
			DbSetOrder(6)
			If DbSeek( xFilial("SC5") + alltrim( oObj:Docid ) )
				
				_oDadSai := WSClassNew("cDadosSai")
				Conout("Pedido: " + alltrim( oObj:Docid ))
				_oDadSai := '{"Pedido": "'+ SC5->C5_NUM +'", "Mensagem": "Pedido Ja Existe"}'
				
				::cDadosSai := _oDadSai
				//DisarmTransaction()
				Return( .T. )
			endif
		elseIF oObj:action = "C"
			
			NopcP := 4
			
			// Verifica se existe o DocId da O2P no campo
			DbSelectArea("SC5")
			DbSetOrder(6)
			if !DbSeek( xFilial("SC5") + alltrim( oObj:Docid ) )
				
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"Pedido": "'+ alltrim( oObj:Docid ) +'","Mensagem": "Pedido Nao Existe"}'
				
				::cDadosSai := _oDadSai
				//DisarmTransaction()
				Return( .T. )
			else
				cPedido := SC5->C5_NUM     // N�o esta fazendo nada
			endif
		elseIF oObj:action = "D"
			
			NopcP := 5
			
			DbSelectArea("SC5")
			DbSetOrder(6)
			if !DbSeek( xFilial("SC5") + alltrim( oObj:Docid ) )
				
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"Pedido": "'+ alltrim( oObj:Docid ) +'","Mensagem": "Pedido Nao Existe"}'
				
				::cDadosSai := _oDadSai
				//DisarmTransaction()
				Return( .T. )
			else
				cPedido := SC5->C5_NUM
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
		
		//If TRBTab->(EOF())                 
		//	_oDadSai := WSClassNew("cDadosSai")
		//	_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Tabela de Preco fora de vigencia"}'
		//	::cDadosSai := _oDadSai
	    //		
		//	Conout(::cDadosSai) 
		//	Conout("==> N�o h� retono na query, verifique!!! <==")		
		//EndIf                                                   
		////////////////////////////////////////////
		// =============================================
		// inicio da tratativa para avalia��o de cr�dito
		// =============================================
		// Busca tabela de pre�o no cadastro de Cliente
		dbSelectArea("SA1")
		dbSetOrder(1)            
		If SA1->A1_MSBLQL=="1"
			_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Mensagem": "Cliente bloqueado."}'
			::cDadosSai := _oDadSai   
			Return(.T.)                                  
		EndIf
			
		If !SA1->(dbSeek(xFilial("SA1") + Right( alltrim(oObj:Customer),6 ) ) )
			//oResult:SetValue("300","","Customer not found!")
			_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Mensagem": "Cliente n�o encontrado. [SA1]"}'
			::cDadosSai := _oDadSai   
			Return(.T.)
		Else
			// Procura a tabela de pre�o atrelada ao cliente para validar a vig�ncia
			//----------------------------------------------------------------------
			If Empty(SA1->A1_TABELA)
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"Mensagem": "Cliente sem tabela de pre�o. [SA1]"}'
				::cDadosSai := _oDadSai  
				Return(.T.)
			EndIf      		
				dbSelectArea("DA0")
				dbSetOrder(1)
				If DA0->(dbSeek(xFilial("DA0")+SA1->A1_TABELA))
					cTabPrc := SA1->A1_TABELA
					_cFilial := Right(alltrim(oObj:plant),2)
					While !DA0->(EOF()) .AND. DA0->DA0_CODTAB == cTabPrc .AND. DA0->DA0_FILIAL=_cFilial
					 	// Verifica se h� uma tabela sobre vig�ncia
					 	//-----------------------------------------
					 	If Date() >= DA0->DA0_DATDE .AND. Date() <= DA0->DA0_DATATE .AND. Time() >= DA0->DA0_HORADE .AND. Time() <= DA0->DA0_HORATE
					 		lVigente := .T.
					 		Exit
					 	Else
					 		DA0->(dbSkip())
					 	EndIf
					End
					If !lVigente
						// Retorna erro na tabela de pre�o
						//--------------------------------
						//oResult:SetValue("700","","price table does not exist or is out of date!")
						//_Retorno := "price table does not exist or is out of date!"
						_oDadSai := WSClassNew("cDadosSai")
						_oDadSai := '{"Mensagem": "Tabela de Pre�o n�o existe ou fora de vig�ncia. [DA0]"}'
						::cDadosSai := _oDadSai
						//"Tabela de Pre�o n�o existe ou fora de vig�ncia."
					Else
						For nX := 1 to Len(oObj:itens)
							dbselectArea("SB1")
							dbSetOrder(1)
							If !SB1->(dbseek(xFilial("SB1") + Right( alltrim(oObj:itens[nx]:skuCode),9) ) )
								_oDadSai := WSClassNew("cDadosSai")
								_oDadSai := '{"Mensagem": "C�digo de Produto inv�lido.'+Right( alltrim(oObj:itens[nx]:skuCode),9)+'"}'
								::cDadosSai := _oDadSai 
								Return(.T.)
						    EndIf     
						    
						    dbSelectArea("DA1")
						    dbSetOrder(1)
						    If dbSeek(xFilial("DA1")+SA1->A1_TABELA+Right( alltrim(oObj:itens[nx]:skuCode),9 ))
								nTotItem += Val(oObj:itens[nx]:quantity)* DA1->DA1_PRCVEN
							EndIf	
						Next nX


					EndIf
				EndIf
            EndIf

			// Executa a consulta de credito
			// ------------------------------
			Conout("======[Analise de Credito]======")
			Conout(oObj:Customer)
			Conout(cLoja)
			Conout(Str(nTotItem))
			Conout(Str(nMoeda))
			Conout(cFilial)
			Conout("================================")
			lCredOk := MaAvalCred( Right( alltrim(oObj:Customer),6) , cLoja, nTotItem, nMoeda, .T., @cBlqCred )
			If !lCredOk //.AND. lVigente
				//oResult:SetValue("200","true","credit analysis aproved")
				//_Retorno := "credit analysis aproved" 
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"Mensagem": "Analise de Credito Reprovada.'+Right( alltrim(oObj:itens[nx]:skuCode),9)+'"}'
				::cDadosSai := _oDadSai
				//oResult := WSClassNew("_Retorno")
				//oResult := '{"analise":true,"mensagem":"Analise de Credito Aprovada."}'
				//::_Retorno := oResult
				Return(.T.)
			EndIf
		///////////////////////////////////////////
		
		If oObj:action $ "C/D" .AND. !VldPedOE(cPedido,"")
			Conout("Existe Ordem de Embarque para esse Pedido") 
			_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Existe Ordem de Embarque para esse Pedido"}'
			::cDadosSai := _oDadSai
			//DisarmTransaction()
			
		Else
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
					
					aadd(aItens,{	{"C6_ITEM"  , strzero(++nItem,2)           ,NIL},;
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
					
					aadd(aItens,{	{"C6_ITEM"  ,strzero(++nItem,2)               ,NIL},;
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
					
					aadd(aItens,{	{"C6_ITEM"   ,strzero(++nItem,2)               ,NIL},;
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
			lAutoErrNoFile := .T.
			lMSHelpAuto := .T.
			MSExecAuto({|x,y,z|Mata410(x,y,z)} , aCab , aItens , NopcP )
			
			lMSHelpAuto := .F.   
			
			If lMSErroAuto
				cMsgExec := "Erro(s) na gera��o do pedido de venda: "+ cPedido+"  - " + XCONVERRLOG(GetAutoGrLog())
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "'+cMsgExec+'"}'
				conout(cMsgExec)    
				for no := 1 to Len(GetAutoGrLog())
				   Conout(Str(no)+" - "+GetAutoGrLog()[no])
				Next no             
				Conout('----------[MostraErro()]-----------------------')
				Conout(mostraErro())
				Conout('----------[MostraErro()]-----------------------')
				::cDadosSai := _oDadSai
				//DisarmTransaction()    				
			else
				_oDadSai := WSClassNew("cDadosSai")
				
				IF oObj:action = "I"
					_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Pedido inclu�do com sucesso!"}'
				elseIF oObj:action = "C"
					_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Pedido alterado com sucesso!"}'
				elseIF oObj:action = "D"
					_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Pedido deletado com sucesso!"}'
				ENDIF
				Conout(_oDadSai)
				::cDadosSai := _oDadSai
			ENDIF
			
		Endif
	Else
		_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Erro no Json!"}'
		::cDadosSai := _oDadSai
	EndIf
Else
	_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "Usuario n�o autenticado."}'
	::cDadosSai := _oDadSai
ENDIF

//End transaction

//Conout("...:ALUFATD0:...")
Conout("...:ALUFATD0 - THE END:...")

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

conout(cQuery)

dbUseArea(.T., "TopConn", TCGenQry(, , cQuery), "TRBTab", .F., .F. )

dbSelectArea("TRBTab")


Return( .T. )


// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : AtuTabPrc
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 08/11/17 | Eduardo Souza     | Verifica se existem OEs para pedidos.                    |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

Static Function VldPedOE(_cPed,_cItPed)

Local _cRet := .T.
Local _cQuery := ""
Local _cArea := GetArea()
Local _aOE := {}
Local _cEOL := Chr(13)+Chr(10)

//Valida se ja existe o alias
If Select("TRBEXCP") > 0
	TRBEXCP->(dbCloseArea())
EndIf

//If Alltrim( FunName() ) = "MATA410"

_cQuery := " SELECT DISTINCT ZZJ_A_OE FROM " +RetSqlName("ZZJ")
_cQuery += "  WHERE ZZJ_FILIAL ='"+ xFilial("ZZJ") + "' "
_cQuery += "  AND ZZJ_A_PED = '" + _cPed + "' "
if alltrim(_cItPed)<>""
	_cQuery += "  AND ZZJ_A_ITPE = '" + _cItPed + "' "
endif
_cQuery += "  AND D_E_L_E_T_ <> '*' "

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TRBEXCP",.T.,.T.)

TRBEXCP->(dbGoTop())
While TRBEXCP->(!Eof())
	
	aadd(_aOE,strzero(ZZJ_A_OE,6,0))
	
	TRBEXCP->(dbskip())
end

if Len(_aOE)>0
	
	_cMSG:= ""
	for I:= 1 to Len(_aOE)
		_cMsg +=" " + _aOE[I] + _cEOL
		Conout("Ordens de Embarque: "+_aOE[I])
	Next  
	_oDadSai := WSClassNew("cDadosSai")
	_oDadSai := '{"Pedido": "'+ cPedido +'","Mensagem": "'+CRH(34)+'"Este Pedido possui ordens de embarque, nao sera excluido "' +_cEol +'"Orden(s) de Embarque: "' + _cMsg+CHR(34)+'}'
	::cDadosSai := _oDadSai
	
	//aviso("Ordem de Embarque","Este Pedido possui ordens de embarque, nao sera excluido " +_cEol +"Orden(s) de Embarque: " + _cMsg,{"OK"})
	_cRet := .F.
	
endif
//endif

Restarea(_cArea)

Return(_cRet)

// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : XCONVERRLOG
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 08/11/17 | Eduardo Souza     | Converte errorlog para composi��o do Json para O2P.      |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

STATIC FUNCTION XCONVERRLOG(aAutoErro)
			
LOCAL cRet := ""
LOCAL nX := 1
		
FOR nX := 1 to Len(aAutoErro)
	cRet += aAutoErro[nX]+CHR(13)+CHR(10)
NEXT nX
				
RETURN cRet
