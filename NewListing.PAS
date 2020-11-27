{
  Different Codes passed
          'S', Suppliers
          'C', Customers
          'G', Groups
          'N', Nominal Accounts
          'E' : Enterprise Accounts
          'V' : VAT Codes
          'W' : Excludes Exclusive VAT Codes
          'I' : Used to list income accounts for EntRange ( Enterprises )
          'A' : Analysis Codes
          'L' : List Ledger Cards ( Use the Account String to pass the Current Account

   08/01/19 [V4.3 R4.0] /MK Change - Added Balance, Age1, Age2 and Age3 fields for ledger customers - GL/TGM request.
}

unit NewListing;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, Types, ActnList, Menus, cxButtons,
  cxControls, cxContainer, cxEdit, cxTextEdit, uAccsSystem;

type
    TListRec = Record     // direct copy from old form for compatibility
    CustOrSupp  : Integer; { Record number }
    ActiveDb    : Integer;
    ListType    : Char;
    AccRange    : TAccRange;
    Ent         : ShortString;
    Account     : ShortString;
    ReturnValue : ShortString;
  End;

  TNewListBox = class(TForm)
    List: TStringGrid;
    ActionList1: TActionList;
    actCancel: TAction;
    actNew: TAction;
    actSelect: TAction;
    pActionPanel: TPanel;
    Bevel1: TBevel;
    p: TPanel;
    Searchlabel: TLabel;
    Searchfield: TcxTextEdit;
    pButtons: TPanel;
    pCancel: TPanel;
    btnCancel: TcxButton;
    pNew: TPanel;
    btnNew: TcxButton;
    pSelect: TPanel;
    btnSelect: TcxButton;
    procedure Setscreen(ListingType : char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Function  SetRanges ( Sender: TObject; Range : TRange ) : TAccRange;
    Procedure ListRecords;
    Procedure FillCustSuppGrid;
    procedure ListSelectClick(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure SearchfieldChange(Sender: TObject);
    Procedure FillGroupGrid;
    Procedure FillEntGrid;
    Procedure FillVATGrid;
    Procedure FillAnalysisGrid;
    Procedure FillLedgerCardsGrid;
    Procedure FillNomGrid;
    Procedure ListNominals(RangeStart,RangeEnd : integer);
    Procedure CalcTax ( ArrPos : Integer; Var VATAmt : ShortString;
                    Var TaxAmt, NomAmt : Long; Var Exclusive : Boolean );
    procedure NewButtonClick(Sender: TObject);
    Function CheckVAT ( VATCode : ShortString; Var ArrPos : Integer ) : Boolean;
    // SP 28/06/2019
    function CheckVATCode(AVATCode : ShortString) : Boolean;
    Function NegitiveFlag ( NominalStr : ShortString; StringTochange : String ) : String;
    Function Listok ( Substr, Bigstr : String; RecCounter : Integer ) : Boolean;
    Function CheckNom ( NomCode : ShortString; AccRange : TAccRange ) : Boolean;
    procedure SearchfieldKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actNewExecute(Sender: TObject);
    procedure actSelectExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure ListSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SearchfieldPropertiesChange(Sender: TObject);
    procedure actNewUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FRecordsListed : Boolean;
    SelectedRow : Integer;
    FFormShowing : Boolean;
    FFocusedAccountNo : string;
    FAccountType : TRange;
    procedure FocusRow(const AFocusedAccountNo : string);
  public
    { Public declarations }
    ListInfo    : TListRec;
    InitialSearchFieldText : string;
    setgridposition : boolean;
    procedure ListIt ( Sender: TObject; AccountType : TRange; ListType : Char );overload;
    procedure ListIt ( Sender: TObject; AccountType : TRange; ListType : Char;
        const AFocusedAccountNo : string);overload;
    // temp solution to list groups from Setup.pas, should refactor at later stage. 07/01/2013
    procedure ListGroups( Sender: TObject; AccRange : TAccRange);overload;
  end;

var
  NewListBox: TNewListBox;
  NomGridPos, FirstExp : integer;


implementation

uses AccsData, DBGen, vars, DBCore, clears, Addrec, calcs,
  uPreferenceConsts, uPreferences;

{$R *.DFM}

function TNewListBox.Listok ( Substr, Bigstr : String; RecCounter : Integer ) : Boolean;
var
   x,y : integer;
Begin
     If substr=Null then
        begin
             Listok := True;
             Exit  ;
        end;

 {    For x:=1 to Length(Substr) do
         If (ord (Substr [x]) >= 97) and
            (ord (Substr [x]) <=122) Then Substr [x] :=CHR(ord(Substr [x] ) - 32);
     For x:=1 to Length(Bigstr) do
         If (ord (Bigstr [x]) >= 97) and
            (ord (Bigstr [x]) <=122) Then Bigstr [x] :=CHR(ord(Bigstr [x] ) - 32);
  }
     Substr := AnsiUppercase(Substr);
     Bigstr := AnsiUppercase(Bigstr);

     Listok := POS(Substr, Bigstr) > 0;

     if RecCounter <> 9999999 then begin

        try y := strtoint(substr);
            if (Substr = vartostr(RecCounter)) then listok:= True;
            Listok := POS(Substr, vartostr(RecCounter)) = 1;
        except
        end;
     end;
end;

Procedure TNewListBox.CalcTax ( ArrPos : Integer; Var VATAmt : ShortString;
                             Var TaxAmt, NomAmt : Long; Var Exclusive : Boolean );
Var
   TmpVAT,
   TmpAmt,
   VRate,
   Wk     : Double;
{-->>   Save,}
   Rate   : Long;
   Method : Integer;
Begin
     VATAmt := '';
     Method := 1;
     Rate := Cash1.xTaxRates[ArrPos];
     If Cash2.xTaxTypes[ArrPos] = 'E' Then Method := 1;
     If Cash2.xTaxTypes[ArrPos] = 'I' Then Method := 2;

     If METHOD=0 Then
        If (Cash1.XCALCSTAX AND (PROG IN [CASHINC,SALESTX])) Or
           (Cash1.XCALCPTAX AND (PROG IN [CASHEXP,PURCHTX])) Or
           (Cash1.XCALCJTAX AND (PROG IN [JOURNAL	   ])) THEN METHOD:=1;
     If METHOD=0 Then
        If (Cash1.XGROSSSL  AND (PROG IN [CASHINC,SALESTX])) Or
           (Cash1.XGROSSPL  AND (PROG IN [CASHEXP,PURCHTX])) Or
           (Cash1.XGROSSJL  AND (PROG IN [JOURNAL	   ])) THEN METHOD:=2;
     Exclusive := ( Method = 1 );
     If METHOD=1 THEN
        Begin
             (* check XCOUNTRY CODE AND only used for UK *)
             If (( Cash2.XCOUNTRY = 1 ) and ( Cash1.XTAXIDS[ArrPos] = 'E' ) And
                 ( RATE = 0 )) then
                 TAXAMT := 0;

             If NomAmt>0 THEN
                Begin
                     WK := NomAmt/100;
{-->>                     TmpAmt := WK;}
                     VRate := Rate/100;
                     WK := ((WK * VRate) / 100);
                     TaxAmt := Round (WK*100);
                End;
             IF NomAmt < 0 THEN
                Begin
                     NomAmt := 0-NomAmt;


                     WK := NomAmt/100;
{-->>                     TmpAmt := WK;}
                     VRate := Rate/100;
                     WK := ((WK * VRate) / 100);
                     TaxAmt := Round (WK*100);
                     NomAmt := 0-NomAmt;
                     TAXAMT :=0-TAXAMT;
                End;
             EXIT;
        End;
     If METHOD=2 Then
        Begin
{-->>             SAVE:=NomAmt;}
             If NomAmt > 0 Then
                Begin
                     WK := NomAmt/100;
                     TmpAmt := WK;
                     VRate := Rate/100;
                     WK := ((WK / (100+ VRate)) * 100);
                     TmpVAT := TmpAmt - WK;
                     TaxAmt := Round (TmpVAT*100);
                     NomAmt := (Round (WK*100));
                End;
             If NomAmt < 0 THEN
                Begin
                     WK := 0-(NomAmt/100);
                     TmpAmt := WK;
                     VRate := Rate/100;
                     WK := ((WK / (100+ VRate)) * 100);
                     TmpVAT := TmpAmt - WK;
                     TaxAmt := 0-(Round (TmpVAT*100));
                     NomAmt := 0-(Round (WK*100));
                End;
        End;
End;

Function TNewListBox.CheckNom ( NomCode : ShortString; AccRange : TAccRange ) : Boolean;
Var
   NomAccount,
   LastNom   : Integer;
   NominalOK,
   ActiveRecord,
   UseRanges : Boolean;

Begin
{-->>     CheckNom := False;}
     NominalOK := False;
     ActiveRecord := False;
     SlimAll ( NomCode );
     If Numeric ( NomCode ) Then
        Begin
             UseRanges := False;
             NomAccount := StrToInt ( NomCode );
             SetDb ( NlFile );
             LastNom := db1.dbrechigh;
             If AccRange[2] > 0 Then
                Begin
                     LastNom := AccRange[2];
                     UseRanges := True;
                End;
             If AccRange[4] > 0 Then
                Begin
                     LastNom := AccRange[4];
                     UseRanges := True;
                End;
             If ( NomAccount <= LastNom ) Then
                Begin
                     ReadRec ( NlFile, NomAccount );
                 //    dberr;
                     ActiveRecord := RecActive ( NlFile );
                End;

             NominalOK := (( ActiveRecord ) And ( NOT UseRanges )) Or
                         (( ActiveRecord ) And ( UseRanges ) And
                         (( NomAccount >= AccRange[1] ) And
                          ( NomAccount <= AccRange[2] )) Or
                         (( NomAccount >= AccRange[3] ) And
                          ( NomAccount <= AccRange[4] )));
        End
     Else
         If Length ( NomCode ) = 0 Then
            NominalOK := True;
     CheckNom := NominalOK;
End;

Function TNewListBox.CheckVAT ( VATCode : ShortString; Var ArrPos : Integer ) : Boolean;
Var
   FoundPos,
   RecCounter : Integer;
Begin
     CheckVAT := False;
     RecCounter := 0;
     FoundPos   := -1;
     ArrPos := 0;

     SlimAll ( VATCode );
     If Length ( VATCode ) <> 0 Then
        Begin
           While ( RecCounter <= 9 ) Do
              Begin
                   If Length ( Cash1.xTaxIds[RecCounter] ) > 0 Then
                      Begin
                           If Cash1.xTaxids[RecCounter] = VATCode Then
                              Begin
                                   CheckVAT := True;
                                   FoundPos := RecCounter;
                                   RecCounter := 9;

                              End;
                      End;
                   Inc ( RecCounter );
              End;
        End;

     If FoundPos <> -1 Then
        ArrPos := FoundPos;

End;

// SP 28/06/2019
function TNewListBox.CheckVATCode(AVATCode : ShortString) : Boolean;
var
   TempArrPos  : Integer;
begin
   Result := CheckVAT(AVATCode,TempArrPos);
end;

Function TNewListBox.NegitiveFlag ( NominalStr : ShortString; StringTochange : String ) : String;
Var
   NomAccount : LongInt;
   TestStr : ShortString;
   Neg : Boolean;
Begin
   NegitiveFlag := StringToChange;
   SlimAll ( NominalStr );
   If Numeric ( NominalStr ) Then
      NomAccount := StrToInt ( NominalStr )
   Else
       NomAccount := 0;
   Neg := False;
   IF (PROG IN [CASHINC,CASHEXP,SALESTX,PURCHTX]) AND
     (( NomAccount >= Cash1.XNOMPRVINC ) AND
      ( NomAccount <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN
      BEGIN
         CASE PROG OF
            CASHINC,SALESTX : NEG:=(( NomAccount >=Cash1.XNOMPRVEXP) And
			     ( NomAccount <=Cash1.xnomprvexp+Cash11.xno_of_partners ));
            CASHEXP,PURCHTX : NEG:=(( NomAccount >=Cash1.XNOMPRVINC) And
			     ( NomAccount <=Cash1.xnomprvinc+Cash11.xno_of_partners ));
         END;
      END
   ELSE
      NEG:= (( PROG IN [CASHINC,SALESTX] ) AND
            (( NomAccount < Cash1.XNOMINCFROM ) OR
             ( NomAccount > Cash1.XNOMNONTO )) AND
            (( NomAccount > Cash1.XNOMEXPFROM-1 ) AND
             ( NomAccount < Cash1.XNOMOHTO+1 )) ) OR

            (( PROG IN [CASHEXP,PURCHTX] ) AND
            (( NomAccount < Cash1.XNOMEXPFROM ) OR
             ( NomAccount > Cash1.XNOMOHTO )) AND
	    (( NomAccount > Cash1.XNOMINCFROM-1 ) AND
	     ( NomAccount < Cash1.XNOMNONTO+1 )));

   If NEG And ( NomAccount >= 1 ) And ( NomAccount <= 9999 ) Then
      Begin
           TestStr := StringToChange;{CashBookForm.DetailGrid.Cells[4, Row];}
           SlimAll ( TestStr );
           If ( Pos ( '-', TestStr ) = 0 ) Then
              NegitiveFlag := TestStr + '-';{CashBookForm.DetailGrid.Cells[4, Row] := }
      End;
End;

Function TNewListBox.SetRanges ( Sender: TObject; Range : TRange ) : TAccRange;
Var
   LastEnt,
   EntRecord : Integer;
Begin
     SetRanges[1] := 0;
     SetRanges[2] := 0;
     SetRanges[3] := 0;
     SetRanges[4] := 0;
     SetRanges[5] := 0;
     SetRanges[6] := 0;

     NewListBox.ListInfo.ActiveDb := NlFile;

     If ( Range = AllNoms ) Then
        Begin
             SetRanges[1] := 1;
             SetRanges[2] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;
        End
     Else If ( Range = AllNomsPlusCapital ) Then
        Begin
             SetDb ( NlFile );
             SetRanges[1] := 1;
             SetRanges[2] := DB1.DBRECTOT;
             SetRanges[3] := 0;
             SetRanges[4] := 0;
             SetRanges[5] := 0;
             SetRanges[6] := 0;
        End
     Else If ( Range = AllNomsXBank ) Then
        Begin
             SetRanges[1] := 1;
             SetRanges[2] := Cash1.xNomCato;
             SetRanges[3] := Cash1.xNomFaTo+1;
             SetRanges[4] := Cash1.xNomLiTo;
             SetRanges[5] := Cash1.xNomPrvInc;
             SetRanges[6] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;
        End
     Else If ( Range = NonEnt ) Then
        Begin
             SetRanges[1] := Cash1.xNomNonFrom;
             SetRanges[2] := Cash1.xNomNonTo;
        End
     Else If ( Range = NonEntToLiab ) Then
        Begin
             SetRanges[1] := Cash1.xNomNonFrom;
             SetRanges[2] := Cash1.xNomLiTo;
             SetRanges[3] := Cash1.xNomPrvInc;
             SetRanges[4] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;
        End
     Else If ( Range = Liab ) Then
        Begin
             SetRanges[1] := Cash1.xNomLiFrom;
             SetRanges[2] := Cash1.xNomLiTo;
        End
     Else If ( Range = Banks ) Then
        Begin
             SetRanges[1] := Cash1.xBankMin;
             SetRanges[2] := Cash1.xBankMax;
        End
     Else If ( Range = FAsset ) Then
        Begin
             SetRanges[1] := Cash1.xNomFaFrom;
             SetRanges[2] := Cash1.xNomFaTo;
        End
     Else If ( Range = CAsset ) Then
        Begin
             SetRanges[1] := Cash1.xNomCaFrom;
             SetRanges[2] := Cash1.xNomCaTo;
        End
     Else If ( Range = OverHeads ) Then
        Begin
             SetRanges[1] := Cash1.xNomOhFrom;
             SetRanges[2] := Cash1.xNomOhTo;
        End
     Else If ( Range = OverHeadsToLiab ) Then
        Begin
             SetRanges[1] := Cash1.xNomOhFrom;
             SetRanges[2] := Cash1.xNomLiTo;
             SetRanges[3] := Cash1.xNomPrvInc;
             SetRanges[4] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;
        End
     Else If ( Range = OverHeadsWithExpense ) Then
        Begin
             SetRanges[1] := Cash1.xNomExpFrom;
             SetRanges[2] := Cash1.xNomExpTo;
             SetRanges[3] := Cash1.xNomOhFrom;
             SetRanges[4] := Cash1.xNomOhTo;
        End
     Else If ( Range = EntRange ) Then
        Begin
             SlimAll ( NewListBox.ListInfo.Ent );
             EntRecord := 1;
             SetRanges[1] := 1;
             SetRanges[2] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;
             SetDb ( EntFile );
             LastEnt := db1.dbrechigh;
             While ( EntRecord <= LastEnt ) Do
                   Begin
                        ReadRec ( EntFile, EntRecord );
                   //     dberr;
                        If RecActive ( EntFile ) Then
                           Begin
                                GetItem ( EntFile, 1 );
                                SlimAll ( CurrStr );
                                If ( CurrStr = NewListBox.ListInfo.Ent ) Then
                                   Begin
                                        GetItem ( EntFile, 6 );
                                        SetRanges[1] := CurrInt;
                                        GetItem ( EntFile, 7 );
                                        SetRanges[2] := CurrInt;
                                        If ( NewListBox.ListInfo.ListType <> 'I' ) Then
                                           Begin
                                                GetItem ( EntFile, 8 );
                                                SetRanges[3] := CurrInt;
                                                GetItem ( EntFile, 9 );
                                                SetRanges[4] := CurrInt;
                                           End;
                                   End;
                           End;
                        Inc ( EntRecord );
                   End;
        End
     Else If ( Range = Enterprise ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := EntFile;
             SetDb ( EntFile );
             SetRanges[1] := 1;
             SetRanges[2] := db1.dbrechigh;
        End
     Else If ( Range = Customers ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := SlFile;
             SetDb ( SlFile );
             SetRanges[1] := 1;
             SetRanges[2] := Accsdatamodule.SLFileDB.RecordCount; // db1.dbrectot;    TGM AB
        End
     Else If ( Range = Suppliers ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := PlFile;
             SetDb ( PlFile );
             SetRanges[1] := 1;
             SetRanges[2] := Accsdatamodule.PLFileDB.RecordCount; //db1.dbrectot;      TGM AB
        End
     Else If ( Range = Analysis ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := AnalFile;
             SetDb ( AnalFile );
             SetRanges[1] := 1;
             SetRanges[2] := db1.dbrectot;
        End
     Else If ( Range = CustLedgerCards ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := SlFile;
             SetDb ( NewListBox.ListInfo.ActiveDb );
             SetRanges[1] := 1;
             SetRanges[2] := db1.dbrectot;
        End
     Else If ( Range = EntAllIncome ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := NlFile;
             SetDb ( NewListBox.ListInfo.ActiveDb );
             SetRanges[1] := Cash1.XNOMINCFROM;
             SetRanges[2] := Cash1.XNOMINCTO;
        End
     Else If ( Range = EntAllExpend ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := NlFile;
             SetDb ( NewListBox.ListInfo.ActiveDb );
             SetRanges[1] := Cash1.XNOMExpFROM;
             SetRanges[2] := Cash1.XNOMExpTO;
        End
     Else If ( Range = SuppLedgerCards ) Then
        Begin
             NewListBox.ListInfo.ActiveDb := PLFile;
             SetDb ( NewListBox.ListInfo.ActiveDb );
             SetRanges[1] := 1;
             SetRanges[2] := db1.dbrectot;
        End
     Else If ( Range = AllNomsPlusCapitalLessControl ) Then
        Begin
             SetDb ( NlFile );
             SetRanges[1] := 1;
             SetRanges[2] := cash1.XNOMDEBTOR-1;
             SetRanges[3] := cash1.XNOMCREDIT+1;
             SetRanges[4] := DB1.DBRECTOT;
             SetRanges[5] := 0;
             SetRanges[6] := 0;
        End;
End;

procedure TNewListBox.Setscreen(ListingType : char);
begin
   Case ListingType Of
          'A',
          'G',
          'N',
          'I',
          'E' : Begin
                     // List.ColCount := 2;  { Nominal Account Groups }

                     // SP 04/07/013 - New column added to display the Ent code (if present)
                     List.ColCount := 3;
                     List.ColWidths[0] := 45;
                     List.ColWidths[1] := 265;
                     List.ColWidths[2] := 45;
                     NewListBox.List.Cells[0,0] := 'No';
                     NewListBox.List.Cells[1,0] := 'Name';
                     NewListBox.List.Cells[2,0] := 'Ent.';
                End;
          'S','C' : begin
                     NewListBox.List.ScrollBars := ssBoth;
                     If (NewListBox.ListInfo.ListType = 'C') Then NewListBox.Caption := 'List Customer Accounts'
                         Else NewListBox.Caption := 'List Supplier Accounts';
                     if ( AccsSystem.SystemType = stCashbook ) then
                        List.ColCount := 2
                     else
                        List.ColCount := 6;
                     List.ColWidths[1] := List.ColWidths[0]*4;
                     if ( AccsSystem.SystemType <> stCashbook ) then
                        begin
                           List.ColWidths[2] := 80;
                           List.ColWidths[3] := List.ColWidths[2];
                           List.ColWidths[4] := List.ColWidths[2];
                           List.ColWidths[5] := List.ColWidths[2];
                        end;
                     NewListBox.List.Cells[0,0] := 'No';
                     NewListBox.List.Cells[1,0] := 'Name';
                     if ( AccsSystem.SystemType <> stCashbook ) then
                        begin
                           NewListBox.List.Cells[2,0] := 'Balance';
                           NewListBox.List.Cells[3,0] := 'Age1';
                           NewListBox.List.Cells[4,0] := 'Age2';
                           NewListBox.List.Cells[5,0] := 'Age3';
                        end;
                    end;
          'L' : Begin
                     List.ColCount := 3;
                     List.ColWidths[0] := List.Font.Size * 8;
                     List.ColWidths[1] := List.Font.Size * 5;
                     List.ColWidths[2] := List.Font.Size * 12;
                End;
          'V','W' : Begin
                     List.ColCount := 4;  { VAT Codes }
                     List.ColWidths[0] := List.Font.Size * 3;
                     List.ColWidths[1] := List.Font.Size * 5;
                     List.ColWidths[2] := List.Font.Size * 7;
                     List.ColWidths[3] := List.Font.Size * 10;

                End;
   end;
End;


procedure TNewListBox.FormActivate(Sender: TObject);
begin
   SearchField.text := '';
   if (Trim(InitialSearchFieldText) <> '') then
      begin
         SearchField.text := InitialSearchFieldText;
         InitialSearchFieldText := '';
         Searchfield.SetFocus;
      end
   else if ((NewListBox.ListInfo.ListType <> 'V') and (NewListBox.ListInfo.ListType <> 'W')) then
      Searchfield.SetFocus;

   if (Trim(SearchField.Text) <> '') then
      SearchField.SelStart := Length(Trim(SearchField.Text))+1;

   if (List.RowCount > 1) then // include header!
      begin
         if (FFocusedAccountNo <> '') then
            begin
               FocusRow(FFocusedAccountNo);
               FFocusedAccountNo := '';
            end
         else if setgridposition then
            begin
               Newlistbox.List.TopRow := FirstExp+1;
               if (Newlistbox.List.TopRow <= Newlistbox.List.RowCount-1) then
                  Newlistbox.List.Row := Newlistbox.List.TopRow
               else
                  MessageDlg('There are no Nominal Accounts available.',mtInformation,[mbOK],0);
            end;
      end;
   FFormShowing := True;
end;

procedure TNewListBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   NewListBox.ListInfo.ListType := ' ';
   Searchfield.Text := '';
   FRecordsListed := False;
   FFormShowing := False;
end;

Procedure TNewListBox.ListRecords;
Begin
               SetDb ( ListInfo.ActiveDb );
               Case ListInfo.ListType Of
                    'A' : FillAnalysisGrid;
                    'G' : FillGroupGrid;
                    'V','W' : FillVATGrid;
                    'I',
                    'N' : FillNomGrid;
                    'E' : FillEntGrid;
                    'S',
                    'C' : FillCustSuppGrid;
                    'L' : FillLedgerCardsGrid;
               End;
               try List.fixedrows := 1;
               except
               end;
   FRecordsListed := True;
End;

procedure TNewListBox.ListIt ( Sender: TObject; AccountType : TRange; ListType : Char );
begin
   FAccountType := AccountType;

   NewListBox.List.ScrollBars := ssVertical;

   if ((ListInfo.ListType = 'V') or (ListInfo.ListType = 'W')) then
      begin
         SearchField.Visible := false;
         SearchLabel.Visible := false;
      end
   else
      begin
         SearchField.visible := true;
         SearchLabel.Visible := true;
         if Trim(InitialSearchFieldText) <> '' then
            Searchfield.Text := InitialSearchFieldText;
      end;

   FRecordsListed := False;
   setgridposition := false;
   InitRange ( NewListBox.ListInfo.AccRange );

   NewListBox.ListInfo.ListType := ListType;
   NewListBox.Setscreen(ListType);
   NewListBox.ListInfo.AccRange := SetRanges ( Sender, AccountType );

   ListInfo.ReturnValue := '';
   List.ColWidths[0] := 50;
   setscreen(NewListBox.ListInfo.ListType);

   ListRecords;
   Newlistbox.showmodal;
end;

Procedure TNewListBox.FillCustSuppGrid;
var
    gridpos, recno : integer;
    searchtext, teststring : string;
    recOK : boolean;
Begin
  gridpos := 1;
  List.Rowcount := 1;
  searchtext := searchfield.Text;

  if ListInfo.ListType = 'C' then begin
     Accsdatamodule.SLFileDB.first;
     for recno :=1 to Accsdatamodule.SLFileDB.RecordCount do begin
     recok := true;
     if length(searchtext) <> 0 then begin
        try
           teststring := Accsdatamodule.SLFileDB['Name']
        except
        end;
        recok := false;
        if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
        if pos(ansilowercase(searchtext),Accsdatamodule.SLFileDB['SLNo']) > 0 then recok := true;
     end;
     if Accsdatamodule.SLFileDB['Active'] <> true then recok := false;
     if recok then begin
        List.Rowcount := List.Rowcount + 1;
        if ( AccsSystem.SystemType <> stCashbook ) then
           begin
              List.Cells [5, GridPos] := '';
              List.Cells [4, GridPos] := '';
              List.Cells [3, GridPos] := '';
              List.Cells [2, GridPos] := '';
           end;
        List.Cells [1, GridPos] := '';
        List.Cells [0, GridPos] := IntTostr ( Accsdatamodule.SLFileDB['SLNo']);
        try
           List.Cells [1, GridPos] := Accsdatamodule.SLFileDB['Name'];
           if ( AccsSystem.SystemType <> stCashbook ) then
              begin
                 List.Cells [2, GridPos] := Accsdatamodule.SLFileDB['Balance'];
                 List.Cells [3, GridPos] := Accsdatamodule.SLFileDB['Age1'];
                 List.Cells [4, GridPos] := Accsdatamodule.SLFileDB['Age2'];
                 List.Cells [5, GridPos] := Accsdatamodule.SLFileDB['Age3'];
              end;
        except //List.Cells [1, GridPos] := '';
        end;
        inc(gridpos);
     end;
     Accsdatamodule.SLFileDB.next;
     end;
  end;


  if ListInfo.ListType = 'S' then begin
     Accsdatamodule.PLFileDB.first;
     for recno :=1 to Accsdatamodule.PLFileDB.RecordCount do begin
     recok := true;
     if length(searchtext) <> 0 then begin
        try
           teststring := Accsdatamodule.PLFileDB['Name']
        except
        end;
        recok := false;
        if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
        if pos(ansilowercase(searchtext),Accsdatamodule.PLFileDB['PLNo']) > 0 then recok := true;
     end;
     if Accsdatamodule.PLFileDB['Active'] <> true then recok := false;
     if recok then begin
        List.Rowcount := List.Rowcount + 1;
        if ( AccsSystem.SystemType <> stCashbook ) then
           begin
              List.Cells [5, GridPos] := '';
              List.Cells [4, GridPos] := '';
              List.Cells [3, GridPos] := '';
              List.Cells [2, GridPos] := '';
           end;
        List.Cells [1, GridPos] := '';
        List.Cells [0, GridPos] := IntTostr ( Accsdatamodule.PLFileDB['PLNo']);
        try
           List.Cells [1, GridPos] := Accsdatamodule.PLFileDB['Name'];
           if ( AccsSystem.SystemType <> stCashbook ) then
              begin
                 List.Cells [2, GridPos] := Accsdatamodule.PLFileDB['Balance'];
                 List.Cells [3, GridPos] := Accsdatamodule.PLFileDB['Age1'];
                 List.Cells [4, GridPos] := Accsdatamodule.PLFileDB['Age2'];
                 List.Cells [5, GridPos] := Accsdatamodule.PLFileDB['Age3'];
              end;
        except
        end;
        inc(gridpos);
     end;
     Accsdatamodule.PLFileDB.next;
     end;
  end;



 { if ListInfo.ListType = 'S' then
     begin

        with Accsdatamodule.PLFileDB do
           begin
              DisableControls;
              try
                 First;
                 while not eof do
                    begin
                       recok := true;
                       if Length(searchtext) <> 0 then
                          begin
                             try
                                teststring := Accsdatamodule.PLFileDB['Name']
                             except
                             end;
                             recok := false;
                             if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
                             if pos(ansilowercase(searchtext),Accsdatamodule.PLFileDB['PLNo']) > 0 then recok := true;
                          end;

                       if Accsdatamodule.PLFileDB['Active'] <> true then recok := false;
                       if recok then begin
                          List.Rowcount := List.Rowcount + 1;
                          List.Cells [1, GridPos] := '';
                          List.Cells [0, GridPos] := IntTostr ( Accsdatamodule.PLFileDB['PLNo']);
                          try List.Cells [1, GridPos] := Accsdatamodule.PLFileDB['Name'];
                          except
                          end;
                          inc(gridpos);
                       end;
                       Next;
                    end
              finally
                 EnableControls;
              end;
           end;
     end;  }
end;

procedure TNewListBox.ListSelectClick(Sender: TObject);
begin
{     if List.Cells[0,List.Row] = 'No' then begin
                                                showmessage('No Selection Made');
                                                exit;
                                           end;
     if ListInfo.ListType = 'L' then ListInfo.ReturnValue := List.Cells[2,List.Row]
     else ListInfo.ReturnValue := List.Cells[0,List.Row];
     SlimAll ( ListInfo.ReturnValue );
     ModalResult := mrCancel;
     }
end;

procedure TNewListBox.ListDblClick(Sender: TObject);
begin
   actSelect.Execute;
end;

procedure TNewListBox.SearchfieldChange(Sender: TObject);
begin
   Listrecords;
end;

Procedure TNewListBox.FillGroupGrid;
var
    gridpos, recno : integer;
    searchtext, teststring : string;
    recOK : boolean;
Begin
     NewListBox.Caption := 'List Account Groups';
     NewListBox.List.Cells[0,0] := 'No';
     NewListBox.List.Cells[1,0] := 'Name';
     GridPos := 1;
     List.Rowcount := 1;
     searchtext := searchfield.Text;
     Accsdatamodule.NLGroupsDB.open;
     Accsdatamodule.NLGroupsDB.Locate('GroupNo',ListInfo.AccRange[1],[]);
     for recno := ListInfo.AccRange[1] to ListInfo.AccRange[2] do begin
         If not ExcludeNominal ( recno ) then begin
            recok := false;
            if Accsdatamodule.NLGroupsDB['Active'] = True then recok := true;
            if length(searchtext) <> 0 then begin
               try teststring := Accsdatamodule.NLGroupsDB['GroupDesc']
               except
               end;
               recok := false;
               if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
               if pos(ansilowercase(searchtext),Accsdatamodule.NLGroupsDB['GroupNo']) > 0 then recok := true;
            end;
            if recok then begin
               List.Rowcount := List.Rowcount + 1;
               List.Cells [0, GridPos] := IntTostr ( Accsdatamodule.NLGroupsDB['GroupNo']);
               try List.Cells [1, GridPos] := Accsdatamodule.NLGroupsDB['GroupDesc'];
               except List.Cells [1, GridPos] := '';
               end;
               inc(gridpos);
            end;
         end;
     Accsdatamodule.NLGroupsDB.next;
     end;
End;

Procedure TNewListBox.FillEntGrid;
var
    gridpos, recno : integer;
    searchtext, teststring : string;
    recOK : boolean;
Begin
     NewListBox.Caption := 'List Enterprise Accounts';
     NewListBox.List.Cells[0,0] := 'Code';
     NewListBox.List.Cells[1,0] := 'Name';
     GridPos := 1;
     List.Rowcount := 1;
     searchtext := searchfield.Text;
     Accsdatamodule.EntsFileDB.open;
     Accsdatamodule.EntsFileDB.Locate('EntNo',ListInfo.AccRange[1],[]);
     for recno := ListInfo.AccRange[1] to ListInfo.AccRange[2] do begin
            if Accsdatamodule.EntsFileDB['Active'] = True then begin
               recok := true;
               if length(searchtext) <> 0 then begin
                  try teststring := Accsdatamodule.EntsFileDB['EntName']
                  except
                  end;
                  recok := false;
                  if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
                  if pos(ansilowercase(searchtext),Accsdatamodule.EntsFileDB['EntNo']) > 0 then recok := true;
               end;
               if recok then begin
                  List.Rowcount := List.Rowcount + 1;
                  try List.Cells [0, GridPos] := ' ';
                      List.Cells [1, GridPos] := ' ';
                      List.Cells [0, GridPos] := Accsdatamodule.EntsFileDB['EntCode'];
                      List.Cells [1, GridPos] := Copy (Accsdatamodule.EntsFileDB['EntName'], 1, 16 );;
                  except
                  end;
                  inc(gridpos);
               end;
            end;
     Accsdatamodule.EntsFileDB.next;
     end;
End;

{
Fill the Grid with info from the Cashbook Definition File re VAT Codes, Rates
}
Procedure TNewListBox.FillVATGrid;
Var
   RecCounter : Integer;
   TempRate   : Real;
   GridPos : integer;
Begin
     NewListBox.List.ColCount := 4;
     NewListBox.Caption := 'List VAT Codes';
     NewListBox.List.Cells[0,0] := 'Code';
     NewListBox.List.Cells[1,0] := 'Rate';
     NewListBox.List.Cells[2,0] := '';
     NewListBox.List.Cells[3,0] := 'Description';

     GridPos := 1;
     For RecCounter := 0 To 9 Do
         Begin
              If Length ( Cash1.xTaxIds[RecCounter] ) > 0 Then
                 Begin
                      if ListInfo.ListType = 'W' then begin
                         if Cash2.xTaxTypes[RecCounter] <> 'E' Then begin
                                NewListBox.List.Cells[0,GridPos] := Cash1.xTaxIds[RecCounter];
                                TempRate := Cash1.xTaxRates[RecCounter] / 100;
                                NewListBox.List.Cells[1,GridPos] := Format ( '%f', [TempRate]); {FloatToStrF ( TempRate, ffFixed, 2, 2 );}
                                If Cash2.xTaxTypes[RecCounter] = 'I' Then
                                        NewListBox.List.Cells[2,GridPos] := 'Inclusive'
                                Else If Cash2.xTaxTypes[RecCounter] = 'E' Then
                                        NewListBox.List.Cells[2,GridPos] := 'Exclusive';
                                NewListBox.List.Cells[3,GridPos] := Cash11.vat_desc[RecCounter];
                                Inc ( GridPos );
                         end;
                      end else begin

                                NewListBox.List.Cells[0,GridPos] := Cash1.xTaxIds[RecCounter];
                                TempRate := Cash1.xTaxRates[RecCounter] / 100;
                                NewListBox.List.Cells[1,GridPos] := Format ( '%f', [TempRate]); {FloatToStrF ( TempRate, ffFixed, 2, 2 );}
                                If Cash2.xTaxTypes[RecCounter] = 'I' Then
                                        NewListBox.List.Cells[2,GridPos] := 'Inclusive'
                                Else If Cash2.xTaxTypes[RecCounter] = 'E' Then
                                        NewListBox.List.Cells[2,GridPos] := 'Exclusive';
                                NewListBox.List.Cells[3,GridPos] := Cash11.vat_desc[RecCounter];
                                Inc ( GridPos );
                      end;
                 End;
         End;
     NewListBox.List.RowCount := GridPos;
End;

Procedure TNewListBox.FillAnalysisGrid;
var
   i, gridpos, recno : integer;
   searchtext,teststring : string;
   recok : boolean;
Begin
     NewListBox.Caption := 'List Analysis Codes';
     NewListBox.List.Cells[0,0] := 'No';
     NewListBox.List.Cells[1,0] := 'Name';
     GridPos := 1;
     List.Rowcount := 1;
     searchtext := searchfield.Text;
     Accsdatamodule.AnalysisDB.open;
     Accsdatamodule.AnalysisDB.first;
     for recno := 1 to Accsdatamodule.AnalysisDB.recordcount do begin
               recok := true;
               if length(searchtext) <> 0 then begin
                  try teststring := Accsdatamodule.AnalysisDB['Description']
                  except
                  end;
                  recok := false;
                  if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
               end;
               if recok then begin
                  List.Rowcount := List.Rowcount + 1;
                  try List.Cells [0, GridPos] := Accsdatamodule.AnalysisDB['Number'];
                      List.Cells [1, GridPos] := '';
                      List.Cells [1, GridPos] := Accsdatamodule.AnalysisDB['Description'];
                  except
                  end;
                  inc(gridpos);
               end;
     Accsdatamodule.AnalysisDB.next;
     end;
End;


Procedure TNewListBox.FillLedgerCardsGrid;
Var
   ActiveRec,
   CurrTx, GridPos, RecCounter, itemto : Integer;
   RecOK : Boolean;
   TotAmt : Long;
Begin
     If ( NewListBox.ListInfo.ActiveDb = SLFile ) Then
        NewListBox.Caption := 'List Customer Ledger Cards'
     Else
         NewListBox.Caption := 'List Supplier Ledger Cards';
     NewListBox.List.Cells[0,0] := 'Date';
     NewListBox.List.Cells[1,0] := 'Type';
     NewListBox.List.Cells[2,0] := 'Amount';
     GridPos := 1;
     List.RowCount := 1;
     CurrTx := 0;

     SlimAll ( ListInfo.Account );
     If Numeric ( ListInfo.Account ) Then
        Begin
           SetDb ( ListInfo.ActiveDb );
           ReadRec ( ListInfo.ActiveDb, StrToInt ( ListInfo.Account ));
           If RecActive ( ListInfo.ActiveDb ) Then
              Begin
                 GetItem ( ListInfo.ActiveDb, 14 );   // First Year
                 If CurrInt <> 0 Then
                    CurrTx := CurrInt;
                 GetItem ( ListInfo.ActiveDb, 15 );   // First Tx
                 If CurrInt <> 0 Then
                    ActiveRec := CurrInt
                 Else
                     ActiveRec := CurrTx;
                 If CurrTx = 0 Then
                    CurrTx := ActiveRec;
              End;
           SetDb ( TxFile );
           // gather up transactions
           RecCounter := ActiveRec;
           ItemTo := AccsDataModule.TransactionsDB.recordcount;
           While ( RecCounter <= ItemTo ) do
                               Begin
                                     ReadRec ( TxFile, RecCounter );
                                     RecOk := RecActive ( TxFile );
                                     If RecOk Then
                                        RecOK := CheckEditStatus;
                                     GetItem ( TxFile, 16 );
                                     If CurrInt <= 0 Then
                                        RecCounter := ItemTo + 1
                                     Else
                                         RecCounter := CurrInt;
                                     If RecOK Then begin
                                        List.RowCount := List.RowCount + 1;
                                        GetItem ( TxFile, 2 );
                                        List.Cells [0, GridPos] := CurrStr;
                                        GetItem ( TxFile, 1 );
                                            Case CurrInt Of
                                                          1,
                                                          5 : List.Cells [1, GridPos] := 'INV';
                                                          2,
                                                          6 : List.Cells [1, GridPos] := 'PAY';
                                                          3,
                                                          7 : List.Cells [1, GridPos] := 'CRN';
                                            End;
                                            GetItem ( TxFile, 9 );
                                            TotAmt := CurrLong;
                                            GetItem ( TxFile, 11 );
                                            TotAmt := CurrLong + TotAmt;
                                            LongStr ( TotAmt, CurrStr, 'L' );
                                            List.Cells [2, GridPos] := CurrStr;
                                            inc(GridPos);
                                           // List.RowCount := List.RowCount + 1;
                                     end;
                               End;

        End;
End;

Procedure TNewListBox.FillNomGrid;
Var
        GridPos, i : Integer;
        myRect: TGridRect;
Begin

     NewListBox.Caption := 'List Nominal Accounts';
     List.Cells[0,0] := 'No';
     List.Cells[1,0] := 'Name';
     NomGridPos := 1;
     FirstExp := 0;
     List.RowCount := 1;


     With ListInfo Do
          Begin
               ListNominals ( AccRange[1], AccRange[2]);
               ListNominals ( AccRange[3], AccRange[4]);
               ListNominals ( AccRange[5], AccRange[6]);
          End;

     If ( PROG = CASHEXP ) Or ( PROG = PurchTx ) Then
        Begin
            if FirstExp > 0 then begin
                  setgridposition := true;
            end;
        End

End;

Procedure TNewListBox.ListNominals(RangeStart,RangeEnd : integer);
var
        recno : integer;
        searchtext, teststring : string;
        recok : boolean;
begin
   // lists nominal codes between the two ranges
     searchtext := searchfield.Text;
     Accsdatamodule.NLFileDB.open;
     if rangestart = 0 then rangestart := 1;
     Accsdatamodule.NLFileDB.Locate('NLNo',RangeStart,[]);
     for recno := RangeStart to RangeEnd do begin
            if ((Accsdatamodule.NLFileDB['Active'] = True) And ( not ExcludeNominal ( RecNo ))) then begin
               recok := true;
               if length(searchtext) <> 0 then begin
                  try teststring := Accsdatamodule.NLFileDB['Name']
                  except
                  end;
                  recok := false;
                  if pos(ansilowercase(searchtext),ansilowercase(teststring)) > 0 then recok := true;
                  if pos(ansilowercase(searchtext),Accsdatamodule.NLFileDB['NLNo']) > 0 then recok := true;
               end;
               if recok then begin
                  try List.Cells [0, NomGridPos] := Accsdatamodule.NLFileDB['NLNo'];
                  except List.Cells [0, NomGridPos] := '';
                  end;
                  try List.Cells [1, NomGridPos] := Accsdatamodule.NLFileDB['Name'];
                  except List.Cells [1, NomGridPos] := '';
                  end;

                  // SP 04/07/2013 - Added Enterprise column
                  try List.Cells [2, NomGridPos] := Accsdatamodule.NLFileDB['Enterprise'];
                  except List.Cells [2, NomGridPos] := '';
                  end;

                  If ((Recno <= cash1.XNOMNONFROM) And (ListInfo.Ent <> '')) or
                     ((Recno < cash1.XNOMOHFROM) And ( ListInfo.Ent = '' )) Then
                         FirstEXP := NomGridPos;

                  List.RowCount := List.RowCount + 1;
                  inc(NomGridPos);
               end;
            end;
     Accsdatamodule.NLFileDB.next;
     end;
end;

procedure TNewListBox.NewButtonClick(Sender: TObject);
begin
 (*           { Call the Data Input Form }
            AddRecForm.ShowModal;
            { Re-list the information in the List if new record added }
            If AddRecForm.MadeNewRec Then
               ListRecords;
               *)
end;

procedure TNewListBox.SearchfieldKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if ((key = VK_UP) or (Key = VK_Down)) then begin
       List.setfocus;
   end;
end;

procedure TNewListBox.actNewExecute(Sender: TObject);
begin
   { Call the Data Input Form }
   AddRecForm.ShowModal;
   { Re-list the information in the List if new record added }
   If AddRecForm.MadeNewRec Then
      begin
         ListRecords;
         // SP 30/07/2014
         // Refresh all accounts if record has been added.
         AccsDataModule.Accounts.Refresh;
      end;
end;

procedure TNewListBox.actSelectExecute(Sender: TObject);
begin
   if ( List.Row <= 0 ) then
      begin
         MessageDlg('No selection has been made.',mtWarning,[mbOK],0);
         Exit;
      end

{   if List.Cells[0,List.Row] = 'No' then begin
                                              showmessage('No Selection Made');
                                              exit;
                                         end;}
   else if ListInfo.ListType = 'L' then ListInfo.ReturnValue := List.Cells[2,List.Row]
   else ListInfo.ReturnValue := List.Cells[0,List.Row];

   SlimAll ( ListInfo.ReturnValue );
   ModalResult := mrCancel;
end;

procedure TNewListBox.actCancelExecute(Sender: TObject);
begin
   ModalResult := mrCancel;
   Close;
end;

procedure TNewListBox.ListSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   SelectedRow := ARow;
end;

procedure TNewListBox.FormCreate(Sender: TObject);
begin
   FFormShowing := False;
   SelectedRow := 0;
end;

procedure TNewListBox.SearchfieldPropertiesChange(Sender: TObject);
begin
   Update;
   if (FFormShowing) and (ModalResult <> mrCancel) then
      Listrecords;
end;

procedure TNewListBox.ListIt(Sender: TObject; AccountType: TRange;
  ListType: Char; const AFocusedAccountNo: string);
begin
   FFocusedAccountNo := AFocusedAccountNo;
   ListIt(Sender, AccountType, ListType);
end;

procedure TNewListBox.FocusRow(const AFocusedAccountNo: string);
var
   nRow : Integer;
begin
   if (Length(Trim(AFocusedAccountNo))<=0) then Exit;

   for nRow := 0 to List.RowCount-1 do
      begin
         if (List.Cells[0,nRow] = AFocusedAccountNo) then
            begin
               Newlistbox.List.TopRow := nRow;
               Newlistbox.List.Row := nRow;
               Break;
            end;
      end;
end;

procedure TNewListBox.actNewUpdate(Sender: TObject);
var
   IsNominalLedgerAccount : Boolean;
begin

   // Disable adding of new Income/Expense nom if cPref_AllowNominalLedgerAccess = false
   // and the specified range includes Income/Expense accounts.
   IsNominalLedgerAccount :=
      (FAccountType in [AllNoms ,
                        AllNomsPlusCapital,
                        AllNomsXBank,
                        NonEnt,
                        NonEntToLiab,
                        Liab,
                        Banks,
                        FAsset,
                        CAsset,
                        OverHeads,
                        OverHeadsToLiab,
                        OverHeadsWithExpense,
                        EntAllIncome,
                        EntAllExpend,
                        EntRange,
                        AllNomsPlusCapitalLessControl]);

   // allow access to nominal account editing if search account type
   // is NOT Income or Expense type
   if not (IsNominalLedgerAccount) then
      actNew.Enabled := True
   else
      // only allow access to nominal account editing based on preference setting.
      actNew.Enabled := Preferences.ValueAsBoolean[cPref_AllowNominalLedgerAccess];
end;

// temp solution to list groups from Setup.pas, should refactor at later stage. 07/01/2013
procedure TNewListBox.ListGroups(Sender: TObject; AccRange: TAccRange);
begin
   ListInfo.ReturnValue := '';
   InitRange ( NewListBox.ListInfo.AccRange );
   ListInfo.ActiveDb := NlFile;
   ListInfo.ListType := 'G';
   ListInfo.AccRange := AccRange;
   Setscreen(ListInfo.ListType);
   SearchField.visible := true;
   SearchLabel.Visible := true;

   FRecordsListed := False;
   setgridposition := false;

   List.ColWidths[0] := 50;
   Setscreen(NewListBox.ListInfo.ListType);


   ListRecords;

   ShowModal;
end;

procedure TNewListBox.FormShow(Sender: TObject);
{var
  Flag: UINT;
  AppSysMenu: THandle;}
begin
{  AppSysMenu:=GetSystemMenu(Handle,False);
  Flag:=MF_GRAYED;
  EnableMenuItem(AppSysMenu,SC_CLOSE,MF_BYCOMMAND or Flag);
  }

end;

end.
