#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'AP5MAIL.CH'
#INCLUDE "MSOLE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOTVS.CH"

#DEFINE oleWdFormatPDF '17'
#DEFINE oleWdPrintBack

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ ALUFAT81 ³ AUTOR ³ Felipe Geraldo (MRC)  ³ DATA ³ 20/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Imprime Laudos Automatico							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ SIGAFAT - Alumínio       						          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ Faturamento (Chamado 241296)					         	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Felipe (MRC)  ³24/01/13³ CHAMADO 262079: Substituicao do dbseek no SF2³±±
±±³               ³        ³por query uma vez que no Protheus 11 se a NF  ³±±
±±³               ³        ³nao estiver no browse da tela o dbseek falha  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³26/04/13³ CHAMADO 264820: Imprimir o laudo para nfs    ³±±
±±³               ³        ³de faturamento geradas pelo PIA.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cristiane      ³21/08/13³ CHAMADO 278053: Ajuste na query              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³22/04/14³ CHAMADO: 295095: POrtal do cliente geração do³±±
±±³               ³        ³ array para geração do Laudo                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³15/07/14³ CHAMADO: 295095: Troca de email do aviso     ³±±
±±³               ³        ³ de nf sem laudo                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³11/02/15³ CHAMADO: 315190: Como melhoria, não enviar   ³±±
±±³               ³        ³ email para "informatica@crowncork.com.br"    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Bruno Silva    ³27/07/16³ CHAMADO: 346059: Foi incluido um alerta em   ³±±
±±³               ³        ³ casos de produtos que necessitam de vinculo  ³±±
±±³               ³        ³ na exportação                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³10/08/16³ Projeto A006/16. Chamado 352746. Impressao do³±±
±±³               ³        ³ numero da nota fiscal no laudo de qualidade  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alex Borges    ³02/09/16³ Projeto A006/16. Chamado 352746. Caso a filial±±
±±³               ³        ³ não gerar o arquivo "DOT", imprimir o PDF.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Andre (MRC)    ³22/05/17³ A013/17 - Laudo de Qualidade                  ±±
±±³               ³        ³ Impressao Laudo a partir das tabelaso PDF.   ³±±
±±³               ³        ³ ZB4 e ZB5                                    ³±±
±±³               ³        ³ Chamado : 363515                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³29/09/17³ Chamado 369846. Projeto A031/17. Laudo de    ³±±
±±³               ³        ³ Qualidade por email.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ALUFAT81( _cNotaDe, _cNotaAte, _cSerie )

	LOCAL _aAreaAtu := GetArea()
	LOCAL _aAreaSA1 := SA1->(GetArea())
	LOCAL _aDiasPr  := {}
	LOCAL _aLaudos  := {}
	LOCAL _aInfEml  := {}
	LOCAL _cEmpFil  := GetNewPar("CE_DIRELAU","")
	LOCAL _cPathLau := GetNewPar("CE_PATHLAU","\\192.168.10.22\dptos$\Certificados_DFS") + _cEmpFil + "\"
	LOCAL _cFile    := ""
	LOCAL _cQuery   := ""
	LOCAL _EnvEml   := .F.
	LOCAL _cCodLata := GetNewPar("CE_CODLATA","'402092865','402092866','402092867','402092868'")
	LOCAL cDtCorte  := Getmv("CE_DTLAUD") //Alex Borges - 10/08/2016 - Chamado 352746

	//Andre (MRC) 22/05/17
	//	Chamado..: 363515
	//	Descric..: Criando variaveis para controle
	LOCAL cQueryZB4	:= ""
	LOCAL cDtCorZB4 := Getmv("CE_DTLAUD1")
	LOCAL cCodLaudo	:= ""   
	
	//Alex Borges - 29/09/17 - Chamado 369846
	PRIVATE _aLaudoEmail := {}
	PRIVATE cLotes       := "" 
	PRIVATE lMailConsol  := GETMV("CE_LAUCONS")

	//Felipe (MRC) - 24/01/13 - Substituicao do dbseek no SF2 por query
	If SELECT("SF2TMP") > 0
		SF2TMP->(dbCloseArea())
	EndIf

	_cQuery := " SELECT * "
	_cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
	_cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
	_cQuery += " AND F2_DOC >= '" + _cNotaDe  + "' "
	_cQuery += " AND F2_DOC <= '" + _cNotaAte + "' "
	_cQuery += " AND D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY F2_DOC,F2_SERIE "
	_cQuery := ChangeQuery(_cQuery)
	MemoWrite("\SYSTEM\QUERY\ALUFAT81_SF2.SQL",_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SF2TMP",.T.,.T.)

	dbSelectArea("SF2TMP")
	SF2TMP->( dbGoTop() )
	While SF2TMP->(!EOF()) .AND. SF2TMP->F2_FILIAL + SF2TMP->F2_DOC + SF2TMP->F2_SERIE <= xFilial("SF2") + _cNotaAte + _cSerie

		If SF2TMP->F2_TIPO == "N"

			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek( xFilial("SA1") + SF2TMP->F2_CLIENTE + SF2TMP->F2_LOJA ) .AND. SA1->A1_A_LAUDO == "S"


				If Select("CB0TMP") > 0
					CB0TMP->(dbCloseArea())
				EndIf

				//Alberto - 26/04/13- Tratamento para imprimir o laudo quando a nota for gerada pelo PIA
				//                    Se a nota existir na tabela PAH, significa que foi gerada pelo PIA
				//Cristiane - 21/08/13 - Coloquei o comando and na linha do CB0.Delete
				dbSelectArea("PAH")
				dbSetOrder(5)
				If dbSeek( xFilial("PAH") + SF2TMP->F2_DOC + SF2TMP->F2_SERIE )
					_cQuery := " SELECT * "
					_cQuery += " FROM " + RetSqlName("CB0") + " CB0, "+RetSqlName("PAH") + " PAH "
					_cQuery += " WHERE CB0_FILIAL = '" + xFilial("CB0") + "' AND "
					_cQuery += " CB0_FILIAL = PAH_FILIAL AND "
					_cQuery += " CB0_CODETI = PAH_A_ETIQ AND "
					_cQuery += " PAH_A_NFFT = '" + SF2TMP->F2_DOC + "' AND "
					_cQuery += " PAH_A_SERF = '" + SF2TMP->F2_SERIE + "' AND "
					_cQuery += " CB0.D_E_L_E_T_ = ' ' " + " AND "
					_cQuery += " PAH.D_E_L_E_T_ = ' ' "
					_cQuery += " ORDER BY CB0_DTNASC "
					_cQuery := ChangeQuery(_cQuery)

				Else
					_cQuery := " SELECT * "
					_cQuery += " FROM " + RetSqlName("CB0") + " CB0 "
					_cQuery += " WHERE CB0_FILIAL = '" + xFilial("CB0") + "' AND "
					_cQuery += " CB0_NFSAI = '" + SF2TMP->F2_DOC + "' AND "
					_cQuery += " CB0_SERIES = '" + SF2TMP->F2_SERIE + "' AND "
					_cQuery += " D_E_L_E_T_ = ' ' "
					_cQuery += " ORDER BY CB0_DTNASC "
					_cQuery := ChangeQuery(_cQuery)
				Endif
				MemoWrite("\SYSTEM\QUERY\ALUFAT81_CB0.SQL",_cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"CB0TMP",.T.,.T.)

				dbSelectArea("CB0TMP")
				CB0TMP->(dbGoTop())
				While CB0TMP->(!Eof())

					//Busca a data de producao da etiqueta que originou o retrabalho
					If CB0TMP->CB0_TM $ "004/014"

						//Busca o codigo da etiqueta que originou o retrabalho
						dbSelectArea("PA1")
						dbSetOrder(1)
						If dbSeek( xFilial("PA1") + CB0TMP->CB0_OP )

							While PA1->(!Eof()) .AND. PA1->PA1_FILIAL + PA1->PA1_OP == xFilial("PA1") + CB0TMP->CB0_OP

								If PA1->PA1_TIPO == "E"

									dbSelectArea("CB0")
									dbSetOrder(1)
									dbSeek( xFilial("CB0") + PA1->PA1_CODETI )

									If date() <= Stod(cDtCorte) //Alex Borges - 10/08/2016 - Chamado 352746
										_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + DtoS(CB0->CB0_DTNASC) + ".PDF"
									Else

										//Andre (MRC) 22/05/17
										//	Chamado..: 363515
										//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
										If DATE() >= STOD( cDtCorZB4 )
											//BUSCA QUAL LAUDO DE QUALIDADE DEVERÁ SER IMPRESSO
											cQueryZB4 := " "
											cQueryZB4 += " SELECT "
											cQueryZB4 += "     ZB4.ZB4_FILIAL, MAX(ZB4.ZB4_LAUDO) ZB4_LAUDO, ZB4.ZB4_CODPRO, ZB4.ZB4_DTPROD "
											cQueryZB4 += " FROM " + RetSQLName("ZB4") + " ZB4 "
											cQueryZB4 += " WHERE "
										    cQueryZB4 += "     ZB4.ZB4_FILIAL = '" + xFilial("ZB4") + "' "
										    cQueryZB4 += " AND ZB4.ZB4_CODPRO = '" + CB0TMP->CB0_CODPRO + "' "
										    cQueryZB4 += " AND ZB4.ZB4_DTPROD = '" + CB0TMP->CB0_DTNASC + "' "
										    cQueryZB4 += " AND ZB4.ZB4_OK     = '1' "
										    cQueryZB4 += " AND ZB4.D_E_L_E_T_ = ' ' "
										    cQueryZB4 += " GROUP BY "
										    cQueryZB4 += "     ZB4.ZB4_FILIAL, ZB4.ZB4_CODPRO, ZB4.ZB4_DTPROD "

									    	MemoWrite("\SYSTEM\QUERY\ALUEST81_ZB4.SQL", cQueryZB4 )

											If SELECT("QueryZB4") > 0
												dbSelectArea("QueryZB4")
												dbCloseArea()
											EndIf

											dbUseArea(.T., "TopConn", TCGenQry(, , cQueryZB4), "QueryZB4", .F., .F. )

											dbSelectArea("QueryZB4")
											If !EOF()
												If ASCan( _aLaudos, QueryZB4->ZB4_LAUDO ) = 0	///não achou
													AAdd( _aLaudos, QueryZB4->ZB4_LAUDO )
													AAdd( aArqLaudos,{ SF2TMP->F2_FILIAL+SF2TMP->F2_DOC+SF2TMP->F2_SERIE , "" } )
													cCodLaudo := QueryZB4->ZB4_LAUDO
												Endif
											Endif

											dbSelectAreA("QueryZB4")
											dbCloseArea()
									    Else
											_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + DtoS(CB0->CB0_DTNASC) + ".DOT"
											//Alex Borges - 02/09/2016 - Chamado 352746
											//Verifica se existe o arquivo DOT, caso não existir imprime o PDF
											If !File(_cFile)
												_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + DtoS(CB0->CB0_DTNASC) + ".PDF"
											Endif
										Endif
									EndIf

									//Andre (MRC) 22/05/17
									//	Chamado..: 363515
									//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
									If DATE() >= STOD( cDtCorZB4 )
										If AScan( _aLaudos , cCodLaudo ) = 0
											_EnvEml := .T.
											AAdd( _aInfEml , { SF2TMP->F2_DOC , SF2TMP->F2_SERIE , SF2TMP->F2_CLIENTE , SF2TMP->F2_LOJA , Alltrim(CB0TMP->CB0_CODPRO) , DtoS(CB0->CB0_DTNASC) , .T. } )
											Aviso( "Laudo" , "Não foi localizado o Laudo de Qualidade do Produto: " + Alltrim(CB0TMP->CB0_CODPRO) + " referente a data (original de retrabalho): " + DtoC(CB0->CB0_DTNASC) + " (NF: " + SF2TMP->F2_DOC + "). Favor verificar com o Depto de Qualidade !!!" , {"&Ok"} )
										EndIf
									Else
										If AScan( _aLaudos , _cFile ) = 0
											If File(_cFile)
												AAdd( _aLaudos , _cFile ) // Alex Borges - 22/04/2014 Chamado 295095
												AAdd( aArqLaudos , {SF2TMP->F2_SERIE+SF2TMP->F2_DOC,SF2TMP->F2_CLIENTE,SF2TMP->F2_LOJA,CB0TMP->CB0_CODPRO,_cFile} )
											Else
												_EnvEml := .T.
												AAdd( _aInfEml , { SF2TMP->F2_DOC , SF2TMP->F2_SERIE , SF2TMP->F2_CLIENTE , SF2TMP->F2_LOJA , Alltrim(CB0TMP->CB0_CODPRO) , DtoS(CB0->CB0_DTNASC) , .T. } )
												Aviso( "Laudo" , "Não foi localizado o Laudo de Qualidade do Produto: " + Alltrim(CB0TMP->CB0_CODPRO) + " referente a data (original de retrabalho): " + DtoC(CB0->CB0_DTNASC) + " (NF: " + SF2TMP->F2_DOC + "). Favor verificar com o Depto de Qualidade !!!" , {"&Ok"} )
											EndIf
										EndIf
									Endif

									Exit

								EndIf

								dbSelectArea("PA1")
								PA1->(dbSkip())

							Enddo

						Else

							If SF2TMP->F2_EMISSAO < cDtCorte //Alex Borges - 10/08/2016 - Chamado 352746
								_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + CB0TMP->CB0_DTNASC + ".PDF"
							Else

								//Andre (MRC) 22/05/17
								//	Chamado..: 363515
								//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
								If DATE() >= STOD( cDtCorZB4 )
									//BUSCA QUAL LAUDO DE QUALIDADE DEVERÁ SER IMPRESSO
									cQueryZB4 := " "
									cQueryZB4 += " SELECT "
									cQueryZB4 += "     ZB4.ZB4_FILIAL, MAX(ZB4.ZB4_LAUDO) ZB4_LAUDO, ZB4.ZB4_CODPRO, ZB4.ZB4_DTPROD "
									cQueryZB4 += " FROM " + RetSQLName("ZB4") + " ZB4 "
									cQueryZB4 += " WHERE "
								    cQueryZB4 += "     ZB4.ZB4_FILIAL = '" + xFilial("ZB4") + "' "
								    cQueryZB4 += " AND ZB4.ZB4_CODPRO = '" + CB0TMP->CB0_CODPRO + "' "
								    cQueryZB4 += " AND ZB4.ZB4_DTPROD = '" + CB0TMP->CB0_DTNASC + "' "
								    cQueryZB4 += " AND ZB4.ZB4_OK     = '1' "
								    cQueryZB4 += " AND ZB4.D_E_L_E_T_ = ' ' "
								    cQueryZB4 += " GROUP BY "
								    cQueryZB4 += "     ZB4.ZB4_FILIAL, ZB4.ZB4_CODPRO, ZB4.ZB4_DTPROD "

							    	MemoWrite("\SYSTEM\QUERY\ALUEST81_ZB4.SQL", cQueryZB4 )

									If SELECT("QueryZB4") > 0
										dbSelectArea("QueryZB4")
										dbCloseArea()
									EndIf

									dbUseArea(.T., "TopConn", TCGenQry(, , cQueryZB4), "QueryZB4", .F., .F. )

									dbSelectArea("QueryZB4")
									If !EOF()
										If ASCan( _aLaudos, QueryZB4->ZB4_LAUDO ) = 0
											AAdd( _aLaudos, QueryZB4->ZB4_LAUDO )
											AAdd( aArqLaudos, { SF2TMP->F2_FILIAL+SF2TMP->F2_DOC+SF2TMP->F2_SERIE , "" } )
											cCodLaudo := QueryZB4->ZB4_LAUDO
										Endif
									Endif

									dbSelectAreA("QueryZB4")
									dbCloseArea()
							    Else
									_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + CB0TMP->CB0_DTNASC + ".DOT"
									//Alex Borges - 02/09/2016 - Chamado 352746
									//Verifica se existe o arquivo DOT, caso não existir imprime o PDF
									If !File(_cFile)
										_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + CB0TMP->CB0_DTNASC + ".PDF"
									EndIf
								Endif
							EndIf

							//Andre (MRC) 22/05/17
							//	Chamado..: 363515
							//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
							If DATE() >= STOD( cDtCorZB4 )
								If AScan( _aLaudos , cCodLaudo ) = 0
									_EnvEml := .T.
									AAdd( _aInfEml , { SF2TMP->F2_DOC , SF2TMP->F2_SERIE , SF2TMP->F2_CLIENTE , SF2TMP->F2_LOJA , Alltrim(CB0TMP->CB0_CODPRO) , DtoS(CB0->CB0_DTNASC) , .T. } )
									Aviso( "Laudo" , "Não foi localizado o Laudo de Qualidade do Produto: " + Alltrim(CB0TMP->CB0_CODPRO) + " referente a data (original de retrabalho): " + DtoC(CB0->CB0_DTNASC) + " (NF: " + SF2TMP->F2_DOC + "). Favor verificar com o Depto de Qualidade !!!" , {"&Ok"} )
								EndIf
							Else
								If AScan( _aLaudos , _cFile ) = 0
									If File(_cFile)
										AAdd( _aLaudos , _cFile ) // Alex Borges - 22/04/2014 - Chamado 295095
										AAdd( aArqLaudos , {SF2TMP->F2_SERIE+SF2TMP->F2_DOC,SF2TMP->F2_CLIENTE,SF2TMP->F2_LOJA,CB0TMP->CB0_CODPRO,_cFile} )
									Else
										_EnvEml := .T.
										AAdd( _aInfEml , { SF2TMP->F2_DOC , SF2TMP->F2_SERIE , SF2TMP->F2_CLIENTE , SF2TMP->F2_LOJA , Alltrim(CB0TMP->CB0_CODPRO) , CB0TMP->CB0_DTNASC , .T. } )
										Aviso( "Laudo" , "Não foi localizado o Laudo de Qualidade do Produto: " + Alltrim(CB0TMP->CB0_CODPRO) + " referente a data (original do retrabalho): " + DtoC(StoD(CB0TMP->CB0_DTNASC)) + " (NF: " + SF2TMP->F2_DOC + "). Favor verificar com o Depto de Qualidade !!!" , {"&Ok"} )
									EndIf
								EndIf
							Endif

						Endif

					Else
						If SF2TMP->F2_EMISSAO < cDtCorte //Alex Borges - 10/08/2016 - Chamado 352746
							_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + CB0TMP->CB0_DTNASC + ".PDF"
						Else

							//Andre (MRC) 22/05/17
							//	Chamado..: 363515
							//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
							If DATE() >= STOD( cDtCorZB4 )
								//BUSCA QUAL LAUDO DE QUALIDADE DEVERÁ SER IMPRESSO
								cQueryZB4 := " "
								cQueryZB4 += " SELECT "
								cQueryZB4 += "     ZB4.ZB4_FILIAL, MAX(ZB4.ZB4_LAUDO) ZB4_LAUDO, ZB4.ZB4_CODPRO, ZB4.ZB4_DTPROD "
								cQueryZB4 += " FROM " + RetSQLName("ZB4") + " ZB4 "
								cQueryZB4 += " WHERE "
							    cQueryZB4 += "     ZB4.ZB4_FILIAL = '" + xFilial("ZB4") + "' "
							    cQueryZB4 += " AND ZB4.ZB4_CODPRO = '" + CB0TMP->CB0_CODPRO + "' "
							    cQueryZB4 += " AND ZB4.ZB4_DTPROD = '" + CB0TMP->CB0_DTNASC + "' "
							    cQueryZB4 += " AND ZB4.ZB4_OK     = '1' "
							    cQueryZB4 += " AND ZB4.D_E_L_E_T_ = ' ' "
							    cQueryZB4 += " GROUP BY "
							    cQueryZB4 += "     ZB4.ZB4_FILIAL, ZB4.ZB4_CODPRO, ZB4.ZB4_DTPROD "

						    	MemoWrite("\SYSTEM\QUERY\ALUEST81_ZB4.SQL", cQueryZB4 )

								If SELECT("QueryZB4") > 0
									dbSelectArea("QueryZB4")
									dbCloseArea()
								EndIf

								dbUseArea(.T., "TopConn", TCGenQry(, , cQueryZB4), "QueryZB4", .F., .F. )

								dbSelectArea("QueryZB4")
								If !EOF()
									If ASCan( _aLaudos, QueryZB4->ZB4_LAUDO ) = 0
										AAdd( _aLaudos, QueryZB4->ZB4_LAUDO )
										AAdd( aArqLaudos, { SF2TMP->F2_FILIAL+SF2TMP->F2_DOC+SF2TMP->F2_SERIE , "" } )
										cCodLaudo := QueryZB4->ZB4_LAUDO
									Endif
								Endif

								dbSelectAreA("QueryZB4")
								dbCloseArea()
						    Else

								_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + CB0TMP->CB0_DTNASC + ".DOT"
								//Alex Borges - 02/09/2016 - Chamado 352746
								//Verifica se existe o arquivo DOT, caso não existir imprime o PDF
								If !File(_cFile)
									_cFile := _cPathLau + Alltrim(CB0TMP->CB0_CODPRO) + "_" + CB0TMP->CB0_DTNASC + ".PDF"
								EndIf
							Endif

						Endif

						//Andre (MRC) 22/05/17
						//	Chamado..: 363515
						//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
						If DATE() >= STOD( cDtCorZB4 )
							If AScan( _aLaudos , cCodLaudo ) = 0
								_EnvEml := .T.
								AAdd( _aInfEml , { SF2TMP->F2_DOC , SF2TMP->F2_SERIE , SF2TMP->F2_CLIENTE , SF2TMP->F2_LOJA , Alltrim(CB0TMP->CB0_CODPRO) , DtoS(CB0->CB0_DTNASC) , .T. } )
								Aviso( "Laudo" , "Não foi localizado o Laudo de Qualidade do Produto: " + Alltrim(CB0TMP->CB0_CODPRO) + " referente a data (original de retrabalho): " + DtoC(CB0->CB0_DTNASC) + " (NF: " + SF2TMP->F2_DOC + "). Favor verificar com o Depto de Qualidade !!!" , {"&Ok"} )
							EndIf
						Else
							If AScan( _aLaudos , _cFile ) = 0
								If File(_cFile)
									AAdd( _aLaudos , _cFile )
									AAdd( aArqLaudos , {SF2TMP->F2_SERIE+SF2TMP->F2_DOC,SF2TMP->F2_CLIENTE,SF2TMP->F2_LOJA,CB0TMP->CB0_CODPRO,_cFile} )
								Else
									If Ascan( _aInfEml , { |x| x[1] + x[2] + x[5] + x[6] == Alltrim(CB0TMP->CB0_NFSAI) + CB0TMP->CB0_SERIES + Alltrim(CB0TMP->CB0_CODPRO) + Alltrim(CB0TMP->CB0_DTNASC) }) = 0
										_EnvEml := .T.
										AAdd( _aInfEml , { SF2TMP->F2_DOC , SF2TMP->F2_SERIE , SF2TMP->F2_CLIENTE , SF2TMP->F2_LOJA , Alltrim(CB0TMP->CB0_CODPRO) , CB0TMP->CB0_DTNASC , .F. } )
										Aviso( "Laudo" , "Não foi localizado o Laudo de Qualidade do Produto: " + Alltrim(CB0TMP->CB0_CODPRO) + " referente a data: " + DtoC(StoD(CB0TMP->CB0_DTNASC)) + " (NF: " + SF2TMP->F2_DOC + "). Favor verificar com o Depto de Qualidade !!!" , {"&Ok"} )
									EndIf
								EndIf
							EndIf
						Endif

					EndIf

					dbSelectArea("CB0TMP")
					CB0TMP->(dbSkip())

				End

				CB0TMP->(dbCloseArea())

			EndIf

		EndIf

		dbSelectArea("SF2TMP")
		SF2TMP->(dbSkip())

	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia email aos responsaveis informando que nao foram encontrados laudos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _EnvEml
		MontaEml(_aInfEml)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os Laudos        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If LEN(_aLaudos) > 0
		If MsgYesNo("*** DESEJA IMPRIMIR OS LAUDOS DA QUALIDADE? ***" ,"LAUDOS")

			// ShellExecute("PRINT",_aLaudos[_nI],"","",1) //Alex Borges - 10/08/2016 - Chamado 352746
			For _nI := 1 To LEN( _aLaudos )

				_nPosPV1 := AT(".PDF", UPPER( _aLaudos[ _nI ] ) )

				If _nPosPV1 > 0

					ShellExecute("PRINT", _aLaudos[ _nI ], "", "", 1 )

				Else

					//Andre (MRC) 22/05/17
					//	Chamado..: 363515
					//	Descric..: Verificando Data de Corte para impressao do laudo a partir das tabelas
					If DATE() >= STOD( cDtCorZB4 )
						//Chamada da função para geração do laudo qualidade
						fLaudo( _aLaudos[ _nI ], aArqLaudos[ _nI ][ 1 ] )
					Else
						GeraLaudo( _aLaudos[ _nI ], aArqLaudos[ _nI ][ 1 ] )
					Endif

				EndIf

			Next

		EndIf

	EndIf

    //Alex Borges - 29/09/17 - Chamado 369846
    If lMailConsol
    	LaudoMail()
    EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aviso de nota fiscal de folha plastica para produtos especificos³
	//³ Chamado 346059  - Bruno Silva 26/07/16                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SELECT("SD2TMP") > 0
		SD2TMP->( dbCloseArea() )
	Endif

	_cQuery := " SELECT * "
	_cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_EST='EX' "
	_cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2") + "' "
	_cQuery += " AND D2_DOC >= '" + _cNotaDe  + "' "
	_cQuery += " AND D2_DOC <= '" + _cNotaAte + "' "
	_cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	_cQuery += " AND D2_COD IN (" +_cCodLata+ ") "
	_cQuery += " ORDER BY D2_DOC,D2_SERIE "
	_cQuery := ChangeQuery(_cQuery)
	MemoWrite("\SYSTEM\QUERY\ALUFAT81_SD2.SQL",_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SD2TMP",.T.,.T.)

	dbSelectArea("SD2TMP")
	SD2TMP->(dbGoTop())

	If SD2TMP->( !EOF() )

		MsgYesNo("*** Processo com retorno de folhas plasticas, por favor vincule a ordem de embarque das latas ***" ,"VINCULO EXPORTAÇÃO")

	EndIf

	SD2TMP->(dbCloseArea())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fim -Chamado 346059                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura Areas		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(_aAreaSA1)
	RestArea(_aAreaAtu)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaEml º Autor ³                    º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Envia o e-mail                                            º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function MontaEml( _aDados )

	Local _cEOL     := CHR(13)+CHR(10)
	Local _cHoraNF	:= Time()
	Local _cMensag  := ""
	Local _cNFSAnt  := ""
	Local _cDestina := Alltrim(GetNewPar("CE_EMLAUDO","informatica@crowncork.com.br"))
	Local _dDataNF	:= Date()

	_cMensag := "Não foram localizado(s) o(s) laudo(s) de qualidade do(s) produto(s) e data(s) listado(s) abaixo: <br>"
	For _nI:=1 To Len(_aDados)
		If _aDados[_nI,1] + _aDados[_nI,2] <> _cNFSAnt
			_cNFSAnt := _aDados[_nI,1] + _aDados[_nI,2]
			_cMensag += "<br>"
			_cMensag += "-> NF: " + _aDados[_nI,1] + " Serie: " + _aDados[_nI,2] + " Cliente/Loja: " + _aDados[_nI,3] + "/" + _aDados[_nI,4] + "<br>"
			If _aDados[_nI,7]
				_cMensag += "        Produto: " + _aDados[_nI,5] + "  Data (retrabalho): " + DtoC(StoD(_aDados[_nI,6])) + "<br>"
			Else
				_cMensag += "        Produto: " + _aDados[_nI,5] + "  Data: " + DtoC(StoD(_aDados[_nI,6])) + "<br>"
			EndIf
		Else
			If _aDados[_nI,7]
				_cMensag += "        Produto: " + _aDados[_nI,5] + "  Data (retrabalho): " + DtoC(StoD(_aDados[_nI,6])) + "<br>"
			Else
				_cMensag += "        Produto: " + _aDados[_nI,5] + "  Data: " + DtoC(StoD(_aDados[_nI,6])) + "<br>"
			EndIf
		EndIf
	Next
	_cMensag += "<br>"
	_cMensag += "Favor Verificar. <br><br>"
	_cMensag += "--------------------------------------------------------------------------------------------------------<br>"
	_cMensag += "Data: " + DtoC(_dDataNF) + " Hora: " + _cHoraNF + _cEOL + "<br>"
	_cMensag += "Mensagem gerada automaticamente pelo Gerenciador de Mensagens do Protheus <br>"
	_cMensag += "--------------------------------------------------------------------------------------------------------<br>"

	//U_EnviaEml(_cDestina,"informatica@crowncork.com.br","Produto Sem Laudo de Qualidade",_cMensag,"",.T.) //Alex Borges - 11/02/15 - CHAMADO 315190
	U_EnviaEml(_cDestina,"","Produto Sem Laudo de Qualidade",_cMensag,"",.T.)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³GeraLaudo º Autor ³                   º Data ³    /  /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Gera Laudo Qualidade                                      º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraLaudo(cArqWord,cNumNF)

	Local cAux			:= ""
	Local cPath 		:= GETTEMPPATH()
	Local nAt			:= 0
	Local nx

	/*Verifica se o usuario escolheu um drive local caso contrario busca o nome do arquivo de modelo,  copia para o diretorio temporario
	do windows e ajusta o caminho completo do arquivo a ser impresso.*/

	If substr(cArqWord,2,1) <> ":"
		cAux 	:= cArqWord
		nAT		:= 1
		for nx := 1 to len(cArqWord)
			cAux := substr(cAux,If(nx==1,nAt,nAt+1),len(cAux))
			nAt := at("\",cAux)
			If nAt == 0
				Exit
			Endif
		next nx
		CpyS2T(cArqWord,cPath, .T.)
		cArqWord	:= cPath+cAux
	Endif

	_oWinWord := OLE_CreateLink()

	//Cria uma Nova Página
	OLE_NewFile( _oWinWord, cArqWord )

	//Define o Conteúdo das Variãveis
	OLE_SetDocumentVar( _oWinWord, "NF", cNumNF )

	//Atualiza os Campos
	OLE_UpdateFields( _oWinWord )

	OLE_SetProperty( _oWinWord, '208', .F. ) ; OLE_PrintFile( _oWinWord )

	OLE_CloseLink( _oWinWord )

	If Len(cAux) > 0
		fErase(carqword)
	Endif


Return




// ############################################################################################
// Projeto: A013/17 - Laudo de Qualidade
// Modulo : SIGAFAT
// Fonte  : ALUEST67
// Param  : cParam01 = Array contendo os números para impressão do laudo. Retorna da Tabela ZB4
//        : cParam02 = Array contendo os dados da filial + nota fiscal + serie
// ---------+-------------------+--------------------------------------------+-----------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+-----------------
// 22/05/17 | Andre (MRC)       | Impressao Laudo Qualidade                  | 363515
// ---------+-------------------+--------------------------------------------+-----------------
//          |                   |                                            |
// ---------+-------------------+--------------------------------------------+-----------------
// ############################################################################################
STATIC Function fLaudo( cParam01, cParam02 )

	LOCAL nItem			:= 1
	LOCAL cArquivoDOT	:= GetMV("CE_PATHLAU") + "\" + GetMV("CE_MODDIR")
	LOCAL cPathLocal	:= GETTEMPPATH()
	LOCAL cArqSAI		:= GETTEMPPATH()
	LOCAL cIniFile		:= GetADV97()
	LOCAL cStartPath 	:= GetPvProfString( GetEnvServer(), "RootPath", "ERROR", cIniFile ) + GetMV("CE_ARQPORT")

	LOCAL lOkZB5		:= .F.

	LOCAL cNtFiscal		:= ""
	LOCAL cDtNtFiscal	:= CTOD("  /  /  ")
	LOCAL cTXTIdade		:= ""    
	LOCAL cLaudoEml     := " "

	PRIVATE oWord   
	Private cChave      := "" 

	If ( OLE_CreateLink() < "0" )
		Alert("MS-WORD nao encontrado nessa maquina!!!")
		Return .F.
	Endif

	//Posicionando tabela para retorno das informações
	//Somente imprime Laudo quando o mesmo esta com Status OK, ou seja, todos os requisitos do Laudo foram preenchidos
	dbSelectArea("ZB4")
	dbSetOrder( 1 )
	If dbSeek( xFilial("ZB4") + cParam01 ) .AND. ZB4->ZB4_OK == "2"
		Return .F.
	Endif

	//Verificando qual o idioma a ser impresso o laudo de qualidade
	If ZB4->ZB4_XIDIOM = "1"			//Portugues

		cArquivoDOT := cArquivoDOT + GetMV("CE_MODLAU")
		cTXTIdade	:= "IDADE PRODUTO (dias) : "

	ElseIf ZB4->ZB4_XIDIOM = "2"		//Espanhol

		If FWCodFil() = "01"
			cArquivoDOT := cArquivoDOT + GetMV("CE_MODMAOE")
		Else
			cArquivoDOT := cArquivoDOT + GetMV("CE_MODLES")
		Endif

		cTXTIdade	:= "EDAD PRODUCTO (días) : "

	ElseIf ZB4->ZB4_XIDIOM = "3"		//Ingles

		If FWCodFil() = "01"
			cArquivoDOT := cArquivoDOT + GetMV("CE_MODMAOI")
		Else
			cArquivoDOT := cArquivoDOT + GetMV("CE_MODLIN")
		Endif

		cTXTIdade	:= "PRODUCT AGE (day) : "

	Endif

	//Copiando arquivo para pasta local, e a partir do arquivo local processar geracao do laudo
	CpyS2T(cArquivoDOT, cPathLocal, .T.)

	//Verificando qual o idioma a ser impresso o laudo de qualidade
	If ZB4->ZB4_XIDIOM = "1"			//Portugues

		cPathLocal	:= cPathLocal + GetMV("CE_MODLAU")

	ElseIf ZB4->ZB4_XIDIOM = "2"		//Espanhol

		If FWCodFil() = "01"
			cPathLocal	:= cPathLocal + GetMV("CE_MODMAOE")
		Else
			cPathLocal	:= cPathLocal + GetMV("CE_MODLES")
		Endif

	ElseIf ZB4->ZB4_XIDIOM = "3"		//Ingles

		If FWCodFil() = "01"
			cPathLocal	:= cPathLocal + GetMV("CE_MODMAOI")
		Else
			cPathLocal	:= cPathLocal + GetMV("CE_MODLIN")
		Endif

	Endif

	dbSelectArea("ZB5")
	dbSetOrder( 1 )
	If dbSeek( xFilial("ZB5") + ZB4->ZB4_LAUDO )
		lOkZB5 := .T.
	Endif

	Posicione("SB1", 1, xFilial("SB1") + ZB4->ZB4_CODPRO, "B1_A_GRCLI")
	Posicione("ACY", 1, xFilial("ACY") + SB1->B1_A_GRCLI, "ACY_XGERID" )

	dbSelectArea("SF2")
	dbSetOrder( 1 )
	If dbSeek( cParam02 )		//a variavel cParam02 já contem toda a sintaxe para pesquisa
		cNtFiscal	:= SF2->F2_DOC
		cDtNtFiscal	:= SF2->F2_EMISSAO
	Endif

	dbSelectArea("SD2")
	dbSetOrder( 3 )
	dbSeek( cParam02 )		//a variavel cParam02 já contem toda a sintaxe para pesquisa

	Posicione("SA1", 1, xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA, "A1_NOME" )

	//INICIALIZA O OLE COM O MS-WORD E CRIA LINK DO PROTHEUS COM WORD
	oWord := OLE_CreateLink()

	//CRIA NOVO ARQUIVO BASEADO NO MODELO
	OLE_NewFile( oWord, cPathLocal )

	//EXIBE OU OCULTA A JANELA DO APLICATIVO WORD NO MOMENTO DO CARREGAMENTO DOS VALORES
	OLE_SetProperty( oWord, oleWdVisible, .F. )

	//EXIBE OU OCULTA APLICAÇÃO WORD
	OLE_SetProperty( oWord, oleWdWindowState, '1' )

	//---Preenchendo informações no documento modelo
	OLE_SetDocumentVar( oWord, "CAB_LAUDO"		, ZB4->ZB4_LAUDO + "/" + ZB4->ZB4_ANO 																				)
	OLE_SetDocumentVar( oWord, "CAB_PLANTA"		, AllTrim( SM0->M0_CIDENT ) 																						)
	OLE_SetDocumentVar( oWord, "CAB_EMISSAO"	, Day2Str( DTOC( ZB4->ZB4_DTPROD ) ) + " " + MesExtenso( ZB4->ZB4_DTPROD ) + " de " + Year2Str( ZB4->ZB4_DTPROD )	)
	OLE_SetDocumentVar( oWord, "CAB_CLIENTE"	, AllTrim( GetAdvFVal("ACY", "ACY_A_NOME", xFilial("ACY") + SB1->B1_A_GRCLI, 1, "" ) )								)
	OLE_SetDocumentVar( oWord, "CAB_CODPRO"		, AllTrim( ZB4->ZB4_CODPRO )																						)
	OLE_SetDocumentVar( oWord, "CAB_DTPROD"		, DTOC( ZB4->ZB4_DTPROD ) 																							)
	OLE_SetDocumentVar( oWord, "CAB_DESPRO"		, AllTrim( SB1->B1_DESC )																							)
	OLE_SetDocumentVar( oWord, "CAB_DTVALID"	, DTOC( ZB4->ZB4_DTVALI ) 																							)
	OLE_SetDocumentVar( oWord, "CAB_QTDPROD"	, TRANSFORM( ZB4->ZB4_QTDPRO, "@E 999,999,999" )																	)
	OLE_SetDocumentVar( oWord, "CAB_TURNO"		, ZB4->ZB4_TURNO																									)
	OLE_SetDocumentVar( oWord, "CAB_LINHA"		, ZB4->ZB4_LINHA 																									)
	OLE_SetDocumentVar( oWord, "CAB_NF"			, SF2->F2_DOC																										)
	OLE_SetDocumentVar( oWord, "CAB_ARTE"		, AllTrim( SB1->B1_A_NRART ) 																						)

	//Imprimindo Idade da Lata com base no cadastro de grupo de cliente
	If ACY->ACY_XGERID = "1"
		OLE_SetDocumentVar( oWord, "CAB_IDADE"	, cTXTIdade + IIf( !Empty( cNtFiscal ), STR( DateDiffDay( cDtNtFiscal, ZB4->ZB4_DTPROD ) ), "" ) 					)
	Else
		OLE_SetDocumentVar( oWord, "CAB_IDADE"	, "" 																												)
	Endif

	OLE_SetDocumentVar( oWord, "CAB_LOTE"		, AllTrim( ZB4->ZB4_LOTE )																							)

	//Imprime dados de tampa somente quando filial for manaus
	If FWCodFil() = "01"
		OLE_SetDocumentVar( oWord, "CAB_COR"	, NGRetSX3Box("B1_XCORTAM", SB1->B1_XCORTAM )																		)
		OLE_SetDocumentVar( oWord, "CAB_CORANEL", NGRetSX3Box("B1_XCORATP", SB1->B1_XCORATP )																		)
	Endif

	//Atualizando variaveis do documento
	dbSelectArea("ZB5")
	If lOkZB5
		While !EOF() .AND. ZB5->ZB5_FILIAL = ZB4->ZB4_FILIAL .AND. ZB5->ZB5_LAUDO = ZB4->ZB4_LAUDO

			//Verificando qual o idioma a ser impresso o laudo de qualidade
			If ZB4->ZB4_XIDIOM = "1"			//Portugues
				OLE_SetDocumentVar( oWord, "IT_DESC"	+ AllTrim( STR( nItem ) ), AllTrim( GetAdvFVal("ZA7", "ZA7_DESLAU", xFilial("ZA7") + ZB5->ZB5_CODIGO, 1, "" ) )	)
			ElseIf ZB4->ZB4_XIDIOM = "2"		//Espanhol
				OLE_SetDocumentVar( oWord, "IT_DESC"	+ AllTrim( STR( nItem ) ), AllTrim( GetAdvFVal("ZA7", "ZA7_DESESP", xFilial("ZA7") + ZB5->ZB5_CODIGO, 1, "" ) )	)
			ElseIf ZB4->ZB4_XIDIOM = "3"		//Ingles
				OLE_SetDocumentVar( oWord, "IT_DESC"	+ AllTrim( STR( nItem ) ), AllTrim( GetAdvFVal("ZA7", "ZA7_DESING", xFilial("ZA7") + ZB5->ZB5_CODIGO, 1, "" ) )	)
			Endif

			OLE_SetDocumentVar( oWord, "IT_POL"			+ AllTrim( STR( nItem ) ), AllTrim( GetAdvFVal("ZB2", "ZB2_DESCRI", xFilial("ZB2") + ZB5->ZB5_UN, 1, "" ) )			)
			OLE_SetDocumentVar( oWord, "IT_MEDIA"		+ AllTrim( STR( nItem ) ), AllTrim( TRANSFORM( ZB5->ZB5_MEDIA, "999.999" ) )										)
			OLE_SetDocumentVar( oWord, "IT_MAIOR"		+ AllTrim( STR( nItem ) ), AllTrim( TRANSFORM( ZB5->ZB5_MAXIMA, "999.999" ) )										)
			OLE_SetDocumentVar( oWord, "IT_MENOR"		+ AllTrim( STR( nItem ) ), AllTrim( TRANSFORM( ZB5->ZB5_MINIMO, "999.999" ) )										)
			OLE_SetDocumentVar( oWord, "IT_ESPECIFIC"	+ AllTrim( STR( nItem ) ), AllTrim( ZB5->ZB5_ESPECIF )																)
			OLE_SetDocumentVar( oWord, "IT_AMOSTRAS"	+ AllTrim( STR( nItem ) ), AllTrim( TRANSFORM( ZB5->ZB5_AMOSTRAS, "9999" ) )										)
			OLE_SetDocumentVar( oWord, "IT_CONDIC"		+ AllTrim( STR( nItem ) ), "Aprovado"																				)
			OLE_SetDocumentVar( oWord, "IT_METODO"		+ AllTrim( STR( nItem ) ), NGRetSX3Box("ZB5_METODO", ZB5->ZB5_METODO )												)

			dbSelectArea("ZB5")
			dbSkip()

			//Faz a verificação antes de somar um a variavel para correta impressao do laudo de qualidade
			If !EOF() .AND. ZB5->ZB5_FILIAL = ZB4->ZB4_FILIAL .AND. ZB5->ZB5_LAUDO = ZB4->ZB4_LAUDO
				nItem	:= nItem + 1
			Endif

		Enddo
	Endif

	//Atualizando variaveis do documento
	OLE_SetDocumentVar( oWord, "NITEM", LTrim( STR( nItem ) ), "" )

	// Executa a macro do Word.
	OLE_ExecuteMacro( oWord , "tabitem" )

	//ATUALIZANDO VARIAVEIS DO WORD
	OLE_UpDateFields( oWord )

	//IMPRIMINDO DIRETAMENTE NA IMPRESSORA
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )

	//SALVANDO EM FORMATO PDF
	OLE_SaveAsFile( oWord, cArqSAI + FWCodFil() + "_" + AllTrim( ZB4->ZB4_CODPRO ) + "_" + DTOS( ZB4->ZB4_DTPROD ) + ".PDF", "", "", .F., oleWdFormatPDF )

	//Copiando arquivo para a pasta do portal do cliente
	cArqSAI := Alltrim(cArqSAI + FWCodFil() + "_" + AllTrim( ZB4->ZB4_CODPRO ) + "_" + DTOS( ZB4->ZB4_DTPROD ) + ".PDF" )
	
	//Alex Borges - 29/09/17 - Chamado 369846
    cPasta   := GETMV("CE_PASTLAU")
    cArquivo := Alltrim(SF2->F2_DOC) + "_"+AllTrim( ZB4->ZB4_CODPRO ) + "_" + DTOS( ZB4->ZB4_DTPROD ) + ".PDF"
    cArqPor  := Alltrim(cPasta + cArquivo)
    cArqtmp  := Alltrim("\TEMP\"+cArquivo)     
    // Eduardo Souza - 14/11/2017 - Chamado
    cChave   := Alltrim(SF2->F2_CHVNFE)  
    cArqO2P  := Alltrim("\TEMP\"+Alltrim(cChave)+"-LAUDO"+".PDF")
    
    //Copia arquivo impresso na pasta dos laudos na rede
    If (__CopyFile(cArqSAI,cArqPor )) == .f.
		MsgBox("Nao foi possivel copiar arquivos para a pasta "+cPasta+"!",'Erro-Path','Info')
	Else    
	
		//Copia arquivo impresso na pasta temporaria para envio de email.
		If (__CopyFile(cArqSAI,cArqtmp )) == .f.
		MsgBox("Nao foi possivel copiar arquivos para a pasta "+cPasta+"!",'Erro-Path','Info')
		Else        
			// Eduardo Souza - 14/11/2017 Chamado:
			// Copia arquivo para enviar para O2P
			If (__CopyFile(cArqSAI,cArqO2P)) == .f.
				MsgBox("Não foi possivel copiar arquivos para a pasta\TEMP\ !","Erro-Path","Info")	   
			EndIf	                            
		    //(Posição [1]=Pasta Laudo, [2]=Pasta Temporaria)
			AAdd( _aLaudoEmail,{ cArqPor,cArqtmp,cArqO2P} ) 
	
			//Incrementa a descrição dos lotes das latas
			If Empty(cLotes)
				cLotes := "Produção : " +DTOc( ZB4->ZB4_DTPROD )+"<br>"
				cLotes += Alltrim(ZB4->ZB4_LOTE)+"<br><br>"
			Else
				cLotes += "Produção : " +DTOc( ZB4->ZB4_DTPROD )+"<br>"
				cLotes += Alltrim(ZB4->ZB4_LOTE)+"<br><br>"
			EndIf
	
			//Envia email consolidado ou nao "1 email com vários laudos"
			If !lMailConsol
				//Envia 1 email por laudo
				LaudoMail()
				cLotes       := ""
				_aLaudoEmail := {}			
			End If
		EndIf
	  
	EndIf

	ShellExecute("PRINT", cArqSAI, "", "", 0 )

	//ENVIANDO E-MAIL PARA OS DESTINATÁRIOS INFORMADO NO CADASTRO DE CLIENTE
	//If SA1->A1_XENVLAU = "1"
	//	U_EnviaEml( SA1->A1_XMAILQ, "", "Laudo de Qualidade CROWN", "Segue Laudo de Qualidade gerado pela Nota Fiscal " + SF2->F2_DOC + CRLF + CRLF + "Atenciosamente," + CRLF + CRLF + "Departamento de Qualidade - CRWON", cArqSAI, .T. )
	//Endif
	
	//---Fecha o documento
	OLE_CloseFile( oWord )

	//---Fecha o Link com o Word
	OLE_CloseLink( oWord )

Return

Static Function LaudoMail

cCopiaLaudo := GETMV("CE_INSPLAU")
_cMensag    := ""
cArquivos   := ""

If lMailConsol
	_cAssunto := "Laudo Crown "+AllTrim( SM0->M0_CIDENT )+" - NF "+Alltrim(SF2->F2_DOC)
Else
	_cAssunto := "Laudo Crown "+AllTrim( SM0->M0_CIDENT )+" - Prod "+DTOC( ZB4->ZB4_DTPROD )+" - NF "+Alltrim(SF2->F2_DOC)
EndIf


_cMensag := " Segue anexo o(s) laudo(s) dos lotes de fabricação: <br>"
_cMensag += "<br>"
_cMensag += cLotes
_cMensag += "--------------------------------------------------------------------------------------------------------<br>"
_cMensag += "Data: " + DtoC(ddatabase) + " Hora: " + Time() + "<br>"
_cMensag += "Mensagem gerada automaticamente.<br>"
_cMensag += "--------------------------------------------------------------------------------------------------------<br>"

// Lista todos os arquivos para anexar
For i:= 1 To  Len(_aLaudoEmail) 
	If StrTran(_aLaudoEmail[i][2],Alltrim(cChave + " - LAUDO"))<>Alltrim(cChave + " - LAUDO")
		cArquivos += _aLaudoEmail[i][2]+","	   
	EndIf	
Next i

If Len(_aLaudoEmail) > 0 
	//Envia email dos laudos     
	//cLaudoEml := SuperGetMV("CE_O2PLAEM",.F.,"laudo.danfe@crowncork.com.br")
	cLaudoEml := "eduardo.souza@mrconsultoria.com.br"
	If !Empty(SA1->A1_XEMLQDO) 
		Processa({||  U_EnviaEml(Alltrim(SA1->A1_XEMLQDO), cCopiaLaudo, _cAssunto , _cMensag, cArquivos, .f. )}, "Envio de E-Mail", "Enviando laudo de qualidade por email...")	   
		// Eduardo Souza - 14/11/2017 | Chamado: 369903 
		Processa({||  U_EnviaEml(cLaudoEml, "", Alltrim(cChave + " - LAUDO") , "Laudo anexo", cArqO2P, .f. )}, "Envio de E-Mail", "Enviando laudo de qualidade por email para Processware")
	Endif  
	
	//Deleta os arquivos da pasta
	For i:= 1 To  Len(_aLaudoEmail) 
		//Deleta arquivo na pasta de laudos
		If GETMV("CE_DELARQL")
			fErase(_aLaudoEmail[i][1])
		End
		//Deleta arquivo da pasta temporária
		fErase(_aLaudoEmail[i][2])
	Next i           
EndIf
	
Return