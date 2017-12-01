#INCLUDE 'APVT100.CH'
#include 'Ap5Mail.ch'                                              


#DEFINE SERIE Substr(GetMv("CE_SERNFS"),1,3)

Static __nSem:=0
Static __nSemAru:=0 //Incluido por Marion em 11/02/09 - Aruma Semaforo*

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³  CRC010  ³AUTOR: ³ Sandro                ³DATA: ³ 09/03/01 ³±±
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
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marcos Cesar  ³28122005³Alteracao de tab.preco no cadastro de Cliente ³±±
±±³ Felipe        ³17032006³Chamda da funcao U_fAltdBase(.t.) no caso de  ³±±
±±³		      	  ³	   	   ³a NF nao ter sido impressa com sucesso e dese-³±±
±±³		     	  ³	 	   ³jar gerar uma outra NF                        ³±±
±±³ Felipe        ³06032006³Chamada da funcao AtuSC6 (PROJETO PRICELIST)  ³±±
±±³ Marion        ³12/06/06³Alteracao da rotina para exclusao de nota     ³±±
±±³               ³        ³devido a Mata520 nao funcionar mais no rel.3  ³±±
±±³ Katia Bugov   ³28022007³Tratamento para Embalagem                     ³±±
±±³ Marion        ³14/03/07³Tratamento de tabela de preco expirada. Nao   ³±±
±±³               ³        ³permite o carregamento desde o inicio.        ³±±
±±³ Alberto       ³06/07/07³Incluido tratamento para distribuidora. Nao   ³±±
±±³               ³        ³gera pedido de 'topo' e 'papelao'             ³±±
±±³ Alberto       ³17/07/07³Incluido tratamento para nao gerar pedido de  ³±±
±±³               ³        ³embalagem na distribuidora quando o parametro ³±±
±±³               ³        ³'EMBPRO' estiver vazio.                       ³±±
±±³ Marion        ³17/07/07³Projeto CEMA                                  ³±±
±±³ Alberto       ³21/09/07³Alteracao na atualizacao da tabela no SC6.    ³±±
±±³               ³        ³O sistema nao estava atualizando o preco de   ³±±
±±³               ³        ³todos os itens do pedido de venda             ³±±
±±³ Alberto       ³21/09/07³Alteracao na funcao acertasc9 de static       ³±±
±±³               ³        ³function para user function.                  ³±±
±±³ Alberto       ³21/09/07³Incluida validacao da data inicial da tabela  ³±±
±±³               ³        ³de preco.                                     ³±±
±±³ Luiz Cesar    ³01/10/07³Digitacao da placa do veiculo no embarque     ³±±
±±³ Luiz Cesar    ³05/10/07³Ajuste mostra embarcados na tela              ³±±
±±³ Marion        ³07/12/07³Projeto AEP - Trata tabela bloqueio tab.preco ³±±
±±³ Anderson      ³10/06/08³Cabecalho, identacao                          ³±±
±±³ Marion        ³27/01/09³Projeto Aruma - Fuso horario                  ³±±
±±³ Cristiane     ³02/02/09³Tratamento para 9 digitos da NF e 3 da Serie  ³±±
±±³ Marion        ³11/02/09³Projeto Aruma - Tratamento semaforo           ³±±
±±³ Alberto       ³18/02/09³Inclusao da funcao vldped() quando a doca     ³±±
±±³               ³        ³esta preenchida, para que o sistema posicione ³±±
±±³               ³        ³corretamente no pedido de venda e na tabela   ³±±
±±³               ³        ³de preco e atualize o preco do pedido unitario³±±
±±³               ³        ³do pedido corretamente.                       ³±±
±±³               ³        ³Foi substituida tambem a verficacao do campo  ³±±
±±³               ³        ³A1_A_TABP, que identifica se o cliente        ³±±
±±³               ³        ³utiliza tabela de preco, pela verificacao se  ³±±
±±³               ³        ³o pedido de venda esta com a tabela de preco  ³±±
±±³               ³        ³preenchida como criterio para atualizar o     ³±±
±±³               ³        ³preco de venda do pedido.                     ³±±
±±³ Alberto       ³25/02/09³Grava log com dados de geracao da nota fiscal ³±±
±±³ Marion        ³25/02/09³Tratamento para Topos de Plastico             ³±±
±±³ Alberto       ³25/03/09³Projeto nf eletronica                         ³±±
±±³ Alberto       ³25/03/09³Projeto nf eletronica                         ³±±
±±³ Luiz Cesar    ³06/04/09³Alterado a UFP                                ³±±
±±³ Cristiane     ³04/05/09³Chamado 175120 - Para tratar cliente que nao  ³±±
±±³               ³        ³gera embalagem.                               ³±±
±±³ Alberto       ³15/07/09³Projeto PV Automatico                         ³±±
±±³               ³        ³O sistema devera gerar o pedido de venda      ³±±
±±³               ³        ³automatico para os clientes que utilizam      ³±±
±±³               ³        ³tabela de preco                               ³±±
±±³ Alberto       ³29/07/09³Projeto PV Automatico                         ³±±
±±³               ³        ³Alteracao do posicionamento dos campos pois   ³±±
±±³               ³        ³no coletor manual utilizado em Manaus a       ³±±
±±³               ³        ³mensagem das etiquetas embarcadas nao esta    ³±±
±±³               ³        ³aparecendo.                                   ³±±
±±³ Luiz Cesar    ³29/03/10³Projeto Lata Importada                        ³±±
±±³               ³        ³Alteracao na query que localiza a tabela de   ³±±
±±³               ³        ³preco de venda para considerar o produto.     ³±±
±±³ Luiz Cesar    ³31/03/10³Correcao gravacao de transportadoras          ³±±
±±³ Luiz Cesar    ³31/05/10³Informacao de container para importacoes      ³±±
±±³ Luiz Cesar    ³20/09/10³Alteracao para o projeto PIA,                 ³±±
±±³               ³        ³Gravacao de Etiquetas PAH                     ³±±
±±³ Luis Alberto  ³01/12/10³Projeto Ponta Grossa                          ³±±
±±³               ³        ³Tratamento do arquivo de semaforo por empresa.³±±
±±³ J.Francisco   ³17/01/11|Verificacao de tipo pelo grupo                ³±±
±±³               ³        ³Chamado : 208014 Projeto A024/10              ³±±
±±³ Luis Alberto  ³08/04/11³Projeto PIA. Utiliza um TES diferente para o  ³±±
±±³               ³        ³material de embalagem quando o cliente for    ³±±
±±³               ³        ³operador logistico.                           ³±±
±±³ Luis Alberto  ³13/04/11³Correcao na gravacao da hora(utilizar a funcao³±±
±±³               ³        ³strzero no campo F2_HORA )                    ³±±
±±³ Luis Alberto  ³11/05/11³Projeto SPED PIS/COFINS.Chamado 218.885       ³±±
±±³               ³        ³Utilizar TES diferente para produtos com PIS/ ³±±
±±³               ³        ³COFINS por pauta e por aliquota.              ³±±
±±³ Luis Alberto  ³26/05/11³Projeto SPED PIS/COFINS.Chamado 218.885       ³±±
±±³               ³        ³Utilizacao de parametro para definir se a     ³±±
±±³               ³        ³rotina de embarque vai utilizar ou nao os     ³±±
±±³               ³        ³TES por aliquota e por pauta.                 ³±±
±±³ Luis Alberto  ³31/05/11³Projeto Controle Material Embalagem.          ³±±
±±³               ³        ³Chamado 213.421. Alteracao no criterio de     ³±±
±±³               ³        ³identificacao do material de embalagem que    ³±±
±±³               ³        ³passara a utilizar o campo CB0_A_TPEM. Esse   ³±±
±±³               ³        ³campo eh preenchido no momento da distribuicao³±±
±±³ Luis Alberto  ³13/06/11³Projeto Controle Material Embalagem.          ³±±
±±³               ³        ³Chamado 213.421. Inclusao do parameto         ³±±
±±³               ³        ³CE_FLAGME para controlar se a filial vai      ³±±
±±³               ³        ³utilizar o novo procedimento de controle de   ³±±
±±³               ³        ³material de embalagem. Essa solicitacao foi   ³±±
±±³               ³        ³feita para que o projeto seja implantado      ³±±
±±³               ³        ³primeiro em Cabreuva e depois em Ponta Grossa ³±±
±±³               ³        ³e Aruma.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³22/07/11³Tratamento de saldo da rua do pallet lido     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³26/08/11³Busca o tipo do frete na tabela PBS e nao mais³±±
±±³               ³        ³na tabela SZR                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³03/11/11³Chamado 231473 - Valida se a variavel do tipo ³±±
±±³               ³        ³de frete esta preenchida antes de gerar o pe- ³±±
±±³               ³        ³dido 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³07/12/11³Chamado 233433 - Valida se a TES da tabela de ³±±
±±³               ³        ³precos atualiza estoque                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³08/12/11³Chamado 233411 - Trata qtde de lata por camada³±±
±±³               ³        ³para calcular quantidade de papel             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³09/02/12³Chamado 234745 - Ajustes e validacao na digita³±±
±±³               ³        ³cao do campo placa				              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³01/03/12³Chamado 238945 - Ajuste na montagem da tela   ³±±
±±³               ³        ³quando a doca ja esta em uso                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³23/04/12³PROJETO 012/12 - Configuracao de DANFE p/ EX- ³±±
±±³		 		  ³        ³PORTACAO - Informar numero do container para  ³±±
±±³Chamado 241662 ³        ³os casos de exportacao, alem  de nao gerar as ³±±
±±³               ³        ³embalagens									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³31/05/12³Projeto Protheus 11 - Substituicao do SetOrder³±±
±±³               ³        ³por Nickname                                  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³30/11/12³CHAMADO 240027 - Limpeza do fonte, tratamento ³±±
±±³               ³        ³para doca exclusiva, e validacao se a etiqueta³±±
±±³               ³        ³ja esta faturada	  						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³21/03/13³ PROJETO ARUMA TERESINA - CHAMADO 265299	  ³±±
±±³               ³        ³Ajuste de dbseek apos compartilhamento do ca- ³±±
±±³               ³        ³dastro de clientes, fornecedores e transporta-³±±
±±³               ³        ³doras										  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cristiane      ³30/07/13³CHAMADO 276084-Ajuste no cod.e filial empresa ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³27/08/13³ CHAMADO 277470 - Calcula o frete a ser desta-³±±
±±³               ³        ³cado na NF utilizando a quantidade da NF.     ³±±
±±³               ³        ³ O valor do frete informado na tabela de preco³±±
±±³               ³        ³(campo ZR_A_FRETE) deve ser sempre em MI	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³28/08/13³ CHAMADO 278380 - Projeto A019/13-Operacao    ³±±
±±³               ³        ³triangular eletronica. Gera automaticamente   ³±±
±±³               ³        ³ a nota de remessa para o destinatario e a    ³±±
±±³               ³        ³ a nota de venda para o cliente.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³09/10/13³ PROJETO A027/13 - ARUMA TERESINA - FASE II   ³±±
±±³               ³        ³CHAMADO: 284710 - Tratamentos p/ nova filial  ³±±
±±³               ³        ³ARUMA Teresina                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³14/11/13³ CHAMADO 278380 - Projeto A019/13-Operacao    ³±±
±±³               ³        ³triangular eletronica. Alteracao na liberacao ³±±
±±³               ³        ³do pedido da op.triangular.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cristiane      ³09/01/14³ CHAMADO 287979 - Tratar Produto em doca lida ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alex Borges    ³10/06/14³ CHAMADO 298562 - Validação da tabela de preço³±±
±±³               ³        ³ ao inserir uma etiqueta.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alex Borges    ³11/06/14³ CHAMADO 298562 - Ajuste do retorno da funçao ³±±
±±³               ³        ³ VldCliente() para nao continuar na rotina    ³±±
±±³               ³        ³ retornar .f.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alex Borges    ³16/06/14³ CHAMADO 298562 -Ajuste da funçao VldCliente()³±±
±±³               ³        ³ antes de execucar a query, faz dbclosearea   ³±±
±±³               ³        ³ no temporario TRBSZR.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima   ³30/06/14³ Pega a tabela de preco do cliente de operacao³±±
±±³               ³        ³ op.triangular.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³01/08/14³ Projeto A018/13 - Chamado: 268694            ³±±
±±³               ³        ³ Valida se o produto esta bloqueado no momento³±±
±±³               ³        ³ da leitura da etiqueta						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³25/09/14³ Projeto A010/14 - Chamado: 306119	          ³±±
±±³               ³        ³ Calcula o preco em reais utilizando a valor  ³±±
±±³               ³        ³ da PTAX D-1 conforme o cliente				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³02/10/14³ CHAMADO 279402 - Projeto A007/13-GFE         ³±±
±±³               ³        ³Incluida validacao do cliente e transportadora³±±
±±³               ³        ³no cadastro de emitentes do GFE. Incluida     ³±±
±±³               ³        ³validacao somente atualizar as etiquetas se   ³±±
±±³               ³        ³a nota foi gerada.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Alberto   ³02/10/14³ CHAMADO 279402 - Projeto A007/13-GFE         ³±±
±±³               ³        ³Alteracao no tipo do frete do material de     ³±±
±±³               ³        ³embalagem para usar o mesmo tipo de frete da  ³±±
±±³               ³        ³lata.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA   ³12/11/14³ AJUSTADO HORARIO PARA EVITAR HORA NEGATIVA   ³±±
±±³               ³        ³ CHAMADO: 309228                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³01/12/14³ Projeto A010/14 - Chamado: 310632 			  ³±±
±±³               ³        ³ Grava a sequencia da ordem de embarque das	  ³±±
±±³               ³        ³ etiquetas									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³05/02/15³ Projeto GFE - Chamado: 279402 			  	  ³±±
±±³               ³        ³ Nao valida emitente quando for FOB ou qdo for³±±
±±³               ³        ³ exportacao									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³15/04/15³ Projeto 021/14 FRETE EXPORTACAO - CH: 319838 ³±±
±±³               ³        ³ Busca o frete para as exportacoes na tabela  ³±±
±±³               ³        ³ de grupo de produtos (PBS) e nao mais no ca- ³±±
±±³               ³        ³ becalho da tabela de precos (SZR)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³01/06/15³ Chamado: 323394. Correção de quando usuario  ³±±
±±³               ³        ³ digita um cód. cliente com UF = "EX" e depois³±±
±±³               ³        ³ troca o cód. cliente nacional.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³10/06/15³ Projeto A003/15. Chamado: 324218.Nao permitir³±±
±±³               ³        ³ embarque de pallet fracionado.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³26/06/15³ Projeto A004/15. Chamado: 325613. Geração de ³±±
±±³               ³        ³ NF de admissao temporaria.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³07/07/15³ Projeto A004/15. Chamado:325613.Nao descontar³±±
±±³               ³        ³ o frete na primeira NF.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³14/07/15³ Projeto A004/15. Chamado: 325613. O valor de ³±±
±±³               ³        ³ frete das folhas devera ser simbolico.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³10/08/15³ Projeto A016/15. Chamado: 328540. Permitir   ³±±
±±³               ³        ³ embarque de pallet fracionado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³14/09/15³ Chamado: 330060. Alteracao do preço unitario ³±±
±±³               ³        ³ das folhas de admissão temporaria.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³23/10/15³ Chamado: 333842. Correcao da hora na filial  ³±±
±±³               ³        ³ durante o horario de verão.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³04/11/15³CHAMADO 303631 PROJETO A002/14 - COMP CADASTRO³±±
±±³               ³        ³Busca dados no ZZG e nao mais no SA1          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA   ³29/12/15³ Chamado: 338109, CONFIRMA A TABELA DE PRECO  ³±±
±±³               ³        ³ DO CLIENTE DE VENDA PARA OPERACAO TRIANGULAR ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³26/01/16³ Chamado: 338492. Correção do embarque de     ³±±
±±³               ³        ³ etiquetas com cód. embalagem diferentes.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³12/04/16³ Chamado: 344445. Projeto A005/16. Alteração  ³±±
±±³               ³        ³ na TES do pedido de venda, para TES priorita-³±±
±±³               ³        ³ rio no item da tabela de preço.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³RICARDO LIMA   ³01/09/16³ Chamado: 346182, inclui a quantidade de      ³±±
±±³               ³        ³ pallet no pedido para ingressar na nota      ³±±
±±³               ³        ³ fiscal como unitizador que sera usado no GFE ³±±
±±³               ³        ³ para calculo de frete por pallet.            ³±±                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³01/09/16³ Chamado: 350242. Proj A025/15. Nova operação ³±±
±±³               ³        ³ triangular                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³16/11/16³ Chamado: 357001. Correção da operação triang ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges    ³17/11/16³ Chamado: 357001. Correção da operação triang ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luiz Cesar     ³26/11/16³ Chamado: 356204. Exceção FRETE FOB           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luiz Cesar     ³12/01/17³ Chamado: 356204. Ajuste posterior a correcao ³±±
±±³               ³        ³ operacao triangular ajustada                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Lima   ³21/03/17³ Chamado: 362908. Retira Validacao do Campo   ³±±
±±³               ³        ³ ZZG_A_TES5                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Eduardo Souza  ³01/12/17³CH:369903. Atualiza Estoque no Sistema O2P com³±±
±±³               ³        ³ Saida de Nota Fiscal                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                   

User Function CRC010 

Local lSaida  := .f.
Local cEtiqueta:=''
Local cCRWDFAT := GetMV("MV_CRWDFAT")
Local akey:={0,0,0,0,0}
Local lEstorno :=.f.
Local nX             

// Luiz Cesar - 31/05/10 - Informacoes de importacao
Local _lprodimp   := .F.
Local _cDI        := CriaVar("SF2->F2_A_DI")   
Local _dDataDI    := CriaVar("SF2->F2_A_DTDI")
Local _cContainer := CriaVar("SF2->F2_A_CTNR")
Local _cProdExt   := ALLTRIM(GETMV("CE_PRODEXT"))

Private _aVldEtiqs:= {}
Private _cPlaca   := space(8)
Private _cUFP     := space(2)
Private nValor   := 0
Private nDoca    := 0
Private nQtde    := 0  //quantidade atual
Private lCredOK  := .f.
Private lNoAberto:= .t.
private cPedido  := Space(6)
private _cProdLida := " "  // Cristiane 09/01/04
private cPedidoE := Space(6)
private nQtdeP   := 0
private cSerSai  := Substr(GetMv("CE_SERNFS"),1,3)
private cDrive := "DBFCDXADS"
private cArq
private cInd
private cArqM
private cIndM
private cArqG
private cIndG
private aPvlNfs:={}
private aPvlNfsR:={}
private cNota
private cNotaR
private nTotPla := 0
private _nFretPBS := 0 //Felipe - 15/04/15 - Valor do frete na tabela PBS (grupo de produtos)
private _nPtxTab  := 0 //Felipe - 25/09/14 - PTAX da tabela de precos utilizada
private _nUltPtx  := U_GETPTAX2(Date()) //Felipe - 25/09/14 - Busca a PTAX da data
private _nPrcUGrp := 0  //Felipe - 25/09/14 - Preco em dolar do grupo sem impostos
private _nPrcRGrp := 0  //Felipe - 25/09/14 - Preco em dolar do grupo sem impostos
private _cCodGrp  := "" //Felipe - 25/09/14 - Codigo do grupo de produtos
private _cPTaxSA1 := ""
private _nPerTSA1 := ""

//Incluido por Marion em 25/02/09 - Topo Plastico*
private _nTotTopPla := 0
Private nQtdPapel := 0
Private aEmbPro  := {}
Private aRemessa := {}
Private aRet
Private lMSErroAuto := .F.
Private cTransp:=Space(6)
Private dtNascimento:= cTod("")
Private lRemessa := .f.
Private cCliente :=SPACE(6)

//Alberto - 15/07/09- Projeto PV Automatico *
Private _cLoja   :=SPACE(2)
Private _cTpFre  :=" "  //Tipo do frete C=CIF F=FOB
Private _cCondPG :="   "  //Cond.Pagto
Private _cTES    :="   "
Private _cTESPauta:="   "  //Alberto - 11/05/11 - Projeto SPED PIS/COFINS
Private _cTESAliq :="   "  //Alberto - 11/05/11 - Projeto SPED PIS/COFINS
Private _cTESIsen:="   " //Felipe Geraldo - 25/04/12 - Tratamento para PIS/COFINS Isento
Private _cMenNF  :=" "  //Mensagem NF
Private _cCodTab :="   "  //Mensagem NF
Private _cCliDF  :=SPACE(6) //CLiente deposito fechado
Private _cLojaDF :=SPACE(2) //Loja    deposito fechado
Private _lGerouPV:=.F.  //Flag geracao pedido venda

//Incluido por Marion em 27/01/09 - Projeto Aruma*
Private _nFusoH := GetMv("MV_CRWHORA")
Private _cHoraNF := Transform(Time(),"99:99:99")
Private _nHoraNF := Val(Left(_cHoraNF,2)) + _nFusoH

//RICARDO LIMA - 12/11/2014
IF _nHoraNF =  -1 .AND. Val(Left(_cHoraNF,2)) = 0
	//_nHoraNF := 11 // Alex Borges - 23/10/15 - Chamado: 333842
	_nHoraNF := 23
ELSEIF _nHoraNF =  -2 .AND. Val(Left(_cHoraNF,2)) = 0
	//_nHoraNF := 10 // Alex Borges - 23/10/15 - Chamado: 333842
	_nHoraNF := 22
ELSEIF _nHoraNF =  -1 .AND. Val(Left(_cHoraNF,2)) = 1
	//_nHoraNF := 11 // Alex Borges - 23/10/15 - Chamado: 333842		
	_nHoraNF := 23		
ENDIF
//

// Incluido por Alberto em 25/02/09 -
Private _lGeraLog := GetMv("MV_CRWLOG")
Private _cDirLog  := GetMv("MV_CRWDIRL")
Private _cArqLOg
Private _aMatEmb:={} //Alberto - 31/05/11- Projeto controle mat.embalagem
Private _cFlagME  := GetMv("CE_FLAGME") //Alberto 13/06/11 - Projeto controle mat.embalagem(parametro que identifica se a rotina sera utilizada na filial)

//Felipe - 09/02/12 - Ajustes e validacao na digitacao do campo placa
Private _cLtrPlaca := SPACE(3)
Private _cNroPlaca := SPACE(4)

//Felipe Geraldo - 25/04/12 - Tratamento para PIS/COFINS Isento e Numero do container para exportacao
Private _lExporta  := .F.
Private _nValFrete := 0

//Luis Alberto - 28/08/13- Projeto A019/13- Operacao triangular automatica
Private _lOpTri    := .f.   //
// Private _cCliTri   := " "  // Cliente operacao triangular //Alex Borges 01/09/2016 - Chamado 350242
Private _cCliTri   := SPACE(TamSX3("A1_COD")[1])   
Private _cLjTri    := " "  // Loja operacao triangular
Private _cCpTri    := " "  // Condicao pagamento operacao triangular
Private _cFreteTri := " "  //Tipo frete operacao triangular
Private _cTesAlTri := " "  //Tes Aliquota operacao triangular
Private _cTesPaTri := " "  //Tes Pauta operacao triangular
Private _cTesIsTri := " "  //Tes Pis Cofins isento operacao triangular
Private _cTesTri   := " "  //Tes operacao triangular
Private _cPauta    := " "   
Private _cCodTabTri:= " "  //Codigo tabela cliente operacao triangular
Private _cNotaTri  := " "  //Nota  operacao triangular
Private _cNomeTri  := " "
Private _cEndTri   := " "
Private _cCNPJTri  := " "
Private _cIETri    := " "
Private _cNomeCli  := " "
Private _cEndCli   := " "
Private _cCNPJCli  := " "
Private _cIECli    := " "
private _cPedTri   := Space(6) //Pedido operacao tringular 
//Inicio - Alex Borges - 26/06/2015 - Chamado 325613 
Private lPrimeira  := .T. 
Private _cPrimEmb  := ""  
Private cNotaAdm   := ""  
Private lGeraAdmTemp := .F.
Private cEmbPlastico := GETMV("CE_EMBPLAS")
Private aPvlNfsAdm  :={}
Private cPedidoAdm  := SPACE(6)
Private nFreteEmb   := 0
//Fim - Alex Borges - 26/06/2015 - Chamado 325613 

