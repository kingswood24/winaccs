unit Documentation;

// this unit's only purpose is to provide some documentation for subsequent programmers
// started 16/10/01 by G Megarry

// 16/10/01 NomReps:
// tgm altered 16/10/01 to check whether or not item is to included in VAT report by setting OKToPrint in line
// 1882 - I copied the code from lines 2043+ - I assume this is run first before line 1882 as the
// var testcode is initialised in lines 2043+
// lines 1833+ need altered if S ireland users to be allowed to include/exclude items from VAT return
// tgm added line 1895 to exclude VAT code 0 from S Ireland VAT return


//16/10/01 lines 1068+ in UPrintOut added by tgm 16/10/01 to pull in share of overheads from previous year.

// 23/11/01 lines arround 1138 in reportdefs altered to print VAT report headers properly

// earlier work:
// setup screen has been altered so if an enterprise code range gets altered, user can manually set the ranges for income and expenditure
// by double clicking on the number of codes input box

// work done summer 2001 by Duncan Burch - new units reportdefs and reports.  Basically, reportdefs parses the file produced by the program which was being sent to
// wordpad.  Addleftaligned column, addrightaligned column etc. create database fields in report.db - report.db has 30 blank fields f1 - f30
// add column then adds the fields f1 - f?? to the quickreport unit report.
// tgm edited DBs work a bit due to overlapping columns - altered the old code which produces the report headers etc to
// align the columns slightly differently.


// important notes:
// getitem and putitem are the main means of getting items from a database table and putting them back.  GetXXXX and putXXXX seem to be more
// or less exactly the same.
// Currint, CurrStr, Currlong etc are global variables used by getitem and putitem
// you need to know the item numbers of what you're getting or putting rather than the actual field names - the item number is the field number
// in the table.

// you get the item numbers by using the old database utilities to print off the database definitions.

// var ACT used widely - ACT changes during report processing, e.g. during the VAT report it starts off with a value, causing MAINFLOW
// to behave in a certain way.  When income has been printed, ACT is set to a different value, causing next loop of MAINFLOW to behave
// differently.

// PROG is another global variable used widely.

// VAT report - PROG is SPECREP, ACT  is 8 for the summary, 11 for the income details, 12 for the expenditure list

// transaction file types: tgm 18/10/01
// 1 = sales invoice start
// 2 =  sales receipt
// 3 =  sales credit note (I think)
// 5 = Purch Invoice
// 6 = Purch payment
// 7 = purchase credit note
// 9 =  detail line
// 0 =  VAT detail line
// 11,12, 15 & 16 are either standing orders or direct debits/credits or cashbook Inc/Exp totals
// Cashbook Inc has type 11 then type 9, type 0 and type 12
// Cashbook Exp + Standing Orders have type 15 then 9 then 0 then 16.
// Cashbook Inc & Exp may have multiple types 9 and 0

// the field ORIG TYPE identifies what the type 9 or type 0 belongs to, i.e. ORIG TYPE would be
// 5 if for the subsequent 9 and 0 type belonging to a purch invoice.

// tx write line 599 - code to correct 'S Order not saving description bug'
// + line 797
// 18/11/01 added 'and (act <> 0) to lines and 604 and 803 to stop from overwriting comment for
// cashbook inc & exp
// description is saved in comment field for standing orders but not for cashbook inc or exp
// this makes front grid show correctly + exp listing report show correctly
// 18/11/01 added following line to saveclick of cashbook
// if (prog = cashinc) or (prog = cashexp) then act := 0;
// as save click was not setting act to 0 when editing a cashbook transaction thus back to problem
// of above where nominal description was being saved for cashbook inc exp.

// tgm changes to nomreps:
// tgm altered 16/10/01 to check whether or not item is to included in VAT report by setting OKToPrint in line
// 1882 - I copied the code from lines 2043+ - I assume this is run first before line 1882 as the
// var testcode is initialised in lines 2043+
// lines 1833+ need altered if S ireland users to be allowed to include/exclude items from VAT return
// tgm added line 1895 to exclude VAT code 0 from S Ireland VAT return

// more notes 28/11/01:
// Standing orders : PROG = 12 ACT = 1
// Cashbook Expenditure : PROG = 12 ACT = 0
// Cashbook Income : PROG = 11 ACT = 0

// 28/11/01+ worked on the invoice print button in cashbook
// hit a problem when called InvoiceReport.Preview, as this seemed to force a cashbookForm .deactivate
// which in turn called FMainScreen.Visible := True;
// solved this by moving FMainScreen.Visible := True to form CashBookForm.close instead of CashbookForm.deactiviate
// hope this doesn't introduce any side effects

