#INCLUDE "APVT100.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'TOPCONN.CH'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³  ALUACD05  ³AUTOR: ³ Andre               ³DATA: ³ 04/10/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Embarque - Programa efetua coleta de pallets, gerar e imp. ³±±
±±³         :³ NF de Saida, geracao de TXT para ser enviado por e-mail.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA    ³ ALTERACAO OCORRIDA 				  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Andre (MRC)   ³ 17/01/17 ³ CH: 359506 Adicionado parametro para       ³±±
±±³               ³          ³ controlar se gera ou não Ord. Embarque     ³±±
±±³               ³          ³ no momento do faturamento                  ³±±
±±³               ³          ³ Funciona em conjunto com Sliic             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Andre (MRC)   ³ 17/01/17 ³ CH: 359552 Adicionado desbloqueio da tabela³±±
±±³               ³          ³ SX6 Adicionado desbloqueio da tabela SX6   ³±±
±±³               ³          ³ conforme instrução: SX6->(MsRUnLock())     ³±±
±±³               ³          ³ Deve ter essa citação para funcionar       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Andre (MRC)   ³ 25/01/17 ³ CH: 359859 Ajuste de mensagem              ³±±
±±³               ³          ³ Etiqueta Invalida quando efetuado leitura  ³±±
±±³               ³          ³ da etiqueta pelo teraterm                  ³±±
±±³               ³          ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Andre (MRC)   ³ 27/01/17 ³ CH: 359924 Adicionado SOMA1 p/ evitar      ³±±
±±³               ³          ³ problema no retorno do numero de pedido de ³±±
±±³               ³          ³ venda tratado pela rotina SXE e SXF        ³±±
±±³               ³          ³                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Andre (MRC)   ³ 15/02/17 ³360563 ³ Adicionado regra de semafaro       ³±±
±±³               ³          ³       ³ antes de iniciar nova carga qdo    ³±±
±±³               ³          ³       ³ for carga mista                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima³21/02/17³CH:360684 altera no pedido quando e alterado o   ³±±
±±³            ³        ³ codigo da transportadora na ordem de embarque   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luiz Cesar  ³11/04/17³CH:361744 Correcao tratamento pTAX               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima³11/04/17³CH:362908 avalia credito somando o valor do IPI  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luiz Cesar  ³11/05/17³CH:364004 Correcao tratamento Frete              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luiz Cesar  ³20/06/17³CH:361774 Correcao Nota de exportacao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima³04/09/17³CH:362908, Atualiza Estoque no Sistema O2P com   ³±±
±±³            ³        ³ Saida de Nota Fiscal                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ALUACD05

LOCAL cMSGNome		:= ""
LOCAL cMSGEnde		:= ""
LOCAL cMSGCNPJ		:= ""
LOCAL cMSGIE		:= ""
LOCAL aKey			:= { 0, 0, 0, 0, 0 }
LOCAL cQuery		:= ""
LOCAL cItZZD 		:= "0000"

PRIVATE lMSErroAuto	:= .F.

PRIVATE cNota		:= SPACE( 09 )
PRIVATE cSerie		:= Substr( GetMV("CE_SERNFS"), 01, 03 )
PRIVATE aHoraNF		:= {}
PRIVATE cNotaVenda	:= ""
PRIVATE cSeriVenda	:= ""
PRIVATE cNotaRemessa:= ""
PRIVATE cSeriRemessa:= ""
PRIVATE cTESVenda	:= ""
PRIVATE cTESRemessa	:= ""

PRIVATE lLibFrac	:= GetNewPar("CE_LIBFRAC", ".F.")
PRIVATE cVldSEnd	:= GetNewPar("CE_VLDSEND", "N")

PRIVATE aPvlNfs		:= {}
PRIVATE aVldEtiqs	:= {}
PRIVATE aEmpenho	:= {}
PRIVATE aMatEmb		:= {}
PRIVATE aCabec		:= {}
PRIVATE aItens		:= {}
PRIVATE aLinha		:= {}

PRIVATE lHabilita	:= .T.

PRIVATE cDocEmbarq	:= SPACE( 09 )
PRIVATE cDoca		:= SPACE( 02 )
PRIVATE nOrdEmb		:= 0
PRIVATE cTransp		:= SPACE( 06 )
PRIVATE cPlacaCarr	:= SPACE( 07 )
PRIVATE cUF			:= SPACE( 02 )
PRIVATE cEtiq		:= SPACE( 10 )
PRIVATE cCliente	:= SPACE( 06 )
PRIVATE cLoja		:= SPACE( 02 )
PRIVATE cPedido		:= SPACE( 06 )
PRIVATE cItemZZJ	:= SPACE( 02 )
PRIVATE cProduto	:= SPACE( 15 )
PRIVATE cProdZZJ	:= SPACE( 15 )
PRIVATE cCodTab		:= SPACE( 06 )
PRIVATE cCondPgto	:= SPACE( 03 )
PRIVATE cLocal		:= SPACE( 02 )
PRIVATE cLocaliz	:= SPACE( 15 )
PRIVATE cTPEM		:= SPACE( 02 )
PRIVATE cPedEmb		:= SPACE( 06 )
PRIVATE dtNascimento:= CTOD("  /  /  ")
PRIVATE cMatEmb		:= ""
PRIVATE nQtdReg		:= 0

PRIVATE lGeraNota	:= .F.
PRIVATE lGerouNF	:= .F.
PRIVATE lRemessa	:= .F.
PRIVATE lATemporaria:= .F.
PRIVATE cCliTriang	:= ""
PRIVATE cLojTriang	:= ""

PRIVATE cSerieSelo	:= SPACE( 02 )
PRIVATE cNumeroSelo	:= SPACE( 10 )

PRIVATE cContainer	:= SPACE( 20 )

PRIVATE nQtdLata	:= 0
PRIVATE	nQtdPal		:= 0
PRIVATE	nQtdPalPlan	:= 0
PRIVATE nQtdLida	:= 0
PRIVATE nQtdZZM		:= 0
PRIVATE nPosLOCALIZ	:= 0
PRIVATE nPosPAL		:= 0
PRIVATE nPosFOL		:= 0
PRIVATE nPosQUA		:= 0
PRIVATE nCont		:= 0
PRIVATE nRecnoZZJ	:= 0
PRIVATE nRecnoZZJPr	:= 0

PRIVATE cAliasTMP	:= GetNextAlias()

PRIVATE aDadosEtiq

PRIVATE nVlrDolar	:= 0

PRIVATE nQtdEmpenho	:= 0

PRIVATE _lContinua	:= .F.

PRIVATE lProxZZJ	:= .F.

PRIVATE cfirstTpemb := ""

PUBLIC nQtdFolha	:= 0

VTClear()
VtClearBuffer()

@ 00,00 VTSay "Doca..: "		VTGet cDoca		Picture "@!" 		When lHabilita	Valid fValidaDoca( cDoca )			F3 "ZZI"
VTRead()

If  VtLastKey() == 27
	fRollbackCarregamento()
	Return .F.
Endif

@ 01,00 VTSay "O.E...: "		VTGet nOrdEmb	Picture "999999999"	When lHabilita	Valid fValidaOrdEmb( nOrdEmb )		F3 "ZZC"
VTRead()

If  VtLastKey() == 27
	fRollbackCarregamento()
	Return .F.
Endif

