unit ufsgGeral;

interface

uses
  Graphics, SysUtils, usajProcessamento, Controls, uspConjuntoDados, Forms, DB,
  StdCtrls, dxBarExtItems, dxBar, dxTL, dxDBCtrl, dxDBGrid, dxCntner, Classes,
  dxGridMenus, dxDBTL, dxExEdtr, dxEdLib, dxDBTLCl, dxGrClms, dxDBELib, uspForm,
  Windows, uspAplicacao, ComCtrls, uspPageControl, usajNumeroProcesso, uspConsulta,
  uspMensagem, ufsgMensagem, ufpgGeral, ufsgConstante, uspDateTimeCombo, FileCtrl,
  uspClientDataSet, uspQuery, DBClient, usajConstante, uspFuncoesComponentes,
  uspCriptografia, uspParametro, ufsgParametro, usajParametros, uspFuncoes,
  Winsock, ExtCtrls, uspGridFiltro, VCLZip, uspCampo, uspCampoMascara,
  uspBotaoConsulta, ufpgConstante, uspDataBase, uedtWPRichText, uspDBGrid, uspReportSystem, Menus;

type
  TfsgTipoDocumento = (tdCPF, tdCNPJ);
  TfsgTipoDocumentos = set of TfsgTipoDocumento;
  TfsgTipoRelatorio = (trDespacho, trVista, trIntimaAcordao, trDespachoIntimacao,
    trResultadoSessaoConc, trDecisaoMonocratica, trDecisaoInter);

procedure apagaDiretorio(sDiretorio: string; sMascaraArquivo: string;
  bSubDiretorios: boolean = False);

procedure apagaCacheSeEstiverEmDesenvolvimento;

function ValidaHora(vHora: variant): string;
function DtHrToDateTime(nData: TDateTime; nHora: integer): TDateTime;
function HoraToDateTime(vHora: variant): TDateTime;

var
  oFormTitulo: TfsajProcessamento;
  oListaPreposicao: TStringList;
  sVersaoServidor: string;
  frmCadHistVaraPercentual: string = 'ffsgCadHistVaraPercentual';
  gbSistemaDigital: boolean;

  //29/02/2012 - Anderson Roberto Monzani - SALT: 102385/1
  vWidthLsProc: integer;
  vWidthLsClock: integer;
  vWidthLsSup: integer;
  //------------------------------------------------------

  // 25/07/2011 - rduarte - SALT: 86862/1
  nFLTIPOCLASSE_1GRAU: integer = 0;
  nFLTIPOCLASSE_ACAOINCIDENTAL: integer = 1;
  nFLTIPOCLASSE_EXECUCAOSENTENCA: integer = 2;
  nFLTIPOCLASSE_INCIDENTEPROCESSUAL: integer = 3;
  nFLTIPOCLASSE_RECURSOINTERNO: integer = 4;
  nFLTIPOCLASSE_PETICAO: integer = 5;
  nFLTIPOCLASSE_ORIGINARIO: integer = 6;
  nFLTIPOCLASSE_RECURSO: integer = 7;
  nFLTIPOCLASSE_INCIDENTE_INTERNO: integer = 8;
  nFLTIPOCLASSE_INCIDENTE_EXTERNO: integer = 9;

  sCdTpClasse1Grau: char = '0';
  sCdTpClasseAcaoIncidental: char = '1';
  sCdTpClasseExecucao: char = '2';
  sCdTpClasseIncidenteProcessual: char = '3';
  sCdTpClasseRecurso: char = '4';
  sCdTpClassePeticoesDiversas: char = '5';
  sCdTpClasse2Grau: char = '6';
  sCdTpClasse2GrauRecurso: char = '7';
  sCdTpClasseIncidenteInterno: char = '8';
  sCdTpClasseIncidenteExterno: char = '9';

procedure mostraWaiting(sFrase: string; nTamanho: integer = 0);
procedure escondeWaiting;

procedure SetaTamanhoComponentes(Campo: TControl; bVisivel: boolean;
  nLeft: integer = 0; nTop: integer = 0; nWidth: integer = 0; nHeight: integer = 0);

procedure MontaFiltroRegistrosEmUso(eConjuntoDados: TspConjuntoDados; sMaisCondicoes: string = '');
procedure MontaFiltroRegistrosForaDeUso(eConjuntoDados: TspConjuntoDados;
  sMaisCondicoes: string = '');

// Funcao para retirar espaços e #13#10 do final dos componentes memo
function RetiraCaracteresInvalidosFinalDoMemo(Texto: string): string;

// NyR - Sem Salt - Método para retirar Caracteres de Strings
procedure RetirarCaracteres(psCaracteres: string; var psTexto: string);
// 20/04/2011 - NyR - SALT: 74671/1 - Número Único
function formatarNuProcessoUnico(psNuProcesso: string): string;
//24/08/2012 - NyR - SALT:
function FormatarNuOrigem1grau(psNuProcesso: string): string;
function ValidarMascaraUnificado(psNumeroUnico: string): boolean;


// Controla o número máximo de caracteres de um memo
procedure LimitaEditMemo(nTamanhoMaximo: integer; oComponente: TObject; var Key: char);

// Controle grids da dev com agrupamento para evitar que se clique no agrupador
procedure corrigeAgrupamentoGridDEV(OldNode, Node: TdxTreeListNode; bClicouSetaPraCima: boolean);

// Abre a tela com o abreTela normal das classes e depois chama o PassaParametro
// do form aberto passando cada um dos parâmetros do array aParametros
function abreTelaComParametros(const sAtivaForm: string; const oFormPai: TComponent;
  const aParametros, aValores: array of variant): TspForm;

function copiaTextoComEstilos(oField: TField; sNmEstilo: string): WideString;

// 09/11/2010 - Jonas - SALT 70977/82.
(*procedure copiarEstilosEditor(var poEditor: TedtWPRichText; psArquivoRTF: string;
  psEstilos: string);*)
procedure copiarEstilosEditor(var poEditor: TedtWPRichText; psArquivoRTF: string;
  poEstilos: TStrings);

procedure LimpaBufferTeclado;

procedure EscondePastas(CtrlPai: TspPageControl; oPastas: array of TTabSheet;
  PastaAtiva: TTabSheet);

function CalculaDigitoVerificador(psNumeroProcesso: string): string;
function ValidaDigitoVerificador(nuProcesso: string): boolean;

function DLLEstaRegistrada(DLLName: string): boolean;
function registraDLL(DLLName: string; bForcaRegistro: boolean = False): boolean;
function execAndWait(const executeFile, paramString: string): boolean;

procedure DefineFoco(nmComponente: TWinControl);
procedure IFSetaFoco(bCondicao: boolean; oCampoCondicaoTrue, oCampoCondicaoFalse: TWinControl);

procedure MensagemCampoObrigatorio(sMensagem: string; oActiveControl: TWinControl;
  fFormDaMensagem: TComponent);

procedure VerificaUnicoRegistro(oConjuntoDados: TspConjuntoDados; sCondicao: TStrings;
  spConsulta: TspConsulta; nmCampoRetorno: string; bFiltraForaUso: boolean);

procedure inserirCaracterBufferTeclado(Key: word; const Shift: TShiftState; SpecialKey: boolean);

//Completa com zeros a esquerda a partir do primeiro caracter encontrado (ñ/ò);
function CompletaComZeros(sTexto, sMascara: string): string;
function CompletaComZerosDireita(sTexto, sMascara: string): string;

//Funcao para verificar se o campo possui a mesma mascara.
function VerificaSePossuiMascara(sCampo, sMascara: string): boolean;
function PegaMascara(sTexto: string): string;
function InsereMascara(sTexto, sMascara: string): string;

// Devolve um texto sem as máscaras (somente os números)
function removeMascara(sDocumento: string): string;
// Formata um texto de acordo com a quantidade de caracteres (CPF ou CNPJ)
function formataMascara(sDocumento: string; oTipoDocumento: TfsgTipoDocumento): string;
function ValidaCPFCorreto(sCPF: string): boolean;
procedure MarcaRegistros(oConjuntoDados: TspConjuntoDados; sField: string;
  bDisableControls: boolean = True; bValidarReadOnly: boolean = False); overload;
procedure MarcaRegistros(oClientDataSet: TspClientDataSet; sField: string;
  bDisableControls: boolean = True); overload;
procedure DesmarcaRegistros(oConjuntoDados: TspConjuntoDados; sField: string;
  bValidarReadOnly: boolean = False); overload;
procedure DesmarcaRegistros(oClientDataSet: TspClientDataSet; sField: string); overload;

function dataVazia(oData: TspDateTimeCombo): boolean;

function dataTypeParaString(oDataType: TFieldType): string;

function criaOrdenacao(oData: olevariant; sColuna: string): olevariant;

procedure gravaSQLNoDisco(qy: TspQuery; sNomeArquivo: string);

procedure copiaCamposEntreDatasets(oCDSOriginal: TClientDataSet; var oCDSDestino: TClientDataSet);
procedure copiaRegistro(oCDSOriginal: TClientDataSet; var oCDSDestino: TClientDataSet);
procedure CopiarRegistroComDataSetEmEdicao(pocdsOrigem: TspClientDataSet;
  var pocdsDestino: TspClientDataSet);
function HoraToString(hora: string): string;

function siglasComposicao(cdProcesso: string; nCdRelator, nCdRevisor: integer;
  bIncluiRelator, bIncluiRevisor, bReiniciaNumeracao: boolean;
  sSiglaRelator, sSiglaRevisor, sCampoProcesso, sCampoOrdem, sCampoCodigo, sCampoNome: string;
  oComposicao: olevariant): string;

function quebraNomeEmPalavras(sNome: string): string;
function retornaIniciais(sNome: string): string;

procedure PopMenu(poPopupMenu: TdxBarPopupMenu; poControle: TControl; pnX, pnY: integer);

function FormataListaIn(podata: olevariant; psAlias, psColuna: string;
  psColunaCalculada: string = ''; pbResultadoEntreAspas: boolean = True): string;

// 23/08/2012 - Uba - SALT 115841/3.
function RetornarListaCampoDataSet(podata: olevariant; psColuna: string): string;

function DataPorExtenso(pnData: TDateTime; psformato: string = STRING_INDEFINIDO): string;
function NomeMes(pnMes: word): string;
function NomeDia(pnDia: word): string;
function NumeroPorExtenso(pnNumero: double): string;
function DataTotalmentePorExtenso(nData: TDateTime; bPrefixo: boolean = False): string;
function HoraPorExtenso(nHora: TDateTime; psformato: string = STRING_INDEFINIDO): string;
function HoraTotalmentePorExtenso(nHora: TDateTime): string;

// 23/05/2011 - Jonas - SALT 70977/99.
//função que retorna data por extenso, podendo selecionar qual parte da data será
//em formato numérico, e qual será em formato de string.
function DataComSelecaoExtenso(nData: TDateTime; bPrefixo: boolean = False;
  bDiaExtenso: boolean = True; bMesExtenso: boolean = True; bAnoExtenso: boolean = True;
  const sEntreDiaMes: string = ' dias do mês de ';
  const sEntreMesAno: string = ' do ano de '): string;

procedure ValidaDataFutura(oCampo: TspDateTimeCombo; sComplementoMensagem: string = '');
procedure ValidaDataMaior(oCampoValidacao, oCampoComparacao: TspDateTimeCombo;
  sComplementoMensagem: string = '');

procedure ValidaDataMaiorOuIgual(poCampoValidacao, poCampoComparacao: TspDateTimeCombo;
  psComplementoMensagem: string = '');

function retornaNewValueSeExistir(newValue, oldValue: variant): variant;
function retornaNewValueSeExistirField(oCDS: TClientDataSet; nmField: string): variant;
function mascaraNumeroProcesso(nuProcesso: string; nuNivelDepend: integer): string;
function MascaraProcesso(psNuProcesso, psCdProcesso: string;
  pbFormatoAntigoSAJ: boolean = False): string;
function MascaraProcessoUnificado(psNuProcesso, psCdProcesso: string;
  psFormaTramita: string = ''): string;
function RetornarProcessoMascaradoServidor: string;
function MascaraProcessoData(pvDados: olevariant;
  psNmCampoNuProcesso, psNmCampoCdProcesso: string): olevariant;

function MascaraProcessoDataUnificado(pvDados: olevariant;
  psNmCampoNuProcesso, psNmCampoCdProcesso: string;
  const psNmCampoTpFormaTramita: string = ''): olevariant;

// Cálculo de HASH da assinatura digital para a tela de sessão eletrônica
function calculaHashAssinaturaDigitalSessaoEletronica(dataHora: TDateTime;
  nuSeqSessao, cdForo, cdVara, cdMagistrado, cdTipoVoto: integer;
  cdProcesso, cdUsuario, nuCPF, nmProprietario, nmCertificadora: string): string;
function validaCalculoHashAssinaturaDigitalSessaoEletronica(dataHora: TDateTime;
  nuSeqSessao, cdForo, cdVara, cdMagistrado, cdTipoVoto: integer;
  cdProcesso, cdUsuario, nuCPF, nmProprietario, nmCertificadora, hash: string): boolean;

procedure AdicionaAtributoProjecao(psCampo: string; oConjuntoDados: TspConjuntoDados);

function ColocaAspasListaIn(psLista: string): string;
function RetornaColunaNomeAgente(psAlias: string = ''; pbUtilizaAliasCampo: boolean = True;
  psAliasDist: string = ''): string;
function RetornaColunaNomeAgenteSubstituto(psAliasAgente, psAliasAgenteTitular: string;
  pbUtilizaAliasCampo: boolean = True; psAliasDist: string = '';
  psAliasCargo: string = ''): string;

//SALT: 61635/1 - 03/02/2010 - Claudinei
function PegarDistVaga(psAliasDist: string): string;
//SALT: 62028/1 - 12/03/2010 - Claudinei
function PegarCargoMagistrado(psAliasCargo: string): string;

function IncluirClasseSQL(Classe: string): string;

function VerificaDiretorioMapeado(sCaminho: string; sLetraUnidade: char): boolean;
function MapeiaUnidadeRede(sLetraUnidade, sCaminho, sUsuario, sSenha: string;
  oFormPai: TComponent): boolean;

function MapeiaUnidadeRedeServidor(psUnidade, psCaminho, psUsuario, psSenha: string;
  var psMsgErro: string): boolean;

function DesmapeiaUnidadeRede(sLetraUnidade: string): boolean;

procedure ValidaParametro(nParametro: integer; oFormPai: TComponent);
procedure ConfiguraLayoutBotoesProcesso(sajNumeroProcesso: TsajNumeroProcesso);
function criaListaSeparadaPorVirgulaQuery(oQY: TspQuery; sColuna: string;
  bColocarParticulaE: boolean; pbQuebrarLinha: boolean = False): WideString;
function criaListaSeparadaPorVirgulaDataSet(oCDS: TClientDataset; sColuna: string;
  bColocarParticulaE: boolean): WideString;
function criaListaSeparadaPorVirgulaStrings(oLista: TStrings; bColocarParticulaE: boolean;
  pbQuebrarLinha: boolean = False): WideString;
procedure retiraReadOnlyDoGrid(oGrid: TspGridFiltro; sListaColunasManterSL: string = '');
procedure CompactarArquivo(psArquivoCompactar: string; psNmArquivoZip: string;
  pbApagarArquivoOriginal: boolean = True);
function InteiroValidoString(psInteiro: string): boolean;
procedure exportaDadosDataSet(oDataSet: TClientDataSet; sIndexName, sNomeArquivo: string);

// Retorna o mapeamento de um drive específico
function getNetworkMap(drive: char): string;
// Retorna todos os mapeamentos de rede
function GetNetworkDriveMappings(lista: TStrings): integer;
procedure ExecutaConsulta(oConjuntoDados: TspConjuntoDados;
  sField, sValor, sMaisCondicoes: WideString);
procedure AtualizaCampoChave(oConjuntoDados: TspConjuntoDados; sField, sValor: WideString);
function ProcessoEhMigrado(psTpOrigemMigracao: string): boolean;
function FormataDataHora(pdtReferencia: TDateTime; pbMaiorHoraDia: boolean): TDateTime;
function ValidaFaixaPesquisaAcordao(sNuFaixaInicial, sNuFaixaFinal: string): boolean;
function ValidaPeriodoPesquisaAcordao(sDtInicial, sDtFinal: string): boolean;
procedure CriaCotas(var pcdsCota: TspClientDataSet);
function IncB36(const psNuB36: string; pnLen: integer): string;
function PossuiRegistro(poDataSet: TClientDataSet): boolean;
function NumeroSubProcesso(psCdProcesso: string): integer;
procedure AjustaLayoutSpConsulta(oCampoCodigo: TspCampoMascara; oCampoDescricao: TspCampo;
  oBotaoConsulta: TspBotaoConsulta);

// 16/01/2012 - Anderson Roberto Monzani - SAC: 100716/1 - SG
function RetornarValoresMultiplaSelecao(const poCdsDados: TspClientDataSet;
  const psNomeCampo: string): string; overload;

// Função para concatenar vários campos com opção de formatação de máscara.
// Por enquanto só existe formatação para número do lote
function RetornarValoresMultiplaSelecao(const poCdsDados: TspClientDataSet;
  psListaCampos, psSeparador, psTipoFormato: string): string; overload;
//-------------------------------------------------------------------------

//SALT: 55712/1 - 22/06/2010 - Claudinei - R65
//Devera ser implementado no servidor
//function GetProcessoMaster(psCdProcesso: string): string;
function RemoveCaracter(psValor, psCaracter: string): string;
procedure ValidaHorarioCritico(poFormPai: TComponent);
function HorarioEhCritico(poFormPai: TComponent): boolean;
function ObtemListaCodigosAspas(oDataSet: TDataSet; sNmCampo: string;
  sNmCampoSel: string = ''; const pbSemAspasUnicoRegistro: boolean = False): string;
function RetornarDescExigeRevisor(psFlExigeRevisor: string; psCdClasse: string): string;

// NyR - 11.12.2009 - Monta Lista de Parametros "IN" para spCondicao.
function ListaParametros(pnmParametro: string; var poListaParametros: TStringList): string;
function FormatarHora(pvHora: variant): string;

// NyR - 04.11.09 - Para realizar a Pesquisa na EsajVara pela informação de FlVirtual
procedure IdentificarSistemaDigital;

procedure AtualizarPropriedadesComponentes(poForm: TWinControl; poDadosConfigLayout: olevariant);
function DataPorExtensoComNumeros(nData: TDateTime; bPrefixo: boolean = False): string;
function RetornarRotuloProcurador(const psTextoFormatar: string;
  const pbMaisculo: boolean = False): string;

function MontarIndiceSQL(const psSQL: string; const psNmIndice: string): string;
function ColocarEspacoListaIn(const psLista: string): string;
function RetornarAddTabelaPublicacao(const psNmTabela, psAliasTabela, psLinkedServer: string;
  const paTipoBanco: TspTipoBanco): string;

function RetornarAnoNumeroUnificado(psNuProcesso: string): integer;
function ValidarDigitoVerificador(psNumeroProcesso: string; psSiglaCliente: string;
  const pnTribunalCliente: integer = NUMERO_INDEFINIDO): boolean;
function NumeroProcessoEhProvisorio(psNuProcesso: string): boolean;
function GerarNumeroProcessoUnificado(pnAno: integer; pnNuProtocolo: double;
  pnCdForo: integer; psTrCliente: string): string;
function RetornarNomeFormCadastro(psNuProcesso, psCdProcessoPrinc, psFlTipoClasse,
  psFlExcepcional: string): string;

// 29/06/2010 - rduarte - SAC: 55712/1
function RetornarColunaNuOutroNumero(const psAliasTabelaProcesso: string;
  const psNomeColunaRetorno: string = ''; const pbRetornarNumeroFormatado: boolean = True): string;

function TotalDeParametros(psValor: string): integer;
function WithIndex(psNmIndice: string; paTipoBanco: TspTipoBanco): string;
function SepararListaVirgula(const psLista: string; const pbAspas: boolean = False): string;
// 04/08/2010 - rduarte - SAC: 66319/1
function FormatarNuEditalSemDje(const psNuEdital: string): string;

function RetornarNomeFormEtiquetaAutuacao: string;

// 03/11/2010 - Jonas - SALT 74121/1.
//insere aspas no parâmetro sTexto, e realiza o Trim no texto se bTrim = true
function AspasSG5(sTexto: string; const bTrim: boolean = True): string;

// 12/01/2011 - Jonas - SALT 77845/1.
procedure FecharDataSetsTela(poForm: TForm);

// 09/12/2010 - Jonas - SALT 76404/1.
//retorna lista de órgãos julgadores para serem usados no select.
function RetornarListaOrgaosEstudo(): string;

// 11/07/2011 - junior.goulart - SAC: 87858/1
function RetornaCondicaoTipoCartorio(pbUsarFaixa: boolean): string;

// 19/05/2011 - Jonas - SALT 70977/15.
procedure DefineFocoAnterior(poForm: TForm; poCompAtual: TWinControl);

// 27/05/2011 - Jonas - SALT 70977/46.
procedure DefinirGrideZebrado(oGride: TspDBGrid); overload;
procedure DefinirGrideZebrado(oGride: TdxDBGrid); overload;
// 11/07/2011 - Jonas - SALT 72363/1.
function VerificarValoresDiferentesDataSets(oCDS1, oCDS2: TClientDataSet): boolean;
// 15/07/2011 - rduarte - SALT: 88294/1
function TestarPrecisaCriarTela(const psNmForm: string; var poForm: TspForm): boolean;

// 19/07/2011 - Jonas - SALT 77340/2/7.
procedure AtualizarTopComponentesHeightTela(const poForm: TspForm;
  const poComponentes: array of TControl; const pnAcrescentarHeightForm: integer = 0;
  const pbAtualizarTopComponentes: boolean = False;
  const pnAcrescentarEspacoEntreComponentes: integer = 0);
// 21/07/2011 - Jonas - SALT 78684/1.
procedure AcresecentarItemVariavelEstiloLista(var sVarDestino: string;
  sValorSerAcresentado: string; const bNovoValorEntreAspas: boolean = True;
  const sSeparadorValor: string = ',');

procedure AlterarDescricaoTipoObjeto(poConjuntoDados: TspConjuntoDados;
  pnCdTipoObjeto: integer; psDeTipoObjeto: string);

// 17/08/2011 - Jonas - SALT 81598/1.
function DefinirCaptionTela(psCaptionAtual: string; psTipoTela: string): string;

// 31/08/2011 - rduarte - SALT: 91125/1
function ConfigurarDataSetCamposOrdenacaoAtividade900: olevariant;

// 06/09/2011 - junior.goulart - SALT 57707/3.
function FormataTexto(psFormato, psNumero: string): string;

// 12/09/2011 - Jonas - SALT 92067/1.
procedure DefinirOpcoesGerarRelatorio(poReportSystem: TspReportSystem;
  const pbPDF: boolean = False; const pbRTF: boolean = False;
  const pbRTFGrafico: boolean = False; const pbHTML: boolean = False;
  const pbXLS: boolean = False; const pbBinario: boolean = False;
  const pbSXC: boolean = False; const pbXML: boolean = False);

// 22/09/2011 - rduarte - SALT: 91087/1
function CriarDataSetRejeitados: olevariant;
procedure IncluirDataSetRejeitado(const poCdsRejeitados: TspClientDataSet;
  const psCdProcesso, psNuProcesso, psDeClasse, psDeMotivo: string);

// 26/09/2011 - Jonas - SALT 90907/3.
procedure ExibirItemMenu(poItemMenu: TMenuItem; pbExibir: boolean;
  const pbSomenteDesabilitar: boolean = False);

// 27/10/2011 - Jonas - SALT 94914/1.
function FinalizarDocumento(pnCdDocumento: double; var pnCdErro: double;
  var psMsgErro: string): boolean;

// 10/11/2011 - Uba - SALT: 92305/1.
function GetNomeArea(psVlrArea: string): string;

// 02/12/2011 - junior.goulart - SALT 97266/8.
function RemoverCaracterInvalidoDoProcesso(psNuProcesso: string): string;

//29/02/2012 - Anderson Roberto Monzani - SALT: 102385/1
function GetLocalHost: string;
function PegarIPLocal: string;
//------------------------------------------------------

// 05/03/2012 - rduarte - SALT: 104051/1
function RetornarControleLinksConsulta(const psCdProcesso: string): olevariant;

