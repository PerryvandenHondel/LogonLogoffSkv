{

  PROGRAM:
    LogonLogoffSkv.exe

  DESCRIPTION:
    Register the logon/logoff action of an account in Splunk SKV format
    
  USAGE:
    LogonLogoffSkv.exe \\vm70as006.rec.nsint\INDEXEDBYSPLUNK LOGON P
    LogonLogoffSkv.exe \\vm70as006.rec.nsint\INDEXEDBYSPLUNK LOGOFF T
  
  VERSION:
    02  2014-11-13  PVDH  Added Prod/Test release option in command line options.
    01	2014-11-12	PVDH	Initial version

  RETURNS:
    Nothing
    
  SUGGESTED UPDATES:
    1) check for correct Paramstrings
    
} 

program LogonLogoffSkv;

{$mode objfpc}
{$H+}


uses
	Classes, 
	SysUtils,
  StrUtils,
  USplunkFile,
	USupportLibrary;
  
  
const
  VERSION         = '01';
  PROGRAM_ID      = '000101';
   

procedure ProgramTitle();
begin
  WriteLn();
  WriteLn(StringOfChar('-', 80));
  WriteLn(GetProgramName() + ' -- Log the logon/logoff action of current account');
  WriteLn(RightStr(StringOfChar(' ', 80) + PROGRAM_ID + ' ' + VERSION, 80));
  WriteLn(StringOfChar('-', 80));
end; // of procedure ProgramTitle


procedure ProgramUsage();
begin
  WriteLn();
  WriteLn('Usage:');
  WriteLn(Chr(9) + GetProgramName()  + ' <share to store files> <action> <release>');
  WriteLn();
  WriteLn(Chr(9) + '<location>' + Chr(9) + 'Location to store the output store files, \\server\share');
  WriteLn(Chr(9) + '<action>' + Chr(9) + 'LOGON or LOGOFF');
  WriteLn(Chr(9) + '<release>' + Chr(9) + 'P(roduction) or T(est)');
  WriteLn();
  WriteLn('Example:');
  WriteLn(Chr(9) + GetProgramName()  + ' \\server\share\000101 LOGON P');
  WriteLn();
end; // of procedure ProgramUsage


procedure ProgramRun(share: string; action: string; release: string);
var
  p: string;
  s: CSplunkFile;
  u: string;
begin
  //WriteLn('user name: ' + GetCurrentUserName());

  //WriteLn('share:  ' + share);
  // WriteLn('action: ' + action);
  
  u := GetCurrentUserName();
  
  p := share + '\' + PROGRAM_ID + '\' + release + '\' + GetDateFs() + '\' + GetCurrentComputerName() + '\' + u + '.skv';
  WriteLn('Writing current ' + action + ' action for ' + u + ' to file ' + p);
  MakeFoldertree(p);
  
  s := CSplunkFile.Create(p);
  s.OpenFileWrite();
  s.SetDate();
  s.SetStatus('INFO');
  s.AddKey('account', u, true);
  s.AddKey('action', action, true);
  s.WriteLineToFile();
  s.CloseFile();
end;

 
procedure ProgramTest();
begin
  //WriteLn(GetDrive('d:\folder1\folder1\file.txt'));
  //WriteLn(GetDrive('\\server\share\folder1\folder2\file.txt'));
  
  MakeFolderTree('\\vm70as006.rec.nsint\INDEXEDBYSPLUNK\000101\2014-11-13\file.txt');
  MakeFolderTree('d:\folder1\folder1\file.txt');
  MakeFolderTree('d:\folder1\folder2\folder3\folder4\folder5\folder6\file.txt');
  
  
end; // of procedure ProgramTest

  
begin
  // ProgramTest();
  ProgramTitle();
  
  if ParamCount <> 3 then
    ProgramUsage()
  else
  begin
    ProgramRun(ParamStr(1), ParamStr(2), ParamStr(3));
  end;
  
end. // of main program LogonLogoffSkv  