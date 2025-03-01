; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "Aseprite"
!define PRODUCT_VERSION "1.3.13"
!define PRODUCT_PUBLISHER "Igara Studio S.A."
!define PRODUCT_WEB_SITE "https://www.aseprite.org/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\aseprite.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "D:\a\aseprite-v${PRODUCT_VERSION}\aseprite-v${PRODUCT_VERSION}\build\bin\data\icons\ase.ico"
!define MUI_UNICON "D:\a\aseprite-v${PRODUCT_VERSION}\aseprite-v${PRODUCT_VERSION}\build\bin\data\icons\ase.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "D:\a\aseprite-v${PRODUCT_VERSION}\aseprite-v${PRODUCT_VERSION}\build\bin\data\EULA.txt"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\aseprite.exe"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Aseprite-v1.3.13.exe"
InstallDir "$PROGRAMFILES\Aseprite"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File /r "D:\a\aseprite-v${PRODUCT_VERSION}\aseprite-v${PRODUCT_VERSION}\build\bin\*.*"
  File /r "libcrypto-1_1-x64.dll"
  CreateDirectory "$SMPROGRAMS\Aseprite"
  CreateShortCut "$SMPROGRAMS\Aseprite\Aseprite.lnk" "$INSTDIR\aseprite.exe"
  CreateShortCut "$DESKTOP\Aseprite.lnk" "$INSTDIR\aseprite.exe"
  File "D:\a\aseprite-v${PRODUCT_VERSION}\aseprite-v${PRODUCT_VERSION}\build\bin\aseprite.exe"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\Aseprite\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\Aseprite\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\aseprite.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\aseprite.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\aseprite.exe"

  Delete "$SMPROGRAMS\Aseprite\Uninstall.lnk"
  Delete "$SMPROGRAMS\Aseprite\Website.lnk"
  Delete "$DESKTOP\Aseprite.lnk"
  Delete "$SMPROGRAMS\Aseprite\Aseprite.lnk"

  RMDir "$SMPROGRAMS\Aseprite"

  RMDir /r "$INSTDIR\widgets"
  RMDir /r "$INSTDIR\strings"
  RMDir /r "$INSTDIR\palettes"
  RMDir /r "$INSTDIR\icons"
  RMDir /r "$INSTDIR\fonts"
  RMDir /r "$INSTDIR\extensions"
  RMDir /r "$INSTDIR\docs"

  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从你的计算机移除。"
FunctionEnd