// New forms InvoicePrintForm and InvoiceLayoutForm

// 06/12/01 V2.2 R2.2  Fixed small bug in invoice report - total exc VAT was overlapping the each column - made
// total exec VAT not auto size and shrunk it a bit.

// 15/12/01 V2.2 R2.3  Fixed bug in payments screen where discount from previous payment was initially being
// included in the calculation for current balance when entering the next payment. lines 980 & 981 in cashbook

// added line 283 to chkcomp to fix bug where, if user changed from a company which had a nomlisting.db to one
// which hadn't (say an older archive), an error was generated after clicking on the sales button.

// added closeallfiles procedure to accsdatamodule to close all open files, queries and datasets so that backup
// doesn't throw a wobbler
// added call to closeallfiles in line 730 of Mainunit (Backup button)

// 22/12/01  V2.2 R2.4 altered font size in invoice report to allow more description lines per page

// slaccs-1 & placcs-1 dbase fields -
   // balance-bf = balance brought forwrd - beginning of statement
   // balance-st = balance at start of ledger i.e. balance at start of current year
   // first-year = first tx on ledger
   // first-tx = first tx on statement

// current reset pointers code sets both first-year and first-tx to first-year value.
// not a problem with winaccs systems as they don't give user option to do a sales/purchase
// reset pointer during the course of the year.  DOS accs however did allow users to do
// a sales/purchase pointer reset during the month end.  This only reset the first-tx pointer, i.e.
// the statement start pointer


// 19/02/02 TGM AB  New Unit Startup Parameters

//  This unit contains the procedures for dealing with the input parameters.

//  Format for sending in parameters is Winaccs X YYYY, (only 1 space between each!)
//  where X is transaction type
//        P - Purchase
//        S - Sale
//        M - Mainscreen
//        R - Reports Screen
//    and YYYY is accounts set / company name (e.g. accs)

//    NB These parmaeters are NOT CASE SENSITIVE!

// 19/02/02 TGM AB Added global param_start (boolean) & param_type (string)
//  (S - Sales, P - Purchase, M - Mainscreen, R - Reports) when running the program with startup parameters
// also firstrun - used as flag to trigger trial balance check first time main screen is viewed

// If parameters are detected the program starts creating the minimum number of forms

// 12/03/02 TGM AB Altered code under winaccs, to load only specific forms needs when running in a reduced manner
//

// 05/03/02 TGM AB Data Integrity Check.

// The following checks are preformed under the trial balance report button
//                          Trial Balance Check
//                          Missing nominal Accounts
//
// if ledger version also,
//                          Sales ledger balances
//                          Purchase ledger balances
//                          Age of debts - match control accounts
//
// The following checks are preformed under the full audit trial button
//                          Nominal pointer reset
//                          Missing nominal Accounts
//

// 22/04/02 V2.2 R3.7 tgm altered year end archive code in YearArch, arround line 299
// use copy file command instead of the old fashioned copy procedures there before.
// use a dynamic array, which is sized using setlength, instead of a fixed length array
// this means that no matter how many files there are, they'll all be copied.
// also changed the vars tot_space_needed and free  to Int64 - larger HDDs were giving
// insufficient disk space errors as the longint var couldn't store the large size returned by the diskfree function

// bug in ledger card fixed 01/05/02 where opening balance and hence running balance was incorrect if a date range
// was selected.
// stmrep - various place if prog in [CUSTSTM,SUPPSTM] changed to if prog in [CUSTSTM,SUPSTM,VUSTLED,SUPPLED] so that
// the opening balance is recalulated properly for ledger cards. see arround line 1321
// STINTS^[22] etc are the Statement parameters and are used to position the output
// Nsrep11 - line 1966 - code for printing individual lines on the balance sheet - moved print postion by 1 to get right hand brackets to
// line up properly


//  V2.2 R5.4
//  GM altered audit and full audit considerably 11/05/02
//  new function in full audit to getfirstTx of current year
// note SETDB (NlFile) opens nlfile, db1.dbrectot do gets total records equivalnet to delphi db.recordcount
// also note db1.dbrechigh returns rec no of highest used record in the file
// cash1.xlasttx is the last active tx - this is how prog knows whether trans can be edited ot not.

// altered fillgrid in Mainunit so only items >= firsttx are shown in grid
// arround line 334

// gm wrote function testforfirsttx. this keeps trying the nominal balance check until the first trans where check passes
// is found.- not implemented as not sure if it would be reliable - button not visible

