{
  File	    : Startup Parameters.PAS   TGM AB 19/02/02
  Unit	    :
  Prefix    :
  Status    :
  Level	    :

  DATE'S
  Started   : 15/02/02
  Finished  : 19/02/02

  This unit contains the procedures for dealing with the input parameters.

  Format for sending in parameters is Winaccs X YYYY 111x111, (only 1 space between each)
  where X is transaction type
        P - Purchase
        S - Sale
        M - Mainscreen
        R - Reports Screen
        SL - Slaccs Dump
        NL - Nlaccs Dump
        C - Check Company Screen

    YYYY is accounts set / company name (e.g. accs)

    111x111 is the serial number of the Herd Program

    NB These parmaeters are NOT CASE SENSITIVE!

  Special Case - Opening up check company from Herd using serial number of Herd Program
                 Format for sending in parameter is Winaccs X 111x111 (accs company removed)

}

unit startparameters;

interface

         Procedure Checkparams;
 //        Procedure cashbooktrans;
 //        Procedure ledgertrans;

var
         transtype : string;
         companyname : string;

implementation

uses dialogs, forms, chkcomp, accsdata, sysutils, mainunit, vars, cashbook, registry,
     ShellAPI, Windows, AccsUtils, Params;

procedure Checkparams;
var
   i: integer;
   herdserialno, parameterserialnumber : string;
   registry : TRegistry;
begin
     // set global variable param_start which is used later under exit buttons
     // to kill the aplication and not return to the main screen

     param_start := true;

     // parameter validity checking

     if ( Paramcount > 3 ) then
        begin
           Showmessage ('Too Many Parameters Specified');
           application.terminate;
        end;

     if ((Paramcount < 2) and (Paramcount > 0)) then begin
                            Showmessage ('Not enough parameters specifed');
                            application.terminate;
                            end;

     if ( length(ParamStr(1)) > 2 ) then
        begin
           Showmessage ('Transaction Type Incorrect - Should be P, S, R, M, NL, SL, C');
           application.terminate;
        end;

     transtype := copy(ParamStr(1),1,2);

     if lowercase(transtype) = 'p' then transtype := 'P'
        else if lowercase(transtype) = 's' then transtype := 'S'
             else if lowercase(transtype) = 'r' then transtype := 'R'
                  else if lowercase(transtype) = 'm' then transtype := 'M'
                       else if lowercase(transtype) = 'nl' then transtype := 'NL'
                            else if lowercase(transtype) = 'sl' then transtype := 'SL'
                                 else if lowercase(transtype) = 'c' then transtype := 'C'
                                      else begin
                                           showmessage('Transaction Type Incorrect - Should be P, S, R, M, NL, SL');
                                           application.terminate;
                                           end;

     // Global paramter used to specifly the transaction tpye (Purchase, Sale, Mainscreen, Reports)
     // used when setting up the correct PROG when setting up the cashbookform in a cash book system.

     param_type := transtype;

     if ( param_type = 'C' ) then
        begin
           ParameterSerialNumber := copy(ParamStr(2),1,length(ParamStr(2)));
           registry:= Tregistry.Create;
           Registry.OpenKey('Software\Kingswood\kcc', True);
           HerdSerialNo := Registry.ReadString('Serial Number');
           Registry.Free;

           if not (ansilowercase(ParameterSerialNumber) = ansilowercase(HerdSerialNo)) then
              if ( NOT FCheckName.CheckProtection ) then
                 Application.Terminate;

           ParamSecurityByPass := true;
        end
     else
        begin
           // this section gathers all the available companies and checks the lower
           // case version against the lower case verion of the company paramter and
           // assigns the correct company Name

           // these 2 lines avoid the need to show the chkcomp form
           FCheckName.OnShow(FCheckName);
           FCheckName.OnActivate(FCheckName);

           FCheckName.GatherCompanies;
           companyname := '';
           for i := 0 to Fcheckname.CheckCompanyName.Items.Count-1 do
              if ( AnsiLowerCase(Paramstr(2)) = (AnsiLowerCase(Fcheckname.CheckCompanyName.Items[i])) ) then
                 begin
                    companyname := Fcheckname.CheckCompanyName.Items[i];
                    //   18/01/17 [V4.2 R5.6] /MK Bug Fix - Default company name to item that matches ParamStr(2). Assigning FCheckName.CheckCompanyName.Text doesn't work. 
                    FCheckName.CheckCompanyName.ItemIndex := i;
                    AccsDataModule.UseThisAlias(companyname);
                 end;

           if ( companyname = '' ) then
              begin
                 showmessage('Incorrect Company Name');
                 application.terminate;
              end;

           // copy protection check
           if ( paramcount < 3 ) then
              begin
                 if ( NOT FCheckName.CheckProtection ) then
                    Application.Terminate
                 else
                    begin
                       ParameterSerialNumber := copy(ParamStr(3),1,length(ParamStr(3)));
                       registry:= Tregistry.Create;
                       Registry.OpenKey('Software\Kingswood\kcc', True);
                       HerdSerialNo := Registry.ReadString('Serial Number');
                       Registry.Free;
                       if not (ansilowercase(ParameterSerialNumber) = ansilowercase(HerdSerialNo)) then
                          if ( NOT FCheckName.CheckProtection ) then
                             Application.Terminate;
                    end;

                 FCheckName.CheckCompanyNameExit(FCheckName);
                 // last line is needed to set the correct set of accounts in the cashbook.def
                 // file otherwise the last set of accounts is always opened not those specified

                 if FileExists(PChar(ApplicationPath + companyname + '\trans.fdb')) then
                    InvokeExternalProgram(ApplicationPath + 'dataconvert.exe');
              end;
        end;
end;

end.
