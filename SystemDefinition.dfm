�
 TSYSTEMDEFINITIONFORM 0vE  TPF0TSystemDefinitionFormSystemDefinitionFormLeftrTop� BorderStylebsDialogCaptionSystem DefinitionClientHeight"ClientWidth�Color	clBtnFaceFont.CharsetANSI_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.Style OldCreateOrderPositionpoDesktopCenterOnShowFormShowPixelsPerInch`
TextHeight TPanelPanel3Left Top Width� Height1
BevelInner	bvLowered
BevelOuter	bvLowered
BevelWidthBorderStylebsSingleColorclSilverTabOrder  TBitBtnExitbtnLeftTopWidthQHeight!HintPress to ExitCancel	CaptionE&xitParentShowHintShowHint	TabOrder OnClickExitbtnClick
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 3     33wwwww33333333333333333333333333333333333333333333333?33�33333s3333333333333���33��337ww�33��337���33��337ww3333333333333����33     33wwwwws3	NumGlyphs  TBitBtnSaveBtnLeftXTopWidthQHeight!HintPress To ConfirmCaption&SaveParentShowHintShowHint	TabOrderOnClickSaveBtnClick
Glyph.Data
�  �  BM�      6  (   $            �                      �  �   �� �   � � ��  ��� ��� �ʦ                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ��� ��� ���   �  �   �� �   � � ��  ��� �����������������������������������������������������������������������������	NumGlyphs   TPageControlPageControl1LeftTop;WidthaHeight�
ActivePageGeneralTabOrder 	TTabSheetGeneralCaptionGeneral 	TGroupBox	GroupBox2Left
Top
WidthHeightiCaption Accounts Details TabOrder  TLabelLabel3LeftTopWidthPHeightCaptionCompany Name  TLabelCompanyNameLeft� TopWidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel4LeftTop0Width<HeightCaptionData Path -   TLabelPathLeft� Top0WidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TButtonChangeDataPathLeftpTopHWidth� HeightCaptionChange Data PathTabOrder OnClickChangeDataPathClick   TRadioGroup
SystemTypeLeft0Top
Width� HeightiCaption System Type Items.StringsCashbookLedgerLedger with Cashbook Option TabOrder  TRadioGroupVATGroupLeft�Top
Width� HeightPCaption VAT - Country Items.StringsIrelandUnited Kingdom TabOrderVisible  	TGroupBox	GroupBox3Left�TopeWidth� Height0Caption Extra Partners TabOrder TLabelLabel6LeftTopWidth� HeightCaptionNumber of extra Partners -   TEdit
NoPartnersLeft� TopWidth!HeightTabOrder    	TGroupBoxSerialPanelLeft
TopvWidthHeight� Caption Serial Numbers TabOrder TLabelLabel1LeftTop0WidthxHeightCaptionSystem Serial Number -   TLabelDefSerialNoLeft� Top0WidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel2LeftTopHWidthmHeightCaptionData Serial Number -   TLabelCashSerialNoLeft� TopHWidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel5LeftTopWidthtHeightCaptionToken Serial Number -   TLabelTokenSerialNoLeft� TopWidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TButtonChangeSerialLeftTophWidth� HeightCaptionChange Data Serial NumberTabOrder OnClickChangeSerialClick   	TGroupBox	GroupBox1Left0TopvWidth� Height� Caption Accounts Options Installed TabOrder 	TCheckBoxUse_EnterpriseLeftTop(Width� HeightCaptionEnterprisesTabOrder   	TCheckBoxUse_VatLeftTopWidth� HeightCaptionVATTabOrderOnClickUse_VatClick  	TCheckBoxUse_billingLeftTop@Width� HeightCaptionBillingTabOrder  	TCheckBoxInvoicerLeftTopXWidth� HeightCaptionInvoicer / JobcardsTabOrder  	TCheckBoxInvoiceAllocCBLeftToppWidth� HeightCaptionUse Invoice AllocationParentShowHintShowHintTabOrder  	TCheckBoxcbPaymentBasedVatLeftTop� Width� HeightCaptionPayment Based VatParentShowHintShowHintTabOrder   	TGroupBox	GroupBox4Left�Top� Width� Height0Caption Archive Data TabOrder 	TCheckBox	ArchiveCBLeftTopWidthaHeightCaptionArchive DataTabOrder    	TGroupBoxgbCashbookLastTxLeft�Top� Width� Height0Caption Cashbook LastTxTabOrder TEditeCashBookLastTxLeftTopWidthQHeightTabOrder 
OnKeyPresseCashBookLastTxKeyPress   	TGroupBoxgbNomProdRelationshipLeft
TopWidth�Height� CaptionNominal/Product AssociationFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.StylefsBold 
ParentFontTabOrder TLabelLabel7LeftTopRWidth�HeightAAlignalBottomCaption"  This setting comes into effect in the JobCard app and possiblity other places yet to be defined. If there is a one to one relationship between the two entities, we must only display Nominal () within the app. When a job has been synced its then possible to retrieve the product using the one to one relationship.
If a One to Many or Many to Many relationship is selected, these settings will enable the app to display both Nominal and Product entities allowing that bit more flexibility but is slightly more onerous for the user to record a job.Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.Style 
ParentFontWordWrap	  TRadioGrouprgNomProdRelationshipLeft0TopWidthYHeight1Caption7Select relationship between Nominal and Product recordsColumnsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameSegoe UI
Font.Style Items.Strings
One to OneOne to ManyMany to Many 
ParentFontTabOrder    	TCheckBoxSimpleVATCheckboxLeft�Top;WidthVHeightCaption
Simple VATTabOrder	   	TTabSheetNominalAccountsCaptionNominal Accounts
ImageIndex TLabelLabel58Left�Top� Width�HeighthCaptionr  Note - 

1. Any changes to this structure can only be carried out on blank data 
    (no updating of existing codes to reflect changes).

2. Any changes to this structure require the NLFile & NLGroups files to be rebuilt 
    from scratch. The button below deletes the existing files && creates the new files     adding in the control accounts (and a default bank)WordWrap	  	TGroupBoxgbControlAccountsLeft`TopWidth� Height� Caption& Control Accounts - 43 Codes in Total TabOrder TLabelLabel19LeftTopHWidthGHeightCaptionVAT Control -   TLabelLabel20Left� TopHWidthHeightCaption(841)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel21LeftTop`Width]HeightCaptionDebtors Control -   TLabelLabel22LeftTopxWidthcHeightCaptionCreditors Control -   TLabelLabel23LeftTop� WidthuHeightCaptionP/L Brought Forward -   TLabelLabel24Left� Top`WidthHeightCaption(842)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel25Left� TopxWidthHeightCaption(843)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel26Left� Top� WidthHeightCaption(844)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel27LeftTopWidthJHeightCaptionPrivate Income  TLabelLabel28Left� TopWidthHeightCaption(821)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel29LeftTop0WidthcHeightCaptionPrivate Expenditure  TLabelLabel30Left� Top0WidthHeightCaption(831)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelOpeningNetWrothLeftTop� WidthqHeightCaptionOpening Net Worth -   TLabelLabel31Left� Top� WidthHeightCaption(854)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TEdit
VATControlLeft� TopDWidthAHeightEnabledTabOrder Text
VATControl  TEditDebtorsControlLeft� Top\WidthAHeightEnabledTabOrderTextDebtorsControl  TEditCreditorsControlLeft� ToptWidthAHeightEnabledTabOrderTextCreditorsControl  TEditPLBroughtForwardLeft� Top� WidthAHeightEnabledTabOrderTextP/LBroughtForward  TEditPrivateIncomeLeft� TopWidthAHeightTabOrderTextPrivateIncome  TEditPrivateExpenditureLeft� Top,WidthAHeightEnabledTabOrderTextPrivateExpenditure  TEditOpeningNetWorthLeft� Top� WidthAHeightEnabledTabOrderTextOpeningNetWorth   	TGroupBoxgbBanksLeft�Top`Width� HeightQCaption Banks TabOrder TLabelLabel32LeftTopWidth1HeightCaptionBank Min  TLabelLabel33Left� TopWidthHeightCaption(801)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel34LeftTop0Width2HeightCaptionBank Max  TLabelLabel35Left� Top0WidthHeightCaption(820)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TEditBankMinLeftPTopWidthAHeightTabOrder TextBankMin  TEditBankMaxLeftPTop,WidthAHeightTabOrderTextBankMax   	TGroupBoxgbEntIncomeLeftTopWidth� HeightQCaption Enterprise Income TabOrder  TLabelLabel36Left� TopWidthHeightCaption(1)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel37Left� Top0WidthHeightCaption(180)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel38LeftTopWidthHeightCaptionFrom  TLabelLabel39LeftTop0WidthHeightCaptionTo  TEdit
NomIncFromLeft8TopWidthAHeightTabOrder Text
NomIncFrom  TEditNomIncToLeft8Top,WidthAHeightTabOrderTextNomIncTo   	TGroupBoxgbEntExpenseLeftTop� Width� HeightQCaption Enterprise Expenditure TabOrder TLabelLabel40Left� TopWidthHeightCaption(201)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel41Left� Top0WidthHeightCaption(400)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel42LeftTopWidthHeightCaptionFrom  TLabelLabel43LeftTop0WidthHeightCaptionTo  TEdit
NomExpFromLeft8TopWidthAHeightTabOrder Text
NomExpFrom  TEditNomExpToLeft8Top,WidthAHeightTabOrderTextNomExpTo   	TGroupBoxgbNoneEntIcomeLeftTopjWidth� HeightyCaption Non-Enterprise Income TabOrder TLabelLabel44Left� TopWidthHeightCaption(181)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel45Left� Top0WidthHeightCaption(200)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel46LeftTopWidthHeightCaptionFrom  TLabelLabel47LeftTop0WidthHeightCaptionTo  TLabelLabel48LeftTopHWidthdHeightCaptionPurchase Discounts  TLabelLabel49LeftITop`WidtheHeightCaption(Last Code In Range)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TEditNonEntIncFromLeft8TopWidthAHeightTabOrder TextNonEntIncFrom  TEditNonEntIncToLeft8Top,WidthAHeightTabOrderTextNonEntIncToOnExitNonEntIncToExit  TEditPurchaseDiscountsLeftxTopHWidth)HeightEnabledTabOrderTextPurchaseDiscounts   	TGroupBoxgbOverheadsLeft� TopWidth� Height� Caption Overheads TabOrder TLabelLabel50Left� TopWidthHeightCaption(401)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel51Left� Top0WidthHeightCaption(500)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel52LeftTopWidthHeightCaptionFrom  TLabelLabel53LeftTop0WidthHeightCaptionTo  TLabelLabel54LeftTopHWidthPHeightCaptionSales Discounts  TLabelLabel55LeftITop`WidthdHeightCaption(First Code In Range)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel56LeftITop� WidtheHeightCaption(Last Code In Range)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel57LeftTopxWidthBHeightCaptionDepreciation  TEditOverheadsFromLeft8TopWidthAHeightTabOrder TextOverheadsFromOnExitOverheadsFromExit  TEditOverheadsToLeft8Top,WidthAHeightTabOrderTextOverheadsToOnExitOverheadsToExit  TEditSalesDiscountsLefthTopDWidth1HeightEnabledTabOrderTextSalesDiscounts  TEditDepreciationLefthToptWidth1HeightEnabledTabOrderTextDepreciation   	TGroupBoxgbCurrentAssetsLeft� Top� Width� HeightICaption Current Assets TabOrder TLabelLabel59Left� TopWidthHeightCaption(501)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel60Left� Top0WidthHeightCaption(600)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel61LeftTopWidthHeightCaptionFrom  TLabelLabel62LeftTop0WidthHeightCaptionTo  TEditCAFromLeft8TopWidthAHeightTabOrder TextCAFrom  TEditCAToLeft8Top,WidthAHeightTabOrderTextCATo   	TGroupBoxgbFixedAssetsLeft� TopWidth� HeightQCaption Fixed Assets TabOrder TLabelLabel63Left� TopWidthHeightCaption(601)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel64Left� Top0WidthHeightCaption(700)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel65LeftTopWidthHeightCaptionFrom  TLabelLabel66LeftTop0WidthHeightCaptionTo  TEditFAFromLeft8TopWidthAHeightTabOrder TextFAFrom  TEditFAToLeft8Top,WidthAHeightTabOrderTextFATo   	TGroupBoxgbLiabilitiesLeft�TopWidth� HeightQCaption Liabilities  TabOrder TLabelLabel67Left� TopWidthHeightCaption(701)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel68Left� Top0WidthHeightCaption(800)Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel69LeftTopWidthHeightCaptionFrom  TLabelLabel70LeftTop0WidthHeightCaptionTo  TEditLiFromLeft8TopWidthAHeightTabOrder TextLiFrom  TEditLiToLeft8Top,WidthAHeightTabOrderTextLiTo   TButtonRebuildDataBtnLeftHTopAWidthHeightCaption.Delete Nominal File && rebuild with new rangesTabOrder	OnClickRebuildDataBtnClick     