//Controle de integracao com o GFE
Private _lIntGFE := GetMv("MV_INTGFE")

VldPerg()
ValidSXB()
VtClear()
VtClearBuffer()

//Alberto - 19/03/10- Projeto Lata importada
Private _cProduto :=SPACE(15)

@ 00,00 VtSay "Embarque"
@ 01,00 VtSay "Doca..:" VtGet nDoca pict "99"  Valid VldDoca(nDoca)
Vtread

If VtLastkey() == 27
	Return .f.
EndIf

//Alberto - 18/02/09 - Incluida validacao do pedido para que o cliente e a tabela de preco fiquem posicionados
//corretamente no momento da atualizacao do preco no pedido de venda.
//Alberto - 15/07/09 -Projeto PV Automatico
//Cristiane - 09/01/14 - tratar codigo do produto da doca ja existente. 
If !lNoAberto
	//If !VldCliente(cCliente,_cLoja)
	If !VldCliente(cCliente,_cLoja,_cProdLida)
		VTBeep(3)
		VTAlert("Cliente invalido !!!","Aviso",.t.,4000)
		Return .f.
	Endif
Endif

//Alberto - 15/07/09 -Projeto PV Automatico 
//Alberto - 29/07/09- Ajuste posicionamento campos 
@ 02,00 VtSay "Cliente:" VtGet cCliente  pict '@!'  When lNoAberto Valid VldCliente(cCliente,_cLoja) F3 "SA1"  //Alberto -19/03/10- Projeto Lata importada
@ 03,00 VtSay "Transp:" VtGet cTransp   pict '@!'  When lNoAberto Valid VldTransp(cTransp) F3 "SA4"

//Felipe - 09/02/12 - Ajustes e validacao na digitacao do campo placa
@ 04,00 VtSay "Placa/UF:" VtGet _cLtrPlaca Pict '@!' When lNoAberto Valid !Empty(_cLtrPlaca) .AND. Len(Alltrim(_cLtrPlaca))=3 .AND. VldPlaca(_cLtrPlaca,1)
@ 04,13 VtGet                   _cNroPlaca Pict '@!' When lNoAberto Valid !Empty(_cNroPlaca) .AND. Len(Alltrim(_cNroPlaca))=4 .AND. VldPlaca(_cNroPlaca,2)
@ 04,17 VtGet                   _cUFP      Pict '@!' When lNoAberto Valid !Empty(_cUFP)      .AND. ExistCpo("SX5","12"+_cUFP) F3 "12"  //.and. MostraPlaca(04,00)
@ 05,00 VtSay "Cap. Pallets:" VtGet nQtdeP pict '99' When lNoAberto Valid VldQTEP(nQtdeP)
VtRead

If empty(_cLoja)
	SA1->(dbsetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliente))
		_cLoja := SA1->A1_LOJA
	EndIf
Endif

//Felipe Geraldo - 23/04/12 - Verifica se o cliente eh de fora do Brasil
If SA1->A1_EST == "EX"
	_lExporta := .T.
Else
	//Alex Borges - 01/06/15 - Chamado: 323394
	_lExporta := .F.
EndIf

If VtLastkey() == 27
	Doca->(dbCloseArea())
	_cArqDoca := "DOCA" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
	FErase(_cArqDoca+STRZERO(nDoca,2)+".DTC")
	FErase(_cArqDoca+STRZERO(nDoca,2)+".CDX")
	
	LimpaCab(nDoca)
	LimpaDocaEti()
	Return .f.
EndIf

akey[1] := VTSetKey(09,{||InfoEmbarque()})  // CTRL+I
akey[2] := VTSetKey(01,{||InfoTec()})   // CTRL+A
akey[3] := VTSetKey(24,{||Estorna()})   // CTRL+X
akey[4] := VTSetKey(16,{||Parametros()})   // CTRL+P

lEstorno:= (nQtde == nQtdeP)
_lprodimp := .F.

//Felipe - 09/02/12 - Ajustes e validacao na digitacao do campo placa
_cPlaca := _cLtrPlaca + _cNroPlaca

While nQtde < nQtdeP .or. lEstorno

	If lEstorno
		lEstorno := .f.
	EndIf
	
	cEtiqueta := Space(20)

	//Alberto -29/07/09- Ajuste posicionamento campos *
	@ 06,00 VtSay "Etiqueta:" VtGet cEtiqueta pict "@!" valid vldeti(cEtiqueta) 
	VtRead
	
	If VtLastkey() == 27
		If Empty(nQtde)
			Doca->(dbCloseArea())
			dbUseArea(.T.,cDrive,cArq,'DOCA',.f.,.F.)
			If ! neterr()
				Doca->(dbCloseArea())
				_cArqDoca := "DOCA" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
				FErase(_cArqDoca+STRZERO(nDoca,2)+".DTC")
				FErase(_cArqDoca+STRZERO(nDoca,2)+".CDX")
				
				LimpaCab(nDoca)
			EndIf
			LimpaDocaEti()
			VTReverso(.f.)
			Return
		EndIf

		//Alberto -29/07/09- Ajuste posicionamento campos *
		@ 07,00 VtSay space(21) //Alberto - 06/06/09 - Projeto PV Automatico
		
		Exit
	EndIf
	
	//Luiz Cesar - 31/05/2010 - Verifica se esta gerando produto importado
	_cProdExt := ALLTRIM(GETMV("CE_PRODEXT"))
	
	//Alterado por J.Francisco em 17/01/11 - A024/10 *
	_lProdimp := if( posicione("SBM",1,xFilial("SBM") + Posicione("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO, "B1_GRUPO"), "BM_A_ORIG") == "I" ,.T.,.F.)

Enddo

//Alberto - 15/07/09 - Projeto PV Automatico     *
If !empty(nQtde)
	//VldQTEP(nQtdeP) //Alex Borges - 01/09/2016 - Chamado 350242
	If !VldQTEP(nQtdeP)
		Doca->(dbCloseArea())
		CABDOCA->(dbCloseArea())
		DocaEti->(dbCloseArea())
		VTReverso(.f.)
		return .f.	
	EndIf
Endif

VTSetKey(9,aKey[1]) // informacoes ref a pesquisa ctrl-i
VTSetKey(1,aKey[2]) // informacoes tecla          ctrl-A
VTSetKey(24,aKey[3]) // estorno CTRL+X
VTSetKey(16,aKey[4]) // pergunte

Doca->(dbCloseArea())
dbUseArea(.T.,cDrive,cArq,'DOCA',.f.,.F.)

If neterr() .or. If(nQtde # nQtdeP ,.t.,! VTYesNo("Confirma a geracao da nota?","Aviso",.t.))
	If ! neterr()
		Doca->(dbCloseArea())
	Else
		If nQtde = nQtdeP
			VTBeep(3)
			VTAlert("Embarque concluido, a geracao de nota sera concluido pelo ultimo usuario","Aviso",.t.,6000)
		EndIf
	EndIf
	CABDOCA->(dbCloseArea())
	DocaEti->(dbCloseArea())
	VTReverso(.f.)
	return .f.

//Felipe Geraldo - 30/11/12 - Validacao para nao gerar NF com uma etiqueta ja faturada (problema de doca suja em Ponta Grossa)
Else
	_aAreaAnt := GetArea()
	_aAreaCB0 := CB0->(GetArea())
	dbSelectArea("CB0")
	dbSetOrder(1)
	If dbSeek( xFilial("CB0") + DOCA->IDETIQ ) .AND. !Empty(CB0->CB0_NFSAI)
		VTBeep(3)
		VTAlert("Etiqueta(s) carregada(s) já foi faturada(s). Favor limpar o arquivo de doca!!!","Aviso",.t.,6000)	
		DOCA->(dbCloseArea())
		CABDOCA->(dbCloseArea())
		DOCAETI->(dbCloseArea())
		VTReverso(.F.)
		Return .F.
	EndIf
	RestArea(_aAreaCB0)
	RestArea(_aAreaAnt)
EndIf

dbSetIndex(FileNoExt(cInd))

//Alex Borges - 01/09/2016 - Chamado 350242
dbSelectArea("ZZG")
dbSetOrder(1)
If dbSeek(xFilial("ZZG") + cCliente + _cLoja)
	If ZZG->ZZG_A_TRIA = 'S'
    	_lOpTri := .t.  
	EndIf
EndIf

If _lOpTri
   	VTClear()
   	@ 02,00 VtSay "Cliente Triangular:" 
	@ 03,00 VtGet _cCliTri  pict '@!' Valid VldCliTri(_cCliTri) F3 "SA1"
	VTRead
	
	If VtLastkey() == 27 
		Doca->(dbCloseArea())
		CABDOCA->(dbCloseArea())
		DocaEti->(dbCloseArea())
		VTReverso(.f.)
		return .f.
	Else	
		If !VTYesNo("Confirma Operacao Triangular? ","Aviso",.t.)
			Doca->(dbCloseArea())
			CABDOCA->(dbCloseArea())
			DocaEti->(dbCloseArea())
			VTReverso(.f.)
			return .f.			
		EndIf
   	EndIf
	
EndIf
//Alberto - 31/05/11- Projeto controle Mat.Embalagem*
If _cFlagME = "S"
	
	_aMatEmb:={}
	_nQtdEmb:=0
    _nPosEmb:=0

	Doca->(DBGoTop())
	While ! Doca->(Eof())

 		PBZ->(dbSeek(xFilial("PBZ")+Doca->MATEMB))

        //Pallet  
		nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_PAL})
		If  nPos==0
			AADD(_aMatEmb,{PBZ->PBZ_A_PAL,1,1})
		Else
			_aMatEmb[nPos,2]+=1
			_aMatEmb[nPos,3]+=1
		EndIf 

		//Folha
		nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_FOL})
		If  nPos==0
			AADD(_aMatEmb,{PBZ->PBZ_A_FOL,Doca->QTDPAPEL,1})
		Else
			_aMatEmb[nPos,2]+=Doca->QTDPAPEL
			_aMatEmb[nPos,3]+=1
		EndIf 

		//Quadro
		nPos:= ascan(_aMatEmb,{|x| x[1]==PBZ->PBZ_A_QUA})
		If  nPos==0
			AADD(_aMatEmb,{PBZ->PBZ_A_QUA,1,1})
		Else
			_aMatEmb[nPos,2]+=1
			_aMatEmb[nPos,3]+=1
		EndIf 

		Doca->(DbSkip())
	End

Endif

//Alterado por Marion em 25/02/09 - Topo Plastico*
If _cFlagME = "N"  //Alberto - 13/06/11 - Projeto controle Mat.Embalagem

	While .t.

		VTClear()
		@ 00,00 VtSay "Embarque"
		@ 02,00 VtSay "Informe total de "
		@ 03,00 VtSay "pallets de plastico"
		@ 04,00 VtGet nTotPla PICTURE "99"   Valid nTotPla >= 0 .and. nTotPla <= nQtde
		VTRead
		VTBEEP(3)
	
		VTClear()
		@ 00,00 VtSay "Embarque"
		@ 02,00 VtSay "Informe total de "
		@ 03,00 VtSay "topos de plastico"
		@ 04,00 VtGet _nTotTopPla PICTURE "99"   Valid _nTotTopPla >= 0 .and. _nTotTopPla <= nQtde
		VTRead
		VTBEEP(3)
	
		If VTYesNo("Confirma quatidade? "+chr(13)+chr(10)+"PP --> "+strzero(nTotPla,2)+" <--"+chr(13)+chr(10)+"TP --> "+strzero(_nTotTopPla,2)+" <--","Aviso",.t.)
			Exit
		EndIf
	End
Endif

//Luiz Cesar - 31/05/2010 - Informacoes adicionais para produto importado
if _lProdImp

   While .t.
     	VTClear()
        @ 00,00 VtSay "Dados de Importacao"
	    @ 02,00 VtSay "DI .: " VtGet _cDI         Valid !empty(_cDI)
		@ 03,00 VtSay "Data: " VtGet _dDataDI     Valid !empty(_dDataDI) 
		@ 04,00 VtSay "CTNR: " VtGet _cContainer  Valid !empty(_cContainer)
		VTRead
		VTBEEP(3)
	               
	
		If VTYesNo("Confirma Dados Importacao? ","Aviso",.t.)
			Exit
		EndIf
   End 	
   
Endif

//Felipe Geraldo - 23/04/12 - Se eh exportacao pede o numero do container
If _lExporta
	While .T.
		VTClear()
		@ 00,00 VtSay "Dados de Exportacao"
		@ 02,00 VtSay "CTNR: " VtGet _cContainer  Valid !Empty(_cContainer)
		VTRead
		VTBEEP(3)

		If VTYesNo("Confirma Nro Container? ","Aviso",.t.)
			Exit
		EndIf
	End
EndIf

FechaSemaforo()
vtclear()

//Alberto - 25/02/2009 - Gravar log de geracao da nota  *
If _lGeralog
	_cCabecLog:= "pedido;produto;cliente;tabela;preco tabela;preco pedido;nota;serie"
	_cItensLog:= DOCA->PEDIDO+";"+DOCA->PRODUTO+";"+cCliente+";" //Alberto -15/07/09- Projeto PV Automatico
Endif

//Alberto - 18/02/2009                                               *
//Atualizar o preco de venda do pedido com base na tabela de preco   *
//somente se o pedido estiver com o campo tabela de preco preenchido *
//Alberto - 15/07/09- Projeto PV Automatico *
Begin transaction
VTClear()

// Trata faturamento com data retroativa
If cCRWDFAT == "N"
	DDATABASE := Date()
Endif

U_fAltdBase(.t.)

//Alberto 06/05/2009 -Projeto PV Automatico *
@ 01,00 VtSay "Gerando pedido..."
GerPed() // gera pedido automatico

//Felipe - 04/11/15 - Chamado 303631 - Posiciona e busca informacoes no cadastro auxiliar do cliente
//If SA1->A1_A_EMBAL == "S"
// Alex Borges 01/09/2016 chamado 350242 
If !_lOpTri
	dbSelectArea("ZZG")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZG") + SA1->A1_COD + SA1->A1_LOJA) .AND. ZZG->ZZG_A_EMB == "S"
		@ 02,00 VtSay "Gerando embalagem.."
		GerPedEmb() // gera pedido com material de embalagem
		U_AcertaSC9(SC5->C5_NUM)  //Rotina para acerto do SC9 (Henrique 26/06/2005)
	EndIf
EndIf

@ 03,00 VtSay "Liberando pedido..."
Libera() // liberando pedido e empenhando
@ 04,00 VtSay "Gerando nota..."
cNota := MaPvlNfs(aPvlNfs,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

SF2->(dbSetOrder(1))
SF2->(dbSeek(xFilial("SF2")+cNota+SERIE))
If SF2->(!EOF())

	//Incluido por Cristiane em 02/01/2009 *
	If (Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL))="0102"
		If(LEN(alltrim(cNota))=6)
			cNota := (substr(alltrim(cNota),1,6)+space(03))
		EndIF
	EndIF

	//Inclusao sandro e bartolo
	If ( GetMv("MV_NUMITEN",.T.) )
		SX6->(MsRUnLock())
	EndIf

	// Nao permite gravacao incompleta da placa do Veiculo
	if len(alltrim(_cPlaca))<7
		_cPlaca:=""
	endif

	RecLock('SF2',.f.)
	SF2->F2_TRANSP  := cTransp
	SF2->F2_A_PLACA := _cPlaca
	SF2->F2_A_UFP   := _cUFP
	SF2->F2_HORA    := strzero(_nHoraNf,2) + Substr(_cHoraNf,3,3) //Alberto - 13/04/11- Correcao gravacao campo F2_HORA

	// Luiz Cesar - 31/05/2010 - dados importacao 
	if _lprodimp
	   SF2->F2_A_DI   := _cDI
	   SF2->F2_A_DTDI := _dDataDI
	   SF2->F2_A_CTNR := _cContainer            
	endif

	//Felipe Geraldo - 23/04/12 - Grava o numero do container no SF2
	If _lExporta
	   SF2->F2_A_CTNR := _cContainer            
	Endif
	MSUNLOCK()

	//Alberto - 25/02/2009 - Gravar log de geracao da nota
	If _lGeralog
		_cItensLog+= SF2->F2_DOC+";"+SF2->F2_SERIE+";"
		_cArqLog := SF2->F2_DOC+SF2->F2_SERIE+StrTran(Time(), ":", "" )
		_nHandle := MsfCreate(_cDirLog+"\"+_cArqLog+".CSV",0)
		If _nHandle > 0
			FWrite(_nHandle, _cCabecLog +Chr(13) + Chr(10) )
			FWrite(_nHandle, _cItensLog +Chr(13) + Chr(10) )
			FClose(_nHandle)
		Endif
	Endif

	//Luis Alberto - 28/08/13- Projeto A019/13- Operacao triangular automatica
	If _lOpTri
		aPvlNfs := {}
		@ 05,00 VtSay "Gerando pedido op.triangular"
		GerPedTri() // gera pedido automatico
		//Alex Borges - 01/09/2016 - Chamado 350242
		dbSelectArea("ZZG")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZG") + SA1->A1_COD + SA1->A1_LOJA) .AND. ZZG->ZZG_A_EMB == "S"
			@ 02,00 VtSay "Gerando embalagem.."
			GerPedEmb() // gera pedido com material de embalagem
			//U_AcertaSC9(SC5->C5_NUM)  //Rotina para acerto do SC9 (Henrique 26/06/2005)
		EndIf

		@ 06,00 VtSay "Gerando nota op.triangular"
		_cNotaTri := MaPvlNfs(aPvlNfs,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
	    Dbselectarea("SF2")
    	Dbsetorder(1)
		If Dbseek(xfilial("SF2")+_cNotaTri+SERIE)// Alex Borges - 01/09/2016 - 350242
			RecLock('SF2',.f.)
			SF2->F2_A_DOCTRI := cNota
			SF2->F2_A_SERTRI := SERIE
			SF2->F2_A_PLACA := _cPlaca // Alex Borges - 01/09/2016 - 350242
			SF2->F2_A_UFP   := _cUFP // Alex Borges - 01/09/2016 - 350242
			SF2->(MSUNLOCK())
        Else
        	VTBeep(3)
			VTAlert("Falha na geração da Nota Fiscal da operacao triangular.","Aviso",.t.,6000)
			_cNotaTri := "" 
			cNota     := ""
			DisarmTransaction()
			Return .F.
        EndIf
	    
	    If Dbseek(xfilial("SF2")+cnota+SERIE)
			RecLock('SF2',.f.)
			SF2->F2_A_DOCTRI := _cNotaTri
			SF2->F2_A_SERTRI := SERIE
			SF2->(MSUNLOCK())
    	Endif     
	    //Atualiza mensagem no pedido remessa
    	Dbselectarea("SC5")    
		SC5->(dbsetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+cPedido))
			RecLock('SC5',.f.)
			//Alex Borges - 26/09/16 - Chamado - 350242 
			//SC5->C5_MENNOTA := " MERCADORIA ENVIADA POR CONTA E ORDEM DE "+_cNomeTri+"-"+_cEndTri+"-CNPJ "+_cCNPJTri+"-I.E."+_cIETri+"-"+" CONF. NF. "+_cNotaTri
			SC5->C5_MENNOTA := " Mercadoria enviada para fins de industrialização a "+_cNomeTri+"-"+_cEndTri+"-CNPJ "+_cCNPJTri+"-I.E."+_cIETri+"-"+" CONF. NF. "+_cNotaTri
		
			SC5->(MSUNLOCK())

		EndIf
	    //Atualiza mensagem no pedido venda
    	Dbselectarea("SC5")    
		SC5->(dbsetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+_cPedTri))
			RecLock('SC5',.f.)
			//Alex Borges - 26/09/16 - Chamado - 350242
			//SC5->C5_MENNOTA := "A NF SEGUIU P/ "+_cNomeCli+"-"+_cEndCli+"-CNPJ "+_cCNPJCli+"-I.E."+_cIECli+"-"+" CONF. NF. "+cNota
			SC5->C5_MENNOTA := "Mercadoria que segue para fins de indust. impostos já recolhido atraves da NF "+cNota+", empresa "+_cNomeCli+"-"+_cEndCli+"-CNPJ "+_cCNPJCli+"-I.E."+_cIECli+"."
			SC5->(MSUNLOCK())
		EndIf
    
	Endif

	If lRemessa
		nRecSF2:= SF2->(RECNO())
		@ 04,00 VtSay "Gerando nota de "
		@ 05,00 VtSay "remessa..."
		Libera() // liberando pedido e empenhando
		cNotaR := MaPvlNfs(aPvlNfsR,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
	
		//Incluido por Cristiane em 02/01/2009 *
		If (Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL))="0102"
			IF(LEN(alltrim(cNotaR))=6)
				cNotaR := (substr(alltrim(cNotaR),1,6)+space(03))
			EndIf
		EndIF
	
		If ( GetMv("MV_NUMITEN",.T.) )
			SX6->(MsRUnLock())
		EndIf
	
		RecLock('SF2',.f.)
		SF2->F2_TRANSP := cTransp
		SF2->F2_CRNFAUX := cNota
		SF2->F2_A_PLACA := _cPlaca
		// Luiz Cesar - 06/04/2009
		SF2->F2_A_UFP   := _cUFP
		SF2->(MSUNLOCK())
	
		SF2->(DbGoTo(nRecSF2))
		RecLock('SF2',.f.)
		SF2->F2_CRNFAUX:= cNotaR
		SF2->(MSUNLOCK())

	EndIf

	@ 05,00 VtSay "Atualizando..."
	If lRemessa
		@ 05,00 VtSay "Atualizando nota ..."+cNotaR
		AtuCB0(cNotaR,SERIE)
	Else
		@ 05,00 VtSay "Atualizando nota ..."+cNota
		//Alex Borges - 17/11/16 - Chamado 357001
		//AtuCB0(cNota,SERIE)
		If _lOpTri
			AtuCB0(_cNotaTri,SERIE)
		Else
			AtuCB0(cNota,SERIE)
		EndIf
	EndIf
	
	//Alex Borges - 26/06/2015 - Chamado 325613
	//Verifica se irá gerar nota fiscal de admissao temporária
	If (CB0->CB0_NFSAI = SF2->F2_DOC) .AND. (CB0->CB0_SERIES = SF2->F2_SERIE) //Validação para consistencia da informação
		_cMatEmb := CB0->CB0_A_TPEM 
	    If !Empty(_cMatEmb)
		 	If _cMatEmb $ cEmbPlastico
		    	lGeraAdmTemp := .T.
		   	EndIf
		EndIf
		
		//Alex Borges - 10/08/2015 - Chamado 328540
		//Após o faturamento de pallet fracionado o produto será bloqueado novamente para não permitir novas vendas sem aprovação do comercial.
		aAreaAtu := GetArea()
		aAreaSB1 := SB1->(GetArea())
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+CB0->CB0_CODPRO)
			If SB1->B1_A_LFRAC = "S" // Atualiza apenas se estiver liberado.
				If SB1->(RecLock("SB1",.F.))
					SB1->B1_A_LFRAC := "N"
					SB1->(MsUnLock())
				EndIf              
			EndIf
		EndIf
	    RestArea(aAreaSB1)
	    RestArea(aAreaAtu)
	    
	EndIf
	
	If lGeraAdmTemp
		nRecSF2:= SF2->(RECNO())
		//Gera pedido de venda e fatura admissao temporaria
		If !FatAdm(_cMatEmb)
			DisarmTransaction()
			lMsErroAuto := .T.
		EndIf
	EndIf
		
