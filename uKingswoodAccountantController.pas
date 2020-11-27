unit uKingswoodAccountantController;

interface
uses
   Sysutils, uKingswoodAccessControllerBase;

type
   TKingswoodAccountantController = class(TKingswoodAccessControllerBase)
   protected
      function GetAuthKey : string;override;
   end;

   function KAC : TKingswoodAccountantController;

var
   KingswoodAccountantController : TKingswoodAccountantController;

const
   cFileName = 'kac.config';
   cKey = 'IKlaOP8!8yTNSK]IYj/VeAoRE&wd54>dskdlsh+ppQoWSAg09sduv]3e4j]P093ca8g09sduv]3e4j]';

implementation

 { TKingswoodAccountantController }

   function KAC : TKingswoodAccountantController;
   var
      Path : string;
   begin
      if ( KingswoodAccountantController = nil ) then
         begin
            Path := IncludeTrailingBackslash( ExtractFilePath( paramStr(0)) );
            KingswoodAccountantController := TKingswoodAccountantController.create(Path + cFileName);
         end;
      Result := KingswoodAccountantController;
   end;
   
{ TKingswoodAccountantController }

function TKingswoodAccountantController.GetAuthKey: string;
begin
   Result := cKey;
end;

initialization

finalization
   if (KingswoodAccountantController <> nil) then
      FreeAndNil(KingswoodAccountantController);

end.
