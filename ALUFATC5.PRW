#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"

// ##########################################################################################
// Projeto:  - Integracao dom sistema O2P - Processware - Envia dados da Transportadora
// Modulo : SIGAFAT
// Fonte  : ALUFATC5
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 04/09/17 | Eduardo Souza     | Integracao com o Webservice O2P,envia dados| 369903
//          |                   | transportadora                             |
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################
user function ALUFATC5( cTrp )
  // Variaveis da rotina de integracao
  Local oWsdl         := WSIntegrationEngine():New()
  Local o2pUsuario    := Alltrim( Upper(GetMv("CE_URSCRWO")) )  
  Local o2pSenha      := Alltrim( Upper(GetMv("CE_PSWCRWO")) )  
  Local o2pOpc        := "Vendor"
  Local o2pEventData  := ""
  Local cQuery        := ""

  // Variaveis para autenticacao no HTTP
  Local aHeadOut := {}
  Local cHeadRet := ""
  Local cPostRet := ""

  AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
  AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

  // Conecta no WS
  HTTPSetPass(o2pUsuario, o2pSenha )
  WSDLDbgLevel( 3 )

  oWsdl:csUserId := o2pUsuario 
  oWsdl:csEventId := o2pOpc

  	If Select("TRB")>0
  		TRB->(dbCloseArea())
	EndIf

	cQuery := " SELECT A4_FILIAL, A4_COD, A4_NOME, A4_END, A4_CEP, A4_MUN, A4_EST, SUBSTR(A4_CODPAIS,2,3) A4_CODPAIS, YA_SIGLA, A4_DDD, A4_TEL, A4_CGC, A4_MSBLQL "
	cQuery += " FROM "+ RetSqlName("SA4") +" A4 "
	cQuery += " LEFT OUTER JOIN "+ RetSqlName("SYA") +" YA ON YA_FILIAL=' ' AND YA_CODGI=SUBSTR(A4_CODPAIS,2,3) AND YA.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE A4.D_E_L_E_T_= ' ' "
	if !empty(cTrp)
		cQuery += " AND A4_COD = "+ cTrp +" "
	endif
	cQuery += " ORDER BY A4_FILIAL, A4_COD "
	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery New Alias "TRB"

	While !TRB->(EOF())

	 o2pEventData := '{' + ;
	 				 '"code": "'+ Alltrim( TRB->A4_COD ) +'",' + ;
	 				 '"description": "'+ Alltrim( TRB->A4_NOME ) +'",' + ;
	 				 '"address": "'+ Alltrim( TRB->A4_END ) +'",' + ;
	 				 '"zipCode": "'+ Alltrim( TRB->A4_CEP ) +'",' + ;
	 				 '"city": "'+ Alltrim( TRB->A4_MUN ) +'",' + ;
	 				 '"state": "'+ Alltrim( TRB->A4_EST ) +'",' + ;
	 				 '"country": "'+ Alltrim( TRB->YA_SIGLA ) +'",' + ;
	 				 '"phone": "'+ "(" + Alltrim( TRB->A4_DDD ) + ")" + Alltrim(TRB->A4_TEL) +'",' + ;
	 				 '"fiscalId": "'+ Alltrim( TRB->A4_CGC ) +'",' + ;
	 				 '"IsBlocked":"'+ iif(TRB->A4_MSBLQL="1","true","false") +'"' + ;  // <boolean>
	 				 '}'

	 	// Cria e alimenta uma nova instancia do cliente
	 	o2pEventData := "<![CDATA[ [ "+ o2pEventData +" ] ]]>"
	 	oWsdl:csEventData := o2pEventData

	 	Memowrite("\system\O2P\"+ ALLTRIM(TRB->A4_COD) +"_TRANSPORTADORA.json",o2pEventData)

		// Executa a operação TriggerEvent.
		oWsdl:TriggerEvent()

		if !oWsdl:lTriggerEventResult
  			If oWsdl:csResultData <> nil
	  			conout( "Erro no processamento: " + oWsdl:csResultData )
	  			conout( "Erro no processamento: " + oWsdl:csResultCode )
	  			conout( "Erro no processamento: " + oWsdl:csResultMessage )
	  	 	EndIf
	  		conout( "Erro no processamento: " + TRB->A4_COD + " | " + Alltrim(TRB->A4_NOME) )
		ELSE
			DbSelectArea("SA4")
			DbSetOrder(1)
			if DbSeek( xFilial("SA4") + TRB->A4_COD  )
				RecLock("SA4")
					SA4->A4_XO2PINT := '1'
				MsUnlock()
			endif
			conout( "Registro Integrado ao WS O2P, Transportadora: "+ TRB->A4_COD + " | " + Alltrim(TRB->A4_NOME) )
		endif
		TRB->(dbSkip())
	EndDo
return