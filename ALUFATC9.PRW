#include "protheus.ch"
#include "apwebsrv.ch"
#include "topconn.ch"
#include "totvswebsrv.ch"
#include "tbiconn.ch"


// ##########################################################################################
// Projeto:  - Integracao dom sistema O2P - Processware - Analise de Credito
// Modulo : SIGAFAT
// Fonte  : ALUFATC9
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 04/09/17 | Eduardo Souza     | Integracao com o Webservice O2P,envia dados| 369903
//          |                   | sobre a Analise de Credito                 |
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################

WSSERVICE WS_ALUFATC9 DESCRIPTION "WS Analise de Credito" NameSpace "protheusweb.crowncork.com.br:8092"
	wsdata sUserId            as string
    wsdata sEventData         as string
    wsdata _Retorno           as string
	WSMETHOD CRD_ANALYSYS DESCRIPTION "<b>Método que retorna a analise de crédito de um cliente "
ENDWSSERVICE

WSMETHOD CRD_ANALYSYS WSRECEIVE sUserId,sEventData WSSEND _Retorno WSSERVICE WS_ALUFATC9
Local oCustomer
Local oResult
Local cLoja   := "01"
Local nValor  := 0
Local nMoeda:= 1
Local cBlqCred:= ""
Local cTabPrc := ""
Local lVigente := .F.
Local nTotItem := 0
Local _cFilial := ""

RPCSETType(3) //Nao utiliza licenca
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" //Abro o ambiente Manaus
 
Conout("...:ALUFATC9:...")
Conout(DtoC(Date())+" - "+Time())

