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
// 27/11/17 | Eduardo Souza     | Cliente de Integracao com o Webservice da O2P - DT       | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

User Function ALUFATD9()


Local oWsdl := WSIntegrationEngine():New()
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
Local aDT_IT   := {}

Conout("...: ALUFATD9 :...")
Conout(cUrl)
Conout(Dtoc(Date()))
AAdd( aHeadOut, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')' )
AAdd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')

// Conecta no WS
HTTPSetPass( o2pUsuario, o2pSenha )
WSDLDbgLevel( 3 )

oWsdl:csUserId := o2pUsuario
oWsdl:csEventId := o2pOpc

If SELECT("WSDT") > 0
	DBSELECTAREA("WSDT")
	DBCLOSEAREA("WSDT")
Endif

cQuery := "SELECT DISTINCT  zzc.zzc_a_oe, zzj.zzj_a_ped, zzc.zzc_a_tran, zzc.zzc_a_plcv, zzc.zzc_a_dtca, zzc.zzc_a_dten,             "
cQuery := "                 zzj.zzj_a_itpe, zzj.zzj_a_prpe, zzj.zzj_a_qtd, sb1.b1_um, zzc_a_stca, zzj_a_ser, zzj_a_nf, f2_chvnfe     "
cQuery := "FROM                                                                                                                      "
cQuery := "    aluminio."+RetSQLName("ZZC")+" zzc, aluminio."+RetSQLName("ZZJ")+" zzj, aluminio."+RetSQLName("SB1")+" sb1, aluminio."+RetSQLName("SB1")+" sf2                                    "
cQuery := "WHERE                                                                                                                     "
cQuery := "        zzc.d_e_l_e_t_ = ' '   AND     zzj.d_e_l_e_t_ = ' '    AND    sb1.d_e_l_e_t_ = ' '    AND    sf2.d_e_l_e_t_ = ' ' "
cQuery := "    AND                                                                                                                   "
cQuery := "        zzc.zzc_a_oe = zzj.zzj_a_oe   AND     zzj.zzj_a_prpe = sb1.b1_cod    AND    zzc.zzc_a_stca = '2'                  "
cQuery := "    AND                                                                                                                   "
cQuery := "        f2_doc = zzj.zzj_a_nf    AND     f2_serie = zzj.zzj_a_ser AND F2_TIPO='N'  AND  F2_FILIAL=ZZC.ZZC_FILORI          "
cQuery := "ORDER BY                                                                                                                  "
cQuery := "    zzj.zzj_a_ped, zzj.zzj_a_itpe;


TcQuery cQuery New Alias "WSDT"

Conout(cQuery)

While !WSSA1->(EOF())
	If SELECT("WSDT_IT") > 0
		DBSELECTAREA("WSDT_IT")
		DBCLOSEAREA("WSDT_IT")
	Endif
	
	// Faz a query para pegar os itens
	cQryItem := "SELECT distinct zzj.zzj_a_ped, zzj.zzj_a_itpe, zzj.zzj_a_prpe, zzj.zzj_a_qtd, sb1.b1_um, zzj_a_ser, zzj_a_nf, f2_chvnfe "
	cQryItem := "FROM aluminio.zzj010 zzj, aluminio.sb1010 sb1, aluminio.sf2010 sf2 "
	cQryItem := "WHERE  zzj.d_e_l_e_t_ = ' ' AND  sb1.d_e_l_e_t_ = ' '   AND  sf2.d_e_l_e_t_ = ' '   AND   zzj.zzj_a_oe = '111089' "
	cQryItem := "AND  zj.zzj_a_prpe = sb1.b1_cod  AND   f2_doc = zzj.zzj_a_nf  AND  f2_serie = zzj.zzj_a_ser AND F2_TIPO='N' "
	cQryItem := "ORDER BY zzj.zzj_a_ped,zzj.zzj_a_itpe "
	
	
	TcQuery cQuery New Alias "WSDT_IT"
	
	o2pEventData := '{'
	o2pEventData += '"TransportDocument":"' + WSDT->zzc_a_oe  + '",'
	o2pEventData +='"SalesOrder":"' + WSDT->zzj_a_ped  + '",'   // <string35>
	o2pEventData +='"ScheduleLandingDate":"' + Substr(Dtos(WSDT->zzc_a_dtca),7,2) + "-" + Substr(Dtos(WSSA1->zzc_a_dtca),5,2) + "-" + Substr(Dtos(WSSA1->zzc_a_dtca),1,4) + '",' 
	o2pEventData +='"ScheduleDeliveryDate:"' + Substr(Dtos(WSDT->zzc_a_dten),7,2) + "-" + Substr(Dtos(WSSA1->zzc_a_dten),5,2) + "-" + Substr(Dtos(WSSA1->zzc_a_dten),1,4) + '",' 
	o2pEventData +='"Vehicle1":"' + Alltrim(WSDT->zzc_a_plcv)  + '",' 
	o2pEventData +='"Vehicle2":"' + "" + '",' 
	o2pEventData +='"Carrier":"' + Alltrim(WSDT->zzc_a_tran)  + '",' 
	o2pEventData +='"FiscalDoc":"' + Alltrim(WSDT->f2_chvnfe) + '",' 
	o2pEventData +='"Material":['
	
	
	aDT_IT := {}
	
	While !WSDT_IT->(Eof())
		If SELECT("WSDT_IT") > 0
			DBSELECTAREA("WSDT_IT")
			DBCLOSEAREA("WSDT_IT")
		Endif
		
		aadd(aDT_IT,{WSDT_IT->zzj_a_ped, WSDT_IT->zzj_a_itpe, WSDT_IT->zzj_a_prpe, WSDT_IT->zzj_a_qtd, WSDT_IT->b1_um, WSDT_IT->zzj_a_ser, WSDT_IT->zzj_a_nf, WSDT_IT->f2_chvnfe})
		
		WSDT_IT->(dbSkip())
	End
	For nX := 1 to Len(aDT_IT)
		o2pEventData += '"SalesOrderItem":"' + Alltrim(WSDT_IT->zzj_a_itpe) + '",' 
		o2pEventData += '"Sku":"' + Alltrim(WSDT_IT->zzj_a_prpe) + '",' 
		o2pEventData += '"Quantity":"' + Alltrim(WSDT_IT->zzj_a_qtd) + '",' 
		o2pEventData += '"UoM":"' + Alltrim(WSDT_IT->b1_um) + '",' 
		If nX = Len(aDT_IT)
			o2pEventData += ']' 
		Else
			o2pEventData += '],[' 
		EndIf
	Next nX
	o2pEventData += '}'
	
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
