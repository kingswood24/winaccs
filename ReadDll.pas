unit ReadDll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  TYPE
    TDataPtr = ^ccmb_rec_type;
    ccmb_rec_type = record
    ccmb          : array[1..4] of char;
    func          : byte;
    r_code        : shortint;
    drive         : byte;
    dir           : dword;
    vers          : shortint;
    s_n           : word;
    p_code        : array[1..9]  of char;
    p_name        : array[1..13] of char;
    cc_sn         : word;
    master        : byte;
    dr_typ        : byte;
    copies        : Word;
    init_copies   : word;
    uses_left     : word;
    i_uses        : word;
    exp_d         : byte;
    exp_m         : byte;
    exp_y         : word;
    feature       : word;
    net_users     : word;
    secure_msg    : array[1..257] of char;
    update_num    : word;
    flags1        : word;
    net_user_data : array[1..4] of byte;
    dos_time      : array[1..4] of byte;
    max_days      : word;
    res2          : dword;
    extended_err  : array[1..6] of byte;
    res_expand    : array[1..173] of byte;
end;

var
	Temp : TDataPtr;
  TCCRecord : ccmb_rec_type;

implementation
uses dllin;
{$R *.DFM}

function Check_Protection : Integer ; export;
// Function sets up memory pointers
var
i : Integer;
begin
  // initialise pointer variables
  Temp := @TCCRecord;
  // there is now no need to use ^ operator but will still operate with it
  New (Temp);
  Temp.ccmb[1] :='C';
  Temp.ccmb[2] :='C';
  Temp.ccmb[3] :='M';
  Temp.ccmb[4] :='B';
  Temp.r_code := -1;
  Temp.func := 0;
  Temp.drive := 0;
  Temp.dir := 0;
  Temp.Flags1 := 0;
  for i := 1 to 173 do Temp.res_expand[i] := 0;
  check_protection := CC32(Temp);
end;
//-------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
begin
	 messagedlg(Inttostr(check_protection),mtinformation,[mbok],0);
end;

end.
