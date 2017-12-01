#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"
// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATC6
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - Cliente  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function ALUFATC6( cCli )

  Local oWsdl        := WSIntegrationEngine():New()
  Local oCadastro
  Local oLista
  Local o2pUsuario   := Alltrim( Upper(GetMv("CE_URSCRWO")) ) 
  Local o2pSenha     := Alltrim( Upper(GetMv("CE_PSWCRWO")) ) 
  Local o2pOpc       := "Customer"
  Local o2pEventData := " "
  Local cQuery       := ""

  Local aHeadOut := {}
  Local cHeadRet := ""
  Local cPostRet := ""
                                                                
  Conout("...: ALUFATC6 :...")
  Conout(cUrl)
  Conout(Dtoc(Date()))
  AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
  AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

  // Conecta no WS
  HTTPSetPass( o2pUsuario, o2pSenha )
  WSDLDbgLevel( 3 )

  oWsdl:csUserId := o2pUsuario
  oWsdl:csEventId := o2pOpc

  	If SELECT("WSSA1") > 0
  		DBSELECTAREA("WSSA1")
  		DBCLOSEAREA("WSSA1")
  	Endif

  cQuery := " SELECT A1_COD, A1_NOME, A1_NREDUZ, A1_END, A1_CEP, A1_MUN, A1_EST, A1_PAIS, YA_SIGLA, A1_DDD, A1_TEL, A1_CGC, A1_RISCO, A1_MSBLQL, A1_GRPCLI, ACY_A_NOME "
  cQuery += " FROM " + RetSqlName("SA1") + " A1 "
  cQuery += " INNER JOIN "+ RetSqlName("SYA") +" YA ON YA_FILIAL=A1_FILIAL AND YA_CODGI=A1_PAIS AND YA.D_E_L_E_T_ = ' ' "
  cQuery += " LEFT OUTER JOIN "+ RetSqlName("ACY") +" CY ON ACY_FILIAL=A1_FILIAL AND ACY_GRPVEN=A1_GRPCLI AND CY.D_E_L_E_T_ = ' ' "
  cQuery += " WHERE A1.D_E_L_E_T_ = ' ' "
  if !empty(cCli)
   cQuery += " AND A1_COD = "+ cCli +" "
  endif
  cQuery += " ORDER BY A1_COD "

  TcQuery cQuery New Alias "WSSA1"
                
  Conout(cQuery)
  While !WSSA1->(EOF())

  	o2pEventData := '{' + ;
  				  '"code":"' + WSSA1->A1_COD  + '",' + ;  // <string10>
  				  '"description":"' + Substr(Alltrim(WSSA1->A1_NOME),1,35) + '",' + ;  // <string35>  
  				  '"commercialDescription":"' + Substr(Alltrim(WSSA1->A1_NREDUZ),1,35) + '",' + ;  // <string35>
  				  '"address":"' + Substr(Alltrim(WSSA1->A1_END),1,35)  + '",' + ;  // <string35>
  				  '"zipCode":"' + Alltrim(WSSA1->A1_CEP)  + '",' + ;  // <string10>
  				  '"city":"' + Alltrim(WSSA1->A1_MUN)  + '",' + ;  // <string35>
  				  '"state":"' + Alltrim(WSSA1->A1_EST)  + '",' + ;  // <string3>
  				  '"country":"' + Alltrim(WSSA1->YA_SIGLA) + '",' + ;  // <string3>
  				  '"phone":"' + "(" + Alltrim(WSSA1->A1_DDD) + ")" + Alltrim(WSSA1->A1_TEL) + '",' + ;  // <string16>
  				  '"fiscalId":"' + Alltrim(WSSA1->A1_CGC)  + '",' + ;  // <string20>
  				  '"riskrating":"'+ Alltrim(WSSA1->A1_RISCO) +'",' + ; // <string01>
  				  '"IsBlocked":"'+ iif(WSSA1->A1_MSBLQL="1","true","false") +'",' + ;  // <boolean>
  				  '"CustomerGroup": "'+ Alltrim(WSSA1->ACY_A_NOME) +'", ' + ;
  				  '"allowTriangulation":"true",' + ;                   // <boolean>
  				  '"customerTriangulation":[' + ;
  				  							']' + ;
  				    '}'

  				  o2pEventData := "<![CDATA[ [ "+ o2pEventData +" ] ]]>"
  				  oWsdl:csEventData := o2pEventData

  				  Memowrite("\system\O2P\"+ Alltrim(WSSA1->A1_COD) +"_CLIENTE.json" , o2pEventData )

  				  oWsdl:TriggerEvent()

  				  if !oWsdl:lTriggerEventResult
  				  	If oWsdl:csResultData <> nil
  				  		conout( "Erro no processamento: " + oWsdl:csResultData )
  				  		conout( "Erro no processamento: " + oWsdl:csResultCode )
  				  		conout( "Erro no processamento: " + oWsdl:csResultMessage )
  				  	EndIf
  				  	conout( "Erro no processamento: " + WSSA1->A1_COD + " - 01, " + WSSA1->A1_NOME )
  				  else
  				  	DbSelectArea("SA1")
  				  	DbSetOrder(1)
  				  	if DbSeek( xFilial("SA1") + WSSA1->A1_COD + "01" )
  				  	  RecLock("SA1")
  				  	   SA1->A1_XO2PINT := '1'
  				  	  MsUnlock()
  				  	endif
  				  	conout( "Registro Integrado ao WS O2P, Cliente: " + WSSA1->A1_COD + " - 01, " + WSSA1->A1_NOME )
  				  endif
    WSSA1->(dbSkip())
  EndDo
return