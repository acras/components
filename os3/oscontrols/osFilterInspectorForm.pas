{* osFilterInspectorForm
 * Início da documentação, o componente já funciona mas não estava documentado
 * Responsável: Ricardo N. Acras
 * Alterações:
 *        => 07/10/2005 - Adicionar filtro em filtro como mais um tipo de
 *                        restrição ao usuário
 *          - Adicionar a opção na função CreateConstraint.
}

unit osFilterInspectorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, wwDataInspector, osDBdatetimepicker, wwdbdatetimepicker,
  osUtils, wwCheckBox, Variants;

type
  TosFilterInspector = class(TForm)
    DataInspector: TwwDataInspector;
    btnOK: TButton;
    btnCancela: TButton;
  private
    function LastDayMonth(PDate: TDatetime): TDatetime;
    function SQLDateFromStr(PStr: string): string;

    function GetWord(const PStr: string; PIndex: integer; PSeparator: char = ';'): string;
    function GetExpressions: string;
    function GetOrder: string;
    procedure ReplaceSpecialChars(var PStr: string);
    procedure CreateConstraint(const PStr: string; PInspItem: TwwInspectorItem);
    procedure CreateOrder(POrderList: TStrings);
    procedure CreateDateList(PInspItem: TwwInspectorItem);
    procedure DateListItemChanged(Sender: TwwDataInspector;
      Item: TwwInspectorItem; NewValue: String);
    procedure DatePickerOnEnter(Sender: TObject);
  public
    function Execute(PConstr, POrder: TStrings): boolean;
    property Expressions: string read GetExpressions;
    property Order: string read GetOrder;
  end;

var
  osFilterInspector: TosFilterInspector;

implementation

{$R *.DFM}

uses
  osComboSearch, osClientDataSet, osComboFilter;

{ TFilterInspector }

procedure TosFilterInspector.CreateConstraint(const PStr: string; PInspItem: TwwInspectorItem);
var
  iIniBlock, iNumWord: integer;
  InspItem: TwwInspectorItem;
  sTipoControle, sConteudo, sAux1, sAux2: string;
  sNome, sExpressao, sIdConstraint: string;
  sNomeFiltro, sNomeCampoRetorno, sNomeCampoTexto: string;
  sPStr: string;
  idConstraint: integer;
