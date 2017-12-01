#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"

// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATD1
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Produto  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function ALUFATD1( cAlt )

  Local oWsdl         := WSIntegrationEngine():New()
  Local o2pUsuario    := Alltrim( Upper(GetMv("CE_URSCRWO")) )
  Local o2pSenha      := Alltrim( Upper(GetMv("CE_PSWCRWO")) )
  Local o2pOpc        := "Material"
  Local o2pEventData  := " "
  Local cQuery        := ""
  Local cQuery2       := ""
  Local cQuery3       := ""
  Local cQuery4       := ""
  Local o2pDataA7     := ""
  Local o2pDataA1     := ""
  Local o2pData2A7    := ""
  Local cCodSB1       := ""
  
  Local aHeadOut := {}
  Local cHeadRet := ""
  Local cPostRet := ""
  Local cDescType := ""
  Local cVerDesc  := ""
  Local cPosVl
  Local cDtprod
  Local cDesSB1 := ""
  
  
//Conout("...:ALUFATD0:...")
//Conout(DtoC(Date())+" - "+Time())


  AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
  AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

  // Conecta no WS
  HTTPSetPass( o2pUsuario, o2pSenha)
  WSDLDbgLevel( 3 )

  oWsdl:csUserId := o2pUsuario
  oWsdl:csEventId := o2pOpc

  	If SELECT("WSSB1") > 0
  		DBSELECTAREA("WSSB1")
  		DBCLOSEAREA("WSSB1")
  	Endif

  cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC, B1_MSBLQL, PBU_A_DESP, B1_TIPO, B1_UM, ZZL_DESC, B1_A_VEXTE, B1_A_BLQOP, B1_USERLGI, BM_A_TIPO, B1_A_OKCOM, B1_A_FIS, B1_A_OKLOG, B1_A_OKCON, B1_A_NRART "
  cQuery += " FROM "+ RetSqlName("SB1") +" B1 "
  cQuery += " INNER JOIN "+ RetSqlName("SBM") +" SBM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND SBM.D_E_L_E_T_ = ' ' "
  cQuery += " INNER JOIN "+ RetSqlName("PBU") +" PBU ON PBU_FILIAL=BM_FILIAL AND PBU_A_COD=BM_A_SUBG AND PBU.D_E_L_E_T_ = ' ' "
  cQuery += " INNER JOIN "+ RetSqlName("ZZL") +" ZZL ON ZZL_CODIGO=B1_A_VOLUM AND ZZL.D_E_L_E_T_ = ' ' "
  cQuery += " WHERE B1_TIPO = 'PA' "
//  cQuery += " AND B1_MSBLQL <> '1' "
  if !empty(cAlt)
  	cQuery += " AND B1_COD = '"+ cAlt +"' "
  ENDIF
  cQuery += " AND B1.D_E_L_E_T_ = ' ' "
  cQuery += " ORDER BY B1_COD "

  	TcQuery cQuery New Alias "WSSB1"

  Memowrite( "\system\O2P\MATERIAL.SQL" , cQuery )