// 13/03/2012 - rduarte - SALT: 104361/1
function RetornarPrimeiroDiaAno(const pdDiaHoje: TDateTime): TDateTime;
function RetornarPrimeiroDiaDoMes(const pdDiaHoje: TDateTime): TDateTime;
function RetornarPrimeiraSegunda(const pdDiaHoje: TDateTime): TDateTime;
function RetornarUltimoDiaMes(pdDiaHoje: TDateTime): TDateTime;
// 19/04/2012 - Uba - SALT 107038/1.
function PegarRelatorDoProcessoFormatadoPrm58149(oCdsDados: TClientDataSet): string;
function Uniao(pvConjunto1, pvConjunto2: olevariant; psCampoChave: string): olevariant;
// 11/05/2012 - Uba - SALT 108131/1.
procedure AdicionarTextoVariavel(var psSaida: string; psTextoAdicionar: string;
  const psSeparador: string = STRING_INDEFINIDO);
// 15/05/2012 - Uba - SALT 108131/1.
function VerificarSessaoJulgamentoFoiPublicada(poConjuntoDados: TspConjuntoDados;
  const pbVerificarJahFoi: boolean = True): boolean;
// 02/07/2012 - rduarte - SALT: 106650/1
function TestarValorEstaNaLista(const psLista, psValor: string): boolean;
// 19/09/2012 - CassianoM - SALT: 110259/1
procedure EnviarFormSegundoMonitor(poForm: TspForm);
// 31/07/2012 - rduarte - SALT: 64640/1
function VerificarAutorizacao(const psNmForm, psAutorizacao: string): boolean;
// 26/09/2012 - NyR	SALT: 100795/1
function ValidarValorPreenchido(const pvValor: variant): boolean;
//15/10/2012 - CassianoM - 115149/1 - Melhoria nas métricas do sistema.
// Função para ser utilizada em métodos onde se tem "inherited" comentado
// ou seja, onde se deseja matar o comportamento do evento ancestral.
procedure MatarComportamentoAncestral(pbExecutarAbort: boolean = False);
function PegarMensagemExcecao: string;
function ConverterSegundosToDateTime(pnTempo: integer): TDateTime;
function CalcularMediaProcessamento(pdtInicio, pdtTermino: TDateTime;
  pnQuantidadeProcessados: integer): integer;
function RetornarTempoTotalProcessamento(pdtInicio, pdtTermino: TDateTime): string;
function RetornarTempoMedioProcessamento(pdtInicio, pdtTermino: TDateTime;
  pnQuantidadeProcessados: integer): string;

// 21/11/2012 - junior.goulart - SALT: 119981/1
function EhHoraValida(const psHorario: string): boolean;

// Classe básica para criação de coleções, mais utilizada nos nossos sistemas
// para construção de caches.
type
  Tsg5ItemCache = class(TPersistent)
  private
  end;

  Tsg5Cache = class
  private
    FItens: TList;

    function getFItem(index: integer): Tsg5ItemCache;
    function getRegrasCount: integer;
    procedure setFItem(index: integer; const Value: Tsg5ItemCache);
  protected
    procedure customSetItem(index: integer; const Value: Tsg5ItemCache); dynamic;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure addItem(item: Tsg5ItemCache);
    procedure delItem(index: integer);
    function findItem(palavra: string): integer; dynamic; abstract;
    property itens[index: integer]: Tsg5ItemCache read getFItem write setFItem;
    property itensCount: integer read getRegrasCount;
  end;

implementation

uses
  usaj4Geral, uedtZip, WPRTEDefs, shellApi, Messages, registry, uspFuncoesSQL,
  lsajProcesso, esajVara, usajLotacao, DBCtrls, IniFiles, uedtDocEmitido,
  uedtAssinaturaDigital, uedtInicializacaoSistema, uedtGeral, uspSeguranca, usajConfigEstacao;

// 06/09/2011 - junior.goulart - SALT 57707/3.  
function FormataTexto(psFormato, psNumero: string): string;
var
  vr: string;
  tam, x: integer;
begin
  result := STRING_INDEFINIDO;
  vr := psNumero;
  vr := Trim(vr);
  tam := length(vr);

  if Length(psNumero) < Length(psFormato) then
  begin
    for x := 1 to tam do
    begin
      if psFormato <> '#' then
        vr := StringReplace(vr, psFormato[x], '', [rfReplaceAll]);
    end;

    tam := length(vr);
    x := 1;
    while x <= tam do
    begin
      if psFormato[x] <> '#' then
        Insert(psFormato[x], vr, x);
      tam := length(vr);
      Inc(x);
    end;
  end
  else
    vr := Copy(vr, 1, Length(psNumero));
  vr := Trim(vr);
  result := vr;
end;

procedure apagaDiretorio(sDiretorio: string; sMascaraArquivo: string; bSubDiretorios: boolean);
var
  FileAttrs: integer;

  // Cuidado que esse negócio é recursivo!!!
  procedure ProcessaSubDiretorios(sPasta: string);
  var
    sSubPasta: string;
    SR3: TSearchRec;

  begin
    sSubPasta := sPasta;

    if findFirst(AddBackSlash(sSubPasta) + sMascaraArquivo, FileAttrs, SR3) = 0 then
      repeat
        if ((SR3.Attr and faDirectory) > 0) and (SR3.Name <> '.') and (SR3.Name <> '..') then
          processaSubDiretorios(AddBackSlash(sSubPasta) + SR3.Name)
        // Pra quem não sabe taqui a recursividade.
        else
          SysUtils.deleteFile(addBackSlash(sSubPasta) + SR3.Name);
      until findNext(SR3) <> 0;

    SysUtils.FindClose(SR3);
  end;

var
  SR: TSearchRec;

begin
  FileAttrs := faArchive;

  if bSubDiretorios then
    FileAttrs := FileAttrs + faDirectory;

  if findFirst(AddBackSlash(sDiretorio) + sMascaraArquivo, FileAttrs, SR) = 0 then
  begin
    repeat
      if ((SR.Attr and faDirectory) > 0) and (SR.Name <> '.') and (SR.Name <> '..') then
        processaSubDiretorios(addBackSlash(sDiretorio) + SR.Name)
      else
        SysUtils.deleteFile(addBackSlash(sDiretorio) + SR.Name);
    until findNext(SR) <> 0;

    SysUtils.findClose(SR);
  end;
end;

procedure apagaCacheSeEstiverEmDesenvolvimento;
var
  i: integer;

begin
  for i := 0 to paramCount do
    if AnsiUpperCase(ParamStr(i)) = 'EMDESENVOLVIMENTO' then
    begin
      apagaDiretorio(ExtractFilePath(ParamStr(0)) + 'CACHE', '*.*', True);
      break;
    end;
end;

function ValidaHora(vHora: variant): string;
var
  sHora: string;
  nHH, nMM: integer;

begin
  sHora := varToStr(vHora);

  if length(sHora) < 4 then
    sHora := fillZeros(sHora, 4)
  else if length(sHora) > 4 then
    sHora := copy(sHora, length(sHora) - 3, 4);

  nHH := StrToInt(copy(sHora, 1, 2));
  nMM := StrToInt(copy(sHora, 3, 2));

  if nHH > 23 then
    nHH := 23;

  if nMM > 59 then
    nMM := 59;

  if nHH < 10 then
    sHora := '0' + IntToStr(nHH)
  else
    sHora := IntToStr(nHH);

  if nMM < 10 then
    sHora := sHora + '0' + IntToStr(nMM)
  else
    sHora := sHora + IntToStr(nMM);

  result := sHora;
end;

function DtHrToDateTime(nData: TDateTime; nHora: integer): TDateTime;
begin
  result := nData + HoraToDateTime(nHora);
end;

function HoraToDateTime(vHora: variant): TDateTime;
var
  sHora: string;

begin
  sHora := ValidaHora(vHora);
  System.insert(':', sHora, 3);
  result := StrToTime(sHora);
end;

procedure mostraWaiting(sFrase: string; nTamanho: integer = 0);
begin
  if not assigned(oFormTitulo) then
  begin
    oFormTitulo := TfsajProcessamento.Create(nil); //PC_OK
    oFormTitulo.pnProcessamento.Caption := sFrase;

    if nTamanho > 0 then
      oFormTitulo.Width := nTamanho
    else
    begin
      oFormTitulo.Canvas.font.Name := oFormTitulo.pnProcessamento.font.Name;
      oFormTitulo.Canvas.font.size := oFormTitulo.pnProcessamento.font.size;
      oFormTitulo.Canvas.font.style := oFormTitulo.pnProcessamento.font.style;
      oFormTitulo.Width := oFormTitulo.Canvas.TextWidth(sFrase) + 10;

      if oFormTitulo.Width > 800 then
        oFormTitulo.Width := 800;

      if oFormTitulo.Width < 320 then
        oFormTitulo.Width := 320;
    end;

    if assigned(application.mainForm) then
      oFormTitulo.left := (application.mainForm.clientWidth - oFormTitulo.Width) div 2
    else
      oFormTitulo.left := (screen.Width - oFormTitulo.Width) div 2;

    oFormTitulo.Show;
    oFormTitulo.refresh;
  end;
end;

procedure escondeWaiting;
begin
  if assigned(oFormTitulo) then
    FreeAndNil(oFormTitulo); //PC_OK
end;

procedure SetaTamanhoComponentes(Campo: TControl; bVisivel: boolean;
  nLeft: integer = 0; nTop: integer = 0; nWidth: integer = 0; nHeight: integer = 0);
begin
  Campo.Visible := bVisivel;
  if nLeft > 0 then
    Campo.Left := nLeft;
  if nTop > 0 then
    Campo.Top := nTop;
  if nWidth > 0 then
    Campo.Width := nWidth;
  if nHeight > 0 then
    Campo.Height := nHeight;
end;

procedure MontaFiltroRegistrosEmUso(eConjuntoDados: TspConjuntoDados; sMaisCondicoes: string = '');
begin
  eConjuntoDados.spCondicao.Clear;
  eConjuntoDados.LimpaFiltroCondicao;
  eConjuntoDados.spCondicao.Add('flForaUso = ''N''');

  if sMaisCondicoes <> '' then
    eConjuntoDados.spCondicao.add('and ' + sMaisCondicoes);
end;

procedure MontaFiltroRegistrosForaDeUso(eConjuntoDados: TspConjuntoDados;
  sMaisCondicoes: string = '');
begin
  eConjuntoDados.spCondicao.Clear;
  eConjuntoDados.LimpaFiltroCondicao;
  eConjuntoDados.spCondicao.Add('flForaUso = ''S''');

  if sMaisCondicoes <> '' then
    eConjuntoDados.spCondicao.add('and ' + sMaisCondicoes);
end;

