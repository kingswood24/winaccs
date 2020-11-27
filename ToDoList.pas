unit ToDoList;
(*
// this unit's only purpose is to record To Do Items


 Bugs
 ====

  Sales screen switching between invoice / cashsale to receipt causes pause before figures
  can be entered.

  If first transaction on file is a purchase payment, it seems to get left off the main grid
  ??? can't repeat ???


 Short Term Items
   ================

  In a cash purchase, would it be possible to enable the auto complete for the comment and 1st
  nominal in the same way as it does for invoices.  This would be very useful for wages etc.

  Gerry gave me a list of modifications to the Accounts program that he had brought back from a meeting :-
    - The Cost Per Unit Report should show 3 decimal places instead of two in the
      This Period/Quantity and This Period headings.


  Proforma report - Adding a negitive line not subtracting

 Long Finger
   ===========

   - Statements to print by Date order and not Tx Order

   Michael - "I had an agent on the phone to me yesterday about the Sort on the Statements.
              His problems is that the user who has the program is entering in transactions
              on the program not in date order but he would like the Statements to not show
              the fact that he is too lazy to enter in the events in order. Gerry said that
              this is not a major issue but the agent says that it is.
              If you could let me know whether this would be a major fix and a time line of
              sorts then I'll let Gerry/Agent know. "

   Standing Orders - Save Customer / Supplier

   Statement & Ledger - Show only Euro value not both

   Statement & Ledger - Filter by Area Code

   Accs data folder - delete all files automatically with ~ in filename

   Standing Orders - Remove saving date at initial setup and replece with option to specify
   date of application during the month

   Enterprise Summary Reports
	1 - Last Year Monthy not showing months (except 1st)
	2 - Print Date/Report Date both showing Today's Date - even when in previous year -
            default to cashbook date for report date

   Need opening balance on bank reports "full nominal ledger audit trail"

   On the Ledger Card/Statement Would it be possible to show outstanding (not paid) Invoices
   in some other colour and outstanding balances on part paid ones.

   The Full Nominal Ledger Audit Trail report if you use 'Date Range' and 'Start of Month
   Balance' what you get is the year opening balance twice. It does not seem to calculate
   the new 'Start of Month Balance' .

   The issue with the spacing of the lines on the invoices seems ok but the descriptions,
   if is more than one word long, the second word is obscured. (15 Characters in Variables)

   Just another little fix required on Accs. I think both This Year vs Last Year reports
   (Financial and Ent. Management sections) are still not working correctly. The Period
   figures (normally monthly) are still not coming out right after the new style of Year End,
   where Period Ends are done automatically.

   I have a problem when selecting an Account from and Account To report in the Full Nominal
   Ledger Audit Trail in the NewWinaccs version where after the report is run and you have
   exited the report itself the program will not let you exit the opening Full Nominal Ledger
   screen as it seems to be stuck on the Account To search box. Even if you tab the program
   will not let you move from this box. - Can't replicate

   A problem which recurs at times in the program but is a particular prob here is the
   running of numerical amounts in fields into one another. This is easily resolved usually
   by dropping the pennies/cents part of the fields. This information is of no benefit and
   only contributes to visual clutter or in this case renders the reports almost unreadable.

   Data Integry check .. display result in Memo box .. avoids problems with Notepad!!!




 Kingswood Suggestions
 =====================

   Hello Andrew
   A customer made a useful suggestion re Kingswood Accounts.
   He is complaining that he has to enter an Invoice and then enter a payment against it.
   He would like a facility to mark an Invoice as paid and then the program would create
   the receipt transaction. I asked him why not do a cash sale and he said that he could
   not print out a copy of the invoice there, is it possible to allow a print invoice
   facility there?.
   Could you have a look and let us know.
   Regards
   John Kelly
   Kingswood.

 DATACONVERT
 ===========

   Add new password to password list.

*)
interface

implementation

end.
