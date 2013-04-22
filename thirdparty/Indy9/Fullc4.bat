@echo off

computil SetupC4
if exist setenv.bat call setenv.bat
if exist setenv.bat del setenv.bat > nul

if (%NDC4%)==() goto enderror
if not exist %NDC4%\bin\dcc32.exe goto endnocompiler
if not exist ..\C4\*.* md ..\C4 > nul
if exist ..\C4\*.* call clean.bat ..\C4\

copy *Indy40.dpk ..\C4
copy *.pas ..\C4
copy *.obj ..\C4
copy *.inc ..\C4
copy *.res ..\C4
copy *.dcr ..\C4
copy *.rsp ..\C4

cd ..\C4
REM ***************************************************
REM Compile Runtime Package Indy40
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compiled separately
REM due to a DCC32 bug.
%NDC4%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC4%\bin\dcc32.exe Indy40.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC4%\bin\dcc32.exe IdDummyUnit.pas /LIndy40.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu > nul
del IdDummyUnit.hpp > nul
del IdDummyUnit.obj > nul

%NDC4%\bin\dcc32.exe Indy40.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy40.LIB file, please wait...
%NDC4%\bin\tlib.exe Indy40.lib /P32 @IndyWin32.rsp > nul
if exist ..\C4\Indy40.bak del ..\C4\Indy40.bak > nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC4%\bin\dcc32.exe dclIndy40.dpk /DBCB /O..\Source\objs /H /W /N..\C4 /LIndy40.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror


REM ************************************************************
REM Set all files we want to keep with the R attribute then 
REM delete the rest before restoring the attribute
REM ************************************************************
attrib +r Id*.hpp
attrib +r *.bpl
attrib +r Indy*.bpi
attrib +r Indy*.lib
attrib +r indy40.res
del /Q /A:-R *.*
attrib -r Id*.hpp
attrib -r *.bpl
attrib -r Indy*.bpi
attrib -r Indy*.lib
attrib -r indy40.res

goto endok

:enderror
echo Error!
goto endok

:endnocompiler
echo C++Builder 4 Compiler Not Present!
goto endok

:endok
cd ..\Source
