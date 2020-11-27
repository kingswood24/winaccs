{
	      ษอออออออออออออออออออออออออออออออออออออออออออออออออป
	      บ Kingswood Computing Ltd. - Program Or Unit Name บ
	      ศอออออออออออออออออออออออออออออออออออออออออออออออออผ
   
  File	    : CATEXT:CBA.COPYD.TEXT.
  Segment   : copy_data_files.
  Status    : started.

  DATE'S
  Started   : 11/10/94.
  Finished  :

  ** Brief outline of function of this Segment	**
  To copy the data from the currently active company to another dir and rename
  the location of data files of this new directories cashbook.def to point at
  this new directory. N.B leaving the current dir. untouched.
  The procedure is called prior to doing a year end.
  The new definition is written with the new directory entered by the user as
  the location of data files. The filenames on the new cashbook.def are scaned
  for possible sub directories and these sub dir are deleted from the string.
  This is done as the old locations are hard to predict.
}
Unit YearArch;

InterFace
Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,  printers,
  FileCtrl, Grids, ExtCtrls;

Function copy_data_files : Boolean;

Implementation
uses
    Uyearend,
    DbGen,
    Umonth,
    PYEnd,
    Clears,
    Calcs,
    UTIL,
    DBCore,
    Types,
    Vars,
    kMessage,
    init,
    DefSecFl,
    filed,
    abortprg,
    SetUp,
    MainRpts,
    params;

Function copy_data_files : Boolean;

Const
  cash_blocks = 11;			  { no of blocks in the cashbook.def }
  def_size = 6144;					 { cashbook.def size }
  // tgm removed next line - the array for storing the filenames is now dynamic in length
//  no_files = 100;				      { max no of files copy }

Type
  { t_err is the error message returned after all calls to open, close, read,
    write, amend files begin copied }
  t_err = ( blk_read, blk_write, creating_dir, file_opening, file_creating,
	    no_space, closing_file, search_failed, opening_def, reading_def,
	    writing_def, getting_info );

  string13 = ShortString;			    { max length of filename }

  t_files_copy = record			      { record to hold info on files }
    name     : ShortString;		      { begin copied }
    no_blks  : longint;
  End;
  // tgm removed next line 22/04/02 - array to store file names is no longer fixed length
  //  t_file_arr = array [1..no_files] of t_files_copy; { array to hold file info }

Var
  s_dir,					     { hold the sub dir name }
  new_prefix,			      { the new prefix for the archived data }
  prefix,						{ active data prefix }
  st		: ShortString;				    { general string }
  new_dir	: ShortString;			{ user entered new directory }
  ior,							   { ioresult holder }
  total_files,					 { total no of files to copy }
  x		: integer;				   { general counter }
  ok		: boolean;		   { boolean to see if alls going ok }
  files_to_copy : array of t_files_copy; //^t_file_arr;		    { var declared to hold file info }
  Backuphnd : THandle;                            {all of these from Mainunit}
  DirString : ShortString;
  BackupDir : PChar;
  BackUpArray : Array [0..29] Of Char;
  quit:boolean;
  // tgm removed procedures below - no longer needed as array uses setlength to dynamically change size

{  Procedure NewMemory;
  Begin
       New ( Files_To_Copy );
  End;

  Procedure DisposeMemory;
  Begin
       Dispose ( Files_To_Copy );
  End;}

  {* Displays an error message }
  Procedure err ( err_type : t_err );
  Var
    st	  : ShortString;
  Begin
    st := '';

    if err_type = blk_read then
      st := concat ( st, ' ERROR READING BLOCK' )
    else
      if err_type = blk_write then
	st := concat ( st, ' ERROR WRITING BLOCK' )
      else
	if err_type = creating_dir then
	  st := concat ( st, ' ERROR CREATING DIRECTORY' )
	else
	  if err_type = file_creating then
	    st := concat ( st, ' ERROR CREATING FILE' )
	  else
	    if err_type = file_opening then
	      st := concat ( st, ' ERROR OPENING FILE' )
	    else
	      if err_type = closing_file then
		st := concat ( st, ' ERROR CLOSING FILE' )
	      else
		if err_type = search_failed then
		  st := concat ( st, ' CANNOT FIND DIRECTORY')
		else
		  if err_type = opening_def then
		    st := concat ( st, ' ERROR OPENING DEFINITION')
		  else
		    if err_type = reading_def then
		      st := concat ( st, ' ERROR READING DEFINITION')
		    else
		      if err_type = writing_def then
			st := concat ( st, ' ERROR WRITING DEFINITION')
		      else
			if err_type = no_space then
			  st := concat ( st, ' INSUFFICIENT DISK SPACE')
			else
			  if err_type = getting_info then
			    st := concat ( st, ' RETRIEVING INFORMATION')
			  else
			    st := concat ( st, ' UNKNOWN ERROR OCCURED');

    MessageDlg ( St, mtInformation, [mbOK], 0 );
    ok := False;
