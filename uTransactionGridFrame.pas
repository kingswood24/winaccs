unit uTransactionGridFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxClasses, cxGridLevel, cxGrid;

type
  TTransactionGridFrame = class(TFrame)
    TransactionGridLevel: TcxGridLevel;
    TransactionGrid: TcxGrid;
    TransactionGridTableView: TcxGridTableView;
    TransactionGridTableViewTradeAccount: TcxGridColumn;
    TransactionGridTableViewDate: TcxGridColumn;
    TransactionGridTableViewReference: TcxGridColumn;
    TransactionGridTableViewComment: TcxGridColumn;
    TransactionGridTableViewNomCode: TcxGridColumn;
    TransactionGridTableViewNomDesc: TcxGridColumn;
    TransactionGridTableViewVatCode: TcxGridColumn;
    TransactionGridTableViewVatAmt: TcxGridColumn;
    ransactionGridTableViewTotalIncVat: TcxGridColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
