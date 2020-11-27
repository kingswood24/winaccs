unit ParadoxNotes;
(*

V3.0 R4.x

          1. Fixed problem with the Transaction Report where the information in the Description
             field running into the Stub Number column.
          2. Transaction report updated to include missing Transaction Type Column. Also updated
             CSV export to include this extra field.
          3. Routine written to update NL Groups & NL File where nomnial code has no report group
             associated with it. NL Group being allocated same number and if blank, same name as
             the NL code. (Runs under Profit & Loss Report).


V3.0 R4.8

          1. Fixed problem on simple interface where it was possible to change VAT code without
             updating figures when exiting the column by clicking Save directly after
             typing the VAT Code.
          2. When using a Purchase code on sales screen or sales code on purchase screen
             following the warning message a negative is filled into the Amount box (which
             may be deleted / overtyped).
          3. Fixed problem with selecting a Vat Code for a Nominal Account in the
             Enterprises section
          4. Use New Layout for Reports defaulted throughout the program (removed option box).
          5. Cheque Journal Report appears first on the list in the Cashbook Version
          6. Nominal Accounts drop-down-menu in the transaction entry screens (single & multiline)
             now default to overheads for Expenditure and Non Enterprise Income if there is no
             Enterprise selected
          7. Full Nominal Report form - bug fixed where range was not changing when going between
             report by group and report by account.
          8. Full Nominal Report - Added debit / credit heading to balance column


V3.0 R4.7T (Testing Only)
          1. New VAT Report button enabled for Kingswood testing with customer data.

V3.0 R4.6
          1. Fixed issues with Analysis Code Summary & Analysis Code Breakdown reports incorrectly adding
             quantities on Credit notes and crediting them back.
V3.0 R4.5
          1. Fixed problem withn Accounts being called by NL parameter chasing with 'cannot focus invisable
             window' error.
          2. Fixed bug in ledger card listing on payment screen where extra line with random data was being
             displayed
          3. Fixed front grid which wasn't always displaying the transaction type with sorts other than
             default transaction number.

V3.0 R4.4
          1. Fixed problem with Standing Order VAT lines showing a random customer / supplier on the
             VAT Report when the line should be blank.
          2. Fixed problem with Frontgrid not showing stub number details correctly on front grid on
             some Cashbook Transactions.
          3. Cost Per Unit report - Table not open errors fixed


V3.0 R4.3
          1. Fixed problem with year end not carrying forward outstanding payments for bank
          2. Fixed problem with def file getting blanked as part of year end

V3.0 R4.2
          1. Fixed problems with listing box not always jumping to expense codes in purchases invoices etc.
          2. Misc Bug fixes

V3.0 R4.1
          1. Fixed bug with invoices etc putting Enterprise (if any) into Reference database field if
             reference box was left blank while entering the transaction.

V3.0 R4.0
          1. Fixed Vat Report where transactions with no vat code where showing up on Southern VAT Report
             in the first blank VAT code.
          2. Bug fixed when editing a Cash Purchase / Sale Transaction Stub Number, the payment line
             stub number wasn't being updated and showing up incorrectly on Bank Reconciliation.


V3.0 R3.9
          1. Extra accounts appearing on the trial balance report fixed
          2. Invoice Report - Column spacings if including Nom Description improved.
          3. Product Code Summary - Fixed problems with Products not showing up correctly & problems with
             Product Code limit of 9999 fixed.

V3.0 R3.8
          1. Added front grid sort order select box (other options to be added as required)
          2. Program now will come to a blank select company screen rather than crashing out if the
             set of company accounts is missing that the program last accessed.

V3.0 R3.7
          1. Listing Box Fix .. blank name entries where stillshowing the name previoulsy listed in that cell.

V3.0 R3.6
          1. Added CSV Export to Transaction Report

V3.0 R3.5
          1. Analysis code breakdown report - drop down list box fixed (was looking up products)
          2. Fix for Reset Sales Balances with Customers > 1000
          3. New Backup / Restore Screen

V3.0 R3.4 1. Problem with statement report not printing between two dates fixed (removed old filtering code)
          2. Fixed Job Card Report getting customer nmuber wrong when a customer is deleted

V3.0 R3.3 1. Added Update Month Routines to Enterprise Summary Reports
          2. Enterprise Summary Report 'This year versus Last' - Fixed to shown correct data in Last Year To Date

V3.0 R3.2 1. Search Box on Stat form rewritten to improve searching speed.

V3.0 R3.1 1. Report headings changed to read 'This Year' and 'Last Year'.
          2. Enterprise Summary Report 'This year only' - correct data now shown in this month column.
          3. Enterprise Summary Report 'This year versus Last' - Fixed to shown correct data in all columns
          4. Users are now prompted for current month with both 'This Year Only' and 'This Year versus Last' reports

V3.0 R3.0 1. Re-wrote calculate balances to remove old code and speed up procedure when used with ledger
             cards etc.
          2. Fixed bug with Supplier Statements not printing correctly / or at all

V3.0 R2.9 1. Fixed Year End problem with BalanceST/St Year & Opening Net Worth figures not being correctly
             carried forward correctly

V3.0 R2.8 1. Fixed Bug where program incorrectly slows last record carried forward once a year end has been
             completed.

V3.0 R2.7 1. Fixed bug with Co-Op import not allowing Co-Op to be select
          2. In Simple Accounts Screen the word Nom has been replaced by Income / Expense depending on
             transaction type

V3.0 R2.6 1. Restriction not allowing a zero discount in a payment to be edited returned (cannot do as this
             world require a type 9 line to be inserted after the payment line
          2. Problems with editing payments/receipts and cashbook transactions fixed
          3. Program hang when exiting back to herd program when run from parameters fixed

V3.0 R2.5 1. Fixed bug where not all transactions were showing up on the full nominal audit trail.

V3.0 R2.4 1. New CSV export implemented for Bank Audit Trail

V3.0 R2.3 1. CSV Export for Trial Balance completed (extended trial balance now exports too)
          2. New CSV export implemented for Cashbook Income/Expenditure Report

V3.0 R2.2 1. ExecSql memory leak in FirstTX called from the maingrid fixed
          2. New CSV export implemented for Full Nominal
          3. New CSV export for Trial Balance (extended trial balance not complete yet)
          4. Restriction not allowing a zero discount in a payment to be edited removed

V3.0 R2.0 1. This now has a new version numbering system as per old version as discussed with Gerry this
          morning (version V3.0 R2.0).
          2. Startup parameters now adjusted to allow Accounts program to be called from within the Herd
          program to open at the select company screen. Parameters - winaccs c herdserialnumber (same as before with letter c and company name omitted)
          3. Invoice Allocation screen altered to allow payments to be entered unallocated, against invoice(s)
          or against an opening balance.

Dev 120   Bug in VAT Audit Trail where wrong transaction numbers were being listed against the transactions fixed.

Dev 119   1. Grid Index Out Of Range error on Sales/Purchase Screen fixed
          2. Statement report now showing age of debt figures when date range selected (same fix as release
          version)
          3. Invoice Allocation - bug causing some transactions following the invoice with payment allocated
          to it also being incorrectly marked as allocated fixed.
          4. Addition of 'Enter Unallocated Payment' button on Payment screen to allow payments to be entered
          on standard payment screen without the need to be allocated to an invoice.

Dev 118   1. Backup can now be taken onto a memory stick (procedure identical to Herd). This will be included
          in the next version of the Release as well.
          2. 'Update Balances Removed From Here' warning removed when running Ledger Cards
          3. Problems relating to having to exit the program when switching between reports fixed
          4. Significant speed increase in front screen update procedure. This has a knock on effect on the
          rest of the program and speeds up saving / editing transactions etc.

Dev 116   1. Extends the size of Enterprise field in Transactions table automatically to fix the problem
          caused by dataconvert program. This does not however fix the problem with existing customers data
          converted with enterprise codes longer than 1 character as only the first character is saved in the
          table and will need to be manually fixed or the original data reconverted.
          2. 'Cannot Create Sales Account Listing' error in cashbook screen fixed, bug was caused by the
          program not handling a sales account with a blank name.
          3. Fixed Age of debt report correct figures now being shown in 3month+ column.
          4. Problems relating to a four digital year fixed, there should be no problems editing transactions
          or with systems set to 4 digital year.
          5. Invoice Allocation - The program brings up all invoices for a client not marked as complete,
          allowing the payment to be allocated to any of these invoices (get marked as complete once totally
          paid). Bug where incorrect invoices were marked as complete fixed so allocation should be working ok.
          If any other problems found can you give me specific transaction details so I can step through.
          6. Program hang before printing invoice fixed (caused by only first character of Enterprise Code
          being saved by dataconvert)
          7. Not being about to print saved invoice fixed (caused by only first character of Enterprise Code
          being saved by dataconvert)

Dev 115   1. Option to choose report date on age of debt report removed
          2. Inconsistent spacing between lines on sales invoice fixed (was included in earlier development
          version but may not have been noted)
          3. Problems with transaction reports (invoice/payment/credit note & summary reports) not including
          all transactions fixed

Dev 114   1. Reports folder created (c:\kingsacc\reports) if it doesn't exist on startup
          2. Customer/Supplier listing box problems as reported by Milo fixed

Dev 113   The option for selecting the simple interface is now saved to the def file for each set of data and
          no longer in the registry (so data for new customers can be set to simple interface by default).
          Also various bug fixes.

Dev 107   Co-Op import problems sorted and other fixes included

Stable Release Versions Sent for testing



Dataconvert History
===================

V0.15 Added the Data Integrity check step into the conversion to fix problems arising in older data

V0.14 Problem with 'DateDue' field not found during conversion fixed, should have been 'DueDate'

V0.13 Dataconvert now deletes the new paradox tables prior to any conversion, fixing the problems experienced
      when extracting old data into a new system with new blank data.

V0.11 This fixes the problem with dataconvert crashing out when converting previous year data from very old
      versions of the Winaccs program which allowed transactions with invalid dates to be saved. The invalid
      dates are replaced with the date on the last successfully converted transaction (if it happens to be
      the first transaction date defaults to 01/01/1990).

V0.10 Problem with dataconvert only creating a single character Enterprise field in Transactions table repaired
      (should be 4 characters long). This only effects customers who have Enterprise codes longer than 1
      character, the data must be converted with this new version or the field manually extended in the table.
      This bug caused a few of the problems experienced by John as the program was not able to match the single
      character enterprise code in the transaction table with the actual four character code in the enterprise
      table.

V0.09 Fixed bug with the record count variable where the dataconvert program only ran through the same number
      of customers as there was suppliers (variable updated with customer count)

V0.08




*)

interface

implementation

end.
