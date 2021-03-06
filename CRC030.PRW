#include "apvt100.ch"

#DEFINE POSPRODUTO  1
#DEFINE POSQTD      2
#DEFINE POSNOTA     4
#DEFINE POSSERIE    5
#DEFINE POSFORNECE  6
#DEFINE POSLOJA     7
#DEFINE POSLOCALI   9
#DEFINE POSLOCAL   10
#DEFINE POSOP      11
#DEFINE POSNUMSEQ  12

//������A�T�E�N�C�A�O�������������������������������������������������������Ŀ
//�Antes de rodar as funcoes verifique se contem os requisitos:              �
//�01-Campo                                                                  �
//�                                                                          �
//����������������������������������������������������������������������������

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CRC030     � Autor � Fernando Alves      � Data � 31/05/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Transfere HFI para almoxarifado                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� MV_ALMOHFI - Almoxarifado usado no HFI                     ���
���          � MV_LOCAHFI - Locallizacao do HFI                          .���
���          � MV_LOCATMP - Localliz. Temp. do Almox. 01, usado p/ Transf.���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Crown Cork        	    								  ���
�������������������������������������������������������������������������Ĵ��
���  ALBERTO      �19/09/07� Incluida movimentacao interna para requisitar���
���               �        �  do HFI  e gerar devolucao no almox.Inibido o���
���               �        �   estorno e a transferencia para a           ���
��� Anderson      �12062008� Cabecalho e identacao                        ���
���               �        �                                              ���
��� Adriano Guedes�14/05/14� chamado 293131 campo informa Lib condicional ���
���               �        � opcao  S=Supervisor,Q=Qualidade e G=Gerencia ���
��� Luiz Cesar    �28032016� Trocar a Letra S por P Chamado 342061        ���
��� Eduardo Souza �30/11/17� Chamado 369903. Atualiza WS da O2P           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRC030

Local cMenTop   := "HFI Devolucao"
Local cEti      := space(10)

Private aEtiqueta := {}
Private lMsErroAuto := .f.

VTCLEAR
@ 0,0 VTSAY cMenTop
@ 2,0 VTSAY 'Etiqueta:'
@ 3,0 VTGET cEti PICT "@!" VALID CRC030VldEt(@cEti)
VTREAD

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CRC030VldEt� Autor � Fernando Alves      � Data � 31/05/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida Etiqueta e inicia moviementacoes. (Devolver os pro- ���
���          � dutos anteriormente destinados ao endereco HFI para pode-  ���
���          � rem ser enderecados na localizacao desejada                ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Crown Cork        	    								  ���
�������������������������������������������������������������������������Ĵ��
��� Anderson      �12062008� Cabecalho e identacao                        ���
��� Luiz Cesar    �28032016� Trocar a Letra S por P Chamado 342061        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CRC030VldEt(cEti)

Local aTela
Local cAlmoxHFI := GetNewPar("MV_ALMOHFI","98")
Local cTmpLocal := padr(GetNewPar("MV_LOCATMP","T01"),15)
Local cHFILocal := padr(GetNewPar("MV_LOCAHFI","T98"),15)
//--------------------------------------------------------------------------------
//Adriano Guedes em 14/05/14 chamado 293131 campo informa Lib condicional 
// opcao  S=Supervisor,Q=Qualidade e G=Gerencia
//--------------------------------------------------------------------------------
Local lFim := .T.
Local cLibCond := space(1) // Campo para informar se � uma liberacao condicional e qual o aprovador opcao  S=Supervisor,Q=Qualidade e G=Gerencia
//--------------------------------------------------------------------------------

aEtiqueta := CBRetEti(cEti,"01")

If Empty(aEtiqueta)
	VTBEEP(2)
	VTALERT("Etiqueta invalida.","AVISO",.T.,4000)
	VtKeyboard(Chr(20))  // zera o get
	Return .f.
EndIf

If !U_CRCArea('LIBERAHFI',cEti)
	VtKeyboard(Chr(20))  // zera o get
	Return .f.
EndIf

VTBeep(2)
If ! VTYesNo('Confirma a devolucao deste pallet ','Atencao',.t.)
	VtKeyboard(Chr(20))  // zera o get
	Return .f.
EndIf 
aTela:=VTSave()
//--------------------------------------------------------------------
// Adriano Guedes em 14/05/14 chamado 293131
//--------------------------------------------------------------------
     
		VTBeep(2)
		If  VTYesNo('Liberacao Condicional ?? ','Atencao',.t.) 
  			VTCLEAR
   				@ 0,0 VTSAY "HFI Devolucao"
   				@ 2,0 VTSAY 'Responsavel:'
   				@ 3,0 VTGET cLibCond PICT "@!" VALID !Empty(cLibCond) .and. Alltrim(cLibCond) $'PQGA' // Luiz Cesar - chamado 342061 Trocado a letra S por P 'SQGA'
  			VTREAD
		Endif
	
//--------------------------------------------------------------------


VTMSG("Aguarde...",1)

Begin Transaction
// Incluida movimentacao interna para requisitar do HFI  e gerar devolucao no almox.
// Inibido o estorno e a transferencia para area temporaria
U_GeraD3(GetMV("MV_CCTMSUC"),CB0->CB0_CODPRO,CB0->CB0_LOCAL,CB0->CB0_LOCALI,CB0->CB0_QTDE)  // REQUISITA

If U_GeraD3(GetMV("MV_CCTMDEV"),CB0->CB0_CODPRO,"01","",CB0->CB0_QTDE)             // DEVOLVE P/ SALDO A DISTRIBUIR
	RecLock("CB0",.F.)
		CB0->CB0_NUMSEQ:= SD3->D3_NUMSEQ
		CB0->CB0_LOCALI:= Space(15)
		CB0->CB0_LOCAL := SD3->D3_LOCAL
	CB0->(MsUnlock())
	aEtiqueta[POSNUMSEQ] := SD3->D3_NUMSEQ
	aEtiqueta[POSLOCALI] := Space(15)
	aEtiqueta[POSLOCAL]  := SD3->D3_LOCAL
Endif

RecLock('CB0',.F.)
	CB0->CB0_ITESDB := ""
	CB0->CB0_CCAREA := ""
//------------------------------------------------
// Adriano Guedes em 14/05/14  chamado 293131
//------------------------------------------------
    CB0->CB0_A_LBCO := cLibCond
//------------------------------------------------	
CB0->(MsUnLock())

aEtiqueta := CBRetEti(cEti,"01")
// Grava no arquivo de historico do HFI
M->PA2_CODETI := cEti
M->PA2_DESSAI := "1"
//------------------------------------------------
// Adriano Guedes em 14/05/14  chamado 293131
//------------------------------------------------
M->PA2_A_LBCO := cLibCond
//------------------------------------------------

U_CRCGrPA2("SAIDAHFI")
End Transaction

If lMsErroAuto
	VTDispFile(NomeAutoLog(),.t.)
Else
	// Eduardo Souza 30/11/2017 - Chamado 369903 
	u_ALUFATC8( "H" , CB0->CB0_CODPRO , "" , "" , CB0->CB0_QTDE ) //Envia para O2P a atualizacao dos estoques
Endif

vtRestore(,,,,aTela)
VtKeyboard(Chr(20))  // zera o get

Return .f.
