#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*
===================================================================================================
WSDL Location    http://crowndev.brazilsouth.cloudapp.azure.com/o2pwebservices/NotaFiscal.asmx?WSDL
Gerado em        09/28/17 09:38:34
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
===================================================================================================
*/

// ##########################################################################################################
// Projeto: A027/17 - Integracao dom sistema O2P - Processware
// Modulo : SIGAFAT
// ---------+-------------------+------------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                  | Chamado
// ---------+-------------------+------------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Client de Integracao com o Webservice O2P - Envio de NF-e  | 369903
// ---------+-------------------+------------------------------------------------------------+---------------
// ##########################################################################################################


User Function ALUFATD6 ; Return  // "dummy" function - Internal Use

/*
-------------------------------------------------------------------------------
WSDL Service WSNotaFiscal
-------------------------------------------------------------------------------
*/

WSCLIENT WSNotaFiscal

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ConsumeReferenceDocumentAndNF
	WSMETHOD Dummy_ExportStructs
	WSMETHOD ReverseNotaFiscalItem
	WSMETHOD ValidateDanfeSEFAZ
	WSMETHOD ValidateDanfeSEFAZWithCNPJ
	WSMETHOD ValidateCTeSEFAZ
	WSMETHOD DownloadDanfeSEFAZ
	WSMETHOD SaveFileIntoFolder
	WSMETHOD ReceptionEventSEFAZ
	WSMETHOD ImportDANFEGeneric
	WSMETHOD ImportO2PNotaFiscal
	WSMETHOD ImportDanfeXMLString
	WSMETHOD ImportXmlString
	WSMETHOD ImportXml
	WSMETHOD ParseXMLString
	WSMETHOD ParseXML
	WSMETHOD ImportOAGNotaFiscal
	WSMETHOD GetAccessKey

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   csIntDocID                AS string
	WSDATA   cConsumeReferenceDocumentAndNFResult AS string
	WSDATA   oWSnfs                    AS NotaFiscal_NotaFiscalSuccess
	WSDATA   oWSnfe                    AS NotaFiscal_NotaFiscalError
	WSDATA   oWSge                     AS NotaFiscal_GenericError
	WSDATA   csAccessKey               AS string
	WSDATA   csUF                      AS string
	WSDATA   csUrl                     AS string
	WSDATA   lValidateDanfeSEFAZResult AS boolean
	WSDATA   csResultMessage           AS string
	WSDATA   csCNPJ                    AS string
	WSDATA   lValidateDanfeSEFAZWithCNPJResult AS boolean
	WSDATA   lValidateCTeSEFAZResult   AS boolean
	WSDATA   lDownloadDanfeSEFAZResult AS boolean
	WSDATA   csXml                     AS string
	WSDATA   csFileName                AS string
	WSDATA   csFileContent             AS string
	WSDATA   lSaveFileIntoFolderResult AS boolean
	WSDATA   csEventCod                AS string
	WSDATA   csEventDesc               AS string
	WSDATA   csDTTimeZone              AS string
	WSDATA   lReceptionEventSEFAZResult AS boolean
	WSDATA   csErrorMessage            AS string
	WSDATA   csLanguage                AS string
	WSDATA   oWSImportO2PNotaFiscalResult AS NotaFiscal_ArrayOfAnyType
	WSDATA   cImportDanfeXMLStringResult AS string
	WSDATA   oWSImportXmlStringResult  AS NotaFiscal_ArrayOfAnyType
	WSDATA   csUserName                AS string
	WSDATA   csPassword                AS string
	WSDATA   oWSImportXmlResult        AS NotaFiscal_ArrayOfAnyType
	WSDATA   oWSParseXMLStringResult   AS NotaFiscal_ArrayOfAnyType
	WSDATA   oWSParseXMLResult         AS NotaFiscal_ArrayOfAnyType
	WSDATA   oWSImportOAGNotaFiscalResult AS NotaFiscal_ArrayOfAnyType
	WSDATA   cGetAccessKeyResult       AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSNotaFiscal
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150908] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSNotaFiscal
	::oWSnfs             := NotaFiscal_NOTAFISCALSUCCESS():New()
	::oWSnfe             := NotaFiscal_NOTAFISCALERROR():New()
	::oWSge              := NotaFiscal_GENERICERROR():New()
	::oWSImportO2PNotaFiscalResult := NotaFiscal_ARRAYOFANYTYPE():New()
	::oWSImportXmlStringResult := NotaFiscal_ARRAYOFANYTYPE():New()
	::oWSImportXmlResult := NotaFiscal_ARRAYOFANYTYPE():New()
	::oWSParseXMLStringResult := NotaFiscal_ARRAYOFANYTYPE():New()
	::oWSParseXMLResult  := NotaFiscal_ARRAYOFANYTYPE():New()
	::oWSImportOAGNotaFiscalResult := NotaFiscal_ARRAYOFANYTYPE():New()
