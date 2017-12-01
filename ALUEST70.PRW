#INCLUDE "TOTVSWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

// ########################################################################################################
// Projeto: A027/17 - Integracao com sistema O2P - Processware
// Modulo : SIGAEST
// Fonte  : ALUEST70
// ---------+-------------------+----------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                | Chamado
// ---------+-------------------+----------------------------------------------------------+---------------
// 04/09/17 | Ricardo Lima      | Webservice Server de Integracao para o Sistema O2P - OP  | 369903
// ---------+-------------------+----------------------------------------------------------+---------------
// ########################################################################################################

WSSERVICE WS_ALUEST70 DESCRIPTION "WS Ordem de Produção" NameSpace "protheusweb.crowncork.com.br:8092"
	WSDATA cUserID   AS string
	WSDATA sJsonO2P  AS string
	WSDATA cDadosSai AS string
	WSMETHOD ORDEMPRODUCAO DESCRIPTION "<b>Método que retorna o Numero da Ordem de Produção Gerado a partir de dados Recebidos"
ENDWSSERVICE

//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß//
// METODO PARA RETORNAR AS OP'S INTEGRADO //
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß//

WSMETHOD ORDEMPRODUCAO WSRECEIVE cUserID, sJsonO2P  WSSEND cDadosSai WSSERVICE WS_ALUEST70

//Variaveis Locais
Local cJson
Local oObj
Local _cEmpresa := ""
Local _cFilial  := ""
Local nOpcOP    := 3
Local _oDadSai
Local _cQtdD1t := 0
Local aMata650
Local cTurno   := "A"
Local aAreaSC2
Local cLineOP := '1'

Private lMSErroAuto := .F.
Private _numOP   := ""

RPCSETType(3) //Nao utiliza licenca
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" //Abro o ambiente Manaus

Conout("...:ALUEST70:...")
Conout(DtoC(Date())+" - "+Time())                


Begin transaction

cJson := sJsonO2P

If cUserID == GetMv("CE_USRWSO2")

	If FWJsonDeserialize(cJson,@oObj)

		// Empresa e Filial Recebido pelo arquivo
		_cEmpresa := "01"
		_cFilial  := Right( Alltrim(oObj:PLANT) , 2 )

		//Reinicia o ambiente agora com a filial correta
		RESET ENVIRONMENT
		RPCSETType(3) //Nao utiliza licenca
		PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial

		Memowrite("\system\O2P\OP_"+ alltrim(oObj:MAINORDER) + oObj:ACTION +".json" , cJson )

		if oObj:ACTION = "I"

			nOpcOP := 3
			_numOP := GetSX8Num("SC2","C2_NUM")
			DbSelectArea("SC2")
			DbSetOrder(12)
			if DbSeek( _cFilial + Alltrim(oObj:MAINORDER) )
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"OrdemProducao": "'+ SC2->C2_NUM +'","Mensagem": "Ordem de Produção Já Existe"}'

				::cDadosSai := _oDadSai
				DisarmTransaction()
				Return( .T. )
			endif
		elseif oObj:ACTION = "D"

			nOpcOP := 5
			DbSelectArea("SC2")
			DbSetOrder(12)
			if DbSeek( _cFilial + oObj:MAINORDER )
				_numOP := SC2->C2_NUM
			Else
				_oDadSai := WSClassNew("cDadosSai")
				_oDadSai := '{"OrdemProducao": "'+ SC2->C2_NUM +'","Mensagem": "Ordem de Produção Não Existe"}'

				::cDadosSai := _oDadSai
				DisarmTransaction()
				Return( .T. )
			endif
		endif

		cLineOP := Alltrim(oObj:PRODUCTIONLINE)
		cLineOP := StrTran( cLineOP , 'L', "" )

		lMSErroAuto := .F.
		_cQtdD1t := round(val( oObj:QUANTITY) , 4 )
		aMata650 := {{"C2_FILIAL"   ,_cFilial        ,NIL},;
					{"C2_NUM"      ,_numOP           ,NIL},;
					{"C2_ITEM"     ,"01"             ,NIL},;
					{"C2_SEQUEN"   ,"001"            ,NIL},;
					{"C2_CLINHA"   ,cLineOP          ,NIL},;
					{"C2_CTURNO"   ,cTurno           ,NIL},;
					{"C2_PRODUTO"  ,Right(Alltrim(oObj:SKUCODE),9) ,NIL},;
					{"C2_LOCAL"    ,"01"             ,NIL},;
					{"C2_QUANT"    ,_cQtdD1t         ,NIL},;
					{"C2_UM"       ,oObj:UOM         ,NIL},;
					{"C2_DATPRI"   ,dDataBase        ,NIL},;
					{"C2_DATPRF"   ,dDataBase        ,NIL},;
					{"C2_OBS"      ,"OP Gerada pelo O2P" ,NIL},;
					{"C2_EMISSAO"  ,dDataBase        ,NIL},;
					{"C2_TPOP"     ,"F"              ,NIL},;
					{"C2_CRWTM"    ,"001"            ,NIL},;
					{"C2_A_QTFIL"  ,val(oObj:CHILDORDERQUANTITY) ,NIL},;
					{"C2_XNOPO2P"  ,Alltrim(oObj:MAINORDER)   ,NIL}}

		msExecAuto({|x,Y| Mata650(x,Y)} , aMata650 , nOpcOP )

		If lMSErroAuto
			_oDadSai := WSClassNew("cDadosSai")
			_oDadSai := '{"OrdemProducao": "'+ oObj:MAINORDER +'","Mensagem": "'+ MostraErro() +'"}'

			::cDadosSai := _oDadSai
			DisarmTransaction()
		Else
			_oDadSai := WSClassNew("cDadosSai")
			if oObj:ACTION = "I"
				  aAreaSC2 := SC2->(GetArea())
				    U_GeraEmpOP( .F. , _numOP + "01001" )
				  RestArea(aAreaSC2)
				_oDadSai := '{"OrdemProducao": "' + _numOP + '","Mensagem": ""}'
			elseif oObj:ACTION = "D"
				_oDadSai := '{"OrdemProducao": "' + _numOP + '","Mensagem": ""}'
			endif
			::cDadosSai := _oDadSai
		Endif
	Endif
Endif

End transaction

Conout("...:ALUEST70:...")
Conout(DtoC(Date())+" - "+Time())
Conout("...:ALUEST70 - THE END:...")
Return( .T. )