begin
  idConstraint := 0;
  if pos('#',PStr)<>0 then
  begin
    sPStr := copy(PStr,pos('#',PStr)+1,1000);
    sIdConstraint := copy(PStr,1,pos('#',PStr)-1);
    idConstraint := StrToInt(trim(sIdConstraint));
  end
  else
    sPStr := PStr;
  sNome := GetWord(sPStr, 1); // Nome
  sExpressao := GetWord(sPStr, 2); // Expressão

  if not Assigned(PInspItem) then
    InspItem := DataInspector.Items.Add
  else
    InspItem := PInspItem.Items.Add;

  InspItem.Tag := idConstraint;

  {
  Formato:
  Nome;Expressão;Date
  Nome;Expressão;List;cod1,descr1,cod2,descr2,...
  Nome;Expressão;Dategroup;expr1 | expr2
  Nome;;Group Nome;Expressao[;...] | Nome;Expressao[;...] | ...
  Nome;Expressão;Filter;nome_filtro[,campo_retorno,campo_texto]
  Nome;Expressão1[~Expressao2];CONDITIONAL[,[TRUE|FALSE]]
  }

  InspItem.Caption := sNome;
  InspItem.TagString := sExpressao;
  sTipoControle := Trim(UpperCase(GetWord(sPStr, 3))); // Tipo de controle
  if sTipoControle = 'DATE' then
  begin
    InspItem.CustomControl := TosDBDateTimePicker.Create(Self);
    TosDBDateTimePicker(InspItem.CustomControl).RefObject := InspItem;
    TosDBDateTimePicker(InspItem.CustomControl).OnEnter := DatePickerOnEnter;  // Atribui o método de tratamento do evento
  end
  else if sTipoControle = 'LIST' then
  begin
    InspItem.PickList.MapList := True;
    InspItem.PickList.AllowClearKey := True;
    InspItem.PickList.Style := csDropDownList;
    iNumWord := 1;
    sConteudo := GetWord(sPStr, 4); // Conteúdo
    sAux1 := GetWord(sConteudo, iNumWord, ',');
    while Trim(sAux1) <> '' do
    begin
      Inc(iNumWord);
      sAux2 := GetWord(sConteudo, iNumWord, ',');
      InspItem.PickList.Items.Add(sAux2 + #9 + sAux1);
      Inc(iNumWord);
      sAux1 := GetWord(sConteudo, iNumWord, ',');
    end;
  end
  else if sTipoControle = 'DATEGROUP' then
  begin
    CreateDateList(InspItem);
    InspItem.OnItemChanged := DateListItemChanged;
    iIniBlock := Pos('DATEGROUP', UpperCase(sPStr)) + 10;
    sConteudo := Copy(sPStr, iIniBlock, Length(sPStr) - iIniBlock + 1);
    iNumWord := 1;
    sAux1 := GetWord(sConteudo, iNumWord, '|');
    while Trim(sAux1) <> '' do
    begin
      CreateConstraint(sAux1, InspItem);
      Inc(iNumWord);
      sAux1 := GetWord(sConteudo, iNumWord, '|');
    end;
  end
  else if sTipoControle = 'GROUP' then
  begin
    InspItem.DisableDefaultEditor := True;
    iIniBlock := Pos('GROUP', upperCase(sPStr)) + 6;
    sConteudo := Copy(sPStr, iIniBlock, Length(sPStr) - iIniBlock + 1);
    iNumWord := 1;
    sAux1 := GetWord(sConteudo, iNumWord, '|');
    while Trim(sAux1) <> '' do
    begin
      CreateConstraint(sAux1, InspItem);
      Inc(iNumWord);
      sAux1 := GetWord(sConteudo, iNumWord, '|');
    end;
  end
  else if sTipoControle = 'FILTER' then
  begin
    sConteudo := GetWord(sPStr, 4); // Dados do filtro
    if Pos(',',sConteudo) <> 0 then
    begin
      sNomeFiltro := GetWord(sConteudo, 1, ',');
      sNomeCampoRetorno := GetWord(sConteudo, 2, ',');
      sNomeCampoTexto := GetWord(sConteudo, 3, ',');
    end
    else
    begin
      sNomeFiltro := sExpressao;
      sNomeCampoRetorno := '';
      sNomeCampoTexto := '';
    end;
    InspItem.CustomControl := TosComboSearch.Create(Self);
    TosComboSearch(InspItem.CustomControl).FilterDataProvider :=
      TosClientDataSet(application.mainform.FindComponent('FilterDataSet')).DataProvider;
    TosComboSearch(InspItem.CustomControl).FilterDefName := sNomeFiltro;
    TosComboSearch(InspItem.CustomControl).ReturnLookupField := sNomeCampoRetorno;
    TosComboSearch(InspItem.CustomControl).ReturnTextField := sNomeCampoTexto;
  end
  else if sTipoControle = 'CONDITIONAL' then
  begin
    sConteudo := GetWord(sPStr, 4); // Dados do filtro
    InspItem.CustomControl := TwwCheckBox.Create(self);
    (InspItem.CustomControl as TwwCheckBox).Checked :=
      not((sConteudo='') or (UpperCase(sConteudo)='FALSE'));
  end;
end;

procedure TosFilterInspector.CreateDateList(PInspItem: TwwInspectorItem);
begin
  PInspItem.PickList.MapList := True;
  PInspItem.PickList.AllowClearKey := True;
  PInspItem.PickList.Style := csDropDownList;
  PInspItem.PickList.Items.Add('Hoje' + #9 + '1');
  PInspItem.PickList.Items.Add('Ontem' + #9 + '2');
  PInspItem.PickList.Items.Add('Últimos 3 dias' + #9 + '3');
  PInspItem.PickList.Items.Add('Últimos 7 dias' + #9 + '4');
  PInspItem.PickList.Items.Add('Últimos 30 dias' + #9 + '5');
  PInspItem.PickList.Items.Add('Mês atual' + #9 + '6');
  PInspItem.PickList.Items.Add('Ano atual' + #9 + '7');
  PInspItem.PickList.Items.Add('Mês anterior' + #9 + '8');
  PInspItem.PickList.Items.Add('Ano anterior' + #9 + '9');
end;

procedure TosFilterInspector.CreateOrder(POrderList: TStrings);
var
  InspItem: TwwInspectorItem;
  sAux1, sAux2: string;
  i: integer;
begin
  InspItem := DataInspector.Items.Add;
  InspItem.Caption := 'Ordem';
  InspItem.TagString := 'ORDER';

  InspItem.PickList.MapList := True;
  InspItem.PickList.AllowClearKey := True;
  InspItem.PickList.Style := csDropDownList;

  for i:=0 to POrderList.Count - 1 do
  begin
    sAux1 := GetWord(POrderList[i], 1, '=');
    sAux2 := GetWord(POrderList[i], 2, '=');
    InspItem.PickList.Items.Add(sAux1 + #9 + sAux2);
  end;
end;

procedure TosFilterInspector.DateListItemChanged(Sender: TwwDataInspector;
  Item: TwwInspectorItem; NewValue: String);
var
  dtIni, dtFim: TDatetime;
  dia, mes, ano: word;
begin
  case NewValue[1] of
  '1':  // Hoje
    begin
      dtIni := date;
      dtFim := date;
    end;
  '2': // Ontem
    begin
      dtIni := date-1;
      dtFim := date-1;
    end;
  '3': // Últimos 3 dias
    begin
      dtIni := date-2;
      dtFim := date;
    end;
  '4': // Últimos 7 dias
    begin
      dtIni := date-6;
      dtFim := date;
    end;
  '5': // Últimos 30 dias
    begin
      dtIni := date-29;
      dtFim := date;
    end;
  '6': // Mês atual
    begin
      DecodeDate(date, ano, mes, dia);
      dtIni := EncodeDate(ano, mes, 1);
      dtFim := LastDayMonth(date);
    end;
  '7': // Ano atual
    begin
      DecodeDate(date, ano, mes, dia);
      dtIni := EncodeDate(ano, 1, 1);
      dtFim := EncodeDate(ano, 12, 31);
    end;
  '8': // Mês anterior
    begin
      DecodeDate(date, ano, mes, dia);
      Dec(mes);
      if Mes = 0 then
      begin
        Mes := 12;
        Dec(ano);
      end;
      dtIni := EncodeDate(ano, mes, 1);
      dtFim := LastDayMonth(dtIni);
    end;
  '9': // Ano anterior
    begin
      DecodeDate(date, ano, mes, dia);
      dtIni := EncodeDate(ano-1, 1, 1);
      dtFim := EncodeDate(ano-1, 12, 31);
    end;
  else
    begin
      dtIni := 0;
      dtFim := 0;
    end;
  end;

  Item.Items[0].CustomControlAlwaysPaints := False;
  Item.Items[0].EditText := FormatDatetime('dd/mm/yyyy', dtIni);
  Item.Items[1].CustomControlAlwaysPaints := False;
  Item.Items[1].EditText := FormatDatetime('dd/mm/yyyy', dtFim);
  if Item.Expanded then
  begin
    {
    //if TwwDBDateTimePicker(Item.Items[0].CustomControl).ParentWindow <> 0 then
      TwwDBDateTimePicker(Item.Items[0].CustomControl).Date := dtIni;
    //if TwwDBDateTimePicker(Item.Items[1].CustomControl).ParentWindow <> 0 then
      TwwDBDateTimePicker(Item.Items[1].CustomControl).Date := dtFim;
    }
  end;
end;

procedure TosFilterInspector.DatePickerOnEnter(Sender: TObject);
var
  dtPicker: TosDBDatetimePicker;
begin
  dtPicker := TosDBDatetimePicker(Sender);
  if TwwInspectorItem(dtPicker.RefObject).EditText <> '' then
    dtPicker.Date := StrToDate(TwwInspectorItem(dtPicker.RefObject).EditText);
end;

function TosFilterInspector.Execute(PConstr, POrder: TStrings): boolean;
var
  i: integer;
begin
  for i:=0 to PConstr.Count - 1 do
    CreateConstraint(PConstr[i], nil);

  if POrder.Count > 0 then
    CreateOrder(POrder);
  if DataInspector.Items.Count > 0 then
    ShowModal                                    
  else
    ModalResult := mrOK;
  Result := (ModalResult = mrOK);
end;

function TosFilterInspector.GetExpressions: string;
var
  i, j: integer;
  sCon, sAux: string;
  InspItem, InspItemChild: TwwInspectorItem;
  comboSearch: TosComboSearch;
  listaRestricoesPreenchidas: TList;
  restricao, restricaoChild: TRestricaoUsuario;
begin
  listaRestricoesPreenchidas := TList.Create;

  Result := '';
  sCon := '';
  for i:=0 to DataInspector.Items.Count-1 do
  begin
    InspItem := DataInspector.Items[i];
    restricao := TRestricaoUsuario.Create;
    restricao.IdRestricao := InspItem.tag;
    restricao.Texto := InspItem.editText;
    if InspItem.Items.Count > 0 then
    begin
      for j:=0 to InspItem.Items.Count - 1 do
      begin
        InspItemChild := InspItem.Items[j];
        if Trim(InspItemChild.EditText) <> '' then
        begin
          restricaoChild := TRestricaoUsuario.Create;
          restricaoChild.IdRestricao := InspItemChild.Tag;
          restricaoChild.Id          := 0;
          restricaoChild.Texto := InspItemChild.EditText;
          if InspItemChild.CustomControl is TosDBDateTimePicker then
            sAux := sCon + Format(InspItemChild.TagString,[SQLDateFromStr(InspItemChild.EditText)])
          else
            if InspItemChild.CustomControl is TosComboSearch then
            begin
              comboSearch := (InspItemChild.CustomControl as TosComboSearch);
              sAux := '';
              if VarToStr(comboSearch.ReturnedValue)<>'-1' then
                sAux := sCon + Format(InspItemChild.TagString,[VarToStr(comboSearch.ReturnedValue)]);
              restricao.id := comboSearch.ReturnedValue;
            end
            else
              sAux := sCon + Format(InspItemChild.TagString,[InspItemChild.EditText]);
          listaRestricoesPreenchidas.Add(restricaoChild);
          ReplaceSpecialChars(sAux); // Método privado
          if sAux<>'' then
          begin
            Result := Result + sAux;
            sAux := '';
            sCon := ' AND ';
          end;
        end;
      end;
    end
    else if ((Trim(InspItem.EditText) <> '') and (InspItem.TagString <> 'ORDER')) OR (InspItem.CustomControl is TwwCheckBox) then
    begin
      if InspItem.CustomControl is TosDBDateTimePicker then
        sAux := sCon + Format(InspItem.TagString,[SQLDateFromStr(InspItem.EditText)])
      else
        if InspItem.CustomControl is TosComboSearch then
        begin
          comboSearch := (InspItem.CustomControl as TosComboSearch);
          sAux := '';
          if VarToStr(comboSearch.ReturnedValue)<>'-1' then
            sAux := sCon + Format(InspItem.TagString,[VarToStr(comboSearch.ReturnedValue)]);
          restricao.id := comboSearch.ReturnedValue;
        end
        else
        if InspItem.CustomControl is TwwCheckBox then
        begin
          //se possui as duas sentenças usa a mais adequada
          if pos('~',InspItem.TagString)<>0 then
          begin
            if (InspItem.CustomControl as TwwCheckBox).Checked then
              sAux := sCon + copy(InspItem.TagString,1,pos('~',InspItem.TagString)-1)
            else
              sAux := sCon + copy(InspItem.TagString,pos('~',InspItem.TagString)+1,1000);
          end
          else //se possui só uma sentença, só a insere se estiver checkado
            if (InspItem.CustomControl as TwwCheckBox).Checked then
              sAux := sCon + Format(InspItem.TagString,[InspItem.EditText]);
        end
        else
          sAux := sCon + Format(InspItem.TagString,[InspItem.EditText]);
      ReplaceSpecialChars(sAux); // Método privado
      if sAux<>'' then
      begin
        Result := Result + sAux;
        sAux := '';
        sCon := ' AND ';
      end;
    end;
    listaRestricoesPreenchidas.Add(restricao);
  end;
  if GlobalListaRestricoesUsuario<>nil then
    FreeAndNil(GlobalListaRestricoesUsuario);
  GlobalListaRestricoesUsuario := listaRestricoesPreenchidas;
end;

function TosFilterInspector.GetOrder: string;
var
  InspItem: TwwInspectorItem;
begin
  InspItem := DataInspector.GetItemByTagString('ORDER');
  if Assigned(InspItem) then
    Result := InspItem.EditText
  else
    Result := '';
end;

function TosFilterInspector.GetWord(const PStr: string; PIndex: integer; PSeparator: char): string;
var
  iNumWord, i, iLen, iIni: integer;
begin
  iLen := Length(PStr);
  iNumWord := 1;
  iIni := 1;
  for i:=1 to iLen do
    if (PStr[i] = PSeparator) then
      if iNumWord = PIndex then
        break
      else
      begin
        iIni := i + 1;
        Inc(iNumWord);
      end;

  if iNumWord = PIndex then
    Result := Trim(Copy(PStr, iIni, i - iIni))
  else
    Result := '';
end;

function TosFilterInspector.LastDayMonth(PDate: TDatetime): TDatetime;
var
  ano, mes, dia: word;
begin
  DecodeDate(PDate, ano, mes, dia);
  Result := PDate + 35 - dia;
  DecodeDate(Result, ano, mes, dia);
  Result := Result - dia;
end;

procedure  TosFilterInspector.ReplaceSpecialChars(var PStr: string);
var
  i, iLen: integer;
begin
  iLen := Length(PStr);
  for i:=1 to iLen do
    if PStr[i] = '*' then
      PStr[i] := '%';
end;

function TosFilterInspector.SQLDateFromStr(PStr: string): string;
begin
//  Result := FormatDatetime('yyyymmdd', StrToDate(PStr));
  Result := FormatDatetime('yyyy/mm/dd', StrToDate(PStr));
end;

end.