If !Empty(sUserId)
    If sUserId == GetMv("CE_USRWSO2")
			If FWJsonDeserialize(sEventData,@oCustomer)
				// ----------------------------------------------
				// exemplo de estrutura Json do EventData
				// ----------------------------------------------
				// Estrutura do Json {"customer":"000001","shipmentType":"FOB","plant":"001","itens":
				// {{"skuCode":"00000000001","quantity":"100","uom":"MIL"},{"skuCode":"00000000002","quantity":"100","uom":"MIL"},
				// {"skuCode":"00000000003","quantity":"100","uom":"MIL"}}}
				// ----------------------------------------------
				// =============================================
				// Seleciona ambiente para execução do ws
				// =============================================
				//cFilial := Right(oCustomer:plant,2)
				//PREPARE ENVIRONMENT EMPRESA "01" FILIAL _cFilial

				RESET ENVIRONMENT
				RPCSETType(3) //Nao utiliza licenca
				PREPARE ENVIRONMENT EMPRESA "01" FILIAL Right(alltrim(oCustomer:plant),2) //Abro o ambiente Cabreuva

				Memowrite("\system\O2P\Analise_Credito_"+ alltrim(oCustomer:Customer) +".json" , sEventData )

				//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' USER 'Administrador' PASSWORD '' TABLES 'SE1,SA1,SE2' MODULO ‘FAT’/*******COMANDOS *********/RESET ENVIRONMENT

				// =============================================
				// inicio da tratativa para avaliação de crédito
				// =============================================
				// Busca tabela de preço no cadastro de Cliente
				dbSelectArea("SA1")
				dbSetOrder(1)
				if !SA1->(dbSeek(xFilial("SA1") + Right( alltrim(oCustomer:Customer),6 ) ) )
					//oResult:SetValue("300","","Customer not found!")
					oResult := WSClassNew("_Retorno")
					oResult := '{"analise":false,"mensagem":"Cliente não encontrado."}'
					::_Retorno := oResult
					Return(.T.)
				Else
					// Procura a tabela de preço atrelada ao cliente para validar a vigência
					//----------------------------------------------------------------------
					If Empty(SA1->A1_TABELA)
						oResult := WSClassNew("_Retorno")
						oResult := '{"analise":false,"mensagem":"Tabela de Preço do Cliente não existe."}'
						::_Retorno := oResult
						Return(.T.)
					End
					dbSelectArea("DA0")
					dbSetOrder(1)
					If DA0->(dbSeek(xFilial("DA0")+SA1->A1_TABELA))
						cTabPrc := SA1->A1_TABELA
						_cFilial := Right(alltrim(oCustomer:plant),2)
						While !DA0->(EOF()) .AND. DA0->DA0_CODTAB == cTabPrc .AND. DA0->DA0_FILIAL=_cFilial
						 	// Verifica se há uma tabela sobre vigência
						 	//-----------------------------------------
						 	If Date() >= DA0->DA0_DATDE .AND. Date() <= DA0->DA0_DATATE .AND. Time() >= DA0->DA0_HORADE .AND. Time() <= DA0->DA0_HORATE
						 		lVigente := .T.
						 		Exit
						 	Else
						 		DA0->(dbSkip())
						 	EndIf
						End
						If !lVigente
							// Retorna erro na tabela de preço
							//--------------------------------
							//oResult:SetValue("700","","price table does not exist or is out of date!")
							//_Retorno := "price table does not exist or is out of date!"
							oResult := WSClassNew("_Retorno")
							oResult := '{"analise":false,"mensagem":"Tabela de Preço não existe ou fora de vigência."}'
							::_Retorno := oResult
							Return(.T.)
						Else
							For nX := 1 to Len(oCustomer:itens)
								dbselectArea("SB1")
								dbSetOrder(1)
								If !SB1->(dbseek(xFilial("SB1") + Right( alltrim(oCustomer:itens[nx]:skuCode),9) ) )
									//oResult:SetValue("610","","Invalid skuCode!")
									//_Retorno := "Invalid skuCode!"
									oResult := WSClassNew("_Retorno")
									oResult := '{"analise":false,"mensagem":"Código de Produto inválido."}'
									::_Retorno := oResult
									Exit
								Else
									// Procuro o produto na tabela de preço se estiver vigente
									If lVigente
										nTotItem += Val(oCustomer:itens[nx]:quantity)*POSICIONE("DA1",1,xFilial("DA1")+SA1->A1_TABELA + Right( alltrim(oCustomer:itens[nx]:skuCode),9 ),"DA1_PRCVEN")
									EndIf
								EndIf
							Next nX


						EndIf
					EndIf


					// Executa a consulta de credito
					// ------------------------------
					Conout("======[Analise de Credito]======")
					Conout(oCustomer:Customer)
					Conout(cLoja)
					Conout(Str(nTotItem))
					Conout(Str(nMoeda))
					Conout(cFilial)
					Conout("================================")
					lCredOk := MaAvalCred( Right( alltrim(oCustomer:Customer),6) , cLoja, nTotItem, nMoeda, .T., @cBlqCred )

					If lCredOk .AND. lVigente
						//oResult:SetValue("200","true","credit analysis aproved")
						//_Retorno := "credit analysis aproved"
						oResult := WSClassNew("_Retorno")
						oResult := '{"analise":true,"mensagem":"Analise de Credito Aprovada."}'
						::_Retorno := oResult
						Return(.T.)
					EndIf
				Endif
			else
				//_Retorno := "Invalid Json data!"
				oResult := WSClassNew("_Retorno")
				oResult := '{"analise":false,"mensagem":"Dados (JSON)inválidos."}'
				::_Retorno := oResult
				Return(.T.)
			EndIf
    Else
    	//_Retorno := "Invalid UserId!"
    	oResult := WSClassNew("_Retorno")
		oResult := '{"analise":false,"mensagem":"UserId inválido."}'
		::_Retorno := oResult
		Return(.T.)
    EndIf
EndIf
//RPCClearEnv()                     

Conout("...:ALUFATC9:...")
Conout(DtoC(Date())+" - "+Time())
Conout("...:ALUFATC9 - THE END:...")
Return(.T.)