//    DisposeMemory;
    Exit;
  End;

  {* scans the str_to_test for no_of_slashs '\' and returns the ShortString test_dir
     the area before the back_slashs }
  Procedure get_sub_dir ( var test_dir : ShortString; str_to_test : ShortString;
			   no_of_slash : integer );
  Var
    inst_st	     : ShortString;
    test_len,
    backslash_count,
    counter	     : integer;

  Begin
    inst_st := ' ';
    backslash_count := 0;
    counter := 1;
    test_len := length ( str_to_test );

    repeat
      inst_st[1] := str_to_test[counter];
      insert ( inst_st, test_dir, counter );
      if str_to_test[counter] = '\' then
	backslash_count := backslash_count + 1;
      counter := counter + 1;
    until ( backslash_count = no_of_slash ) or ( counter > test_len );

  End;

  {* displays a message to the user to indicate if the data has been copied
     correctly }
  Procedure copy_ok ( al_right : boolean );
  Var
    st	  : ShortString;

  Begin
    st := '';

    if al_right then
       begin
            st := 'DATA COPIED SUCCESSFULLY';
       end
    else
        Begin
             st := 'ERROR OCCURED - COPY UNSUCCESSFULLY';
             MessageDlg ( St, mtInformation, [mbOK], 0 );
        end;
  End;


  {* closes files and initialise var }
  Procedure close_init;
  Var
     x : Integer;
  Begin
    CloseAll ( MaxDatabases );
    // tgm changed next bit 22/04/02 as array is no longer fixed size
    {    for x := 1 to no_files do
      Begin
	files_to_copy^[x].name := null;
	files_to_copy^[x].no_blks := 0;
      End;}
    new_dir := null;
    s_dir   := null;
  End;

  {* get the filenames from the cashbook.def file }
  Procedure get_file_names;
  Var
    FirstPass   : Boolean;
    FileOk      : Integer;
    LSearchRec  : TSearchRec;
    tot_space_needed,
    free        : Int64;
//    i_no_files  : LongInt;
    remain_of	     : integer;

    {* retrieve the old filenames from cashbook.def }
    Procedure get_old_filename ( Var Result : Integer );
    Begin
      { if FirstPass then use findfirst to check for files then use findnext to
        go down thru. the whole directory and set LSearchRec  }
      If FirstPass Then
         Result := FindFirst ( Cash2.xdirectory + '\*.*', faAnyFile, LSearchRec )
      Else
          Result := FindNext ( LSearchRec );
      FirstPass := False;
    End;

  Begin
    ok := false;
    x  := 0;
    total_files := 0;
    tot_space_needed := 0;
    FirstPass := True;
    quit := false;

    { get the current amount of free space in the prefix directory }
    Free := DiskFree ( 0 );
    if Free < 0 then
      err ( no_space );

    { scan all possible filenames }
