; !define ENABLE_LOGGING
; !include "logging.nsh"
!include "WinVer.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

RequestExecutionLevel none
# name the installer
OutFile "Installer.exe"
InstallDir "$EXEDIR\haha"
!addplugindir ".\Plugins"

Section 004
  Var /GLOBAL AppZipFile
  Var /GLOBAL ActualAppInstaller
  Var /GLOBAL DownloadURL
  StrCpy $DownloadURL "https://example.com/example.zip"
  StrCpy $AppZipFile "$EXEDIR\example.zip"
  StrCpy $ActualAppInstaller "$EXEDIR\example.exe"
  InitPluginsDir
  Call GetApp
SectionEnd

Function GetApp
  ; MessageBox MB_ICONINFORMATION "${PRODUCT_NAME} will now start download the app and install it."
  ; Call DownloadFile
  Call ExtractFile
  ; nsisunz::UnzipToLog $AppZipFile "$EXEDIR"
  ; Pop $R0
  ; StrCmp $R0 "success" +2
  ;   DetailPrint "$R0" ;print error message to log
  Exec $ActualAppInstaller
  ; ExecWait $ActualAppInstaller
    ; Delete $AppZipFile
FunctionEnd

Function CheckUnsupportedPlatform
    ${if} ${AtLeastWin95}
    ${AndIf} ${AtMostWinME}
        ;NT4 and W95 use the same version number, we can use ${IsNT} if we need precise identification
        MessageBox MB_OK|MB_ICONEXCLAMATION "Sorry, but your version of Windows is unsupported platform.$\n\
Supported platforms are currently 2000 / XP / 2003 / Vista / Seven$\n \
            Cannot continue the installation." /SD IDOK
        abort
    ${elseIf} ${isWin2008}
    ${orIf} ${AtLeastWin2008R2}
        MessageBox MB_OK|MB_ICONINFORMATION "Please note that support for Windows 2008 and Windows 8 is in beta stage.$\n\
Supported platforms are currently 2000 / XP / 2003 / Vista / Seven" /SD IDOK
    ${endif}
FunctionEnd

Function CheckIsX64
  ${If} ${RunningX64}
    MessageBox MB_OK "You are running x64"
  ${Else}
    MessageBox MB_OK "No, you are not running x64"
  ${EndIf}
FunctionEnd

Function DownloadFile
  NSISdl::download /TIMEOUT=30000 $DownloadURL $AppZipFile
  Pop $R0 ;Get the return value
  StrCmp $R0 "success" download_ok
    SetDetailsView show
    DetailPrint "download failed: $R0"
    MessageBox MB_ICONSTOP "Download failed: $R0"
    Abort
  download_ok:
    DetailPrint "download $R0 OK"
FunctionEnd

Function ExtractFile
  nsisunz::UnzipToLog "$EXEDIR\$AppZipFile" "$EXEDIR"
  Pop $R0
  StrCmp $R0 "success" unzip_ok
    DetailPrint "haha"
    DetailPrint "$R0"
    Abort
  unzip_ok:
    DetailPrint "extract $R0 OK"
    ; Delete "$INSTDIR\AppZipFile"
FunctionEnd
