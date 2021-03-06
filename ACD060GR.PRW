#include "rwmake.ch"

/*
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Programa  � ACD060GR � Autor � Alex Borges                   � Data � 15/04/16 ���
���������������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada apos execucao do enderecamento, projeto           ���
���          � A017/15. CHAMADO 344948.                                           ���
���������������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada pela funcao ACDV060 						        		  ���
���������������������������������������������������������������������������������Ĵ��
��� Uso      � SigaACD                                                            ���
���������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                     ���
���������������������������������������������������������������������������������Ĵ��
���Programador � Data   �Chamado� Motivo da Alteracao                             ���
���������������������������������������������������������������������������������Ĵ��
���Ricardo Lima�04/09/17�000000 � Atualiza saldo de estoque por produto no O2P    ���
����������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
*/
User Function ACD060GR()

_aArea    := CB0->(GetArea())

For i := 1 To Len(aHisEti)

	dbSelectArea("CB0")
	dbSetOrder(1)
	dbSeek(xFilial("CB0")+aHisEti[i][1])

	If CB0->(RecLock("CB0",.F.))
		CB0->CB0_A_CURV := SBE->BE_A_CLASS //Grava a Curva ABC na etiqueta
		CB0->(MsUnLock())
	EndIf

	//Atualiza a capacidade da rua ao informar a rua
	lRet := U_ALUACD04(CB0->CB0_LOCAL,CB0->CB0_LOCALI,CB0->CB0_QTDE)

	// Ricardo Lima - 04/09/17
	u_ALUFATC8( "E" , CB0->CB0_CODPRO , CB0->CB0_OP , CB0->CB0_LOCALI , CB0->CB0_QTDE )

Next

RestArea(_aArea)

Return