//    i_no_files := 1;
    Repeat
        get_old_filename ( FileOK );
        If ( FileOK = 0 ) Then
           Begin
{             remain_of := 0;
             remain_of := trunc ( LSearchRec.size mod 512 );

             { store the filename and size the the array only if its can be
               divided by 512 ( block ) and its size is greater than 0 }
//             If (( remain_of = 0 ) and ( LSearchRec.size > 0 )) then
                Begin
                     setLength(Files_To_Copy,x+1);
                     tot_space_needed := LSearchRec.size + tot_space_needed;
                     files_to_copy[x].name := LSearchRec.name;
                     files_to_copy[x].no_blks := LSearchRec.size;

                     //files_to_copy^[x].name := LSearchRec.name;
                     //files_to_copy^[x].no_blks := LSearchRec.size;
                     total_files := x+1;
                     x := x + 1;
                End;
           End
           else quit := true;
//        Inc ( i_no_files );
    Until quit; //( i_no_files >= no_files );
    { test theres enough freespace on the disk }
    if tot_space_needed >= 512 then
      Begin
	if tot_space_needed <= Free then
	  ok := true
	else
	  err ( no_space )
      End
    else
      err ( search_failed );

  End;

  {* copy all the files contained in the files_to_copy array to the new
     Directory }
  Procedure copy_files;
  Var
    db1,
    db2	  : file;
    cb	  : dos_blk;
    x,
    no,
    blk_no,
    no_of_blocks : integer;
    percent	 : real;
    incrementor,
    perc_disp	 : integer;
    St2,
    new_path,
    old_path	 : String;
    oldfile,newfile:pchar;

  Begin
    no_of_blocks := 0;
    // line below added by tgm 22/04/02
    if not directoryexists(new_prefix) then createdir(new_prefix);
    YearEndForm.ProgressBar.Progress := 0;
    for x := 1 to total_files do
      Begin

	no_of_blocks := trunc ( files_to_copy[x-1].no_blks div 512 );

	old_path := null;
	if files_to_copy[x-1].name[1] = '\' then
	  old_path := concat ( prefix, files_to_copy[x-1].name )
	else
	  old_path := concat ( prefix, '\', files_to_copy[x-1].name );

          // below remmed out by tgm 22/04/02 - much better to use copy file than to use old
          // copying code!
        {AssignFile ( db1, old_path );
        ReSet ( db1, 512 );
	ior := ioresult;
	if ior <> 0 then
	  err ( file_opening );

	if NOT ok then
	  exit;}

	new_path := null;

	if files_to_copy[x-1].name[1] = '\' then
	  new_path := concat ( new_prefix, files_to_copy[x-1].name )
	else
	  new_path := concat ( new_prefix ,'\', files_to_copy[x-1].name );

        copyfile(Pchar(old_path),Pchar(new_path),false);

{        AssignFile ( db2, new_path );
        ReWrite ( db2, 512 );
	ior := ioresult;
	if ior <> 0 then
	  err ( file_creating );

	if NOT ok then
	  exit;
        St2 := '            ';
	blk_no := 0;}
//        YearEndForm.ProgressBar.Progress := 0;
        YearEndForm.ProgressBar.MaxValue := 100;
        //incrementor := x;
        YearEndForm.ProgressBar.Progress := x;//YearEndForm.ProgressBar.Progress + incrementor;
//        incrementor := 10000 div no_of_blocks;
        YearEndForm.ProgressLabel.Caption := '';
        YearEndForm.ProgressLabel.Caption := 'Copying file ' + files_to_copy[x-1].name + St2;
        YearEndForm.ProgressLabel.Refresh;

{	while blk_no < no_of_blocks do
	  Begin

            YearEndForm.ProgressBar.Progress := YearEndForm.ProgressBar.Progress + incrementor;

	    percent := ( blk_no / no_of_blocks ) * 100;
	    perc_disp := trunc ( percent );

            Seek ( db1, blk_no );
            BlockRead ( db1, cb, 1, no );
	    if no <> 1 then
	      err ( blk_read );
	    if NOT ok then
	      exit;

            Seek ( db2, blk_no );
            BlockWrite ( db2, cb, 1, no );
	    if no <> 1 then
	      err ( blk_write );
	    if NOT ok then
	      exit;
	    blk_no := blk_no + 1;
	  End;

        CloseFile ( db1 );
	ior := ioresult;
	if ior <> 0 then
	  err ( closing_file );

        CloseFile ( db2 );
	ior := ioresult;
	if ior <> 0 then
	  err ( closing_file );}

      End;
  End;

  {* update the new definition file }
  Procedure update_new_def;
  Var
    no		: integer;
    def0	: TCash1;		     { stores new definition block 0 }
    def1	: TCash2;		     { stores new definition block 1 }
    def11	: TCash11;	 	    { stores new definition block 11 }
    db1		: File;
    { array of blocks to hold above defblks }
    cb		: array [0..2] of dos_blk;

    {* read the new definition file }
    Procedure read_new_def;
    Begin

      if ( new_prefix[length ( new_prefix )] = '\' ) then
	AssignFile ( db1, concat ( new_prefix, cashbook ))
      else
	AssignFile ( db1, concat ( new_prefix, '\', cashbook ));

      ReSet ( db1, 512 );

      ior := ioresult;
      if ior <> 0 then
	err ( opening_def );

      Seek (DB1, 0);
      ior := ioresult;
      if ( ior <> 0 ) then
	err ( reading_def );
      Blockread ( db1, Cb[0], 1, no );
      ior := ioresult;
      if ( no <> 1 ) And ( ior <> 0 ) then
	err ( reading_def );

      Seek (DB1, 1);
      ior := ioresult;
      if ( ior <> 0 ) then
	err ( reading_def );
      Blockread ( db1, Cb[1], 1, no );
      ior := ioresult;
      if ( no <> 1 ) And ( ior <> 0 ) then
	err ( reading_def );

      Seek (DB1, 11);
      ior := ioresult;
      if ( ior <> 0 ) then
	err ( reading_def );
      Blockread ( db1, Cb[2], 1, no );
      ior := ioresult;
      if ( no <> 1 ) And ( ior <> 0 ) then
	err ( reading_def );

      fillchar ( def0, 512, ' ' );
      move ( cb[0][0], def0.dblock0[1], 512 );
      fillchar ( def1, 512, ' ' );
      move ( cb[1][0], def1.dblock1[1], 512 );
      fillchar ( def11, 512, ' ' );
      move ( cb[2][0], def11.db_loc_progs[1], 512 );

      ok := true;
      CloseFile ( db1 );
      ior := ioresult;
      if ior <> 0 then
	err ( reading_def );
    End;

    {* write the new definition and change the location of datafiles }
    Procedure write_old_def;

      Procedure put_new_name ( which_file : integer ; new_name : ShortString );
      Begin
	slimleft ( new_name );
	slimright ( new_name );

	{ make an assumption that if the filename is over 23 then its corrupt
	  data or has never been configured in the definition file }
	if length ( new_name ) > 23 then
	  new_name := null;

	Case which_file Of
	  1  : def0.xordtxfile	:= new_name;
	  2  : def0.xvaccfile	:= new_name;
	  3  : def0.xvstkfile	:= new_name;
	  4  : def0.xmontxfile	:= new_name;
	  5  : def0.xrawfile	:= new_name;
	  6  : def0.xmixfile	:= new_name;
	  7  : def0.xusefile	:= new_name;
	  8  : def0.xsalstate	:= new_name;
	  9  : def0.xpurstate	:= new_name;
	  10 : def1.xorderfile	:= new_name;
	  11 : def1.xdelivfile	:= new_name;
	  12 : def1.xfwdfile	:= new_name;
	  13 : def1.xentfile	:= new_name;
	  14 : def1.xslaccfile	:= new_name;
	  15 : def1.xplaccfile	:= new_name;
	  16 : def1.xnlaccfile	:= new_name;
	  17 : def1.xtransfile	:= new_name;
	  18 : def1.xdiaryfile	:= new_name;
	  19 : def1.xstockfile	:= new_name;
	  20 : def11.xgroupfile := new_name;
	  21 : def11.xanl_file	:= new_name;
	  22 : def11.live_lnk	:= new_name;
	  23 : def11.live_sdb	:= new_name;
	End;
      End;

      {* check the filenames and delete any sub directory from the name }
      Procedure check_filename;
      Var
	check_dir : ShortString;
	del_to,
	char_pos,
	count	  : integer;

      Begin

	For count := 1 To 23 Do
	  Begin
	    check_dir := null;

	    case count of
	      1	 : check_dir := def0.xordtxfile;
	      2	 : check_dir := def0.xvaccfile;
	      3	 : check_dir := def0.xvstkfile;
	      4	 : check_dir := def0.xmontxfile;
	      5	 : check_dir := def0.xrawfile;
	      6	 : check_dir := def0.xmixfile;
	      7	 : check_dir := def0.xusefile;
	      8	 : check_dir := def0.xsalstate;
	      9	 : check_dir := def0.xpurstate;
	      10 : check_dir := def1.xorderfile;
	      11 : check_dir := def1.xdelivfile;
	      12 : check_dir := def1.xfwdfile;
	      13 : check_dir := def1.xentfile;
	      14 : check_dir := def1.xslaccfile;
	      15 : check_dir := def1.xplaccfile;
	      16 : check_dir := def1.xnlaccfile;
	      17 : check_dir := def1.xtransfile;
	      18 : check_dir := def1.xdiaryfile;
	      19 : check_dir := def1.xstockfile;
	      20 : check_dir := def11.xgroupfile;
	      21 : check_dir := def11.xanl_file;
	      22 : check_dir := def11.live_lnk;
	      23 : check_dir := def11.live_sdb;
	    End;

	    if length ( check_dir ) > 0 then
	      Begin
		char_pos := 1;
		del_to	 := 0;

		{ test for '\' and store the last position within the filename
		  then if del_to > 0 delete up to this position in the ShortString }
		if pos ( '\' ,check_dir ) <> 0 THEN
		  while ( char_pos < length ( check_dir )) do
		    Begin
		      if check_dir[char_pos] = '\' then
			del_to := char_pos;
		      char_pos := char_pos + 1;
		    End;
		  if del_to <> 0 then
		    delete ( check_dir, 1, del_to );

		  { place the new name in the approiate block for rewriting }
		  put_new_name ( count, check_dir );
	      End;
	  End;
      End;

    Begin

      check_filename;

      { open the new cashbook.def }
      if ( new_prefix[length ( new_prefix )] = '\' ) then
	AssignFile ( db1, concat ( new_prefix, cashbook ))
      else
	AssignFile ( db1, concat ( new_prefix, '\', cashbook ));
      ReSet ( db1, 512 );
      ior := ioresult;
      if ior <> 0 then
	err ( opening_def );

     { move the updated blocks into the dos blocks }
      Move ( def0.dblock0[1], cb[0][0], 512 );
      Move ( def1.dblock1[1], cb[1][0], 512 );
      Move ( def11.db_loc_progs[1], cb[2][0], 512 );

      { write the new blocks }
      Seek (DB1, 0);
      ior := ioresult;
      if ( ior <> 0 ) then
	err ( writing_def );
      BlockWrite ( db1, Cb[0], 1, no );
      ior := ioresult;
      if ( no <> 1 ) Or ( ior <> 0 ) then
	err ( writing_def );

      Seek (DB1, 1);
      ior := ioresult;
      if ( ior <> 0 ) then
	err ( writing_def );
      BlockWrite ( db1, Cb[1], 1, no );
      ior := ioresult;
      if ( no <> 1 ) Or ( ior <> 0 ) then
	err ( writing_def );

      Seek (DB1, 11);
      ior := ioresult;
      if ( ior <> 0 ) then
	err ( writing_def );
      BlockWrite ( db1, Cb[2], 1, no );
      ior := ioresult;
      if ( no <> 1 ) Or ( ior <> 0 ) then
	err ( writing_def );

      ok := true;
      { close with lock the new cashbook.def }
      CloseFile ( db1 );
      ior := ioresult;
      if ior <> 0 then
	err ( writing_def );

    End;

  Begin
    ok := false;
    read_new_def;

    if ok then
      Begin
	{ store the new directory name in xdirectory }
	def1.xdirectory := concat ( new_dir, '\' );
	write_old_def;
      End;
  End;

Begin

//  NewMemory;

  Copy_Data_Files := False;
  close_init;

  st      := null;
  prefix  := null;

  Prefix := SubDir + RFarmGate.plocation[2];
  s_dir := null;

  SlimAll ( prefix );
  OK := true;
  New_Dir := YearEndForm.ArchiveEdit.Text;
  SlimAll ( New_Dir );
  New_Prefix := SubDir + new_dir;

  if ok then
     get_file_names;

  if ok then
     copy_files;

  if ok then
     update_new_def;

  if ok then
     Begin
        Copy_Data_Files := True;
        copy_ok ( true );
     End
  else
     Begin
        Copy_Data_Files := False;
        copy_ok ( false );
     End;

//  DisposeMemory;

  Initialise;
  OpenAll;

End;


End.