// V2.2R5.8
// tgm fixed bug: when using alt S to save, program was not putting in the .00 if whole number entered as amount paid
// line 858 in cashbook

//  tgm fixed bug where program did not save a stub number if it was changed on the way through a payment or receipt screen and next stub was the same number
// line 1956 approx in cashbook - the var used to store the last used stub number is xRecStub/xPayStub.  also stub[1] used

// amended payment screen so that stub number appears after exiting from bank edit box, rather than on exiting stub number box
// line 1609 in cashbook

// V2.2R5.9
// tgm added code under save buttons in cashbook, othForm and BankAct to save lastbank in xLastBank
// V2.2R6.0  entering a text string >= 2 characters long in supplier or customer edit box automatically brings up
// list box.

// v2.2 r6.1
// code entered for onkeydown event to automatically bring up list box if non numeric key pressed in nom column in cashbook

// V2.2 R6.2  altered code for onkeydown on cashbook grid to exclude numeric keys on keypad in automatic F2 list dropdown

// V2.2 R6.4  fixed bug which deleted customers/suppliers if cancel was clicked on after adding a new customer/supplier

// V2.2 R6.6  changed data integrity check to ignore Edits and Reversals, which come in From DOS, usually cancel each other out
//            however if they don't, previously the data check wrongly showed errors, and 'fixed' the data incorrectly!

// V2.2 R6.7  fixed report length for profit/loss report

// V2.2 R6.8  changed budget setup screen to automatically recalulate Year Total when individual months change.
//             column order now correct going by the financial year start month

// V2.2 R6.9  amended exit button click in cashbook to cater for parameter strings other than S and P

// V2.2 R7.0  adjusted budget setup to allocate budget across zero months only

// V2.2 R7.1  changed column placing, headings & layout & in Costing Report - This Year report

// V2.2 R7.2  fixed bug with 'This Year Monthly' report, which disabled the panels corresponding to all the nominal reports
//            so the user was unable to change any of the options (required restart to re-enable)

// V2.2 R7.3  adding of allocating budgeting unit/form (uAllocatebudgets) to prompt user to allocate budget

// 26/06/02  gm added button in full audit to fix bank rec descriptions in cashbook systems.
// problem was caused by earlier change by gm when lines arround 798 in txwrite were remmed out by gm
// note - cashbok exp starts with trans type 15, then 9 them 0 then a 16.
// cashbook income starts with 11 then 9 then 0 then 12
// note also that the orig type field stores the 1st type of the sequence, i.e. all 4 transactions in
// cashbook exp (15, 9, 0, 16) have orig type set to 15

// V2.2 R7.9 GM fixed bug in incomeclick in cashbook where comment was being cleared if editing

// V2.2 R8.0 TGM AB Merged release code with the new jobcard / proforma section and transfered any bug fixes etc.
// Fixed bug with invoice number reset to 0 when printing a proforma as an invoice

// V2.2 R8.1 02/08/02 TGM AB amended code creating / amending tables relating to invoicer / jobcard so
// all necessary fields & tables are created in older (already have tables with only some fields)
// and new systems.
// validation on simple input grid
// Test version running with vat calculations

// account name on Vat audit trail using a cashbook system now functions as trans now linked to a customer/supplier
// customer / supplier drop down  added to cashbook form

// V2.2 R8.4 Added budgets button to main screen
// Added password to nominla & enterprise setup screens
// Altered cashbook systems to store customer / supplier address details but no balances etc.
// NlaccsExt Table altered
// Updated data dump to run automatically on exiting

// V2.2 R8.5 TGM AB - removed threshold limitations of Fixing buttons on fullaudit form (balance repair buttons)
// Added depreciation boxes to asset code setup
// Added nominal type drop downs to nominal setup
// Added mulit-line input button on simplewinaccs
// Fixed 4 digit year problem in simplewinaccs
// Removed threshold limits with fix buttons on Auditfiles screen (also in release, versions V2.2 R8.5)
// Added reference column to simplewinaccs for systems with vat enabled
// Removed 'E' column for bank rec
// Removed clear capital accounts during year end
// fixed bug in invoicer which allowed presented trans to be saved.
// restricted simple winaccs from ledger systems
// removed vat from sinple winaccs, automatically saving vat amounts as 0.00 with code Z
// add depreciation onto F2 listing nominal code box (fixed bug - not saving enterprise)
// changed cashbook form so that extra columns only appear when invoicing, not if ledger is clicked
// fixed bug when selecting multi line - the prog was being always set to expenditure
// fixed bug with all non 'Z' VAT codes being edited in multi line when VAT module was switched

