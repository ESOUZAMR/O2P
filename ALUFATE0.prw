#include "protheus.ch"
#include "ap5mail.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ALUFATE0 ºAutor  ³ Eduardo Souza	        º Data ³  28/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio da cópia da Danfe por email  							 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Projeto O2P Chamado                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

USER Function ALUFATE0(cFilePath,cFileName,cNumNota,cSerieNF,cEmail, cChvNfe)

Local cEndDanfe := ""
Local cTo := cEmail
Local cCC := ""
Local cCCO := ""
Local cSubject := "Danfe referente a NF-e "+ALLTRIM(cNumNota)+"/"+ALLTRIM(cSerieNF)
Local cBody := OEMTOANSI("Prezados Senhores")+CHR(13)+CHR(10)
Local cLaudoEml := "eduardo.souza@mrconsultoria.com.br" //SuperGetMV("CE_O2PLAEM",.F.,"laudo.danfe@crowncork.com.br")
Local aSave :=  GETAREA()

dbSelectArea("SF2")
dbSetOrder(1)
dbGoTop()
If SF2->(dbSeek(xFilial("SF2")+cNumNota+cSerieNF))
	cChvNfe := SF2->F2_CHVNFE 
	
	// Cria corpo do e-mail
	cBody += CHR(13)+CHR(10)
	cBody += OEMTOANSI("Segue anexo danfe referente a nota fiscal ")+ALLTRIM(cNumNota)+"/"+ALLTRIM(cSerieNF)
	cBody += CHR(13)+CHR(10)
	cBody += OEMTOANSI("Atenção: Este é um email gerado automaticamente pelo sistema. Favor não responder este email.")+CHR(13)+CHR(10)
	
	If !lIsDir("\Danfe")
		MontaDir("\Danfe")
	Endif
	
	cEndAtu := ALLTRIM(cFilePath)+ALLTRIM(cFileName)
	cEndDanfe := "\danfe\"+cChvNfe+".PDF"
	__CopyFile( cEndAtu , cEndDanfe )
	
	//U_MILSMAIL(cBody,cSubject,cEndDanfe,cTo,cCC,cCCO,.T.)
	// Eduardo Souza - 14/11/2017 | Chamado: 369903
	Processa({||  U_EnviaEml(cLaudoEml, "", Alltrim( cChvNfe + " - DANFE") , "Danfe anexo", cEndDanfe, .f. )}, "Envio de E-Mail", "Enviando Danfe por email para Processware")
	
	//Deleta os arquivos da pasta
	
	Ferase(cEndDanfe)
EndIf                     

RESTAREA(aSave)
Return .T.