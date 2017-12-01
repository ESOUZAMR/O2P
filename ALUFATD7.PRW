#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "xmlcsvcs.ch"

// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATD7
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - NF-e     | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function ALUFATD7()

Local nFil := {"01","02","04","05","06"}
PRIVATE lAuto	:= IIf( SELECT("SM0") > 0, .F., .T.)

for F := 1 to len( nFil )

	IF lAuto
		RPCSETType(3) //Nao utiliza licenca
		RpcSetEnv( "01" , nFil[F] )
 	ENDIF

	u_EALUFTD7(nFil[F])
	conout( "Integrado XML ao WS O2P, Filial: "+ nFil[F] )

	IF lAuto
		RpcClearEnv()
	endif
next

Return()


// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : EALUFTD7
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Cliente de Integracao com o Webservice da O2P - NF-e     | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
User Function EALUFTD7(nFil)

Local oWsdl
Local o2pUsuario   := ""
Local o2pSenha     := ""
Local o2pOpc       := "NotaFiscal"
Local o2pEventData := " "
Local cQuery       := ""
Local cRetXML      := ""
Local dDtInO2P     := ""

Local aHeadOut := {}
Local cHeadRet := ""
Local cPostRet := ""

	oWsdl       := WSIntegrationEngine():New()                      
	o2pUsuario  := Alltrim( Upper(GetMv("CE_URSCRWO")) ) 
	o2pSenha    := Alltrim( Upper(GetMv("CE_PSWCRWO")) ) 
	dDtInO2P    := GetMv("CE_DTINO2P")

  AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
  AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

  // Conecta no WS
  HTTPSetPass( o2pUsuario, o2pSenha )
  WSDLDbgLevel( 3 )

  oWsdl:csUserId := o2pUsuario
  oWsdl:csEventId := o2pOpc

	If SELECT("WSSF2") > 0
  		DBSELECTAREA("WSSF2")
  		DBCLOSEAREA("WSSF2")
  	Endif

  	cQuery := " SELECT * "
  	cQuery += " FROM "+ RetSqlName("SF2") +" F2 "
  	cQuery += " WHERE F2_XO2PINT = ' ' AND F2_EMISSAO >= '"+ dDtInO2P +"' AND F2_HAUTNFE <> ' ' AND F2_DAUTNFE <> ' ' "
  	cQuery += " AND F2_FILIAL = '"+ nFil +"' "
  	cQuery += " AND D_E_L_E_T_ = ' ' "
  	TcQuery cQuery New Alias "WSSF2"

  		While !WSSF2->(EOF())

  		  cRetXML := u_ALUFATD2( WSSF2->F2_FILIAL , WSSF2->F2_DOC , WSSF2->F2_SERIE )

  			o2pEventData := "<![CDATA["+ cRetXML +"]]>"

  			oWsdl:csEventData := o2pEventData

  			// Envia o xml para o WS O2P
  			if !empty(o2pEventData)

  				/* Realiza a integracao no WS do O2P */
  				oWsdl:TriggerEvent()

  				Memowrite("\system\O2P\XML_NOTA_"+ alltrim(WSSF2->F2_FILIAL) + "_" + alltrim(WSSF2->F2_DOC) + "_" + alltrim(WSSF2->F2_SERIE) +".XML",cRetXML)

  				if !oWsdl:lTriggerEventResult
  					conout( "Erro no processamento: " + oWsdl:csResultData )
  				  	conout( "Erro no processamento: " + oWsdl:csResultCode )
  				  	conout( "Erro no processamento: " + oWsdl:csResultMessage )
  					conout( "Erro no processamento da NF-e: " + WSSF2->F2_DOC )
  				else
  				 DbSelectArea("SF2")
  				 DbSetOrder(1)
  				 if DbSeek( WSSF2->F2_FILIAL + WSSF2->F2_DOC + WSSF2->F2_SERIE )
  				  //RecLock("SA1")
  				 // 	SF2->F2_XO2PINT = ' '
  				 // MsUnlock()
  				  conout( "Registro Integrado ao WS O2P, Filial: "+ WSSF2->F2_FILIAL +", NF-e: " + WSSF2->F2_DOC + ", Serie: " + WSSF2->F2_SERIE )
  				 endif
  				endif
  			endif
  		WSSF2->(dbSkip())
  		Enddo
Return