dbSelectArea("ZZJ")
dbSetOrder( 5 )
dbSeek( xFilial("ZZJ") + Alltrim( STR( nOrdEmb ) ) )
While !EOF() .AND. ZZJ->ZZJ_A_OE == nOrdEmb

	aPvlNfs		:= {}
	cNota		:= SPACE( 09 )
	cPlacaCarr	:= SPACE( 07 )
	cUF			:= SPACE( 02 )
	cPedido		:= SPACE( 06 )
	cItemZZJ	:= SPACE( 02 )
	lGeraNota	:= .F.
	lGerouNF	:= .F.
	lProxZZJ	:= .F.

	//NECESSARIO REALIZAR ESSA VALIDAÇÃO QUANDO O USUARIO SAI DO TERMINAL E A ORDEM DE EMBARQUE
	//ESTA RELACIONADO A UMA CARGA UNITIZADA
	While !lProxZZJ
		If !Empty( ZZJ->ZZJ_A_NF )
			dbSelectArea("ZZJ")
			dbSkip()
		Else
			EXIT
		Endif
	Enddo

	nRecnoZZJ	:= ZZJ->( Recno() )

	cPedido		:= ZZJ->ZZJ_A_PED
	cItemZZJ	:= ZZJ->ZZJ_A_ITPE
	cProduto	:= ZZJ->ZZJ_A_PRPE
	cProdZZJ	:= ZZJ->ZZJ_A_PRPE
	nQtdPal		:= ZZJ->ZZJ_A_QTPA
	nQtdPalPlan	:= ZZJ->ZZJ_A_QTPA

	IIF( nQtdZZM > 0, nQtdLida := nQtdZZM, nQtdLida := 0)

	//LIMPANDO TELA PARA NOVA EXIBIÇÃO
	@ 00,00 VTSay "                "
	@ 01,00 VTSay "                        "
	@ 02,00 VTSay "                        "
	@ 03,00 VTSay "                        "
	@ 04,00 VTSay "                        "
	@ 05,00 VTSay "                        "
	@ 06,00 VTSay "                        "
	@ 07,00 VTSay "                        "

	@ 00,00 VTSay "Doca..:" + cDoca
	@ 01,00 VTSay "O.E...:" + AllTrim( STR( nOrdEmb ) )
	@ 02,00 VTSay "Transp:" + cTransp

	@ 03,00 VTSay "Placa/UF:"		VTGet cPlacaCarr	Picture "@!!!9999"	When lHabilita	Valid fValidaPlaca( cPlacaCarr )
	VTRead

	If  VtLastKey() == 27
		fRollbackCarregamento()
		Return .F.
	Endif

	@ 03,17	VTGet cUF	Picture "@!"	When lHabilita	Valid ExistCpo("SX5", "12" + cUF)	F3 "12"
	VTRead

	aKey[1] := VTSetKey(09, { || InfoEmbarque( nOrdEmb ) } )		// CTRL+I
	aKey[3] := VTSetKey(24, { || Estorna( nOrdEmb ) } )				// CTRL+X

	While !EOF() .AND. ZZJ->ZZJ_A_OE == nOrdEmb .AND. ZZJ->ZZJ_A_PRPE  == cProduto .AND. ZZJ->( Recno() ) == nRecnoZZJ .AND. Empty( ZZJ->ZZJ_A_NF )

		cLocal		:= SPACE( 02 )
		cLocaliz	:= SPACE( 15 )
		cTPEM		:= SPACE( 02 )
		cEtiq		:= SPACE( 10 )

		cPedido		:= ZZJ->ZZJ_A_PED
		cItemZZJ	:= ZZJ->ZZJ_A_ITPE
		cCodTab		:= GetAdvFVal("SC5", "C5_TABELA", xFilial("SC5") + cPedido, 1, "" )

		nQtdPal		:= ZZJ->ZZJ_A_QTPA
		nQtdLata	:= ZZJ->ZZJ_A_QTD

		@ 04,00 VTSay "Produto: " + cProduto
		@ 05,00 VTSay "Qt.Pall: " + AllTrim( STR( nQtdPal ) )

		//Alberto -29/07/09- Ajuste posicionamento campos *
		@ 07,00 VtSay " Embarcadas..." + StrZero( nQtdLida, 02 )

        cfirstTpemb := "" // Guarda o tipo de embalagem para não permitir repeticao

		While nQtdLida < nQtdPal
			cEtiq := SPACE( 20 )			//SPACE( 10 )

			@ 06,00 VTSay "Etiqueta: "	VTGet cEtiq	Picture "@!"	Valid fValidaEtiq( cEtiq, cCliente, cLoja, cPedido, cItemZZJ, cProduto ) F3 "CB0"
			VTRead()

			If VTLastKey() == 27
				fRollbackCarregamento()
				Return .F.
			Endif

		Enddo

		dbSelectArea("ZZJ")
		dbSkip()

	Enddo

	//Andre (MRC) 27/01/17
	//	Chamado..: 359924
	//	Descric..: Adicionado pergunta e condicional para aguardar termino de processamento de liberação de pedido, empenho e nota fiscal (venda/remessa e demais)
	If !VTYesNo("Confirma a geracao da nota?", "Aviso", .T.)
		Return .F.
	Else
		While !_lContinua
			If !GetMV("CE_SEMACRW")
				_lContinua := .T.
				EXIT
			Else
				VTAlert("Aguarde termino de outro faturamento", "Aviso", .T., 3500 )
			Endif
		Enddo
	Endif

	//Andre (MRC) 27/01/17
	//	Chamado..: 359924
	//	Descric..: Condicionar para continuar ou não o processamento
	If _lContinua

		//Andre (MRC) 27/01/17
		//	Chamado..: 359924
		//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
		PutMV("CE_SEMACRW", .T. )

		nRecnoZZJPr	:= ZZJ->( Recno() )

		VTSetKey(09, aKey[1] )		// informacoes ref a pesquisa CTRL-I
		VTSetKey(24, aKey[3] )		// estorno CTRL+X

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Se faturamento Manaus, solicita Série/Número do Selo
		If cFilAnt == "01"
			While .T.
				VTClear()
				@ 00,00 VTSay "* SELO FISCAL *"
				@ 01,00 VTSay "Serie do Selo: "	VTGet cSerieSelo	PICTURE '@!'
				@ 02,00 VTSay "Numero do Selo"	VTGet cNumeroSelo   PICTURE '@!'
				VTRead

				VTBEEP(3)
				If VTYesNo("Confirma Selo? " +CHR(13)+CHR(10) + "--> " + Alltrim( cSerieSelo ) + " " + Alltrim( cNumeroSelo ) + " <--", "Aviso SELO", .T.)
					Exit
				EndIf
			Enddo
		Endif

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Solicita Nr. Container caso cliente seja exportação
		If GetAdvFVal("SA1", "A1_EST", xFilial("SA1") + cCliente + cLoja, 1, "") == "EX"
			While .T.
				VTClear()
				@ 00,00 VTSay "* DADOS EXPORTAÇÃO *"
				@ 02,00 VTSay "Nr. Container: " VtGet cContainer Valid !Empty( cContainer )
				VTRead
				VTBEEP(3)

				If VTYesNo("Confirma Nro Container? ", "Aviso", .T.)
					Exit
				EndIf
			Enddo
		EndIf

		BEGIN Transaction
			//Andre (MRC) 04/10/16
			//	Chamado..: 354665
			//	Projeto..: A003/15 Carteira de Pedido
			//	Descric..: Posicionando no item do pedido para recuperar recno e preparar liberação
			dbSelectArea("ZZM")
			dbSetOrder( 6 )				//FILIAL + ORD. EMBARQUE + PEDIDO + ITEM + PRODUTO
			If dbSeek( xFilial("ZZM") + STRZERO( nOrdEmb, 10 ) + cPedido + cItemZZJ + cProduto )

				While !EOF() .AND. ZZM->ZZM_A_OE == nOrdEmb

					aEmpenho	:= {}
					nQtdEmpenho	:= 0

					While !EOF() .AND. ZZM->ZZM_A_OE == nOrdEmb .AND. ZZM->ZZM_A_PED == cPedido .AND. ZZM->ZZM_A_ITPE == cItemZZJ .AND. ZZM->ZZM_A_PRPE == cProduto

						cLocal		:= ZZM->ZZM_A_LOC
						cLocaliz	:= ZZM->ZZM_A_LOCA
						cTPEM		:= ZZM->ZZM_A_TPEM
						IIf( cTPEM $ GetMV("CE_EMBPLAS"), lATemporaria := .T., lATemporaria := .F. )

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Montando Array de Empenho referente ao endereço do produto para correta baixa de estoque
						If ZZM->ZZM_A_PRPE = cProduto
							nPosLOCALIZ := AScan( aEmpenho, { |x| x[3] == ZZM->ZZM_A_LOCA } )
							If nPosLOCALIZ == 0
								AAdd( aEmpenho, { "", "", ZZM->ZZM_A_LOCA, "", ZZM->ZZM_A_QTD, 0, CTOD("  /  /  "), "", "", "", ZZM->ZZM_A_LOC, 0 } )
							Else
								aEmpenho[ nPosLOCALIZ, 5 ] += ZZM->ZZM_A_QTD
							Endif

							nQtdEmpenho := nQtdEmpenho + ZZM->ZZM_A_QTD
						Endif

						dbSelectArea("ZZM")
						dbSkip()
					Enddo

					//Andre (MRC) 04/10/16
					//	Chamado..: 354665
					//	Projeto..: A003/15 Carteira de Pedido
					//	Descric..: Atualizando informação de Volume especifico do GFE. Retorna a quantidade de palete da programação de carregamento
					dbSelectArea("SC5")
					dbSetOrder( 1 )
					If dbSeek( xFilial("SC5") + cPedido )
						If RecLock("SC5", .F.)
							SC5->C5_VOLUME1 := nQtdPal
							MsUnLock()
						Endif
					Endif

					dbSelectArea("SC6")
					dbSetOrder( 1 )
					If dbSeek( xFilial("SC6") + cPedido + cItemZZJ + cProduto )

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Continuando processo de geração de nota fiscal após realização de todas as validações necessárias (Estoque, Endereço, Crédito e demais)
						//			   com base no pedido de venda relacionado a ordem de embarque selecionada.
						//			   Próximas validações serão para atualizar preço de venda com base na última tabela de preço ativa no momento da geração da nota
						VTClear()

						@ 01,00 VTSay "Gerando Liberações..."

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Atualizando Preço de Venda com base na tabela vigente do mês de faturamento
						nPRCVEN := fAtualizaPreco( cCliente, cLoja, cProduto, 1 )			//nPRCVEN := SC6->C6_PRCVEN // Ricardo Lima - 11/04/17
						If nPRCVEN = 0
							VTAlert("Problema na atualização do preço. Processo sera abortado", "Aviso", .T., 2500 )
							DisarmTransaction()

							//Andre (MRC) 27/01/17
							//	Chamado..: 359924
							//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
							PutMV("CE_SEMACRW", .F. )
							_lContinua := .F.

							lGeraNota := .F.
							Return
						Else
							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Forçando atualização do preço de venda com base na tabela de preço vigente. Algumas vezes não atualiza utilizando a funcao fPrepara()
							//             e esta ocorrendo que na geração do preço na tabela SD2, o campo preco unitario esta sendo puxado com o valor do pedido de venda
							//             fazendo com que automaticamente seja aplicado desconto.
							dbSelectArea("SC6")
							If RecLock("SC6", .F.)
								SC6->C6_PRCVEN	:= nPRCVEN
								SC6->C6_PRUNIT	:= nPRCVEN
								SC6->C6_VALOR	:= ROUND( (SC6->C6_QTDVEN * nPRCVEN ), 2 )
								MsUnLock()
							Endif

							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Liberando quantidade(s) no pedido de venda
							//  Parametros MaLibDoFat
							//             ExpN1: Registro do SC6
							//             ExpN2: Quantidade a Liberar
							//             ExpL3: Bloqueio de Credito
							//             ExpL4: Bloqueio de Estoque
							//             ExpL5: Avaliacao de Credito
							//             ExpL6: Avaliacao de Estoque
							//             ExpL7: Permite Liberacao Parcial
							//             ExpL8: Tranfere Locais automaticamente
							//             ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao apenas avalia ).
							//             ExpbA: CodBlock a ser avaliado na gravacao do SC9
							//             ExpAB: Array com Empenhos previamente escolhidos (impede selecao dos empenhos pelas rotinas)
							//             ExpLC: Indica se apenas esta trocando lotes do SC9
							//             ExpND: Valor a ser adicionado ao limite de credito
							//             ExpNE: Quantidade a Liberar - segunda UM
							//             MaLibDoFat(nRegSC6, nQtdaLib, lCredito, lEstoque, lAvCred, lAvEst, lLibPar, lTrfLocal, aEmpenho, bBlock, aEmpPronto, lTrocaLot, lOkExpedicao, nVlrCred, nQtdalib2)
							If GetAdvFVal("SF4", "F4_ESTOQUE", xFilial("SF4") + SC6->C6_TES, 1, "" ) == "S"
								MaLibDoFat( SC6->( Recno() ), nQtdEmpenho, .T., .T., .F., .F., .F., .F., Nil, Nil, aEmpenho )		//MaLibDoFat( SC6->( Recno() ), aEmpenho[1][5], .T., .T., .F., .F., .F., .F., Nil, Nil, aEmpenho )
							Else
								MaLibDoFat( SC6->( Recno() ), nQtdEmpenho, .T., .T., .F., .F., .F., .F., Nil, Nil, {} )				//MaLibDoFat( SC6->( Recno() ), aEmpenho[1][5], .T., .T., .F., .F., .F., .F., Nil, Nil, {} )
							Endif

							dbSelectArea("SC6")
							MsUnLock()

							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Forçando atualização do preço de venda com base na tabela de preço vigente. Algumas vezes não atualiza utilizando a funcao fPrepara()
							dbSelectArea("SC9")
							If RecLock("SC9", .F.)
								SC9->C9_PRCVEN := nPRCVEN
								MsUnLock()
							Endif

							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Preparando Matriz para geração da nota fiscal
							AAdd( aPvlNfs, fPrepara( cPedido, cItemZZJ, cProduto, SC6->C6_LOCAL, nPRCVEN ) )

							SC6->( MaLiberOk( { cPedido }, .T. ) )
							SC6->( MsUnLock() )

							@ 01,00 VTSay "Pedido Liberado......"

						Endif

					Endif

					dbSelectArea("ZZM")

				Enddo

				//Andre (MRC) 04/10/16
				//	Chamado: 354665
				//	Projeto: A003/15 Carteira de Pedido
				//	Descric: Verifica se Pedido é operação Triangular através do preenchimento do campo Cli.Remessa ->C5_CLIENT
				//           Caso não seja, gera pedido de embalagem e adiciona para gerar produto + embalagem na mesma nota fiscal
				dbSeek( xFilial("SC5") + cPedido )
				If Empty( SC5->C5_CLIR )
					//Andre (MRC) 04/10/16
					//	Chamado..: 354665
					//	Projeto..: A003/15 Carteira de Pedido
					//	Descric..: Verificando se Cliente exige Mat. Embalagem. Se SIM, gera Pedido de Venda para Material de Embalagem
					dbSelectArea("ZZG")
					dbSetOrder( 1 )
					If dbSeek( xFilial("ZZG") + cCliente + cLoja ) .AND. ZZG->ZZG_A_EMB == "S"

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Adicionando Materiais de Embalagem no Pedido de Venda
						//             Teve que ser colocado aqui pois existe a possibilidade do Mat. Embalagem do Pallet
						//             ser diferente do definido no Cadastro de Produto
						@ 02,00 VTSay "Gerando Ped Embalagem"

						cPedEmb := SPACE( 06 )
						aCabec	:= {}
						aLinha	:= {}
						aItens	:= {}

						//Andre (MRC) 26/01/17
						// Chamado :
						// Ajuste  : Adicionado SOMA1 para não ter inconsistencia na sequencia de numeraçao tratado pelo SXE e SXF
						cPedEmb	:= SOMA1( AllTrim( GetSx8Num("SC5") ) )				//cPedEmb	:= GetSXENum("SC5", "C5_NUM")

						ConfirmSX8() 	//RollBAckSx8()

						AAdd(aCabec, {"C5_NUM"		, cPedEmb			, Nil } )
						AAdd(aCabec, {"C5_TIPO"		, "N"				, Nil } )
						AAdd(aCabec, {"C5_CLIENTE"	, SC5->C5_CLIENTE	, Nil } )
						AAdd(aCabec, {"C5_LOJACLI"	, SC5->C5_LOJACLI	, Nil } )
						AAdd(aCabec, {"C5_CRWTIPO"	, "E"				, Nil } )
						AAdd(aCabec, {"C5_PEDCLIE"	, cPedEmb			, Nil } )
						AAdd(aCabec, {"C5_LOJAENT"	, SC5->C5_LOJACLI	, Nil } )
						AAdd(aCabec, {"C5_TIPOCLI"	, "R"				, Nil } )
						//AAdd(aCabec, {"C5_TABELA"	, cCodTab			, Nil } )
						AAdd(aCabec, {"C5_CONDPAG"	, cCondPgto			, Nil } )
						AAdd(aCabec, {"C5_DEPOSIT"	, SC5->C5_DEPOSIT	, Nil } )
						AAdd(aCabec, {"C5_TPFRETE"	, SC5->C5_TPFRETE	, Nil } )
						AAdd(aCabec, {"C5_TRANSP"	, cTransp	        , Nil } )

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Preparando Matriz com informações dos materiais de embalagem utilizado
						fMatEmb( nOrdEmb, cPedido, cItemZZJ, cProduto )			//fMatEmb()

						For nCont := 1 TO LEN( aMatEmb )
							aLinha := {}
							AAdd( aLinha, {"C6_ITEM"	, StrZero( ( nCont + 1 ), 2 )																		,	NIL } )
							AAdd( aLinha, {"C6_PRODUTO"	, aMatEmb[ nCont, 1 ]																				,	NIL } )
							AAdd( aLinha, {"C6_UM"		, GetAdvFVal("SB1", "B1_UM", xFilial("SB1") + aMatEmb[ nCont, 1 ], 1, "" )							,	NIL } )
							AAdd( aLinha, {"C6_QTDVEN"	, aMatEmb[ nCont, 2 ]																				,	NIL } )
							AAdd( aLinha, {"C6_QTDLIB"	, aMatEmb[ nCont, 2 ]																				,	NIL } )
							AAdd( aLinha, {"C6_PRCVEN"	, GetAdvFVal("SB1", "B1_PRV1", xFilial("SB1") + aMatEmb[ nCont, 1 ], 1, "" )						,	NIL } )
							AAdd( aLinha, {"C6_VALOR"	, aMatEmb[ nCont, 2 ] * GetAdvFVal("SB1", "B1_PRV1", xFilial("SB1") + aMatEmb[ nCont, 1 ], 1, "" )	,	NIL } )
							AAdd( aLinha, {"C6_TES"		, Alltrim( GetMV("CE_TESEMB") )																		,	NIL } )
							AAdd( aLinha, {"C6_LOCAL"	, GetAdvFVal("SB1", "B1_LOCPAD", xFilial("SB1") + aMatEmb[ nCont, 1 ], 1, "" )						,	NIL } )
							AAdd( aLinha, {"C6_DESCRI"	, GetAdvFVal("SB1", "B1_DESC", xFilial("SB1") + aMatEmb[ nCont, 1 ], 1, "" )						,	NIL } )
							AAdd( aItens, aLinha )
						Next

						//MSExecAuto( { |x, y| Mata410(x, y) }, aCabec, aItens, 3 )
						MATA410( aCabec, aItens, 3 )

						If lMSErroAuto
							VTBeep(3)
							VTAlert("Pedido de Mat. Embalagem não gerado. Processo sera abortado", "Aviso", .T., 2500 )
							VTAlert( MostraErro() )
							DisarmTransaction()

							//Andre (MRC) 27/01/17
							//	Chamado..: 359924
							//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
							PutMV("CE_SEMACRW", .F. )
							_lContinua := .F.

							lGeraNota := .F.
						Else
							@ 03,00 VTSay "Liberando Embalagem..."

							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Preparando Matriz para geração da nota fiscal
							dbSelectAreA("SC5")
							dbSetOrder( 1 )
							If dbSeek( xFilial("SC5") + cPedEmb )
								dbSelectArea("SC6")
								dbSetOrder( 1 )
								If dbSeek( xFilial("SC6") + cPedEmb )
									While !EOF() .AND. SC6->C6_NUM = cPedEmb
										AAdd( aPvlNfs, fPrepara( cPedEmb, SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_PRCVEN ) )

										dbSelectArea("SC6")
										dbSkip()
									Enddo
									lGeraNota := .T.
								Endif
							Else
								VTBeep(3)
								VTAlert("Pedido de Mat. Embalagem não gerado. Processo sera abortado", "Aviso", .T., 2500 )
								DisarmTransaction()

								//Andre (MRC) 27/01/17
								//	Chamado..: 359924
								//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
								PutMV("CE_SEMACRW", .F. )
								_lContinua := .F.

								lGeraNota := .F.
							Endif
							@ 03,00 VTSay "Embalagem Liberada..."
						EndIf
					Else
						//PROCEDE COM A GERACAO DA NOTA SEM A NECESSIDADE DE INFORMAR A EMBALAGEM
						lGeraNota := .T.
					Endif
				Else
					//Andre (MRC) 04/10/16
					//	Chamado..: 354665
					//	Projeto..: A003/15 Carteira de Pedido
					//	Descric..: Setando variável que é operação triangular
					cCliTriang	:= SC5->C5_CLIR
					cLojTriang	:= SC5->C5_LOJAR

					//RETORNANDO TES DE VENDA  E  TES DE REMESSA
					dbSelectArea("SC6")
					dbSetOrder( 1 )
					If dbSeek( xFilial("SC6") + cPedido + cItemZZJ + cProduto )
						cTESVenda := SC6->C6_TES

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Retornando TES Operação Triangular
						dbSelectArea("ZZG")
						dbSetOrder( 1 )
						If dbSeek( xFilial("ZZG") + cCliente + cLoja )
							If ZZG->ZZG_A_TRIA == "S"

								cTESRemessa := ZZG->ZZG_A_TES4
								If Empty( cTESRemessa )
									VTAlert("TES Operacao Triangular definido no Cadastro Clientes Adicionais não preenchido", "Aviso", .T., 2500 )
									DisarmTransaction()

									//Andre (MRC) 27/01/17
									//	Chamado..: 359924
									//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
									PutMV("CE_SEMACRW", .F. )
									_lContinua := .F.

									lGeraNota := .F.
									Return
								Else
									dbSelectArea("SF4")
									dbSetOrder( 1 )
									If dbSeek( xFilial("SF4") + cTESRemessa )
										cTESRemessa := SF4->F4_A_TESRP
										If Empty( cTESRemessa )
											VTAlert("TES Operacao Triangular definido no Cadastro de TES não preenchido", "Aviso", .T., 2500 )
											DisarmTransaction()

											//Andre (MRC) 27/01/17
											//	Chamado..: 359924
											//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
											PutMV("CE_SEMACRW", .F. )
											_lContinua := .F.

											lGeraNota := .F.
											Return
										Endif
									Endif
								Endif
							else
									VTAlert("O Campo Op. Triangular definido no Cadastro Clientes Adicionais não preenchido - Contate area Comercial", "Aviso", .T., 2500 )
									DisarmTransaction()

									//Andre (MRC) 27/01/17
									//	Chamado..: 359924
									//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
									PutMV("CE_SEMACRW", .F. )
									_lContinua := .F.

									lGeraNota := .F.
									Return
							Endif
						else
									VTAlert("O Cadastro de Clientes Adicionais não existe !!!! - Contate area Comercial", "Aviso", .T., 2500 )
									DisarmTransaction()

									//Andre (MRC) 27/01/17
									//	Chamado..: 359924
									//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
									PutMV("CE_SEMACRW", .F. )
									_lContinua := .F.

									lGeraNota := .F.
									Return
						Endif
					Endif

					//RETORNANDO TABELA DE TRABALHO ATIVA
					dbSelectArea("ZZM")

					lRemessa	:= .T.
					lGeraNota	:= .T.
				Endif

				If lGeraNota

					@ 04,00 VTSay "Gerando Nota Fiscal.."

					//Andre (MRC) 04/10/16
					//	Chamado..: 354665
					//	Projeto..: A003/15 Carteira de Pedido
					//	Descric..: Gerando automaticamente a Nota Fiscal

					// corrigir transportadora
					SC5->(dbsetorder(1))
					SC5->(dbseek(xFilial("SC5")+cPedido))
					if Reclock("SC5",.F.)
                       SC5->C5_TRANSP := cTransp
                       MsUnlock()
					endif

					cNota := SPACE( 09 )
					cNota := MaPvlNfs( aPvlNfs, cSerie, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

					VTAlert("", "", .T., 2000)

					@ 04,00 VTSay "Nota Processada......"

					//Andre (MRC) 04/10/16
					//	Chamado..: 359552
					//	Projeto..: A003/15 Carteira de Pedido
					//	Descric..: Liberando Parametro
					dbSelectArea("SX5")
					MsUnlock()

					If ( GetMV("MV_NUMITEN", .T. ) )
						SX6->( MsRUnLock() )
					Endif

					dbSelectArea("SF2")
					dbSetOrder( 1 )
					If dbSeek( xFilial("SF2") + cNota + cSerie )

						lGerouNF	:= .T.
						aHoraNF		:= FwTimeUF( SM0->M0_ESTENT )
						cNotaVenda	:= cNota
						cSeriVenda	:= cSerie

						//Andre (MRC) 04/10/16
						//	Chamado..: 359552
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Liberando Parametro
						If ( GetMV("MV_NUMITEN", .T. ) )
							SX6->( MsRUnLock() )
						Endif

						If RecLock('SF2', .F.)
							SF2->F2_TRANSP  := cTransp
							SF2->F2_A_PLACA := cPlacaCarr
							SF2->F2_A_UFP   := cUF
							SF2->F2_SERSELO := cSerieSelo
							SF2->F2_SELO    := cNumeroSelo
							SF2->F2_CLIENT	:= SF2->F2_CLIENTE

							//Andre (MRC) 17/01/17
							//	Chamado..: 359506
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Define se amarra NF x Ord Embarque automaticamente no momento do faturamento ou sera apos (manual)
							If GetMV("CE_INSPL")
								SF2->F2_A_OE	:= AllTrim( STR( nOrdEmb ) )
							Endif

							If !Empty( cContainer )
								SF2->F2_A_CTNR := cContainer
							Endif
							MsUnlock()
						Endif

						//Andre (MRC) 17/01/17
						//	Chamado..: 359506
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Define se amarra NF x Ord Embarque automaticamente no momento do faturamento ou sera apos (manual)
						If GetMV("CE_INSPL")

							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Chamando funcao para Sincronização entre Protheus e SLIIC
							//             Dessa forma não é necessario o usuario ficar vinculando Nota X Ordem de Embarque
							dbSelectArea("ZZD")
							If Reclock("ZZD", .T.)
								cItZZD		:= Soma1( cItZZD, LEN( cItZZD ) )
								ZZD->ZZD_FILIAL	:= xFilial("ZZD")
								ZZD->ZZD_A_ITEM	:= cItZZD
								ZZD->ZZD_A_OE	:= nOrdEmb
								ZZD->ZZD_A_DOC	:= SF2->F2_DOC
								ZZD->ZZD_A_SER	:= SF2->F2_SERIE
								ZZD->ZZD_A_PLCR	:= SF2->F2_A_PLACA
								MsUnlock()
							Endif

							U_fGravaZZE( nOrdEmb, "I" )

						Endif

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Atualizando tabela de etiqueta com o numero da nota fiscal
						dbSelectArea("ZZM")
						dbSetOrder( 5 )				//FILIAL + ORDEM DE EMBARQUE + PEDIDO + ITEM
						If dbSeek( xFilial("ZZM") + STRZERO( nOrdEmb, 10 ) + cPedido + cItemZZJ )
							While !EOF() .AND. ZZM->ZZM_A_OE == nOrdEmb .AND. ZZM->ZZM_A_PED == cPedido .AND. ZZM->ZZM_A_ITPE == cItemZZJ
								dbSelectArea("CB0")
								dbSetOrder( 1 )
								If dbSeek( xFilial("CB0") + ZZM->ZZM_A_ETIQ )
									If RecLock("CB0", .F.)
										CB0->CB0_NFSAI  := cNota
										CB0->CB0_SERIES := cSerie
										CB0->CB0_A_SEMB := VAL( ZZM->ZZM_A_SEQ )
										MsUnLock()
									Endif
									// Ricardo Lima - 04/09/17
									u_ALUFATC8( "S" , CB0->CB0_CODPRO , CB0->CB0_NFSAI , CB0->CB0_LOCALI , CB0->CB0_QTDE )
								Endif
								dbSelectArea("ZZM")
								dbSkip()
							Enddo
						Endif

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Atualizando Nota Fiscal ao Planejamento de Carga
						dbSelectArea("ZZJ")
						ZZJ->( dbGoTo( nRecnoZZJ ) )
						If RecLock("ZZJ", .F.)
							ZZJ->ZZJ_A_NF	:= cNota
							ZZJ->ZZJ_A_SER	:= cSerie
							MsUnLock()
						Endif

						dbSelectArea("ZZJ")
						ZZJ->( dbGoTo( nRecnoZZJPr ) )

						If lATemporaria

							cNumPed := SPACE( 06 )

							//Andre (MRC) 26/01/17
							// Chamado :
							// Ajuste  : Adicionado SOMA1 para não ter inconsistencia na sequencia de numeraçao tratado pelo SXE e SXF
							cNumPed := SOMA1( AllTrim( GetSx8Num("SC5") ) )				//cNumPed := GetSXENum("SC5", "C5_NUM")

							ConfirmSX8() 	//RollBAckSx8()

							fRetAdmissao( cNota, cSerie, cNumPed, cMatEmb, cProduto )

						Else
							//Andre (MRC) 04/10/16
							//	Chamado: 354665
							//	Projeto: A003/15 Carteira de Pedido
							//	Descric: Gera Pedido de Venda Triangular e Nota Fiscal
							If lRemessa
								cNumPed := SPACE( 06 )

								//Andre (MRC) 26/01/17
								// Chamado :
								// Ajuste  : Adicionado SOMA1 para não ter inconsistencia na sequencia de numeraçao tratado pelo SXE e SXF
								cNumPed := SOMA1( AllTrim( GetSx8Num("SC5") ) )				//cNumPed := GetSXENum("SC5", "C5_NUM")

								ConfirmSX8() 	//RollBAckSx8()

								fGeraRemessa( cNumPed, cCliTriang, cLojTriang, cCliente, cLoja, cPedido, cItemZZJ, cProduto, nOrdEmb )

							Endif
						Endif

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Atualizando vinculo entre notas de venda e remessa
						If !Empty( cNotaVenda ) .AND. !Empty( cNotaRemessa )
							dbSelectArea("SF2")
							dbSetOrder( 1 )
							If dbSeek( xFilial("SF2") + cNotaVenda + cSerie )
								If RecLock("SF2", .F.)
									SF2->F2_A_DOCTRI := cNotaRemessa
									SF2->F2_A_SERTRI := cSerie
									MsUnlock()
								Endif

								//Andre (MRC) 04/10/16
								//	Chamado..: 354665
								//	Projeto..: A003/15 Carteira de Pedido
								//	Descric..: Retornando dados do cliente para incluir na nota fiscal
								cMSGNome	:= GetAdvFVal("SA1", "A1_NOME", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaRemessa + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )
								cMSGEnde	:= GetAdvFVal("SA1", "A1_END", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaRemessa + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )
								cMSGCNPJ	:= GetAdvFVal("SA1", "A1_CGC", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaRemessa + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )
								cMSGIE		:= GetAdvFVal("SA1", "A1_INSCR", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaRemessa + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )

								//Andre (MRC) 04/10/16
								//	Chamado..: 354665
								//	Projeto..: A003/15 Carteira de Pedido
								//	Descric..: Atualizando mensagem para nota fiscal referente ao pedido de remessa
								dbSelectArea("SD2")
								SD2->( dbSetOrder( 3 ) )
								SD2->( dbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )

								dbSelectArea("SC5")
								SC5->( dbSetOrder( 1 ) )
								If dbSeek( xFilial("SC5") + SD2->D2_PEDIDO )
									If RecLock("SC5", .F.)
										SC5->C5_MENNOTA := " MERCADORIA ENVIADA POR CONTA E ORDEM DE " + cMSGNome + "-" + cMSGEnde + "-CNPJ " + cMSGCNPJ + "-I.E." + cMSGIE + "-" + " CONF. NF. " + cNotaRemessa
										SC5->( MsUnLock( ) )
									Endif
								Endif
							Endif

							dbSelectArea("SF2")
							dbSetOrder( 1 )
							If dbSeek( xFilial("SF2") + cNotaRemessa + cSerie )
								If RecLock('SF2', .F.)
									SF2->F2_A_DOCTRI := cNotaVenda
									SF2->F2_A_SERTRI := cSerie
									MsUnlock()
								Endif

								//Andre (MRC) 04/10/16
								//	Chamado..: 354665
								//	Projeto..: A003/15 Carteira de Pedido
								//	Descric..: Retornando dados do cliente para incluir na nota fiscal
								cMSGNome	:= GetAdvFVal("SA1", "A1_NOME", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaVenda + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )
								cMSGEnde	:= GetAdvFVal("SA1", "A1_END", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaVenda + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )
								cMSGCNPJ	:= GetAdvFVal("SA1", "A1_CGC", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaVenda + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )
								cMSGIE		:= GetAdvFVal("SA1", "A1_INSCR", xFilial("SA1") + GetAdvFVal("SF2", "F2_CLIENTE", xFilial("SF2") + cNotaVenda + cSerie, 1, "") + GetAdvFVal("SF2", "F2_LOJA", xFilial("SF2") + cNotaRemessa + cSerie, 1, ""), 1, "" )

								//Andre (MRC) 04/10/16
								//	Chamado..: 354665
								//	Projeto..: A003/15 Carteira de Pedido
								//	Descric..: Atualizando mensagem para nota fiscal referente ao pedido de venda
								dbSelectArea("SD2")
								SD2->( dbSetOrder( 3 ) )
								SD2->( dbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )

								dbSelectArea("SC5")
								SC5->( dbSetOrder( 1 ) )
								If dbSeek( xFilial("SC5") + SD2->D2_PEDIDO )
									If RecLock("SC5", .F.)
										SC5->C5_MENNOTA := "A NF SEGUIU P/ " + cMSGNome + "-" + cMSGEnde + "-CNPJ " + cMSGCNPJ + "-I.E." + cMSGIE + "-" + " CONF. NF. " + cNotaVenda
										SC5->( MsUnLock( ) )
									Endif
								Endif
							Endif

							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Reposicionando nota de venda para continuidade dos processos
						    dbSelectArea("SF2")
					    	dbSetOrder( 1 )
							dbSeek( xFilial("SF2") + cNotaVenda + cSerie )

						Endif

						//Andre (MRC) 04/10/16
						//	Chamado..: 354665
						//	Projeto..: A003/15 Carteira de Pedido
						//	Descric..: Excluindo Etiquetas já processadas
						If lGerouNF
							dbSelectArea("ZZM")
							dbSetOrder( 6 )				//FILIAL + ORD. EMBARQUE + PEDIDO + ITEM + PRODUTO
							If dbSeek( xFilial("ZZM") + STRZERO( nOrdEmb, 10 ) + cPedido + cItemZZJ + cProdZZJ )
								While !EOF() .AND. ZZM->ZZM_A_OE == nOrdEmb .AND. ZZM->ZZM_A_PED == cPedido .AND. ZZM->ZZM_A_ITPE == cItemZZJ .AND. ZZM->ZZM_A_PRPE == cProdZZJ
									If RecLock("ZZM", .F.)
										dbDelete()
										MsUnLock()
									Endif
									dbSelectAreA("ZZM")
									dbSkip()
								Enddo

								//Andre (MRC) 04/10/16
								//	Chamado..: 354665
								//	Projeto..: A003/15 Carteira de Pedido
								//	Descric..: Notificando da geração da nota fiscal
								VTAlert("Gerado a Nt Fiscal " + cNotaVenda, "Aviso", .T., 1000 )
							Else
								VTAlert("Erro !!!! Não foi possivel excluir etiquetas lidas", "Aviso", .T., 2500 )
								DisarmTransaction()

								//Andre (MRC) 27/01/17
								//	Chamado..: 359924
								//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
								PutMV("CE_SEMACRW", .F. )
								_lContinua := .F.

								lGeraNota	:= .F.
								lGerouNF	:= .F.
							Endif
						Endif

					Else
						VTAlert("Erro na Geração da Nt Fiscal", "Aviso", .T., 2500 )
						DisarmTransaction()

						//Andre (MRC) 27/01/17
						//	Chamado..: 359924
						//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
						PutMV("CE_SEMACRW", .F. )
						_lContinua := .F.

						lGerouNF := .F.
					Endif

				Endif

				//Andre (MRC) 04/10/16
				//	Chamado..: 354665
				//	Projeto..: A003/15 Carteira de Pedido
				//	Descric..: Retornando tabela de detalhes de carregamento
				dbSelectArea("ZZJ")
				nQtdZZM := 0

			Endif

		END Transaction

	Endif

	dbSelectArea("SX5")
	MsRUnLock()

	dbSelectArea("SX6")
	MsRUnLock()

	dbSelectArea("SB2")
	MsUnLock()

	dbSelectArea("SC5")
	MsUnLock()

	dbSelectArea("SC6")
	MsUnLock()

	dbSelectArea("SC9")
	MsUnLock()

	dbSelectArea("ZZM")
	MsUnLock()

	dbUnLockAll()
	MsUnLockAll()

	dbCommitAll()

	//FOI NECESSARIO TRATAR FORA DA TRANSAÇÃO
	If lGerouNF

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Verificando se faturamento é Armazém Externo (PIA) para gerar dados na Tabela PAH
		U_ALUFAT58( SF2->F2_DOC, SF2->F2_SERIE )

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Verificando se faturamento é Depósito Fechado para gerar dados na Tabela PB5
		U__fImporta()

	Endif

	//Andre (MRC) 04/10/16
	//	Chamado..: 359506
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Adicionado dbSelectArea()
	dbSelectArea("ZZJ")
	nRecnoZZJPr	:= ZZJ->( Recno() )

	//Andre (MRC) 15/02/17
	//	Chamado..: 360563
	//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
	PutMV("CE_SEMACRW", .F. )
	_lContinua := .F.

Enddo

//Andre (MRC) 04/10/16
//	Chamado..: 354665
//	Projeto..: A003/15 Carteira de Pedido
//	Descric..: Atualiza informações apenas se gerou NF
If lGerouNF

	//Andre (MRC) 04/10/16
	//	Chamado..: 354665
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Liberando DOCA para novo carregamento
	dbSelectArea("ZZI")
	dbSetOrder( 1 )
	If dbSeek( xFilial("ZZI") + cDoca )
		If RecLock("ZZI", .F. )
			ZZI->ZZI_A_STAT := "L"
			MsUnLock()
		Endif
    EndIf

	//Andre (MRC) 04/10/16
	//	Chamado..: 354665
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Atualizando Status da Ordem de Embarque
	dbSelectArea("ZZC")
	dbSetOrder( 1 )
	If dbSeek( xFilial("ZZC") + AllTrim( STR( nOrdEmb ) ) )
		If RecLock("ZZC", .F. )
			ZZC->ZZC_A_STCA := "2"
			MsUnLock()
		Endif
	Endif
Endif

//Andre (MRC) 27/01/17
//	Chamado..: 359924
//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
PutMV("CE_SEMACRW", .F. )
_lContinua := .F.

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fValidaDoca ³ Autor ³ Andre (MRC)        ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar DOCA informada                               		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fValidaDoca( pDoca )

LOCAL aArea := GetArea()

If Empty( pDoca )
	Return .F.
Else
	dbSelectArea("ZZI")
	dbSetOrder( 1 )
	If !dbSeek( xFilial("ZZI") + pDoca )
		VTBeep(3)
		VTAlert("DOCA informada não existe", "Aviso", .T., 2500)
		Return .F.
	Endif
Endif

RestArea( aArea )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fValidaOrdEmb ³ Autor ³ Andre (MRC)      ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar Ordem de Embarque informada                  		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fValidaOrdEmb( pOrdEmb )

LOCAL aArea		:= GetArea()
LOCAL cQuery	:= ""
Local cTranp	:= ""

If Empty( pOrdEmb )
	Return .F.
Else
	dbSelectArea("ZZC")
	dbSetOrder( 1 )
	If !dbSeek( xFilial("ZZC") + Alltrim( STR( pOrdEmb ) ) )
		VTBeep(3)
		VTAlert("Ordem Embarque informada não existe", "Aviso", .T., 2500)
		Return .F.
	Else
		If ZZC->ZZC_EMPORI != Alltrim( SM0->M0_CODIGO ) .AND. ZZC->ZZC_FILORI != Alltrim( SM0->M0_CODFIL )
			VTBeep(3)
			VTAlert("Ordem Embarque informada não existe", "Aviso", .T., 2500)
			Return .F.
		Else
			If ZZC->ZZC_A_STCA $ "01"

				//Andre (MRC) 04/10/16
				//	Chamado..: 354665
				//	Projeto..: A003/15 Carteira de Pedido
				//	Descric..: Verificando se existe carregamento em andamento. Caso SIM, continua de onde parou a leitura das etiquetas
				cTransp		:= ZZC->ZZC_A_TRAN
				cPlacaCarr	:= AllTrim( ZZC->ZZC_A_PLCV )
				cCliente	:= ZZC->ZZC_A_CLI
				cLoja		:= ZZC->ZZC_A_LJCL

				//Andre (MRC) 04/10/16
				//	Chamado..: 354665
				//	Projeto..: A003/15 Carteira de Pedido
				//	Descric..: Query para retornar quantidade de etiquetas já processada
				If SELECT("TRBZZM") > 0
					dbSelectArea("TRBZZM")
					dbCloseArea()
				Endif

				cQuery  := " SELECT "
				cQuery	+= "     COUNT( * ) LIDO "
				cQuery	+= " FROM " + RetSQLName("ZZM") + " ZZM"
				cQuery	+= " WHERE "
				cQuery	+= "     ZZM.ZZM_FILIAL  = '" + xFilial("SZR") + "'"
				cQuery	+= " AND ZZM.ZZM_A_OE    = " + AllTrim( STR( pOrdEmb ) )
				cQuery	+= " AND ZZM.D_E_L_E_T_  = ' '"
				cQuery	:= ChangeQuery( cQuery )
				MemoWrite("ALUACD05_ZZM.SQL", cQuery )
				dbUseArea(.T., "TopConn", TCGenQry(, , cQuery), "TRBZZM", .F., .F. )
				dbSelectArea("TRBZZM")
				nQtdZZM		:= TRBZZM->LIDO
				dbCloseArea()

				// Ricardo Lima - 21/02/17
				dbSelectArea("ZZC")
				dbSetOrder( 1 )
				IF dbSeek( xFilial("ZZC") + Alltrim( STR( pOrdEmb ) ) )

				  cTranp :=  ZZC->ZZC_A_TRAN
				ENDIF

				//Andre (MRC) 04/10/16
				//	Chamado..: 354665
				//	Projeto..: A003/15 Carteira de Pedido
				//	Descric..: Posicionando no detalhe do carregamento
				dbSelectArea("ZZJ")
				dbSetOrder( 5 )
				dbSeek( xFilial("ZZJ") + Alltrim( STR( pOrdEmb ) ) )

				// Ricardo Lima - 21/02/17
				dbSelectArea("SC5")
				dbSetOrder( 1 )
				IF dbSeek( xFilial("SC5") + ZZJ->ZZJ_A_PED )
				 IF !EMPTY(cTranp)
				  	If RecLock("SC5", .F. )
				  		SC5->C5_TRANSP := cTranp
				  		MsUnLock()
					Endif
				 ENDIF
				ENDIF

			ElseIf ZZC->ZZC_A_STCA == "2"

				VTBeep(3)
				VTAlert("Ordem Embarque já faturada", "Aviso", .T., 2500)
				dbSelectArea("ZZJ")
				dbSetOrder( 1 )
				If dbSeek( xFilial("ZZJ") + Alltrim( STR( pOrdEmb ) ) )
					While !EOF() .AND. ZZJ->ZZJ_A_OE = pOrdEmb
						VTAlert("Nt Fiscal : " + ZZJ->ZZJ_A_NF, "Aviso", .T., 2500)

						dbSelectArea("ZZJ")
						dbSkip()
					Enddo
				Endif
				Return .F.
			Endif
		Endif
	Endif
Endif

RestArea( aArea )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fValidaTransp ³ Autor ³ Andre (MRC)      ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar Transportadora informada                     		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fValidaTransp( pTransp )

LOCAL aArea := GetArea()

If Empty( pTransp )
	Return .F.
Else
	dbSelectArea("SA4")
	dbSetOrder( 1 )
	If !dbSeek( xFilial("SA4") + pTransp )
		VTBeep(3)
		VTAlert("Transportadora informada não existe", "Aviso", .T., 2500)
		Return .F.
	Endif
Endif

RestArea( aArea )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fValidaPlaca ³ Autor ³ Andre (MRC)       ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar Placa informada se foi preenchido             		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fValidaPlaca( pPlaca )

If Empty( pPlaca )
	VTAlert("Placa Inválida", "Aviso", .T., 2500 )
	Return .F.
Endif

If !IsAlpha( Substr( pPlaca, 01, 01) ) .OR. !IsAlpha( Substr( pPlaca, 02, 01) ) .OR. !IsAlpha( Substr( pPlaca, 03, 01) )
	VTAlert("Placa Inválida", "Aviso", .T., 2500 )
	Return .F.
Endif

If !IsDigit( Substr( pPlaca, 04, 01) ) .OR. !IsDigit( Substr( pPlaca, 05, 01) ) .OR. !IsDigit( Substr( pPlaca, 06, 01) ) .OR. !IsDigit( Substr( pPlaca, 07, 01) )
	VTAlert("Placa Inválida", "Aviso", .T., 2500 )
	Return .F.
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fValidaQtdPal ³ Autor ³ Andre (MRC)      ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar quantidade de palete                         		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fValidaQtdPal( pQtdPal )

LOCAL aArea		:= GetArea()

//If pQtdPal = 0
//	Return .F.
//Endif
//
//If pQtdPal > nQtdPalPlan
//	VtAlert("Quantidade de Palete Lido maior que o planejado. Contate Depto de Logística", "Aviso", .T., 1500 )
//	Return
//Endif

RestArea( aArea )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fValidaEtiq ³ Autor ³ Andre (MRC)        ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar etiqueta lida e demais informações           		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fValidaEtiq( pEtiq, pCliente, pLoja, pPedido, pItem, pProduto )

LOCAL aArea		:= GetArea()
LOCAL nPosEtiq	:= 0
LOCAL cBlqCred	:= ""
LOCAL nValor	:= ROUND( ( nQtdLata * GetAdvFVal("SC6", "C6_PRCVEN", xFilial("SC6") + pPedido + pItem + AllTrim( pProduto ), 1, "" ) ), 2 )
LOCAL nMoeda	:= GetAdvFVal("SC5", "C5_MOEDA", xFilial("SC5") + pPedido, 1, "" )
LOCAL cTES		:= GetAdvFVal("SC6", "C6_TES", xFilial("SC6") + pPedido + pItem + pProduto, 1, "" )
LOCAL cTabela	:= GetAdvFVal("SC5", "C5_TABELA", xFilial("SC5") + pPedido, 1, "" )
LOCAL cTabela	:= ""
LOCAL lAvalCred	:= .F.
LOCAL nQtdPall	:= 0

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Atualizando label com quantidade de etiquetas já realizada a leitura
IIF( GetAdvFVal("SF4", "F4_DUPLIC", xFilial("SF4") + cTES, 1, "" ) == "S", lAvalCred := .T., lAvalCred := .F. )

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Realizando Análise de Regra Financeira. Se OK continua caso contrário aborta processo
If lAvalCred

	//Ricardo Lima - 11/04/17
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek( xFilial("SC5") + pPedido )
	nValor := nValor + ( nValor * ( fAtualizaPreco( pCliente, pLoja, pProduto, 2 )/100)  )

	lCredOk := MaAvalCred( pCliente, pLoja, nValor, nMoeda, .T., @cBlqCred )

	If !lCredOk
		If cBlqCred == "04"
			VtAlert("Cliente com Limite de Crédito vencido" + CRLF+CRLF + "Pallets não podem ser embarcados", "Aviso", .T., 3000 )
			VtAlert("Contate Depto Comercial para liberação", "Aviso", .T., 3000 )
		Else
			VtAlert("Pallets excedem o Limite de Crédito do Cliente" + CRLF+CRLF + "Pallets não podem ser embarcados", "Aviso", .T., 3000 )
			VtAlert("Contate Depto Comercial para liberação", "Aviso", .T., 3000 )
		Endif
		nValor := 0
		VtKeyboard(Chr(20))
		Return .F.
	Endif
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Realizando Regra Financiera
//Andre (MRC) 25/01/16
//  Chamado: 359859
//  Descric: Realizado ajuste na validação do conteudo da etiqueta
//  Estava.: If Empty( pEtiq )
If LEN( Alltrim( pEtiq ) ) # 6 .AND. LEN( Alltrim( pEtiq ) ) # 17
	VTBeep(3)
	VTAlert("Conteudo inválido", "Aviso", .T., 3000 )
	VTKeyBoard( CHR( 20 ) )
	Return .F.
Else
	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Verificando se Etiqueta existe
	dbSelectarea("CB0")
	dbSetOrder( 1 )
	If !dbSeek( xFilial("CB0") + AllTrim( pEtiq ) )  .OR. LEN( Alltrim( pEtiq ) ) < 6
		VTBeep(3)
		VTAlert("Etiqueta informada não é válida", "Aviso", .T., 3000 )
		VTKeyboard( CHR(20) )
		Return .F.
	Endif

	cMatEmb := CB0->CB0_A_TPEM

	dbSelectArea("ZZM")
	dbSetOrder( 1 )
	If dbSeek( xFilial("ZZM") + pEtiq )
		VTBeep(3)
		VTAlert("Etiqueta já foi lida", "Aviso", .T., 3000 )
		VTKeyBoard( CHR( 20 ) )
		Return .F.
	Endif
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Funcao padrão protheus que retorna dados da etiqueta
aDadosEtiq := CBRetEti( pEtiq, "01" )

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Validando Data de Nascimento da Etiqueta
If Empty( dtNascimento )
	dtNascimento := GetAdvFVal("CB0", "CB0_DTNASC", xFilial("CB0") + pEtiq, 1, "" )
Else
	If dtNascimento != GetAdvFVal("CB0", "CB0_DTNASC", xFilial("CB0") + pEtiq, 1, "" )
		VTBeep(4)
		dbSelectarea("CB0")
		dbSetOrder( 13 )
		If dbSeek( xFilial("CB0") + aDadosEtiq[ 01 ] + SPACE( 06 ) )
			If pEtiq != CB0->CB0_CODETI
				If !VTYesNo("Pallet fora da data. O pallet mais antigo é o " + CB0->CB0_CODETI + " de " + DTOC( CB0->CB0_DTNASC ) + " e esta na rua " + CB0->CB0_LOCALI + " do estoque", "Confirma o embarque do pallet LIDO?", .T. )
					VtKeyboard(Chr(20))
					Return .F.
				EndIf
			EndIf
		Endif
	Endif
EndIf

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Validadndo se o código da etiqueta lida corresponde com a ordem de embarque
If aDadosEtiq[ 01 ] != pProduto
	VTBeep(3)
	VTAlert("Produto diferente do Produto programado para Carregamento", "Aviso", .T., 3000 )
	VTKeyboard( CHR(20) )
	Return .F.
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando se Pallet já foi faturado
If !Empty( aDadosEtiq[ 13 ] )
	VTBeep(3)
	VTAlert("Pallet já faturado na Nota: " + aDadosEtiq[ 13 ], "Aviso", .T., 3000 )
	VTKeyboard( CHR(20) )
	Return .F.
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando se Pallet sofreu Distribuição
If Empty( aDadosEtiq[ 09 ] )
	VTBeep(3)
	VTAlert("Pallet não distribuido" + CRLF+CRLF + "Localização em branco", "Aviso", .T., 3000 )
	VTKeyboard( CHR(20) )
	Return .F.
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando se Pallet sofreu Distribuição e possui Almoxarifado
If Empty( aDadosEtiq[ 10 ] )
	VTBeep(3)
	VTAlert("Pallet não distribuido" + CRLF+CRLF + "Almoxarifado em branco", "Aviso", .T., 3000 )
	VTKeyboard( CHR(20) )
	Return .F.
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando de Pallet é HFI, Retrabalho ou Sucata
If aDadosEtiq[ 10 ] == GetNewPar("MV_ALMOHFI", "98") .OR. aDadosEtiq[ 10 ] == GetNewPar("MV_ALMOSUC", "40")
	VTBeep(3)
	VTAlert("Pallet pertence ao HFI, Retrabalho ou Sucata", "Aviso", .T., 3000 )
	VTKeyboard( CHR(20) )
	Return .F.
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando se é Pallet Fracionado
IIf ( Alltrim( GetAdvFVal("SB1", "B1_A_LFRAC", xFilial("SB1") + aDadosEtiq[ 01 ], 1, "") ) == "S", lLibFrac := .T., lLibFrac := .F. )

If !lLibFrac
	If aDadosEtiq[ 10 ] == GetNewPar("CE_ALMOFRA", "80")
		VTBeep(3)
		VTAlert("Necessário liberar produto para Pallet Fracionado" + CRLF+CRLF + "Contate Depto Comercial", "Aviso", .T., 3000 )
		VTKeyboard( CHR(20) )
		Return .F.
	EndIf

	//BUSCA A QTD DE LATAS DO PRODUTO E DO PALLET
	nQtdProd := GetAdvFVal("SB5", "B5_QPA", xFilial("SB5") + aDadosEtiq[ 01 ], 1, "" )
	nQtdPall := aDadosEtiq[ 2 ]

	If nQtdProd <> nQtdPall
		VTBeep(3)
		VTAlert("Nao é possivel Embarcar Pallet Fracionado !!!", "Aviso", .T., 3000 )
		VTKeyboard( CHR(20) )
		Return .F.
	EndIf
Else
	If aDadosEtiq[ 10 ] = GetNewPar("CE_ALMOFRA", "80")
		VtBeep(3)
		VtAlert("Para Embarcar Pallet Fracionado, precisa Transferir para o Almoxarifado 01!", "Aviso", .T., 3000 )
		VtKeyboard( CHR(20) )
		Return .F.
	EndIf
EndIf

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando se RUAS (Localização) esta bloqueado
dbSelectArea("SBE")
dbSetOrder( 9 )
If dbSeek( xFilial("SBE") + aDadosEtiq[ 09 ] ) .AND. !Empty( SBE->BE_DTINV )
	VTBeep(3)
	VTAlert("A RUA do Pallet " + pEtiq + " lido, esta bloqueada e não poderá ser embarcado", "Aviso", .T., 3000)
	VTKeyboard( CHR(20) )
	Return .F.
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Verificando Saldo do Endereço
If UPPER( cVldSEnd ) == "S"
	SBF->( dbSetOrder( 1 ) )
	If SBF->( dbSeek(xFilial("SBF") + aDadosEtiq[ 10 ] + aDadosEtiq[ 09 ] + aDadosEtiq[ 01 ] ) )
		nPosEtiq := aScan( aVldEtiqs, { |x| x[1] + x[2] + x[3] == aDadosEtiq[ 10 ] + aDadosEtiq[ 09 ] + aDadosEtiq[ 01 ] } )
		If nPosEtiq <= 0
			If SBF->BF_QUANT >= aDadosEtiq[ 02 ]
				AAdd( aVldEtiqs, {aDadosEtiq[ 10 ], aDadosEtiq[ 09 ], aDadosEtiq[ 01 ], aDadosEtiq[ 02 ] } )
			Else
				VTBeep(3)
				VTAlert("Não existe Saldo na RUA do Pallet lido" + CRLF+CRLF +"Etiqueta não pode ser Embarcada", "Aviso - ERROR 01", .T., 3000)
				VTKeyboard( CHR(20) )
				Return .F.
			EndIf
		Else
			If SBF->BF_QUANT >= aVldEtiqs[ nPosEtiq, 4 ] + aDadosEtiq[ 02 ]
				aVldEtiqs[ nPosEtiq,4] := aVldEtiqs[ nPosEtiq, 4 ] + aDadosEtiq[ 02 ]
			Else
				VTBeep(3)
				VTAlert("Não existe Saldo na RUA do Pallet lido" + CRLF+CRLF +"Etiqueta não pode ser Embarcada", "Aviso - ERROR 02", .T., 3000)
				VtKeyboard( CHR(20) )
				Return .F.
			EndIf
		EndIf
	Else
		VTBeep(3)
		VTAlert("Não existe Saldo na RUA do Pallet lido" + CRLF+CRLF +"Etiqueta não pode ser Embarcada", "Aviso - ERROR 03", .T., 3000)
		VTKeyboard( CHR(20) )
		Return .F.
	EndIf
EndIf

//Andre (MRC) 04/10/16
//	Chamado..: 354665
//	Projeto..: A003/15 Carteira de Pedido
//	Descric..: Atualizando Status da Ordem de Embarque
dbSelectArea("ZZC")
dbSetOrder( 1 )
If dbSeek( xFilial("ZZC") + AllTrim( STR( nOrdEmb ) ) )
	If RecLock("ZZC", .F. )
		ZZC->ZZC_A_STCA := "1"
		MsUnLock()
	Endif
Endif

// Verifica Tipo Embalagem
_cTipoEmb := GetAdvFVal("CB0", "CB0_A_TPEM", xFilial("CB0") + pEtiq, 1, "" )

if alltrim(cFirstTpemb)<>""

   if cFirstTpEmb <> _cTipoEmb
		VtBeep(3)
		VtAlert("O Mat. embalagem difere das demais etiquetas.","Aviso",.t.,6000)
		VtKeyboard(Chr(20))
		Return .F.
   endif

else

   cFirstTpEmb := _cTipoEmb
endif


//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Gravando codigo da etiqueta (realizada a leitura) e demais dados que serão utilizado no processo de geração da nota
dbSelectArea("ZZM")
If RecLock("ZZM", .T. )
	ZZM->ZZM_FILIAL		:= Alltrim( SM0->M0_CODFIL )
	ZZM->ZZM_A_DOCA		:= cDoca
	ZZM->ZZM_A_OE		:= nOrdEmb
	ZZM->ZZM_A_ETIQ		:= pEtiq
	ZZM->ZZM_A_CLI		:= pCliente
	ZZM->ZZM_A_LJCL		:= pLoja
	ZZM->ZZM_A_PED		:= pPedido
	ZZM->ZZM_A_ITPE		:= pItem
	ZZM->ZZM_A_TAB		:= cTabela
	ZZM->ZZM_A_PRPE		:= aDadosEtiq[ 01 ]
	ZZM->ZZM_A_QTD		:= aDadosEtiq[ 02 ]
	ZZM->ZZM_A_LOC		:= aDadosEtiq[ 10 ]
	ZZM->ZZM_A_LOCA		:= AllTrim( aDadosEtiq[ 09 ] )
	ZZM->ZZM_A_TPEM		:= _cTipoEmb
	ZZM->ZZM_A_SEQ		:= StrZero( ++nQtdLida, 02 )
	MsUnLock()
Endif

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Atualizando label com quantidade de etiquetas já realizada a leitura
@ 07,01 VTSay "Embarcadas.: " + StrZero( nQtdLida, 02 )

RestArea( aArea )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fMatEmb ³ Autor ³ Andre (MRC)            ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para retornar Array com os materiais de embalagem     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fMatEmb( pOrdEmb, pPedido, pItemZZJ, pProduto )

LOCAL nPosPAL
LOCAL nPosFOL
LOCAL nPosQUA

aMatEmb	:= {}

dbSelectArea("ZZM")
dbSetOrder( 2 )			//ORDEM EMBARQUE + PEDIDO + ITEM + PRODUTO + LOCALIZACAO
If dbSeek( xFilial("ZZM") + STRZERO( pOrdEmb, 10 ) + pPedido + pItemZZJ + pProduto )
	While !EOF() .AND. ZZM->ZZM_A_OE == pOrdEmb .AND. ZZM->ZZM_A_PED == pPedido .AND. ZZM->ZZM_A_ITPE == pItemZZJ .AND. ZZM->ZZM_A_PRPE == pProduto
		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Montando Array dos Materiais de Embalabem e suas respectivas quantidades
		PBZ->( dbSetOrder( 1 ) )
		PBZ->( dbSeek( xFilial("PBZ") + ZZM->ZZM_A_TPEM ) )

		//Pallet
		nPosPAL := AScan( aMatEmb, {|x| x[1] == PBZ->PBZ_A_PAL } )
		If  nPosPAL == 0
			AAdd( aMatEmb, { PBZ->PBZ_A_PAL, 1, 1 } )
		Else
			aMatEmb[ nPosPAL, 02 ] += 1
			aMatEmb[ nPosPAL, 03 ] += 1
		EndIf

		//Folha
		nPosFOL := AScan( aMatEmb, {|x| x[1] == PBZ->PBZ_A_FOL } )
		If  nPosFOL == 0
			AAdd( aMatEmb, { PBZ->PBZ_A_FOL, Int( ( ZZM->ZZM_A_QTD / ( Round( GetAdvFVal("SBM", "BM_A_QTDCA", xFilial("SBM") + ( GetAdvFVal("SB1", "B1_GRUPO", xFilial("SB1") + ZZM->ZZM_A_PRPE, 1, "" ) ), 1, "" ) / 1000, 3 ) ) ) ) + 1, 1 } )
		Else
			aMatEmb[ nPosFOL, 02 ] += Int( ( ZZM->ZZM_A_QTD / ( Round( GetAdvFVal("SBM", "BM_A_QTDCA", xFilial("SBM") + ( GetAdvFVal("SB1", "B1_GRUPO", xFilial("SB1") + ZZM->ZZM_A_PRPE, 1, "" ) ), 1, "" ) / 1000, 3 ) ) ) ) + 1
			aMatEmb[ nPosFOL, 03 ] += 1

			nQtdFolha	:= nQtdFolha + 1

		EndIf

		//Quadro
		nPosQUA := AScan( aMatEmb, {|x| x[1] == PBZ->PBZ_A_QUA } )
		If  nPosQUA == 0
			AAdd( aMatEmb, { PBZ->PBZ_A_QUA, 1, 1 } )
		Else
			aMatEmb[ nPosQUA, 02 ] += 1
			aMatEmb[ nPosQUA, 03 ] += 1
		EndIf

		dbSelectArea("ZZM")
		dbSkip()
	Enddo
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fTRBAuxiliar ³ Autor ³ Andre (MRC)       ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria tabela temporaria para auxiliar na leitura de etiqueta  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fPrepara( pPedido, pItemSC6, pProduto, pLocal, pPRCVEN )

SC5->( dbSetOrder( 1 ) )
SC5->( dbSeek( xFilial("SC5") + pPedido ) )

SC6->( dbSetOrder( 2 ) )
SC6->( dbSeek( xFilial("SC6") + pProduto + pPedido + pItemSC6 ) )
SC6->( dbSetOrder( 1 ) )

SC9->( dbSetOrder( 1 ) )
SC9->( dbSeek( xFilial("SC9") + pPedido + pItemSC6 ) )

While !SC9->( EOF() ) .AND. SC9->C9_FILIAL == xFilial("SC9");
                      .AND. SC9->C9_PEDIDO == pPedido;
                      .AND. SC9->C9_ITEM   == pItemSC6
	If Empty( SC9->C9_NFISCAL )
		EXIT
	EndIf
	SC9->( dbSkip() )
EndDo

SE4->( dbSetOrder( 1 ) )
SE4->( dbSeek( xFilial("SE4") + SC5->C5_CONDPAG ) )

SB1->( dbSetOrder( 1 ) )
SB1->( dbSeek( xFilial("SB1") + pProduto ) )

SB2->( dbSetOrder( 1 ) )
SB2->( dbSeek( xFilial("SB2") + pProduto + pLocal ) )

SF4->( dbSetOrder( 1 ) )
SF4->( dbSeek( xFilial("SF4") + SC6->C6_TES ) )

Return( { SC9->C9_PEDIDO,;		//PEDIDO
		  SC9->C9_ITEM,;		//ITEM
		  SC9->C9_SEQUEN,;		//SEQUENCIA
		  SC9->C9_QTDLIB,;		//QUANTIDADE
		  pPRCVEN,;				//SC9->C9_PRCVEN,;		//PRECO DE VENDA
		  SC9->C9_PRODUTO,;		//CODIGO PRODUTO
		  (SF4->F4_ISS=="S"),;	//SE CALCULA ISS
		  SC9->(RecNo() ),;
		  SC5->(RecNo() ),;
		  SC6->(RecNo() ),;
		  SE4->(RecNo() ),;
		  SB1->(RecNo() ),;
		  SB2->(RecNo() ),;
		  SF4->(RecNo() ) } )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fAtualizaPreco ³ Autor ³ Andre (MRC)     ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para retornar preço referente a tabela de preço       ³±±
±±³          ³ vigente da data de faturamento                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Ricardo Lima - 11/04/17
STATIC Function fAtualizaPreco( pCliente, pLoja, pProduto, pOpc )

LOCAL cQuery		:= ""
LOCAL nPRCVEN		:= 0
LOCAL cDataSM2		:= DTOS( DataValida( Date() - 1, .F.) )

LOCAL nAliqPis		:= GetMv("MV_TXPIS")
LOCAL nAliqCof		:= GetMv("MV_TXCOFIN")
LOCAL nValImp		:= ( nAliqPis + nAliqCof ) / 100

LOCAL nPerICM		:= 0
LOCAL nValICM		:= 0

LOCAL cA1_A_FATUR	:= GetAdvFVal("SA1", "A1_A_FATUR", xFilial("SA1") + pCliente + pLoja, 1, "" )

//  Chamado: 361774
//  Data...: 11/04/17
//  Analist: Luiz Cesar
//  Descric: Variaveis para controle do valor de frete
LOCAL _nItem		:= ""
LOCAL nFretPBS		:= 0
LOCAL cTpFre		:= ""
LOCAL nValFrete		:= 0
LOCAL nTotalFrete	:= 0
LOCAL nPesoLiq		:= 0
LOCAL nPesoLiq		:= 0
LOCAL nFreteKG		:= 0

LOCAL nVlrTImp		:= 0

Local cTpFrete      := 0

If Select("TRBTmp") > 0
	dbSelectArea("TRBTmp")
	dbCloseArea()
Endif

cQuery  := " SELECT "
cQuery	+= "     SZR.ZR_CODTAB, SZR.ZR_DATADE, SZR.ZR_DATAATE, SZR.ZR_CONDPAG, SZR.ZR_CLIENTE, SZR.ZR_LOJACLI, "
cQuery	+= "     SZR.ZR_STATUS, SZR.ZR_A_TPFRE, SZR.ZR_A_TES, SZR.ZR_A_TES1, SZR.ZR_A_MENNF, SZR.ZR_A_FRETE, "
cQuery	+= "     SZR.ZR_PTAX, SZR.ZR_A_TES2, SZS.ZS_ITEM, SZS.ZS_CODPRO, SZS.ZS_PRCVEN, DA1.DA1_PRCVEN, SZS.ZS_A_PEDCL, SZS.ZS_A_ITPCL, SZS.ZS_TESPRIO, "
cQuery	+= "	 SA1.A1_COD, SA1.A1_LOJA, SA1.A1_EST, SA1.A1_A_PTXD1, SA1.A1_A_PEPTX, "
cQuery	+= "	 B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO, "
cQuery	+= "	 SBM.BM_GRUPO, SBM.BM_A_PCPTA, "
cQuery	+= "	 PBS.PBS_A_CODT, PBS.PBS_A_CODG, PBS.PBS_A_PVUS, PBS.PBS_A_PVRL, PBS.PBS_A_PRUS, PBS.PBS_A_PRRL, PBS.PBS_A_TIPG, PBS.PBS_A_TPFR, PBS.PBS_A_VLPR, PBS.PBS_A_VLFR "
cQuery	+= " FROM " + RetSQLName("SZR") + " SZR, " + RetSqlName("SZS") + " SZS, " + RetSqlName("DA0") + " DA0, " + RetSqlName("SA1") + " SA1, " + RetSqlName("SB1") + " B1, " + RetSqlName("SBM") + " SBM, " + RetSqlName("PBS") + " PBS, " + RetSqlName("DA1") + " DA1 "
cQuery	+= " WHERE "
cQuery	+= "     SZR.ZR_FILIAL  = '" + xFilial("SZR") + "'"
cQuery	+= " AND SZS.ZS_FILIAL  = SZR.ZR_FILIAL"

 // Luiz Cesar - ch 361599 - correcao busca tabela preco na PBS
cQuery	+= " AND PBS.PBS_FILIAL = SZR.ZR_FILIAL"

cQuery	+= " AND DA0.DA0_FILIAL = SZR.ZR_FILIAL"
cQuery	+= " AND DA1.DA1_FILIAL = DA0.DA0_FILIAL"
cQuery	+= " AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
cQuery	+= " AND B1.B1_FILIAL   = SZR.ZR_FILIAL"
cQuery	+= " AND SBM.BM_FILIAL  = B1.B1_FILIAL"

cQuery	+= " AND SZS.ZS_CODTAB  = SZR.ZR_CODTAB"
cQuery	+= " AND DA0.DA0_CODTAB = SZR.ZR_CODTAB"
cQuery	+= " AND DA1.DA1_CODTAB = DA0.DA0_CODTAB"

cQuery	+= " AND SA1.A1_COD     = SZR.ZR_CLIENTE"
cQuery	+= " AND SA1.A1_LOJA    = SZR.ZR_LOJACLI"

cQuery	+= " AND B1.B1_COD      = SZS.ZS_CODPRO"
cQuery	+= " AND SBM.BM_GRUPO   = B1.B1_GRUPO"

cQuery	+= " AND DA1.DA1_CODPRO = SZS.ZS_CODPRO"

cQuery	+= " AND PBS.PBS_A_CODT = SZR.ZR_CODTAB"
cQuery	+= " AND PBS.PBS_A_CODG = B1.B1_GRUPO"

cQuery	+= " AND SZR.ZR_DATADE  <= '" + DTOS( dDatabase ) + "'"
cQuery	+= " AND SZR.ZR_DATAATE >= '" + DTOS( dDatabase ) + "'"

If !Empty( cA1_A_FATUR )
	cQuery	+= " AND SZR.ZR_CLIENTE = '" + Substr( cA1_A_FATUR, 01, 06 ) + "'"
	cQuery	+= " AND SZR.ZR_LOJACLI = '" + Substr( cA1_A_FATUR, 07, 02 ) + "'"
Else
	cQuery	+= " AND SZR.ZR_CLIENTE = '" + pCliente + "'"
	cQuery	+= " AND SZR.ZR_LOJACLI = '" + pLoja + "'"
Endif

cQuery	+= " AND SZS.ZS_CODPRO  = '" + pProduto + "'"
cQuery	+= " AND SZR.ZR_STATUS  = 'A'"
cQuery	+= " AND SZR.D_E_L_E_T_ = ' '"
cQuery	+= " AND SZS.D_E_L_E_T_ = ' '"
cQuery	+= " AND DA0.D_E_L_E_T_ = ' '"

cQuery	+= " AND SA1.D_E_L_E_T_ = ' '"
cQuery	+= " AND B1.D_E_L_E_T_  = ' '"
cQuery	+= " AND SBM.D_E_L_E_T_ = ' '"
cQuery	+= " AND PBS.D_E_L_E_T_ = ' '"

cQuery	+= " AND DA1.D_E_L_E_T_ = ' '"

cQuery	+= " GROUP BY "
cQuery	+= "     SZR.ZR_CODTAB, SZR.ZR_DATADE, SZR.ZR_DATAATE, SZR.ZR_CONDPAG, SZR.ZR_CLIENTE, SZR.ZR_LOJACLI, "
cQuery	+= "     SZR.ZR_STATUS, SZR.ZR_A_TPFRE, SZR.ZR_A_TES, SZR.ZR_A_TES1, SZR.ZR_A_MENNF, SZR.ZR_A_FRETE, "
cQuery	+= "     SZR.ZR_PTAX, SZR.ZR_A_TES2, SZS.ZS_ITEM, SZS.ZS_CODPRO, SZS.ZS_PRCVEN, DA1.DA1_PRCVEN, SZS.ZS_A_PEDCL, SZS.ZS_A_ITPCL, SZS.ZS_TESPRIO, "
cQuery	+= "	 SA1.A1_COD, SA1.A1_LOJA, SA1.A1_EST, SA1.A1_A_PTXD1, SA1.A1_A_PEPTX, "
cQuery	+= "	 B1.B1_COD, B1.B1_DESC, B1.B1_GRUPO, "
cQuery	+= "	 SBM.BM_GRUPO, SBM.BM_A_PCPTA, "
cQuery	+= "	 PBS.PBS_A_CODT, PBS.PBS_A_CODG, PBS.PBS_A_PVUS, PBS.PBS_A_PVRL, PBS.PBS_A_PRUS, PBS.PBS_A_PRRL, PBS.PBS_A_TIPG, PBS.PBS_A_TPFR, PBS.PBS_A_VLPR, PBS.PBS_A_VLFR "
cQuery	+= " ORDER BY "
cQuery	+= "     SZS.ZS_CODPRO"
cQuery	:= ChangeQuery( cQuery )

MemoWrite("ALUACD05.SQL", cQuery )

dbUseArea(.T., "TopConn", TCGenQry(, , cQuery), "TRBTmp", .F., .F. )

dbSelectArea("TRBTmp")

If !EOF()

	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Retornando a Taxa do Dolar do dia anterior a database do faturamento
	cCodTab		:= TRBTmp->ZR_CODTAB
	cCondPgto	:= TRBTmp->ZR_CONDPAG

	If !Empty( SC5->C5_TRANSP )
		If SC5->C5_TRANSP $ GetMV("CE_A_TRFOB")
			cTpFrete := "F"
		Else
			cTpFrete := TRBTmp->PBS_A_TPFR
		Endif
	Else
		cTpFrete := TRBTmp->PBS_A_TPFR
	Endif


	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Atualizando tabela de preço no cadastro de cliente
	dbSelectArea("SA1")
	dbSetOrder( 1 )
	If dbSeek( xFilial("SA1") + pCliente + pLoja )
		If Reclock("SA1", .F.)
			SA1->A1_TABELA := cCodTab
			MsUnlock()
		Endif
	Endif

	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Retornando a Taxa do Dolar do dia anterior a database do faturamento
	//           Utilizado para calcular o preço de venda quando o contrato comercial com
	//           o cliente exige que o valor da mercadoria seja o preço do dolar do dia
	//           anterior ao do faturamento
	dbSelectArea("SM2")
	dbSetOrder( 1 )
	If dbSeek( cDataSM2 )
		If SM2->M2_MOEDA2 > 0
			nVlrDolar := SM2->M2_MOEDA2
		Endif
	Else
		VTAlert("Valor do Dolar não definido para o dia de faturamento" + CRLF+CRLF + "Contate Depto Financeiro", "Aviso", .T., 2500 )
	Endif

	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Retornando a Aliquota do ICMS do Estado do Cliente
	//
	//  Chamado: 361774
	//  Data...: 11/04/17
	//  Analist: Luiz Cesar
	//  Descric: Retirado validação nPerICM := VAL( SUBS( GETMV("MV_ESTICM"), AT( TRBTmp->A1_EST, GetMV("MV_ESTICM") ) + 2, 2 ) )
	//           e adiciondo linhas abaixo MaFisSave, MaFisEnd, MaFisClear, MaFisIni, _nItem, MaFisAlt, nPerICM, MaFisEnd, MaFisRestore
	//           Ajustes necessários quando o cliente utiliza PTAX D-1. Estava retornando a aliquota do icms do estado do cliente e não a aliquota interestadual
	//Salva o atual
	MaFisSave()

	//Finaliza o atual
	MaFisEnd()

	//Limpa os itens e zera o cabecalho
	MaFisClear()

	//Funcao que Inicializa as Variaveis para os Calculos
	MaFisIni( pCliente, pLoja, "C", "N", NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL,NIL, NIL, NIL, pCliente, pLoja, NIL, .F. )

	_nItem := MaFisAdd( pProduto, TRBTmp->ZR_A_TES, nQtdEmpenho, TRBTmp->ZS_PRCVEN, 0 /*nDesconto*/, "", "", 0, 0, 0 /*nDespesa*/, 0 /*nSeguro*/, 0 /*nFretAut*/, 0 /*nValMerc*/, 0, NIL, NIL, NIL, NIL, NIL, NIL, NIL )

	  // Ricardo Lima - 11/04/17
	if pOpc = 2
	  nVlrTImp := MaFisRet(_nItem,"IT_ALIQIPI")
	  Return(nVlrTImp)
	endif

	//Seta o estado
	MaFisAlt("NF_UFDEST", TRBTmp->A1_EST )

	if TRBTMP->A1_EST <> 'EX'
	   nPerICM	:= MaFisRet( _nItem, "IT_ALIQICM")
	endif

	//Finaliza o calculado
	MaFisEnd()

	//Restaura anterior
	MaFisRestore()

	//nPerICM := VAL( SUBS( GETMV("MV_ESTICM"), AT( TRBTmp->A1_EST, GetMV("MV_ESTICM") ) + 2, 2 ) )		//nPerICM := VAL( SUBS( GETMV("MV_ESTICM"), AT( TRBTmp->A1_EST, GetMV("MV_ESTICM") ) + 2, 2 ) ) / 100

   	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Calculando ICMS Diferido quando configurado
	//
	//  Chamado: 361774
	//  Data...: 11/04/17
	//  Analist: Luiz Cesar
	//  Descric: Tratamento para retornar TES quando cliente é exportacao
	If TRBTmp->A1_EST != "EX"

		If !Empty( TRBTmp->ZR_A_TES )
			dbSelectAreA("SF4")
			dbSetOrder( 1 )
			If dbSeek( xFilial("SF4") + TRBTmp->ZR_A_TES ) .AND. SF4->F4_ICMSDIF == "3"
				nValICM := IIF( SF4->F4_PICMDIF != 0, ROUND( ( ( nPerICM * ( 100 - SF4->F4_PICMDIF ) ) / 10000 ), 2 ), nPerICM / 100 )
			Else
				nValICM := ( nPerICM / 100 )
			Endif
		Else
			nValICM := ( nPerICM / 100 )
		Endif
	Else

	    nValimp := 0

		If !Empty( TRBTmp->ZR_A_TES2 )
			dbSelectAreA("SF4")
			dbSetOrder( 1 )
			If dbSeek( xFilial("SF4") + TRBTmp->ZR_A_TES2 ) .AND. SF4->F4_ICMSDIF == "3"
				nValICM := IIF( SF4->F4_PICMDIF != 0, ROUND( ( ( nPerICM * ( 100 - SF4->F4_PICMDIF ) ) / 10000 ), 2 ), nPerICM / 100 )
			Else
				nValICM := ( nPerICM / 100 )
			Endif
		Else
			nValICM := ( nPerICM / 100 )
		Endif
	Endif

	//  Chamado: 361774
	//  Data...: 11/04/17
	//  Analist: Luiz Cesar
	//  Descric: Tratamento para calcular Valor Frete e Tipo de Frete
	nFretPBS	:= If( cTransp $ Getmv("CE_A_TRFOB"), 0, TRBTmp->PBS_A_VLFR )
	cTpFre		:= If( cTransp $ Getmv("CE_A_TRFOB"), "F", TRBTmp->PBS_A_TPFR )

	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Calculando Preco de Venda em Dolar
	If TRBTmp->A1_A_PTXD1 == "S"			//PTax SIM		- utiliza taxa do dollar do dia atraves da tabela SM2 para calcular o preco de venda em reais
		nPRCVEN := ( TRBTmp->PBS_A_PVUS * nVlrDolar ) + TRBTmp->PBS_A_PVRL

		//Andre (MRC) 04/10/16
		//	Chamado: 354665
		//	Projeto: A003/15 Carteira de Pedido
		//	Descric: Calculando Preco de Venda em Reais
		nPRCVEN := ROUND( ( nPRCVEN / ( 1 - ( nValICM + nValImp ) ) ), 4 )

	ElseIf TRBTmp->A1_A_PTXD1 == "M"		//PTax MEDIO	- utiliza taxa do dollar atraves de uma média calculada pelo comercial  para calcular o preco de venda
		nPRCVEN := ( TRBTmp->PBS_A_PVUS * ( ( TRBTmp->ZR_PTAX * ( TRBTmp->A1_A_PEPTX / 100 ) ) + ( nVlrDolar * ( ( 100 - TRBTmp->A1_A_PEPTX ) /100 ) ) ) + TRBTmp->PBS_A_PVRL )

		//Andre (MRC) 04/10/16
		//	Chamado: 354665
		//	Projeto: A003/15 Carteira de Pedido
		//	Descric: Calculando Preco de Venda em Reais
		nPRCVEN := ROUND( ( nPRCVEN / ( 1 - ( nValICM + nValImp ) ) ), 4 )

	Else									//PTax NAO ou ""- utiliza o preco de venda diretamente da tabela de preco
		nPRCVEN := TRBTmp->ZS_PRCVEN
	Endif


	//  Chamado: 361774
	//  Data...: 11/04/17
	//  Analist: Luiz Cesar
	//  Descric: Tratamento para calcular Valor Frete e atualizar no pedido de venda
	If TRBTmp->A1_A_PTXD1 == "S"
		nValFrete := nFretPBS * nVlrDolar

	ElseIf TRBTmp->A1_A_PTXD1 == "M"

		nValFrete := nFretPBS * ( ( nVlrDolar * ( TRBTmp->A1_A_PEPTX / 100 ) ) + ( nVlrDolar * ( ( 100 - TRBTmp->A1_A_PEPTX ) / 100 ) ) )
	Else

		nValFrete := nFretPBS * nVlrDolar
	EndIf

	nTotalFrete	:= nValFrete * nQtdEmpenho
	nPesoLiq	:= 0

 	If cTPEM $ GETMV("CE_EMBPLAS")
		nPesoLiq	:= GetAdvFVal("SB1", "B1_PESO", xFilial("SB1") + pProduto, 1, "" ) * nQtdEmpenho
		nFreteKG	:= nTotalFrete / nPesoLiq

		cCodFolha	:= GetAdvFVal("PBZ", "PBZ_A_FOL", xFilial("PBZ") + cTPEM, 1, "" )

		cPesoEmb	:= GetAdvFVal("SB1", "B1_PESO", xFilial("SB1") + cCodFolha, 1, "" )

//		nFreteEmb   := _nFreteKG * ( cPesoEmb * _nQtdFolha )
        // Luiz Cesar - Chamado 361744 - 20/06/2017
		nFreteEmb   := nFreteKG * ( cPesoEmb * nQtdFolha )

    EndIf

    //Atualizando Valor de Frete no Cabecalho do Pedido de Venda

    // Luiz Cesar - Chamado: 364004 - 11/05/2017 - Ajuste destaque de Frete para exportação
	dbSelectArea("SC5")
	dbSetOrder( 1 )
	If dbSeek( xFilial("SC5") + cPedido )
       if RecLock("SC5", .F.)

          SC5->C5_TABELA  := cCodTab
          SC5->C5_CONDPAG := ccondPgto
          SC5->C5_TPFRETE := cTpFrete
          SC5->C5_TRANSP  := cTransp

          if nTotalFrete <> 0
	         if TRBTmp->A1_EST = "EX" .and. cTpFrete='C'
		        SC5->C5_FRETE := nTotalFrete
		     Endif
		  Endif
		  MsUnLock()
	   Endif
	endif
Else
	VTAlert("Produto não encontrado na Tabela de Preço " + CRLF+CRLF + "Contate Depto Comercial", "Aviso", .T., 2500 )
Endif

dbSelectArea("TRBTmp")
dbCloseArea()

Return( nPRCVEN )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fGeraRemessa ³ Autor ³ Andre (MRC)    ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para gerar pedido e nota fiscal referente a operação  ³±±
±±³          ³ triangular. basicamente é uma operação de remessa            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fGeraRemessa( pNumPed, pCliTriang, pLojTriang, pCliente, pLoja, pPedido, pItem, pProduto, pOrdEmb )

LOCAL cTabela	:= GetAdvFVal("SA1", "A1_TABELA", xFilial("SA1") + pCliente + pLoja, 1, "" )
LOCAL cCondPag	:= GetAdvFVal("SZR", "ZR_CONDPAG", xFilial("SZR") + cTabela, 1, "" )
LOCAL cTPFrete	:= GetAdvFVal("SC5", "C5_TPFRETE", xFilial("SC5") + pPedido, 1, "" )
LOCAL cTransp	:= GetAdvFVal("SC5", "C5_TRANSP", xFilial("SC5") + pPedido, 1, "" )

LOCAL nLinha	:= 0
LOCAL aEmpenho	:= {}
LOCAL nPRCVEN	:= 0
LOCAL cTES		:= ""
LOCAL nCont		:= 0
LOCAL nLinha	:= 0

LOCAL nQtdEmpenho	:= 0

PRIVATE lMSErroAuto := .F.
PRIVATE aCabec		:= {}
PRIVATE aItens		:= {}
PRIVATE aLinha		:= {}

PRIVATE cNota		:= SPACE( 09 )
PRIVATE cSerie		:= Substr( GetMV("CE_SERNFS"), 01, 03 )
PRIVATE aHoraNF		:= {}
PRIVATE aPvlNfs		:= {}

dbSelectArea("SA1")
dbSetOrder( 1 )
If dbSeek( xFilial("SA1") + pCliTriang + pLojTriang )
	If Reclock("SA1", .F.)
		SA1->A1_TABELA := cCodTab
		MsUnlock()
	Endif
Endif

@ 04,00 VTSay "Gerando Ped Remessa.."

AAdd(aCabec, {"C5_NUM"		, pNumPed	, Nil } )
AAdd(aCabec, {"C5_TIPO"		, "N"		, Nil } )
AAdd(aCabec, {"C5_CLIENTE"	, pCliTriang, Nil } )
AAdd(aCabec, {"C5_LOJACLI"	, pLojTriang, Nil } )
AAdd(aCabec, {"C5_CRWTIPO"	, "R"		, Nil } )
AAdd(aCabec, {"C5_PEDCLIE"	, pNumPed	, Nil } )
AAdd(aCabec, {"C5_LOJAENT"	, pLojTriang, Nil } )
AAdd(aCabec, {"C5_TIPOCLI"	, "R"		, Nil } )
//AAdd(aCabec, {"C5_TABELA"	, cCodTab	, Nil } )
AAdd(aCabec, {"C5_CONDPAG"	, cCondPag	, Nil } )
AAdd(aCabec, {"C5_TPFRETE"	, cTPFrete	, Nil } )
AAdd(aCabec, {"C5_TRANSP"	, cTransp	, Nil } )
AAdd(aCabec, {"C5_VOLUME1"	, nQtdPal	, Nil } )

dbSelectArea("ZZM")
dbSetOrder( 6 )				//ORDEM EMBARQUE + PRODUTO + PEDIDO + ITEM + PRODUTO
If dbSeek( xFilial("ZZM") + STRZERO( pOrdEmb, 10 ) + pPedido + pItem + pProduto )

	While !EOF() .AND. ZZM->ZZM_A_OE == pOrdEmb

		aEmpenho	:= {}
		nQtdEmpenho	:= 0

		While !EOF() .AND. ZZM->ZZM_A_OE == pOrdEmb .AND. ZZM->ZZM_A_PED == pPedido .AND. ZZM->ZZM_A_ITPE == pItem .AND. ZZM->ZZM_A_PRPE == pProduto

			cLocal		:= ZZM->ZZM_A_LOC
			cLocaliz	:= ZZM->ZZM_A_LOCA
			cTPEM		:= ZZM->ZZM_A_TPEM

			//Andre (MRC) 04/10/16
			//	Chamado..: 354665
			//	Projeto..: A003/15 Carteira de Pedido
			//	Descric..: Montando Array de Empenho referente ao endereço do produto
			If ZZM->ZZM_A_PRPE = pProduto
				nPosLOCALIZ := AScan( aEmpenho, { |x| x[3] == ZZM->ZZM_A_LOCA } )
				If nPosLOCALIZ == 0
					AAdd( aEmpenho, { "", "", ZZM->ZZM_A_LOCA, "", ZZM->ZZM_A_QTD, 0, CTOD("  /  /  "), "", "", "", ZZM->ZZM_A_LOC, 0 } )
				Else
					aEmpenho[ nPosLOCALIZ, 5 ] += ZZM->ZZM_A_QTD
				Endif

				nQtdEmpenho := nQtdEmpenho + ZZM->ZZM_A_QTD

			Endif

			dbSelectArea("ZZM")
			dbSkip()
		Enddo

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Atualizando preço de venda atraves do cliente de venda definido no pedido de venda
		nPRCVEN := fAtualizaPreco( pCliente, pLoja, pProduto, 1 ) // Ricardo Lima - 11/04/17

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Poscionando no Produto de Venda
		dbSelectArea("SB1")
		dbSetOrder( 1 )
		dbSeek( xFilial("SB1") + pProduto )

		AAdd( aLinha, {"C6_ITEM"	, StrZero( ( ++nCont ), 2 )						,	NIL } )
		AAdd( aLinha, {"C6_PRODUTO"	, pProduto										,	NIL } )
		AAdd( aLinha, {"C6_UM"		, SB1->B1_UM									,	NIL } )
		AAdd( aLinha, {"C6_QTDVEN"	, nQtdEmpenho									,	NIL } )		//AAdd( aLinha, {"C6_QTDVEN"	, aEmpenho[1][5]								,	NIL } )
		AAdd( aLinha, {"C6_PRCVEN"	, nPRCVEN										,	NIL } )
		AAdd( aLinha, {"C6_VALOR"	, ROUND( ( nQtdEmpenho * nPRCVEN ), 2 )			,	NIL } )		//AAdd( aLinha, {"C6_VALOR"	, ROUND( ( aEmpenho[1][5] * nPRCVEN ), 2 )		,	NIL } )
		AAdd( aLinha, {"C6_TES"		, cTESRemessa									,	NIL } )
		AAdd( aLinha, {"C6_LOCAL"	, SB1->B1_LOCPAD								,	NIL } )
		AAdd( aLinha, {"C6_PRUNIT"	, nPRCVEN										,	NIL } )
		AAdd( aLinha, {"C6_DESCRI"	, SB1->B1_DESC									,	NIL } )

		AAdd( aItens, aLinha )

		//RETORNANDO AREA DE TRABALHO ATIVA
		dbSelectArea("ZZM")

	Enddo

	nLinha := LEN( aItens )

	//Andre (MRC) 04/10/16
	//	Chamado..: 354665
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Preparando Matriz com informações dos materiais de embalagem utilizado
	fMatEmb( pOrdEmb, pPedido, pItem, pProduto )				//fMatEmb()

	For nCont := 1 TO LEN( aMatEmb )
		aLinha := {}

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Poscionando no Produto de Emabalagem
		dbSelectArea("SB1")
		dbSetOrder( 1 )
		dbSeek( xFilial("SB1") + aMatEmb[ nCont, 1 ] )

		AAdd( aLinha, {"C6_ITEM"	, StrZero( ( ++nLinha ), 2 )			,	NIL } )
		AAdd( aLinha, {"C6_PRODUTO"	, aMatEmb[ nCont, 1 ]					,	NIL } )
		AAdd( aLinha, {"C6_UM"		, SB1->B1_UM							,	NIL } )
		AAdd( aLinha, {"C6_QTDVEN"	, aMatEmb[ nCont, 2 ]					,	NIL } )
		AAdd( aLinha, {"C6_PRCVEN"	, SB1->B1_PRV1							,	NIL } )
		AAdd( aLinha, {"C6_VALOR"	, aMatEmb[ nCont, 2 ] * SB1->B1_PRV1	,	NIL } )
		AAdd( aLinha, {"C6_TES"		, Alltrim( GetMV("CE_TESEMB") )			,	NIL } )
		AAdd( aLinha, {"C6_LOCAL"	, SB1->B1_LOCPAD						,	NIL } )
		AAdd( aLinha, {"C6_PRUNIT"	, SB1->B1_PRV1							,	NIL } )
		AAdd( aLinha, {"C6_DESCRI"	, SB1->B1_DESC							,	NIL } )
		AAdd( aItens, aLinha )
	Next

	//Andre (MRC) 04/10/16
	//	Chamado: 354665
	//	Projeto: A003/15 Carteira de Pedido
	//	Descric: Executando MATA410 para geração do pedido
	MSExecAuto( { |x, y| MATA410(x, y) }, aCabec, aItens, 3 )	//MATA410( aCabec, aItens, 3 )
	If lMSErroAuto
		VTAlert("Pedido Triangular não gerado para Cliente: " + CRLF+CRLF + pCliTriang + "-" + pLojTriang, "Aviso", .T., 2500 )
		MostraErro()
		DisarmTransaction()

		//Andre (MRC) 27/01/17
		//	Chamado..: 359924
		//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
		PutMV("CE_SEMACRW", .F. )
		_lContinua := .F.

		lGerouNF := .F.
	Else

		dbSelectArea("SC9")
		dbSetOrder( 1 )
		If dbSeek( xFilial("SC9") + pNumPed )
			While !EOF() .AND. SC9->C9_PEDIDO == pNumPed
				If EMPTY( SC9->C9_NFISCAL )
					If RecLock("SC9", .F. )
						dbDelete()
						MsUnLock()
					Endif
					dbSkip()
				Endif
			Enddo
		Endif

		@ 04,00 VTSay "Liberando Ped Remessa"

		dbSelectArea("SC6")
		dbSetOrder( 1 )
		If dbSeek( xFilial("SC6") + pNumPed )
			While !EOF() .AND. SC6->C6_NUM == pNumPed
				//Andre (MRC) 04/10/16
				//	Chamado..: 354665
				//	Projeto..: A003/15 Carteira de Pedido
				//	Descric..: Liberando quantidade(s) no pedido de venda
				//  Parametros MaLibDoFat
				//             ExpN1: Registro do SC6
				//             ExpN2: Quantidade a Liberar
				//             ExpL3: Bloqueio de Credito
				//             ExpL4: Bloqueio de Estoque
				//             ExpL5: Avaliacao de Credito
				//             ExpL6: Avaliacao de Estoque
				//             ExpL7: Permite Liberacao Parcial
				//             ExpL8: Tranfere Locais automaticamente
				//             ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao apenas avalia ).
				//             ExpbA: CodBlock a ser avaliado na gravacao do SC9
				//             ExpAB: Array com Empenhos previamente escolhidos (impede selecao dos empenhos pelas rotinas)
				//             ExpLC: Indica se apenas esta trocando lotes do SC9
				//             ExpND: Valor a ser adicionado ao limite de credito
				//             ExpNE: Quantidade a Liberar - segunda UM
				//             MaLibDoFat(nRegSC6, nQtdaLib, lCredito, lEstoque, lAvCred, lAvEst, lLibPar, lTrfLocal, aEmpenho, bBlock, aEmpPronto, lTrocaLot, lOkExpedicao, nVlrCred, nQtdalib2)
				dbSelectArea("SF4")
				dbSetOrder( 1 )
				If dbSeek( xFilial("SF4") + SC6->C6_TES )
					If SF4->F4_ESTOQUE == "S"
						MaLibDoFat( SC6->( Recno() ), SC6->C6_QTDVEN, .T., .T., .F., .F., .F., .F., Nil, Nil, aEmpenho )
					Else
						MaLibDoFat( SC6->( Recno() ), SC6->C6_QTDVEN, .T., .T., .F., .F., .F., .F., Nil, Nil, {} )
					Endif

					dbSelectArea("SC6")
					MsUnLock()

					//Andre (MRC) 04/10/16
					//	Chamado..: 354665
					//	Projeto..: A003/15 Carteira de Pedido
					//	Descric..: Posicionando nas linhas do pedido para liberação
					dbSelectArea("SC9")
					dbSetOrder( 1 )
					If dbSeek( xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM )
						If SC9->C9_PEDIDO = SC6->C6_NUM .AND. SC9->C9_ITEM == SC6->C6_ITEM .AND. SC9->C9_PRODUTO == SC6->C6_PRODUTO
							//Andre (MRC) 04/10/16
							//	Chamado..: 354665
							//	Projeto..: A003/15 Carteira de Pedido
							//	Descric..: Preparando Matriz para geração da nota fiscal
							AAdd( aPvlNfs, fPrepara( SC6->C6_NUM, SC9->C9_ITEM, SC9->C9_PRODUTO, SC9->C9_LOCAL, SC9->C9_PRCVEN ) )
						Endif
					Endif
				Endif

				dbSelectArea("SC6")
				dbSkip()
			Enddo
		Endif

		@ 04,00 VTSay "Liberado Ped Remessa "

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Gerando automaticamente a Nota Fiscal
		cNota := SPACE( 09 )
		cNota := MaPvlNfs( aPvlNfs, cSerie, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

		//Andre (MRC) 04/10/16
		//	Chamado..: 359552
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Liberando Parametro
		dbSelectArea("SX5")
		MsUnlock()

		If ( GetMV("MV_NUMITEN", .T. ) )
			SX6->( MsRUnLock() )
		Endif

		dbSelectArea("SF2")
		dbSetOrder( 1 )
		If dbSeek( xFilial("SF2") + cNota + cSerie )

			aHoraNF			:= FwTimeUF( SM0->M0_ESTENT )
			cNotaRemessa	:= cNota

			//Andre (MRC) 04/10/16
			//	Chamado..: 359552
			//	Projeto..: A003/15 Carteira de Pedido
			//	Descric..: Liberando Parametro
			If ( GetMV("MV_NUMITEN", .T. ) )
				SX6->( MsRUnLock() )
			Endif

			If RecLock('SF2', .F.)
				SF2->F2_TRANSP  := cTransp
				SF2->F2_A_PLACA := cPlacaCarr
				SF2->F2_A_UFP   := cUF
				SF2->F2_CLIENT	:= SF2->F2_CLIENTE

				If !Empty( cContainer )
					SF2->F2_A_CTNR := cContainer
				Endif

				//Andre (MRC) 17/01/17
				//	Chamado..: 359506
				//	Projeto..: A003/15 Carteira de Pedido
				//	Descric..: Define se amarra NF x Ord Embarque automaticamente no momento do faturamento ou sera apos (manual)
				If GetMV("CE_INSPL")
					SF2->F2_A_OE	:= AllTrim( STR( nOrdEmb ) )
				Endif

				MsUnlock()
			Endif

			//Andre (MRC) 04/10/16
			//	Chamado..: 354665
			//	Projeto..: A003/15 Carteira de Pedido
			//	Descric..: Notificando da geração da nota fiscal
			VTClear()
			VTAlert("Gerado a Nt Fiscal Remessa " + cNota, "Aviso", .T., 1000 )
		Else
			VTClear()
			VTAlert("Problema na geração da Nt Fiscal Remessa", "Aviso", .T., 2500 )
			DisarmTransaction()

			//Andre (MRC) 27/01/17
			//	Chamado..: 359924
			//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
			PutMV("CE_SEMACRW", .F. )
			_lContinua := .F.

			lGerouNF := .T.
		Endif
	Endif
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fRetAdmissao ³ Autor ³ Andre (MRC)       ³ Data ³ 06/10/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para gerar pedido e nota fiscal retorno de admissão   ³±±
±±³          ³ temporaria dos produtos de embalagem                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fRetAdmissao( pNota, pSerie, pPedido, pMatEmb, pProduto )

LOCAL cMSGNOta	:= GetMV("CE_MSGADM") + Alltrim( pNota ) + "."
LOCAL cCodFol	:= GetAdvFVal("PBZ", "PBZ_A_FOL", xFilial("PBZ") + pMatEmb, 1, "" )
LOCAL cGRPLata	:= GetAdvFVal("SB1", "B1_GRUPO", xFilial("SB1") + pProduto, 1, "" )
LOCAL nQPA		:= GetAdvFVal("SB5", "B5_QPA", xFilial("SB5") + pProduto, 1, "" )
LOCAL nQtdCam	:= GetAdvFVal("SBM", "BM_A_QTDCA", xFilial("SBM") + cGRPLata, 1, "" )

PRIVATE lMSErroAuto := .F.
PRIVATE aCabec		:= {}
PRIVATE aItens		:= {}
PRIVATE aLinha		:= {}

PRIVATE cNota		:= SPACE( 09 )
PRIVATE cSerie		:= Substr( GetMV("CE_SERNFS"), 01, 03 )
PRIVATE aHoraNF		:= {}
PRIVATE aPvlNfs		:= {}

Posicione("SF2", 1, xFilial("SF2") + pNota + pSerie, "F2_DOC" )
Posicione("SB1", 1, xFilial("SB1") + cCodFol, "B1_GRUPO" )

If SB1->B1_MSBLQL == "1"
	VTBeep(3)
	VTAlert("Produto " + cCodFol + " bloqueado" + CRLF+CRLF + "Para gerar a nota fiscal de Admissao Temporaria, entre em contato com o depto de logistica", "Aviso", .T., 2500 )
	DisarmTransaction()

	//Andre (MRC) 27/01/17
	//	Chamado..: 359924
	//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
	PutMV("CE_SEMACRW", .F. )
	_lContinua := .F.

	Return .F.
Endif

If nQtdCam > 0
	nQtdCam := Round( nQtdCam / 1000, 3 )
Else
	VTBeep(3)
	VTAlert("Quantidade de Lata por Camada não informado" + CRLF+CRLF + "Ajustar Cadastro de Grupos do Produto " + Alltrim( cGRPLata ) + CRLF+CRLF +"Contate Depto Comercial", "Aviso", .T., 2500 )
	DisarmTransaction()

	//Andre (MRC) 27/01/17
	//	Chamado..: 359924
	//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
	PutMV("CE_SEMACRW", .F. )
	_lContinua := .F.

	lGerouNF := .T.
	Return .F.
EndIf

nQtdVolume	:= SF2->F2_VOLUME1
nQtdEmb		:= ( ( nQtdVolume * nQPA ) / nQtdCam ) + nQtdVolume
nPeso 		:= ( nQtdEmb * SB1->B1_PESO )
nFrete		:= GetMV("CE_VLRFRT") * nVlrDolar
nPRCVEN		:= SB1->B1_PRV1

@ 04,00 VTSay "Gerando Ped Ad. Temp."

AAdd(aCabec, {"C5_NUM"		, pPedido			, Nil } )
AAdd(aCabec, {"C5_TIPO"		, "N"				, Nil } )
AAdd(aCabec, {"C5_CLIENTE"	, SF2->F2_CLIENTE	, Nil } )
AAdd(aCabec, {"C5_LOJACLI"	, SF2->F2_LOJA		, Nil } )
AAdd(aCabec, {"C5_CRWTIPO"	, "R"				, Nil } )
AAdd(aCabec, {"C5_TIPOCLI"	, "X"				, Nil } )
AAdd(aCabec, {"C5_LOJAENT"	, SF2->F2_LOJA		, Nil } )
AAdd(aCabec, {"C5_CONDPAG"	, SF2->F2_COND		, Nil } )
AAdd(aCabec, {"C5_TPFRETE"	, SF2->F2_TPFRETE	, Nil } )
AAdd(aCabec, {"C5_TRANSP"	, SF2->F2_TRANSP	, Nil } )
AAdd(aCabec, {"C5_MENNOTA"	, cMSGNota			, Nil } )
AAdd(aCabec, {"C5_VOLUME1"	, nQtdVolume		, Nil } )
AAdd(aCabec, {"C5_ESPECI1"	, "UN"				, Nil } )
AAdd(aCabec, {"C5_PBRUTO"	, nPeso				, Nil } )
AAdd(aCabec, {"C5_PESOL"	, nPeso				, Nil } )
AAdd(aCabec, {"C5_FRETE"	, nFrete			, Nil } )

If SM0->M0_CODIGO + SM0->M0_CODFIL == "0101"
	AAdd(aCabec, {"C5_A_LOEMB"	, "13226"	, Nil } )
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0102"
	AAdd(aCabec, {"C5_A_LOEMB"	, "41173"	, Nil } )
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0104"
	AAdd(aCabec, {"C5_A_LOEMB"	, "42285"	, Nil } )
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0105"
	AAdd(aCabec, {"C5_A_LOEMB"	, "32441"	, Nil } )
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0106"
	AAdd(aCabec, {"C5_A_LOEMB"	, "23205"	, Nil } )
Endif

AAdd(aLinha, {"C6_ITEM"		, StrZero(1, 2 )					, NIL } )
AAdd(aLinha, {"C6_PRODUTO"	, SB1->B1_COD						, NIL } )
AAdd(aLinha, {"C6_UM"		, SB1->B1_UM 						, NIL } )
AAdd(aLinha, {"C6_QTDVEN"	, nQtdEmb							, NIL } )
AAdd(aLinha, {"C6_QTDLIB"	, nQtdEmb							, NIL } )
AAdd(aLinha, {"C6_PRCVEN"	, nPRCVEN							, NIL } )
AAdd(aLinha, {"C6_VALOR"	, ROUND( ( nQtdEmb * nPRCVEN ), 2 )	, NIL } )
AAdd(aLinha, {"C6_TES"		, SB1->B1_TS						, NIL } )
AAdd(aLinha, {"C6_LOCAL"	, SB1->B1_LOCPAD					, NIL } )
AAdd(aLinha, {"C6_PRUNIT"	, SB1->B1_PRV1						, NIL } )
AAdd(aLinha, {"C6_DESCRI"	, SB1->B1_DESC						, NIL } )
AAdd(aItens, aLinha )

//Andre (MRC) 04/10/16
//	Chamado: 354665
//	Projeto: A003/15 Carteira de Pedido
//	Descric: Executando MATA410 para geração do pedido
MSExecAuto( { |x, y| MATA410(x, y) }, aCabec, aItens, 3 )
If lMSErroAuto
	VTAlert("Pedido Admissão Temporária não gerado para Cliente " + CRLF+CRLF + SF2->F2_CLIENTE + "-" + SF2->F2_LOJA, "Aviso", .T., 2500 )
	MostraErro()
	DisarmTransaction()

	//Andre (MRC) 27/01/17
	//	Chamado..: 359924
	//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
	PutMV("CE_SEMACRW", .F. )
	_lContinua := .F.

Else

	@ 04,00 VTSay "Liberan Ped Ad. Temp."

	//Andre (MRC) 04/10/16
	//	Chamado..: 354665
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Posicionando nas linhas do pedido para liberação
	SC9->( dbSetOrder( 1 ) )
	SC9->( dbSeek( xFilial("SC9") + pPedido ) )
	While !EOF() .AND. SC9->C9_PEDIDO = pPedido
		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Preparando Matriz para geração da nota fiscal
		AAdd( aPvlNfs, fPrepara( pPedido, SC9->C9_ITEM, SC9->C9_PRODUTO, SC9->C9_LOCAL, SC9->C9_PRCVEN ) )

		dbSelectArea("SC9")
		dbSkip()
	Enddo

	@ 04,00 VTSay "Liberado Ped Ad Temp."

	@ 04,00 VTSay "Gerando Nota Ad Temp."

	//Andre (MRC) 04/10/16
	//	Chamado..: 354665
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Gerando automaticamente a Nota Fiscal
	cNota := SPACE( 09 )
	cNota := MaPvlNfs( aPvlNfs, cSerie, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

	@ 04,00 VTSay "Gerado  Nota Ad Temp."

	//Andre (MRC) 04/10/16
	//	Chamado..: 359552
	//	Projeto..: A003/15 Carteira de Pedido
	//	Descric..: Liberando Parametro
	dbSelectArea("SX5")
	MsUnlock()

	If ( GetMV("MV_NUMITEN", .T. ) )
		SX6->( MsRUnLock() )
	Endif

	dbSelectArea("SF2")
	dbSetOrder( 1 )
	If dbSeek( xFilial("SF2") + cNota + cSerie )

		aHoraNF	:=	FwTimeUF( SM0->M0_ESTENT )

		//Andre (MRC) 04/10/16
		//	Chamado..: 359552
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Liberando Parametro
		If ( GetMV("MV_NUMITEN", .T. ) )
			SX6->( MsRUnLock() )
		Endif

		If RecLock('SF2', .F.)
			SF2->F2_TRANSP  := cTransp
			SF2->F2_A_PLACA := cPlacaCarr
			SF2->F2_A_UFP   := cUF
			SF2->F2_CLIENT	:= SF2->F2_CLIENTE

			//Andre (MRC) 17/01/17
			//	Chamado..: 359506
			//	Projeto..: A003/15 Carteira de Pedido
			//	Descric..: Define se amarra NF x Ord Embarque automaticamente no momento do faturamento ou sera apos (manual)
			If GetMV("CE_INSPL")
				SF2->F2_A_OE	:= AllTrim( STR( nOrdEmb ) )
			Endif

			MsUnlock()
		Endif

		//Andre (MRC) 04/10/16
		//	Chamado..: 354665
		//	Projeto..: A003/15 Carteira de Pedido
		//	Descric..: Notificando da geração da nota fiscal
		VTClear()
		VTAlert("Gerado a Nt Fiscal Admissão Temporária " + cNota, "Aviso", .T., 1000 )
	Else
		VTClear()
		VTAlert("Problema na geração da Nt Fiscal Admissão Temporária", "Aviso", .T., 2500 )
		DisarmTransaction()

		//Andre (MRC) 27/01/17
		//	Chamado..: 359924
		//	Descric..: Atualizando parametro de controle de continuidade do processo de geração de documento
		PutMV("CE_SEMACRW", .F. )
		_lContinua := .F.

		lGerouNF := .T.
	Endif
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fRollbackCarregamento ³ Autor ³ Andre (MRC) ³ Data ³ 06/10/16³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao realizar o rollback de carregamento apagando tabela   ³±±
±±³          ³ temporaria e voltando status de ord. embarque e doca         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                     									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function fRollbackCarregamento()

//Andre (MRC) 04/10/16
//	Chamado..: 354665
//	Projeto..: A003/15 Carteira de Pedido
//	Descric..: Liberando Doca para novo carregamento
dbSelectArea("ZZI")
dbSetOrder( 1 )
If dbSeek( xFilial("ZZI") + cDoca )
	If RecLock("ZZI", .F. )
		ZZI->ZZI_A_STAT := "L"
		MsUnLock()
	Endif
Endif

//Andre (MRC) 04/10/16
//	Chamado..: 354665
//	Projeto..: A003/15 Carteira de Pedido
//	Descric..: Atualizando Status da Ordem de Embarque - Liberando Ordem de Embarque para ser selecionada novamente
dbSelectArea("ZZM")
dbSetOrder( 3 )
If !dbSeek( xFilial("ZZM") + AllTrim( STR( nOrdEmb ) ) )
	dbSelectArea("ZZC")
	dbSetOrder( 1 )
	If dbSeek( xFilial("ZZC") + Alltrim( STR( nOrdEmb ) ) )
		If !ZZC->ZZC_A_STCA $ "12"
			If RecLock("ZZC", .F. )
				ZZC->ZZC_A_STCA := "0"
				MsUnLock()
			Endif
		Endif
	Endif
Endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ InfoEmbarque ³ Autor ³ Sandro            ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao de Informacoes sobre o Embarque. Utilizada pelo     ³±±
±±³          ³ programa principal CRC010                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function InfoEmbarque( pOrdEmb )

Local nX		:= 0
Local aSize		:= {}
Local aCab		:= {}
Local aTela
Local aAreaZZM	:= ZZM->( GetArea() )

aTela			:= VTSave()
VTClear()

aFields := {"ZZM_A_ETIQ", "ZZM_A_PRPE", "ZZM_A_QTD", "ZZM_A_LOCA"}
aSize   := {10, 20, 15, 15}
aHeader := {"ID.Eti", "Produto", "Qtde", "Endereco"}

dbSelectArea("ZZM")
dbSetFilter( { || ZZM_A_OE = VAL( AllTrim( STR( pOrdEmb ) ) ) }, 'ZZM_A_OE = VAL( AllTrim( STR( pOrdEmb ) ) )' )
nRecno := VTDBBrowse(00, 00, 07, 19, "ZZM", aHeader, aFields, aSize)
VTRestore(, , , , aTela )

RestArea( aAreaZZM )

RETURN



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Estorna ³ Autor ³ Sandro                 ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao de Estorno de Pallet. Utilizada pelo programa CRC010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function Estorna( pOrdEmb )

Local aTela
Local nX		:= 0
Local aAreaZZM	:= ZZM->( GetArea() )
Local cEtiq		:= SPACE(20)

aTela 			:= VTSave()
VTClear()

@ 00,00 VTSay Padc("Estorno de Pallet", VTMaxCol() )
@ 03,00 VTSay "Etiqueta:"
@ 04,00 VTGet cEtiq	PICT "@!" VALID !Empty( cEtiq )
VTRead()

If VTLastkey() # 27
	If VTYesNo("Confirma o estorno deste Pallet?", "Atencao", .T.)
		dbSelectArea("ZZM")
		dbSetOrder( 1 )
		If dbSeek( xFilial("ZZM") + AllTrim( cEtiq ) )
			If ZZM->ZZM_A_OE = pOrdEmb
				If RecLock("ZZM", .F.)
					dbDelete()
					MsUnLock()
					nQtdLida := nQtdLida - 1
				Endif
			Endif
		Else
			VTBeep(3)
			VtAlert('Pallet nao encontrado', 'Atencao', .T., 2500)
		Endif
	Endif
EndIf

VTRestore( , , , , aTela )

//Alberto -29/07/09- Ajuste posicionamento campos *
@ 07,00 VtSay " Embarcadas..." + StrZero( nQtdLida, 02 )

RestArea( aAreaZZM )

Return