// removed all - characters in fields for data export.
// fixed bug with no detail lines saved when transfering from a job card / proforma to an invoice
// added registry key to switch on data dump

// Fixed bug with cashbook sytems when trying to load up using parameters from the herd.

// Added the simplewinaccs interface on the mainscreen when running up the accounts with the parameters
// from the herd

// V2.2 R8.7  Bug Fix for Editing presented Purchase Payment Transactions into Simplewinaccs
// Fixed bug in Invoice Printing with no remittance advice the invoice was wrapping onto a second page
// Added Extra Parameters NL & SL

// V2.2 R 8.8 - V2.3 R0.1
// Fixed Bug in invoicer which printed with no customer
// Changed simple interface layout & investigated serial in problem set of accounts
// Added serial number display function under Ctrl Sft F5

// Fixed bug when editing on the SimpleWinaccs bar.

// Work cashbookCoOp import


// Bug fixes in ledger screen (comment not clearing etc)
// Added Delete Proforma / Job Card Buttons
// More CoOp import development

// bug fix, with balances not being updated on ledger payment screen
// Continued with Import into cashbook system & investigated bug with cashbook transactions

// Fixed bug where cashbook transactions with a customer / supplier account not showing up on certain
// reports
// Fixed saving of Nominal Group Descriptions
// Added adaption of cashbook form as a payment screen for co-op import in cashbook systems.


// added 'Unallocated Variable Costs' nominal type
// added 'Private Inc / Exp' Vat Code Fix
// Added Fix To Products Tables missing fields

// Added validation etc to Import

// Fixed bug causing Products to be deleted (when checking for missing fields)


// V2.3R0.1 GM - removed restriction in setup screen where control accounts couldn't be edited.
// also added new fields to products, productstx, proforma for date and referenece - i.e. individual line date and reference
// did it in create table.  only did checkdatabase fields for prodstx and proforma
// amended data integrity check to check for nominals in the restricted private income/expenditure ranges for limited companies
// having balances when they shouldn't
// V2.3 R0.2 GM - fixed small bug in full audit where no_partners was 0
// V2.3 R0.7 AB reinstated products linked to nominals
// V2.3 R0.8 GM fixed small bug in saving to GetExtraDetails
// V2.3 R0.9 GM changed cbProducts onchange to cbProducts onclick - also onkeyup to handle blank product
// V2.3 R1.3  GM introduced 2 new dbs NomDefaults and SLPLDefaults, to save the link between Nominals
//  and customers / suppliers  introduced code in simple screen to automaticaly pick correct supplier/customer
// + in ledger screen the revers - picka correct nominal for 1st line of inout grid + comment


// V2.3 R2.0 - R2.5  development of new budget reports.  New function to calculate month values if no period ends done.
// year end altered to carry these month values forward for this versus last year comparison


// V2.3 R2.7  altered heading in trial balance and nominal audit trail to indicate if by account or by group.
//            also to show both report date and print date

// V2.3 R2.8   pre-printed stationary and other options in invoice setup

// V2.3 R2.9  altered the way job cards, proformas and quotations are saved so that batchID is incemental so that a job card never has the same
//  batchID as a proforma or quote
//  moved invoice button
//  fixed sequential numbering of invoices.
// fixed bug where if editing, last invoice number/jobcardnumber/proformnumber/quotenumber was getting set back to the number of the document
// being edited
// reference input box is disabled when in invoicing/jobcard/proforma/quote as program automatically sets to next sequential number
// V2.3 R3.8 - R3.9 automated backup on startup when run clicked.  Undo added to Backup form
// V2.3 R4.0 automated backup implemented under start reconciliation button
// V2.3 R4.3 bug fixed to prevent using nominal zero
// simple interface date validation added
// changed procedure name GetNominalAccounts to GetExpenseNominalAccounts as this procedure was being confused with
// GetAllNominalAccounts - this was causing a problem in invoicer after editing a transaction in the previous year.
// set global variable nomlistOK to false on run click so that in invoicer, the nomlinal list will be rebuilt when required
// removed password in setup and changed it to a warning instead.
// V2.3 R4.5 - finished graphic header for invoices
// V2.3 R4.7 bug fixed where problems occuring if no billing 'connot perform this operation on closed dataset' message when editing purchase invoice
//  cashbook - added line to getextradetails.showpanel to set showpanel to false if not invoicer
// also amended form activate so that getallnominalledgeraccs is called regardless of xbilling so that above error doesn't occur
// V2.3 R4.8  moved invoicer function from cashbook to types so more parts of the program can use it.
// onexit custsuppcode - altered so that only if invoicer will ref be set to next inv number

