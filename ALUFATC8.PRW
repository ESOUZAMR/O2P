#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"

// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATC8
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Estoque  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function ALUFATC8( nOpc , cCodPro , cDocRef , cEndLoca , QtdMov )

  Local oWsdl := WSIntegrationEngine():New()
  Local oCadastro
  Local oLista
  Local o2pUsuario   := Alltrim( Upper(GetMv("CE_URSCRWO")) ) 
  Local o2pSenha     := Alltrim( Upper(GetMv("CE_PSWCRWO")) ) 
  Local o2pOpc       := "Stock"
  Local o2pEventData := ""
  Local cQuery       := ""
  Local cTpDcRef     := ""
  Local timestamp    := Substr( Alltrim(DTOS(Ddatabase)),1,4) +"-"+ Substr( Alltrim(DTOS(Ddatabase)),5,2 ) +"-"+ Substr(Alltrim(DTOS(Ddatabase)),7,2) +" " + TIME()

  Local aHeadOut := {}
  Local cHeadRet := ""
  Local cPostRet := ""
  Local cMovEst  := ""

  //Saida tecnica para correcao de inconsistencia nos servidores da processware conversao de nil em decimal
  If QtdMov == nil
     QtdMov := 0
  EndIf 
    
  AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
  AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

  // Conecta no WS
  HTTPSetPass( o2pUsuario, o2pSenha )
  WSDLDbgLevel( 3 )

  if nOpc = "E"
    cTpDcRef := "OP"
  elseif nOpc = "S"
    cTpDcRef := "NF"
  elseif nOpc = "H"
    cMovEst := "H"
    nOpc    := "I"
  endif

  // senha do portal da O2P
  oWsdl:csUserId := o2pUsuario
  oWsdl:csEventId := o2pOpc

  	If SELECT("WSCB0") > 0
  		DBSELECTAREA("WSCB0")
  		DBCLOSEAREA("WSCB0")
  	Endif
  cQuery := " SELECT CB0_CODPRO, CB0_DTNASC, CB0_FILIAL, CB0_LOCAL, CB0_LOCALI, SUM(CB0_QTDE) CB0_QTDE, 'CROWN' CB0LOCAL "
  cQuery += " FROM " + RetSqlName("CB0") + " CB0 "
  cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 ON B1_FILIAL=CB0_FILIAL AND B1_COD=CB0_CODPRO AND B1.D_E_L_E_T_ = ' '
  cQuery += " WHERE CB0_LOCALI <> ' ' AND CB0_NFSAI = ' ' "
  if nOpc = 'E' .OR. nOpc = 'S' .OR. cMovEst = 'H'
    cQuery += " AND CB0_CODPRO = '"+ cCodPro +"' "
  endif
  if !empty(cEndLoca)
  	cQuery += " AND CB0_LOCALI = '"+ cEndLoca +"' "
  endif
  cQuery += " AND CB0_LOCAL IN ('01','90') AND CB0_TIPO = '01' AND B1_TIPO = 'PA' AND CB0.D_E_L_E_T_ = ' '
  cQuery += " GROUP BY CB0_CODPRO, CB0_DTNASC, CB0_FILIAL, CB0_LOCAL, CB0_LOCALI , 'CROWN'
  cQuery += " UNION ALL "
  cQuery += " SELECT PAH_A_PROD CB0_CODPRO, PAH_A_DTNS CB0_DTNASC, PAH_FILIAL CB0_FILIAL, PAH_A_ARM CB0_LOCAL, '0008' CB0_LOCALI, SUM(PAH_A_QTD) CB0_QTDE, 'EXTERNO' CB0LOCAL "
  cQuery += " FROM " + RetSqlName("PAH") + "  "
  cQuery += " WHERE PAH_A_ST = 'E' AND D_E_L_E_T_ = ' ' "
  if nOpc = 'E' .OR. nOpc = 'S' .OR. cMovEst = 'H'
    cQuery += " AND PAH_A_PROD = '"+ cCodPro +"' "
  endif
  cQuery += " GROUP BY PAH_A_PROD, PAH_A_DTNS, PAH_FILIAL, PAH_A_ARM, '0008', 'EXTERNO' "
  cQuery += " ORDER BY CB0_FILIAL, CB0_CODPRO, CB0_DTNASC, CB0_LOCAL, CB0_LOCALI "

  TcQuery cQuery New Alias "WSCB0"

  While !WSCB0->(EOF())

  	o2pEventData := '{' + ;
  				  '"ChangeDate":"'+ timestamp +'",' + ;           // <timestamp>
  				  '"matCode":"'+ Alltrim(WSCB0->CB0_CODPRO) +'",' + ;  // <string18>
  				  '"plant":"'+ Alltrim(WSCB0->CB0_FILIAL) +'",' + ;    // <string04>
  				  '"warehouse":"'+ Alltrim(WSCB0->CB0_LOCAL)  +'",' + ;// <string10>
  				  '"StorageLocation": "'+ iif(Alltrim(WSCB0->CB0_LOCALI)='HFI','HFI','') +'",' + ;
  				  '"position":"'+ Alltrim(WSCB0->CB0_LOCALI) +'",' + ; // <string10>
  				  '"quantity":"'+ Alltrim( Transform( WSCB0->CB0_QTDE , "99999999.999" )) +'",' + ;          // <integer>
  				  '"uom":"MI",'+ ;  // <string03>
  				  '"batch": "'+ Alltrim(WSCB0->CB0_CODPRO) + WSCB0->CB0_DTNASC +'",' + ;
  				  '"moviment":{'+ ;
  				  				'"type":"'+ Alltrim(nOpc) +'",' + ;  // <string01> E-Entrada / S-Saída / I-Inventário
  				  				'"docRefType":"'+ Alltrim(cTpDcRef) +'",' + ;  // <string02> OP ou NF
  				  				'"docRef":"'+ Alltrim(cDocRef) +'",' + ;  // cDocRef <string12>
  				  				'"Quantity":"'+ Alltrim( Transform( QtdMov , "99999999.999" )) +'"' + ;  // QtdMov <string12>
  				  				'}' + ;
  				    '}'

  				  o2pEventData := "<![CDATA[ [ "+ o2pEventData +" ] ]]>"
  				  oWsdl:csEventData := o2pEventData

  				  oWsdl:TriggerEvent()

  				  if !oWsdl:lTriggerEventResult
  				  	If oWsdl:csResultData <> nil
	  				  	conout( "Erro no processamento: " + oWsdl:csResultData )
	  				  	conout( "Erro no processamento: " + oWsdl:csResultCode )
	  				  	conout( "Erro no processamento: " + oWsdl:csResultMessage )
					EndIf
  				  else
  				  	conout( "Registro Integrado ao WS O2P, " + WSCB0->CB0_CODPRO  )
  				  endif

  	Memowrite("\system\O2P\"+ alltrim(CB0_FILIAL) +"_" + Alltrim(WSCB0->CB0_CODPRO) + "_" + Alltrim(WSCB0->CB0_LOCAL) + "_" + Alltrim(WSCB0->CB0_LOCALI) + "_ESTOQUE.json",o2pEventData)
    WSCB0->(dbSkip())
  EndDo
return