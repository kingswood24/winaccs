unit uPreferenceConsts;

interface

const
   cPref_RegPath = 'SOFTWARE\Kingswood\Kingsacc\Preferences\';

   { Preference Items }
   cPref_EnableTransGridColumnGrouping = 'EnableTransGridColumnGrouping';
   cPref_EnableSLPLDefaults = 'EnableSLPLDefaults';
   cPref_EnableInvoiceAllocation = 'EnableInvoiceAllocation';
   cPref_EnableCoOpImport = 'EnableCoOpImport';

   cPref_ShowStubNoColumn = 'ShowStubNoColumn';
   cPref_ShowCustomerColumn = 'ShowCustomerColumn';
   cPref_ShowSupplierColumn = 'ShowSupplierColumn';
   cPref_ShowQuantityColumn = 'ShowQuantityColumn';
   cPref_ShowCommentColumn = 'ShowCommentColumn';
   cPref_ShowAnalysisCodeColumn = 'ShowAnalysisCodeColumn';

   cPref_ShowKeyReportsMenu = 'ShowKeyReportsMenu';
   cPref_AllowNominalLedgerAccess = 'AllowNominalLedgerAccess';

   cPref_AutoEntSelect = 'AutoEntSelect';

   // SP 04/04/2014
   cPref_AllowFreeTextForNominalDescriptionColumn = 'AllowFreeTextForNominalDescriptionColumn';

   // SP 26/03/2015
   cPref_JobCard_SyncOnOpen = 'JobCardSyncOnOpen';

   cPref_Enable_PaymentBasedVat = 'EnablePaymentBasedVat';

   // For Age of Debt analysis - currently used in the Sync process only
   cPref_AgeOfDebt_AgedBy_Month = 'AgeOfDebt_AgedBy_Month';

   cPref_ShowKingswoodAccsAppInfo = 'ShowKingswoodAccsAppInfo'; 

   // SP 20/12/2016
   cPref_OutputAgeOfDebtOnSync = 'OutputAgeOfDebtOnSync';
   cPref_OutputExtendedStatementOnSync = 'OutputExtendedStatementOnSync';
   cPref_DownloadJobCardOncePerSession = 'DownloadJobCardOncePerSession';

   cPref_OutputJobCardRptOnSync = 'OutputJobCardRptOnSync';
   cPref_ProformaRptOnSync = 'cPref_ProformaRptOnSync';

   //   15/11/18 [V4.3 R2.7] /MK Additional Feature - Added the New Features registry entries.
   cPref_ShowBankLinkFeatures = 'ShowBankLinkFeatures';
   cPref_ShowCoOpLinkFeatures = 'ShowCoOpLinkFeatures';
   cPref_ShowAccountantLinkFeatures = 'ShowAccountantLinkFeatures';

   cPref_ShowSalePurchGridMainGrid = 'ShowSalePurchGridMainGrid';

   //   26/11/20 [V4.5 R4.6] /MK Change - New const for ShowBankLinkFileNotFound.
   cPref_ShowBankLinkFileNotFound = 'ShowBankLinkFileNotFound';

implementation

end.