function RetiraCaracteresInvalidosFinalDoMemo(Texto: string): string;
begin
  result := Texto;

  while (length(result) > 0) and (result[length(result)] in [#00..#32]) do
    result := copy(result, 1, length(result) - 1);
end;

// NyR - Sem Salt - Método para retirar Caracteres de Strings
procedure RetirarCaracteres(psCaracteres: string; var psTexto: string);
var
  x: integer;
begin
  for x := 1 to length(psCaracteres) do
  begin
    while Pos(psCaracteres[x], psTexto) > 0 do
      Delete(psTexto, Pos(psCaracteres[x], psTexto), 1);
  end;
end;

function formatarNuProcessoUnico(psNuProcesso: string): string;
begin
  psNuProcesso := FillZeros(TiraMascara(psNuProcesso), 20);
  result := Copy(psNuProcesso, 1, 7) + '-' + Copy(psNuProcesso, 8, 2) + '.' +
    Copy(psNuProcesso, 10, 4) + '.' + Copy(psNuProcesso, 14, 1) + '.' +
    Copy(psNuProcesso, 15, 2) + '.' + Copy(psNuProcesso, 17, 4);
end;

function FormatarNuOrigem1grau(psNuProcesso: string): string;
var
  sNuAux: string;

begin
  // 24/08/2012 - NyR SALT: 115847/3
  sNuAux := TiraMascara(psNuProcesso);
  // Se nulo
  if NotNull(sNuAux) then
  begin
    // Antigo do PG
    if Length(sNuAux) < 15 then
    begin
      sNuAux := FillZeros(sNuAux, 12);
      // 001.08.035746-7  001080357467
      result := copy(sNuAux, 1, 3) + '.' + copy(sNuAux, 4, 2) + '.' +
        copy(sNuAux, 6, 6) + '-' + sNuAux[Length(sNuAux)];
    end
    else
      result := formatarNuProcessoUnico(psNuProcesso);
  end
  else
    result := sNuAux;
end;


function ValidarMascaraUnificado(psNumeroUnico: string): boolean;
var
  nAux: integer;

begin
  result := False;
  nAux := Length(psNumeroUnico);
  if IsNull(psNumeroUnico) or ((nAux > 17) and (psNumeroUnico[nAux - 17] = '-') and
    (psNumeroUnico[nAux - 14] = '.') and (psNumeroUnico[nAux - 9] = '.') and
    (psNumeroUnico[nAux - 7] = '.') and (psNumeroUnico[nAux - 4] = '.')) then
    result := True;
end;


procedure LimitaEditMemo(nTamanhoMaximo: integer; oComponente: TObject; var Key: char);
begin
  if (Key <> char(8)) and (Key <> char(127)) then
    // Backspace e Delete podem ser utilizados a vontade
    if length(TMemo(oComponente).Text) >= nTamanhoMaximo then
      Key := char(0);
end;

procedure corrigeAgrupamentoGridDEV(OldNode, Node: TdxTreeListNode; bClicouSetaPraCima: boolean);
var
  oNodoChild, oNodoAcima, oNodoCHildAnterior: TdxTreeListNode;

begin
  // Esse código está aqui porque a grid da devexpress quando possui agrupamento
  // (nesse caso, a lista), ele permite selecionar a linha do agrupador, que
  // nesse contexto está errado. Então com o código abaixo posiciono a seleção
  // no próximo registro que não seja um agrupador, mantendo o visual mais
  // limpo para o usuário.
  if Assigned(Node) and (Node.HasChildren) then
  begin
    // se teclou seta pra cima, e existe um nodo acima (vai para esse nodo,
    // passando assim o registro da categoria
    oNodoAcima := Node.GetPriorNode;

    if (bClicouSetaPraCima) and (Assigned(oNodoAcima)) then
    begin
      // se esse nodo for agrupamento, então abre
      if oNodoAcima.HasChildren then
      begin
        oNodoAcima.Expand(False);
        oNodoCHildAnterior := oNodoAcima;
        oNodoChild := oNodoAcima.GetNextNode;

        // mantem um loop nos nodos filhos, até chegar no último
        while Assigned(oNodoCHild) and (oNodoChild.Level = 1) do
        begin
          oNodoChildAnterior := oNodoChild;
          oNodoChild := oNodoChild.GetNextNode;
        end;

        // oNodoChild tem o agrupamento novamente
        oNodoChild := oNodoCHildAnterior;
        if Assigned(oNodoChild) then
        begin
          oNodoChild.Focused := True;
          oNodoChild.Selected := True;
        end;
      end
      else // o nodoAcima não tem filho, pois já é um item, então joga o foco
      begin
        oNodoAcima.Focused := True;
        oNodoAcima.Selected := True;
      end;
    end
    else // então foi mouse, joga pro nodo de baixo
    begin
      // comportamento original
      Node.Expand(False);
      oNodoChild := Node.GetNextNode;

      if Assigned(oNodoChild) then
      begin
        oNodoChild.Focused := True;
        oNodoChild.Selected := True;
      end;
    end;
  end;
end;

function abreTelaComParametros(const sAtivaForm: string; const oFormPai: TComponent;
  const aParametros, aValores: array of variant): TspForm;
var
  i: integer;

begin
  result := TspForm(abreTela(sAtivaForm, oFormPai));

  if assigned(result) then
    for i := low(aParametros) to high(aParametros) do
      result.passaParametro(varToStr(aParametros[i]), aValores[i]);
end;

function copiaTextoComEstilos(oField: TField; sNmEstilo: string): WideString;
var
  par: TParagraph;
  k: integer;
  oEditor, oEditorCopy: TedtWPRichText;
  nmArquivo, sPathTMP: string;

  function copiaTextoParaDocumentoDestino(edt: TedtWPRichText): boolean;
  var
    oPar: TParagraph;

  begin
    result := True;

    oPar := edt.FirstPar;

    if oPar <> nil then
    begin
      while assigned(oPar.Next) do
        oPar := oPar.Next;
      edt.Memo.Cursor.cursor_pos := 0;
      while edt.CPMoveNext do
      ;
    end;

    // Copia o conteúdo do clipboard para o documento final
    try
      edt.PasteFromClipboard;
      edt.Memo.Cursor.active_paragraph := edt.LastPar;
      edt.Memo.Cursor.active_posinpar := edt.LastPar.CharCount;
    except
      result := False;
      // Se der erro é porque está em tabela. NÃO PODE TER DOCUMENTOS COM TABELAS!!!!!!!!!
    end;
  end;

begin
  result := '';
  sPathTMP := spGetPathExecutavelUsuario;
  nmArquivo := ConvertaBlobZipadoEmArquivo(oField, sPathTMP);

  oEditor := TedtWPRichText.CreateParented(application.handle);
  oEditorCopy := TedtWPRichText.CreateParented(application.handle);
  try
    oEditorCopy.Clear;

    oEditor.TextLoadFormat := 'RTF';
    oEditor.LoadFromFile(nmArquivo);

    k := 0;
    par := oEditor.FirstPar;

    while assigned(par) and (par <> nil) and (k < oEditor.CountParagraphs) do
    begin
      if ansiLowerCase(par.aBaseStyleName) = ansiLowerCase(sNmEstilo) then
      begin
        oEditor.ActiveParagraph := par;
        oEditor.SelectParagraph;

        if notNull(oEditor.selText) then
        begin
          oEditor.CopyToClipboard;

          copiaTextoParaDocumentoDestino(oEditorCopy);
        end;
      end;

      par := par.Next;
      Inc(k);
    end;

    result := oEditorCopy.asAnsiString;
  finally
    SysUtils.DeleteFile(nmArquivo);
    FreeAndNil(oEditorCopy);
    FreeAndNil(oEditor);
  end;
end;

// 09/11/2010 - Jonas - SALT 70977/82.
(*procedure copiarEstilosEditor(var poEditor: TedtWPRichText; psArquivoRTF: string;
  psEstilos: string);*)
procedure copiarEstilosEditor(var poEditor: TedtWPRichText; psArquivoRTF: string;
  poEstilos: TStrings);
var
  oEditorAux: TedtWPRichText;//editor auxiliar, que irá abrir o documento do parâmetro psArquivoRTF
  n: integer; //controla se já navegou em todos os parágrafos do oEditorAux
  oPar: TParagraph; //variável para navegar entre os parágrafos do oEditorAux
  sListaEstilos: TStringList; //lista de estilos recebidos por parâmetro, que serão publicados
  sEstiloAtual: string; //armazena o estilo atual, para inserção de #13 entre um estilo e outro

  function copiarEstilo(sEstilo: string): boolean;
  var
    bRetorno: boolean;
    n: integer;
    nTot: integer;
  begin
    bRetorno := False;
    nTot := sListaEstilos.Count - 1;
    for n := 0 to nTot do
    begin
      if (AnsiLowerCase(sEstilo) = AnsiLowerCase(sListaEstilos.Strings[n])) then
      begin
        bRetorno := True;
        Break;
      end;
    end;
    result := bRetorno;
  end; //fim - copiarEstilo

begin
  oEditorAux := TedtWPRichText.CreateParented(application.handle);
  sListaEstilos := TStringList.Create;
  sListaEstilos.AddStrings(poEstilos);

  try
    oEditorAux.LoadFromFile(psArquivoRTF, False, 'RTF');
    oEditorAux.ReformatAll(True, True);
    oEditorAux.CPPosition := MaxInt;

    sEstiloAtual := STRING_INDEFINIDO;
    n := 0;
    oPar := oEditorAux.FirstPar;
    //oPar := oEditorAux.RTFData.FirstPar;

    while ((Assigned(oPar)) and (oPar <> nil) and (n < oEditorAux.CountParagraphs)) do
    begin
      oPar := oEditorAux.GetPar(n);
      //if(AnsiLowerCase(oPar.ABaseStyleName) = AnsiLowerCase(psEstilos)) and
      //  (NotNull(oPar.ANSIText)) then
      if (copiarEstilo(oPar.ABaseStyleName)) and (NotNull(oPar.ANSIText)) then
      begin
        //verifica se mudou o estilo, para inserir uma quebra de linha entre os estilos
        if (sEstiloAtual <> STRING_INDEFINIDO) and (sEstiloAtual <> oPar.ABaseStyleName) then
        begin
          poEditor.InputString(#13);
          poEditor.Memo.Cursor.active_paragraph := poEditor.LastPar;
          poEditor.Memo.Cursor.active_posinpar := poEditor.LastPar.CharCount;
        end;
        sEstiloAtual := oPar.ABaseStyleName;
        poEditor.ActiveText.AppendParCopy(oPar);
        poEditor.Memo.Cursor.active_paragraph := poEditor.LastPar;
        poEditor.Memo.Cursor.active_posinpar := poEditor.LastPar.CharCount;
        //sEstiloAtual := oPar.ABaseStyleName;
      end;
      //oPar := oPar.Next;
      (* O comando acima não funciona corretamente. Quando o estilo é 'Cabeçalho', por exemplo,
         se o o parágrafo é o 1º, ao realizar o comando oPar.Next, o parágrafo atual passa
         a ser o 3º.
         Então, o ubanóide aqui trocou: oPar := oPar.Next; por: oPar := oEditorAux.GetPar(n);
      *)
      Inc(n);
    end;
  finally
    FreeAndNil(oEditorAux);
    FreeAndNil(sListaEstilos);
  end;
end; //fim - copiarEstilosEditor

procedure LimpaBufferTeclado;
var
  oMsg: TMsg;

begin
  while PeekMessage(oMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do
  ;
end;

procedure EscondePastas(CtrlPai: TspPageControl; oPastas: array of TTabSheet;
  PastaAtiva: TTabSheet);
var
  i: integer;
begin
  for i := Low(oPastas) to High(oPastas) do
  begin
    if oPastas[i] <> nil then
      oPastas[i].TabVisible := False;
  end;

  if PastaAtiva.TabVisible then
    CtrlPai.ActivePage := PastaAtiva;
end;

function CalculaDigitoVerificador(psNumeroProcesso: string): string;
var
  nTamChProcesso: integer;
  nContador: integer;
  nResultMult: integer;
  nResto: longint;
  nDigito: longint;
begin
  nTamChProcesso := length(psNumeroProcesso);
  nResultMult := 0;
  for nContador := 0 to nTamChProcesso - 1 do
    nResultMult := ((12 - nContador) * StrToInt(psNumeroProcesso[nContador + 1])) + nResultMult;

  nResto := nResultMult mod 11;

  if (nResto = 0) or (nResto = 1) then
    nDigito := 0
  else
    nDigito := 11 - nResto;

  result := IntToStr(nDigito);
end;

function ValidaDigitoVerificador(nuProcesso: string): boolean;
var
  sDigito: string;
  nTamNuProcesso: integer;
begin
  nTamNuProcesso := Length(nuProcesso);
  sDigito := Copy(nuProcesso, nTamNuProcesso, 1);
  result := sDigito = CalculaDigitoVerificador(Copy(nuProcesso, 1, nTamNuProcesso - 1));
end;

function execAndWait(const executeFile, paramString: string): boolean;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;

begin
  fillChar(SEInfo, sizeOf(SEInfo), 0);
  SEInfo.cbSize := sizeOf(TShellExecuteInfo);

  with SEInfo do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := application.Handle;
    lpFile := PChar(executeFile);
    lpParameters := PChar(paramString);
    nShow := SW_HIDE;
  end;

  if shellExecuteEx(@SEInfo) then
  begin
    repeat
      application.ProcessMessages;
      getExitCodeProcess(SEInfo.hProcess, ExitCode);
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;

    result := True;
  end
  else
    result := False;
end;

function registraDLL(dllName: string; bForcaRegistro: boolean = False): boolean;
type
  TRegFunc = function: HResult; stdcall;

var
  ARegFunc: TRegFunc;
  aHandle: THandle;

begin
  result := True;

  if bForcaRegistro or (not DLLEstaRegistrada(dllName)) then
    try
      aHandle := LoadLibrary(PChar(dllName));

      if aHandle <> 0 then
      begin
        ARegFunc := GetProcAddress(aHandle, 'DllRegisterServer');

        if Assigned(ARegFunc) then
          result := execAndWait('regsvr32', '/s ' + dllName);

        freeLibrary(aHandle);
      end;
    except
      result := False;
    end;
end;

function DLLEstaRegistrada(DLLName: string): boolean;
var
  oReg: TRegIniFile;
  oDLLs: TStringList;
  i: integer;

begin
  result := False;

  oReg := TRegIniFile.Create;
  oDLLs := TStringList.Create;
  try
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    if oReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\SharedDLLs', False) then
    begin
      oReg.ReadSection('\Software\Microsoft\Windows\CurrentVersion\SharedDLLs', oDLLs);
      oReg.CloseKey;

      for i := 0 to oDLLs.Count - 1 do
      begin
        if ansiLowerCase(extractFileName(oDLLs.Strings[i])) = ansiLowerCase(
          extractFileName(trim(DLLName))) then
        begin
          result := True;
          break;
        end;
      end;
    end;
  finally
    oDLLs.Clear;
    FreeAndNil(oDLLs);
    FreeAndNil(oReg);
  end;
end;

procedure DefineFoco(nmComponente: TWinControl);
begin
  if nmComponente.CanFocus then
    nmComponente.SetFocus;
end;

procedure MensagemCampoObrigatorio(sMensagem: string; oActiveControl: TWinControl;
  fFormDaMensagem: TComponent);
begin
  MostraMensagem(n_avMsgCampoNaoInformado, sMensagem, fFormDaMensagem);
  DefineFoco(oActiveControl);
  Abort;
end;

procedure VerificaUnicoRegistro(oConjuntoDados: TspConjuntoDados; sCondicao: TStrings;
  spConsulta: TspConsulta; nmCampoRetorno: string; bFiltraForaUso: boolean);
var
  i: integer;
  slCondicoes: TStringList;

begin
  slCondicoes := TStringList.Create;
  try
    slCondicoes.Assign(sCondicao);
    oConjuntoDados.spCondicao.Clear;

    if bFiltraForaUso then
      oConjuntoDados.spCondicao.Add('flForaUso = ''N''');

    for i := 0 to slCondicoes.Count - 1 do
    begin
      oConjuntoDados.spCondicao.Add(slCondicoes.Strings[i]);
    end;

    oConjuntoDados.Consulta;

    if oConjuntoDados.RecordCount = 1 then
      spConsulta.spValorCodigo := oConjuntoDados.FieldByName(nmCampoRetorno).AsString;

  finally
    FreeAndNil(slCondicoes);
  end;
end;

// Funcao define foco dependendo do resultado da condição
procedure IFSetaFoco(bCondicao: boolean; oCampoCondicaoTrue, oCampoCondicaoFalse: TWinControl);
begin
  if bCondicao then
    DefineFoco(oCampoCondicaoTrue)
  else
    DefineFoco(oCampoCondicaoFalse);
end;

procedure inserirCaracterBufferTeclado(Key: word; const Shift: TShiftState; SpecialKey: boolean);
type
  TShiftKeyInfo = record
    shift: byte;
    vkey: byte;
  end;
  byteset = set of 0..7;

const
  ShiftKeys: array [1..3] of TShiftKeyInfo =
    ((shift: Ord(ssCtrl); vkey: VK_CONTROL), (shift: Ord(ssShift);
    vkey: VK_SHIFT), (shift: Ord(ssAlt); vkey: VK_MENU));
var
  Flag: DWORD;
  bShift: ByteSet absolute shift;
  i: integer;

begin
  for i := 1 to 3 do
    if shiftkeys[i].shift in bShift then
      Keybd_Event(ShiftKeys[i].vkey, MapVirtualKey(ShiftKeys[i].vkey, 0), 0, 0);

  if SpecialKey then
    Flag := KEYEVENTF_EXTENDEDKEY
  else
    Flag := 0;

  Keybd_Event(Key, MapvirtualKey(Key, 0), Flag, 0);
  Flag := Flag or KEYEVENTF_KEYUP;
  Keybd_Event(Key, MapvirtualKey(Key, 0), Flag, 0);

  for i := 3 downto 1 do
    if ShiftKeys[i].shift in bShift then
      Keybd_Event(shiftkeys[i].vkey, MapVirtualKey(ShiftKeys[i].vkey, 0), KEYEVENTF_KEYUP, 0);
end;


function CompletaComZeros(sTexto, sMascara: string): string;
  // *** Funcao para pegar a posicao do primeiro caracter <> numero ***
  function PegaPosicao(sTexto: string): integer;
  var
    i: integer;

  begin
    result := 0;
    for i := 1 to length(sTexto) do
    begin
      if (sTexto[i] = 'ñ') or (sTexto[i] = 'ò') or (sTexto[i] = 'ó') then
      begin
        result := i;
        exit;
      end;
    end;
  end;

var
  nTamanhoMascara, nTamanhoTexto, nPosicao: integer;

begin
  nTamanhoMascara := Length(MantemSomenteNumero(sMascara));
  nTamanhoTexto := Length(sTexto);
  nPosicao := PegaPosicao(sMascara);

  Insert(Replicate('0', nTamanhoMascara - nTamanhoTexto), sTexto, nPosicao);

  result := sTexto;
end;

function CompletaComZerosDireita(sTexto, sMascara: string): string;
var
  nTamanhoMascara: integer;
  nTamanhoTexto: integer;

begin
  nTamanhoMascara := Length(MantemSomenteNumero(sMascara));
  nTamanhoTexto := Length(sTexto);

  result := sTexto + Replicate('0', nTamanhoMascara - nTamanhoTexto);
end;

function PegaMascara(sTexto: string): string;
var
  i: integer;
begin
  result := '';

  for i := 1 to Length(sTexto) do
  begin
    if sTexto[i] in ['0'..'9'] then
      result := result + '9';

    if (sTexto[i] in ['A'..'Z']) or (sTexto[i] in ['a'..'z']) then
      result := result + 'X';

    if sTexto[i] = '.' then
      result := result + 'ñ';

    if sTexto[i] = '-' then
      result := result + 'ò';

    if sTexto[i] = '/' then
      result := result + 'ó';
  end;
end;

function VerificaSePossuiMascara(sCampo, sMascara: string): boolean;
begin
  result := (Length(sCampo) = Length(sMascara)) and (PegaMascara(sCampo) = sMascara);
end;

function InsereMascara(sTexto, sMascara: string): string;
var
  i: integer;

begin
  for i := 1 to length(sMascara) do
  begin
    if sMascara[i] = 'ñ' then
      Insert('.', sTexto, i);

    if sMascara[i] = 'ò' then
      Insert('-', sTexto, i);

    if sMascara[i] = 'ó' then
      Insert('/', sTexto, i);
  end;
  result := sTexto;
end;


function removeMascara(sDocumento: string): string;
var
  i: integer;

begin
  result := '';

  // Faz um loop nos caracteres do documento informado e só devolve o que for
  // número
  if sDocumento <> '' then
    for i := 1 to length(sDocumento) do
      if sDocumento[i] in ['0'..'9'] then
        result := result + sDocumento[i];
end;

function formataMascara(sDocumento: string; oTipoDocumento: TfsgTipoDocumento): string;
begin
  // Coloca a máscara de CPF ou de CNPJ de acordo com a quantidade de caracteres
  // válidos repassados por parâmetro
  result := removeMascara(sDocumento);

  if oTipoDocumento = tdCPF then
  begin
    result := fillZeros(result, nTamanhoCPF);
    result := copy(result, 1, 3) + '.' + copy(result, 4, 3) + '.' + copy(result, 7, 3) +
      '-' + copy(result, 10, 2);
  end
  else
  begin
    result := fillZeros(result, nTamanhoCNPJ);
    result := copy(result, 1, 2) + '.' + copy(result, 3, 3) + '.' + copy(result, 6, 3) +
      '/' + copy(result, 9, 4) + '-' + copy(result, 13, 2);
  end;
end;

function ValidaCPFCorreto(sCPF: string): boolean;
var
  sAUX: string;

begin
  sAUX := removeMascara(sCPF);

  result := not (length(sAUX) <> nTamanhoCPF) or (sAUX = '00000000000') or
    (sAUX = '11111111111') or (sAUX = '22222222222') or (sAUX = '33333333333') or
    (sAUX = '44444444444') or (sAUX = '55555555555') or (sAUX = '66666666666') or
    (sAUX = '77777777777') or (sAUX = '88888888888') or (sAUX = '99999999999') or
    (not validaDigitoCPF(sAUX));
end;

procedure MarcaRegistros(oConjuntoDados: TspConjuntoDados; sField: string;
  bDisableControls: boolean = True; bValidarReadOnly: boolean = False);
var
  BM: string;

begin
  if not oConjuntoDados.Active then
    Exit;

  if bDisableControls then
  begin
    BM := oConjuntoDados.Bookmark;
    oConjuntoDados.DisableControls;
  end;

  oConjuntoDados.First;

  try
    while not oConjuntoDados.EOF do
    begin
      if (oConjuntoDados.FieldByName(sField).AsString = 'N') then
      begin
        if (((not bValidarReadOnly)) or ((bValidarReadOnly) and
          (not oConjuntoDados.FieldByName(sField).ReadOnly))) then
        begin
          if not (oConjuntoDados.State in [dsEdit, dsInsert]) then
          begin
            oConjuntoDados.Edit;
          end;

          oConjuntoDados.FieldByName(sField).AsString := 'S';
          oConjuntoDados.Post;
        end;
      end;

      oConjuntoDados.Next;
    end;
  finally
    if bDisableControls then
    begin
      oConjuntoDados.Bookmark := BM;
      oConjuntoDados.EnableControls;
    end;
  end;
end;

procedure MarcaRegistros(oClientDataSet: TspClientDataSet; sField: string;
  bDisableControls: boolean = True);
var
  BM: string;

begin
  if not oClientDataSet.Active then
    Exit;

  if bDisableControls then
  begin
    BM := oClientDataSet.Bookmark;
    oClientDataSet.DisableControls;
  end;

  oClientDataSet.First;

  try
    while not oClientDataSet.EOF do
    begin
      if oClientDataSet.FieldByName(sField).AsString = 'N' then
      begin
        if not (oClientDataSet.State in [dsEdit, dsInsert]) then
        begin
          oClientDataSet.Edit;
        end;

        oClientDataSet.FieldByName(sField).AsString := 'S';
        oClientDataSet.Post;
      end;

      oClientDataSet.Next;
    end;
  finally
    if bDisableControls then
    begin
      oClientDataSet.Bookmark := BM;
      oClientDataSet.EnableControls;
    end;
  end;
end;


procedure DesmarcaRegistros(oConjuntoDados: TspConjuntoDados; sField: string;
  bValidarReadOnly: boolean = False);
var
  BM: string;
begin
  if not oConjuntoDados.Active then
    Exit;

  BM := oConjuntoDados.Bookmark;
  oConjuntoDados.DisableControls;
  oConjuntoDados.First;

  try
    while not oConjuntoDados.EOF do
    begin
      if oConjuntoDados.FieldByName(sField).AsString = 'S' then
      begin
        if (((not bValidarReadOnly)) or ((bValidarReadOnly) and
          (not oConjuntoDados.FieldByName(sField).ReadOnly))) then
        begin
          if not (oConjuntoDados.State in [dsEdit, dsInsert]) then
          begin
            oConjuntoDados.Edit;
          end;

          oConjuntoDados.FieldByName(sField).AsString := 'N';
          oConjuntoDados.Post;
        end;
      end;

      oConjuntoDados.Next;
    end;
  finally
    oConjuntoDados.Bookmark := BM;
    oConjuntoDados.EnableControls;
  end;
end;

procedure DesmarcaRegistros(oClientDataSet: TspClientDataSet; sField: string);
var
  BM: string;
begin
  if not oClientDataSet.Active then
    Exit;

  BM := oClientDataSet.Bookmark;
  oClientDataSet.DisableControls;
  oClientDataSet.First;

  try
    while not oClientDataSet.EOF do
    begin
      if oClientDataSet.FieldByName(sField).AsString = 'S' then
      begin
        if not (oClientDataSet.State in [dsEdit, dsInsert]) then
        begin
          oClientDataSet.Edit;
        end;

        oClientDataSet.FieldByName(sField).AsString := 'N';
        oClientDataSet.Post;
      end;

      oClientDataSet.Next;
    end;
  finally
    oClientDataSet.Bookmark := BM;
    oClientDataSet.EnableControls;
  end;
end;

function dataVazia(oData: TspDateTimeCombo): boolean;
begin
  result := isNull(stripCH('/', oData.Text));
end;

function dataTypeParaString(oDataType: TFieldType): string;
begin
  case oDataType of
    ftString: result := 'String';
    ftSmallint: result := 'Smallint';
    ftInteger: result := 'Integer';
    ftWord: result := 'Word';
    ftBoolean: result := 'Boolean';
    ftFloat: result := 'Float';
    ftCurrency: result := 'Currency';
    ftBCD: result := 'BCD';
    ftDate: result := 'Date';
    ftTime: result := 'Time';
    ftDateTime: result := 'DateTime';
    ftBytes: result := 'Bytes';
    ftVarBytes: result := 'VarBytes';
    ftAutoInc: result := 'AutoInc';
    ftBlob: result := 'Blob';
    ftMemo: result := 'Memo';
    ftGraphic: result := 'Graphics';
    ftFmtMemo: result := 'FmtMemo';
    ftParadoxOle: result := 'ParadoxOle';
    ftDBaseOle: result := 'DBaseOle';
    ftTypedBinary: result := 'TypedBinary';
    ftCursor: result := 'Cursor';
    ftFixedChar: result := 'FixedChar';
    ftWideString: result := 'WideString';
    ftLargeInt: result := 'LargeInt';
    ftADT: result := 'ADT';
    ftArray: result := 'Array';
    ftReference: result := 'Reference';
    ftDataSet: result := 'DataSet';
    ftOraBlob: result := 'OraBlob';
    ftOraClob: result := 'OraClob';
    ftVariant: result := 'Variant';
    ftInterface: result := 'Interface';
    ftIDispatch: result := 'IDispatch';
    ftGuid: result := 'Guid';
  else
    result := 'Desconhecido';
  end;
end;

function criaOrdenacao(oData: olevariant; sColuna: string): olevariant;
var
  oCDS: TspClientDataSet;
  i: integer;

begin
  oCDS := TspClientDataSet.Create(nil);
  try
    oCDS.Data := oData;

    oCDS.First;
    i := 1;

    while not oCDS.EOF do
    begin
      oCDS.edit;
      oCDS.FieldByName(sColuna).AsInteger := i;
      oCDS.post;

      Inc(i);

      oCDS.Next;
    end;

    oCDS.First;
    result := oCDS.Data;
  finally
    oCDS.Free;
  end;
end;

procedure gravaSQLNoDisco(qy: TspQuery; sNomeArquivo: string);
var
  X: TextFile;
  i: integer;

begin
  qy.sql.savetofile(sNomeArquivo);

  if qy.paramCount > 0 then
  begin
    assignFile(X, sNomeArquivo);
    append(x);

    writeLn(X);
    writeLn(X, 'Parâmetros: ');

    for i := 0 to qy.paramCount - 1 do
      writeLn(X, qy.params[i].Name + ' = ' + qy.params[i].AsString + ' (' +
        dataTypeParaString(qy.params[i].DataType) + ')');

    closefile(x);
  end;
end;

procedure copiaCamposEntreDatasets(oCDSOriginal: TClientDataSet; var oCDSDestino: TClientDataSet);
var
  i: integer;

begin
  for i := 0 to oCDSOriginal.fields.Count - 1 do
    oCDSDestino.FieldDefs.add(oCDSOriginal.fields[i].fieldName, oCDSOriginal.fields[i].DataType,
      oCDSOriginal.fields[i].Size, oCDSOriginal.fields[i].Required);
end;

procedure copiaRegistro(oCDSOriginal: TClientDataSet; var oCDSDestino: TClientDataSet);
var
  j: integer;

begin
  oCDSDestino.append;

  for j := 0 to oCDSOriginal.fields.Count - 1 do
    oCDSDestino.FieldByName(oCDSOriginal.fields[j].fieldName).Value :=
      oCDSOriginal.fields[j].Value;

  oCDSDestino.post;
end;

procedure CopiarRegistroComDataSetEmEdicao(pocdsOrigem: TspClientDataSet;
  var pocdsDestino: TspClientDataSet);
var
  nIdx: integer;

begin
  for nIdx := 0 to pocdsOrigem.fields.Count - 1 do
    if IsNull(pocdsDestino.FieldByName(pocdsOrigem.fields[nIdx].fieldName).AsString) then
      pocdsDestino.FieldByName(pocdsOrigem.fields[nIdx].fieldName).Value :=
        pocdsOrigem.fields[nIdx].Value;
end;


function HoraToString(hora: string): string;
var
  sHora: string;

begin
  sHora := ValidaHora(Hora);
  System.insert(':', sHora, 3);
  result := sHora;
end;

function siglasComposicao(cdProcesso: string; nCdRelator, nCdRevisor: integer;
  bIncluiRelator, bIncluiRevisor, bReiniciaNumeracao: boolean;
  sSiglaRelator, sSiglaRevisor, sCampoProcesso, sCampoOrdem, sCampoCodigo, sCampoNome: string;
  oComposicao: olevariant): string;
var
  oCDS: TspClientDataSet;
  nOrdem: integer;

begin
  result := '';
  nOrdem := 1;

  oCDS := TspClientDataSet.Create(nil);
  try
    oCDS.Data := oComposicao;

    // Inclui o Relator
    if bIncluiRelator then
    begin
      oCDS.filtered := False;
      oCDS.filter := sCampoProcesso + ' = ' + aspas(cdProcesso) + ' and ' +
        sCampoCodigo + ' = ' + IntToStr(nCdRelator);
      oCDS.filtered := True;

      if not oCDS.EOF then
      begin
        if not oCDS.FieldByName('CC_SGAGENTE').IsNull then
          result := result + sSiglaRelator + ': ' +
            AnsiUpperCase(oCDS.FieldByName('CC_SGAGENTE').AsString)
        else
          result := result + sSiglaRelator + ': ' +
            retornaIniciais(oCDS.FieldByName(sCampoNome).AsString);

        Inc(nOrdem);
      end;
    end
    else
      Inc(nOrdem);

    // Inclui o Revisor
    if bIncluiRevisor then
    begin
      oCDS.filtered := False;
      oCDS.filter := sCampoProcesso + ' = ' + aspas(cdProcesso) + ' and ' +
        sCampoCodigo + ' = ' + IntToStr(nCdRevisor);
      oCDS.filtered := True;

      if not oCDS.EOF then
      begin
        if notNull(result) then
          result := result + ', ';

        if not oCDS.FieldByName('CC_SGAGENTE').IsNull then
          result := result + sSiglaRevisor + ': ' +
            AnsiUpperCase(oCDS.FieldByName('CC_SGAGENTE').AsString)
        else
          result := result + sSiglaRevisor + ': ' +
            retornaIniciais(oCDS.FieldByName(sCampoNome).AsString);

        Inc(nOrdem);
      end;
    end;

    // Inclui Vogais
    oCDS.filtered := False;
    oCDS.filter := sCampoProcesso + ' = ' + aspas(cdProcesso) + ' and ' +
      sCampoCodigo + ' <> ' + IntToStr(nCdRelator) + iif(bIncluiRevisor, ' and ' +
      sCampoCodigo + ' <> ' + IntToStr(nCdRevisor), '');

    oCDS.filtered := True;
    oCDS.indexFieldNames := sCampoOrdem;
    oCDS.First;

    if (not oCDS.EOF) and (Trim(result) <> '') then
      result := result + ', ';

    while not oCDS.EOF do
    begin
      if not oCDS.FieldByName(sCampoCodigo).isNull then
        if not oCDS.FieldByName('CC_SGAGENTE').IsNull then
          result := result + IntToStr(nOrdem) + 'º: ' +
            AnsiUpperCase(oCDS.FieldByName('CC_SGAGENTE').AsString)
        else
          result := result + IntToStr(nOrdem) + 'º: ' +
            retornaIniciais(oCDS.FieldByName(sCampoNome).AsString);

      oCDS.Next;

      if not oCDS.EOF then
        result := result + ', ';

      Inc(nOrdem);
    end;
  finally
    oCDS.Free;
  end;
end;

function quebraNomeEmPalavras(sNome: string): string;
var
  oLista: TStringList;
  x: string;

begin
  oLista := TStringList.Create;
  try
    x := sNome;

    while pos(' ', x) > 0 do
    begin
      if notNull(copy(x, 1, pos(' ', x) - 1)) then
        oLista.add(copy(x, 1, pos(' ', x) - 1));

      Delete(x, 1, pos(' ', x));
    end;

    if notNull(x) then
      oLista.add(x);

    result := oLista.commaText;
  finally
    oLista.Clear;
    oLista.Free;
  end;
end;

function retornaIniciais(sNome: string): string;
var
  i: integer;
  oPalavras: TStringList;

begin
  oPalavras := TStringList.Create;
  result := '';

  try
    oPalavras.CommaText := quebraNomeEmPalavras(sNome);

    if oPalavras.Count > 0 then
      for i := 0 to oPalavras.Count - 1 do
        if oListaPreposicao.indexOf(ansiLowerCase(oPalavras.strings[i])) = -1 then
          result := result + AnsiUpperCase(Copy(oPalavras.strings[i], 1, 1));
  finally
    oPalavras.Clear;
    oPalavras.Free;
  end;
end;

procedure PopMenu(poPopupMenu: TdxBarPopupMenu; poControle: TControl; pnX, pnY: integer);
var
  oPoint, oPointNovo: TPoint;

begin
  oPoint.X := pnX;
  oPoint.Y := pnY;
  oPointNovo := poControle.ClientToScreen(oPoint);
  poPopupMenu.Popup(oPointNovo.X, oPointNovo.Y);
end;

function FormataListaIn(podata: olevariant; psAlias, psColuna: string;
  psColunaCalculada: string = ''; pbResultadoEntreAspas: boolean = True): string;
var
  nqtItensMax: integer;
  oListaItens: TClientDataSet;
  sListaTemp: string;
  sColuna: string;
  nNuItensClausulaIN: integer;

  function GetItem(ocdsItems: TClientDataSet): WideString;
  begin
    if (ocdsItems[psColuna] <> null) then
      result := QuotedStr(ocdsItems[psColuna])
    else
      result := QuotedStr('');
  end;

begin
  nNuItensClausulaIN := 60;
  if NotNull(spParamSistema.AsString(prmNumeroItensClausulaIn, gnCdPrmSG5)) then
    nNuItensClausulaIN := spParamSistema.AsInteger(prmNumeroItensClausulaIn, gnCdPrmSG5);

  sColuna := IIF(NotNull(psColunaCalculada), psColunaCalculada, psColuna);

  //Numero máximo de opções na clausula in = 150 (restrição de alguns SGBD´s)
  if NotNull(psAlias) then
  begin
    psAlias := psAlias + '.';
  end;

  result := psAlias + sColuna + ' in (';
  sListaTemp := STRING_INDEFINIDO;
  nqtItensMax := 0;

  oListaItens := TClientDataSet.Create(nil);
  try
    oListaItens.Data := podata;
    if oListaItens.Active and (oListaItens.RecordCount > 0) then
    begin
      oListaItens.IndexFieldNames := sColuna;

      oListaItens.First;
      while not oListaItens.EOF do
      begin
        Inc(nqtItensMax);

        if nqtItensMax > nNuItensClausulaIN then
        begin
          nqtItensMax := 1;
          result := result + ') or ' + psAlias + sColuna + ' in (' + GetItem(oListaItens);
        end
        else
        begin
          if nqtItensMax = 1 then
            result := result + GetItem(oListaItens)
          else
            result := result + ',' + GetItem(oListaItens);
        end;
        oListaItens.Next;
      end;
      // 03/08/2011 - Jonas - SALT 79591/1/22.
      result := result + ')';
      if pbResultadoEntreAspas then
        result := '(' + result + ')';
    end;
  finally
    FreeAndNil(oListaItens);
  end;
end;

// 23/08/2012 - Uba - SALT 115841/3.
function RetornarListaCampoDataSet(podata: olevariant; psColuna: string): string;
var
  oListaItens: TClientDataSet;
  nTotItens: integer;
begin
  result := STRING_INDEFINIDO;
  oListaItens := TClientDataSet.Create(nil);
  try
    oListaItens.Data := podata;
    if (oListaItens.Active) and (oListaItens.RecordCount > 0) then
    begin
      nTotItens := 0;

      oListaItens.First;
      while not oListaItens.EOF do
      begin
        if (nTotItens = 0) then
          result := AspasSG5(oListaItens.FieldByName(psColuna).AsString)
        else
          result := result + ',' + AspasSG5(oListaItens.FieldByName(psColuna).AsString);
        Inc(nTotItens);
        oListaItens.Next;
      end;

    end;
  finally
    FreeAndNil(oListaItens);
  end;
end;


function DataPorExtenso(pnData: TDateTime; psFormato: string = STRING_INDEFINIDO): string;
var
  nDia: word;
  nMes: word;
  nAno: word;
  oLstFormato: TStringList;
  sAux: string;
  nIdx: integer;

begin
  DecodeDate(pnData, nAno, nMes, nDia);

  if psFormato = STRING_INDEFINIDO then
    result := IntToStr(nDia) + ' de ' + NomeMes(nMes) + ' de ' + IntToStr(nAno)
  else
  begin
    result := '';
    oLstFormato := TStringList.Create;
    try
      sAux := psFormato + ' ';
      while pos(' ', sAux) <> 0 do
      begin
        oLstFormato.Add(Copy(sAux, 1, pos(' ', sAux) - 1));
        Delete(sAux, 1, pos(' ', sAux));
      end;

      for nIdx := 0 to oLstFormato.Count - 1 do
      begin
        if oLstFormato[nIdx] = '$d' then  // FORMATO DE DIA NUMÉRICO "1"
          result := result + IntToStr(nDia)
        else if oLstFormato[nIdx] = '$dd' then  // FORMATO DE DIA NUMÉRICO 2 CARACTERES "01"
          result := result + FormatFloat('00', nDia)
        else if oLstFormato[nIdx] = '$dddd' then // FORMATO DE DIA EXTENSO "vinte e um"
          result := result + NumeroPorExtenso(nDia)
        else if oLstFormato[nIdx] = '$mmmm' then // FORMATO DE MES POR NOME "janeiro"
          result := result + NomeMes(nMes)
        else if oLstFormato[nIdx] = '$aaaa' then // FORMATO DE ANO 4 DIGITOS
          result := result + IntToStr(nAno)
        else if oLstFormato[nIdx] = '$aaaaa' then // FORMATO DE ANO 4 POR EXTENSO
          result := result + NumeroPorExtenso(nAno)

        else if oLstFormato[nIdx][1] <> '$' then // NÃO TEM FORMATO (CARACTERES DE CONCATENAÇÃO)
          result := result + oLstFormato[nIdx];

        if nIdx < oLstFormato.Count - 1 then
          result := result + ' ';
      end;
    finally
      FreeAndNil(oLstFormato);
    end;
  end;
end;

function NomeMes(pnMes: word): string;
begin
  case pnMes of
    1: result := 'janeiro';
    2: result := 'fevereiro';
    3: result := 'março';
    4: result := 'abril';
    5: result := 'maio';
    6: result := 'junho';
    7: result := 'julho';
    8: result := 'agosto';
    9: result := 'setembro';
    10: result := 'outubro';
    11: result := 'novembro';
    12: result := 'dezembro';
  else
    result := '';
  end;
end;

function NomeDia(pnDia: word): string;
begin
  case pnDia of
    1: result := 'Domingo';
    2: result := 'Segunda-feira';
    3: result := 'Terça-feira';
    4: result := 'Quarta-feira';
    5: result := 'Quinta-feira';
    6: result := 'Sexta-feira';
    7: result := 'Sábado';
  else
    result := '';
  end;
end;

function NumeroPorExtenso(pnNumero: double): string;
var
  x, CasaAtual: byte;
  sAux: string;
  bDezena1: boolean;

begin
  // TRUNC??? - POR ENQUANTO SÓ PARA NÚMEROS INTEIROS
  sAux := FloatToStr(Trunc(pnNumero));
  result := '';
  if Trunc(pnNumero) = 0 then
    result := 'zero';
  CasaAtual := 1;
  for x := 0 to Length(sAux) - 1 do
  begin
    bDezena1 := (Length(sAux) - x > 1) and (sAux[Length(sAux) - x - 1] = '1');
    case CasaAtual of
      1: // UNIDADE;
      begin
        // SE EXISTE UM ALGARISMO ANTES E É "1" É A DEZENA ESPECIAL
        if bDezena1 then
          case sAux[Length(sAux) - x] of
            '0': result := 'dez' + result;
            '1': result := 'onze' + result;
            '2': result := 'doze' + result;
            '3': result := 'treze' + result;
            '4': result := 'quatorze' + result;
            '5': result := 'quinze' + result;
            '6': result := 'dezesseis' + result;
            '7': result := 'dezessete' + result;
            '8': result := 'dezoito' + result;
            '9': result := 'dezenove' + result;
          end
        else // 01, 21, 31, 41...
          case sAux[Length(sAux) - x] of
            '1': result := 'um' + result;
            '2': result := 'dois' + result;
            '3': result := 'três' + result;
            '4': result := 'quatro' + result;
            '5': result := 'cinco' + result;
            '6': result := 'seis' + result;
            '7': result := 'sete' + result;
            '8': result := 'oito' + result;
            '9': result := 'nove' + result;
          end;
      end;
      2: // DEZENA;
      begin
        case sAux[Length(sAux) - x] of
          '1': bDezena1 := True;
          '2': result := 'vinte' + result;
          '3': result := 'trinta' + result;
          '4': result := 'quarenta' + result;
          '5': result := 'cinquenta' + result;
          '6': result := 'sessenta' + result;
          '7': result := 'setenta' + result;
          '8': result := 'oitotenta' + result;
          '9': result := 'noventa' + result;
        end;
      end;
      3: // CENTENA;
      begin
        case sAux[Length(sAux) - x] of
          '1': result := 'cento' + result;
          '2': result := 'duzentos' + result;
          '3': result := 'trezentos' + result;
          '4': result := 'quatrocentos' + result;
          '5': result := 'quinhentos' + result;
          '6': result := 'seissentos' + result;
          '7': result := 'setecentos' + result;
          '8': result := 'oitocentos' + result;
          '9': result := 'novecentos' + result;
        end;
      end;

    end;
    // SE EXISTE UM NÚMERO ANTERIOR
    if (Length(sAux) - x > 1) then
    begin
      // SE A CASA ATUAL FO CENTENA, A ANTERIOR EXISTENTE SERÁ MILHAR, E ETC...
      //dezesseis de setembro de dois e mil e dez,
      case x of
        2: result := ' mil' + IIF(sAux[Length(sAux) - x] = '0', ' e ', ', ') + result;
        5: result := IIF(sAux[Length(sAux) - x - 1] = '1', ' milhão' +
            IIF(sAux[Length(sAux) - x] = '0', ' e ', ', '), ' milhões' +
            IIF(sAux[Length(sAux) - x] = '0', ' e ', ', ')) + result;
        8: result := IIF(sAux[Length(sAux) - x - 1] = '1', ' trilhão' +
            IIF(sAux[Length(sAux) - x] = '0', ' e ', ', '), ' trilhões' +
            IIF(sAux[Length(sAux) - x] = '0', ' e ', ', ')) + result;
        11: result := IIF(sAux[Length(sAux) - x - 1] = '1', ' quatrilhão' +
            IIF(sAux[Length(sAux) - x] = '0', ' e ', ', '), ' quatrilhões' +
            IIF(sAux[Length(sAux) - x] = '0', ' e ', ', ')) + result;
        // CENTENAS E DEZENAS ENTÃO " e ";
      else
        if not bDezena1 then
          result := ' e ' + result;
      end;
    end;
    Inc(CasaAtual);
    if CasaAtual = 4 then
      CasaAtual := 1;
  end;
end;

// 14/07/2011 - CassianoM - SALT: 88247/4 - Validar apenas as datas visíveis na tela.
procedure ValidaDataFutura(oCampo: TspDateTimeCombo; sComplementoMensagem: string = '');
begin
  // Se o valor do field estiver vazio
  if (not oCampo.DataSource.DataSet.Active) or (not oCampo.Visible) or
    (IsNull(oCampo.DataSource.DataSet.FieldByName(oCampo.DataField).AsString)) then
    exit;

  if oCampo.Value > DataDoBanco then
  begin
    MostraMensagem(n_avMsgDataSuperiorDiaHoje, sComplementoMensagem, oCampo.Owner);
    DefineFoco(oCampo);
    Abort;
  end;
end;

// 14/07/2011 - CassianoM - SALT: 88247/4 - Validar apenas as datas visíveis na tela.
procedure ValidaDataMaior(oCampoValidacao, oCampoComparacao: TspDateTimeCombo;
  sComplementoMensagem: string = '');
begin
  // Se o valor do field do campo1 estiver vazio
  if (not oCampoValidacao.DataSource.DataSet.Active) or (not oCampoValidacao.Visible) or
    (IsNull(oCampoValidacao.DataSource.DataSet.FieldByName(oCampoValidacao.DataField).AsString))
  then
    exit;
  // Se o valor do field do campo2 estiver vazio
  if (not oCampoComparacao.DataSource.DataSet.Active) or (not oCampoComparacao.Visible) or
    (IsNull(oCampoComparacao.DataSource.DataSet.FieldByName(oCampoComparacao.DataField).AsString))
  then
    exit;

  if oCampoValidacao.Value <= oCampoComparacao.Value then
  begin
    MostraMensagem(n_avMsgDataDeveSerSuperiorOutraData, sComplementoMensagem,
      oCampoValidacao.Owner);
    DefineFoco(oCampoValidacao);
    Abort;
  end;
end;

// 14/07/2011 - CassianoM - SALT: 88247/4 - Validar apenas as datas visíveis na tela.
procedure ValidaDataMaiorOuIgual(poCampoValidacao, poCampoComparacao: TspDateTimeCombo;
  psComplementoMensagem: string = '');
begin
  // Se o valor do field do campo1 estiver vazio
  if (not poCampoValidacao.DataSource.DataSet.Active) or (not poCampoValidacao.Visible) or
    (IsNull(poCampoValidacao.DataSource.DataSet.FieldByName(poCampoValidacao.DataField).AsString))
  then
    exit;
  // Se o valor do field do campo2 estiver vazio
  if (not poCampoComparacao.DataSource.DataSet.Active) or (not poCampoComparacao.Visible) or
    (IsNull(poCampoComparacao.DataSource.DataSet.FieldByName(
    poCampoComparacao.DataField).AsString))
  then
    exit;

  if poCampoValidacao.Value < poCampoComparacao.Value then
  begin
    MostraMensagem(n_avMsgDataSuperiorOuIgualOutraData, psComplementoMensagem,
      poCampoValidacao.Owner);
    DefineFoco(poCampoValidacao);
    Abort;
  end;
end;

function VerificaDiretorioMapeado(sCaminho: string; sLetraUnidade: char): boolean;
begin
  result := AnsiUpperCase(getNetworkMap(sLetraUnidade)) = AnsiUpperCase(sCaminho);
end;

function MapeiaUnidadeRede(sLetraUnidade, sCaminho, sUsuario, sSenha: string;
  oFormPai: TComponent): boolean;
var
  NR: TNetResource;
  Res: cardinal;
  Drive: array[0..100] of char;
  Path: array[0..100] of char;
  sDirMapeamento: string;

begin
  result := False;
  sDirMapeamento := getNetworkMap(sLetraUnidade[1]);

  if DirectoryExists(sLetraUnidade + '\') then
  begin
    if AnsiUpperCase(sDirMapeamento) = AnsiUpperCase(sCaminho) then
    begin
      result := True;
      Exit;
    end
    else
      DesmapeiaUnidadeRede(sLetraUnidade);
  end;

  if NotNull(sCaminho) and NotNull(sUsuario) and NotNull(sSenha) then
  begin
    FillChar(NR, SizeOf(NR), 0);

    NR.dwType := RESOURCETYPE_DISK;
    NR.lpProvider := nil;

    NR.lpLocalName := StrPCopy(Drive, sLetraUnidade);
    NR.lpRemoteName := StrPCopy(Path, sCaminho);

    Res := WNetAddConnection2(NR, PChar(sSenha), PChar(sUsuario), 0);

    result := Res = 0;

    if Res <> 0 then
      mostraMensagem(n_avMsgErroMapeamentoUnidadeRede, sLetraUnidade, oFormPai);
  end
  else
    mostraMensagem(n_avMsgSemConfiguracaoMapeamento, '', oFormPai);
end;

function MapeiaUnidadeRedeServidor(psUnidade, psCaminho, psUsuario, psSenha: string;
  var psMsgErro: string): boolean;
var
  NR: TNetResource;
  Res: cardinal;
  Drive: array[0..100] of char;
  Path: array[0..100] of char;
  sDirMapeamento: string;

begin
  psMsgErro := '';
  result := False;
  sDirMapeamento := getNetworkMap(psUnidade[1]);

  if DirectoryExists(psUnidade + '\') then
  begin
    if AnsiUpperCase(sDirMapeamento) = AnsiUpperCase(psCaminho) then
    begin
      result := True;
      Exit;
    end
    else
      DesmapeiaUnidadeRede(psUnidade);
  end;

  if NotNull(psCaminho) and NotNull(psUsuario) and NotNull(psSenha) then
  begin
    FillChar(NR, SizeOf(NR), 0);

    NR.dwType := RESOURCETYPE_DISK;
    NR.lpProvider := nil;

    NR.lpLocalName := StrPCopy(Drive, psUnidade);
    NR.lpRemoteName := StrPCopy(Path, psCaminho);

    Res := WNetAddConnection2(NR, PChar(psSenha), PChar(psUsuario), 0);

    result := Res = 0;

    if Res <> 0 then
      psMsgErro := TextoDaMensagem(ncdSG5, n_avMsgErroMapeamentoUnidadeRede, psUnidade);
  end
  else
    psMsgErro := TextoDaMensagem(ncdSG5, n_avMsgSemConfiguracaoMapeamento);
end;

procedure ValidaParametro(nParametro: integer; oFormPai: TComponent);
begin
  if IsNull(spParamSistema.AsString(nParametro, gnCdPrmSG5)) then
  begin
    mostraMensagem(n_avMsgParametroNaoPreenchido, IntToStr(nParametro), oFormPai);
    Abort;
  end;
end;

function DesmapeiaUnidadeRede(sLetraUnidade: string): boolean;
var
  Res: cardinal;
  Buff: array[0..255] of char;

begin
  StrPCopy(Buff, sLetraUnidade);
  Res := WNetCancelConnection2(Buff, CONNECT_UPDATE_PROFILE, True);

  result := Res = 0;
end;

{ Tsg5Cache }

procedure Tsg5Cache.addItem(item: Tsg5ItemCache);
begin
  FItens.add(item);
end;

procedure Tsg5Cache.Clear;
var
  nCont: integer;

begin
  // Para evitar Memory Leak, antes de limpar os itens libero a memória
  // utilizada. Isso devia ser feito pelo Delphi
  for nCont := FItens.Count - 1 downto 0 do
    Tsg5ItemCache(FItens.items[nCont]).Free;

  FItens.Clear;
end;

constructor Tsg5Cache.Create;
begin
  FItens := TList.Create; //PC_OK
end;

procedure Tsg5Cache.customSetItem(index: integer; const Value: Tsg5ItemCache);
begin
  Tsg5ItemCache(FItens[index]).Assign(Value);
end;

procedure Tsg5Cache.delItem(index: integer);
begin
  // Apaga um item. Antes de limpá-la, libera a memória utilizada para evitar
  // Memory Leak
  if (FItens.Count > 0) and (index > -1) and (FItens.Count > index) then
  begin
    Tsg5ItemCache(FItens.items[index]).Free;
    FItens.Delete(index);
  end;
end;

destructor Tsg5Cache.Destroy;
begin
  inherited;

  Clear;
  FreeAndNil(FItens); //PC_OK
end;

function Tsg5Cache.getFItem(index: integer): Tsg5ItemCache;
begin
  result := FItens[index];
end;

function Tsg5Cache.getRegrasCount: integer;
begin
  result := FItens.Count;
end;

procedure Tsg5Cache.setFItem(index: integer; const Value: Tsg5ItemCache);
begin
  customSetItem(index, Value);
end;

function retornaNewValueSeExistir(newValue, oldValue: variant): variant;
begin
  if (not varIsEmpty(newValue)) and (not varIsNull(newValue)) then
    result := newValue
  else if (not varIsEmpty(oldValue)) and (not varIsNull(oldValue)) then
    result := oldValue
  else
    result := null;
end;

function retornaNewValueSeExistirField(oCDS: TClientDataSet; nmField: string): variant;
begin
  result := retornaNewValueSeExistir(oCDS.FieldByName(nmField).newValue,
    oCDS.FieldByName(nmField).oldValue);
end;

function mascaraNumeroProcesso(nuProcesso: string; nuNivelDepend: integer): string;
begin
  result := fillZeros(nuProcesso, 12);
  result := copy(result, 1, 3) + '.' + copy(result, 4, 2) + '.' + copy(result, 6, 6) +
    '-' + copy(result, 12, 1);

  // Se existir dependência, então exibe qual é o dependente que está na pauta
  if nuNivelDepend > 0 then
    result := result + '/' + fillZeros(IntToStr(nuNivelDepend), 5);
end;

function MascaraProcesso(psNuProcesso, psCdProcesso: string;
  pbFormatoAntigoSAJ: boolean = False): string;
begin
  if pbFormatoAntigoSAJ then
  begin
    result := FillZeros(psNuProcesso, 12);
    result := Copy(result, 1, 3) + '.' + Copy(result, 4, 2) + '.' + Copy(result, 6, 6) +
      '-' + Copy(result, 12, 1);
  end
  else
  begin
    // CassianoM - 17/06/2010 - "NNNNNNN-DD.AAAA.J.TR.OOOO" - Nova máscara conforme Resolução 65
    result := FillZeros(psNuProcesso, 20);
    result := Copy(result, 1, 7) + '-' + Copy(result, 8, 2) + '.' + Copy(result, 10, 4) +
      '.' + Copy(result, 14, 1) + '.' + Copy(result, 15, 2) + '.' + Copy(result, 17, 4);
  end;

  if (Copy(psCdProcesso, 10, 4) <> '0000') then
    result := result + '/' + FillZeros(Base36ToBase10(Copy(psCdProcesso, 10, 4)), 5);
end;

function MascaraProcessoUnificado(psNuProcesso, psCdProcesso: string;
  psFormaTramita: string = ''): string;
begin
  // CassianoM - 17/06/2010 - "NNNNNNN-DD.AAAA.J.TR.OOOO" - Nova máscara conforme Resolução 65
  result := FillZeros(psNuProcesso, 20);
  result := Copy(result, 1, 7) + '-' + Copy(result, 8, 2) + '.' + Copy(result, 10, 4) +
    '.' + Copy(result, 14, 1) + '.' + Copy(result, 15, 2) + '.' + Copy(result, 17, 4);

  if (Copy(psCdProcesso, 10, 4) <> '0000') and (psFormaTramita <> sTpFormaTramitaApartado) then
    result := result + '/' + FillZeros(Base36ToBase10(Copy(psCdProcesso, 10, 4)), 5);
end;

// 14/07/2011 - junior.goulart - SALT: 88080/1
// Retornar no SQL nuProcesso no Formato - "NNNNNNN-DD.AAAA.J.TR.OOOO" - Máscara da Resolução 65
function RetornarProcessoMascaradoServidor: string;
begin
  result := FSQL.substring('nuProcesso', 1, 7) + FSql.ConcatenaCom + '''-'' ' +
    FSql.ConcatenaCom + '' + FSQL.substring('nuProcesso', 8, 2) + FSql.ConcatenaCom +
    '''.'' ' + FSql.ConcatenaCom + '' + FSQL.substring('nuProcesso', 10, 4) +
    FSql.ConcatenaCom + '''.'' ' + FSql.ConcatenaCom + '' + FSQL.substring('nuProcesso', 14, 1) +
    FSql.ConcatenaCom + '''.'' ' + FSql.ConcatenaCom + '' + FSQL.substring('nuProcesso', 15, 2) +
    FSql.ConcatenaCom + '''.'' ' + FSql.ConcatenaCom + '' + FSQL.substring('nuProcesso', 17, 4);
end;

function MascaraProcessoData(pvDados: olevariant;
  psNmCampoNuProcesso, psNmCampoCdProcesso: string): olevariant;
var
  ocdsDados: TspClientDataSet;
  sCdProcesso: string;
  sNuProcesso: string;
  sBookMark: string;
begin
  //jcf:format=off
  //Claudinei - 10/10/2008
  //Objetivo: formatar o campo nuProcesso de um DataSet
  //Parametros: 1. pvDados: Deve possuir os camposnuProcesso e cdProcesso
  //            2. psNmCampoNuProcesso: Nome do campo nuProcesso que está no DataSet
  //            3. psNmCampoCdProcesso: Nome do campo cdProcesso que está no DataSet
  //jcf:format=on

  ocdsDados := TspClientDataSet.Create(nil);
  try
    ocdsDados.Data := pvDados;
    sBookMark := ocdsDados.Bookmark;
    ocdsDados.DisableControls;
    ocdsDados.First;
    while not ocdsDados.EOF do
    begin
      if not (ocdsDados.State in dsEditModes) then
        ocdsDados.Edit;

      sCdProcesso := ocdsDados.FieldByName(psNmCampoCdProcesso).AsString;
      sNuProcesso := ocdsDados.FieldByName(psNmCampoNuProcesso).AsString;
      sNuProcesso := MascaraProcesso(sNuProcesso, sCdProcesso);
      ocdsDados.FieldByName(psNmCampoNuProcesso).AsString := sNuProcesso;
      ocdsDados.Next;
    end;
  finally
    ocdsDados.MergeChangeLog;
    ocdsDados.CancelUpdates;
    ocdsDados.Bookmark := sBookmark;
    ocdsDados.EnableControls;
    result := ocdsDados.Data;

    FreeAndNil(ocdsDados);
  end;
end;

function MascaraProcessoDataUnificado(pvDados: olevariant;
  psNmCampoNuProcesso, psNmCampoCdProcesso: string;
  const psNmCampoTpFormaTramita: string = ''): olevariant;
var
  ocdsDados: TspClientDataSet;
  sCdProcesso: string;
  sNuProcesso: string;
  sTpFormaTramita: string;
  sBookMark: string;

begin
  //jcf:format=off
  //Claudinei - 10/10/2008
  //Objetivo: formatar o campo nuProcesso de um DataSet
  //Parametros: 1. pvDados: Deve possuir os camposnuProcesso e cdProcesso
  //            2. psNmCampoNuProcesso: Nome do campo nuProcesso que está no DataSet
  //            3. psNmCampoCdProcesso: Nome do campo cdProcesso que está no DataSet
  //jcf:format=on

  ocdsDados := TspClientDataSet.Create(nil);
  try
    ocdsDados.Data := pvDados;
    sBookMark := ocdsDados.Bookmark;
    ocdsDados.DisableControls;
    ocdsDados.First;
    while not ocdsDados.EOF do
    begin
      if not (ocdsDados.State in dsEditModes) then
        ocdsDados.Edit;
      sTpFormaTramita := '';

      sCdProcesso := ocdsDados.FieldByName(psNmCampoCdProcesso).AsString;
      sNuProcesso := ocdsDados.FieldByName(psNmCampoNuProcesso).AsString;

      if notNull(psNmCampoTpFormaTramita) and
        Assigned(ocdsDados.FindField(psNmCampoTpFormaTramita)) then
        sTpFormaTramita := ocdsDados.FieldByName(psNmCampoTpFormaTramita).AsString;
      sNuProcesso := MascaraProcessoUnificado(sNuProcesso, sCdProcesso, sTpFormaTramita);
      ocdsDados.FieldByName(psNmCampoNuProcesso).AsString := sNuProcesso;
      ocdsDados.Next;
    end;
  finally
    ocdsDados.MergeChangeLog;
    ocdsDados.CancelUpdates;
    ocdsDados.Bookmark := sBookmark;
    ocdsDados.EnableControls;
    result := ocdsDados.Data;

    FreeAndNil(ocdsDados);
  end;
end;


function calculaHashAssinaturaDigitalSessaoEletronica(dataHora: TDateTime;
  nuSeqSessao, cdForo, cdVara, cdMagistrado, cdTipoVoto: integer;
  cdProcesso, cdUsuario, nuCPF, nmProprietario, nmCertificadora: string): string;
begin
  result := AnsiUpperCase(EncriptadoParaHexa(
    HashMD5String(formatDateTime('yyyy-mmm-dd-hh:nn', dataHora) + IntToStr(nuSeqSessao) +
    IntToStr(cdForo) + IntToStr(cdVara) + IntToStr(cdTipoVoto) + IntToStr(cdMagistrado) +
    cdProcesso + ansiLowerCase(cdUsuario) + AnsiUpperCase(cdUsuario) +
    ansiLowerCase(nmProprietario) + AnsiUpperCase(nmProprietario) +
    ansiLowerCase(nmCertificadora) + AnsiUpperCase(nmCertificadora))));
end;

function validaCalculoHashAssinaturaDigitalSessaoEletronica(dataHora: TDateTime;
  nuSeqSessao, cdForo, cdVara, cdMagistrado, cdTipoVoto: integer;
  cdProcesso, cdUsuario, nuCPF, nmProprietario, nmCertificadora, hash: string): boolean;
begin
  result := AnsiUpperCase(hash) = calculaHashAssinaturaDigitalSessaoEletronica(
    dataHora, nuSeqSessao, cdForo, cdVara, cdMagistrado, cdTipoVoto, cdProcesso,
    cdUsuario, nuCPF, nmProprietario, nmCertificadora);
end;

procedure AdicionaAtributoProjecao(psCampo: string; oConjuntoDados: TspConjuntoDados);
var
  oCampo: TStringList;
  nCont: integer;
begin
  { Método criado pela necessidade de se adicionar mais campos na projeção de
  um conjunto de dados que já existe a projeção montada. }

  oCampo := TStringList.Create;

  try
    oCampo.CommaText := psCampo;

    for nCont := 0 to oCampo.Count - 1 do
    begin
      if IsNull(oConjuntoDados.spProjecao) then
      begin
        oConjuntoDados.spProjecao := oCampo.Strings[nCont];
      end
      else
      begin
        if Pos(oCampo.Strings[nCont], oConjuntoDados.spProjecao) = 0 then
        begin
          oConjuntoDados.spProjecao := oConjuntoDados.spProjecao + ', ' + oCampo.Strings[nCont];
        end;
      end;
    end;
  finally
    oCampo.Free;
  end;
end;

function ColocaAspasListaIn(psLista: string): string;
begin
{
  Função para formatar uma listagem com aspas. Exemplo de listagem para tipo de
  movimentação (alfanumérico).
  Ex: 703, 705, 708, 709
  Resulttado: '703', '705', '708', '709'
}
  psLista := psLista + ',';

  while psLista <> '' do
  begin
    result := result + Copy(psLista, 0, Pos(',', psLista) - 1) + ''', ''';
    psLista := Trim(Copy(psLista, Pos(',', psLista) + 1, Length(psLista)));
  end;

  result := '''' + Copy(result, 0, Length(result) - 4) + '''';
end;

//SALT: 61635/1 - 03/02/2010 - Claudinei
//Distribuição para vaga inativa deve ter a identificação 'Distribuído na vaga <nome desenb...>'
function PegarDistVaga(psAliasDist: string): string;
var
  sDistribuidoVaga: string;
begin
  if (psAliasDist <> '') then
  begin
    //SALT: 90215/7 - Claudinei - 09/2011
    sDistribuidoVaga := '''' + sDISTRIBUIDO_NA_VAGA + ' ' + '''';
    result := 'CASE WHEN (select  tdis1.cdCaractTipoDist from efpgTipoDistrib tdis1' +
      ' where tdis1.cdTipoDistrib = ' + psAliasDist + '.cdTipoDistrib ) = ' +
      IntToStr(nCDCARACT_TIPODIST_PREVENCAO_MAG_VAGA_INATIVA) + ' then ' +
      sDistribuidoVaga + ' else '''' ' + ' end ' + FSQL.ConcatenaCom;

    //result := 'CASE WHEN ' + psAliasDist + '.cdTipoDistrib  = ' +
    //  IntToStr(nDISTRIBXXX_PREVENCAOMAGISTRADOVAGAINATIVA) + ' then ' + sDistribuidoVaga +
    //  ' else '''' ' + ' end ' + FSQL.ConcatenaCom;
  end
  else
    result := STRING_INDEFINIDO;
end;

//SALT: 62028/1 - 12/03/2010 - Claudinei
//Apresentar o cargo para magistrado substituto
function PegarCargoMagistrado(psAliasCargo: string): string;
begin
  if (psAliasCargo <> '') then
    result := psAliasCargo + '.deTipoAgente' + FSQL.ConcatenaCom + ''' ''' + FSQL.ConcatenaCom
  else
    result := STRING_INDEFINIDO;
end;


// 28/02/2012 - Uba - SALT 103649/1.
(* Foi alterada a rotina abaixo para comportar-se conforme o parâmetro 58149, onde este parâmetro
   irá definir a ordem do juíz titular e substituto e o texto entre estes juízes.
   Veja dois exemplos:
   <<JUIZ SUBSTITUTO>> em substituição ao magistrado(a) <<JUIZ TITULAR>>
   <<JUIZ TITULAR>> substituído(a) por <<JUIZ SUBSTITUTO>> *)

(* function RetornaColunaNomeAgenteSubstituto(psAliasAgente, psAliasAgenteTitular: string;
  pbUtilizaAliasCampo: boolean = True; psAliasDist: string = '';
  psAliasCargo: string = ''): string;

  function PegarTextoSubstituto: string;
  var
    sTextoSubstituto: string;
  begin
    sTextoSubstituto := spParamSistema.AsString(prmTextoSubstituicao, gnCdPrmSG5);
    result := FSQL.ConcatenaCom + ''' ''' + FSQL.ConcatenaCom + Aspas(sTextoSubstituto) +
      FSQL.ConcatenaCom + ''' ''' + FSQL.ConcatenaCom;
  end;

begin
  result := PegarDistVaga(psAliasDist) + ' (CASE WHEN ' + psAliasAgenteTitular +
    '.CDAGENTE is not null ' + 'and ' + psAliasAgente + '.CDAGENTE <> ' +
    psAliasAgenteTitular + '.CDAGENTE THEN ' + RetornaColunaNomeAgente(psAliasAgente, False) +
    PegarTextoSubstituto + PegarCargoMagistrado(psAliasCargo) +
    RetornaColunaNomeAgente(psAliasAgenteTitular, False) + ' ELSE ' +
    RetornaColunaNomeAgente(psAliasAgente, False);

  result := result + ' END )';

  if pbUtilizaAliasCampo then
    result := result + ' AS NMAGENTE';
end; *)

function RetornaColunaNomeAgenteSubstituto(psAliasAgente, psAliasAgenteTitular: string;
  pbUtilizaAliasCampo: boolean = True; psAliasDist: string = '';
  psAliasCargo: string = ''): string;
var
  sAgenteFrente: string; // 23/04/2012 - Uba - SALT 106793/1.
  sAliasFrente, sAliasDepois: string;
  sTextoEmSubstituicao: string;

  procedure DefinirAliasFrenteDepoisTextoEmSubstituicao;
  var
    sParametro: string;
    sAux: string;
    nAuxInicioTagDeletar: integer;
    nTamanhoTagDeletar: integer;
  begin
    sAgenteFrente := STRING_INDEFINIDO;
    sAliasFrente := STRING_INDEFINIDO;
    sAliasDepois := STRING_INDEFINIDO;
    sTextoEmSubstituicao := STRING_INDEFINIDO;
    sParametro := spParamSistema.AsString(prmOrdemMagistradosTitularSubstitutoTextoSubstituicao,
      gnCdPrmSG5);

    //verifica se o 1º agente será o titular.
    sAux := Copy(sParametro, 0, 16);
    if sAux = sTAG_JUIZ_TITULAR then
    begin
      sAgenteFrente := sTAG_JUIZ_TITULAR;
      sAliasFrente := psAliasAgenteTitular;
      sAliasDepois := psAliasAgente;
    end
    else
    begin
      //verifica se o 1º agente será o substituto.
      sAux := Copy(sParametro, 0, 19);
      if sAux = sTAG_JUIZ_SUBSTITUTO then
      begin
        sAgenteFrente := sTAG_JUIZ_SUBSTITUTO;
        sAliasFrente := psAliasAgente;
        sAliasDepois := psAliasAgenteTitular;
      end;
    end;

    if (sAliasFrente <> STRING_INDEFINIDO) and (sAliasDepois <> STRING_INDEFINIDO) then
    begin
      //pegar o texto em substituição.
      //deletando as tag's do parâmetro, restando apenas o texto entre o nome dos juízes.
      //deletando a tag do juíz titular.
      nAuxInicioTagDeletar := pos(sTAG_JUIZ_TITULAR, sParametro);
      nTamanhoTagDeletar := length(sTAG_JUIZ_TITULAR);
      if nAuxInicioTagDeletar > 0 then
        Delete(sParametro, nAuxInicioTagDeletar, nTamanhoTagDeletar);
      //deletando a tag do juíz substituto.
      nAuxInicioTagDeletar := pos(sTAG_JUIZ_SUBSTITUTO, sParametro);
      nTamanhoTagDeletar := length(sTAG_JUIZ_SUBSTITUTO);
      if nAuxInicioTagDeletar > 0 then
        Delete(sParametro, nAuxInicioTagDeletar, nTamanhoTagDeletar);

      sTextoEmSubstituicao := Trim(sParametro);
    end
    else
    begin
      //valores padrão caso o parâmetro 58149 tenha sido informado incorretamente.
      sAliasFrente := psAliasAgente;
      sAliasDepois := psAliasAgenteTitular;
      sTextoEmSubstituicao := 'em substituição ao magistrado(a)';
    end;
  end;

  function PegarTextoSubstituto: string;
  var
    sTextoSubstituto: string;
  begin
    //sTextoSubstituto := spParamSistema.AsString(prmTextoSubstituicao, gnCdPrmSG5);
    sTextoSubstituto := sTextoEmSubstituicao;
    result := FSQL.ConcatenaCom + ''' ''' + FSQL.ConcatenaCom + Aspas(sTextoSubstituto) +
      FSQL.ConcatenaCom + ''' ''' + FSQL.ConcatenaCom;
  end;

begin
  DefinirAliasFrenteDepoisTextoEmSubstituicao;

  // 23/04/2012 - Uba - SALT 106793/1.
  //criada a variável sAgenteFrente para controlar em que momento irá apresentar o nome do cargo
  //do magistrado titular (antes do 1º agente ou no 2º agente).
  if sAgenteFrente = sTAG_JUIZ_SUBSTITUTO then
  begin
    result := PegarDistVaga(psAliasDist) + ' (CASE WHEN ' + psAliasAgenteTitular +
      '.CDAGENTE is not null ' + 'and ' + psAliasAgente + '.CDAGENTE <> ' +
      psAliasAgenteTitular + '.CDAGENTE THEN ' + RetornaColunaNomeAgente(sAliasFrente, False) +
      PegarTextoSubstituto + PegarCargoMagistrado(psAliasCargo) +
      RetornaColunaNomeAgente(sAliasDepois, False) + ' ELSE ' +
      RetornaColunaNomeAgente(psAliasAgente, False);
  end
  else //sTAG_JUIZ_TITULAR
  begin
    result := PegarDistVaga(psAliasDist) + ' (CASE WHEN ' + psAliasAgenteTitular +
      '.CDAGENTE is not null ' + 'and ' + psAliasAgente + '.CDAGENTE <> ' +
      psAliasAgenteTitular + '.CDAGENTE THEN ' + PegarCargoMagistrado(psAliasCargo) +
      RetornaColunaNomeAgente(sAliasFrente, False) + PegarTextoSubstituto +
      RetornaColunaNomeAgente(sAliasDepois, False) + ' ELSE ' +
      RetornaColunaNomeAgente(psAliasAgente, False);
  end;

  result := result + ' END )';

  if pbUtilizaAliasCampo then
    result := result + ' AS NMAGENTE';
end;

function RetornaColunaNomeAgente(psAlias: string = ''; pbUtilizaAliasCampo: boolean = True;
  psAliasDist: string = ''): string;
begin
  psAlias := psAlias + IIF(NotNull(psAlias), '.', '');

  if spParamSistema.AsString(prmUtilizaNomeRegimental, gnCdPrmSG5) = 'S' then
  begin
    result := PegarDistVaga(psAliasDist) + ' (CASE WHEN ' + psAlias + 'CDTIPOAGENTE IN (' +
      IntToStr(nCdDesembargador) + ', ' + IntToStr(nCdJuiz2Grau) + ', ' +
      IntToStr(nCdJuizCooperador) + ') THEN ' + '(CASE WHEN ' + psAlias +
      'NMRESUMIDO IS NULL OR ' + psAlias + 'NMRESUMIDO = ' + Aspas('') + ' THEN ' +
      psAlias + 'NMAGENTE ELSE ' + psAlias + 'NMRESUMIDO END) ELSE ' + psAlias +
      'NMAGENTE END) AS NMAGENTE';
  end
  else
    result := PegarDistVaga(psAliasDist) + IIF(IsNull(psAlias), 'NMAGENTE',
      IIF(Pos('.', psAlias) = 0, Trim(psAlias) + '.NMAGENTE', Trim(psAlias) + 'NMAGENTE'));

  if (not pbUtilizaAliasCampo) and (Pos('AS NMAGENTE', result) > 0) then
    result := Trim(Copy(result, 0, Pos('AS NMAGENTE', result) - 1));
end;

function IncluirClasseSQL(Classe: string): string;
var
  i, nClasse: integer;
  sClasse: string;
begin
  sClasse := '';
  if Classe <> '' then
  begin
    nClasse := ContaItemStr(Classe, '&');
    if nClasse = 0 then
      sClasse := 'and DC.cdClasse in (' + Classe + ')'
    else
    begin
      sClasse := ' and (';
      for i := 1 to nClasse do
      begin
        sClasse := sClasse + ' DC.cdClasse in (' + ItemStr(Classe, '&', i) + ')';
        if i < nClasse then
          sClasse := sClasse + ' or ';
      end;
      sClasse := sClasse + ')';
    end;
  end;
  result := sClasse;
end;

procedure ConfiguraLayoutBotoesProcesso(sajNumeroProcesso: TsajNumeroProcesso);
var
  nDeslocamento: integer;
begin
  nDeslocamento := sajNumeroProcesso.lbRotulo.Width;

  if sajNumeroProcesso.imSegredoJustica.Visible then
  begin
    sajNumeroProcesso.imSegredoJustica.Left := nDeslocamento;
    nDeslocamento := nDeslocamento + sajNumeroProcesso.imSegredoJustica.Width;
  end;

  if sajNumeroProcesso.FpbApresentarUltimoNumero.Visible then
  begin
    sajNumeroProcesso.FpbApresentarUltimoNumero.Left := nDeslocamento;

    nDeslocamento := nDeslocamento + sajNumeroProcesso.FpbApresentarUltimoNumero.Width;
  end;

  if sajNumeroProcesso.FpbPendencias.Visible then
  begin
    sajNumeroProcesso.FpbPendencias.Left := nDeslocamento;
  end;
end;

function criaListaSeparadaPorVirgulaStrings(oLista: TStrings; bColocarParticulaE: boolean;
  pbQuebrarLinha: boolean = False): WideString;
var
  i: integer;

begin
  result := '';

  for i := 0 to oLista.Count - 1 do
  begin
    result := result + oLista.strings[i];

    if pbQuebrarLinha then
    begin
      result := result + #13 + #10;
    end
    else
    begin
      if (i = oLista.Count - 2) and bColocarParticulaE then
        result := result + ' e '
      else if i < oLista.Count - 1 then
        result := result + ', ';
    end;
  end;
end;

function criaListaSeparadaPorVirgulaDataSet(oCDS: TClientDataset; sColuna: string;
  bColocarParticulaE: boolean): WideString;
var
  oLista: TStringList;

begin
  oLista := TStringList.Create;
  try
    oCDS.First;
    while not oCDS.EOF do
    begin
      oLista.add(oCDS.FieldByName(sColuna).AsString);

      oCDS.Next;
    end;

    result := criaListaSeparadaPorVirgulaStrings(oLista, bColocarParticulaE);
  finally
    oLista.Clear;
    oLista.Free;
  end;
end;

function criaListaSeparadaPorVirgulaQuery(oQY: TspQuery; sColuna: string;
  bColocarParticulaE: boolean; pbQuebrarLinha: boolean = False): WideString;
var
  oLista: TStringList;

begin
  oLista := TStringList.Create;
  try
    oQY.First;
    while not oQY.EOF do
    begin
      oLista.add(oQY.FieldByName(sColuna).AsString);

      oQY.Next;
    end;

    result := criaListaSeparadaPorVirgulaStrings(oLista, bColocarParticulaE, pbQuebrarLinha);
  finally
    oLista.Clear;
    oLista.Free;
  end;
end;

procedure retiraReadOnlyDoGrid(oGrid: TspGridFiltro; sListaColunasManterSL: string);
var
  i: integer;
  oLista: TStringList;

begin
  oLista := TStringList.Create;
  try
    oLista.commaText := sListaColunasManterSL;

    // Remove o readOnly do grid filtro
    oGrid.ReadOnly := False;

    // Remove o readOnly do dataset ligado ao grid filtro
    if assigned(oGrid.dataSource) and assigned(oGrid.dataSource.dataSet) then
    begin
      TspClientDataSet(oGrid.dataSource.dataSet).ReadOnly := False;

      // Remove o readOnly dos fields do dataset do grid filtro
      for i := 0 to TspClientDataSet(oGrid.dataSource.dataSet).Fields.Count - 1 do
        TspClientDataSet(oGrid.dataSource.dataSet).Fields[i].ReadOnly := False;
    end;

    // Remove o readOnly das colunas do grid filtro
    for i := 0 to oGrid.Columns.Count - 1 do
    begin
      if assigned(oGrid.Columns[i].field) then
        oGrid.Columns[i].field.ReadOnly := False;

      oGrid.Columns[i].ReadOnly := False;
    end;

    // Remove o readOnly do grid associado ao grid filtro
    if assigned(oGrid.spDBGrid) then
    begin
      // Remove o readOnly do grid
      oGrid.spDBGrid.ReadOnly := False;

      // Remove o readOnly do dataset ligado ao grid
      if assigned(oGrid.spDBGrid.dataSource) and assigned(oGrid.spDBGrid.dataSource.dataSet) then
      begin
        TspClientDataSet(oGrid.spDBGrid.dataSource.dataSet).ReadOnly := False;

        // Remove o readOnly dos fields do dataset do grid
        for i := 0 to TspClientDataSet(oGrid.spDBGrid.dataSource.dataSet).Fields.Count - 1 do
          TspClientDataSet(oGrid.spDBGrid.dataSource.dataSet).Fields[i].ReadOnly := False;
      end;

      // Remove o readOnly das colunas do grid
      for i := 0 to oGrid.spDBGrid.Columns.Count - 1 do
      begin
        if assigned(oGrid.spDBGrid.Columns[i].field) then
          oGrid.spDBGrid.Columns[i].field.ReadOnly := False;

        if oLista.indexOf(IntToStr(I)) > -1 then
          oGrid.spDBGrid.Columns[i].ReadOnly := True
        else
          oGrid.spDBGrid.Columns[i].ReadOnly := False;
      end;
    end;
  finally
    oLista.Clear;
    oLista.Free;
  end;
end;

procedure CompactarArquivo(psArquivoCompactar: string; psNmArquivoZip: string;
  pbApagarArquivoOriginal: boolean = True);
var
  oZip: TedtZip;
  oArquivos: TStringList;
begin
  if (IsNull(psArquivoCompactar)) or (IsNull(psNmArquivoZip)) then
  begin
    if not spAplicacao.spEstaNoServidor then
      spAbort
    else
      Abort;
  end;

  oZip := TedtZip.Create;
  oArquivos := TStringList.Create;

  try
    oZip.AdicioneArquivo(psArquivoCompactar);
    oZip.sArquivoZip := psNmArquivoZip;
    oZip.Compacte;
  finally
    if pbApagarArquivoOriginal then
    begin
      oZip.DeleteArquivos(True, False);
    end;

    oZip.Free;
    oArquivos.Free;
  end;
end;

function InteiroValidoString(psInteiro: string): boolean;
var
  nValor: integer;
  nPosicaoErro: integer;
begin
  Val(psInteiro, nValor, nPosicaoErro);
  result := ((nPosicaoErro = 0) and ((nValor = 0) or (nValor <> 0)));
end;

procedure exportaDadosDataSet(oDataSet: TClientDataSet; sIndexName, sNomeArquivo: string);
var
  i: integer;
  oTexto: textFile;
  sTexto: string;

begin
  assignFile(oTexto, sNomeArquivo);
  try
    rewrite(oTexto);

    sTexto := '';

    for i := 0 to oDataSet.FieldCount - 1 do
      sTexto := sTexto + oDataSet.fields[i].fieldName + ';';

    Delete(sTexto, length(sTexto), 1);
    writeLn(oTexto, sTexto);

    if notNull(sIndexName) then
      oDataSet.indexFieldNames := sIndexName;

    oDataSet.First;
    while not oDataSet.EOF do
    begin
      sTexto := '';

      for i := 0 to oDataSet.FieldCount - 1 do
        sTexto := sTexto + oDataSet.fields[i].AsString + ';';

      Delete(sTexto, length(sTexto), 1);
      writeLn(oTexto, sTexto);

      oDataSet.Next;
    end;

    oDataSet.First;
  finally
    closeFile(oTexto);
  end;
end;

function getNetworkMap(drive: char): string;
var
  sNetPath: string;
  dwMaxNetPathLen: DWord;

begin
  result := '';
  dwMaxNetPathLen := MAX_PATH;
  SetLength(sNetPath, dwMaxNetPathLen);

  if (NO_ERROR = Windows.WNetGetConnection(PChar('' + upperCase(drive) + ':'),
    PChar(sNetPath), dwMaxNetPathLen)) then
    result := StrPas(PChar(sNetPath));
end;

function GetNetworkDriveMappings(lista: TStrings): integer;
var
  i: integer;
  sResult: string;

begin
  lista.Clear;

  for i := 0 to 25 do
  begin
    sResult := getNetworkMap(Chr(65 + i));

    if notNull(sResult) then
      lista.Add(Chr(65 + i) + ': ' + sResult);
  end;

  result := lista.Count;
end;

procedure ExecutaConsulta(oConjuntoDados: TspConjuntoDados;
  sField, sValor, sMaisCondicoes: WideString);
begin
  oConjuntoDados.spCondicao.Clear;
  oConjuntoDados.spCondicao.Add(sField + ' = ' + Aspas(sValor));

  if NotNull(sMaisCondicoes) then
    oConjuntoDados.spCondicao.Add(sMaisCondicoes);

  oConjuntoDados.Consulta;
end;

procedure AtualizaCampoChave(oConjuntoDados: TspConjuntoDados; sField, sValor: WideString);
begin
  oConjuntoDados.Edit;
  oConjuntoDados.FieldByName(sField).AsString := sValor;
  oConjuntoDados.Post;

  oConjuntoDados.Salve;
end;

function ProcessoEhMigrado(psTpOrigemMigracao: string): boolean;
begin
  result := not (StrToChar(AnsiUpperCase(psTpOrigemMigracao)) in [sORIGEM_SG, sORIGEM_SG3]);
end;

function FormataDataHora(pdtReferencia: TDateTime; pbMaiorHoraDia: boolean): TDateTime;
var
  nAno, nMes, nDia: word;
begin
  DecodeDate(pdtReferencia, nAno, nMes, nDia);

  if pbMaiorHoraDia then
    result := EncodeDate(nAno, nMes, nDia) + EncodeTime(23, 59, 59, 0)
  else
    result := EncodeDate(nAno, nMes, nDia);
end;

function ValidaFaixaPesquisaAcordao(sNuFaixaInicial, sNuFaixaFinal: string): boolean;
begin
  result := True;

  if NotNull(sNuFaixaInicial) and NotNull(sNuFaixaFinal) then
    result := ((StrToFloat(sNuFaixaFinal) - StrToFloat(sNuFaixaInicial)) <
      nFaixaLimiteConsultaComParametros);
end;

function ValidaPeriodoPesquisaAcordao(sDtInicial, sDtFinal: string): boolean;
begin
  result := True;

  if NotNull(sDtInicial) and NotNull(sDtFinal) then
    result := ((StrToDateTime(sDtFinal) - StrToDateTime(sDtInicial)) < nNumeroMaxDiasComParametro);
end;

procedure CriaCotas(var pcdsCota: TspClientDataSet);
begin
  pcdsCota.Close;
  pcdsCota.FieldDefs.Clear;

  pcdsCota.FieldDefs.Add('nuCota', ftString, 4);
  pcdsCota.FieldDefs.Add('deCota', ftString, 60);

  pcdsCota.CreateDataSet;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,5';
  pcdsCota['deCota'] := '2 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,34';
  pcdsCota['deCota'] := '3 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,25';
  pcdsCota['deCota'] := '4 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,2';
  pcdsCota['deCota'] := '5 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,17';
  pcdsCota['deCota'] := '6 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,15';
  pcdsCota['deCota'] := '7 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,13';
  pcdsCota['deCota'] := '8 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,12';
  pcdsCota['deCota'] := '9 para 1';
  pcdsCota.Post;

  pcdsCota.Insert;
  pcdsCota['nuCota'] := '0,1';
  pcdsCota['deCota'] := '10 para 1';
  pcdsCota.Post;
end;

{ Incrementa o número em base 36. }
function IncB36(const psNuB36: string; pnLen: integer): string;
begin
  result := FillZeros(Base10ToBase36(FloatToStr(StrToFloat(Base36ToBase10(psNuB36)) + 1)), pnLen);
end;

function PossuiRegistro(poDataSet: TClientDataSet): boolean;
begin
  result := (poDataSet.Active) and (poDataSet.RecordCount > 0);
end;

function NumeroSubProcesso(psCdProcesso: string): integer;
begin
  result := StrToInt(FillZeros(Base36ToBase10(Copy(psCdProcesso, 10, 4)), 5));
end;

procedure AjustaLayoutSpConsulta(oCampoCodigo: TspCampoMascara; oCampoDescricao: TspCampo;
  oBotaoConsulta: TspBotaoConsulta);
begin
  oCampoCodigo.Left := 0;
  oCampoDescricao.Left := oCampoCodigo.Width;
  oBotaoConsulta.Left := oCampoCodigo.Width + oCampoDescricao.Width + 2;
end;

function DataTotalmentePorExtenso(nData: TDateTime; bPrefixo: boolean = False): string;
var
  nDia, nMes, nAno: word;

  function ObtemPrefixo: string;
  begin
    if bPrefixo then
    begin
      if nDia = 1 then
        result := 'No '
      else
        result := 'Aos ';
    end
    else
      result := '';
  end;

begin
  DecodeDate(nData, nAno, nMes, nDia);

  result := ObtemPrefixo + NumeroPorExtenso(VarToFloat(nDia)) + ' de ' +
    NomeMes(nMes) + ' de ' + NumeroPorExtenso(VarToFloat(nAno));
end;

function HoraPorExtenso(nHora: TDateTime; psformato: string = STRING_INDEFINIDO): string;
var
  Hour, Min, Sec, MSec: word;
  lsFormato: TStringList;
  sAux: string;
  x: integer;

begin
  DecodeTime(nHora, Hour, Min, Sec, MSec);
  if psformato = STRING_INDEFINIDO then
  begin
    result := IntToStr(hour) + iif(Hour = 1, ' hora', ' horas');
    if min > 0 then
      result := result + ' e ' + IntToStr(min) + iif(min = 1, ' minuto', ' minutos');
  end
  else
  begin
    result := '';
    lsFormato := TStringList.Create;
    try
      sAux := psformato + ' ';
      while pos(' ', sAux) <> 0 do
      begin
        lsFormato.Add(Copy(sAux, 1, pos(' ', sAux) - 1));
        Delete(sAux, 1, pos(' ', sAux));
      end;

      for x := 0 to lsFormato.Count - 1 do
      begin
        if lsFormato[x] = '$h' then  // FORMATO DE HORA NUMÉRICA "1"
          result := result + IntToStr(hour)
        else if lsFormato[x] = '$hh' then  // FORMATO DE HORA NUMÉRICA 2 CARACTERES "01"
          result := result + FormatFloat('00', hour)
        else if lsFormato[x] = '$hhhh' then // FORMATO DE HORA EXTENSO "vinte e um"
          result := result + NumeroPorExtenso(hour)
        else if lsFormato[x] = '$m' then  // FORMATO DE MINUTO NUMÉRICO "1"
          result := result + IntToStr(min)
        else if lsFormato[x] = '$mm' then // FORMATO DE MINUTO NUMÉRICO 2 CARACTERES "01"
          result := result + FormatFloat('00', min)
        else if lsFormato[x] = '$mmmm' then // FORMATO DE MINUTO POR EXTENSO "vinte e um"
          result := result + NumeroPorExtenso(min)

        else if lsFormato[x][1] <> '$' then // NÃO TEM FORMATO (CARACTERES DE CONCATENAÇÃO)
          result := result + lsFormato[x];
        // SE AINDA NÃO FOR FIM ENTÃO " "
        if x < lsFormato.Count - 1 then
          result := result + ' ';
      end;
    finally
      FreeAndNil(lsFormato);
    end;
  end;
end;

function HoraTotalmentePorExtenso(nHora: TDateTime): string;
var
  Hour, Min, Sec, MSec: word;

begin
  DecodeTime(nHora, Hour, Min, Sec, MSec);

  result := NumeroPorExtenso(VarToFloat(Hour)) + iif(Hour = 1, ' hora', ' horas');

  if Min > 0 then
    result := result + ' e ' + NumeroPorExtenso(VarToFloat(Min)) +
      iif(min = 1, ' minuto', ' minutos');
end;

function RetornarValoresMultiplaSelecao(const poCdsDados: TspClientDataSet;
  const psNomeCampo: string): string;
var
  oCdsClone: TspClientDataSet;
begin
  result := STRING_INDEFINIDO;

  if not poCdsDados.Active then
  begin
    Exit;
  end;

  oCdsClone := TspClientDataSet.Create(nil);

  try
    oCdsClone.CloneCursor(poCdsDados, False, False);
    oCdsClone.First;
    result := oCdsClone.FieldByName(psNomeCampo).AsString;
    oCdsClone.Next;

    while not oCdsClone.EOF do
    begin
      result := result + ', ' + oCdsClone.FieldByName(psNomeCampo).AsString;
      oCdsClone.Next;
    end;
  finally
    oCdsClone.Free;
  end;
end;

// 16/01/2012 - Anderson Roberto Monzani - SAC: 100716/1 - SG
// Função para concatenar vários campos com opção de formatação de máscara.
// Por enquanto só existe formatação para número do lote
function RetornarValoresMultiplaSelecao(const poCdsDados: TspClientDataSet;
  psListaCampos, psSeparador, psTipoFormato: string): string;

  function FormatarCampo(const psTexto, psTipoFormato: string): string;
  var
    sTexto: string;
  begin
    sTexto := psTexto;
    if psTipoFormato = 'Lote' then
    begin
      sTexto := copy(sTexto, 0, Length(sTexto) - 4) + '.' + copy(sTexto, Length(sTexto) - 3, 4);
    end;
    result := sTexto;
  end;

var
  oCdsClone: TspClientDataSet;
  oCampos: TStringList;
  oSeparador: TStringList;
  oFormato: TStringList;
  nContador: integer;
begin
  oCampos := TStringList.Create;
  oSeparador := TStringList.Create;
  oFormato := TStringList.Create;

  result := STRING_INDEFINIDO;

  if not poCdsDados.Active then
  begin
    Exit;
  end;

  oCdsClone := TspClientDataSet.Create(nil);

  try
    oCampos.CommaText := psListaCampos;
    oSeparador.CommaText := psSeparador;
    oformato.CommaText := psTipoFormato;

    oCdsClone.CloneCursor(poCdsDados, False, False);
    oCdsClone.First;

    for nContador := 0 to oCampos.Count - 1 do
    begin
      result := result + FormatarCampo(oCdsClone.FieldByName(oCampos.Strings[nContador]).AsString,
        oformato.Strings[nContador]);
      if (nContador < (oCampos.Count - 1)) then
        result := result + oSeparador.Strings[nContador];
    end;

    oCdsClone.Next;

    while not oCdsClone.EOF do
    begin
      result := result + ', ';
      for nContador := 0 to oCampos.Count - 1 do
      begin
        result := result + FormatarCampo(oCdsClone.FieldByName(
          oCampos.Strings[nContador]).AsString,
          oformato.Strings[nContador]);
        if (nContador < (oCampos.Count - 1)) then
          result := result + oSeparador.Strings[nContador];
      end;
      oCdsClone.Next;
    end;
  finally
    oCdsClone.Free;
    oCampos.Free;
    oSeparador.Free;
    oformato.Free;
  end;
end;
//--------------------------------------------------------------------------------

//SALT: 55712/1 - 22/06/2010 - Claudinei - R65
//function GetProcessoMaster(psCdProcesso: string): string;
//begin
//  result := Copy(psCdProcesso, 1, 9) + '0000';
//end;

function RemoveCaracter(psValor, psCaracter: string): string;
var
  nTamCaracter: integer;
  nContCaracter: integer;
  sCaracter: string;
  nTam: integer;
  nPos: integer;

begin
  if psCaracter <> '' then
  begin
    nTamCaracter := Length(psCaracter);
    for nContCaracter := 1 to nTamCaracter do
    begin
      sCaracter := psCaracter[nContCaracter];
      nPos := Pos(sCaracter, psValor);
      while nPos > 0 do
      begin
        nTam := Length(psValor);
        if nPos = 1 then
          Delete(psValor, 1, 1)
        else if nPos = nTam then
          Delete(psValor, nTam, 1)
        else if (psValor[nPos - 1] in ['0'..'9']) and (psValor[nPos + 1] in ['0'..'9']) then
          Delete(psValor, nPos, 1)
        else
          Delete(psValor, nPos, 1);

        nPos := Pos(sCaracter, psValor);
      end;
    end;
  end;

  result := psValor;
end;

procedure ValidaHorarioCritico(poFormPai: TComponent);
var
  sHrInicio: string;
  sHrFinal: string;

  dtIncio: TDateTime;
  dtFinal: TDateTime;

begin
  dtIncio := 0;
  dtFInal := 0;

  ValidaParametro(prmHorarioInicioCriticoSistema, poFormPai);
  ValidaParametro(prmHorarioFinalCriticoSistema, poFormPai);

  try
    sHrInicio := spParamSistema.AsString(prmHorarioInicioCriticoSistema, gnCdPrmSG5);
    sHrFinal := spParamSistema.AsString(prmHorarioFinalCriticoSistema, gnCdPrmSG5);

    dtIncio := StrToDateTime(DateToStr(DataDoBanco) + sHrInicio + ':00');
    dtFinal := StrToDateTime(DateToStr(DataDoBanco) + sHrFinal + ':00');
  except
    mostraMensagem(n_avMsgAvisoGeralParaComponentes,
      'Não foi possível verificar o horário critico do sistema. ' +
      'Verifique a configuração dos parâmetros ' + IntToStr(prmHorarioInicioCriticoSistema) +
      ' e ' + IntToStr(prmHorarioFinalCriticoSistema), poFormPai);
  end;

  if (DataDoBancoComHora > dtIncio) and (DataDoBancoComHora < dtFinal) then
  begin
    mostraMensagem(n_avMsgAvisoGeralParaComponentes,
      'Esta operação não pode ser executada no momento devido horário crítico do sistema. ' +
      'Por favor execute novamente fora do seguinte horário: ' + sHrInicio + ' às ' +
      sHrFinal, poFormPai);
    Abort;
  end;
end;

function HorarioEhCritico(poFormPai: TComponent): boolean;
var
  sHrInicio: string;
  sHrFinal: string;

  dtIncio: TDateTime;
  dtFinal: TDateTime;

begin
  result := True;

  try
    sHrInicio := spParamSistema.AsString(prmHorarioInicioCriticoSistema, gnCdPrmSG5);
    sHrFinal := spParamSistema.AsString(prmHorarioFinalCriticoSistema, gnCdPrmSG5);

    dtIncio := StrToDateTime(DateToStr(DataDoBanco) + sHrInicio + ':00');
    dtFinal := StrToDateTime(DateToStr(DataDoBanco) + sHrFinal + ':00');

    result := (DataDoBancoComHora > dtIncio) and (DataDoBancoComHora < dtFinal);
  except
    mostraMensagem(n_avMsgAvisoGeralParaComponentes,
      'Não foi possível verificar o horário critico do sistema. ' +
      'Verifique a configuração dos parâmetros ' + IntToStr(prmHorarioInicioCriticoSistema) +
      ' e ' + IntToStr(prmHorarioFinalCriticoSistema), poFormPai);
  end;
end;

//SALT: 51125/56 - 12/11/2009 - Claudinei
function ObtemListaCodigosAspas(oDataSet: TDataSet; sNmCampo: string;
  sNmCampoSel: string = ''; const pbSemAspasUnicoRegistro: boolean = False): string;
var
  oLista: TStringList;

begin
  result := STRING_INDEFINIDO;

  if oDataSet.active then
  begin
    oLista := TStringList.Create;
    try
      oDataSet.First;

      if (pbSemAspasUnicoRegistro) and (oDataSet.RecordCount = 1) then
        result := oDataSet.FieldByName(sNmCampo).AsString
      else
      begin
        while not oDataSet.EOF do
        begin
          if oDataSet.FieldByName(sNmCampo).AsString <> '' then
            if isNull(sNmCampoSel) or (notNull(sNmCampoSel) and
              (oDataSet.FieldByName(sNmCampoSel).AsString = 'S')) then
              oLista.add(chr(39) + oDataSet.FieldByName(sNmCampo).AsString + chr(39));

          oDataSet.Next;
        end;

        result := oLista.CommaText;
      end;
    finally
      oLista.Free;
    end;
  end
  else
    result := '';
end;

//SALT: 57985/1 - 27/11/2009 - Claudinei
function RetornarDescExigeRevisor(psFlExigeRevisor: string; psCdClasse: string): string;
var
  sLista: TStringList;

begin
  result := STRING_INDEFINIDO;

  sLista := TStringList.Create;
  try
    sLista.CommaText := spParamSistema.AsString(prmListaClasseApresentaTextoRevisor, gnCdPrmSG5);

    if (sLista.Count > 0) and (Pos(psCdClasse, sLista.CommaText) > 0) then
    begin
      if psFlExigeRevisor = 'S' then
        result := '(Com revisão)'
      else
        result := '(Sem revisão)';
    end;
  finally
    sLista.Free;
  end;
end;

// NyR - 11.12.2009 - Monta Lista de Parametros "IN" para spCondicao.
function ListaParametros(pnmParametro: string; var poListaParametros: TStringList): string;
var
  nIdx: integer;
begin
  result := '';

  for nIdx := 0 to poListaParametros.Count - 1 do
    result := result + ':' + pnmParametro + IntToStr(nIdx + 1) + ',';

  Delete(result, Length(result), 1);
end;

function FormatarHora(pvHora: variant): string;
var
  sHoras: string;
  sMinutos: string;

begin
  if (Length(pvHora) < 3) or (Length(pvHora) > 4) then
    result := ''
  else
  begin
    if Length(pvHora) = 4 then
    begin
      sHoras := Copy(pvHora, 1, 2);
      sMinutos := Copy(pvHora, 3, 2);
    end
    else
    begin
      sHoras := '0' + Copy(pvHora, 1, 1);
      sMinutos := Copy(pvHora, 2, 2);
    end;

    result := sHoras + ':' + sMinutos + ':00';
  end;
end;

// NyR - 04.11.09 - Para realizar a Pesquisa na EsajVara pela informação de FlVirtual
procedure IdentificarSistemaDigital;
var
  esajVara: TesajVara;
  lstVara: TStringList;
  nIdx: integer;

begin
  gbSistemaDigital := False;
  if (sajLotacaoUsuario <> nil) then
  begin
    // CREATE / TRY / SPPROJECAO
    esajVara := TesajVara.Create(nil);
    lstVara := TStringList.Create;
    try
      esajVara.spProjecao := 'cdForo, cdVara, flVirtual';

      if (sajLotacaoUsuario.TipoLotacao = tlVara) then
      begin
        esajVara.spCondicao.Text := 'cdForo = :cdForo and cdVara = :cdVara';
        esajVara.DefineFiltroCondicao('cdForo', sajLotacaoUsuario.nCdForo);
        esajVara.DefineFiltroCondicao('cdVara', sajLotacaoUsuario.nCdLocalLotacao);
        esajVara.Consulta;

        gbSistemaDigital := esajVara.FieldByName('flVirtual').AsString = 'S';
      end
      else
      if sajLotacaoUsuario.TipoLotacao in [tlJuiz, tlCartorio, tlDistribuidor] then
      begin
        lstVara.CommaText := sajLotacaoUsuario.ListaLocaisLotacao(tlVara);
        if lstVara.Text <> STRING_INDEFINIDO then
        begin
          esajVara.spCondicao.Text := 'cdForo = :cdForo and cdVara in (' +
            ListaParametros('cdVara', lstVara) + ') and flVirtual = ''N''';
          esajVara.DefineFiltroCondicao('cdForo', sajLotacaoUsuario.nCdForo);
          for nIdx := 0 to lstVara.Count - 1 do
            esajVara.DefineFiltroCondicao('cdVara' + IntToStr(nIdx + 1), StrToInt(lstVara[nIdx]));
          esajVara.Consulta;

          gbSistemaDigital := esajVara.Active and (esajVara.RecordCount = 0);
        end;
      end;
    finally
      esajVara.Close;
      FreeAndNil(lstVara);
      FreeAndNil(esajVara);
    end;
  end;
end;

procedure AtualizarPropriedadesComponentes(poForm: TWinControl; poDadosConfigLayout: olevariant);
var
  oParent: TWinControl;
  oComponent: TComponent;
  oCDS: TspClientDataSet;

begin
  oCDS := TspClientDataSet.Create(nil);
  try
    oCDS.Data := poDadosConfigLayout;

    if oCDS.IsEmpty then
      Exit;

    oCDS.IndexFieldNames := 'NMPARENT; NUORDEMTAB; NMCOMPONENTE';

    oCDS.First;
    while not oCDS.EOF do
    begin
      oComponent := poForm.FindComponent(oCDS.FieldByName('NMCOMPONENTE').AsString);

      if not Assigned(oComponent) then
      begin
        oComponent := poForm.FindComponent(oCDS.FieldByName('NMPARENT').AsString);

        if Assigned(oComponent) then
          oComponent := oComponent.FindComponent(oCDS.FieldByName('NMCOMPONENTE').AsString);
      end;

      if Assigned(oComponent) then
      begin
        oParent := TwinControl(poForm.FindComponent(oCDS.FieldByName('NMPARENT').AsString));
        if oComponent is TControl then
        begin
          if NotNull(oCDS.FieldByName('FLVISIVEL').AsString) then
            TControl(oComponent).Visible := oCDS.FieldByName('FLVISIVEL').AsString = 'S';
          if NotNull(oCDS.FieldByName('NUTOPO').AsString) then
            TControl(oComponent).Top := oCDS.FieldByName('NUTOPO').AsInteger;
          if NotNull(oCDS.FieldByName('NUESQUERDA').AsString) then
            TControl(oComponent).Left := oCDS.FieldByName('NUESQUERDA').AsInteger;
          if NotNull(oCDS.FieldByName('NULARGURA').AsString) then
            TControl(oComponent).Width := oCDS.FieldByName('NULARGURA').AsInteger;
          if NotNull(oCDS.FieldByName('NUALTURA').AsString) then
            TControl(oComponent).Height := oCDS.FieldByName('NUALTURA').AsInteger;
          if NotNull(oCDS.FieldByName('FLHABILITADO').AsString) then
            TControl(oComponent).Enabled := oCDS.FieldByName('FLHABILITADO').AsString = 'S';

          if Assigned(oParent) then
            TControl(oComponent).Parent := oParent;
        end;

        if (oComponent is TspConsulta) and
          NotNull(oCDS.FieldByName('NULARGURASPCONS').AsString) then
          TspConsulta(oComponent).spWidthDesc := oCDS.FieldByName('NULARGURASPCONS').AsInteger;

        if NotNull(oCDS.FieldByName('DEROTULO').AsString) then
        begin
          if oComponent is TLabel then
            TLabel(oComponent).Caption := oCDS.FieldByName('DEROTULO').AsString;

          if (oComponent is TCheckBox) or (oComponent is TDBCheckBox) then
            TCheckBox(oComponent).Caption := oCDS.FieldByName('DEROTULO').AsString;

          if oComponent is TGroupBox then
            // 08/07/2011 - Jonas - SALT 87860/1.
            TGroupBox(oComponent).Caption :=
              ' ' + Trim(oCDS.FieldByName('DEROTULO').AsString) + ' ';

          if oComponent is TspConsulta then
            TspConsulta(oComponent).spRotulo := oCDS.FieldByName('DEROTULO').AsString;

          // 23/02/2011 - rduarte - SAC: 79490/1
          if oComponent is TRadioButton then
            TRadioButton(oComponent).Caption := oCDS.FieldByName('DEROTULO').AsString;
        end;

        if (oComponent is TWinControl) and (NotNull(oCDS.FieldByName('NUORDEMTAB').AsString)) then
          TWinControl(oComponent).TabOrder := oCDS.FieldByName('NUORDEMTAB').AsInteger;

        if (oComponent is TTabSheet) and (NotNull(oCDS.FieldByName('FLVISIVEL').AsString)) then
          TTabSheet(oComponent).TabVisible := oCDS.FieldByName('FLVISIVEL').AsString = 'S';
      end;

      oCDS.Next;
    end;
  finally
    FreeAndNil(oCDS);
  end;
end;

function DataPorExtensoComNumeros(nData: TDateTime; bPrefixo: boolean = False): string;
var
  nDia, nMes, nAno: word;

  function ObtemPrefixo: string;
  begin
    if bPrefixo then
    begin
      if nDia = 1 then
        result := 'No '
      else
        result := 'Aos ';
    end
    else
      result := '';
  end;

begin
  DecodeDate(nData, nAno, nMes, nDia);
  result := ObtemPrefixo + varToStr(nDia) + ' dias do mês de ' + NomeMes(nMes) +
    ' do ano de ' + varToStr(nAno);
end;

// 23/05/2011 - Jonas - SALT 70977/99.
//função que retorna data por extenso, podendo selecionar qual parte da data será
//em formato numérico, e qual será em formato de string.
function DataComSelecaoExtenso(nData: TDateTime; bPrefixo: boolean = False;
  bDiaExtenso: boolean = True; bMesExtenso: boolean = True; bAnoExtenso: boolean = True;
  const sEntreDiaMes: string = ' dias do mês de ';
  const sEntreMesAno: string = ' do ano de '): string;
var
  nDia, nMes, nAno: word;

  function ObtemPrefixo: string;
  begin
    if bPrefixo then
    begin
      if nDia = 1 then
        result := 'No '
      else
        result := 'Aos ';
    end
    else
      result := '';
  end;

  function GetDia: string;
  begin
    if bDiaExtenso then
      result := NumeroPorExtenso(VarToFloat(nDia))
    else
      result := VarToStr(nDia);
  end;

  function GetMes: string;
  begin
    if bMesExtenso then
      result := NomeMes(nMes)
    else
      result := VarToStr(nMes);
  end;

  function GetAno: string;
  begin
    if bAnoExtenso then
      result := NumeroPorExtenso(VarToFloat(nAno))
    else
      result := VarToStr(nAno);
  end;

begin
  DecodeDate(nData, nAno, nMes, nDia);
  result := ObtemPrefixo + GetDia + sEntreDiaMes + GetMes + sEntreMesAno + GetAno;
end;


{ SAC: 51125/25 - rduarte - 18/11/2009 - Deve ser criado um parâmetro para as turmas de recurso para
  que apareça o termo Promotor na lugar de Procurador. }
function RetornarRotuloProcurador(const psTextoFormatar: string;
  const pbMaisculo: boolean = False): string;
var
  sParametroProcurador: string;
begin
  sParametroProcurador := Trim(IIF(pbMaisculo,
    AnsiUpperCase(spParamSistema.AsString(prmRotuloProcurador, gnCdPrmSG5)),
    spParamSistema.AsString(prmRotuloProcurador, gnCdPrmSG5)));

  result := IIF(IsNull(sParametroProcurador), psTextoFormatar,
    StringReplace(psTextoFormatar, 'Procurador', sParametroProcurador,
    [rfReplaceAll, rfIgnoreCase]));
end;

function MontarIndiceSQL(const psSQL: string; const psNmIndice: string): string;
begin
  result := psSQL;

  if Pos(psNmIndice, psSQL) > 0 then
  begin
    result := StringReplace(psSQL, psNmIndice, 'with (index (' + psNmIndice +
      '))', [rfReplaceAll]);
  end;
end;

// 19/04/2010 - rduarte - SAC: 64207/1
function ColocarEspacoListaIn(const psLista: string): string;
var
  sLista: string;
begin
  sLista := Trim(psLista) + ',';

  while sLista <> '' do
  begin
    result := result + Copy(sLista, 0, Pos(',', sLista) - 1) + ', ';
    sLista := Trim(Copy(sLista, Pos(',', sLista) + 1, Length(sLista)));
  end;

  result := Copy(result, 0, Length(result) - 2);
end;

// 26/05/2010 - rduarte - SAC: 66170/1
function RetornarAddTabelaPublicacao(const psNmTabela, psAliasTabela, psLinkedServer: string;
  const paTipoBanco: TspTipoBanco): string;
begin
  // Falta realizar tratamento para DB2.

  if paTipoBanco = tbSQLServer then
    result := psLinkedServer + '.' + psNmTabela + ' ' + psAliasTabela;

  if paTipoBanco = tbOracle then
    result := psNmTabela + psLinkedServer + ' ' + psAliasTabela;
end;

function RetornarAnoNumeroUnificado(psNuProcesso: string): integer;
begin
  try
    result := StrToInt(Copy(psNuProcesso, 10, 4));
  except
    result := NUMERO_INDEFINIDO;
  end;
end;

function ValidarDigitoVerificador(psNumeroProcesso: string; psSiglaCliente: string;
  const pnTribunalCliente: integer = NUMERO_INDEFINIDO): boolean;
var
  nNNNNNNN, nDD, nAAAA, nJTR, nOOOO: integer;

begin
  if (pnTribunalCliente <> NUMERO_INDEFINIDO) and (IsNull(psSiglaCliente)) then
    nJTR := 800 + pnTribunalCliente
  else
    nJTR := 800 + StrToInt(RetornaTRDoCliente(psSiglaCliente));

  nNNNNNNN := StrToInt(Copy(psNumeroProcesso, 1, 7));
  nDD := StrToInt(Copy(psNumeroProcesso, 8, 2));
  nAAAA := StrToInt(Copy(psNumeroProcesso, 10, 4));
  nOOOO := StrToInt(Copy(psNumeroProcesso, 17, 4));
  result := ValidaModulo97(nNNNNNNN, nDD, nAAAA, nJTR, nOOOO);
end;

function NumeroProcessoEhProvisorio(psNuProcesso: string): boolean;
begin
  result := Copy(psNuProcesso, 1, 1) = '9';
end;

function GerarNumeroProcessoUnificado(pnAno: integer; pnNuProtocolo: double;
  pnCdForo: integer; psTrCliente: string): string;
begin
  result := FillZeros(FloatToStr(pnNuProtocolo), 7) + Modulo97(Trunc(pnNuProtocolo),
    pnAno, 800 + StrToInt(psTrCliente), pnCdForo) + FillZeros(IntToStr(pnAno), 4) +
    '8' + psTrCliente + FillZeros(IntToStr(pnCdForo), 4);
end;

function RetornarNomeFormCadastro(psNuProcesso, psCdProcessoPrinc, psFlTipoClasse,
  psFlExcepcional: string): string;
begin
  result := STRING_INDEFINIDO;

  if NotNull(psCdProcessoPrinc) then
    result := sFRM_002_CADPETICAO
  else
  if psFlTipoClasse = sCdTpClasse2GrauRecurso then
  begin
    result := sFRM_001_CADPROCESSORECURSO;

    if psFlExcepcional = 'S' then
      result := sFRM_025_CADPROCESSORECURSOEXCEPCIONAL;
  end
  else
  begin
    result := sFRM_024_CADPROCESSOORIGINARIO;

    if psFlExcepcional = 'S' then
      result := sFRM_026_CADPROCESSOORIGINARIOEXCEPCIONAL;
  end;
end;

// 29/06/2010 - rduarte - SAC: 55712/1
function RetornarColunaNuOutroNumero(const psAliasTabelaProcesso: string;
  const psNomeColunaRetorno: string = ''; const pbRetornarNumeroFormatado: boolean = True): string;
var
  sCampoOutroNumero: string;
  sNomeColunaRetorno: string;
begin
  sCampoOutroNumero := IIF(pbRetornarNumeroFormatado, 'nuOutroNumeroForm', 'nuOutroNumero');

  sNomeColunaRetorno := IIF(NotNull(psNomeColunaRetorno), psNomeColunaRetorno,
    'CC_nuOutroNumeroForm');

  //16/08/2012 - Anderson Roberto Monzani - SALT: 116281/1
  // Faltou filtrar a subquery pelo tipo de numero antigo
  // 22/05/2012 - junior.goulart - SALT: 109058/1
  // SQL revisado para retornar apenas 1 registro para não ter problemas em subquerys
  //jcf:format=off
  result :=
    'coalesce( ' +
    '   (SELECT ' +
    '     ' + sCampoOutroNumero +
    '   FROM ' +
    '     efpgOutroNumero ONU' +
    '   WHERE ' +
    '      cdProcesso = ' + psAliasTabelaProcesso + '.cdProcesso and ' +
    '      tpNumeroAntigo = ' + Aspas(sTPOUTRONUMEROSAJ) + ' and ' +
    '      nuseqoutronumero = (select max(nuSeqOutroNumero) ' +
    '      from efpgoutronumero where cdprocesso = ONU.cdprocesso and tpNumeroAntigo = ' + Aspas(sTPOUTRONUMEROSAJ) +')),' +

    '   (SELECT ' +
    '     ' + sCampoOutroNumero +
    '   FROM ' +
    '     efpgOutroNumero ONU' +
    '   WHERE ' +
    '      cdProcesso = ' + psAliasTabelaProcesso + '.cdProcesso and ' +
    '      tpNumeroAntigo = ' + Aspas(sTPOUTRONUMEROLEGADO) + ' and ' +
    '      nuseqoutronumero = (select min(nuSeqOutroNumero) ' +
    '      from efpgoutronumero where cdprocesso = ONU.cdprocesso and tpNumeroAntigo = ' + Aspas(sTPOUTRONUMEROLEGADO) +'))' +
    '   ) as ' + sNomeColunaRetorno + ',' +
    '   (SELECT ' +
    '     ' + sCampoOutroNumero +
    '   FROM ' +
    '     efpgOutroNumero ONU' +
    '   WHERE ' +
    '      cdProcesso = ' + psAliasTabelaProcesso + '.cdProcesso and ' +
    '      tpNumeroAntigo = ' + Aspas(sTPOUTRONUMEROLEGADO) + ' and ' +
    '      nuseqoutronumero = (select max(nuSeqOutroNumero) ' +
    '      from efpgoutronumero where cdprocesso = ONU.cdprocesso and tpNumeroAntigo = ' + Aspas(sTPOUTRONUMEROLEGADO) + ')) as nuNumeroLegado';
  //jcf:format=on
end;

function TotalDeParametros(psValor: string): integer;
var
  sLista: TStringList;

begin
  sLista := TStringList.Create;
  try
    sLista.CommaText := psValor;

    result := sLista.Count;
  finally
    sLista.Free;
  end;
end;

function WithIndex(psNmIndice: string; paTipoBanco: TspTipoBanco): string;
begin
  result := STRING_INDEFINIDO;

  if paTipoBanco = tbSQLServer then
    result := 'WITH (INDEX (' + psNmIndice + '))';
end;

function SepararListaVirgula(const psLista: string; const pbAspas: boolean = False): string;
var
  sLista: string;
begin
{
  Função para formatar uma listagem com aspas. Exemplo de listagem para tipo de
  movimentação (alfanumérico).
  Ex: 703, 705, 708, 709 (pbAspas = TRUE)
  Resulttado: '703', '705', '708', '709'
}
  sLista := psLista + ',';

  while sLista <> '' do
  begin
    result := result + Copy(sLista, 0, Pos(',', sLista) - 1) + IIF(pbAspas, ''', ''', ', ');
    sLista := Trim(Copy(sLista, Pos(',', sLista) + 1, Length(sLista)));
  end;

  if pbAspas then
    result := '''' + Copy(result, 0, Length(result) - 4) + ''''
  else
    result := Copy(result, 0, Length(result) - 2);
end;

// 04/08/2010 - rduarte - SAC: 66319/1
function FormatarNuEditalSemDje(const psNuEdital: string): string;
begin
  result := Copy(psNuEdital, 1, 4) + '.' + Copy(psNuEdital, 5, 6);
end;

function RetornarNomeFormEtiquetaAutuacao: string;
begin
  result := sFRM_607_RELETIQAUTUACAO;

  if NotNull(spParamSistema.AsString(prmNmTelaEtiquetaAutuacao, gnCdPrmSG5)) then
    result := spParamSistema.AsString(prmNmTelaEtiquetaAutuacao, gnCdPrmSG5);
end;


//insere aspas no parâmetro sTexto, e realiza o Trim no texto se bTrim = true
function AspasSG5(sTexto: string; const bTrim: boolean = True): string;
begin
  if (bTrim) then
    result := '''' + Trim(sTexto) + ''''
  else
    result := '''' + sTexto + '''';
end;

// 12/01/2011 - Jonas - SALT 77845/1.
procedure FecharDataSetsTela(poForm: TForm);
var
  nIdx: integer;

begin
  for nIdx := 0 to poForm.ComponentCount - 1 do
  begin
    if (poForm.Components[nIdx] is TspConjuntoDados) then
    begin
      if (poForm.Components[nIdx] as TspConjuntoDados).Active then
      begin
        (poForm.Components[nIdx] as TspConjuntoDados).CancelUpdates;
        (poForm.Components[nIdx] as TspConjuntoDados).MergeChangeLog;
        (poForm.Components[nIdx] as TspConjuntoDados).Cancel;
      end;
    end;
  end;
end;

// 09/12/2010 - Jonas - SALT 76404/1.
//retorna lista de órgãos julgadores para serem usados no select.
function RetornarListaOrgaosEstudo(): string;
var
  oLstOrgaosRecebeProcSemDistrib, oLstOrgaosPodeReceberProcesso: TStringList;
  oLstFinal: TStringList;
  sLstOrgaoRecebeProcSemDistrib, sLstOrgaoPodeReceberProcesso: string;
  bIncluiLista: boolean;
  n1, n2: integer;
  sRetorno: string;
begin
  oLstOrgaosRecebeProcSemDistrib := TStringList.Create;
  oLstOrgaosPodeReceberProcesso := TStringList.Create;
  oLstFinal := TStringList.Create;
  sLstOrgaoRecebeProcSemDistrib := STRING_INDEFINIDO;
  sLstOrgaoPodeReceberProcesso := STRING_INDEFINIDO;
  sRetorno := STRING_INDEFINIDO;

  try
    //parâmetro exclui órgãos do select
    if (NotNull(spParamSistema.AsString(prmLstOrgaoQueRecebemProcessosSemDistribuicao,
      gnCdPrmSG5))) then
      sLstOrgaoRecebeProcSemDistrib :=
        spParamSistema.AsString(prmLstOrgaoQueRecebemProcessosSemDistribuicao, gnCdPrmSG5);
    //parâmetro inclui órgãos no select
    if (NotNull(spParamSistema.AsString(prmLstOrgaosJulgPodemReceberProcEncaminhamentoDistrib,
      gnCdPrmSG5))) then
      sLstOrgaoPodeReceberProcesso :=
        spParamSistema.AsString(prmLstOrgaosJulgPodemReceberProcEncaminhamentoDistrib, gnCdPrmSG5);

    oLstOrgaosRecebeProcSemDistrib.CommaText := sLstOrgaoRecebeProcSemDistrib;
    oLstOrgaosPodeReceberProcesso.CommaText := sLstOrgaoPodeReceberProcesso;
    for n1 := 0 to oLstOrgaosRecebeProcSemDistrib.Count - 1 do
    begin
      bIncluiLista := True;
      for n2 := 0 to oLstOrgaosPodeReceberProcesso.Count - 1 do
      begin
        if (oLstOrgaosRecebeProcSemDistrib[n1] = oLstOrgaosPodeReceberProcesso[n2]) then
        begin
          bIncluiLista := False;
        end;
      end;
      if (bIncluiLista) then
        oLstFinal.Add(oLstOrgaosRecebeProcSemDistrib[n1]);
    end;

    sRetorno := oLstFinal.CommaText;
  finally
    FreeAndNil(oLstOrgaosRecebeProcSemDistrib);
    FreeAndNil(oLstOrgaosPodeReceberProcesso);
    FreeAndNil(oLstFinal);
  end;

  result := sRetorno;
end;

// 11/07/2011 - junior.goulart - SAC: 87858/1
function RetornaCondicaoTipoCartorio(pbUsarFaixa: boolean): string;
begin
  if pbUsarFaixa then
    result := 'cdTipoCartorio >= 500 and flForaUso = ' + Aspas('N')
  else
    result := 'flForaUso = ' + Aspas('N');
end;


// 19/05/2011 - Jonas - SALT 70977/15.
procedure DefineFocoAnterior(poForm: TForm; poCompAtual: TWinControl);
var
  i: integer;
  nTabOrderFocar: integer;
  oCompFocar: TWinControl;
  oParent: TWinControl;

  //achando componente anterior ao parente atual
  procedure AcharComponenteAnteriorParente;
  var
    ii: integer;
  begin
    if (oCompFocar = nil) then
    begin
      poCompAtual := oParent;
      nTabOrderFocar := poCompAtual.TabOrder - 1;
      oParent := poCompAtual.Parent;
      if (nTabOrderFocar >= 0) then
      begin
        for ii := 0 to poForm.ComponentCount - 1 do
        begin
          if ((poForm.Components[ii]) is TWinControl) and
            (TWinControl(poForm.Components[ii]).TabOrder = nTabOrderFocar) and
            (TWinControl(poForm.Components[ii]).Parent = oParent) and
            (TWinControl(poForm.Components[ii]).CanFocus) then
          begin
            oCompFocar := TWinControl(poForm.Components[ii]);
            Break;
          end;
        end;
      end;
    end;
  end;

  procedure VerificarComponenteIsParent;
  var
    iii: integer;
    nFoco: integer;
    oComp: TWinControl;
  begin
    nFoco := -1;
    oComp := nil;
    for iii := 0 to poForm.ComponentCount - 1 do
    begin
      if ((poForm.Components[iii]) is TWinControl) and
        (TWinControl(poForm.Components[iii]).Parent = oCompFocar) and
        (TWinControl(poForm.Components[iii]).TabOrder > nFoco) and
        (TWinControl(poForm.Components[iii]).CanFocus) then
      begin
        oComp := TWinControl(poForm.Components[iii]);
        nFoco := TWinControl(poForm.Components[iii]).TabOrder;
      end;
    end;
    if (oComp <> nil) then
      oCompFocar := oComp;
  end;

begin
  oCompFocar := nil;
  nTabOrderFocar := poCompAtual.TabOrder - 1;
  oParent := poCompAtual.Parent;
  if (nTabOrderFocar >= 0) then
  begin
    //achando componente dentro do mesmo painel
    for i := 0 to poForm.ComponentCount - 1 do
    begin
      if ((poForm.Components[i]) is TWinControl) and
        (TWinControl(poForm.Components[i]).TabOrder = nTabOrderFocar) and
        (TWinControl(poForm.Components[i]).Parent = oParent) and
        (TWinControl(poForm.Components[i]).CanFocus) then
      begin
        oCompFocar := TWinControl(poForm.Components[i]);
        Break;
      end;
    end;
    if (oCompFocar = nil) then
      AcharComponenteAnteriorParente;
  end
  else
    AcharComponenteAnteriorParente;

  if (oCompFocar <> nil) then
  begin
    VerificarComponenteIsParent;
    DefineFoco(oCompFocar);
  end;
end;

// 27/05/2011 - Jonas - SALT 70977/46.
procedure DefinirGrideZebrado(oGride: TspDBGrid); overload;
var
  oIni: TIniFile;
  sIntercalarCor: string;
  sCorGride: string;
  oCorGride: TColor;
begin
  oIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'spcfg.ini');
  try
    sCorGride := oIni.ReadString('CLIENTE', 'CorIntercalarGride', '');  
    sIntercalarCor := oIni.ReadString('CLIENTE', 'IntercalarCoresGride', '');

    oGride.spIntercalarCorGrid := sIntercalarCor = 'S';

    if not oGride.spIntercalarCorGrid then
      Exit;

    try
      oCorGride := StringToColor(sCorGride);
      oGride.spCorGridIntercalada := oCorGride;
    except
      oGride.spIntercalarCorGrid := False;
    end;
  finally
    FreeAndNil(oIni);
  end;
end;

// 27/05/2011 - Jonas - SALT 70977/46.
procedure DefinirGrideZebrado(oGride: TdxDBGrid); overload;
var
  oIni: TIniFile;
  sIntercalarCor: string;
  sCor: string;
  oCor: TColor;
begin
  //IntercalarCoresGride=S
  //CorIntercalarGride=$00C08000
  oIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'spcfg.ini');
  try
    sIntercalarCor := oIni.ReadString('CLIENTE', 'IntercalarCoresGride', '');
    sCor := oIni.ReadString('CLIENTE', 'CorIntercalarGride', '');

    oGride.spIntercalarCorGrid := sIntercalarCor = 'S';

    if oGride.spIntercalarCorGrid then
    begin
      try
        oCor := StringToColor(sCor);
        oGride.spCorGridIntercalada := oCor;
      except
        oGride.spIntercalarCorGrid := False;
      end;
    end;
  finally
    FreeAndNil(oIni);
  end;
end;

// 11/07/2011 - Jonas - SALT 72363/1.
//retorno: True (há diferenças); False (são iguais).
function VerificarValoresDiferentesDataSets(oCDS1, oCDS2: TClientDataSet): boolean;
var
  i: integer;
begin
  result := False;
  if (oCDS1.Active) and (oCDS2.Active) then
  begin
    //testa se total de campos dos dataSet's são diferentes.
    if oCDS1.RecordCount <> oCDS2.RecordCount then
      result := True
    else
    begin
      //testa se o nome dos fields dos dataSet's são diferentes.
      for i := 0 to oCDS1.fields.Count - 1 do
      begin
        if (oCDS1.Fields[i].FieldName <> oCDS2.Fields[i].FieldName) then
        begin
          result := True;
          Break;
        end
        else
          //testa se o valor dos fields dos dataSet's são diferentes.
        begin
          if (oCDS1.Fields[i].Value <> oCDS2.Fields[i].Value) then
          begin
            result := True;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

// 15/07/2011 - rduarte - SALT: 88294/1
function TestarPrecisaCriarTela(const psNmForm: string; var poForm: TspForm): boolean;
var
  nCont: integer;
begin
  result := True;
  poForm := nil;

  for nCont := Screen.FormCount - 1 downto 0 do
  begin
    if Screen.Forms[nCont].Name = psNmForm then
    begin
      result := False;
      poForm := TspForm(Screen.Forms[nCont]);
      Break;
    end;
  end;
end;

// 19/07/2011 - Jonas - SALT 77340/2/7.
(* parâmetros:
     -> poForm: formulário o qual será recalculado o height.
     -> poComponentes: array de componentes (TPanel, TGroupBox, etc) da tela, os quais serão
                       verificados se estão visíveis;  se sim, soma no height do formulário (poForm).
     -> pnAcrescentaHeightForm: height adicional a ser acrescentado na soma do height do formulário.
     -> pbAtualizarTopComponentes: irá atualizar o topo dos componentes (poComponentes) do formulário.
     -> pnAcrescentarEspacoEntreComponentes: valor a ser acrescentado entre o topo de um componente
                                             e outro.
*)
procedure AtualizarTopComponentesHeightTela(const poForm: TspForm;
  const poComponentes: array of TControl; const pnAcrescentarHeightForm: integer = 0;
  const pbAtualizarTopComponentes: boolean = False;
  const pnAcrescentarEspacoEntreComponentes: integer = 0);
var
  nHeightForm: integer;
  i: integer;
  nInicioComp, nFinalComp: integer;

  //ajusta o topo do componente recebido no parâmetro nIndiceComp.
  procedure AjustarTopoComponente(nIdxComp: integer);
  var
    y: integer;
    nIdxCompAcima: integer;
  begin
    //não atualiza o topo do 1º e do último componente.
    if (pbAtualizarTopComponentes) and (not (nIdxComp in [nInicioComp, nFinalComp])) then
    begin
      nIdxCompAcima := nInicioComp;
      //encontra o componente acima deste que encontra-se  visível.
      for y := nIdxComp downto nInicioComp do
      begin
        if poComponentes[y].Visible then
        begin
          nIdxCompAcima := y;
          Break;
        end;
      end;
      if (nIdxCompAcima <> nInicioComp) then
        poComponentes[nIdxComp].Top := poComponentes[nIdxCompAcima].Top +
          poComponentes[nIdxCompAcima].Height + pnAcrescentarEspacoEntreComponentes
      else
        //posiciona como o 1º componente da tela.
        poComponentes[nIdxComp].Top := poComponentes[nInicioComp].Top;
    end;
  end;

begin
  nInicioComp := low(poComponentes);
  nFinalComp := High(poComponentes);

  //calcular o height do formulário, pegando como base os componentes visíveis.
  nHeightForm := 0;
  for i := nInicioComp to nFinalComp do
  begin
    if (poComponentes[i].Visible) then
    begin
      nHeightForm := nHeightForm + poComponentes[i].Height + pnAcrescentarEspacoEntreComponentes;
      AjustarTopoComponente(i);
    end;
  end;
  nHeightForm := nHeightForm + pnAcrescentarHeightForm;
  poForm.Height := nHeightForm;
end;

// 21/07/2011 - Jonas - SALT 78684/1.
procedure AcresecentarItemVariavelEstiloLista(var sVarDestino: string;
  sValorSerAcresentado: string; const bNovoValorEntreAspas: boolean = True;
  const sSeparadorValor: string = ',');
begin
  if bNovoValorEntreAspas then
    sValorSerAcresentado := AspasSG5(sValorSerAcresentado);

  if sVarDestino = '' then
    sVarDestino := sValorSerAcresentado
  else
  begin
    sVarDestino := sVarDestino + sSeparadorValor + sValorSerAcresentado;
  end;
end;

// 09/08/2011 - CassianoM - SALT: 87959/1
procedure AlterarDescricaoTipoObjeto(poConjuntoDados: TspConjuntoDados;
  pnCdTipoObjeto: integer; psDeTipoObjeto: string);
var
  sCampoOrdem: string;
  nCdTipoObjeto: integer;

begin
  if not poConjuntoDados.Active then
    Exit;

  if poConjuntoDados.IsEmpty then
    Exit;

  sCampoOrdem := poConjuntoDados.IndexFieldNames;
  nCdTipoObjeto := poConjuntoDados.FieldByName('cdTipoObjeto').AsInteger;
  try
    if poConjuntoDados.Locate('cdTipoObjeto', pnCdTipoObjeto, []) then
    begin
      poConjuntoDados.Edit;
      poConjuntoDados.FieldByName('deTipoObjeto').AsString := psDeTipoObjeto;
      poConjuntoDados.Post;
    end;
  finally
    poConjuntoDados.IndexFieldNames := sCampoOrdem;
    poConjuntoDados.Locate('cdTipoObjeto', nCdTipoObjeto, []);
  end;
end;

function DefinirCaptionTela(psCaptionAtual: string; psTipoTela: string): string;
var
  sRetorno: string;
begin
  sRetorno := psCaptionAtual;
  if psTipoTela = sTIPO_TELA_TABELA_UNIFICADA then
    sRetorno := sRetorno + ' ' + sCAPTION_ADD_TELA_TABELA_UNIFICADA;
  result := sRetorno;
end;

// 31/08/2011 - rduarte - SALT: 91125/1
function ConfigurarDataSetCamposOrdenacaoAtividade900: olevariant;
var
  oCdsRetorno: TspClientDataSet;

  procedure CriarDataSet;
  begin
    oCdsRetorno.FieldDefs.Add('cdCodigo', ftString, 50);
    oCdsRetorno.FieldDefs.Add('deDescricao', ftString, 100);
    oCdsRetorno.CreateDataset;
    oCdsRetorno.LogChanges := False;
  end;

  procedure AdicionarRegistro(const psCodigo, psDescricao: string);
  begin
    oCdsRetorno.Append;
    oCdsRetorno.FieldByName('cdCodigo').AsString := psCodigo;
    oCdsRetorno.FieldByName('deDescricao').AsString := psDescricao;
    oCdsRetorno.Post;
  end;

begin
  oCdsRetorno := TspClientDataSet.Create(nil);

  try
    CriarDataSet;
    AdicionarRegistro('nuProcesso', 'Processo');
    AdicionarRegistro('CC_nuOrdemSessao', 'Ordem do Processo na Pauta Atual');
    AdicionarRegistro('nuProtocolo', 'Protocolo');
    AdicionarRegistro('deClasseConsulta', 'Classe');
    AdicionarRegistro('CC_relatorProcesso', 'Relator do processo');
    AdicionarRegistro('CC_revisorProcesso', 'Revisor do processo');
    AdicionarRegistro('CC_orgaoJulgador', 'Órgão julgador');

    result := oCdsRetorno.Data;
  finally
    oCdsRetorno.Free;
  end;
end;

// 12/09/2011 - Jonas - SALT 92067/1.
procedure DefinirOpcoesGerarRelatorio(poReportSystem: TspReportSystem;
  const pbPDF: boolean = False; const pbRTF: boolean = False;
  const pbRTFGrafico: boolean = False; const pbHTML: boolean = False;
  const pbXLS: boolean = False; const pbBinario: boolean = False;
  const pbSXC: boolean = False; const pbXML: boolean = False);
const
  faNenhum = 1;
  faRTF = 2;
  faHTML = 4;
  faXls = 8;
  faPDF = 16;
  faBinario = 32;
  faRTFGrafico = 64;
  faSxc = 128;
  faXML = 256;
  faTodos = 511;
var
  nOpcoes: integer;
begin
  poReportSystem.Tag := faNenhum;
  nOpcoes := 0;

  if pbPDF then
    nOpcoes := nOpcoes + faPDF;

  if pbRTF then
    nOpcoes := nOpcoes + faRTF;

  if pbRTFGrafico then
    nOpcoes := nOpcoes + faRTFGrafico;

  if pbHTML then
    nOpcoes := nOpcoes + faHTML;

  if pbXLS then
    nOpcoes := nOpcoes + faXLS;

  if pbBinario then
    nOpcoes := nOpcoes + faXLS;

  if pbSXC then
    nOpcoes := nOpcoes + faSxc;

  if pbXML then
    nOpcoes := nOpcoes + faXML;

  if nOpcoes <> 0 then
    poReportSystem.Tag := nOpcoes;
end;

// 22/09/2011 - rduarte - SALT: 91087/1
function CriarDataSetRejeitados: olevariant;
var
  oCdsRejeitados: TspClientDataSet;
begin
  oCdsRejeitados := TspClientDataSet.Create(nil);

  try
    oCdsRejeitados.FieldDefs.Add('cdProcesso', ftString, 13);
    oCdsRejeitados.FieldDefs.Add('nuProcesso', ftString, 31);
    oCdsRejeitados.FieldDefs.Add('deClasse', ftString, 100);
    oCdsRejeitados.FieldDefs.Add('deMotivo', ftString, 250);
    oCdsRejeitados.CreateDataSet;
    oCdsRejeitados.LogChanges := False;

    result := oCdsRejeitados.Data;
  finally
    oCdsRejeitados.Free;
  end;
end;

// 22/09/2011 - rduarte - SALT: 91087/1
procedure IncluirDataSetRejeitado(const poCdsRejeitados: TspClientDataSet;
  const psCdProcesso, psNuProcesso, psDeClasse, psDeMotivo: string);
begin
  try
    poCdsRejeitados.Append;
    poCdsRejeitados.FieldByName('cdProcesso').AsString := psCdProcesso;
    poCdsRejeitados.FieldByName('nuProcesso').AsString := psNuProcesso;
    poCdsRejeitados.FieldByName('deClasse').AsString := psDeClasse;
    poCdsRejeitados.FieldByName('deMotivo').AsString := psDeMotivo;
    poCdsRejeitados.Post;
  except
    poCdsRejeitados.Cancel;
  end;
end;

// 26/09/2011 - Jonas - SALT 90907/3.
procedure ExibirItemMenu(poItemMenu: TMenuItem; pbExibir: boolean;
  const pbSomenteDesabilitar: boolean = False);
begin
  if pbExibir then
  begin
    poItemMenu.Visible := True;
    poItemMenu.Tag := 0;
  end
  else
  begin
    if pbSomenteDesabilitar then
      poItemMenu.Enabled := False
    else
    begin
      poItemMenu.Visible := False;
      poItemMenu.Tag := -1;
    end;
  end;
end;

// 27/10/2011 - Jonas - SALT 94914/1.
//retorna true se conseguiu finalizar.
function FinalizarDocumento(pnCdDocumento: double; var pnCdErro: double;
  var psMsgErro: string): boolean;
var
  eedtDocEmitido: TeedtDocEmitido;
  ncdErro: double;
  vDataFinalizacao, vRestricoesEventosFluxo, vDocumentosErros: olevariant;
  sMsgErro, sDocumentosOk, sFlagsErroControlado: WideString;
  oCDSFinalizacao, oCDSDocumentos: TspClientDataset;
  oOperacaoFinalizacao: TOperacoes;
begin
  result := True;
  sFlagsErroControlado := STRING_INDEFINIDO;
  oOperacaoFinalizacao := opFinalizar;
  eedtDocEmitido := nil;
  oCDSDocumentos := TspClientDataset.Create(nil);
  oCDSFinalizacao := TspClientDataset.Create(nil);
  eedtDocEmitido := TeedtDocEmitido.Create(nil);
  try
    oCDSDocumentos.Data := TeedtDocEmitido.CrieDatasetDeFinalizacaoDeDocumentosDigitais;
    oCDSFinalizacao.Data := eedtDocEmitido.SelecionaDadosDosDocumentosParaFinalizacao(
      FloatToStr(pnCdDocumento), True, False);
    oInicializacaoSistema.GetClassInterfaceEmissao.PopuleDataSetFinalizacaoDocumento(
      oCDSFinalizacao, oCDSDocumentos);
    vDataFinalizacao := oCDSDocumentos.Data;

    if not eedtDocEmitido.FinalizaDocumentoDigital('Juntando Documentos;' +
      IntToStr(sajLotacaoUsuario.nCdForo), vDataFinalizacao, Ord(oOperacaoFinalizacao),
      NUMERO_INDEFINIDO, Ord(tpEmissaoNormal), vRestricoesEventosFluxo, ncdErro,
      sMsgErro, sDocumentosOk, vDocumentosErros, sFlagsErroControlado, False) then
    begin
      pnCdErro := ncdErro;
      psMsgErro := sMsgErro;
      result := False;
      //TeedtDocEmitido.MostraMensagemErroFinalizacao(ncdErro, sMsgErro, nil);
    end;
  finally
    FreeAndNil(eedtDocEmitido);
    FreeAndNil(oCDSDocumentos);
    FreeAndNil(oCDSFinalizacao);
  end;
end;

// 10/11/2011 - Uba - SALT: 92305/1.
function GetNomeArea(psVlrArea: string): string;
begin
  result := '';
  if (psVlrArea = '1') then
    result := 'Cível'
  else if (psVlrArea = '2') then
    result := 'Criminal'
  else if (psVlrArea = '3') then
    result := 'Ambas';
end;

// 02/12/2011 - junior.goulart - SALT 97266/8.
function RemoverCaracterInvalidoDoProcesso(psNuProcesso: string): string;
var
  sNuProcessoNovo: string;
  nTotal: integer;
  nCont: integer;
begin
  sNuProcessoNovo := STRING_INDEFINIDO;
  nTotal := Length(psNuProcesso);
  for nCont := 1 to nTotal do
    if psNuProcesso[nCont] in (['0', '1', '2', '3', '4', '5', '6', '7', '8',
      '9', '.', '/', '-']) then
      sNuProcessoNovo := sNuProcessoNovo + psNuProcesso[nCont];
  result := sNuProcessoNovo;
end;

// 05/03/2012 - rduarte - SALT: 104051/1
function RetornarControleLinksConsulta(const psCdProcesso: string): olevariant;
var
  oControleLinks: TspConjuntoDados;
begin
  oControleLinks := TspConjuntoDados.Create(nil);

  try
    oControleLinks.FieldDefs.Clear;
    oControleLinks.FieldDefs.add('psCdProcesso', ftString, 13, False);
    oControleLinks.FieldDefs.add('psCdObjeto', ftString, 13, False);
    oControleLinks.FieldDefs.add('pnLinkParte', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoParte', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkTodasParte', ftInteger, 0, False);
    oControleLinks.FieldDefs.Add('pnLinkMov', ftInteger, 0, False);
    oControleLinks.FieldDefs.Add('pnConteudoMov', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkTodasMov', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoTodasMov', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkAud', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoAud', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkMand', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoMand', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkPDiv', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoPDiv', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkApenso', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoApenso', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkCusta', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoCusta', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkFilaTrabalho', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoFilaTrabalho', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkLocFis', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoLocFis', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkArma', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoArma', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkCarga', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoCarga', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkDist', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoDist', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkVinculos', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoVinc', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkOutros', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoOutros', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkAssuntos', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoAssuntos', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkPendencias', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoPendencias', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnLinkHistoricoClasse', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoHistoricoClasse', ftInteger, 0, False);
    // 02/02/2012 - rduarte - SALT: 102072/1 
    oControleLinks.FieldDefs.add('pnLinkObrigacao', ftInteger, 0, False);
    oControleLinks.FieldDefs.add('pnConteudoObrigacao', ftInteger, 0, False);
    oControleLinks.CreateDataSet;

    oControleLinks.Append;
    oControleLinks.FieldByName('psCdProcesso').AsString := psCdProcesso;
    oControleLinks.Post;

    result := oControleLinks.Data;
  finally
    oControleLinks.Free;
  end;
end;

// 13/03/2012 - rduarte - SALT: 104361/1
function RetornarPrimeiroDiaAno(const pdDiaHoje: TDateTime): TDateTime;
begin
  result := StrToDate('01/01/' + IntToStr(Year(pdDiaHoje)));
end;

// 13/03/2012 - rduarte - SALT: 104361/1
function RetornarPrimeiroDiaDoMes(const pdDiaHoje: TDateTime): TDateTime;
begin
  result := StrToDate('01/' + IntToStr(Month(pdDiaHoje)) + '/' + IntToStr(Year(pdDiaHoje)));
end;

// 13/03/2012 - rduarte - SALT: 104361/1
function RetornarPrimeiraSegunda(const pdDiaHoje: TDateTime): TDateTime;
var
  nDiaSemana: integer;
  dAtual: TDateTime;
begin
  result := pdDiaHoje;
  nDiaSemana := DayOfWeek(pdDiaHoje);
  dAtual := pdDiaHoje;

  while nDiaSemana <> 2 do
  begin
    dAtual := IncDay(dAtual, -1);
    Dec(nDiaSemana);
    result := dAtual;
  end;
end;

// 13/03/2012 - rduarte - SALT: 104361/1
function RetornarUltimoDiaMes(pdDiaHoje: TDateTime): TDateTime;
var
  nAno: word;
  nMes: word;
  nDia: word;
  dAux: TDateTime;
begin
  DecodeDate(pdDiaHoje, nAno, nMes, nDia);
  dAux := (pdDiaHoje - nDia) + 33;
  Decodedate(dAux, nAno, nMes, nDia);
  result := dAux - nDia;
end;

//29/02/2012 - Anderson Roberto Monzani - SALT: 102385/1

function GetLocalHost: string;
var
  Buffer: array[0..63] of char;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  result := Buffer;
  WSACleanup;
end;

function PegarIPLocal: string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  I: integer;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  result := '';
  phe := GetHostByName(PChar(GetLocalHost));
  if phe = nil then
    Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  I := 0;
  while pPtr^[I] <> nil do
  begin
    result := inet_ntoa(pptr^[I]^);
    Inc(I);
  end;
  WSACleanup;
end;
//----------------------------------------------------

// 19/04/2012 - Uba - SALT 107038/1.
// 26/06/2012 - NyR - SALT 112262/1 - Modificado o parâmetro
function PegarRelatorDoProcessoFormatadoPrm58149(oCdsDados: TClientDataSet): string;
const
  //constantes com os campos que conterá o nome dos magistrados (titular e substituto).
  sNM_MAGISTRADO_TITULAR_PROCESSO = 'nmMagistradoTitularProcesso';
  sRELATOR_PROCESSO = 'RELATORPROCESSO';
var
  sParametro58149: string;
  sAux: string;
  sMagistradoFrente, sMagistradoDepois: string;
  sTextoEmSubstituicao: string;
  nAuxInicioTagDeletar: integer;
  nTamanhoTagDeletar: integer;
  sRetorno: string;

  function RetornaTratamentoRelator: string;
  begin
    result := Trim(oCdsDados.FieldByName('deTratamentoRelator').AsString) + ' ';
  end;

  function RetornarDistVaga: string;
  begin
    //SALT: 90215/7 - Claudinei - 09/2011
    if oCdsDados.FieldByName('cdCaractTipoDist').AsInteger =
      nCDCARACT_TIPODIST_PREVENCAO_MAG_VAGA_INATIVA then
      result := sDISTRIBUIDO_NA_VAGA + ' '
    else
      result := '';
  end;

begin
  sRetorno := STRING_INDEFINIDO;
  try
    if (oCdsDados.IsEmpty) then
      Exit;

    sMagistradoFrente := STRING_INDEFINIDO;
    sMagistradoDepois := STRING_INDEFINIDO;
    sRetorno := STRING_INDEFINIDO;

    if (oCdsDados.FieldByName('cdRelatorProcesso').AsInteger <> oCdsDados.FieldByName(
      'cdMagistradoTitularProcesso').AsInteger) and
      (oCdsDados.FieldByName('cdMagistradoTitularProcesso').AsInteger <> NUMERO_INDEFINIDO) then
    begin
      //primeiro deve-se verificar o parâmetro 58149, o qual define a ordem de apresentação dos
      //magistrados, e o texto entre eles.
      sParametro58149 := spParamSistema.AsString(
        prmOrdemMagistradosTitularSubstitutoTextoSubstituicao, gnCdPrmSG5);

      //verifica se o 1º agente será o titular.
      sAux := Copy(sParametro58149, 0, 16);
      if sAux = sTAG_JUIZ_TITULAR then
      begin
        sMagistradoFrente := sNM_MAGISTRADO_TITULAR_PROCESSO;
        sMagistradoDepois := sRELATOR_PROCESSO;
      end
      else
      begin
        //verifica se o 1º agente será o substituto.
        sAux := Copy(sParametro58149, 0, 19);
        if sAux = sTAG_JUIZ_SUBSTITUTO then
        begin
          sMagistradoFrente := sRELATOR_PROCESSO;
          sMagistradoDepois := sNM_MAGISTRADO_TITULAR_PROCESSO;
        end;
      end;

      if (sMagistradoFrente <> STRING_INDEFINIDO) and (sMagistradoDepois <> STRING_INDEFINIDO) then
      begin
        //pegar o texto em substituição.
        //deletando as tag's do parâmetro, restando apenas o texto entre o nome dos juízes.
        //deletando a tag do juíz titular.
        nAuxInicioTagDeletar := pos(sTAG_JUIZ_TITULAR, sParametro58149);
        nTamanhoTagDeletar := length(sTAG_JUIZ_TITULAR);
        if nAuxInicioTagDeletar > 0 then
          Delete(sParametro58149, nAuxInicioTagDeletar, nTamanhoTagDeletar);
        //deletando a tag do juíz substituto.
        nAuxInicioTagDeletar := pos(sTAG_JUIZ_SUBSTITUTO, sParametro58149);
        nTamanhoTagDeletar := length(sTAG_JUIZ_SUBSTITUTO);
        if nAuxInicioTagDeletar > 0 then
          Delete(sParametro58149, nAuxInicioTagDeletar, nTamanhoTagDeletar);

        sTextoEmSubstituicao := ' ' + Trim(sParametro58149) + ' ';
      end
      else
      begin
        //valores padrão caso o parâmetro 58149 tenha sido informado incorretamente.
        sMagistradoFrente := sRELATOR_PROCESSO;
        sMagistradoDepois := sNM_MAGISTRADO_TITULAR_PROCESSO;
        sTextoEmSubstituicao := 'em substituição ao magistrado(a)';
      end;

      sRetorno := {'Relator: ' +} RetornarDistVaga + RetornaTratamentoRelator +
        oCdsDados.FieldByName(sMagistradoFrente).AsString;

      sRetorno := sRetorno + sTextoEmSubstituicao + oCdsDados.FieldByName(
        'deTipoAgente').AsString + ' ' + oCdsDados.FieldByName(sMagistradoDepois).AsString;
    end
    else
      sRetorno := {'Relator: ' +} RetornarDistVaga + RetornaTratamentoRelator +
        oCdsDados.FieldByName('RELATORPROCESSO').AsString;
  finally
    result := Trim(sRetorno);
  end;
end;

function Uniao(pvConjunto1, pvConjunto2: olevariant; psCampoChave: string): olevariant;
var
  cdsConjunto1, cdsConjunto2, cdsConjuntoResult: TClientDataSet;
begin
  cdsConjunto1 := TClientDataSet.Create(nil);
  cdsConjunto2 := TClientDataSet.Create(nil);
  cdsConjuntoResult := TClientDataSet.Create(nil);
  try
    cdsConjunto1.Data := pvConjunto1;
    cdsConjunto2.Data := pvConjunto2;
    cdsConjuntoResult.Data := pvConjunto1;

    cdsConjunto2.First;
    while not cdsConjunto2.EOF do
    begin
      if not cdsConjuntoResult.Locate(psCampoChave, cdsConjunto2.FieldByName(
        psCampoChave).AsString, []) then
        copiaRegistro(cdsConjunto2, cdsConjuntoResult);

      cdsConjunto2.Next;
    end;

    result := cdsConjuntoResult.Data;

  finally
    FreeAndNil(cdsConjunto1);
    FreeAndNil(cdsConjunto2);
    FreeAndNil(cdsConjuntoResult);
  end;
end;


// 11/05/2012 - Uba - SALT 108131/1.
//psSaida: retorno da função.
//psTextoAdicionar: texto a ser adicionado no retorno psSaida.
//psSeparador: adicionado no psSaida, separando o texto já existente do que será inserido (psTextoAdicionar).
procedure AdicionarTextoVariavel(var psSaida: string; psTextoAdicionar: string;
  const psSeparador: string = STRING_INDEFINIDO);
begin
  if (psSaida = STRING_INDEFINIDO) then
    psSaida := psTextoAdicionar
  else
    psSaida := psSaida + psSeparador + psTextoAdicionar;
end;

// 15/05/2012 - Uba - SALT 108131/1.
//verifica se a sessão de julgamento já foi publicada (pbVerificarJahFoi = True), ou se ela
//ainda não foi publicada (pbVerificarJahFoi = False). A verificação se dará no dataSet poConjuntoDados.

function VerificarSessaoJulgamentoFoiPublicada(poConjuntoDados: TspConjuntoDados;
  const pbVerificarJahFoi: boolean = True): boolean;
begin
  result := not pbVerificarJahFoi;

  if (Assigned(poConjuntoDados.FindField('cdLocalPub'))) and
    (Assigned(poConjuntoDados.FindField('nuSequencia'))) and
    (Assigned(poConjuntoDados.FindField('nuSeqPub'))) then
  begin
    //verifica se a sessão de julgamento já foi publicada.
    if pbVerificarJahFoi then
      result := (NotNull(poConjuntoDados.FieldByName('cdLocalPub').AsString)) and
        (NotNull(poConjuntoDados.FieldByName('nuSequencia').AsString)) and
        (NotNull(poConjuntoDados.FieldByName('nuSeqPub').AsString))
    //verifica se a sessão de julgamento ainda não foi publicada.
    else
      result := (IsNull(poConjuntoDados.FieldByName('cdLocalPub').AsString)) and
        (IsNull(poConjuntoDados.FieldByName('nuSequencia').AsString)) and
        (IsNull(poConjuntoDados.FieldByName('nuSeqPub').AsString));
  end;
end;

// 02/07/2012 - rduarte - SALT: 106650/1
function TestarValorEstaNaLista(const psLista, psValor: string): boolean;
var
  oLstValores: TStringList;
  nCont: integer;
begin
  oLstValores := TStringList.Create;

  try
    result := False;
    oLstValores.CommaText := psLista;

    for nCont := 0 to oLstValores.Count - 1 do
    begin
      if AnsiUpperCase(psValor) = AnsiUpperCase(oLstValores.Strings[nCont]) then
      begin
        result := True;
        Break;
      end;
    end;
  finally
    FreeAndNil(oLstValores);
  end;
end;

// 19/09/2012 - CassianoM - SALT: 110259/1
procedure EnviarFormSegundoMonitor(poForm: TspForm);
begin
  if not osajConfEstacao.sajUtilizarSegundoMonitor then
    Exit;

  if poForm.FormStyle <> fsNormal then
    poForm.FormStyle := fsNormal;

  poForm.Constraints.MaxHeight := osajConfEstacao.sajMonitor2.Height;
  poForm.Top := osajConfEstacao.sajMonitor2.Top;
  poForm.Left := osajConfEstacao.sajMonitor2.Left;
  poForm.Width := osajConfEstacao.sajMonitor2.Width;
  poForm.Height := osajConfEstacao.sajMonitor2.Height;
end;

// 31/07/2012 - rduarte - SALT: 64640/1
function VerificarAutorizacao(const psNmForm, psAutorizacao: string): boolean;
begin
  result := spSeguranca.AutorizadoComponente(psNmForm, psAutorizacao, vaUsuario);
end;

// 26/09/2012 - NyR	SALT: 100795/1
function ValidarValorPreenchido(const pvValor: variant): boolean;
begin
  result := (not VarIsNull(pvValor)) and (not VarIsEmpty(pvValor));
end;

procedure MatarComportamentoAncestral(pbExecutarAbort: Boolean = False);
begin
  if pbExecutarAbort then
    Abort;
end;

function PegarMensagemExcecao: string;
var
  oException: Exception;

begin
  oException := Exception(ExceptObject);
  try
    result := oException.Message;
  finally
    FreeAndNil(oException); //PC_OK
  end;
end;

function ConverterSegundosToDateTime(pnTempo: integer): TDateTime;
var
  nHour, nMin, nSec: word;
begin
  nHour := 0;

  if pnTempo >= 3600 then // 1 hora
  begin
    nHour := Trunc((pnTempo / 60) / 60);
    pnTempo := pnTempo - (nHour * 60 * 60);
  end;

  if pnTempo >= 60 then   // 1 minuto
  begin
    nMin := Trunc(pnTempo / 60);
    pnTempo := pnTempo - (nMin * 60);
    nSec := pnTempo;
  end
  else
  if pnTempo > 0 then
  begin
    nMin := 0;
    nSec := pnTempo;
  end
  else
  begin
    nMin := 0;
    nSec := 0;
  end;

  result := Date + EncodeTime(nHour, nMin, nSec, 0);
end;

function CalcularMediaProcessamento(pdtInicio, pdtTermino: TDateTime;
  pnQuantidadeProcessados: integer): integer;
var
  nHour, nMin, nSec, nMSec: word;
  nSegundos: integer;
begin
  DecodeTime(pdtInicio - pdtTermino, nHour, nMin, nSec, nMSec);
  nSegundos := (nHour * 60 * 60) + (nMin * 60) + nSec;

  if (nSegundos > 0) and (pnQuantidadeProcessados > 0) then
  begin
    if pnQuantidadeProcessados = 1 then
      result := nSegundos
    else
      result := Trunc((nSegundos / pnQuantidadeProcessados));
  end
  else
    result := nSegundos;
end;

function RetornarTempoTotalProcessamento(pdtInicio, pdtTermino: TDateTime): string;
begin
  result := FormatDateTime('hh:mm:ss', (pdtTermino - pdtInicio));
end;

function RetornarTempoMedioProcessamento(pdtInicio, pdtTermino: TDateTime;
  pnQuantidadeProcessados: integer): string;
begin
  result := FormatDateTime('hh:mm:ss', ConverterSegundosToDateTime(
    CalcularMediaProcessamento(pdtInicio, pdtTermino, pnQuantidadeProcessados)));
end;

// 21/11/2012 - junior.goulart - SALT: 119981/1
function EhHoraValida(const psHorario: string): boolean;
begin
  try
    StrToTime(psHorario);
    result := True;
  except
    result := False;
  end;
end;

initialization

  // Monta lista de partes de nomes que serão ignoradas na montagem das siglas
  // e outros locais
  oListaPreposicao := TStringList.Create;
  oListaPreposicao.add('da');
  oListaPreposicao.add('de');
  oListaPreposicao.add('do');
  oListaPreposicao.add('das');
  oListaPreposicao.add('dos');
  oListaPreposicao.add('para');
  oListaPreposicao.add('pra');
  oListaPreposicao.add('pela');
  oListaPreposicao.add('pelo');
  oListaPreposicao.add('pelas');
  oListaPreposicao.add('pelos');
  oListaPreposicao.add('a');
  oListaPreposicao.add('e');
  oListaPreposicao.add('i');
  oListaPreposicao.add('o');
  oListaPreposicao.add('u');
  oListaPreposicao.add('no');
  oListaPreposicao.add('na');
  oListaPreposicao.add('nas');
  oListaPreposicao.add('nos');

  sVersaoServidor := '1.0.0-48';

finalization
  oListaPreposicao.Clear;
  oListaPreposicao.Free;

end.