Endif

End transaction

If lMsErroAuto
	cFileLog := NomeAutoLog()
	If VALTYPE(cFileLog) == "C"
		VTDispFile(NomeAutoLog(),.t.)
	Endif
EndIf

//Alberto - 25/03/09 - Projeto nf eletronica - Inibida a impressao da nota e a sua exclusao *
VTBeep(3)
If !empty(cNotaR)
	VTAlert("Foi gerada a nota fiscal de remessa "+cNotaR,"Aviso",.t.,6000)
Endif
If !empty(cNota) .and. !lMSErroAuto .and. !SF2->(EOF())  //Alberto - 02/10/2014- Nao apresentar a mensagem se a nota nao foi gerada
   //Luis Alberto - 28/08/13- Projeto A019/13- Operacao triangular automatica
   If !empty(_cNotaTri) 
		VTAlert("Foram geradas as notas fiscais "+cNota+" "+_cNotaTri,"Aviso",.T.,6000)
   Else
		If lGeraAdmTemp //Se gerou a nota fiscal de admissao temporaria apresenta ao usuario. //Alex Borges - 26/06/2015 - Chamado 325613
			VTAlert("Foi gerada a NF "+cNota+" e também NF "+cNotaAdm+" da adm. temporaria","Aviso",.T.,6000)
		Else
			VTAlert("Foi gerada a nota fiscal "+cNota,"Aviso",.T.,6000)
		EndIf
   Endif
Endif

AbreSemaforo()
Doca->(dbCloseArea())

//Alberto - 15/07/09 - Projeto PV Automatico
If _lGerouPV .and. !SF2->(EOF())  //Alberto - 24/01/2014- Nao apresentar a mensagem se a nota nao foi gerada
	_cArqDoca := "DOCA" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
	FErase(_cArqDoca+STRZERO(nDoca,2)+".DTC")
	FErase(_cArqDoca+STRZERO(nDoca,2)+".CDX")

	LimpaCab(nDoca)
	LimpaDocaEti()
Else
	CABDOCA->(DBCloseArea())
	DocaEti->(dbCloseArea())
Endif

VTReverso(.f.)

gera:= GetMv("MV_SITCAR1")
cCliente := Posicione("SC5",1,xFilial("SC5")+cPedido,"C5_CLIENTE")

If cCliente $ gera
	cArqTxt:=""
	lEnviado:=.F.
	@ 05,00 VtSay "Gerando arquivo..."
	GeraTxt(cArqTxt)
	@ 07,00 VtSay "Enviando arquivo..."
	EnviaTxt(cArqTxt)
Endif

//Incluido por Luiz Cesar em 20/09/2010 *
U_ALUFAT58(SF2->F2_DOC,SF2->F2_SERIE) // Armazem Externo(PIA) geracao PAH

//Deposito Fechado geracao PB5
u__fImporta() 

