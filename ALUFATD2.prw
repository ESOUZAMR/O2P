#INCLUDE "SPEDNFE.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#DEFINE TAMMAXXML 400000 //- Tamanho maximo do XML em  bytes
#DEFINE VBOX       080
#DEFINE HMARGEM    030

/*
// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : ALUFATD2
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Recupera XML da Nota do Parametro para envio ao O2P      | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
*/


user Function ALUFATD2( FilParNF , F2DOC , F2SERIE )

Local aListBox := {}
Local aMsg     := {}
Local nX       := 0
Local nY       := 0
Local nSX3SF2  := TamSx3("F2_DOC")[1]
Local nLastXml := 0
Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local lOk      := .T.
Local oOk      := LoadBitMap(GetResources(), "ENABLE")
Local oNo      := LoadBitMap(GetResources(), "DISABLE")
Local oWS
Local oRetorno
Local cTextInut:= GetNewPar("MV_TXTINUT","")
Local aXML       := {}
Local aNotas     := {}
Local cModalidade:= ""
Local aParam := {"","",""}
Local cIdEnt := GetIdEnt(.T.)
Local nModelo := 1
Local cXmlNfe := ""
Local cModel		:= "55"

Private oXml
Private lCTe := .F.
Private lMsg := .T.
Private cerror

Default lCTe   := .F.
Default lMsg   := .T.

aParam[01] := F2SERIE
aParam[02] := F2DOC
aParam[03] := F2DOC

oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN	:= "TOTVS"
oWS:cID_ENT		:= cIdEnt
oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
oWS:cModelo		:= cModel
If nModelo == 1
	oWS:cIdInicial    := aParam[01]+aParam[02]
	oWS:cIdFinal      := aParam[01]+aParam[03]
	lOk := oWS:MONITORFAIXA()
	oRetorno := oWS:oWsMonitorFaixaResult
Else
	If VALTYPE(aParam[01]) == "N"
		oWS:nIntervalo := Max((aParam[01]),60)
	Else
		oWS:nIntervalo := Max(Val(aParam[01]),60)
	EndIf
	lOk := oWS:MONITORTEMPO()
	oRetorno := oWS:oWsMonitorTempoResult
EndIf

 oXml := oWS:RETORNAFAIXA()

If lOk
	dbSelectArea("SF3")
	dbSetOrder(5)
    For nX := 1 To Len(oRetorno:oWSMONITORNFE)
  		aMsg := {}
 		oXml := oRetorno:oWSMONITORNFE[nX]
 		If Type("oXml:OWSERRO:OWSLOTENFE")<>"U"
			nLastRet := Len(oXml:OWSERRO:OWSLOTENFE)
	 		For nY := 1 To Len(	oXml:OWSERRO:OWSLOTENFE)
 				If oXml:OWSERRO:OWSLOTENFE[nY]:NLOTE<>0
	 				aadd(aMsg,{oXml:OWSERRO:OWSLOTENFE[nY]:NLOTE,oXml:OWSERRO:OWSLOTENFE[nY]:DDATALOTE,oXml:OWSERRO:OWSLOTENFE[nY]:CHORALOTE,;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:NRECIBOSEFAZ,;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:CCODENVLOTE,PadR(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGENVLOTE,50),;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETRECIBO,PadR(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETRECIBO,50),;
	 							oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE,PadR(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE,50)})
				EndIf
			Next nY
			DbSelectArea("SF3")
			DbSetOrder(5)
			If SF3->(MsSeek( FilParNF + oXml:Cid , .T. ))
				If (SubStr(SF3->F3_CFO,1,1)>="5" .Or. SF3->F3_FORMUL=="S")
					aNotas 	:= {}
					aXml2	:= {}
					aadd(aNotas,{})
					aadd(Atail(aNotas),.F.)
					aadd(Atail(aNotas),IIF(SF3->F3_CFO<"5","E","S"))
					aadd(Atail(aNotas),SF3->F3_ENTRADA)
					aadd(Atail(aNotas),SF3->F3_SERIE)
					aadd(Atail(aNotas),SF3->F3_NFISCAL)
					aadd(Atail(aNotas),SF3->F3_CLIEFOR)
					aadd(Atail(aNotas),SF3->F3_LOJA)
					aXml2 := u_GetXmlNf(cIdEnt,aNotas,@cModalidade) //GetXMLNFE(cIdEnt,aNotas,@cModalidade)

					If ( Len(aXml2) > 0 )
						aAdd(aXml,aXml2[1])
					EndIf

					nLastXml := Len(aXml)
				Else
					nLastXml:= Len(aXml)
				EndIf
			EndIf
 		EndIf
   			aadd(aListBox,{ IIf(Empty(oXml:cPROTOCOLO),oNo,oOk),;
			oXml:cID,;
			IIf(oXml:nAMBIENTE==1,STR0056,STR0057),; //"ProduГЦo"###"HomologaГЦo"
			IIf(oXml:nMODALIDADE==1 .Or. oXml:nMODALIDADE==4 .Or. oXml:nModalidade==6,STR0058,STR0059),; //"Normal"###"ContingЙncia"
			oXml:cPROTOCOLO,;
			PadR(oXml:cRECOMENDACAO,250),;
			oXml:cTEMPODEESPERA,;
			oXml:nTEMPOMEDIOSEF,;
			aMsg})

			aXml 		:= {}
			nLastXml	:= 0
    Next nX