{ Different Transaction Types
  PROG              ACT
  SALESTX           1        = Sales Invoice
  SALESTX           2        = Cash Sale
  SALESTX           3        = Sales Receipt
  SALESTX           4        = Sales Credit Note

  PURCHTX           1        = Purchase Invoice
  PURCHTX           2        = Cash Purchase
  PURCHTX           3        = Purchase Payment
  PURCHTX           4        = Purchase Credit Note

  CASHINC                    = Cashbook Income
  CASHEXP                    = Cashbook Expenditure

  JOURNAL           1        = Direct Debits
  JOURNAL           2        = Direct Credits
  JOURNAL           3        = VAT Paid
  JOURNAL           4        = VAT Received
  JOURNAL           5        = Inter Bank Transfers
}
// V2.3 R6.8 - Removal of 10 line invoice restriction (defaultly set to 100 lines)
// V2.3 R7.0 - Addition of cheque journal report to cashbook systems
//           - Search box and incremental save buttons added to bank reconciliation screen
//           - further options and improvements added to invoicer including vat code summary table.

// V2.3 R7.2 - Fixed bug causing errors etc when editing an invoice longer the with more than 10 lines
// V2.3 R7.5 implemented live calculation of age of debt for both age of debt and statements

// V2.3 R8.2 TNewRepForm.FormCreate checks for group number 0 linked to nominals or blank group names,
//           both of which upset the cashflow report.

// V2.3R8.3 / 8.4  made background height and width both 0
// altered screen sizes so that they fit  into 800*600 resolution

// finally, line 797 in cashbook, set nomlist to false so that nominal/product link file is recreated every time
// cashbook is activated to try to fix reason why job cards don't always save line details.

// V2.3 R8.5 altered nomrep to retain date range after report run
// alter preprinted stationary invoice for Gerry
// altered blank fields in ful audit to set bad dates to 01/01/90

// V2.3R8.6 fixed bug where line detail could go missing in loading job card

// V2.3R8.8  altered reports to take account of VAT code E, used in N Ireland for imports from other states.
// V2.3 R8.9 altered on key up for both the simple grid and the comment inut box in cashbook so that if
// cashbook system, user can't manually type in a customer/supplier

// V2.3 R8.9 altered invoice printing for pre preinted stationary to allow user to setup
// own parameters for start of name/address, invoie details, footer and page number
// fixed bug in getExtraDetails where product price was not being picked up if linked to a nominal code
// V2.4 R0.2 amended password setup in System so password saves properly
// V2.4 R0.3 amended filter in age of debt to include negative values
// V2.4 R0.6 fixed product summary invalid variant type message where no product id in productstx
// and fixed product code range to 1 .. 9999
// V2.4 R1.3 altered code in Nsrep11 lines 1970 and 2004 - added if clause and code as balanced sheet putting brackets where it shouldn't!
// V2.4 R1.4 VAT code setup screen allows users in both NI and ROI to set Include in VAT return parameter
// V2.4 R1.5 removed 'and amount = 0' in yearend arch as this was causing problems
// V2.4 R1.6 added the ability to save & load Quote Templates within a Invoicer System
// V2.4 R1.8 added new 'Bill Of Quantities' report from a selected Quotation
// V2.4 R1.9 Added ability to copy Quotation details into a new job card when saving a quotation

// V2.4 R2.2 VerNo & Modules enteries now made in registry

// V2.4 R2.3 problems filtering by Nominal Code in Record Cards fixed

// V2.4 R2.4   1. Bug causing mainscreen to freeze when the user clicks the 'x' having called the accounts from within the herd fixed.
//             2. Enterprise Summary - Last Year Month now showing all the monthly values
//             3. CD Backup implemented (accessible on normal backup form) .. CDBackup.exe & XPBurnObj.dll must be in the Kingsacc Folder.

// V2.4 R2.5 invoice printing adapted so that the totals & remittance slip will only appear on the last page of an invoice spanning more than one page.

// V2.4 R2.7 This has the fix for the transaction date not being saved correctly when running the accounts program with parameters from within the herd (re: problems experienced by Gerard Lyons).

// V2.4 R2.8  1. Extra detail lines available in ledger screen again without the customer needing to have purchased the invoicer.
//            2. Quick reports now have the export to excel / word / csv etc working (available under the save floppy disk icon).

// V2.4 R2.9 Customer/Supplier listing box problems as reported by Milo (as fixed in development)

// V2.4 R3.0 1. The bug where statements between two dates were not displaying the age of debt figures fixed
//           2. Ability to backup to memory stick incorporated into this version


interface

implementation

end.
