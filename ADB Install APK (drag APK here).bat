@echo off
IF [%1] EQU [] Goto:Error
CD /D "%~1">nul 2>&1 && Goto:Explorer_Folder || Goto :OpenFile
GOTO: END
::**********************************************************
:OpenFile <File>
adb install -r "%~1"
GOTO :END
::**********************************************************
:Explorer_Folder <Folder>
Explorer "%~1"
GOTO :END
::**********************************************************
:Error
ECHO You must drag and drop a file on this batch program 
GOTO :END
::**********************************************************
:END
echo -----------------------------
pause
Exit /b
::**********************************************************