EndIf

 cXmlNfe := Bt3NFeMnt(cIdEnt,aListBox[ 1,2 ])

Return(cXmlNfe)

/*
// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : Bt3NFeMnt
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Recupera XML da Nota do Parametro para envio ao O2P      |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
*/

Static Function Bt3NFeMnt(cIdEnt,cIdNFe,nTipo)

Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMsg := ""
Local CXML := ""

Local oWS

DEFAULT nTipo  := 1

oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN        := "TOTVS"
oWS:cID_ENT           := cIdEnt
oWS:oWSNFEID          := NFESBRA_NFES2():New()
oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := cIdNfe
oWS:nDIASPARAEXCLUSAO := 0
oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"

If oWS:RETORNANOTAS()
	If Len(oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
		If nTipo == 1
			Do Case
				Case oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA <> Nil
					CXML := oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
				OtherWise
					CXML := '<?xml version="1.0" encoding="UTF-8"?>' + ;
							'<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="3.10">'
					CXML += oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
					CXML += oWs:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXMLPROT
					CXML += '</nfeProc>'
			EndCase
		EndIf
	EndIf
Else
	CXML := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
EndIf
Return(CXML)

/*
// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : GetIdEnt
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Obtem o codigo da entidade apos enviar o post para o     |
//          |                   | Totvs Service                                            |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
*/

Static Function GetIdEnt(lConsulta)

Local aArea  := GetArea()
Local cIdEnt := ""
Local oWs
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁObtem o codigo da entidade                                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oWS 						:= WsSPEDAdm():New()
oWS:cUSERTOKEN 				:= "TOTVS"

oWS:oWSEMPRESA:cCNPJ       	:= IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        	:= IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         	:= SM0->M0_INSC
oWS:oWSEMPRESA:cIM         	:= SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       	:= SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   	:= SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   	:= FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        	:= FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      	:= FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         	:= SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        	:= SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    	:= SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   	:= "1058"
oWS:oWSEMPRESA:cBAIRRO     	:= SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        	:= SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     	:= Nil
oWS:oWSEMPRESA:cCP         	:= Nil
oWS:oWSEMPRESA:cDDD        	:= Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       	:= AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        	:= AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      	:= UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       	:= SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       	:= SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        	:= IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  	:= ""
oWS:oWSEMPRESA:cID_MATRIZ  	:= ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL 					:= AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	if lConsulta
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{""},3)
	endif
EndIf

RestArea(aArea)

Return(cIdEnt)

/*
// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAFAT
// Fonte  : GetXmlNf
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Obtem o codigo da entidade apos enviar o post para o     |
//          |                   | Totvs Service                                            |
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################
*/

User Function GetXmlNf(cFile)

Local nAt1    := 0
Local nAt2    := 0
Local cXml    := ""
Local lOk     := .T.
Local cNfe    := ""
Local cNfeAss := ""
Local cSign   := ""
Local cProt   := ""

cXml := MemoRead(cFile)

//зддддддддддддддддддддддддддддддддддддддддд©
//Ё NF-e                                    Ё
//юддддддддддддддддддддддддддддддддддддддддды
nAt1:=At("<NFe xmlns=",cXml)
nAt2:=At("</infNFe>",cXml)

If nAt1 > 0 .And. nAt2 > 0
	nAtNfe :=nAt2-nAt1 +9
	cNfe :=Substr(cXml,nAt1,nAtNfe)+"</NFe>"
Else
	lOk := .F.
EndIf

//зддддддддддддддддддддддддддддддддддддддддд©
//Ё NF-e Assinada                           Ё
//юддддддддддддддддддддддддддддддддддддддддды
nAt1:=At("<NFe xmlns=",cXml)
nAt2:=At("</NFe>",cXml)

If nAt1 > 0 .And. nAt2 > 0
	nAtNfe  :=nAt2-nAt1 +6
	cNfeAss :=Substr(cXml,nAt1,nAtNfe)
Else
	lOk := .F.
EndIf

//зддддддддддддддддддддддддддддддддддддддддд©
//Ё Assinatura                              Ё
//юддддддддддддддддддддддддддддддддддддддддды
nAt3:=At("<Signature xmlns=",cXml)
nAt4:=At("</Signature>",cXml)
If nAt3 > 0 .And. nAt4 > 0
	nAtSig :=nAt2-nAt3
	cSign:=Substr(cXml,nAt3,nAtSig)
Else
	lOk := .F.
EndIf

//зддддддддддддддддддддддддддддддддддддддддд©
//Ё Protocolo                               Ё
//юддддддддддддддддддддддддддддддддддддддддды
nAt5:=At("<protNFe",cXml)
nAt6:=At("</protNFe>",cXml)

If nAt5 > 0 .And. nAt6 > 0
	nAtProt :=nAt6-nAt5 +10
	cProt:=Substr(cXml,nAt5,nAtProt)
Else
	lOk := .F.
EndIf


Return({lOk,cNfe,cNfeAss,cSign,cProt})