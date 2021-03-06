#include "protheus.ch"
#include "ap5mail.ch"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯突北
北篜rograma  � ALUFATE0 篈utor  � Eduardo Souza	        � Data �  28/11/2017 罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯凸北
北篋esc.     � Envio da c髉ia da Danfe por email  							 罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯凸北
北篣so       � Projeto O2P Chamado                                           罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯凸北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
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
	cBody += OEMTOANSI("Aten玢o: Este � um email gerado automaticamente pelo sistema. Favor n鉶 responder este email.")+CHR(13)+CHR(10)
	
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