While !WSSB1->(EOF())

 if alltrim(cCodSB1) <> alltrim(WSSB1->B1_COD)

 	if upper( Alltrim(WSSB1->ZZL_DESC)) $ "SM"
 		cDescType := 'Small'
 	elseif Upper( Alltrim(WSSB1->ZZL_DESC) ) $ "SL"
 		cDescType := 'Sleek'
 	else
 		cDescType := 'Standard'
 	endif

 	if WSSB1->B1_A_VEXTE = '1'
 		cVerDesc := "Fosco"
 	Elseif WSSB1->B1_A_VEXTE = '2'
 		cVerDesc := "Brilho"
 	Elseif WSSB1->B1_A_VEXTE = '3'
 		cVerDesc := "Tactil"
 	endif

 	cDtprod := dtos(ctod(FWLeUserlg("WSSB1->B1_USERLGI", 2)))
 	if !empty(cDtprod)
 		cDtprod := substr(cDtprod,1,4)+"-"+substr(cDtprod,5,2)+"-"+substr(cDtprod,7,2)+"T00:00:00"
 	else
 		cDtprod := "2000-01-01T00:00:00"
 	endif

 	cPosVl := At( 'oz', alltrim(WSSB1->ZZL_DESC) )

 	cDesSB1 := StrTran( WSSB1->B1_DESC , '"', "" )

  	o2pEventData := '{' + ;
  					'"code": "'+ Alltrim(WSSB1->B1_COD) +'",' + ;  									// <string18>
  					'"description": "'+ Substr(ALLTRIM(cDesSB1),1,40) +'",' + ;       				// <string40>
  					'"active": "'+ IIF( WSSB1->B1_MSBLQL='1' , 'false' , 'true' ) +'",' + ;			// <boolean> true or false
  					'"beer": "'+ IIF( ALLTRIM(WSSB1->PBU_A_DESP) $ "CERVEJA" , 'true' , 'false' ) +'",' + ;	// <boolean> true or false
  					'"type": "'+ Alltrim(cDescType) +'",' + ;  										// <string10>
  					'"uom": "'+ Alltrim(WSSB1->B1_UM) +'",' + ;  									// <string3>
  					'"volume": "'+ Substr(Alltrim(WSSB1->ZZL_DESC),1,cPosVl-1) +'",' + ;			// <string6>
  					'"volumeUom": "OZ",' + ;														// <string6>
  					'"width": "00000000",' + ;    													// <string8>
  					'"packingtype": "'+ IIF( WSSB1->BM_A_TIPO = 'T' , 'Tampa' , 'Lata' ) +'",' + ;	// <string10>
  					'"varnish": "'+ cVerDesc +'",' + ;   											// <string10>
  					'"ProductionBlocked": "'+ IIF( WSSB1->B1_A_BLQOP = 'S' , 'true' , 'false' ) +'",' + ;  // <boolean> true or false
  					'"stockBlocked": "'+ IIF( WSSB1->B1_MSBLQL = '1' , 'true' , 'false' ) +'",' + ; // <boolean>  true or false
  					'"CommercialRelease": "'+ IIF( WSSB1->B1_A_OKCOM = '1' , 'true' , 'false' ) +'",' + ;
  					'"FiscalRelease": "'+ IIF( WSSB1->B1_A_FIS = '1' , 'true' , 'false' ) +'",' + ;
  					'"LogisticsRelease": "'+ IIF( WSSB1->B1_A_OKLOG = '1' , 'true' , 'false' ) +'",' + ;
  					'"ControllerRelease": "'+ IIF( WSSB1->B1_A_OKCON = '1' , 'true' , 'false' ) +'",' + ;
  					'"artNumber": "'+ WSSB1->B1_A_NRART+'",' + ;  									// <string>
  					'"creationDate": "'+ cDtprod +'",' + ;											// <datetime>
  						'"materialCustomerList":['

  	If SELECT("WSSA7") > 0
  		DBSELECTAREA("WSSA7")
  		DBCLOSEAREA("WSSA7")
  	Endif

  	cQuery2 := " SELECT DISTINCT A7_CLIENTE, A1_MSBLQL "
  	cQuery2 += " FROM "+ RetSqlName("SA7") +" A7 "
  	cQuery2 += " INNER JOIN "+ RetSqlName("SA1") +" A1 ON A1_COD=A7_CLIENTE AND A1.D_E_L_E_T_ = ' ' "
  	cQuery2 += " WHERE A7_PRODUTO = '"+ Alltrim(WSSB1->B1_COD) +"' AND A7.D_E_L_E_T_ = ' ' "
  	If Alltrim(funname()) = 'MATA370' //Se for Produto X Cliente
	  	If !INCLUI .AND. !ALTERA // Verifica se é exclusao
	  		cQuery2 += " AND A7_CLIENTE NOT IN ( '"+SA7->A7_CLIENTE+"') "
	  	EndIf
	EndIf
  	cQuery2 += " ORDER BY A7_CLIENTE "
  	TcQuery cQuery2 New Alias "WSSA7"

  	While !WSSA7->(EOF())
  		o2pDataA7 += '{"customer": "'+ WSSA7->A7_CLIENTE +'","active": "'+ IIF( WSSA7->A1_MSBLQL='2' , 'true' , 'false' ) +'"},'
  	  WSSA7->(dbSkip())
    EndDo
    o2pDataA7 := substr(alltrim(o2pDataA7),1,len(alltrim(o2pDataA7)) -1)

  	o2pEventData +=	o2pDataA7
  	o2pEventData +=						    '],' + ;
  						'"materialPlantList":['

  	If SELECT("WSB1") > 0
  	DBSELECTAREA("WSB1")
  	DBCLOSEAREA("WSB1")
  	Endif

  	cQuery3 := " SELECT B1_FILIAL, B1_COD, B1_LOCPAD, B1_A_CURVA "
  	cQuery3 += " FROM "+ RetSqlName("SB1") +" "
  	cQuery3 += " WHERE B1_COD = '"+ Alltrim(WSSB1->B1_COD) +"' AND D_E_L_E_T_ = ' ' "
  	TcQuery cQuery3 New Alias "WSB1"

  	While !WSB1->(EOF())
  		o2pDataA1 += '{"plant": "'+ WSB1->B1_FILIAL +'","warehouseDefaul": "'+ WSB1->B1_LOCPAD +'","AbcCurve": "'+ WSB1->B1_A_CURVA +'"},'
  		WSB1->(dbSkip())
    EndDo
    o2pDataA1 := Substr(ALLTRIM(o2pDataA1),1,len(ALLTRIM(o2pDataA1)) -1)

  	o2pEventData += o2pDataA1
  	o2pEventData += 					 '],' + ;
  						'"materialCustomerPlantList":['

  	If SELECT("WSA7") > 0
  	DBSELECTAREA("WSA7")
  	DBCLOSEAREA("WSA7")
  	Endif

  	cQuery4 := " SELECT DISTINCT A7_CLIENTE, A7_FILIAL "
  	cQuery4 += " FROM "+ RetSqlName("SA7") +" A7 "
  	cQuery4 += " INNER JOIN "+ RetSqlName("SA1") +" A1 ON A1_COD=A7_CLIENTE AND A1.D_E_L_E_T_ = ' ' "
  	cQuery4 += " WHERE A7_PRODUTO = '"+ Alltrim(WSSB1->B1_COD) +"' "
  	If Alltrim(funname()) = 'MATA370' //Se for Produto X Cliente
  		If !INCLUI .AND. !ALTERA // Verifica se é exclusao
  			cQuery4 += " AND A7_CLIENTE NOT IN ( '"+SA7->A7_CLIENTE+"') "
  		EndIf
  	EndIf
  	cQuery4 += " AND A7.D_E_L_E_T_ = ' ' "
  	cQuery4 += " ORDER BY A7_CLIENTE, A7_FILIAL "
  	TcQuery cQuery4 New Alias "WSA7"

  	While !WSA7->(EOF())
  		o2pData2A7 += '{"customer": "'+ WSA7->A7_CLIENTE +'","plant": "'+ WSA7->A7_FILIAL +'"},'
  		WSA7->(dbSkip())
    EndDo
    o2pData2A7 := Substr(ALLTRIM(o2pData2A7),1,len(ALLTRIM(o2pData2A7)) -1)

  	o2pEventData += o2pData2A7
  	o2pEventData +=								']' + ;
  					'}'

  				  o2pEventData := "<![CDATA[ [ "+ o2pEventData +" ] ]]>"
  				  oWsdl:csEventData := o2pEventData

  				  Memowrite("\system\O2P\"+ Alltrim(WSSB1->B1_COD) +"_MATERIAL.json",o2pEventData)

  				  /* Realiza a integracao no WS do O2P */
  				  oWsdl:TriggerEvent()

  				  if !oWsdl:lTriggerEventResult
  				  	If oWsdl:csResultData <> nil
  				  		conout( "Erro no processamento: " + oWsdl:csResultData )
  				  		conout( "Erro no processamento: " + oWsdl:csResultCode )
  				  		conout( "Erro no processamento: " + oWsdl:csResultMessage )
  				  	EndIf
  				  	conout( "Erro no processamento: " + WSSB1->B1_COD + " " + ALLTRIM(SUBSTR(WSSB1->B1_DESC,1,40)) )
  				  else
  				  	DbSelectArea("SB1")
  				  	DbSetOrder(1)
  				  	if DbSeek( xFilial("SB1") + WSSB1->B1_COD  )
  				  	  RecLock("SB1")
  				  	   SB1->B1_XO2PINT := '1'
  				  	  MsUnlock()
  				  	endif
  				  	conout( "Registro Integrado ao WS O2P, Material: " + WSSB1->B1_COD + " " + ALLTRIM(SUBSTR(WSSB1->B1_DESC,1,40)) )
  				  endif

    cCodSB1      := WSSB1->B1_COD
    WSSB1->(dbSkip())
    o2pDataA7    := ""
    o2pDataA1    := ""
    o2pData2A7   := ""
    o2pEventData := ""
 else

  WSSB1->(dbSkip())
 endif
Enddo               


//Conout("...:ALUFATD1:...")
//Conout(DtoC(Date())+" - "+Time())
//Conout("...:ALUFATD1 - THE END:...")
return