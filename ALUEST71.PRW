#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"

// ########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAEST
// Fonte  : ALUEST71
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - O.P.     | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################


User Function ALUEST71( numOPf , C2NUM , C2QUANT )

  Local oWsdl := WSIntegrationEngine():New()
  Local oCadastro
  Local oLista
  Local o2pUsuario   := Alltrim( Upper(GetMv("CE_URSCRWO")) )  
  Local o2pSenha     := Alltrim( Upper(GetMv("CE_PSWCRWO")) )  
  Local o2pOpc       := "ProductionOrder"
  Local o2pEventData := " "
  Local cQuery       := ""

  Local aHeadOut := {}
  Local cHeadRet := ""
  Local cPostRet := ""

  AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
  AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

  // Conecta no WS
  HTTPSetPass( o2pUsuario, o2pSenha)

  WSDLDbgLevel( 3 )

  oWsdl:csUserId := o2pUsuario
  oWsdl:csEventId := o2pOpc

  o2pEventData := '{' + ;
  					'"action": "Include",' + ;
  					'"childOrder": "'+ numOPf +'",' + ;
  					'"mainOrder": "'+ C2NUM +'",' + ;
  					'"quantity": "'+ Alltrim( str(C2QUANT) ) +'",' + ;
  					'"uom": "MI"' + ;
  					'}'

  o2pEventData := "<![CDATA[ [ "+ o2pEventData +" ] ]]>"
  oWsdl:csEventData := o2pEventData

  Memowrite("\system\O2P\" + Alltrim(numOPf) + "_OP.json",o2pEventData)

  oWsdl:TriggerEvent()

  if !oWsdl:lTriggerEventResult
  	If oWsdl:csResultData <> nil	
	  	conout( "Erro no processamento: " + oWsdl:csResultData )
	  	conout( "Erro no processamento: " + oWsdl:csResultCode )
	  	conout( "Erro no processamento: " + oWsdl:csResultMessage ) 
	EndIf
  else

  	conout( "Registro Integrado ao WS OP do O2P, OP Filha: " + numOPf )
  endif


return