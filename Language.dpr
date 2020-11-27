program Language;

uses
  Forms,
  Setlang in 'SETLANG.PAS' {LangForm},
  LangUnit in 'LANGUNIT.PAS',
  Calcs in 'CALCS.PAS',
  db_Types in 'TYPES.PAS',
  db_params in 'PARAMS.PAS',
  db_clears in 'CLEARS.PAS',
  db_vars in 'VARS.PAS';

{$R *.RES}

begin
  Application.CreateForm(TLangForm, LangForm);
  Application.Run;
end.