//Ajusta a data
U_fAltdBase(.f.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³  VldDoca ³AUTOR: ³ Sandro                ³DATA: ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao dos Gets - Utilizado pelo programa CRC010        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Anderson      ³10/06/08³Cabecalho, identacao                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldDoca(nDoca)

Local aStru

If Empty(nDoca)
	Return .f.
EndIf

If nDoca > 4 //Alterado por em 14/10/04
	VTBeep(3)
	VTAlert("Doca nao pode ser maior que 04, verifique !!!","Aviso",.t.,4000)
	Return .f.
Endif

//Tratamento de abertura/criacao do arquivo
_cArqDoca := "DOCA" + Alltrim(SM0->M0_CODIGO)+ Alltrim(SM0->M0_CODFIL)
cArq  := RetArq(cDrive,_cArqDoca+STRZERO(nDoca,2),.t.)
cInd  := RetArq(cDrive,_cArqDoca+STRZERO(nDoca,2),.f.)

//Felipe Geraldo - 30/11/12 - Tratamento para doca exclusiva
If ! File(cArq) .or. !File(cInd)
	If ! File(cArq)
		aStru :={{"QTDEP"   ,"N",02,00},;
		{"CLIENTE" ,"C",06,00},;  //Alberto - 15/07/09 - Projeto PV Automatico
		{"LOJA"    ,"C",02,00},;  //Alberto - 15/07/09 - Projeto PV Automatico
		{"PEDIDO"  ,"C",06,00},;
		{"TRANSP"  ,"C",06,00},;
		{"IDETIQ"  ,"C",20,00},;
		{"PRODUTO" ,"C",15,00},;
		{"QTDE"    ,"N",15,03},;
		{"LOCALIZ" ,"C",15,00},;
		{"ALMOX"   ,"C",02,00},;
		{"PLACA"   ,"C",08,00},;
		{"UFP"     ,"C",02,00},;
		{"TES"     ,"C",03,00},; //Alberto -11/05/11 - Projeto SPED PIS/COFINS
		{"MATEMB"  ,"C",02,00},;  //Alberto - 31/05/11 - Projeto controle mat.embalagem
		{"CLIENTETRI","C",06,00},; //Alberto - 28/08/13- Projeto operacao triangular automatica
		{"LOJATRI" ,"C",02,00},; //Alberto - 28/08/13- Projeto operacao triangular automatica
		{"QTDPAPEL","N",05,00},;
		{"USUARIO" ,"C",25,00},;
		{"SEQEMB"  ,"N",02,00}} //Felipe - 01/12/14 - Grava a ordem da sequencia de embarque
		MsCreate( cArq, aStru,cDrive)
	EndIf
	
	dbUseArea(.T.,cDrive,cArq,'DOCA',.f.,.F.) // exclusivo
	INDEX ON IDETIQ TAG &(RetFileName(cInd)) TO &(FileNoExt(cArq))
	
	RecLock("DOCA",.T.)
	DOCA->IDETIQ  := 'NOVO'
	DOCA->USUARIO := Alltrim(cUserName)
	MsUnLock()
	Doca->(dbCloseArea())

Else

	lNoAberto := .T.
	dbUseArea(.T.,cDrive,cArq,'DOCA',.t.,.F.) // COMPARTILHADO
	dbSetIndex(FileNoExt(cInd))
	dbSelectArea("DOCA")
	DOCA->(dbGotop())
	If Alltrim(cUserName) <> Alltrim(DOCA->USUARIO)
		VtBeep(3)
		VtAlert("Doca em uso pelo usuário " + Alltrim(DOCA->USUARIO) + ". Favor utilizar outra doca!!!" , "Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		DbCloseArea()
		Return .F.		
	EndIf
	Doca->(dbCloseArea())
	
EndIf

dbUseArea(.T.,cDrive,cArq,'DOCA',.t.,.F.) // COMPARTILHADO
dbSetIndex(FileNoExt(cInd))
dbSelectArea("DOCA")

//tratamento do arquivo de etiquetas por doca
_cArqDocaEti := "DETI" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
cArqG  := RetArq(cDrive,_cArqDocaEti,.T.)
cIndG  := RetArq(cDrive,_cArqDocaEti,.F.)

If ! File(cArqG)  .or. ! File(cIndG)
	IF ! File(cArqG)
		aStru :={{"ETIQUETA"    ,"C",20,00},;
		         {"DOCA"         ,"N",2,00}}
		MsCreate( cArqG, aStru,cDrive)
	EndIf
	
	dbUseArea(.T.,cDrive,cArqG,'DOCAETI',.f.,.F.) // exclusivo
	INDEX ON ETIQUETA TAG &(RetFileName(cIndG)) TO &(FileNoExt(cArqG))
	DOCAETI->(dbCloseArea())
EndIf

dbUseArea(.T.,cDrive,cArqG,'DOCAETI',.t.,.F.) // COMPARTILHADO
dbSetIndex(FileNoExt(cIndG))
dbSelectArea("DOCAETI")

//tratamento do cabecalho
_cArqCabDoca := "CDOCA" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
cArqM  := RetArq(cDrive,_cArqCabDoca,.T.)
cIndM  := RetArq(cDrive,_cArqCabDoca,.F.)

If ! File(cArqM)  .or. ! File(cIndM)
	IF ! File(cArqM)
		aStru :={{"DOCA"    ,"C",02,00},;
		{"CLIENTE"  ,"C",06,00},;   //Alberto - 15/07/09 - Projeto PV Automatico
		{"LOJA"     ,"C",02,00},;   //Alberto - 15/07/09 - Projeto PV Automatico
		{"PEDIDO"  ,"C",06,00},;
		{"PRODUTO" ,"C",15,00},;
		{"QTDE"    ,"N",15,03}}
		MsCreate( cArqm, aStru,cDrive)
	EndIf
	
	dbUseArea(.T.,cDrive,cArqM,'CABDOCA',.f.,.F.) // exclusivo
	INDEX ON DOCA+CLIENTE+LOJA+PEDIDO+PRODUTO TAG &(RetFileName(cIndM)) TO &(FileNoExt(cArqM))  //Alberto - 15/07/09 - Projeto PV Automatico
	CABDOCA->(dbCloseArea())
EndIf

dbUseArea(.T.,cDrive,cArqM,'CABDOCA',.t.,.F.) // COMPARTILHADO
dbSetIndex(FileNoExt(cIndM))
dbSelectArea("CABDOCA")

//Alberto - 15/07/09 - Projeto PV Automatico
dbSelectArea("DOCA")
If ! DOCA->(DbSeek('NOVO')) .OR. ! Empty(DOCA->PEDIDO).OR. ! Empty(DOCA->CLIENTE)

	DOCA->(DBGOTOP())
	_cLtrPlaca := Substr(DOCA->PLACA,1,3)
	_cNroPlaca := Substr(DOCA->PLACA,4,4)
	_cUFP      := DOCA->UFP

	// Alberto -29/07/09- Ajuste posicionamento campos		
	@ 02,00 VtSay "Cliente: "+DOCA->CLIENTE   //Alberto - 15/07/09 - Projeto PV Automatico
	@ 03,00 VtSay "Transp: "+DOCA->TRANSP

	// Felipe (MRC) - 01/03/12 - Ajuste para montagem da placa na tela
	@ 04,00 VtSay "Placa/UF: " + _cLtrPlaca
	@ 04,13 VtSay                _cNroPlaca
	@ 04,17 VtSay                _cUFP
	@ 05,00 VtSay "Cap. Pallets: "+STRZERO(QTDEP,2)

	cPedido := DOCA->PEDIDO
	cCliente:= DOCA->CLIENTE  
	_cLoja  := DOCA->LOJA     
	cTransp := DOCA->TRANSP
	nQTDEP  := DOCA->QTDEP
	_cProdLida := DOCA->PRODUTO  // Cristiane 09/01/14
	_cPlaca := _cLtrPlaca + _cNroPlaca
	_cTES   := DOCA->TES  //Alberto - 11/05/11 - Projeto SPED PIS/COFINS
	nQtde := 0
	dbeval({|| nQtde++},{|| IDETIQ <> "NOVO"} )

	//Alberto -29/07/09- Ajuste posicionamento campos 
	@ 07,00 VtSay " Embarcadas...: "+strzero(nQtde,2)

	/*//Luis Alberto - 28/08/13- Projeto A019/13- Operacao triangular automatica
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4") + _cTes) 
	If SF4->F4_A_OPTRI ='S'
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1") + cCliente+_cLoja) 
	    _lOpTri := .t.  

	    //Felipe - 04/11/15 - Chamado 303631 - Posiciona e busca informacoes no cadastro auxiliar do cliente
		dbSelectArea("ZZG")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZG") + cCliente + _cLoja)
			If Empty(ZZG->ZZG_A_CTRI) .OR. Empty(ZZG->ZZG_A_LJTR) .OR. Empty(ZZG->ZZG_A_TES4) .OR. Empty(ZZG->ZZG_A_TES5) .OR. Empty(ZZG->ZZG_A_TES6)
				VtBeep(3)
				VtAlert("Os campos do cliente para operacao triangular nao estao preenchidos no cadastro auxiliar de clientes. Entrar em contato com depto comercial.","Aviso",.t.,3000)
				VtKeyboard(Chr(20))
				DbCloseArea()
				Return .F.
			Endif
		Else
			VtBeep(3)
			VtAlert("Não foi localizado o cadastro auxiliar do cliente para operacao triangular. Entrar em contato com depto comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			DbCloseArea()
			Return .F.			
		EndIf

       //Felipe - 18/09/2014 - Variaveis sao atualizadas pela tabela ZZG
	   _cCliTri   := ZZG->ZZG_A_CTRI  //Cliente operacao triangular
	   _cLjTri    := ZZG->ZZG_A_LJTR  //Loja operacao triangular
	   _cTesAlTri := ZZG->ZZG_A_TES4  //Tes Aliquota operacao triangular
	   _cTesPaTri := ZZG->ZZG_A_TES5  //Tes Pauta operacao triangular
	   _cTesIsTri := ZZG->ZZG_A_TES6  //Tes Pis Cofins isento operacao triangular

	   _cPTaxSA1 := SA1->A1_A_PTXD1
	   _nPerTSA1 := SA1->A1_A_PEPTX

	   //Validar tabela de preco do cliente  da operacao triangular
	   _nRecSA1:=SA1->(recno())
	   VldCliTri(_cCliTri,_cLjTri)
	   SA1->(DbGoTo(_nRecSA1))
	Endif */ // Alex Borges - 01/09/2016 - Chamado 350242
	lNoAberto := .F.
Else
	lNoAberto := .T.
EndIf

dtNascimento:= cTod("")

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldPed   ³AUTOR: ³ Sandro                ³DATA: ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao do Pedido de Venda informado - Utilizado pelo    ³±±
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
±±³ Felipe        ³06032006³Valida a vigencia da tabela de preco no pedido³±±
±±³				  ³		   ³de venda digitado (PROJETO PRICELIST)         ³±±
±±³ Felipe        ³18052006³Altera tabela de preco no cadastro do cliente ³±±
±±³				  ³		   ³caso esteja diferente da tabela do pedido de  ³±±
±±³				  ³		   ³vendas (PROJETO PRICELIST)                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldPed(cPedido)

If Empty(cPedido)
	return .f.
EndIf

SC5->(dbSetOrder(1))
If ! SC5->(DbSeek(xFilial("SC5")+cPedido))
	VtBeep(3)
	VtAlert("Pedido nao existe.","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

If !(Empty(SC5->C5_LIBEROK).And. Empty(SC5->C5_NOTA))
	VtBeep(3)
	VtAlert("Pedido encerrado","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

dbSelectArea("DOCA")
IF DOCA->(DbSeek('NOVO'))
	RecLock("DOCA",.F.)
	DOCA->PEDIDO := cPedido
	DOCA->TRANSP := cTransp
	DOCA->PLACA  := _cPlaca
	DOCA->UFP    := _cUFP
	MsUnLock()
EndIf

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

//Alberto - 18/02/2009                  *
If lNoaberto
	cTransp := SA1->A1_TRANSP
	_cPlaca := DOCA->PLACA
	_cUFP   := DOCA->UFP
Endif

cCliente:= SA1->A1_COD  //RB
lRemessa:= ! Empty(SC5->C5_CLIR+SC5->C5_LOJAR)

IF !EMPTY(SC5->C5_TABELA)

	//Alberto - 18/02/2009                                               *
	// Inibida a verificacao do campo SA1->A1_A_TABP pois o criterio para *
	//atualizacao do preco, passou a ser se existe a tabela  de preco    *
	//preenchida no pedido de venda.                                     *
	_cHrTabPrc := Transform(Time(),"99:99:99")

	//ALterado por Marion em 27/01/09 - Projeto Aruma*
	_nHrTabPrc := Val(Left(_cHrTabPrc,2)) + _nFusoH

	DbSelectArea("DA0")
	DbSetOrder(1)
	IF DbSeek(xFilial("DA0")+SC5->C5_TABELA)
		DbSelectArea("SZR")
		DbSetOrder(1)
		DbSeek(xFilial("SZR") + DA0->DA0_CODTAB)
		If SZR->ZR_STATUS == 'B'
			VtBeep(3)
			VtAlert("Tabela de Preco esta BLOQUEADA pelo Depto.Comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		ElseIF DA0->DA0_DATATE = dDatabase .AND. _nHrTabPrc >= 6
			VtBeep(3)
			VtAlert("Tabela de Preco expirou as 5:59. Utilizar o pedido de vendas com a tabela de precos atual.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		ElseIF DA0->DA0_DATATE < dDatabase
			VtBeep(3)
			VtAlert("Tabela de Preco expirada. Utilizar o pedido de vendas com a tabela de precos atual.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		ElseIF DA0->DA0_DATDE > dDatabase
			VtBeep(3)
			VtAlert("Tabela de Preco expirada. Utilizar o pedido de vendas com a tabela de precos atual.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		ELSE
			IF ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(SC5->C5_TABELA)
				Reclock("SA1",.F.)
				SA1->A1_TABELA := SC5->C5_TABELA
				MsUnlock()
			ENDIF
			Return .t.
		ENDIF
	ELSE
		VtBeep(3)
		VtAlert("Tabela de Preco cadastrada para este pedido nao existe","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	ENDIF
ELSE
	IF SA1->A1_A_TABP = 'S'
		VtBeep(3)
		VtAlert("Cliente exige utilizacao de tabela de preco , porem nao foi informada no pedido digitado.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	ENDIF
ENDIF

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldQTEP  ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao da Quantidade informada - Utilizado pelo         ³±±
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
Static Function VldQTEP(nQtdep)

Local cBlqCred:= ""
Local nQtdtot := 0
Local nItem   := 0

/*If Empty(nQtdep)
	return .f.
EndIf

//Alberto - 15/07/09 - Projeto PV Automatico     *
If !Empty(DOCA->PRODUTO)
	
	SB5->(dbSetOrder(1))
	SB5->(DbSeek(xFilial("SB5")+DOCA->PRODUTO))
	nQtdtot := nQtdep*SB5->B5_QPA
	DA1->(dbSetOrder(1))
	DA1->(DbSeek(xFilial("DA1")+_cCodtab+DOCA->PRODUTO))

	nValor   := nQtdtot*DA1->DA1_PRCVEN
	*/ // Alex Borges - 01/09/2016 - Chamado 350242
If Empty(nQtdep)
	return .f.
Else
	nValor := ValorDoca()
	_nMoeda  :=1

	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4") + _cTes) //Alberto - 15/07/09 - Projeto PV Automatico

	//Felipe - 07/12/2011 - Valida se a TES atualiza estoque
	If !Empty(_cTes) .AND. SF4->F4_ESTOQUE <> "S"
		VtBeep(3)
		VtAlert("O TES " + _cTes + " cadastrado na tabela de preços não atualiza estoque. Entrar em contato com depto comercial.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	EndIf

	If GetMV("MV_CRWCRED") # "S" .OR. SF4->F4_DUPLIC # "S"
		lCredOK := .t.
	Else
		lCredOK := MaAvalCred(cCliente,_cLOja,nValor,_nMoeda,.T.,@cBlqCred)
	Endif

	If ! lCredOK
		If cBlqCred == "04"
			VtAlert("Cliente com limite de credito vencido, Pallets nao podem ser embarcados","Aviso",.t.,4000)
		Else
			VtAlert("Pallets excedem o limite de credito do cliente, Pallets nao podem ser embarcados","Aviso",.t.,4000)
		Endif
		nValor:= 0
		VtKeyboard(Chr(20))
		Return .f.
	Endif

Endif

dbSelectArea("DOCA")
If DOCA->(DbSeek('NOVO'))
	RecLock("DOCA",.F.)
	DOCA->QTDEP  := nQTDEP
	DOCA->PLACA  := _cPlaca
	DOCA->UFP    := _cUFP
	MsUnLock()
EndIf

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldEti   ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao das Etiquetas - Utilizado pelo programa principal³±±
±±³          ³ CRC010                                                     ³±±
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
Static Function VldEti(cEtiqueta)

Local _aAreaAtu := {}
Local _aAreaSB1 := {}
Local nSalPed:=0
Local nQtdpro:=0
Local _nQtdCam:=0
Local _cxProd := ""
Local _cMatEmb := ""  //31/05/11 - Projeto controle mat.embalagem
Local _cVldSEnd := GetNewPar("CE_VLDSEND","N")
Local _cBloq := ""
Local _lAchouEmi := .F.

VtClearBuffer()

If len(Alltrim(cEtiqueta)) # 6 .and. len(Alltrim(cEtiqueta)) # 17
	VTBeep(3)
	VtAlert("Conteudo invalido","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

dbSelectArea("DOCA")
nQtde := 0
dbeval({|| nQtde++},{|| IDETIQ <> "NOVO"} )
If nQtde >= nQtdeP
	VtBeep(3)
	VtAlert("Embarque finalizado por outro usuario, confirme a geracao da nota","Aviso",.t.,6000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

IF DOCA->(DbSeek(cEtiqueta)) .or. DOCAETI->(DbSeek(cEtiqueta))
	VtBeep(3)
	VtAlert("Pallet ja lido.","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIF

aRet := CBRetEti(cEtiqueta,"01")

//Ajuste para etiquetas antigas
If Empty(aRet)
	aRet := AjustEti(cEtiqueta)
EndIf

If Empty(aRet)
	VtBeep(3)
	VtAlert("Etiqueta Invalida.","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

If ! Empty(aRet[13])
	VtBeep(3)
	VtAlert("Pallet pertence a nota "+aRet[13],"Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

If Empty(aRet[09])   // localizacao
	VtBeep(3)
	VtAlert("Pallet nao distribuido, localizacao em branco","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

If Empty(aRet[10])  //  almox
	VtBeep(3)
	VtAlert("Pallet nao distribuido, almoxarifado em branco","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

If aRet[10] == GetNewPar("MV_ALMOHFI","98") .or. aRet[10] == GetNewPar("MV_ALMOSUC","40")
	VtBeep(3)
	VtAlert("Pallet pertence ao HFI, retrabalho ou sucata","Aviso",.t.,4000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

// Alex Borges - 10/06/2015 - Chamado 324218
//lLibFrac := GetNewPar("CE_LIBFRAC",".F.")// Parametro que permite pallet fracionado no almoxarifado 01. 

//Alex Borges - 10/08/15 - Chamado 328540
If (Alltrim(GetAdvFVal("SB1","B1_A_LFRAC",XFILIAL("SB1")+CB0->CB0_CODPRO,1,"")) = 'S')
	lLibFrac := .T.	
Else
	lLibFrac := .F.	
End

If !lLibFrac
	
	If aRet[10] = GetNewPar("CE_ALMOFRA","80")
		VtBeep(3)
		//VtAlert("Este Pallet se encontra no almoxarifado "+Alltrim(aRet[10])+". Favor entrar em contato com a Qualidade!","Aviso",.t.,4000) //Alex Borges - 10/08/15 - Chamado 328540
		VtAlert("Para embarcar pallet fracionado precisa da liberação no cadastro de produto pelo departamento comercial!","Aviso",.t.,4000)
		VtKeyboard(Chr(20))
		Return .F.
	EndIf
	
	// Busca a quantidade de latas do produto e do pallet
	nQtdProd := Posicione("SB5",1,xFilial("SB5")+CB0->CB0_CODPRO,"B5_QPA")
	nQtdPall := CB0->CB0_QTDE
				
	If nQtdProd <> nQtdPall
		VtBeep(3)
		VtAlert("Nao é possivel embarcar pallet fracionado!")
		VtKeyboard(Chr(20))
		Return .F.
	EndIf
Else
	If aRet[10] = GetNewPar("CE_ALMOFRA","80")
		VtBeep(3)
		VtAlert("Para embarcar pallet fracionado precisa transferir para o almoxarifado 01!","Aviso",.t.,4000)
		VtKeyboard(Chr(20))
		Return .F.
	EndIf	
EndIf
	
//Felipe - 01/08/14 - Valida se o produto nao esta bloqueado
_aAreaAtu := GetArea()
_aAreaSB1 := SB1->(GetArea())
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek( xFilial("SB1") + CB0->CB0_CODPRO ) 
_cBloq := SB1->B1_MSBLQL //Posicione("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO, "B1_MSBLQL")
If _cBloq == "1"
	VtBeep(3)
	VtAlert("Produto bloqueado para movimentação! Entrar em contato com o depto de logistica.","Aviso",.t.,6000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf
RestArea(_aAreaSB1)
RestArea(_aAreaAtu)

//Tratamento de ruas bloqueadas
SBE->(DbSetOrder(9))
SBE->(DbSeek(xFilial("SBE")+CB0->CB0_LOCALI))
If !Empty(SBE->BE_DTINV)
	VtBeep(3)
	VtAlert("A rua do Pallet lido esta bloqueada. Nao pode ser embarcado.","Aviso",.t.,4000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

//Tratamento de saldo da rua do pallet lido - 22/07/11
If UPPER(_cVldSEnd) == "S"
	SBF->( dbSetOrder(1) )
	If SBF->( dbSeek(xFilial("SBF") + CB0->CB0_LOCAL + CB0->CB0_LOCALI + CB0->CB0_CODPRO ) )
		_nPosEtiq := aScan(_aVldEtiqs, { |x| x[1] + x[2] + x[3] == CB0->CB0_LOCAL + CB0->CB0_LOCALI + CB0->CB0_CODPRO })
		If _nPosEtiq <= 0
			If SBF->BF_QUANT >= CB0->CB0_QTDE //SBF->BF_EMPENHO
				AAdd( _aVldEtiqs, {CB0->CB0_LOCAL, CB0->CB0_LOCALI, CB0->CB0_CODPRO, CB0->CB0_QTDE })
			Else
				VtBeep(3)
				VtAlert("Não existe saldo na rua do Pallet lido. Etiqueta não pode ser embarcada.","Aviso1",.t.,4000)
				VtKeyboard(Chr(20))
				Return .F.
			EndIf
		Else
			If SBF->BF_QUANT >= _aVldEtiqs[_nPosEtiq,4] + CB0->CB0_QTDE
				_aVldEtiqs[_nPosEtiq,4] := _aVldEtiqs[_nPosEtiq,4] + CB0->CB0_QTDE
			Else
				VtBeep(3)
				VtAlert("Não existe saldo na rua do Pallet lido. Etiqueta não pode ser embarcada.","Aviso2",.t.,4000)
				VtKeyboard(Chr(20))
				Return .F.		
			EndIf
		EndIf
	Else
		VtBeep(3)
		VtAlert("Não existe saldo na rua do Pallet lido. Etiqueta não pode ser embarcada.","Aviso3",.t.,4000)
		VtKeyboard(Chr(20))
		Return .F.
	EndIf
EndIf

//Alberto - 19/03/10- Projeto lata automatica    *
If nQtde =0                           
   _cxProd := CB0->CB0_CODPRO
   IF !VldCliente(cCliente,_cLoja,_cxProd) // Alex Borges 11/06/2014 - CHAMADO 298562
		VtBeep(3)
		VtKeyboard(Chr(20))
		Return .F.
   EndIf
Endif

If _cFlagME = "S"  //Alberto - 13/06/11 - Projeto controle Mat.Embalagem
	_cMatEmb:= CB0->CB0_A_TPEM  //Alberto - 31/05/11- Projeto controle mat.embalagem
	
	If empty(CB0->CB0_A_TPEM)
	    //Pega informacao do material de embalagem do pallte
	    _cMatEmb :=U_MatEmb(cEtiqueta)
	Endif
	
	// Alex Borges - 26/06/2015 - Chamado 325613
	If lPrimeira // Flag controladora da primeira etiqueta lida
		// Alex Borges - 26/01/16 - Chamado: 338492
		//De todas as etiquetas embarcadas sempre pesquisará a primeira etiqueta o código de embalagem
		DbSelectArea("DOCA")
		IF ! DOCA->(DbSeek('NOVO')) .OR. !Empty(DOCA->PEDIDO)
			DOCA->(DBGOTOP())
			dbeval({|| nQtde++},{|| IDETIQ <> "NOVO"} )
			
			If nQtde <= 0
				Return(nValor)
			Endif
		
			DOCA->(DBGOTOP())
			While ! DOCA->(Eof()) .and. DOCA->PEDIDO==cPedido
		    	_cPrimEmb := DOCA->MATEMB
			DOCA->(DbSkip())
			Enddo 
		EndIf
		If Empty(_cPrimEmb)
			_cPrimEmb := _cMatEmb //Atualiza a primeira embalagem
		EndIf
		
		//_cPrimEmb := _cMatEmb //Atualiza a primeira embalagem // Alex Borges - 26/01/16 - Chamado: 338492
		lPrimeira := .F.
	EndIf
	
	If _cPrimEmb <> _cMatEmb //Para cada etiqueta digitada verifica se a embalagem e diferente das demais.
		VtBeep(3)
		VtAlert("O Mat. embalagem difere das demais etiquetas.","Aviso",.t.,6000)
		VtKeyboard(Chr(20))
		Return .F.	
	EndIf
Endif

// Verificar se o produto exite na tabela de preco do cliente
DA1->(Dbsetorder(1))
If ! DA1->(dbSeek(xFilial("DA1")+_cCodTab+CB0->CB0_CODPRO))
	VtBeep(3)
	VtAlert("Produto do pallet nao pertence a tabela de preco do cliente, nao podera ser embarcado.Entrar em contato com depto comercial.","Aviso",.t.,4000)
	VtKeyboard(Chr(20))
	Return .F.
Endif 

//Verifica se o produto do pallet e diferente dos demais pallets ja embarcados
nQtdPro :=0
DOCA->(dbeval({|| nQtdPro+=DOCA->QTDE},{|| DOCA->PRODUTO <> aRet[1] .and. DOCA->IDETIQ <> "NOVO" }))
If nQtdpro > 0
	VtBeep(3)
	VtAlert("O produto deste pallet e diferente dos demais pallets ja embarcados.","Aviso",.t.,4000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

//Alberto - 11/05/11 - Projeto SPED PIS/COFINS
_cGrupo   := Posicione("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO, "B1_GRUPO")
_cPauta   := Posicione("SBM",1,xFilial("SBM")+_cGrupo, "BM_A_PCPTA")

If _cPauta == 'S'
	If _cTESPauta = ' '
		VtBeep(3)
		VtAlert("Campo TES Pauta nao esta preenchido na tabela de preco do cliente. Nao podera ser embarcado.Entrar em contato com depto comercial.","Aviso",.t.,4000)
		VtKeyboard(Chr(20))
		Return .F.
	Else
		_cTES := _cTESPauta
	Endif

//Felipe Geraldo - 25/04/12 - Tratamento para PIS/COFINS Isento
ElseIf _cPauta == 'I'
	If _cTESIsen = ' '
		VtBeep(3)
		VtAlert("Campo TES Isento nao esta preenchido na tabela de preco do cliente. Nao podera ser embarcado.Entrar em contato com depto comercial.","Aviso",.t.,4000)
		VtKeyboard(Chr(20))
		Return .F.
	Else
		_cTES := _cTESIsen
	Endif

Else
	If _cTESAliq = ' '
		VtBeep(3)
		VtAlert("Campo TES Aliquota nao esta preenchido na tabela de preco do cliente. Nao podera ser embarcado.Entrar em contato com depto comercial.","Aviso",.t.,4000)
		VtKeyboard(Chr(20))
		Return .F.
    Else
		_cTES := _cTESAliq
    Endif
Endif

IF cTransp $ Getmv("CE_A_TRFOB") // Luiz Cesar CH 356204 Tratamento para identificar transportadoras obrigatoriamente FOB
   
    PBS->(dbSetOrder(1))
    PBS->(dbSeek(xFilial("PBS") + _cCodTab + _cGrupo ))

    If PBS->(!Found())                 
         VtBeep(3)
	     VtAlert("Grupo de itens da tabela de preco nao cadastrado. Entrar em contato com depto comercial.","Aviso",.t.,3000)
	     VtKeyboard(Chr(20))
	     DbCloseArea()
	     Return .F.
    Else
	     _cTpFre   := "F"  //Tipo do frete C=CIF F=FOB
	     _cCodGrp  := PBS->PBS_A_CODG //Codigo do grupo de produtos
	     _nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
	     _nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
	     _nFretPBS := 0 //Excecao nao considera Valor do frete na tabela PBS (grupo de produtos)
    Endif

Else

    //Felipe - 26/08/2011 - Busca o tipo do frete na tabela PBS e nao mais na SZR
    PBS->(dbSetOrder(1))
    PBS->(dbSeek(xFilial("PBS") + _cCodTab + _cGrupo ))

    If PBS->(!Found()) .OR. Empty(PBS->PBS_A_TPFR)
                
         VtBeep(3)
	     VtAlert("Tipo de frete nao esta cadastrado corretamente na tabela de preco.Entrar em contato com depto comercial.","Aviso",.t.,3000)
	     VtKeyboard(Chr(20))
	     DbCloseArea()
	     Return .F.
    Else
	     _cTpFre   := PBS->PBS_A_TPFR //Tipo do frete C=CIF F=FOB
	     _cCodGrp  := PBS->PBS_A_CODG //Codigo do grupo de produtos
	     _nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
	     _nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
	     _nFretPBS := PBS->PBS_A_VLFR //Felipe - 15/04/15 - Valor do frete na tabela PBS (grupo de produtos)
    Endif

Endif

//Alberto - 02/10/14- Projeto GFE - Validacao transportadora
If _lIntGFE
	
	_lAchouEmi := .F.
	If _cTpFre == "C" .AND. !_lExporta //Felipe - 05/02/15 - Valida emitente somente para CIF e dentro do Brasil
	
		GU3->(dbOrderNickName("CODTRPERP"))
		If GU3->(!dbSeek( xFilial("GU3") + cTransp ))
			VtBeep(3)
			VtAlert("Transportadora nao cadastrada no cadastro de emitentes do GFE. Entre em contato com o depto Logistica","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		Else
			While GU3->(!Eof()) .AND. GU3->GU3_CDTERP = cTransp
				If GU3->GU3_TRANSP = '1'
					_lAchouEmi := .T.
					Exit
				Endif
				GU3->(DbSkip())
			End
		EndIf
	
		If !_lAchouEmi
			VtBeep(3)
			VtAlert("Transportadora nao cadastrada no cadastro de emitentes do GFE. Entre em contato com o depto Logistica","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		Endif
	
	EndIf
	
Endif

If Empty(dtNascimento)
	dtNascimento := CB0->CB0_DTNASC
Else
	If dtNascimento <> CB0->CB0_DTNASC
		VTBeep(4)
		dbselectarea("CB0")
		dbordernickname("CB0PROD")
		If Dbseek(xFilial("CB0")+ CB0->CB0_CODPRO + SPACE(6))
			If (cEtiqueta) <> (CB0->CB0_CODETI)
				If ! VTYesNo("Pallet fora da data. O pallet mais antigo e o "+CB0->CB0_CODETI+" de "+DTOC(CB0->CB0_DTNASC)+" e esta na rua "+CB0->CB0_LOCALI+" do estoque","Confirma o embarque desse pallet?",.t.)
					VtKeyboard(Chr(20))
					Return .F.
				EndIf
			EndIf
		Endif
	Endif
EndIf

DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4") + _cTes) //Alberto - 15/07/09 - Projeto PV Automatico

//Felipe - 07/12/2011 - Valida se a TES atualiza estoque
If SF4->F4_ESTOQUE <> "S"
	VtBeep(3)
	VtAlert("O TES " + _cTes + " cadastrado na tabela de preços não atualiza estoque. Entrar em contato com depto comercial.","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	DbCloseArea()
	Return .F.
EndIf

/*
//Luis Alberto - 28/08/13- Projeto A019/13- Operacao triangular automatica
If SF4->F4_A_OPTRI ='S'
   _lOpTri := .t.  

    //Felipe - 04/11/15 - Chamado 303631 - Posiciona e busca informacoes no cadastro auxiliar do cliente
	dbSelectArea("ZZG")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZG") + SA1->A1_COD + SA1->A1_LOJA )
		If Empty(ZZG->ZZG_A_CTRI) .OR. Empty(ZZG->ZZG_A_LJTR) .OR. Empty(ZZG->ZZG_A_TES4) .OR. Empty(ZZG->ZZG_A_TES5) .OR. Empty(ZZG->ZZG_A_TES6)
			VtBeep(3)
			VtAlert("Os campos do cliente para operacao triangular nao estao preenchidos no cadastro auxiliar de clientes. Entrar em contato com depto comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			DbCloseArea()
			Return .F.
		Endif
	Else
		VtBeep(3)
		VtAlert("Não foi localizado o cadastro auxiliar do cliente para operacao triangular. Entrar em contato com depto comercial.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		DbCloseArea()
		Return .F.			
	EndIf

	//Felipe - 18/09/2014 - Variaveis sao atualizadas pela tabela ZZG
	_cCliTri   := ZZG->ZZG_A_CTRI  //Cliente operacao triangular
	_cLjTri    := ZZG->ZZG_A_LJTR  //Loja operacao triangular
	_cTesAlTri := ZZG->ZZG_A_TES4  //Tes Aliquota operacao triangular
	_cTesPaTri := ZZG->ZZG_A_TES5  //Tes Pauta operacao triangular
	_cTesIsTri := ZZG->ZZG_A_TES6  //Tes Pis Cofins isento operacao triangular

	//Validar tabela de preco do cliente da operacao triangular
	_nRecSA1:=SA1->(recno())
	VldCliTri(_cCliTri,_cLjTri)   
    SA1->(DbGoTo(_nRecSA1))

	PBS->(dbSetOrder(1))
	PBS->(dbSeek(xFilial("PBS") + _cCodTabTri + _cGrupo ))
	If PBS->(!Found()) .OR. Empty(PBS->PBS_A_TPFR)
		VtBeep(3)
		VtAlert("Tipo de frete nao esta cadastrado corretamente na tabela de preco.Entrar em contato com depto comercial.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		DbCloseArea()
		Return .F.
	Else
		_cFreteTri := PBS->PBS_A_TPFR //Tipo do frete C=CIF F=FOB
		_cCodGrp  := PBS->PBS_A_CODG //Codigo do grupo de produtos
		_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
		_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
		_nFretPBS := PBS->PBS_A_VLFR //Felipe - 15/04/15 - Valor do frete na tabela PBS (grupo de produtos)
	Endif

Endif */ //Alex Borges - 01/09/2016 - Chamado 350242

If GetMV("MV_CRWCRED") # "S" .OR. SF4->F4_DUPLIC # "S"
	lCredOK:= .t.
Endif

If ! lCredOK
	If ! Credito(cEtiqueta)
		Return .F.
	Endif
Endif

//Felipe - 08/12/11 - Trata qtde de lata por camada para calcular quantidade de papel
_nQtdCam := Posicione("SBM",1,xFilial("SBM")+_cGrupo, "BM_A_QTDCA")
If _nQtdCam > 0
	_nQtdCam := Round(_nQtdCam/1000,3)
Else
	VtBeep(3)
	VtAlert("Quantidade de Lata por Camada não informado no cadastro de Grupos do Produto " + _cGrupo + ". Entrar em contato com depto comercial.","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	DbCloseArea()
	Return .F.
EndIf

//Alex Borges  - 10/06/14 - CHAMADO 298562
// Verificar se a tabela de preço esta ativa
DbSelectArea("SZR")
SZR->(Dbsetorder(1))
If SZR->(dbSeek(xFilial("SZR")+_cCodTab))
	If SZR->ZR_STATUS == 'B'
		VtBeep(3)
		VtAlert("Tabela de Preco esta BLOQUEADA pelo Depto.Comercial.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	EndIf
Endif

IF !DOCA->(DbSeek('NOVO'))
	RecLock("DOCA",.T.)
	DOCA->CLIENTE:= cCliente //Alberto - 15/07/09 - Projeto PV Automatico
	DOCA->LOJA   := _cLoja   //Alberto - 15/07/09 - Projeto PV Automatico
	DOCA->PEDIDO := cPedido
	DOCA->TRANSP := cTransp
	DOCA->QTDEP  := nQTDEP
	DOCA->PLACA  := _cPlaca
	DOCA->UFP    := _cUFP
Else
	RecLock("DOCA",.F.)
	DOCA->CLIENTE:= cCliente
	DOCA->LOJA   := _cLoja
EndIf

DOCA->IDETIQ := cEtiqueta
DOCA->PRODUTO:= aRet[1]
DOCA->QTDE   := aRet[2]
DOCA->LOCALIZ:= aRet[9]
DOCA->ALMOX  := aRet[10]

//Felipe - 08/12/11 - Trata qtde de lata por camada para calcular quantidade de papel
DOCA->QTDPAPEL:= Int(aRet[2] / _nQtdCam) + 1
DOCA->PLACA  := _cPlaca
DOCA->UFP    := _cUFP
DOCA->TES    := _cTES //Alberto -11/05/11- Projeto SPED PIS/COFINS
DOCA->MATEMB := _cMatEmb    //Alberto - 31/05/11 - Projeto controle mat. embalagem
DOCA->USUARIO:= Alltrim(cUserName)
nQtde++
DOCA->SEQEMB := nQtde //Felipe - 01/12/14 - Grava na doca a sequencia da ordemd e embarque da etiqueta
DOCA->(MsUnLock())

//Alberto -29/07/09- Ajuste posicionamento campos *
@ 07,00 VtSay " Embarcadas...: "+strzero(nQtde,2)

nQtdPro :=0
dbeval({|| nQtdPro+=DOCA->QTDE},{|| DOCA->PRODUTO == aRet[1]} )

nQtdPapel :=0
dbeval({|| nQtdPapel+=DOCA->QTDPAPEL})

AtuCab(nDoca,cPedido,aRet[1],nQtdPro)

RecLock('DOCAETI',.T.)
DOCAETI->ETIQUETA :=cEtiqueta
DOCAETI->DOCA :=nDoca  //Alberto 31/05/11- Projeto controle material de embalagem
DOCAETI->(MsUnlock())

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Libera   ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Liberacao dos pedidos para preparacao da nota. Utilizado   ³±±
±±³          ³ pelo programa principal CRC010                             ³±±
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
Static Function Libera()

Local aProduto:={}
Local aEmp:={}
Local nX
Local cNumPed
Local cAlmox

Doca->(DbGotop())
cNumPed := Doca->PEDIDO
cAlmox  := Doca->ALMOX

If !_lOpTri
	aPvlNfs  :={}
EndIf

If lRemessa
	aPvlNfsR  :={}
EndIf

// Libera quantidade embarcada
SC5->(dbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+cNumPed))
aProduto := aClone(ProdDoca())
For nX:=1 to Len(aProduto)
	aEmp     := aClone(CarregaEmpenho(aProduto[nx,1]))
	LibPed(cNumPed,aProduto[nx,1],aEmp[1],aEmp[2])
	aadd(aPvlNfs,Prepara(cNumped,aProduto[nx,1],cAlmox))
Next

//Libera pedido de embalagens e remessa quando for o caso
SC5->(dbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+cPedidoE))
For nX:=1 to Len(aRemessa)
	aEmp:= aClone(CarregaEmpenho(aRemessa[nx,1]))
	LibPed(cPedidoE,aRemessa[nx,1],aEmp[1],aEmp[2])
	aadd(aPvlNfsR,Prepara(cPedidoE,aRemessa[nx,1],cAlmox))
Next

For nX := 1 To Len(aEmbPro)
	LibPed(cPedidoE,aEmbPro[nx,1],aEmbPro[nx,2],{})
	If !lRemessa
		aadd(aPvlNfs,Prepara(cPedidoE,aEmbPro[nx,1],"01"))
	Else
		aadd(aPvlNfsR,Prepara(cPedidoE,aEmbPro[nx,1],"01"))
	EndIF
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ ProdDoca ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Retorna os produtos que foram embarcados na Doca. Utilizado³±±
±±³          ³ pelo programa principal CRC010                             ³±±
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
Static function ProdDoca()

Local aProduto:={}
Local aQtd:={}
Local nPos:=0

Doca->(DBGoTop())
While ! Doca->(Eof())
	nPos:= ascan(aProduto,{|x| x[1]==Doca->PRODUTO})
	If  nPos==0
		AADD(aProduto,{Doca->PRODUTO,Doca->QTDE})
	Else
		aProduto[nPos,2]+=Doca->QTDE
	EndIf
	Doca->(DbSkip())
End

Return aProduto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ CarregaEmpenho ³ Autor ³ Sandro          ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Carrega empenho dos itens do pedido. Funcao utilizada	  ³±±
±±³          ³ pelo programa principal CRC010                             ³±±
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
Static Function CarregaEmpenho(cProduto)

Local aEmp:={}
Local nPos:= 0
Local nTQtde:=0

Doca->(dbGotop())
While ! Doca->(Eof())
	If Doca->Produto == cProduto
		nPos :=ascan(aEmp,{|x| x[3] == DOCA->LOCALIZ})
		If  nPos ==0
			aadd(aEmp,{"","",Doca->LOCALIZ,"",Doca->QTDE,0,ctod(""),"","","",DOCA->ALMOX,CRIAVAR("C9_POTENCI")})
		Else
			aEmp[nPos,5] +=Doca->QTDE
		EndIF
		nTQtde +=Doca->QTDE
	Endif
	Doca->(DbSkip())
End

Return {nTQtde,aEmp}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ LibPed ³ Autor ³ Sandro                  ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Liberacao do pedido. Utilizado pelo programa CRC010  	  ³±±
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
Static Function LibPed(cNumPed,cProd,nQtde,aEmp)

SC6->(DBSetOrder(2))
SC6->(DbSeek(xFilial("SC6")+cProd+cNumPed))
SC6->(DBSetOrder(1))
//Alex Borges Chamado 350242 - 19/09/2016
/*MaLibDoFat(SC6->(Recno()),;
		nQTDE,;
		.T.,;
		.T.,;
		.F.,;
		.F.,;
		.F.,;
		.F.,;
		NIL,;
		NIL,;
		aEmp)*/

If _lOpTri

	aAreaSF4 := SF4->(GetArea())      
	lEstoque := .F.
	
	dbSelectArea("SF4")
	//Verifica a TES do Produto Acabado
	If dbSeek(xFilial("SF4")+SC6->C6_TES)
		If SF4->F4_ESTOQUE = 'S' 
			lEstoque := .T.	
		EndIf
	EndIf
	RestArea(aAreaSF4)
	
	If lEstoque  // Alex Borges - 19/09/2016 - Chamado 350242
		MaLibDoFat(SC6->(Recno()),nQTDE,.T.,.T.,.F.,.F.,.F.,.F.,NIL,NIL,aEmp)
	Else
		MaLibDoFat(SC6->(Recno()),nQTDE,.T.,.T.,.F.,.F.,.F.,.F.,NIL,NIL,{})		
	EndIf
Else
	MaLibDoFat(SC6->(Recno()),nQTDE,.T.,.T.,.F.,.F.,.F.,.F.,NIL,NIL,aEmp)
EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Prepara ³ Autor ³ Sandro                 ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Preparacao de Nota. Utilizado pelo programa CRC010   	  ³±±
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
Static Function Prepara(cNumped,cProd,cLocal)

//posiciona cabecalho
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+cNumPed) )                         //FILIAL+NUMERO
//posiciona item
SC6->(DBSetOrder(2))
SC6->(DbSeek(xFilial("SC6")+cProd+cNumPed))
SC6->(DBSetOrder(1))
//posiciona itens liberados
SC9->(DbSetOrder(1))
SC9->(DbSeek(xFilial("SC9")+cNumPed+SC6->C6_ITEM) )                    //FILIAL+NUMERO+ITEM

While ! SC9->(Eof()) .and.  SC9->C9_FILIAL==xFilial("SC9") .and.;
	SC9->C9_PEDIDO==cNumPed .and. SC9->C9_ITEM == SC6->C6_ITEM
	If Empty(SC9->C9_NFISCAL)
		EXIT
	EndIf
	SC9->(DbSkip())
EndDo

SE4->(DbSetOrder(1))
SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+cProd ))               //FILIAL+PRODUTO
SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB2")+cProd+cLocal) )          //FILIAL+PRODUTO+LOCAL
SF4->(DbSetOrder(1))
SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )                            //FILIAL+CODIGO

Return { SC9->C9_PEDIDO,;
SC9->C9_ITEM,;
SC9->C9_SEQUEN,;
SC9->C9_QTDLIB,;
SC9->C9_PRCVEN,;
SC9->C9_PRODUTO,;
(SF4->F4_ISS=="S"),;
SC9->(RecNo()),;
SC5->(RecNo()),;
SC6->(RecNo()),;
SE4->(RecNo()),;
SB1->(RecNo()),;
SB2->(RecNo()),;
SF4->(RecNo())}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ AtuCB0 ³ Autor ³ Sandro                  ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Atualiza Registro de Etiquetas. Utilizado pelo CRC010	  ³±±
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
Static Function AtuCB0(cNota,cSerie)

Local aProduto:={}

Doca->(DBGoTop())
While ! Doca->(Eof())
	aProduto := CBRetEti(DOCA->IDETIQ,"01")
	RecLock("CB0",.F.)
	CB0->CB0_NFSAI  := cNota
	CB0->CB0_SERIES := cSerie
	CB0->CB0_A_SEMB := DOCA->SEQEMB //Felipe - 01/12/14 - Grava a ordem da sequencia de embarque
	CB0->(MsUnLock()) 
	
	// Eduardo Souza 30/11/2017 - #369903
	u_ALUFATC8( "S" , CB0->CB0_CODPRO , CB0->CB0_NFSAI , CB0->CB0_LOCALI , CB0->CB0_QTDE )
	
	Doca->(DbSkip())
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Imprime ³ Autor ³ Sandro                 ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Possibilita a impressao ou nao da NF                       ³±±
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
Static Function Imprime(cNota)

VTBeep(3)

If VTYesNo("Deseja imprimir a nota "+cNota+" agora?","Aviso",.t.)
	U_NOTAACD(cNota+cSerSai)
EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ ValidSXB ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao de Consulta no SXB. Utilizada pelo prg. CRC010   ³±±
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
Static Function ValidSXB()

Local aArea := GetArea()
Local cCod:= "P03"

IF  SXB->(DbSeek(cCod))
	Return .t.
EndIf

aCampos :={	{cCod,"1","01","DB"	,"Pedido"	,"SC5"},;
{cCod,"2","01","01"	,"Codigo"	,""},;
{cCod,"4","01","01"	,"Codigo"	,"C5_NUM"},;
{cCod,"4","01","02"	,"Cliente"	,"C5_CLIENTE"},;
{cCod,"4","01","03"	,"Loja"		,"C5_LOJACLI"},;
{cCod,"5","01",""	,""			,"SC5->C5_NUM"},;
{cCod,"6","01","01"	,""			,"(Empty(SC5->C5_LIBEROK).And. Empty(SC5->C5_NOTA))"}}

dbSelectArea("SXB")
For nX:= 1 to len(aCampos)
	RecLock("SXB",.t.)
	SXB->XB_ALIAS := aCampos[nx,1]
	SXB->XB_TIPO  := aCampos[nx,2]
	SXB->XB_SEQ   := aCampos[nx,3]
	SXB->XB_COLUNA:= aCampos[nx,4]
	SXB->XB_DESCRI:= aCampos[nx,5]
	SXB->XB_CONTEM:= aCampos[nx,6]
	MSUNLOCK()
Next

RestArea(aArea)

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ InfoTec ³ Autor ³ Sandro                 ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao de Teclas de Atalho utilizada pelo prg. CRC010      ³±±
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
Static Function InfoTec()

VtAlert(	"Teclas CTRL:"+CHR(13)+CHR(10)+;
"A - Ajuda"+CHR(13)+CHR(10)+;
"I - Embarcados"+CHR(13)+CHR(10)+;
"P - Parametros"+CHR(13)+CHR(10)+;
"X - Estorna","Ajuda",.f.)

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
Static Function InfoEmbarque()

Local nX :=0
Local aSize:={}
Local aCab :={}
Local aTela
Local aArea := GetArea("DOCA")

aTela := VTSave()
VTClear()
aFields := {"IDETIQ","PRODUTO","QTDE","LOCALIZ"}
aSize   := {10,20,15,15}
aHeader := {"ID.Eti","Produto","Qtde","Endereco"}
doca->(dbgotop())
nRecno := VTDBBrowse(0,0,7,19,"DOCA",aHeader,aFields,aSize)
vtRestore(,,,,aTela)

RestArea(aArea)

Return

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
Static Function Estorna()

Local _nSeqEmb := 0
Local nX :=0
Local aTela
Local aArea := GetArea("DOCA")
Local cEtiqueta
Local nQtdpro:=0
Local cPed,cProd
Local lRev

aTela := VTSave()
VTClear()
cEtiqueta := Space(20)

@ 00,00 VtSay Padc("Estorno de Pallet",VTMaxCol())
@ 03,00 VtSay "Etiqueta:"
@ 04,00 VtGet cEtiqueta pict "@!" valid ! Empty(cEtiqueta)
VtRead

If VtLastkey() # 27
	If VTYesNo("Confirma o estorno deste Pallet?","Atencao",.t.)
		If Doca->(Dbseek(cEtiqueta))
			aRet := CBRetEti(cEtiqueta,"01")
			cPed :=DOCA->PEDIDO
			cProd:=DOCA->PRODUTO
			_nSeqEmb := DOCA->SEQEMB //Felipe - 01/12/14 - Salva a sequencia da etiqueta estornada
			RecLock("DOCA",.F.)
			DOCA->(DbDelete())
			MsUnLock()
			AJUSEQ(_nSeqEmb) //Felipe - 01/12/14 - Funcao que reajusta a sequencia de embarque das etiquetas ja lidas
			nQtde := 0
			dbeval({|| nQtde++},{|| IDETIQ <> "NOVO"} )
			nQtdPro :=0
			dbeval({|| nQtdPro+=DOCA->QTDE},{|| DOCA->PRODUTO == aRet[1]} )
			AtuCab(nDoca,cPed,cProd,nQtdPro)
			DOCAETI->(DbSeek(cEtiqueta))
			RecLock("DOCAETI",.F.)
			DOCAETI->(DbDelete())
			MsUnLock()
			If SC6->(DbSeek(xFilial("SC6")+aRet[1]+cPedido))
				nValor:= nValor - (aRet[2]*SC6->C6_PRCVEN)
			Endif
		Else
			VTBeep(3)
			VtAlert('Pallet nao encontrado','Atencao',.t.,3000)
		EndIF
	Endif
EndIf

vtRestore(,,,,aTela)
RestArea(aArea)

//Alberto -29/07/09- Ajuste posicionamento campos *
@ 07,00 VtSay " Embarcadas...: "+strzero(nQtde,2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ AtuCab ³ Autor ³ Sandro                  ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para controle de cabecalho das docas. Utilizado pelo³±±
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
Static function AtuCab(nDoca,cPedido,cProduto,nQtde)

Local aArea := GetArea()

DbSelectArea('CABDOCA')
//Alberto - 15/07/09 -Projeto PV Automatico *
If ! CABDOCA->(dbSeek(Strzero(nDoca,2)+cCliente+_cLoja+cPedido+cProduto))
	RecLock("CABDOCA",.T.)
Else
	RecLock("CABDOCA",.f.)
EndIf

CABDOCA->DOCA   := StrZero(nDoca,2)
CABDOCA->CLIENTE:= cCliente  //Alberto - 15/07/09 - projeto PV Automatico
CABDOCA->LOJA   := _cLoja    //Alberto - 15/07/09 - projeto PV Automatico
CABDOCA->PEDIDO := cPedido
CABDOCA->PRODUTO:= cProduto
CABDOCA->QTDE   := nQtde
MsUnLock()

RestArea(aArea)

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ LimpaCab ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para apagar o arquivo de cabecalho das docas.       ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
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
Static Function LimpaCab(nDoca)

Local aArea := GetArea()

DbSelectArea('CABDOCA')
While CABDOCA->(dbSeek(Strzero(nDoca,2)))
	RecLock("CABDOCA",.f.)
	CABDOCA->(DbDelete())
	MsUnLock()
End

CABDOCA->(DBCloseArea())
dbUseArea(.T.,cDrive,cArqM,'CABDOCA',.f.,.F.)

If ! neterr()
	dbSetIndex(FileNoExt(cIndM))
	Pack
	CABDOCA->(dbCloseArea())
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPedEmb ³ Autor ³ Sandro               ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de embalagem e verifica se o item do pedido    ³±±
±±³          ³ principal tambem entra na nota de remessa. Usado p/ CRC010 ³±±
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
Static Function GerPedEmb()

Local aCab   := {}
Local aItens := {}
Local nItem  := 0
Local nQtdVol := 0  // Ricardo Lima - 01/09/16

cPedidoE := RetNumPVE()
nQtdPapel :=0
dbeval({|| nQtdPapel+=DOCA->QTDPAPEL})
DOCA->(dbGoTop())

SC5->(dbSetOrder(1))
If _lOpTri // Alex Borges - 01/09/2016 - Chamado 350242
	SC5->(dbSeek(xFilial("SC5")+_cPedTri))
	If UPPER(SC5->C5_CRWTIPO) == "R"
		SC6->(dbSeek(xFilial("SC6")+_cPedTri))
	EndIf
Else	
	
	SC5->(dbSeek(xFilial("SC5")+cPedido))
	If UPPER(SC5->C5_CRWTIPO) == "R"
		SC6->(dbSeek(xFilial("SC6")+cPedido))
	EndIf
EndIf
/*If UPPER(SC5->C5_CRWTIPO) == "R"
	SC6->(dbSeek(xFilial("SC6")+cPedido))
EndIf*/

If lRemessa
	aadd(aCab,{"C5_NUM"       ,cPedidoE          ,nil})
	aadd(aCab,{"C5_TIPO"      ,'N'               ,nil})
	aadd(aCab,{"C5_CLIENTE"   ,SC5->C5_CLIR      ,nil})
	aadd(aCab,{"C5_LOJACLI"   ,SC5->C5_LOJAR     ,nil})
	aadd(aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
	aadd(aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
	aadd(aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
	aadd(aCab,{"C5_CONDPAG"   ,SC5->C5_CONDPAG   ,nil})
	aadd(aCab,{"C5_DEPOSIT"   ,SC5->C5_DEPOSIT   ,nil})
	//aadd(aCab,{"C5_TABELA"    ,SC5->C5_TABELA    ,nil})
	If _lOpTri // Alex Borges - 01/09/2016 - Chamado 350242
   		aadd(aCab,{"C5_TABELA"    ,SC5->C5_TABELA    ,nil})
 	EndIf
	aadd(aCab,{"C5_TPFRETE"   ,_cTpfre          ,nil})//Alberto - 02/10/14- Projeto GFE- Para o material de embalagem utilizar o mesmo tipo de frete da lata
	aadd(aCab,{"C5_TRANSP"    ,cTransp          ,nil})
Else
	aadd(aCab,{"C5_NUM"       ,cPedidoE           ,nil})
	aadd(aCab,{"C5_TIPO"      ,'N'               ,nil})
	aadd(aCab,{"C5_CLIENTE"   ,SC5->C5_CLIENTE   ,nil})
	aadd(aCab,{"C5_LOJACLI"   ,SC5->C5_LOJACLI   ,nil})
	aadd(aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
	aadd(aCab,{"C5_PEDCLIE"   ,"0"               ,nil})
	aadd(aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
	aadd(aCab,{"C5_DEPOSIT"   ,SC5->C5_DEPOSIT   ,nil})
	aadd(aCab,{"C5_CONDPAG"   ,SC5->C5_CONDPAG   ,nil})
	//aadd(aCab,{"C5_TABELA"    ,SC5->[    ,nil})
	If _lOpTri // Alex Borges - 01/09/2016 - Chamado 350242
   		aadd(aCab,{"C5_TABELA"    ,SC5->C5_TABELA    ,nil})
 	EndIf
	aadd(aCab,{"C5_TPFRETE"   ,_cTpfre               ,nil}) //Alberto - 02/10/14- Projeto GFE- Para o material de embalagem utilizar o mesmo tipo de frete da lata
	aadd(aCab,{"C5_TRANSP"    ,cTransp          ,nil})
Endif

Pergunte("EMBPRO",.f.)

//Gera os Itens do pedido se tiver nota de remessa
If lRemessa
	SC6->(DbSetorder(1))
	If ! SC6->(dbSeek(xFilial("SC6")+cPedido))
		ConOut("Pedido nao encontrado "+cPedido)
		ConOut("Linha 862")
	Endif
	
	While ! SC6->(Eof()) .and.  SC6->C6_FILIAL==xFilial("SC6") .and. SC6->C6_NUM==cPedido
		SB1->(dbSeek(xFilial("SB1")+PADR(SC6->C6_PRODUTO,15)))
		aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)  ,NIL},;
		{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
		{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
		{"C6_QTDVEN" ,SC6->C6_QTDVEN                   ,NIL},;
		{"C6_PRCVEN" ,SC6->C6_PRCVEN                   ,NIL},;
		{"C6_VALOR"  ,SC6->C6_VALOR    				 ,NIL},;
		{"C6_TES"    ,SC6->C6_TESR                     ,NIL},;
		{"C6_LOCAL"  ,"01"                             ,NIL},;
		{"C6_DESCRI" ,SB1->B1_DESC  				 ,NIL}})
		aadd(aRemessa,{PADR(SC6->C6_PRODUTO,15),SC6->C6_QTDVEN})
		SC6->(DbSkip())
	Enddo
EndIf

//Alberto - 31/05/11- Projeto controle material de embalagem
If _cFlagME = "S"  //Alberto - 13/06/11 - Projeto controle Mat.Embalagem
	For nX:=1 to Len(_aMatEmb)
	   If !empty(_aMatEmb[nx,1])

    	    //Pallet                          
			SB1->(dbSeek(xFilial("SB1")+_aMatEmb[nx,1]))
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,_aMatEmb[nx,2]    ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                     ,NIL},;
			{"C6_VALOR"  ,_aMatEmb[nx,2]*SB1->B1_PRV1,NIL},;
			{"C6_TES"    ,RetTes()                         ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
			aadd(aEmbPro,{_aMatEmb[nx,1],_aMatEmb[nx,2]})

			// Ricardo Lima - 01/09/16
			if _aMatEmb[nx,1] = '032093007' .OR. _aMatEmb[nx,1] = '032093004'            
			  nQtdVol := _aMatEmb[nx,2]
			endif
	   
	   Endif
	   
    Next
    
Else
		//PALLET DE MADEIRA
	If nQtde - nTotPla > 0
		If !empty(mv_par01)
			SB1->(dbSeek(xFilial("SB1")+PADR(MV_PAR01,15)))
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,nQtde - nTotPla    ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                     ,NIL},;
			{"C6_VALOR"  ,(nQtde - nTotPla)*SB1->B1_PRV1,NIL},;
			{"C6_TES"    ,RetTes()                         ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
			aadd(aEmbPro,{MV_PAR01,nQtde - nTotPla})
			// Ricardo Lima - 01/09/16
			nQtdVol := nQtde - nTotPla
		Endif
	EndIf

	//PALLET DE PLASTICO
	If !Empty(nTotPla)
		If !empty(mv_par02)
			SB1->(dbSeek(xFilial("SB1")+Padr(MV_PAR02,15)))
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,nTotPla                         ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                    ,NIL},;
			{"C6_VALOR"  ,SB1->B1_PRV1*nTotPla            ,NIL},;
			{"C6_TES"    ,RetTes()                        ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
			aadd(aEmbPro,{MV_PAR02,nTotPla})
			// Ricardo Lima - 01/09/16
			nQtdVol := nTotPla
		Endif
	EndIf

	//Alterado por Marion em 25/02/09 - Topo Plastico*
	//Topo Madeira
	If nQtde - _nTotTopPla > 0
		If !empty(mv_par03)
			SB1->(dbSeek(xFilial("SB1")+PADR(MV_PAR03,15)))
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)     ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                          ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                           ,NIL},;
			{"C6_QTDVEN" ,nQtde - _nTotTopPla	              ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                         ,NIL},;
			{"C6_VALOR"  ,(nQtde - _nTotTopPla)*SB1->B1_PRV1  ,NIL},;
			{"C6_TES"    ,RetTes()                             ,NIL},;
			{"C6_LOCAL"  ,"01"                                 ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
			aadd(aEmbPro,{MV_PAR03,nQtde - _nTotTopPla})
		Endif
	Endif

	//Topo Plastico
	If !Empty(_nTotTopPla)
		If !empty(mv_par05)
			SB1->(dbSeek(xFilial("SB1")+Padr(MV_PAR05,15)))
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
			{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
			{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
			{"C6_QTDVEN" ,_nTotTopPla                         ,NIL},;
			{"C6_PRCVEN" ,SB1->B1_PRV1                    ,NIL},;
			{"C6_VALOR"  ,SB1->B1_PRV1*_nTotTopPla            ,NIL},;
			{"C6_TES"    ,RetTes()                        ,NIL},;
			{"C6_LOCAL"  ,"01"                             ,NIL},;
			{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
			aadd(aEmbPro,{MV_PAR05,_nTotTopPla})
		Endif
	EndIf

	If !empty(mv_par04)
		//PAPELOES
		SB1->(dbSeek(xFilial("SB1")+PADR(MV_PAR04,15)))
		aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
		{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
		{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
		{"C6_QTDVEN" ,nQtdPapel                       ,NIL},;
		{"C6_PRCVEN" ,SB1->B1_PRV1                    ,NIL},;
		{"C6_VALOR"  ,SB1->B1_PRV1*nQtdPapel          ,NIL},;
		{"C6_TES"    ,RetTes()                        ,NIL},;
		{"C6_LOCAL"  ,"01"                             ,NIL},;
		{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
		aadd(aEmbPro,{MV_PAR04,nQtdPapel})
	Endif
	
Endif		

    // Rciardo Lima - 01/09/16
	aadd(aCab,{"C5_VOLUME1" , nQtdVol , nil })		

If len(aItens) > 0
	lMSHelpAuto := .T.
	msExecAuto({|x,y|Mata410(x,y)},aCab,aItens)
	lMSHelpAuto := .F.
	If lMSErroAuto
		VTBeep(3)
		VTAlert("Falha no empenho da embalagem, o processo sera abortado.","Aviso",.t.,6000)
		DisarmTransaction()
		BREAK
	Else
		//Alex Borges - 01/09/2016 - Chamado 350242
		If _lOpTri // Alex Borges - 01/09/2016 - Chamado 350242
			SC5->(dbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+cPedidoE))
			//Libera pedido de embalagens e remessa quando for o caso
			For nX:=1 to Len(aRemessa)
				aEmp:= aClone(CarregaEmpenho(aRemessa[nx,1]))
				LibPed(cPedidoE,aRemessa[nx,1],aEmp[1],aEmp[2])
				aadd(aPvlNfsR,Prepara(cPedidoE,aRemessa[nx,1],cAlmox))
			Next
			
			For nX := 1 To Len(aEmbPro)
				LibPed(cPedidoE,aEmbPro[nx,1],aEmbPro[nx,2],{})
				If !lRemessa
					aadd(aPvlNfs,Prepara(cPedidoE,aEmbPro[nx,1],"01"))
				Else
					aadd(aPvlNfsR,Prepara(cPedidoE,aEmbPro[nx,1],"01"))
				EndIF
			Next

	
		EndIf
	EndIf
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldPerg ³ Autor ³ Sandro                 ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para manutencao das perguntas necessarias para a    ³±±
±±³          ³ utilizacao do programa principal CRC010                    ³±±
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
Static Function VldPerg()

/*
Local aPergu := {}
Local cPerg  := "EMBPRO    "
Local nI     := 0
Local aArea  := GetArea()

dbSelectArea("SX1")
dbSetOrder(1)
If Alltrim(SM0->M0_CODIGO+SM0->M0_CODFIL) == "0101"
Aadd(aPergu,{cPerg,"01","Pallets para tampas ?","mv_ch01","C",15,0,0,"G","","mv_par01",''             ,''               ,"",""               ,"",""     ,""      ,""      ,""      ,""      ,"","","","","SB1"})
Elseif Alltrim(SM0->M0_CODIGO+SM0->M0_CODFIL) == "0102"
Aadd(aPergu,{cPerg,"01","Pallet madeira      ?","mv_ch01","C",15,0,0,"G","","mv_par01",''             ,''               ,"",""               ,"",""     ,""      ,""      ,""      ,""      ,"","","","","SB1"})
Aadd(aPergu,{cPerg,"02","Pallet plastico     ?","mv_ch02","C",15,0,0,"G","","MV_PAR02",''             ,""               ,"",''               ,"",""     ,''      ,''      ,''      ,""      ,"","","","","SB1"})
Aadd(aPergu,{cPerg,"03","Topo                ?","mv_ch03","C",15,0,0,"G","","mv_par03",''             ,""               ,"",''               ,"",""     ,''      ,''      ,''      ,""      ,"","","","","SB1"})
Aadd(aPergu,{cPerg,"04","Papelao             ?","mv_ch04","C",15,0,0,"G","","mv_par04",''             ," "              ,"",''               ,"",""     ,''      ,''      ,''      ,""      ,"","","","","SB1"})
Endif

For nI := 1 to Len(aPergu)
If !dbSeek(cPerg + aPergu[nI,2])
RecLock("SX1",.T.)
For nX:=1 to FCount()
FieldPut(nX,aPergu[nI,nX])
Next
MsUnlock()
Endif
Next

RestArea(aArea)
*/

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ RetNumPVE ³ Autor ³ Sandro               ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Gerar um Numero de Pedido de Venda a ser usado ³±±
±±³          ³ pelo programa principal CRC010                             ³±±
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
Static Function RetNumPVE()

Local aArea := GetArea()
Local cNumPV := GetSx8Num("SC5")

//Verifica se o numero do pedido existe
While SC5->(dbSeek(xFilial("SC5")+cNumPV))
	cNumPV := soma1(alltrim(cNumPV))
End

RestArea(aArea)

Return cNumPV

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ AjustEti ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Ajuste da Etiqueta a ser usado pelo programa   ³±±
±±³          ³ principal CRC010                                           ³±±
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
Static Function AjustEti(cEtiqueta)

Local aEtiqueta := {}
Local aDados    := {}
Local cD3Etiq   := ""
Local cProduto  := ""

cD3Etiq   := substr(cEtiqueta,1,6)

//Felipe Geraldo - 31/05/12 - Projeto Protheus 11 - Substituicao do SetOrder por Nickname
SD3->(dbOrderNickName("D3ETIQ"))
If SD3->(dbSeek(xFilial("SD3")+cD3Etiq)) .and. SD3->D3_ESTORNO #"S"
	aadd(aDados,SD3->D3_COD) 				//cod.produto
	aadd(aDados,SD3->D3_QUANT) 		//qtde
	aadd(aDados,__cUserId) 				//usuario
	aadd(aDados,NIL) 						//NF entrada
	aadd(aDados,NIL) 						//serie entrada
	aadd(aDados,NIL) 						//Fornecedor
	aadd(aDados,NIL) 						//loja
	aadd(aDados,NIL) 						//Pedido de Compra
	aadd(aDados,"9999") 	            //Localizacao
	aadd(aDados,"01") 		         //Almoxarifado
	aadd(aDados,SD3->D3_OP) 			//OP
	aadd(aDados,SD3->D3_NUMSEQ) 		//Num Seq
	aadd(aDados,NIL) 					   //NF Saida
	aadd(aDados,NIL)	               //Serie Saida
	aadd(aDados,cD3Etiq )	         //Etiqueta do Cliente
	CBGrvEti("01",aDados)
EndIf

Return CBRetEti(cEtiqueta,"01")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ RetTes   ³ Autor ³ Sandro                ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Retorno de TES a ser utilizado pelo programa   ³±±
±±³          ³ principal CRC010                                           ³±±
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
Static Function RetTes()

Local cTES := ''
Local aSave := SC6->(GetArea())
Local _cASC5    := SC5->(GetArea())
Local _cCliEmb := .f.

//Felipe - 21/03/13 - Ajuste do dbseek passando xFilial do SA1
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	_cCliEmb := IIf(SA1->A1_A_IMPE = "S",.T.,.F.)
Endif

SC5->(RestArea(_cASC5))

//Alberto - 08/04/11- Utilizar um TES diferente quando for remessa para operador logisitico
If !empty(SA1->A1_A_OPER) //Se for operador logistico(Projeto PIA)
	cTES := Alltrim(GETMV("CE_TESPIA"))
Elseif _cCliEmb
	cTES := Alltrim(GETMV("CE_TESEMB"))
Elseif UPPER(SC5->C5_CRWTIPO) == "V"
	cTES := SB1->B1_TS
Else
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+cPedido))
	cTES := SC6->C6_TES
	SC6->(RestArea(aSave))
EndIf

Return cTES

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ ApagaNota ³ Autor ³ Sandro               ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Exclusao de Nota Fiscal utiliz. pelo programa  ³±±
±±³          ³ principal CRC010                                           ³±±
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
Static Function ApagaNota(cNota,cSerie)

Local aRegSD2 := {}
Local aRegSE1 := {}
Local aRegSE2 := {}

lMSErroAuto := .f.

dbSelectArea("SD2")
SD2->(dbSetOrder(3))
IF SD2->(DbSeek(xFilial("SD2")+subs(cNota,1,9)+cSERIE))
	While SD2->D2_DOC = subs(cNota,1,9) .AND. SD2->D2_SERIE = cSerie
		AADD(aRegSD2,Recno())
		DbSkip()
		Loop
	End
ENDIF

dbSelectArea("SE1")
SE1->(dbSetOrder(1))
IF SE1->(DbSeek(xFilial("SE1")+cSerie+subs(cNota,1,9)))
	While SE1->E1_NUM = subs(cNota,1,9) .AND. SE1->E1_PREFIXO = cSerie
		AADD(aRegSE1,Recno())
		DbSkip()
		Loop
	End
ENDIF

If SD2->D2_TIPO $ ('B/D')
	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	IF SE2->(DbSeek(xFilial("SE2")+cSerie+subs(cNota,1,9)))
		While SE2->E2_NUM = subs(cNota,1,9) .AND. SE2->E2_PREFIXO = cSerie
			AADD(aRegSE2,Recno())
			DbSkip()
		End
	ENDIF
EndIf

dbSelectArea("SF2")
SF2->(dbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+subs(cNota,1,9)+cSerie))

MACANDELF2("SF2",RECNO(),@aRegSD2,@aRegSE1,@aRegSE2)  //VALIDA A EXCLUSAO

MADELNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.T.)         //EFETUA A EXCLUSAO

If lMSErroAuto
	VTBeep(3)
	VTAlert("Falha na exclusao da nota","Aviso",.t.,6000)
	DisarmTransaction()
	BREAK
EndIf

Return !lMSErroAuto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ FechaSemaforo ³ Autor ³ Sandro           ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Controle do Fechamento de Semaforo utilizado   ³±±
±±³          ³ pelo programa principal CRC010                             ³±±
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
Static Function FechaSemaforo()

Local aTela:=VTSave()

*-------------------------------------------*
*Alberto -01/12/10- Projeto Ponta Grossa         *
*Considerar o codigo da empresa na criacao do    *
*arquivo de semaforo.                            *
*-------------------------------------------*
VTMSG("Aguarde ...",1)
__nSem := -1
While __nSem  < 0
	__nSem  := MSFCreate("Embarque"+Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)+".sem")
	IF  __nSem  < 0
		SLeep(50)
	Endif
End

vtRestore(,,,,aTela)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ AbreSemaforo ³ Autor ³ Sandro           ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Controle da Abertura de Semaforo utilizado     ³±±
±±³          ³ pelo programa principal CRC010                             ³±±
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
Static Function AbreSemaforo()

*-------------------------------------------*
*Alberto -01/12/10- Projeto Ponta Grossa         *
*Considerar o codigo da empresa na criacao do    *
*arquivo de semaforo.                            *
*-------------------------------------------*
Fclose(__nSem)
FErase("Embarque"+Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)+".sem")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Parametros ³ Autor ³ Sandro              ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Efetuar o chamado de perguntas p/ parametrizar ³±±
±±³          ³ detalhes utilizados pelo programa principal CRC010         ³±±
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
Static function Parametros()

Local aTela:= VTSave()
Local lReverso:= VTReverso()

Pergunte("EMBPRO")

VTRestore(,,,,aTela)
VTReverso(lReverso)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldTransp ³ Autor ³ Sandro               ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Efetuar a Validacao da Transportadora          ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
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
Static Function VldTransp(cTransp)

If Empty(cTransp)
	VtBeep(3)
	VtAlert("Transportadora nao pode ser branco","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

SA4->(dbsetOrder(1))
If ! SA4->(DbSeek(xFilial("SA4")+cTransp))
	VtBeep(3)
	VtAlert("Transportadora nao cadastrada","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

RecLock("DOCA",.F.)
DOCA->TRANSP:= cTransp
MsUnLock()

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ LimpaDocaEti ³ Autor ³ Sandro            ³ Data ³ 09/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Efetuar a Limpeza dos Arquivos ref. Etiquetas  ³±±
±±³          ³ Doca. Utilizado pelo programa principal CRC010             ³±±
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
Static Function LimpaDocaEti()

Local nX

DocaEti->(dbCloseArea())
For nX:= 1 to 10
	_cArqDoca := "DOCA" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
	If File(_cArqDoca+StrZero(nX,2)+".DTC")
		Return
	EndIf
Next

_cArqDocaEti := "DETI" + Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL)
FErase(_cArqDocaEti+".DTC")
FErase(_cArqDocaEti+".CDX")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ Credito ³ Autor ³ Anderson Rodrigues     ³ Data ³ 18/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Avaliar o Limite de Credito do Cliente         ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Codigo do Cliente                                   ³±±
±±³da funcao ³ ExpC2: Loja do Cliente                                     ³±±
±±³MaAvalCred³ ExpN3: Valor a ser avaliado                                ³±±
±±³          ³ ExpN4: Moeda do valor a ser avaliado                       ³±±
±±³          ³ ExpL5: Considera acumulados de Pedido de Venda do SA1      ³±±
±±³          ³ ExpC6: Codigo do Bloqueio.                                 ³±±
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
Static Function Credito(cEtiqueta)

Local cBlqCred:= " "
Local aEti    := {}
Local lCredito:= .f.

nValor:= ValorDoca()
aEti:= CBRetEti(cEtiqueta,"01")

//Alberto - 15/07/09- Projeto PV Automatico *
dbSelectArea("DA1")
dbSetorder(1)
If dbSeek(xFilial("DA1")+_cCodTab+aEti[1])
	nValor   := nValor+(aEti[2]*DA1->DA1_PRCVEN)
	_nMoeda  :=1
	lCredito := MaAvalCred(cCliente,_cLoja,nValor,_nMoeda,.T.,@cBlqCred)
Endif

If ! lCredito
	VtBeep(3)
	If cBlqCred == "04"
		VtAlert("Cliente com limite de credito vencido, Pallet nao podera ser embarcado.","Aviso",.t.,4000)
	Else
		VtAlert("Este Pallet excede o limite de credito do cliente, Pallet nao podera ser embarcado.","Aviso",.t.,4000)
	Endif
	nValor:= ValorDoca()
	VtKeyboard(Chr(20))
	Return .f.
Endif

Return(lCredito)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ ValorDoca ³ Autor ³ Anderson Rodrigues   ³ Data ³ 18/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Avaliar os produtos paletizados na Doca        ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
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
Static Function ValorDoca()

Local nValor:= 0
Local nQtde := 0

DbSelectArea("DOCA")
IF ! DOCA->(DbSeek('NOVO')) .OR. ! Empty(DOCA->PEDIDO)
	DOCA->(DBGOTOP())
	dbeval({|| nQtde++},{|| IDETIQ <> "NOVO"} )
	
	If nQtde <= 0
		Return(nValor)
	Endif
	
	DOCA->(DBGOTOP())
	While ! DOCA->(Eof()) .and. DOCA->PEDIDO==cPedido
	    //Alberto - 06/06/09 - Projeto PV Automatico *
		DA1->(dbSetOrder(1))
		If DA1->(DbSeek(xFilial("DA1")+_cCodTab+DOCA->PRODUTO))
			nValor   := nValor+(DOCA->QTDE*DA1->DA1_PRCVEN)
    	Endif

		DOCA->(DbSkip())
	Enddo
	
EndIf

Return(nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GeraTxt ³ Autor ³ Ricardo Baldoni        ³ Data ³ 07/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Gerar Arquivo Texto a ser Enviado para Sitcar  ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ J.Francisco   ³17/01/11|Verificacao de tipo pelo grupo - Proj A024/10 ³±±
±±³				  ³		   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraTxt()

//Cria o arquivo texto
Private cArqTxt := "NF"+cnota+".TXT"
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	VtAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Aviso",.T.,4000)
	Return
Endif

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2")+cNota+SERIE)

cCpo	:= "1"
cCpo	+= "331743350000185"
cCpo	+= SF2->F2_TPFRETE
cCpo	+= SubStr(dtoc(SF2->F2_EMISSAO),7,2)+SubStr(dtoc(SF2->F2_EMISSAO),5,2)+SubStr(dtoc(SF2->F2_EMISSAO),1,4)
cCpo	+= SF2->F2_SERIE
cCpo	+= SF2->F2_DOC+Space(04)
cCpo	+= StrZero( SF2->F2_VALBRUT * 100, 16 )
cCpo	+= StrZero( SF2->F2_PBRUTO * 100, 15 )
cCpo	+= Repl("0",28)
cCpo	+= SA1->A1_CGC
cCpo	+=	cEol

fWrite(nHdl,cCpo,Len(cCpo))

dbSelectArea("SD2")
dbSetOrder(3)
If dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	While xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA == ;
		xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

		//Alterado por J.Francisco em 17/01/11 - A024/10 *
		cGrp	:= posicione("SBM",1,xFilial("SBM") + SD2->D2_GRUPO, "BM_A_TIPO")
		cCpo	:= "2"
		cCpo	+= StrZero( Val( SD2->D2_COD ), 09 )
		cCpo	+= StrZero( SD2->D2_QUANT * 100, 15 )

		//Alterado por J.Francisco em 17/01/11 - A024/10 *
		if cGrp <> "O"
			cCpo	+= cGrp
		endif
		cCpo	+= cEol
		fWrite(nHdl,cCpo,Len(cCpo))
		
		dbSkip()
	Enddo
	
Endif

fClose(nHdl)

Return(cArqTxt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ EnviaTxt ³ Autor ³ Ricardo Baldoni       ³ Data ³ 07/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Enviar Arquivo Texto                           ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
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
Static Function EnviaTxt(cArqTxt)

Local cServer   := GETMV("MV_RELSERV")
Local cAccount  := GETMV("MV_RELACNT")
Local cEnvia    := GETMV("MV_SITCAR2") //'informatica@crowncork.com.br'
Local cRecebe   := GETMV("MV_SITCAR3")   //'ricardo.baldoni@mrconsultoria.com.br'
Local cPassword := GETMV("MV_RELPSW")
Local aFiles    := {}
Local nI        := 1
Local cMensagem := ''
Local cTos
Local CRLF      := Chr(13) + Chr(10)

cMensagem := 'Em anexo EDI da  '+ substr(cArqTxt,1,8)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	
	aFiles := { "\SYSTEM\"+cArqTxt }
	
	SEND MAIL FROM cEnvia;
	TO cRecebe;
	SUBJECT 'EDI '+cArqTxt ;
	BODY cMensagem ;
	ATTACHMENT aFiles[1];
	RESULT lEnviado
	
	DISCONNECT SMTP SERVER Result lDisConectou
	
	If lEnviado
		cArqDest := "\SITCAR\ENVIADOS\" + Substr(cArqTxt,Rat("\",cArqTxt))
		COPY FILE &cArqTxt To &cArqDest
		FErase(cArqTxt)
	Endif
	
Endif

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ EnviaTxt ³ Autor ³ Ricardo Baldoni       ³ Data ³ 07/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao utilizada para efetuar Acerto no SC9                ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
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
USER Function AcertaSC9(cPedAtu)

Local  aArea    := GetArea()
Local  aAreaSC9 := GetArea("SC9")

SC9->(DbSetOrder(1))
SC9->(DbSeek(xFilial("SC9")+cPedAtu))
While xFilial("SC9")+cPedAtu == SC9->C9_FILIAL+SC9->C9_PEDIDO .and. ! SC9->(Eof())
	
	If Empty(SC9->C9_NFISCAL)
		RecLock("SC9",.F.)
		SC9->(DbDelete())
		SC9->(MsUnLock())
	Endif
	
	SC9->(Dbskip())
	
Enddo

RestArea(aAreaSC9)
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³  AtuSC6  ³AUTOR: ³ Felipe Geraldo        ³DATA: ³ 06/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Rotina que atualiza o SC6 com os valores da tabela de preco³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Felipe Geraldo ³10042006³Essa rotina atualizava o SC9, porem qdo fica  ³±±
±±³				  ³		   ³diferene os precos entre tabela e pedido de   ³±±
±±³				  ³		   ³venda o sistema gera um desconto, por isso foi³±±
±±³				  ³		   ³necessario atualizar o SC6 que ira gerar o SC9³±±
±±³				  ³ 	   ³correto, com o valor da tabela.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSC6(_cNumPed,_cCodPro,_cCodCli)

Local _aAreaAnt := GetArea()

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+_cCodCli)

*--------------------------------------------------------------------*
* Alberto - 18/02/2009                                               *
* Inibida a verificacao do campo SA1->A1_A_TABP pois o criterio para *
* atualizacao do preco, passou a ser se existe a tabela  de preco    *
* preenchida no pedido de venda.                                     *
*--------------------------------------------------------------------*
If found()
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+_cNumPed)
		
		While !eof() .and. SC6->C6_NUM == _cNumPed
			dbSelectArea("DA1")
			dbSetorder(1)
			If dbSeek(xFilial("DA1")+DA0->DA0_CODTAB+SC6->C6_PRODUTO)
				
				RecLock("SC6",.F.)
				C6_PRCVEN := DA1->DA1_PRCVEN
				C6_PRUNIT := DA1->DA1_PRCVEN
				C6_VALOR  := DA1->DA1_PRCVEN * C6_QTDVEN
				MsUnlock()
				
			Else
				
				VtBeep(3)
				VtAlert("Tabela de precos nao localizada. Faturamento nao podera continuar.","Aviso",.t.,3000)
				VtKeyboard(Chr(20))
				aPvlNfs := {}
				
			EndIf
			*-----------------------------*
			* Alberto - 25/02/2009           *
			* Gravar log de geracao da nota  *
			*-----------------------------*
			If _lGeralog
				_cItensLog+= DA1->DA1_CODTAB+";"+Transform(DA1->DA1_PRCVEN,"@E 999,999,999.9999")+";"+Transform(SC6->C6_PRCVEN,"@E 999,999,999.9999")+";"
			Endif

			Dbskip()
		Enddo
		
	Else
		
		VtBeep(3)
		VtAlert("Pedido de venda nao localizado. Faturamento nao podera continuar.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		aPvlNfs := {}
		
	EndIf
	
EndIf

RestArea(_aAreaAnt)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO:   ³MostraPlaca ³AUTOR: ³ Luiz Cesar          ³DATA: ³ 01/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Mostra placa digitada com a mascara correta e grava doca   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MostraPlaca(_nlin,_ncol)

_cplaca := substr(_cPlaca,1,3)+'-'+substr(_cplaca,4,4)

@ _nlin,_ncol    VtSay "Placa : " +  _cPlaca
@ _nlin,_ncol+19 VtSay _cUFP

RecLock("DOCA",.F.)
DOCA->PLACA:= _cPlaca
DOCA->UFP  := _cUFP
MsUnLock()

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³VldCliente³ Autor ³ Alberto               ³ Data ³ 15/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Efetuar a Validacao do cliente                 ³±±
±±³          ³ Utilizado pelo programa principal CRC010                   ³±±
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
Static Function VldCliente(cCliente,_cLoja,_cProd1)

If Empty(cCliente)
	VtBeep(3)
	VtAlert("Cliente nao pode ser branco","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

SA1->(dbsetOrder(1))
If empty(_cLoja)
	If ! SA1->(DbSeek(xFilial("SA1")+cCliente))
		VtBeep(3)
		VtAlert("Cliente nao cadastrado","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	Else
		_cLoja := SA1->A1_LOJA
	EndIf
Else
	If ! SA1->(DbSeek(xFilial("SA1")+cCliente+_cLoja))
		VtBeep(3)
		VtAlert("Cliente nao cadastrado","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	Endif
Endif

If SA1->A1_EST == "EX"
	_lExporta := .T.
Else
	//Alex Borges - 01/06/15 - Chamado: 323394
	_lExporta := .F.
EndIf

//Alberto - 24/01/14- Projeto GFE
If _lIntGFE
	If _cLoja <> ' '.AND. cCliente <> ' '
		_lAchouEmi:=.f.
		GU3->(dbOrderNickName("CODERP"))
		If ! GU3->(DbSeek(xFilial("GU3")+cCliente+_cLoja))
			VtBeep(3)
			VtAlert("Cliente nao cadastrado no cadastro de emitentes do GFE.Entre em contato com o depto Logistica","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		Else
			While ! GU3->(Eof()) .AND. GU3->GU3_CDERP+GU3->GU3_CDCERP =cCliente+_cLoja
				If GU3->GU3_CLIEN = '1'
					_lAchouEmi:=.t.
				Endif
				GU3->(DbSkip())
			End
		EndIf
	
		If ! _lAchouEmi
			VtBeep(3)
			VtAlert("Cliente nao cadastrado no cadastro de emitentes do GFE.Entre em contato com o depto Logistica","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		Endif
	Endif
Endif

_cEol := CHR(13)+CHR(10)

//Localiza a tabela de preco valida para o cliente
If _cLoja <> ' ' .or. _cProd1<>NIL //.and. !empty(_cProduto)  //Luiz Cesar -29/03/10- Projeto lata importada. Inclusao do codigo de produto
	If (Select("TRBSZR") <> 0 ) //Alex Borges - 16/06/14 -  CHAMADO 298562
    	dbSelectArea ("TRBSZR")
        TRBSZR->(dbCloseArea())
 	Endif
	
	//_cQuery  := "SELECT ZR_CODTAB,ZR_DATADE,ZR_DATAATE,ZR_CONDPAG,ZR_CLIENTE,ZR_LOJACLI,ZR_STATUS,ZR_A_TPFRE,ZR_A_TES,ZR_A_TES1,ZR_A_MENNF,ZR_A_FRETE,ZR_PTAX,ZR_A_TES2 FROM " + RetSqlName("SZR") +" SZR, "+RetSqlName("DA0")+" DA0, "+ RetSqlName("SZS") +" SZS "+ _cEol //Alberto -11/05/11- Projeto SPED PIS/COFINS (Adicionado o campo ZR_A_TES1
	//Alex Borges -11/04/16 - Chamado 344445
	_cQuery  := "SELECT ZR_CODTAB,ZR_DATADE,ZR_DATAATE,ZR_CONDPAG,ZR_CLIENTE,ZR_LOJACLI,ZR_STATUS,ZR_A_TPFRE,ZR_A_TES,ZR_A_TES1,ZR_A_MENNF,ZR_A_FRETE,ZR_PTAX,ZR_A_TES2,ZS_TESPRIO FROM " + RetSqlName("SZR") +" SZR, "+RetSqlName("DA0")+" DA0, "+ RetSqlName("SZS") +" SZS "+ _cEol 
	_cQuery  += " WHERE ZR_FILIAL = '" + xFilial("SZR") + "'" + _cEol
    _cQuery  += " AND   ZR_FILIAL = DA0_FILIAL" + _cEol
	_cQuery  += " AND   ZR_CODTAB = DA0_CODTAB" + _cEol
	_cQuery  += " AND   ZR_CODTAB = ZS_CODTAB" + _cEol
	_cQuery  += " AND   ZR_DATADE <= '"   + DToS( dDatabase )+ "' "+ _cEol
	_cQuery  += " AND   ZR_DATAATE >= '"  + DToS( dDatabase )+ "' "+ _cEol
    
    //Esse campo identifica se o cliente é um deposito on site
    //Nesse caso deve ser utilizada a tabela de preco do cliente identificado nesse campo
	If empty(SA1->A1_A_FATUR) 
		_cQuery  += " AND   ZR_CLIENTE = '"+cCliente+"'" + _cEol
		_cQuery  += " AND   ZR_LOJACLI = '"+_cLoja +"'" + _cEol
    Else
        _cCliDF := substr(SA1->A1_A_FATUR,1,6)
        _cLojaDF := substr(SA1->A1_A_FATUR,7,2)
		_cQuery  += " AND   ZR_CLIENTE = '"+_cCliDF+"'" + _cEol
		_cQuery  += " AND   ZR_LOJACLI = '"+_cLojaDF +"'" + _cEol
    Endif      
	_cQuery  += " AND   ZR_STATUS = 'A'" + _cEol
	_cQuery  += " AND   SZR.D_E_L_E_T_ = ' '"
	_cQuery  += " AND   SZS.D_E_L_E_T_ = ' '"
	_cQuery  += " AND   DA0.D_E_L_E_T_ = ' '"
    if _cProd1<>NIL // Luiz Cesar - 29/03/2010 - Importacao de Latas
	   _cQuery  += " AND   ZS_CODPRO = '"+_cProd1+"'" + _cEol
	endif   
	
	memowrite("CRC010.SQL",_cQuery)
	
	_cQuery  := ChangeQuery(_cQuery)
	
	DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSZR", .F., .F. )
	TcSetField("TRBSZR","ZR_DATADE"   ,"D",08,0)
	TcSetField("TRBSZR","ZR_DATAATE"  ,"D",08,0)
	
	DbSelectArea("TRBSZR")
	Dbgotop()
	If eof()
		VtBeep(3)
		VtAlert("Nao existe tabela de preco criada para o cliente.Entrar em contato com depto comercial.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		DbCloseArea()
		Return .F.
	Else
		//Felipe - 26/08/2011 - Busca o tipo do frete na tabela PBS e nao mais na SZR
        If empty(TRBSZR->ZR_CONDPAG)
			VtBeep(3)
			VtAlert("Condicao de pagto nao esta cadastrada corretamente na tabela de preco.Entrar em contato com depto comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			DbCloseArea()
			Return .F.
        Endif
        If empty(TRBSZR->ZR_A_TES)
			VtBeep(3)
			VtAlert("TES nao esta cadastrado corretamente na tabela de preco.Entrar em contato com depto comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			DbCloseArea()
			Return .F.
        Endif

		//Felipe - 26/08/2011 - Busca o tipo do frete na tabela PBS e nao mais na SZR
		_cCondPG := TRBSZR->ZR_CONDPAG  //Cond.Pagto
		_cFlagPC := GetMv("CE_FLAGPC")//Alberto - 26/05/11 - Projeto SPED PIS/COFINS
        If _cFlagPC =="S"//Alberto - 26/05/11 - Projeto SPED PIS/COFINS
			_cTESPauta:= TRBSZR->ZR_A_TES1 //Alberto - 11/05/11 - Projeto SPED PIS/COFINS
        Else
			_cTESPauta:= TRBSZR->ZR_A_TES //Alberto - 11/05/11 - Projeto SPED PIS/COFINS
        Endif
		If Empty(TRBSZR->ZS_TESPRIO) //Alex Borges -11/04/16 - Chamado 344445	
			_cTESAliq := TRBSZR->ZR_A_TES  //Alberto - 11/05/11 - Projeto SPED PIS/COFINS
		Else
			_cTESAliq := TRBSZR->ZS_TESPRIO  //Alex Borges -11/04/16 - Chamado 344445	
		EndIf
		_cTESIsen := TRBSZR->ZR_A_TES2 //Felipe Geraldo - 25/04/12 - Tratamento para PIS/COFINS Isento
		_cMenNF  := TRBSZR->ZR_A_MENNF   //Mensagem NF
		_cCodTab := TRBSZR->ZR_CODTAB
		_nPtxTab := TRBSZR->ZR_PTAX //Felipe Geraldo - 25/09/14 - PTax da tabela de precos utilizada
		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cCliente+_cLoja))

        // Luiz Cesar - 31/03/2010 nao buscar transportadora na informacao da etiqueta
		If lNoaberto .and. _cProd1=NIL
			cTransp := SA1->A1_TRANSP
		Endif

		IF ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(TRBSZR->ZR_CODTAB)
			Reclock("SA1",.F.)
			SA1->A1_TABELA := TRBSZR->ZR_CODTAB
			MsUnlock()
		ENDIF

		_cPTaxSA1 := SA1->A1_A_PTXD1
		_nPerTSA1 := SA1->A1_A_PEPTX
		
		DbSelectArea("TRBSZR")
		DbCloseArea()
		
		Return .t.
	Endif
Endif
		
//Alberto - 19/03/10 - Projeto lata importada
dbSelectArea("DOCA")
IF DOCA->(DbSeek('NOVO'))
	RecLock("DOCA",.F.)
	DOCA->Cliente:= cCliente
	DOCA->LOJA   := _cLoja
	DOCA->PEDIDO := cPedido
	DOCA->TRANSP := cTransp
	DOCA->PLACA  := _cPlaca
	DOCA->UFP    := _cUFP
	MsUnLock()
EndIf

If lNoaberto
	_cPlaca := DOCA->PLACA
	_cUFP   := DOCA->UFP
Endif

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPed   ³ Autor ³ Alberto               ³ Data ³ 15/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de venda automatico                            ³±±
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
Static Function GerPed()

Local aCab   := {}
Local aItens := {}
Local nItem  := 0

//Felipe - 25/09/14 - Variaveis para PTAX D-1 e PTAX Medio
Local _cPtaxD1 := ""
Local _nPerPtx := 0
Local _nNewPrc := 0

cPedido := RetNumPVE()
DOCA->(dbGoTop())

// Felipe - 03/11/11 - Chamado 231473 - Valida se a variavel do tipo de frete esta preenchida 
If Empty(_cTpFre)
    _cGrupo := Posicione("SB1",1,xFilial("SB1") + DOCA->PRODUTO , "B1_GRUPO")
	PBS->(dbSetOrder(1))
	PBS->(dbSeek(xFilial("PBS") + _cCodTab + _cGrupo ))
	If PBS->(!Found()) .OR. Empty(PBS->PBS_A_TPFR)
        _lGerouPV := .F.
		VTBeep(3)
		VtAlert("Tipo de frete nao esta cadastrado corretamente na tabela de preços. Entrar em contato com depto comercial.","Aviso",.t.,6000)
		DisarmTransaction()
		BREAK
	Else
		_cTpFre  := IF(cTransp $ Getmv("CE_A_TRFOB"),"F",PBS->PBS_A_TPFR) // Luiz Cesar ch 356204 - Tipo do frete C=CIF F=FOB
		_cCodGrp := PBS->PBS_A_CODG //Codigo do grupo de produtos
		_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
		_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
		_nFretPBS := IF(cTransp $ Getmv("CE_A_TRFOB"),0,PBS->PBS_A_VLFR) //Felipe - 15/04/15 - Valor do frete na tabela PBS (grupo de produtos)
	Endif
EndIf

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+cCliente+_cLoja))

//Felipe - 25/09/14 - Variaveis para PTAX D-1 e PTAX Medio
_cPTaxD1 := SA1->A1_A_PTXD1
_nPerPtx := SA1->A1_A_PEPTX

//Alberto - 28/08/13-Projeto operacao triangular eletronica
_cNomeCli:= ALLTRIM(SA1->A1_NOME)
_cEndCli := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
_cCNPJCli:= SA1->A1_CGC
_cIECli  := ALLTRIM(SA1->A1_INSCR)

// Ricardo Lima - 30/06/14 - tabela de preco do cliente de operacao triangular
_cCodTabTri := SA1->A1_TABELA
_cCpTri     := _cCondPg   // Alex Borges - 01/09/2016 - Chamado 350242
// FIM  

aadd(aCab,{"C5_NUM"       ,cPedido          ,nil})
aadd(aCab,{"C5_TIPO"      ,'N'               ,nil})
aadd(aCab,{"C5_CLIENTE"   ,cCliente          ,nil})
aadd(aCab,{"C5_LOJACLI"   ,_cLoja            ,nil})
If !EMPTY(SA1->A1_DEPFECH)
	aadd(aCab,{"C5_DEPOSITO"   ,SA1->A1_DEPFECH   ,nil})
	aadd(aCab,{"C5_CRWTIPO"   ,"R"               ,nil})
Else
	aadd(aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
Endif
aadd(aCab,{"C5_PEDCLIE"   ,"0"               ,nil})

//Felipe Geraldo - 25/04/12 - Se eh exportacao deixa pv como exportacao
If _lExporta
	aadd(aCab,{"C5_TIPOCLI"   ,"X"               ,nil})
Else
	aadd(aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
EndIf
aadd(aCab,{"C5_CONDPAG"   ,_cCondPg          ,nil})
aadd(aCab,{"C5_TABELA"    ,_cCodTab          ,nil})
aadd(aCab,{"C5_TPFRETE"   ,_cTpfre           ,nil})
aadd(aCab,{"C5_MENNOTA"   ,_cMenNF           ,nil})
aadd(aCab,{"C5_TRANSP"    ,cTransp          ,nil})

//Felipe Geraldo - 25/04/12 - Se eh exportacao deixa pv como exportacao
//Cristiane  - 30/07/13 - ajuste no codigo e filial da empresa de cabreuva
If _lExporta
	If SM0->M0_CODIGO + SM0->M0_CODFIL == "0101"
		aadd(aCab,{"C5_A_LOEMB"   ,"13226"               ,nil})
	ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0102"
		aadd(aCab,{"C5_A_LOEMB"   ,"41173"               ,nil})
	ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0104"
		aadd(aCab,{"C5_A_LOEMB"   ,"42285"               ,nil})
	ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0301"
		aadd(aCab,{"C5_A_LOEMB"   ,"32441"               ,nil})
	ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0303" //Felipe - 09/10/2013 - Inclusao da condicao para Teresina
		aadd(aCab,{"C5_A_LOEMB"   ,"23205"               ,nil})		
	//Alex Borges 26/09/2016 - Chamado 350242
	ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0105"
		aadd(aCab,{"C5_A_LOEMB"   ,"32441"               ,nil})
	ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0106"
		aadd(aCab,{"C5_A_LOEMB"   ,"23205"               ,nil})
	EndIf
EndIf

If nQtde > 0
	If !EMPTY(DOCA->PRODUTO)
        _cCodPro:=DOCA->PRODUTO
		_nQtdSC6 :=0
		DOCA->(dbeval({|| _nQtdSC6+=DOCA->QTDE},{|| DOCA->PRODUTO = _cCodPro }))
		DOCA->(dbGoTop())
		SB1->(dbSeek(xFilial("SB1")+DOCA->PRODUTO))
		DA1->(dbSeek(xFilial("DA1")+_cCodTab+DOCA->PRODUTO))

		//Felipe - 25/09/14 - Valida se a PTAX do dia nao eh 0
		If _nUltPtx <= 0 .AND. ( _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" )
	        _lGerouPV := .F.
			VTBeep(3)
			VtAlert("Cotacao do dolar nao localizado. Entrar em contato com depto financeiro.","Aviso",.t.,6000)				
			DisarmTransaction()
			BREAK
		EndIf

		//Felipe - 25/09/14 - Calculos para clientes que utilizam PTAX D-1
		If _cPTaxD1 == "S" //Usa PTAX D-1
			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)               ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                       ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                        ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,Iif(_lOpTri,_nQtdSC6,0)           ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc		 	                ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *_nNewPrc,2)       ,NIL},;
						{"C6_PRUNIT" ,_nNewPrc			                ,NIL},;
						{"C6_TES"    ,_cTes                             ,NIL},;
						{"C6_LOCAL"  ,"01"                              ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                      ,NIL}})
		ElseIf _cPTaxD1 == "M" //Usa PTAX D-1 Medio
			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia			
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)               ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                       ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                        ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,Iif(_lOpTri,_nQtdSC6,0)           ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc		 	                ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *_nNewPrc,2)       ,NIL},;
						{"C6_PRUNIT" ,_nNewPrc			                ,NIL},;
						{"C6_TES"    ,_cTes                             ,NIL},;
						{"C6_LOCAL"  ,"01"                              ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                      ,NIL}})							
		Else // "N" ou Vazio
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)               ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                       ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                        ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,Iif(_lOpTri,_nQtdSC6,0)           ,NIL},;
						{"C6_PRCVEN" ,DA1->DA1_PRCVEN                   ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *DA1->DA1_PRCVEN,2),NIL},;
						{"C6_PRUNIT" ,DA1->DA1_PRCVEN                   ,NIL},;
						{"C6_TES"    ,_cTes                             ,NIL},;
						{"C6_LOCAL"  ,"01"                              ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC                      ,NIL}})
		EndIf			
	Endif
EndIf

nTotalFrete := 0  //Alex Borges - 26/06/15 - Chamado: 325613

//Felipe - 15/04/15 - Calcula o frete conforme o PTAX configurado para o cliente
If _lExporta
	/*If _cPTaxD1 == "S"
		_nValFrete := _nFretPBS * _nUltPtx
		aadd(aCab,{"C5_FRETE" ,_nValFrete*_nQtdSC6 ,nil})
	ElseIf _cPTaxD1 == "M"
		_nValFrete := _nFretPBS * ( (_nPtxTab * (_nPerTSA1/100)) + (_nUltPtx * ((100-_nPerTSA1)/100)) )
		aadd(aCab,{"C5_FRETE" ,_nValFrete*_nQtdSC6 ,nil})	
	Else
		_nValFrete := _nFretPBS * _nPtxTab
		aadd(aCab,{"C5_FRETE" ,_nValFrete*_nQtdSC6 ,nil})
	EndIf *///Alex Borges - 26/06/15 - Chamado: 325613
	
	If _cPTaxD1 == "S"
		_nValFrete := _nFretPBS * _nUltPtx
	ElseIf _cPTaxD1 == "M"
		_nValFrete := _nFretPBS * ( (_nPtxTab * (_nPerTSA1/100)) + (_nUltPtx * ((100-_nPerTSA1)/100)) )
	Else
		_nValFrete := _nFretPBS * _nPtxTab
	EndIf
	
	nTotalFrete := _nValFrete*_nQtdSC6 // Total do Frete
	_nPesoLiq   := 0
	_nQtdFolha  := 0
	
	Doca->(DBGoTop())
	While ! Doca->(Eof())
		_nQtdFolha += Doca->QTDPAPEL //Quantidade de Folhas 
		_cMatEmb := Doca->MATEMB
		Doca->(DbSkip())
	End
	Doca->(DBGoTop())
    If !Empty(_cMatEmb)
      	If _cMatEmb $ cEmbPlastico
			_nPesoLiq   := SB1->B1_PESO * _nQtdSC6 //Identifica o peso total do pedido
			_nFreteKG   := nTotalFrete/_nPesoLiq  // Identifica o peso por Kg
			cCodPlas    := Posicione("PBZ",1,xFilial("PBZ")+_cMatEmb,"PBZ_A_FOL") //Identifica qual é o código da folha
			
			cAliasSB1   := SB1->(GetArea())
			cPesoEmb    := Posicione("SB1",1,xFilial("SB1")+cCodPlas, "B1_PESO")  //Peso liquido da folha
		    RestArea(cAliasSB1)
			
			nFreteEmb   := _nFreteKG * (cPesoEmb *_nQtdFolha) //Total de frete somente da embalagem
			
			//Alex Borges - Chamado 325613 - 07/07/2015
			//Não descontará mais o frete da primeira nota fiscal, pois dará diferença no contas a receber.
			//Foi uma mudança no escopo do projeto A004/15. 
			//nTotalFrete := nTotalFrete - (nFreteEmb) //Desconta o valor do frete da folha	       	
        EndIf
    EndIf
	
	aadd(aCab,{"C5_FRETE" ,nTotalFrete ,nil})
	
EndIf

If len(aItens) > 0
	lMSHelpAuto := .T.
	msExecAuto({|x,y|Mata410(x,y)},aCab,aItens)

	lMSHelpAuto := .F.
	If lMSErroAuto
        _lGerouPV :=.f.
		VTBeep(3)
		VTAlert("Falha na geracao do pedido, o processo sera abortado.","Aviso",.t.,6000)
		DisarmTransaction()
		BREAK
    Else
        _lGerouPV :=.t.
       //Grava o numero do pedido na doca 
		RecLock("DOCA",.F.)
		DOCA->PEDIDO := cPedido
    	MsUnLock()
	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldEmb   ³ Autor ³ Alberto               ³ Data ³ 31/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao do mat.embalagem. Projeto controle material de   ³±±
±±³          ³ embalagem                                                  ³±±
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
Static Function VldEmb(_cMatEmb)

VtClearBuffer()

dbSelectArea("PBZ")
If !Dbseek(xfilial("PBZ")+_cMatEmb)
	VtBeep(3)
	VtAlert("Mat.embalagem invalido.","Aviso",.t.,6000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf 

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ MatEmb   ³ Autor ³ Alberto               ³ Data ³ 02/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Efetua a classificacao do material de embalagem            ³±±
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
USER Function MatEmb(cEtiqueta)

Local nX :=0
Local aTela
Local aArea := GetArea("DOCA")
Local cEtiqueta

aTela := VTSave()
VTClear()
_cModDist:=SPACE(2)

While EMPTY(_cModDist) 

	@ 3,0 VtSay Space(20)
	@ 4,0 VtSay Padr("Material de Embalagem",20)
	@ 5,0 VtSay Space(20)
	@ 5,0 VtGet _cModDist Pict "99" Valid !Empty(_cModDist) .and. VldEmb(_cModDist) F3 "PBZ"
	VtRead

    If !empty(_cModDist)
		If VTYesNo("Confirma distribuicao? Codigo: "+_cModDist,"Material de embalagem do pallet",.t.) 
			cAlias := GetArea()
        	Dbselectarea("CB0")
	        If ALLTRIM(cEtiqueta) == ALLTRIM(CB0->CB0_CODETI)
				RecLock('CB0',.F.)
				CB0->CB0_A_TPEM := _cModDist
				CB0->(MsUnLock())
	        Endif
			RestArea(cAlias)
		Else
			_cModDist:=SPACE(2)
			Loop
		Endif
    Endif

Enddo

vtRestore(,,,,aTela)
RestArea(aArea)

Return(_cModDist)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ VldPlaca ³ Autor ³ Felipe Geraldo        ³ Data ³ 09/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Validacao da placa digitada pelo usuario					  ³±±
±±³          ³ Parametros: PamC1 = Caracter a ser lido					  ³±±
±±³          ³             PamN2 = Se eh letra(1) ou numero(2)			  ³±±
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
/*/

Static Function VldPlaca(_cPlaca,_nTipo)

Local _lRet  := .F.
Local _cChar := ""

If _nTipo = 1
	For _nI:=1 To Len(_cPlaca)
		_cChar := Substr(_cPlaca,_nI,1)
		_lRet  := IsAlpha(_cChar)
		If !_lRet
			Exit
		EndIf
	Next
Else
	For _nI:=1 To Len(_cPlaca)
		_cChar := Substr(_cPlaca,_nI,1)
		_lRet  := IsDigit(_cChar)
		If !_lRet
			Exit
		EndIf		
	Next
EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ GerPedTri³ Autor ³ Alberto               ³ Data ³ 28/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de venda automatico operacao triangular        ³±±
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
Static Function GerPedTri()

Local aCab   := {}
Local aItens := {}
Local nItem  := 0

//Felipe - 25/09/14 - Variaveis para PTAX D-1 e PTAX Medio
Local _cPtaxD1 := ""
Local _nPerPtx := 0
Local _nNewPrc := 0

_cPedTri := RetNumPVE()
DOCA->(dbGoTop())

If Empty(_cFreteTri)
    _cGrupo := Posicione("SB1",1,xFilial("SB1") + DOCA->PRODUTO , "B1_GRUPO")
	PBS->(dbSetOrder(1))
	PBS->(dbSeek(xFilial("PBS") + _cCodTabTri + _cGrupo ))
	If PBS->(!Found()) .OR. Empty(PBS->PBS_A_TPFR)
        _lGerouPV := .F.
		VTBeep(3)
		VtAlert("Tipo de frete nao esta cadastrado corretamente na tabela de preços. Entrar em contato com depto comercial.","Aviso",.t.,6000)
		DisarmTransaction()
		BREAK
	Else
		_cFreteTri  := IF(cTransp $ Getmv("CE_A_TRFOB"),"F",PBS->PBS_A_TPFR) //Tipo do frete C=CIF F=FOB
		_cCodGrp := PBS->PBS_A_CODG //Codigo do grupo de produtos
		_nPrcUGrp := PBS->PBS_A_PVUS //Preco em dolar sem impostos
		_nPrcRGrp := PBS->PBS_A_PVRL //Preco em reais sem impostos
		_nFretPBS := IF(cTransp $ Getmv("CE_A_TRFOB"),0,PBS->PBS_A_VLFR) //Felipe - 15/04/15 - Valor do frete na tabela PBS (grupo de produtos)
	Endif
EndIf

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+_cCliTri+_cLjTri))

If ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(_cCodTabTri)
	Reclock("SA1",.F.)
	SA1->A1_TABELA := _cCodTabTri
	MsUnlock()
EndIf                    

// Luiz Cesar
SZR->(Dbsetorder(1))
SZR->(dbSeek(xFilial("SZR")+_cCodTabTri))

_cCpTri := SZR->ZR_CONDPAG

//Felipe - 25/09/14 - Variaveis para PTAX D-1 e PTAX Medio
_cPTaxD1 := SA1->A1_A_PTXD1
_nPerPtx := SA1->A1_A_PEPTX

//Alberto - 28/08/13-Projeto operacao triangular eletronica
_cNomeTri:= ALLTRIM(SA1->A1_NOME)
_cEndTri := ALLTRIM(SA1->A1_END)+"-"+ALLTRIM(SA1->A1_BAIRRO)+"-"+ALLTRIM(SA1->A1_MUN)+"-"+ALLTRIM(SA1->A1_EST)
_cCNPJTri:= SA1->A1_CGC
_cIETri := ALLTRIM(SA1->A1_INSCR)

//RICARDO LIMA - 29/12/15
//_cCodTabTri := SA1->A1_TABELA // Alex Borges 01/09/2016 - Chamado 350242

aadd(aCab,{"C5_NUM"       ,_cPedTri        ,nil})
aadd(aCab,{"C5_TIPO"      ,'N'               ,nil})
aadd(aCab,{"C5_CLIENTE"   ,_cCliTri          ,nil})
aadd(aCab,{"C5_LOJACLI"   ,_cLjTri           ,nil})
If !EMPTY(SA1->A1_DEPFECH)
	aadd(aCab,{"C5_DEPOSITO"   ,SA1->A1_DEPFECH   ,nil})
	aadd(aCab,{"C5_CRWTIPO"   ,"R"               ,nil})
Else
	aadd(aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
Endif
aadd(aCab,{"C5_PEDCLIE"   ,"0"               ,nil})

//Felipe Geraldo - 25/04/12 - Se eh exportacao deixa pv como exportacao
If _lExporta
	aadd(aCab,{"C5_TIPOCLI"   ,"X"               ,nil})
Else
	aadd(aCab,{"C5_TIPOCLI"   ,"R"               ,nil})
EndIf
aadd(aCab,{"C5_CONDPAG"   ,_cCpTri          ,nil})
aadd(aCab,{"C5_TABELA"    ,_cCodTabTri      ,nil})
aadd(aCab,{"C5_TPFRETE"   ,_cFreteTri        ,nil})
aadd(aCab,{"C5_MENNOTA"   ,_cMenNF           ,nil})
aadd(aCab,{"C5_TRANSP"    ,cTransp          ,nil})

If nQtde > 0
	If !EMPTY(DOCA->PRODUTO)
		// Não é mais necessário estas validações, pois a TES de remessa será vinculada a TES que foi utilizada para venda
		/*If _cPauta == 'S'
			_cTES := _cTesPaTri
		ElseIf _cPauta == 'I'
			_cTES := _cTesIsTri
		Else
			_cTES := _cTesAlTri
	    Endif*/ // Alex Borges - 01/09/2016 - Chamado 350242
	    
	    _cTES := GetAdvFVal("SF4","F4_A_TESRE",XFILIAL("SF4")+_cTES,1,"")
        _cCodPro:=DOCA->PRODUTO
		_nQtdSC6 :=0
		DOCA->(dbeval({|| _nQtdSC6+=DOCA->QTDE},{|| DOCA->PRODUTO = _cCodPro }))
		DOCA->(dbGoTop())
		SB1->(dbSeek(xFilial("SB1")+DOCA->PRODUTO))
		DA1->(dbSeek(xFilial("DA1")+_cCodTabTri+DOCA->PRODUTO))

		//Felipe - 25/09/14 - Valida se a PTAX do dia nao eh 0
		If _nUltPtx <= 0 .AND. ( _cPTaxD1 == "S" .OR. _cPTaxD1 == "M" )
	        _lGerouPV := .F.
			VTBeep(3)
			VtAlert("Cotacao do dolar nao localizado. Entrar em contato com depto financeiro.","Aviso",.t.,6000)				
			DisarmTransaction()
			BREAK
		EndIf		
		
		//Felipe - 25/09/14 - Calculos para clientes que utilizam PTAX D-1
		If _cPTaxD1 == "S" //Usa PTAX D-1
			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,0                                 ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc		 	                ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *_nNewPrc,2)      ,NIL},;
						{"C6_PRUNIT" ,_nNewPrc			                ,NIL},;
						{"C6_TES"    ,_cTes                            ,NIL},;
						{"C6_LOCAL"  ,"01"                             ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
		ElseIf _cPTaxD1 == "M" //Usa PTAX D-1 Medio
			_nNewPrc := U_ALUFATA4(SB1->B1_COD,SB1->B1_GRUPO,_nPrcUGrp,_nPrcRGrp,_nUltPtx,_cTes,_nPtxTab) //Calcula o preco em reais com base na PTAX do dia			
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,0                                 ,NIL},;
						{"C6_PRCVEN" ,_nNewPrc		 	                ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *_nNewPrc,2)      ,NIL},;
						{"C6_PRUNIT" ,_nNewPrc			                ,NIL},;
						{"C6_TES"    ,_cTes                            ,NIL},;
						{"C6_LOCAL"  ,"01"                             ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})							
		Else // "N" ou Vazio
			aadd(aItens,{{"C6_ITEM"   ,strzero(++nItem,2)              ,NIL},;
						{"C6_PRODUTO",SB1->B1_COD                      ,NIL},;
						{"C6_UM"     ,SB1->B1_UM                       ,NIL},;
						{"C6_QTDVEN" ,_nQtdSC6                          ,NIL},;
						{"C6_QTDLIB" ,0                                ,NIL},;
						{"C6_PRCVEN" ,DA1->DA1_PRCVEN                  ,NIL},;
						{"C6_VALOR"  ,ROUND(_nQtdSC6 *DA1->DA1_PRCVEN,2),NIL},;
						{"C6_PRUNIT" ,DA1->DA1_PRCVEN                  ,NIL},;
						{"C6_TES"    ,_cTes                            ,NIL},;
						{"C6_LOCAL"  ,"01"                             ,NIL},;
						{"C6_DESCRI" ,SB1->B1_DESC  ,NIL}})
		EndIf
	Endif
EndIf

//Felipe - 15/04/15 - Calcula o frete conforme o PTAX configurado para o cliente
If _lExporta
	If _cPTaxD1 == "S"
		_nValFrete := _nFretPBS * _nUltPtx
		aadd(aCab,{"C5_FRETE" ,_nValFrete*_nQtdSC6 ,nil})
	ElseIf _cPTaxD1 == "M"
		_nValFrete := _nFretPBS * ( (_nPtxTab * (_nPerTSA1/100)) + (_nUltPtx * ((100-_nPerTSA1)/100)) )
		aadd(aCab,{"C5_FRETE" ,_nValFrete*_nQtdSC6 ,nil})	
	Else
		_nValFrete := _nFretPBS * _nPtxTab
		aadd(aCab,{"C5_FRETE" ,_nValFrete*_nQtdSC6 ,nil})
	EndIf
EndIf


If len(aItens) > 0
	lMSHelpAuto := .T.
	msExecAuto({|x,y|Mata410(x,y)},aCab,aItens)
	lMSHelpAuto := .F.
	If lMSErroAuto
        _lGerouPV :=.f.
		VTBeep(3)
		VTAlert("Falha na geracao do pedido operacao triangular, o processo sera abortado.","Aviso",.t.,6000)
		DisarmTransaction()
		BREAK
    Else
        _lGerouPV :=.t.
		cNumPed := _cPedTri
		cAlmox  := Doca->ALMOX
		aPvlNfs  :={}

		// Libera quantidade embarcada
		SC5->(dbSetOrder(1))
		SC5->(DbSeek(xFilial("SC5")+cNumPed))
		aProduto := aClone(ProdDoca())
		For nX:=1 to Len(aProduto)
			aEmp     := aClone(CarregaEmpenho(aProduto[nx,1]))
			LibPed(cNumPed,aProduto[nx,1],aEmp[1],aEmp[2]) 
			aadd(aPvlNfs,Prepara(cNumped,aProduto[nx,1],cAlmox))
		Next

	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³VldCliTri ³ Autor ³ Alberto               ³ Data ³ 28/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Funcao para Efetuar a Validacao do cliente operacao        ³±±
±±³          ³ triangular.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³ ACD / Crown CBV                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€O INICIAL.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  PROGRAMADOR  ³  DATA  ³ ALTERACAO OCORRIDA 				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alex Borges	  ³01/09/16³ Chamado 350242. Alteração das variaveis      ³±±
±±³          	  ³        ³ cCliente, e _cLoja para cCli e cLoja         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCliTri(cCli,cLoja,_cProd1)

aAreaSA1 := SA1->(GetArea())
If Empty(cCli)
	VtBeep(3)
	VtAlert("Cliente Triangular nao pode ser branco","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf

SA1->(dbsetOrder(1))
If empty(cLoja)
	If ! SA1->(DbSeek(xFilial("SA1")+cCli))
		VtBeep(3)
		VtAlert("Cliente Triangular nao cadastrado","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	Else
		cLoja := SA1->A1_LOJA
		_cLjTri := SA1->A1_LOJA
	EndIf
Else
	If ! SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
		VtBeep(3)
		VtAlert("Cliente Triangular nao cadastrado","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.
	/*Else
		If ( _cPTaxSA1 <> SA1->A1_A_PTXD1 ) .OR. ( _nPerTSA1 <> SA1->A1_A_PEPTX ) //Verifica se o campo esta igual nos 2 clientes
			VtBeep(3)
			VtAlert("Campo PTax D-1 divergente entre os clientes da op. triangular!","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.
		EndIf*/ // Alex Borges - 01/09/2016 - Chamado 350242
	Endif
Endif

If Empty(_cLoja)
	_cLoja:= GetAdvFVal("SA1","A1_LOJA",XFILIAL("SA1")+cCliente,1,"")		
EndIf
//Caso o cliente for igual ao cliente operação triangular não gera a segunda nota fiscal
If _cCliTri+_cLjTri = cCliente+_cLoja
	_lOpTri := .F.
	Return .T.	
EndIf


// Alex Borges - 01/09/2016 - Chamado 350242
// Com a nova operação triangular não valida a tabela de preço do cliente remessa
/*_cEol := CHR(13)+CHR(10)

//Localiza a tabela de preco valida para o cliente
If _cLoja <> ' ' .or. _cProd1<>NIL //.and. !empty(_cProduto)  //Luiz Cesar -29/03/10- Projeto lata importada. Inclusao do codigo de produto
	_cQuery  := "SELECT ZR_CODTAB,ZR_DATADE,ZR_DATAATE,ZR_CONDPAG,ZR_CLIENTE,ZR_LOJACLI,ZR_STATUS,ZR_A_TPFRE,ZR_A_TES,ZR_A_TES1,ZR_A_MENNF,ZR_A_FRETE,ZR_PTAX,ZR_A_TES2 FROM " + RetSqlName("SZR") +" SZR, "+RetSqlName("DA0")+" DA0, "+ RetSqlName("SZS") +" SZS "+ _cEol //Alberto -11/05/11- Projeto SPED PIS/COFINS (Adicionado o campo ZR_A_TES1
	_cQuery  += " WHERE ZR_FILIAL = '" + xFilial("SZR") + "'" + _cEol
    _cQuery  += " AND   ZR_FILIAL = DA0_FILIAL" + _cEol
	_cQuery  += " AND   ZR_CODTAB = DA0_CODTAB" + _cEol
	_cQuery  += " AND   ZR_CODTAB = ZS_CODTAB" + _cEol
	_cQuery  += " AND   ZR_DATADE <= '"   + DToS( dDatabase )+ "' "+ _cEol
	_cQuery  += " AND   ZR_DATAATE >= '"  + DToS( dDatabase )+ "' "+ _cEol
    
    //Esse campo identifica se o cliente é um deposito on site
    //Nesse caso deve ser utilizada a tabela de preco do cliente identificado nesse campo
	If empty(SA1->A1_A_FATUR) 
		_cQuery  += " AND   ZR_CLIENTE = '"+cCliente+"'" + _cEol
		_cQuery  += " AND   ZR_LOJACLI = '"+_cLoja +"'" + _cEol
    Else
        _cCliDF := substr(SA1->A1_A_FATUR,1,6)
        _cLojaDF := substr(SA1->A1_A_FATUR,7,2)
		_cQuery  += " AND   ZR_CLIENTE = '"+_cCliDF+"'" + _cEol
		_cQuery  += " AND   ZR_LOJACLI = '"+_cLojaDF +"'" + _cEol
    Endif      
	_cQuery  += " AND   ZR_STATUS = 'A'" + _cEol
	_cQuery  += " AND   SZR.D_E_L_E_T_ = ' '"
	_cQuery  += " AND   SZS.D_E_L_E_T_ = ' '"
	_cQuery  += " AND   DA0.D_E_L_E_T_ = ' '"
    if _cProd1<>NIL // Luiz Cesar - 29/03/2010 - Importacao de Latas
	   _cQuery  += " AND   ZS_CODPRO = '"+_cProd1+"'" + _cEol
	endif   
	
	memowrite("CRC010tri.SQL",_cQuery)
	
	_cQuery  := ChangeQuery(_cQuery)
	
	DbUseArea( .T., "TopConn", TCGenQry(,,_cQuery), "TRBSZR", .F., .F. )
	TcSetField("TRBSZR","ZR_DATADE"   ,"D",08,0)
	TcSetField("TRBSZR","ZR_DATAATE"  ,"D",08,0)
	
	DbSelectArea("TRBSZR")
	Dbgotop()
	If eof()
		VtBeep(3)
		VtAlert("Nao existe tabela de preco criada para o cliente "+cCliente+" ref operacao triangular.Entrar em contato com depto comercial.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		DbCloseArea()
		Return .F.
	Else
		//Felipe - 26/08/2011 - Busca o tipo do frete na tabela PBS e nao mais na SZR
        If empty(TRBSZR->ZR_CONDPAG)
			VtBeep(3)
			VtAlert("Condicao de pagto nao esta cadastrada corretamente na tabela de preco do cliente "+cCliente+" ref operacao triangular.Entrar em contato com depto comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			DbCloseArea()
			Return .F.
        Endif
        If empty(TRBSZR->ZR_A_TES)
			VtBeep(3)
			VtAlert("TES nao esta cadastrado corretamente na tabela de preco do cliente "+cCliente+" ref operacao triangular.Entrar em contato com depto comercial.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			DbCloseArea()
			Return .F.
        Endif

		//Felipe - 26/08/2011 - Busca o tipo do frete na tabela PBS e nao mais na SZR
		_cCpTri := TRBSZR->ZR_CONDPAG  //Cond.Pagto
		_cMenNFTri  := TRBSZR->ZR_A_MENNF   //Mensagem NF
		_cCodTabTri := TRBSZR->ZR_CODTAB

		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cCliente+_cLoja))

		IF ALLTRIM(SA1->A1_TABELA) <> ALLTRIM(TRBSZR->ZR_CODTAB)
			Reclock("SA1",.F.)
			SA1->A1_TABELA := TRBSZR->ZR_CODTAB
			MsUnlock()
		ENDIF
		
		DbSelectArea("TRBSZR")
		DbCloseArea()
		
		Return .t.
	Endif
Endif */ 
// Alex Borges - 01/09/2016 - Chamado 350242

If Empty(ZZG->ZZG_A_TES4) .OR. Empty(ZZG->ZZG_A_TES6) // Ricardo Lima - 21/03/17  .OR. Empty(ZZG->ZZG_A_TES5)
	VtBeep(3)
	VtAlert("Os campos do cliente para operacao triangular nao estao preenchidos no cadastro auxiliar de clientes. Entrar em contato com depto comercial.","Aviso",.t.,3000)
	return .F.
Else
	_cGrupo   := Posicione("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO, "B1_GRUPO")
	_cPauta   := Posicione("SBM",1,xFilial("SBM")+_cGrupo, "BM_A_PCPTA")
// Ricardo Lima - 21/03/17	
	If _cPauta == 'I'
		_cTES := ZZG->ZZG_A_TES6
    Else
		_cTES := ZZG->ZZG_A_TES4
    Endif		
Endif

aAreaSF4 := SF4->(GetArea())      
dbSelectArea("SF4")
If dbSeek(xFilial("SF4")+_cTes)
	If SF4->F4_A_OPTRI <> 'S' 
		VtBeep(3)
		VtAlert("No cadastro da TES " + _cTes + " o campo 'OP. Triangular' nao esta parametrizado para operação triangular.","Aviso",.t.,3000)
		VtKeyboard(Chr(20))
		Return .F.   	    
	Else
		If Empty(SF4->F4_A_TESRE)
			VtBeep(3)
			VtAlert("No cadastro da TES " + _cTes + " o campo 'TES Rem. Tri' nao esta cadastrado a TES de remessa.","Aviso",.t.,3000)
			VtKeyboard(Chr(20))
			Return .F.   
		EndIf 		
	EndIf
EndIf
RestArea(aAreaSF4)
		
//Alberto - 19/03/10 - Projeto lata importada
dbSelectArea("DOCA")
IF DOCA->(DbSeek('NOVO'))
	RecLock("DOCA",.F.)
	DOCA->ClienteTri:= cCliente
	DOCA->LOJATRI   := _cLoja
 
	MsUnLock()
EndIf

RestArea(aAreaSA1)
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GETPTAX2 ³ Autor ³ Felipe Geraldo        ³ Data ³ 25/09/14   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a ultima PTAX valida para moeda 2 					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Data 			                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Taxa na moeda 2 na data solicitada							³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GETPTAX2(_dData)

//Variaveis Locais
Local _nRet := 0
Local _aAreaAtu := GetArea()
Local _aAreaSM2 := SM2->(GetArea())
Local _cDataVld := DtoS( DataValida(_dData-1,.F.) )

dbSelectArea("SM2")
dbSetOrder(1)
If dbSeek(_cDataVld)
	If SM2->M2_MOEDA2 > 0
		_nRet := SM2->M2_MOEDA2
	EndIf
EndIf

//Restaura o alias original
RestArea(_aAreaSM2)
RestArea(_aAreaAtu)

Return _nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AJUSEQ   ³ Autor ³ Felipe Geraldo        ³ Data ³ 01/12/14   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reajusta a sequencia de leitura das etiquetas ja embarcadas	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sequencia da etiqueta estornada                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AJUSEQ(_nSeqEmb)

//Variaveis Locais
Local _aAreaAtu  := GetArea()
Local _aAreaDOCA := DOCA->(GetArea())

dbSelectArea("DOCA")
DOCA->(dbGoTop())
While DOCA->(!Eof())
	If DOCA->(!Deleted())
		If DOCA->SEQEMB > 1 .AND. DOCA->SEQEMB > _nSeqEmb
			DOCA->(RecLock("DOCA",.F.))
			DOCA->SEQEMB := DOCA->SEQEMB - 1
			DOCA->(MsUnlock())
		EndIf
	EndIf
	DOCA->(dbSkip())
End

//Restaura o alias original
RestArea(_aAreaDOCA)
RestArea(_aAreaAtu)

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA: ³ FatAdm ³ Autor ³ Alex Borges          ³ Data ³ 26/06/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI€O:³ Gera pedido de embalagem quando for de admissao temporaria.³±±
±±³         :³ Projeto A004/15 - Chamado 325613                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE:  ³ Chamada padr„o para programas em RDMake. 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³USADO EM: ³                                                            ³±±
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

Static Function FatAdm(cMatEmb)

Local lRet     := .T.
Local aCab     := {}
Local aItens   := {}
Local nItem    := 0
Local cCodPlas := ""
Local cTipoCli := "" 
Local cMsg     := ""
Local aEmp     := {}
Local nPeso    := 0

cPedidoAdm := RetNumPVE()

_aArea := GetArea()

//Verifica se é exportacao	
If _lExporta
	cTipoCli := "X" 
Else
	cTipoCli := "R" 
EndIf

//Mensagem que sera impressa nas informações complementares da DANFE.
cMsg := Getmv("CE_MSGADM")+Alltrim(cNota)+"."

//Busca o produto a ser gerado o pedido de venda
cCodPlas   := Posicione("PBZ",1,xFilial("PBZ")+cMatEmb,"PBZ_A_FOL")   
//Busca o grupo de produto da lata
cGrupoLata := Posicione("SB1",1,xFilial("SB1")+CB0->CB0_CODPRO, "B1_GRUPO")
// Busca a quantidade de latas do produto e do pallet
nQtdProd   := Posicione("SB5",1,xFilial("SB5")+CB0->CB0_CODPRO,"B5_QPA")

//Busca a quantidade de folhas
_nQtdCam := Posicione("SBM",1,xFilial("SBM")+cGrupoLata, "BM_A_QTDCA")
If _nQtdCam > 0
	_nQtdCam := Round(_nQtdCam/1000,3)
Else
	VtBeep(3)
	VtAlert("Quantidade de Lata por Camada não informado no cadastro de Grupos do Produto " + Alltrim(SB1->B1_GRUPO) + ". Entrar em contato com depto comercial.","Aviso",.t.,3000)
	VtKeyboard(Chr(20))
	DbCloseArea()
	Return .F.
EndIf 
nQtdPallet := SF2->F2_VOLUME1 // Usa a mesma informação da nota fiscal da lata
nQtdEmb := ((nQtdPallet * nQtdProd) / _nQtdCam) + nQtdPallet

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek( xFilial("SB1") + cCodPlas ) 
_cBloq := SB1->B1_MSBLQL 
If _cBloq == "1"
	VtBeep(3)
	VtAlert("Produto "+cCodPlas+" bloqueado. Para gerar a nota fiscal de Admissao Temporaria, entre em contato com o depto de logistica.","Aviso",.t.,6000)
	VtKeyboard(Chr(20))
	Return .F.
EndIf 

nPeso := ( nQtdEmb* SB1->B1_PESO ) //Peso Liquido
nFreteEmb := GETMV("CE_VLRFRT") * _nUltPtx //Valor simbolico de Frete - 14/07/2015 - Projeto A004/15 - Chamado 325613

aadd(aCab,{"C5_NUM"       ,cPedidoAdm        ,nil})
aadd(aCab,{"C5_TIPO"      ,'N'               ,nil})
aadd(aCab,{"C5_CLIENTE"   ,SF2->F2_CLIENTE   ,nil})
aadd(aCab,{"C5_LOJACLI"   ,SF2->F2_LOJA      ,nil})
aadd(aCab,{"C5_CRWTIPO"   ,"V"               ,nil})
aadd(aCab,{"C5_TIPOCLI"   ,cTipoCli          ,nil})
aadd(aCab,{"C5_CONDPAG"   ,SF2->F2_COND      ,nil})
aadd(aCab,{"C5_TPFRETE"   ,SF2->F2_TPFRETE   ,nil}) 
aadd(aCab,{"C5_TRANSP"    ,SF2->F2_TRANSP    ,nil})
aadd(aCab,{"C5_MENNOTA"   ,cMsg              ,nil})
aadd(aCab,{"C5_VOLUME1"   ,nQtdEmb           ,nil})
aadd(aCab,{"C5_ESPECI1"   ,"UN"              ,nil})
aadd(aCab,{"C5_PBRUTO"    ,nPeso             ,nil})
aadd(aCab,{"C5_PESOL"     ,nPeso             ,nil})
aadd(aCab,{"C5_FRETE"     ,nFreteEmb         ,nil})
If SM0->M0_CODIGO + SM0->M0_CODFIL == "0101"
	aadd(aCab,{"C5_A_LOEMB"   ,"13226"               ,nil})
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0102"
	aadd(aCab,{"C5_A_LOEMB"   ,"41173"               ,nil})
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0104"
	aadd(aCab,{"C5_A_LOEMB"   ,"42285"               ,nil})
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0301"
	aadd(aCab,{"C5_A_LOEMB"   ,"32441"               ,nil})
ElseIf SM0->M0_CODIGO + SM0->M0_CODFIL == "0303" //Felipe - 09/10/2013 - Inclusao da condicao para Teresina
	aadd(aCab,{"C5_A_LOEMB"   ,"23205"               ,nil})	
EndIf

//nPrcVen := SB1->B1_PRV1 //Alex Borges - 14/09/15 - Chamado: 330060
nPrcVen := SB1->B1_PRV1 * _nUltPtx

aadd(aItens,{ {"C6_ITEM"   ,strzero(++nItem,2)             ,NIL},;
			  {"C6_PRODUTO",SB1->B1_COD                    ,NIL},;
			  {"C6_UM"     ,SB1->B1_UM                     ,NIL},;
			  {"C6_QTDVEN" ,nQtdEmb                        ,NIL},;
			  {"C6_PRCVEN" ,nPrcVen                        ,NIL},;
			  {"C6_VALOR"  ,ROUND(nQtdEmb * nPrcVen,2)     ,NIL},;
			  {"C6_TES"    ,SB1->B1_TS                     ,NIL},;
			  {"C6_LOCAL"  ,SB1->B1_LOCPAD                 ,NIL},;
			  {"C6_DESCRI" ,SB1->B1_DESC  			       ,NIL}})

If len(aItens) > 0
	lMSHelpAuto := .T.
	msExecAuto({|x,y|Mata410(x,y)},aCab,aItens)
	lMSHelpAuto := .F.
	If lMSErroAuto
		VTBeep(3)
		VTAlert("Falha na geração do Pedido de Venda da Admissao Temporaria.","Aviso",.t.,6000)
		DisarmTransaction()
		VTDispFile(NomeAutoLog(),.t.)           
		Return .F.
	Else
		//Gera Nota Fiscal
		//aadd(aEmp,{"","","","",nQtdEmb,0,ctod(""),"","","",SB1->B1_LOCPAD,CRIAVAR("C9_POTENCI")})
		//LibPed(cPedidoAdm,SB1->B1_COD,nQtdEmb,{}) //Libera o Pedido de venda
        aadd(aPvlNfsAdm,Prepara(cPedidoAdm,SB1->B1_COD,SB1->B1_LOCPAD))
		cNotaAdm := MaPvlNfs(aPvlNfsAdm,SERIE, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
		
		//Valida se a nota foi gerada normalmente
		If Empty(cNotaAdm)
			VTBeep(3)
			VTAlert("Falha na geração da Nota Fiscal da Admissao Temporaria.","Aviso",.t.,6000)
			DisarmTransaction()
			Return .F.
		EndIf 
		
		//Verifica se a Nota Fiscal de Saida foi gerada
		_aAreaSF2  := SF2->(GetArea())
		_nTamNFF2 := TamSX3("F2_DOC")[1]
		_nTamSRF2 := TamSX3("F2_SERIE")[1]
		dbSelectArea("SF2")
		dbSetOrder(1)
		If !dbSeek( xFilial("SF2") +Alltrim(cNotaAdm)+Space(_nTamNFF2- Len(Alltrim(cNotaAdm)))+Alltrim(SERIE)+Space(_nTamSRF2- Len(Alltrim(SERIE))) )
			VTBeep(3)
			VTAlert("Falha na geração da Nota Fiscal da Admissao Temporaria.","Aviso",.t.,6000)
			DisarmTransaction()
			Return .F.
		EndIf
		
		//Verifica se os itens da Nota fiscal foi gerada normalmente
		_aAreaSD2  := SD2->(GetArea())
		_nTamNFD2 := TamSX3("D2_DOC")[1]
		_nTamSRD2 := TamSX3("D2_SERIE")[1]
		dbSelectArea("SD2")
		dbSetOrder(1)
		If dbSeek( xFilial("SD2") +Alltrim(cNotaAdm)+Space(_nTamNFD2- Len(Alltrim(cNotaAdm)))+Alltrim(SERIE)+Space(_nTamSRD2- Len(Alltrim(SERIE))) )
			VTBeep(3)
			VTAlert("Falha na geração da Nota Fiscal da Admissao Temporaria.","Aviso",.t.,6000)
			DisarmTransaction()
			Return .F.
		EndIf
		
		RecLock('SF2',.f.)
		SF2->F2_TRANSP := cTransp
		SF2->F2_CRNFAUX := cNotaAdm
		SF2->F2_A_PLACA := _cPlaca
		SF2->F2_A_UFP   := _cUFP
		SF2->(MSUNLOCK())
	
		SF2->(DbGoTo(nRecSF2))
		RecLock('SF2',.f.)
		SF2->F2_CRNFAUX:= cNota
		SF2->(MSUNLOCK())
		
	EndIf
Endif

//Restaura o alias original
RestArea(_aArea)

Return lRet