Return

WSMETHOD RESET WSCLIENT WSNotaFiscal
	::csIntDocID         := NIL
	::cConsumeReferenceDocumentAndNFResult := NIL
	::oWSnfs             := NIL
	::oWSnfe             := NIL
	::oWSge              := NIL
	::csAccessKey        := NIL
	::csUF               := NIL
	::csUrl              := NIL
	::lValidateDanfeSEFAZResult := NIL
	::csResultMessage    := NIL
	::csCNPJ             := NIL
	::lValidateDanfeSEFAZWithCNPJResult := NIL
	::lValidateCTeSEFAZResult := NIL
	::lDownloadDanfeSEFAZResult := NIL
	::csXml              := NIL
	::csFileName         := NIL
	::csFileContent      := NIL
	::lSaveFileIntoFolderResult := NIL
	::csEventCod         := NIL
	::csEventDesc        := NIL
	::csDTTimeZone       := NIL
	::lReceptionEventSEFAZResult := NIL
	::csErrorMessage     := NIL
	::csLanguage         := NIL
	::oWSImportO2PNotaFiscalResult := NIL
	::cImportDanfeXMLStringResult := NIL
	::oWSImportXmlStringResult := NIL
	::csUserName         := NIL
	::csPassword         := NIL
	::oWSImportXmlResult := NIL
	::oWSParseXMLStringResult := NIL
	::oWSParseXMLResult  := NIL
	::oWSImportOAGNotaFiscalResult := NIL
	::cGetAccessKeyResult := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSNotaFiscal
Local oClone := WSNotaFiscal():New()
	oClone:_URL          := ::_URL
	oClone:csIntDocID    := ::csIntDocID
	oClone:cConsumeReferenceDocumentAndNFResult := ::cConsumeReferenceDocumentAndNFResult
	oClone:oWSnfs        :=  IIF(::oWSnfs = NIL , NIL ,::oWSnfs:Clone() )
	oClone:oWSnfe        :=  IIF(::oWSnfe = NIL , NIL ,::oWSnfe:Clone() )
	oClone:oWSge         :=  IIF(::oWSge = NIL , NIL ,::oWSge:Clone() )
	oClone:csAccessKey   := ::csAccessKey
	oClone:csUF          := ::csUF
	oClone:csUrl         := ::csUrl
	oClone:lValidateDanfeSEFAZResult := ::lValidateDanfeSEFAZResult
	oClone:csResultMessage := ::csResultMessage
	oClone:csCNPJ        := ::csCNPJ
	oClone:lValidateDanfeSEFAZWithCNPJResult := ::lValidateDanfeSEFAZWithCNPJResult
	oClone:lValidateCTeSEFAZResult := ::lValidateCTeSEFAZResult
	oClone:lDownloadDanfeSEFAZResult := ::lDownloadDanfeSEFAZResult
	oClone:csXml         := ::csXml
	oClone:csFileName    := ::csFileName
	oClone:csFileContent := ::csFileContent
	oClone:lSaveFileIntoFolderResult := ::lSaveFileIntoFolderResult
	oClone:csEventCod    := ::csEventCod
	oClone:csEventDesc   := ::csEventDesc
	oClone:csDTTimeZone  := ::csDTTimeZone
	oClone:lReceptionEventSEFAZResult := ::lReceptionEventSEFAZResult
	oClone:csErrorMessage := ::csErrorMessage
	oClone:csLanguage    := ::csLanguage
	oClone:oWSImportO2PNotaFiscalResult :=  IIF(::oWSImportO2PNotaFiscalResult = NIL , NIL ,::oWSImportO2PNotaFiscalResult:Clone() )
	oClone:cImportDanfeXMLStringResult := ::cImportDanfeXMLStringResult
	oClone:oWSImportXmlStringResult :=  IIF(::oWSImportXmlStringResult = NIL , NIL ,::oWSImportXmlStringResult:Clone() )
	oClone:csUserName    := ::csUserName
	oClone:csPassword    := ::csPassword
	oClone:oWSImportXmlResult :=  IIF(::oWSImportXmlResult = NIL , NIL ,::oWSImportXmlResult:Clone() )
	oClone:oWSParseXMLStringResult :=  IIF(::oWSParseXMLStringResult = NIL , NIL ,::oWSParseXMLStringResult:Clone() )
	oClone:oWSParseXMLResult :=  IIF(::oWSParseXMLResult = NIL , NIL ,::oWSParseXMLResult:Clone() )
	oClone:oWSImportOAGNotaFiscalResult :=  IIF(::oWSImportOAGNotaFiscalResult = NIL , NIL ,::oWSImportOAGNotaFiscalResult:Clone() )
	oClone:cGetAccessKeyResult := ::cGetAccessKeyResult
