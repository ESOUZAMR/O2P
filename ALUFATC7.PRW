#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"    
#INCLUDE "TBICONN.CH"

/*
==========================================================================================================
WSDL Location    http://crowndev.brazilsouth.cloudapp.azure.com/o2pwebservices/IntegrationEngine.asmx?WSDL
Gerado em        09/28/17 09:46:40
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
==========================================================================================================
*/

// ##########################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATC7
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Client de Integracao com o Webservice O2P  | 369903
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################

User Function ALUFATC7 ; Return  // "dummy" function - Internal Use

/*
-------------------------------------------------------------------------------
WSDL Service WSIntegrationEngine
-------------------------------------------------------------------------------
*/

WSCLIENT WSIntegrationEngine

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD TriggerEvent

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   csUserId                  AS string
	WSDATA   csEventId                 AS string
	WSDATA   csEventData               AS string
	WSDATA   lTriggerEventResult       AS boolean
	WSDATA   csResultData              AS string
	WSDATA   csResultCode              AS string
	WSDATA   csResultMessage           AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSIntegrationEngine
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150908] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSIntegrationEngine
Return

WSMETHOD RESET WSCLIENT WSIntegrationEngine
	::csUserId           := NIL
	::csEventId          := NIL
	::csEventData        := NIL
	::lTriggerEventResult := NIL
	::csResultData       := NIL
	::csResultCode       := NIL
	::csResultMessage    := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSIntegrationEngine
Local oClone := WSIntegrationEngine():New()
	oClone:_URL          := ::_URL
	oClone:csUserId      := ::csUserId
	oClone:csEventId     := ::csEventId
	oClone:csEventData   := ::csEventData
	oClone:lTriggerEventResult := ::lTriggerEventResult
	oClone:csResultData  := ::csResultData
	oClone:csResultCode  := ::csResultCode
	oClone:csResultMessage := ::csResultMessage
Return oClone

// WSDL Method TriggerEvent of Service WSIntegrationEngine

WSMETHOD TriggerEvent WSSEND csUserId,csEventId,csEventData WSRECEIVE lTriggerEventResult,csResultData,csResultCode,csResultMessage WSCLIENT WSIntegrationEngine
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<TriggerEvent xmlns="http://o2p.processware.com.pt/WebServices/IntegrationEngine">'
cSoap += WSSoapValue("sUserId", ::csUserId, csUserId , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("sEventId", ::csEventId, csEventId , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("sEventData", ::csEventData, csEventData , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</TriggerEvent>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"http://o2p.processware.com.pt/WebServices/IntegrationEngine/TriggerEvent",;
	"DOCUMENT","http://o2p.processware.com.pt/WebServices/IntegrationEngine",,,;
	"http://crownqas.brazilsouth.cloudapp.azure.com/o2pwebservices/IntegrationEngine.asmx")         

::Init()
::lTriggerEventResult :=  WSAdvValue( oXmlRet,"_TRIGGEREVENTRESPONSE:_TRIGGEREVENTRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL)
::csResultData       :=  WSAdvValue( oXmlRet,"_TRIGGEREVENTRESPONSE:_SRESULTDATA:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::csResultCode       :=  WSAdvValue( oXmlRet,"_TRIGGEREVENTRESPONSE:_SRESULTCODE:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)
::csResultMessage    :=  WSAdvValue( oXmlRet,"_TRIGGEREVENTRESPONSE:_SRESULTMESSAGE:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)     
conout(::csResultData)
conout(::csResultCode)
Conout(::csResultMessage)
END WSMETHOD

oXmlRet := NIL
Return .T.