Return oClone

// WSDL Method ImportXmlString of Service WSNotaFiscal

WSMETHOD ImportXmlString WSSEND csFileName,csXml,csLanguage WSRECEIVE oWSImportXmlStringResult WSCLIENT WSNotaFiscal
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportXmlString xmlns="http://o2p.processware.com.pt/WebServices/NotaFiscal">'
cSoap += WSSoapValue("sFileName", ::csFileName, csFileName , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("sXml", ::csXml, csXml , "string", .F. , .F., 0 , NIL, .F.)
cSoap += WSSoapValue("sLanguage", ::csLanguage, csLanguage , "string", .F. , .F., 0 , NIL, .F.)
cSoap += "</ImportXmlString>"

oXmlRet := SvcSoapCall(	Self,cSoap,;
	"http://o2p.processware.com.pt/WebServices/NotaFiscal/ImportXmlString",;
	"DOCUMENT","http://o2p.processware.com.pt/WebServices/NotaFiscal",,,;
	"http://crownqas.brazilsouth.cloudapp.azure.com/o2pwebservices/NotaFiscal.asmx")

::Init()
::oWSImportXmlStringResult:SoapRecv( WSAdvValue( oXmlRet,"_IMPORTXMLSTRINGRESPONSE:_IMPORTXMLSTRINGRESULT","ArrayOfAnyType",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Data Structure NotaFiscalSuccess

WSSTRUCT NotaFiscal_NotaFiscalSuccess
	WSDATA   csInternalDocid           AS string OPTIONAL
	WSDATA   csNotaFiscalId            AS string OPTIONAL
	WSDATA   csSerieId                 AS string OPTIONAL
	WSDATA   csFornecedor              AS string OPTIONAL
	WSDATA   csPlant                   AS string OPTIONAL
	WSDATA   csHouse                   AS string OPTIONAL
	WSDATA   oWSsOnhand                AS NotaFiscal_ArrayOfAnyType OPTIONAL
	WSDATA   csAccessKey               AS string OPTIONAL
	WSDATA   csDemandCode              AS string OPTIONAL
	WSDATA   csWarningMessage          AS string OPTIONAL
	WSDATA   csCollectionDate          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NotaFiscal_NotaFiscalSuccess
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NotaFiscal_NotaFiscalSuccess
Return

WSMETHOD CLONE WSCLIENT NotaFiscal_NotaFiscalSuccess
	Local oClone := NotaFiscal_NotaFiscalSuccess():NEW()
	oClone:csInternalDocid      := ::csInternalDocid
	oClone:csNotaFiscalId       := ::csNotaFiscalId
	oClone:csSerieId            := ::csSerieId
	oClone:csFornecedor         := ::csFornecedor
	oClone:csPlant              := ::csPlant
	oClone:csHouse              := ::csHouse
	oClone:oWSsOnhand           := IIF(::oWSsOnhand = NIL , NIL , ::oWSsOnhand:Clone() )
	oClone:csAccessKey          := ::csAccessKey
	oClone:csDemandCode         := ::csDemandCode
	oClone:csWarningMessage     := ::csWarningMessage
	oClone:csCollectionDate     := ::csCollectionDate
Return oClone

WSMETHOD SOAPSEND WSCLIENT NotaFiscal_NotaFiscalSuccess
	Local cSoap := ""
	cSoap += WSSoapValue("sInternalDocid", ::csInternalDocid, ::csInternalDocid , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sNotaFiscalId", ::csNotaFiscalId, ::csNotaFiscalId , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sSerieId", ::csSerieId, ::csSerieId , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sFornecedor", ::csFornecedor, ::csFornecedor , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sPlant", ::csPlant, ::csPlant , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sHouse", ::csHouse, ::csHouse , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sOnhand", ::oWSsOnhand, ::oWSsOnhand , "ArrayOfAnyType", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sAccessKey", ::csAccessKey, ::csAccessKey , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sDemandCode", ::csDemandCode, ::csDemandCode , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sWarningMessage", ::csWarningMessage, ::csWarningMessage , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sCollectionDate", ::csCollectionDate, ::csCollectionDate , "string", .F. , .F., 0 , NIL, .F.)
Return cSoap

// WSDL Data Structure NotaFiscalError

WSSTRUCT NotaFiscal_NotaFiscalError
	WSDATA   csNotaFiscalId            AS string OPTIONAL
	WSDATA   csSerieId                 AS string OPTIONAL
	WSDATA   csFornecedor              AS string OPTIONAL
	WSDATA   csNotaFiscalItemId        AS string OPTIONAL
	WSDATA   csErrorMsg                AS string OPTIONAL
	WSDATA   csPlant                   AS string OPTIONAL
	WSDATA   csHouse                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NotaFiscal_NotaFiscalError
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NotaFiscal_NotaFiscalError
Return

WSMETHOD CLONE WSCLIENT NotaFiscal_NotaFiscalError
	Local oClone := NotaFiscal_NotaFiscalError():NEW()
	oClone:csNotaFiscalId       := ::csNotaFiscalId
	oClone:csSerieId            := ::csSerieId
	oClone:csFornecedor         := ::csFornecedor
	oClone:csNotaFiscalItemId   := ::csNotaFiscalItemId
	oClone:csErrorMsg           := ::csErrorMsg
	oClone:csPlant              := ::csPlant
	oClone:csHouse              := ::csHouse
Return oClone

WSMETHOD SOAPSEND WSCLIENT NotaFiscal_NotaFiscalError
	Local cSoap := ""
	cSoap += WSSoapValue("sNotaFiscalId", ::csNotaFiscalId, ::csNotaFiscalId , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sSerieId", ::csSerieId, ::csSerieId , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sFornecedor", ::csFornecedor, ::csFornecedor , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sNotaFiscalItemId", ::csNotaFiscalItemId, ::csNotaFiscalItemId , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sErrorMsg", ::csErrorMsg, ::csErrorMsg , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sPlant", ::csPlant, ::csPlant , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sHouse", ::csHouse, ::csHouse , "string", .F. , .F., 0 , NIL, .F.)
Return cSoap

// WSDL Data Structure GenericError

WSSTRUCT NotaFiscal_GenericError
	WSDATA   csErrorType               AS string OPTIONAL
	WSDATA   csErrorMsg                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NotaFiscal_GenericError
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NotaFiscal_GenericError
Return

WSMETHOD CLONE WSCLIENT NotaFiscal_GenericError
	Local oClone := NotaFiscal_GenericError():NEW()
	oClone:csErrorType          := ::csErrorType
	oClone:csErrorMsg           := ::csErrorMsg
Return oClone

WSMETHOD SOAPSEND WSCLIENT NotaFiscal_GenericError
	Local cSoap := ""
	cSoap += WSSoapValue("sErrorType", ::csErrorType, ::csErrorType , "string", .F. , .F., 0 , NIL, .F.)
	cSoap += WSSoapValue("sErrorMsg", ::csErrorMsg, ::csErrorMsg , "string", .F. , .F., 0 , NIL, .F.)
Return cSoap

// WSDL Data Structure ArrayOfAnyType

WSSTRUCT NotaFiscal_ArrayOfAnyType
	WSDATA   oWSanyType                AS SCHEMA OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT NotaFiscal_ArrayOfAnyType
	::Init()
Return Self

WSMETHOD INIT WSCLIENT NotaFiscal_ArrayOfAnyType
	::oWSanyType           := {} // Array Of  SCHEMA():New()
Return

WSMETHOD CLONE WSCLIENT NotaFiscal_ArrayOfAnyType
	Local oClone := NotaFiscal_ArrayOfAnyType():NEW()
	oClone:oWSanyType := NIL
	If ::oWSanyType <> NIL
		oClone:oWSanyType := {}
		aEval( ::oWSanyType , { |x| aadd( oClone:oWSanyType , x:Clone() ) } )
	Endif
Return oClone

WSMETHOD SOAPSEND WSCLIENT NotaFiscal_ArrayOfAnyType
	Local cSoap := ""
	aEval( ::oWSanyType , {|x| cSoap := cSoap  +  WSSoapValue("anyType", x , x , "SCHEMA", .F. , .F., 0 , NIL, .F.)  } )
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT NotaFiscal_ArrayOfAnyType
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif
	oNodes1 :=  WSAdvValue( oResponse,"_ANYTYPE","SCHEMA",{},NIL,.T.,"O",NIL,NIL)
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSanyType , oNodes1[nRElem1] )
		Endif
	Next
Return