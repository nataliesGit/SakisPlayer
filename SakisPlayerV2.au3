#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ico3.ico
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Icon_Add=ico3.ico
#AutoIt3Wrapper_Res_File_Add=soundfileMissing.jpg
#AutoIt3Wrapper_Res_File_Add=ordnerMissing.jpg
#AutoIt3Wrapper_Res_File_Add=favoritenBeep.mp3
#AutoIt3Wrapper_Res_File_Add=play.jpg
#AutoIt3Wrapper_Res_File_Add=aus.ico
#AutoIt3Wrapper_Res_File_Add=an.ico
#AutoIt3Wrapper_Res_File_Add=renameToAscii.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ #AutoIt3Wrapper_Res_File_Add=7za.exe
;~ #AutoIt3Wrapper_Res_File_Add=asciiTool.zip



;~ Tolles online ico conversion Tool
;~ https://www.zamzar.com/convert/png-to-ico/




;~ Hotkeys: für favoritenordner, deleted ordner, vor, zurück , vol up, vol down, suche und suche beenden
;~ 			 ;! = alt  ^ = CTRL
;~ 			HotKeySet("!^d", "deleteSongAndPlayNext")
;~ 			HotKeySet("{RIGHT}", "forward")
;~ 			HotKeySet("{LEFT}", "back")
;~ 			HotKeySet("{up}", "volumeUp")
;~ 			HotKeySet("{down}", "volumeDown")
;~ 			HotKeySet("!^f", "copy2FavoritesFolder")
;~ 			HotKeySet("^f", "suche")
;~ 			HotKeySet("^u", "populatelist")


; ******************************************************************
; **::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::**
; **::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::**
; **::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::**
; **      .---. ,-.         ,---.  ,---.  ,-.      .--..-.   .-.  **
; **     ( .-._)|(||\    /| | .-.\ | .-.\ | |     / /\ \\ \_/ )/  **
; **    (_) \   (_)|(\  / | | |-' )| |-' )| |    / /__\ \\   (_)  **
; **    _  \ \  | |(_)\/  | | |--' | |--' | |    |  __  | ) (     **
; **   ( `-'  ) | || \  / | | |    | |    | `--. | |  |)| | |     **
; **    `----'  `-'| |\/| | /(     /(     |( __.'|_|  (_)/(_|     **
; **               '-'  '-'(__)   (__)    (_)           (__)      **
; **::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::**
; **::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::**
; **::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::**
; ******************************************************************
;~ Text to Ascii Generator: http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20
;~ http://www.kammerl.de/ascii/AsciiSignature.php/


#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <sound.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include <ColorConstants.au3>
#include <GuiMenu.au3>
#include <Date.au3>

#region declarations
;~ MsgBox("","deleted songs folder: ",$delFolder)
Global $song2delete = ""
Global $butZurueck,$butVor,$butPlay,$butStop,$butOpen
Global $selectedFolder,$hListView,$labFolder,$labAnzeige
Global $aResult = []
Global $a2d = []
Global $playlistArray = []
Global $iCount
Global $iIndexPlaylist,$saveIndexPlaylist
Global $iIndexPlaylist_safe  ;während Suchmodus rückspeichern der orig. $iIndexPlaylist
Global $soundActive = 0
Global $selectedFile = ""
Global $spielDauerInMillisek = 0
Global $hSoundOpen
Global $hTimerInit, $timerDiff
Global $diff = 0
Global $titel,$songAnzahl
Global $sFile, $delFolder, $logFile
Global $playlistVZ
;~ Global $playerCalledWithParams = 0

;~ falls player mit Ordner als Parameter uebergeben wird
;~ MsgBox(64, "Passed Parameters", $CmdLine[0] & " parameters have been passed to this script:")
Global $g_hListView
;~ Global $listViewFilled = 0

Global $shuffleFlag = 1  ;1 = on, 0 = off
Global $endlosFlag = 1  ;1 = on, 0 = off
Global $ContextMenu

Global $contextAbNummer = 40  ; ändert sich bei jedem neu zur GUI hinzugefügtem Element

Global $suchModus = 0  ;1 = on, 0 = off
Global $suchBegriff = ""
Global $aResult  ;$aResult enthält Liste aller Lieder aus Ordner - siehe populateList()
Global $aFileNotFound = []  ;speichert nicht gefundenen Soundfile und prüft vorab, ob schon in Array - dann soundstop um Endlosschleife zu verhindern
;~ Global $favoritenBeep,$ordnerMissing,$soundfileMissing
Global $pauseModus = 0  ;1 = on, 0 = off
Global $hotkeysActive = 1 ;alle hotkeys aktive (STRG+Alt+1 deaktiviert alle hotkeys)
Global $asciiFolder
#EndRegion

#region fileinstall
Local $bFileInstall = true ; Change to True and ammend the file paths accordingly.
if $bFileInstall Then
	$playlistVZ = "C:\SakisPlayer\playlistVZ.txt"

	If Not FileExists("c:\SakisPlayer\") Then
		DirCreate("c:\SakisPlayer\")
		FileInstall("play.jpg","C:\SakisPlayer\play.jpg")
		FileInstall("ico3.ico","C:\SakisPlayer\ico3.ico")
		FileInstall("aus.ico","C:\SakisPlayer\aus.ico")
		FileInstall("an.ico","C:\SakisPlayer\an.ico")
		FileInstall("favoritenBeep.mp3","C:\SakisPlayer\favoritenBeep.mp3")
		FileInstall("ordnerMissing.jpg","C:\SakisPlayer\ordnerMissing.jpg")
		FileInstall("soundfileMissing.jpg","C:\SakisPlayer\soundfileMissing.jpg")
		FileInstall("renameToAscii.exe","C:\SakisPlayer\renameToAscii.exe")
;~ 		FileInstall("7za.exe","C:\SakisPlayer\7za.exe")
;~ 		FileInstall("asciiTool.zip","C:\SakisPlayer\asciiTool.zip")
	EndIf

	$picture = "C:\SakisPlayer\play.jpg"
	$ico = "C:\SakisPlayer\ico3.ico"
	$icoAus = "C:\SakisPlayer\aus.ico"
	$icoAn = "C:\SakisPlayer\an.ico"
	$sFile = "C:\SakisPlayer\mp3List.txt"
	$favoritenBeep ="C:\SakisPlayer\favoritenBeep.mp3"
	$ordnerMissing = "C:\SakisPlayer\ordnerMissing.jpg"
	$soundfileMissing = "C:\SakisPlayer\soundfileMissing.jpg"

	$asciiRenameTool = "C:\SakisPlayer\renameToAscii.exe"

	If Not FileExists($playlistVZ) Then _FileCreate($playlistVZ)
	$delFolder = "C:\SakisPlayer\deletedSongs"
	$logFile ="C:\SakisPlayer\logSakis.txt"
	If Not FileExists($logFile) Then _FileCreate($logFile)
	$FavoritesFolder = "C:\SakisPlayer\favoriteSongs"
	if not FileExists($FavoritesFolder) then
		DirCreate($FavoritesFolder)
	EndIf
	if not FileExists($delFolder) then
		DirCreate($delFolder)
	EndIf
Else
	$ico = @scriptDir & "\ico3.ico"
	$icoAus = @scriptDir & "\aus.ico"
	$icoAn = @scriptDir & "\an.ico"
	$picture = @scriptDir & "\play.jpg"
	$sFile = @ScriptDir & "\mp3List.txt"
	$delFolder = @ScriptDir & "\" & "deletedSongs"
	$logFile = @ScriptDir & "\logSakis.txt"
	$FavoritesFolder = @ScriptDir & "\" & "favoriteSongs"
	$playlistVZ  = @ScriptDir & "\" & "playlistVZ.txt"
	$favoritenBeep =@ScriptDir & "\" & "favoritenBeep.mp3"
	$ordnerMissing = @ScriptDir & "\" & "ordnerMissing.jpg"
	$soundfileMissing = @ScriptDir & "\" & "soundfileMissing.jpg"
	$asciiRenameTool = @ScriptDir & "\" & "renameToAscii.exe"

	if not FileExists($delFolder) then
		DirCreate($delFolder)
	EndIf
	if not FileExists($FavoritesFolder) then
		DirCreate($FavoritesFolder)
	EndIf
EndIf
#EndRegion


#region gui
;~ 	$Form = GUICreate("Player", 333, 545, 333, 146,-1, $WS_EX_ACCEPTFILES)
	$Form = GUICreate("Player", 333, 610, 333, 164,-1, $WS_EX_ACCEPTFILES)
	GUISetIcon ($ico)
	$ContextMenu = GUICtrlCreateContextMenu()   ;für playlist

	$mInfo = GUICtrlCreateMenu("Info")
	$mToolInfo = GUICtrlCreateMenuItem("Info zu diesem Tool", $mInfo)
	$mAutoitLink = GUICtrlCreateMenuItem("Autoit Webseite", $mInfo)
	$mPlaylist = GUICtrlCreateMenu("Playlists")

	$mOpen = GUICtrlCreateMenu("Öffnen")
	$mFavoriten = GUICtrlCreateMenuItem("lade Favoriten Lieder", $mOpen)
	$mDeleted = GUICtrlCreateMenuItem("lade Gelöschte Lieder", $mOpen)
	GUICtrlCreateMenuItem("", $mOpen)  ;Separator line

	$mOpenFavoriten = GUICtrlCreateMenuItem("Favoriten im Explorer", $mOpen)
	$mOpenDeleted = GUICtrlCreateMenuItem("Gelöschte im Explorer", $mOpen)
	GUICtrlCreateMenuItem("", $mOpen)  ;Separator line
	$mOpenPlaylistFile = GUICtrlCreateMenuItem("öffne Favoriten in Notepad", $mOpen)
	$mOpenLogs = GUICtrlCreateMenuItem("öffne Logs in Notepad", $mOpen)
	$mOpenSakisFolder = GUICtrlCreateMenuItem("öffne Player Ordner", $mOpen)
	GUICtrlCreateMenuItem("", $mOpen)  ;Separator line
	GUICtrlCreateMenuItem("", $mOpen)  ;Separator line
	$mAsciiRenamer = GUICtrlCreateMenuItem("Ascii Renamer", $mOpen)
	$mRestart = GUICtrlCreateMenuItem("Player neu starten", $mOpen)

	$mSuch = GUICtrlCreateMenu("Suche")
	$mSuche = GUICtrlCreateMenuItem("Suche Lied", $mSuch)




	GUICtrlCreatePic($picture,0,0,333,84)

	$butHotkey = GUICtrlCreateButton("",  317, 90,8, 8,$BS_ICON)
    GUICtrlSetImage(-1, $icoAn)


	$hListView = GUICtrlCreateListView("",0,192,333,348,BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT),BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES))

	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	;add columns
	_GUICtrlListView_AddColumn($hListView,"Nr.",30)
	_GUICtrlListView_AddColumn($hListView,"Track",293)

	$butZurueck = GUICtrlCreateButton("<<", 8, 152, 35, 25)
	$butVor = GUICtrlCreateButton(">>", 160, 152, 35, 25)
	$butPlay = GUICtrlCreateButton("Play", 48, 152, 51, 25)
	$butStop = GUICtrlCreateButton("Stop", 104, 152, 51, 25)
	$butOpen = GUICtrlCreateButton("...", 8, 96, 27, 25)
	$labFolder = GUICtrlCreateLabel("Ordner waehlen", 40, 104, 278, 17)
	$labAnzeige = GUICtrlCreateLabel("....", 8, 128, 312, 17)
	$labSpieldauer = GUICtrlCreateLabel("gespielt: ", 216, 160, 52, 17)
	$labMin = GUICtrlCreateLabel("min", 272, 158, 20, 17, $WS_BORDER)
	$labSec = GUICtrlCreateLabel("sec", 303, 158, 21, 17, $WS_BORDER)
	GUICtrlSetData($labMin,"-")
	GUICtrlSetData($labSec,"-")
	$Label1 = GUICtrlCreateLabel(":", 296, 158, 7, 17)

	$butShuffle = GUICtrlCreateButton("Zufall Mix ist an", 8, 552, 91, 25)
	$butEndlos = GUICtrlCreateButton("Schleife ist an", 104, 552, 83, 25)
	$butPlaylist = GUICtrlCreateButton("zu Favoriten hinzufügen", 192, 552, 131, 25)
	GUICtrlSetColor ( $butEndlos, $COLOR_GREEN )
	GUICtrlSetColor ( $butShuffle, $COLOR_GREEN )
	GUICtrlSetColor ( $butPlaylist, $COLOR_BLACK )

	$g_hListView = $hListView  ;damit ich code für doubleclick detect nicht anpassen muss
	enableDisableButtons(0)
	HotKeySet("{Tab}", "pauseSoundToggle")  ;! = alt  ^ = CTRL
	HotKeySet("!^x", "hotkeyToggle")  ;! = alt  ^ = CTRL
	HotKeySet("!^o", "openSakisPlayerFolder")  ;! = alt  ^ = CTRL

	GUISetState(@SW_SHOW)
#EndRegion


;~ MsgBox($MB_SYSTEMMODAL, "Pc Long format", _DateTimeFormat(_NowCalc(), 1))
;~ MsgBox($MB_SYSTEMMODAL, '', "The time is:" & _NowTime())
;~ MsgBox($MB_SYSTEMMODAL, "Pc Short format", _DateTimeFormat(_NowCalc(), 2))

writeToLog("--------- START Anwendung --------------" &@CRLF)

func unzipFiles()   ;wird nicht verwendet - aber sehr nuetzlich
;~ 	7za.exe und zip zu Ressourcen hinzufügen.
;~ 	dann Run(7za.exe e mein archiv.zip)   e ist schalter zum entpacken in momentanes VZ

EndFunc

func asciiRenamer()

;~ 	das Tool fkt. nicht, wenns über ressourcen verteilt wird. Deshalb verteilen und entpacken des zips
;~    command 7za.exe e asciiTool.zip

	$asciiFolder = FileSelectFolder("Ordner wählen", @scriptdir)
	local $currWorkingdir = @WorkingDir
	FileChangeDir($asciiFolder)
	FileCopy ( $asciiRenameTool, $asciiFolder,1 )

	$DOS = Run("renameToAscii.exe", "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	ProcessWaitClose($DOS)
;~ 	$Message = StdoutRead($DOS)
	FileChangeDir($currWorkingdir)
	MsgBox($MB_SYSTEMMODAL, "Info","Umbenennung(en)erfolgt")
EndFunc

func hotkeyToggle()
;~ 	MsgBox($MB_SYSTEMMODAL, "test", "in hotkey toggle")
	if 	$hotkeysActive = 1 then ;hotkey modus ist an
		unsetAllHotkeys()
		GUICtrlSetImage($butHotkey, $icoAus)
		$hotkeysActive = 0
	Else
		setHotkeys()
		GUICtrlSetImage($butHotkey, $icoAn)
		$hotkeysActive = 1
	EndIf
EndFunc


func writeToLog($msg)
	if _FileCountLines ( $logFile ) > 10000 Then
		$oldFileName = $logFile&"-"&_DateTimeFormat(_NowCalc(), 2)&"-"&@hour&"Uhr"&@MIN
		FileMove ( $logFile, $oldFileName)
	EndIf

	local $datZeit = getTimeDate()
	$hLog = FileOpen($logFile, $FO_APPEND)
	FileWriteLine($hLog,$datZeit &":"& $msg )
	FileClose($hLog)
EndFunc


func getTimeDate()
	local $datumZeit = _DateTimeFormat(_NowCalc(), 2) & "|" & _NowTime()
	return $datumZeit
EndFunc


if $CmdLine[0] = 1 then
	paramBeiAufruf()
EndIf

func paramBeiAufruf()
;~ 	MsgBox(64, "Passed Parameters", $CmdLine[1] & " parameters have been passed to this script:")
	$selectedFolder = $CmdLine[1]
EndFunc

assignEvents()  ;anstelle von while
playlistVZauslesen()

func suche()
	local $aResultKopie = $aResult
	Global $aResultSuche = []

	$suchBegriff = InputBox("Liedsuche", "Lied enthält folgende Zeichen: ", "")
	if not $suchBegriff = "" Then  ;wenn nichts in Suchbox eingegeben wurde, wird Suche ignoriert

;~ 		_ArrayDisplay($aResultKopie)

;~ 		MsgBox(64, "$suchBegriff", $suchBegriff)
		;alle items, in denen Suchbegriff vorkommt in $aResultSuche speichern
		for $i = 0 to Ubound($aResultKopie)-1
;~ 			MsgBox(64, "$aResultKopie[$i]", $aResultKopie[$i])
			if StringInStr($aResultKopie[$i],$suchBegriff) Then
;~ 				MsgBox(64, "$suchBegriff match", $suchBegriff & "  in  :  " & $aResultKopie[$i])
				_ArrayAdd($aResultSuche,$aResultKopie[$i])

			EndIf
		Next
;~ 		_ArrayDisplay($aResultSuche)

;~ 		****************  wenn Suche erfolgreich:*********************************

		If UBound($aResultSuche) > 1 then
			_GUICtrlListView_DeleteAllItems ( $hListView )
					;~ 	**************** create 2d array für listview *********************
			$iCount = UBound($aResultSuche)  ; zeilenanzahl des Arrays ermitteln $aResult
			$songAnzahl = $iCount -1
			Global $a2d[$iCount][2]  ;zeile - spalte
			for $i = 1 to $iCount -1
				$a2d[$i][0] = $i
				$a2d[$i][1] = $aResultSuche[$i]
			Next
			_ArrayDelete($a2d,0)


	;~ 	 	_ArrayDisplay($a2d)
			;~ 	**************** 2d array in listview füllen *********************
			_GUICtrlListView_AddArray($hListView,$a2d)
			$listViewFilled = 1
			stop()
		Else
			MsgBox(64, "keine Übereinstimmung", "Suchbegriff in keinem Lied vorhanden")
		EndIf


	EndIf

EndFunc

func favInNotepad()
	$_Run = "notepad.exe " & $playlistVZ
	ConsoleWrite ( "$_Run : " & $_Run & @Crlf )
	Run ( $_Run, @WindowsDir )
EndFunc

func logsInNotepad()
	$_Run = "notepad.exe " & $logFile
	ConsoleWrite ( "$_Run : " & $_Run & @Crlf )
;~ 	Run ( $_Run, @WindowsDir, @SW_MAXIMIZE )
	Run ( $_Run, @WindowsDir )
EndFunc


func playlistVZauslesen()
;~ 	Format der playlistdatei:  test=F:\Sakis_youtube_sound\dj lounge mix\
	Global $playlistArray = []  ;einlesen der playlist datei in array
	Global $playlistOrnder = []  ;den Ordner pfad des playlist items
	Global $playlistItems = []   ;das playlist item mit selbst verg. namen
	Global $testIfEmpty = ""

	Global $aLines
	$testIfEmpty = FileRead($playlistVZ)
;~ 	MsgBox(0,"$playlistVZ",$playlistVZ)

	If not $testIfEmpty = "" Then
;~ 		MsgBox(0,"$testIfEmpty has content",$testIfEmpty)
;~ 		==========delete empty lines in file=============
		_FileReadToArray($playlistVZ, $aLines)
		$sLines = _ArrayToString($aLines, "|", 1)
		$sLines = StringReplace($sLines, "||", "|")
		$aLines = StringSplit($sLines, "|")
		_FileWriteFromArray($playlistVZ, $aLines, 1)
;~ 		==========Ende delete empty lines in file=============
		_FileReadToArray($playlistVZ,$playlistArray)
;~ 		_ArrayDisplay($playlistArray)
		for $i = 1 to $playlistArray[0]
;~ 			MsgBox($MB_SYSTEMMODAL, "$playlistArray[$i]", $playlistArray[$i])
			local $splitString = StringSplit($playlistArray[$i],"=")

			if $splitString[0]> 1 then   ;d.h. nicht leerer Eintrag
;~ 			_ArrayDisplay($splitString)

			$playlistName = $splitString[1]
			$ordner = $splitString[2]

			_arrayAdd($playlistOrnder,$ordner)
			local $temp = GuiCtrlCreateMenuitem ($playlistName,$mPlaylist)
			GUICtrlSetOnEvent(-1, "playlistMenueInvoked")

;~ 			GUICtrlCreateMenuItem("Eintrag loeschen: "& $playlistName, $ContextMenu)
;~ 			GUICtrlSetOnEvent(-1, "contextMenue")

			_arrayAdd($playlistItems,$temp)
			EndIf

		Next
			; @GUI_CTRLID liefert die Nummer des Menuitems - da diese zur Laufzeit erzeugt werden, sind sie fortlaufend.
			; die Kontext menu items sollen erst erzeugt werden, wenn die menue items fertig sind
			for $i = 1 to $playlistArray[0];~
				local $splitString = StringSplit($playlistArray[$i],"=")
				if $splitString[0]> 1 then   ;d.h. nicht leerer Eintrag
					$playlistName = $splitString[1]
					$ordner = $splitString[2]
					GUICtrlCreateMenuItem("Playlist loeschen: "& $playlistName, $ContextMenu)
					GUICtrlSetOnEvent(-1, "contextMenue")
				EndIf
			Next

		FileClose(FileWriteLine($playlistVZ,@CR))   ;Cursur in nächste Zeile für neue Einträge

;~ 		_ArrayDisplay($playlistOrnder)
;~ 		_ArrayDisplay($playlistItems)

	EndIf

EndFunc


;~ https://www.autoitscript.com/autoit3/docs/functions/GUICtrlCreateContextMenu.htm

func add2playlist()
	sleep(100)
;~ 	 pruefe, ob Ordner bereits in Favoritenliste enthalten
	$read = FileRead(FileOpen($playlistVZ, 0))
	If StringInStr($read, $selectedFolder) Then
        MsgBox(0,"","Ordner ist bereits in Favoritenliste enthalten")
	else
;~ 		 MsgBox(0,"Inhalt von playlist file: ",$read)
		Local $itemName = InputBox("Playlist Name", "Name der Playlist: ", "")
;~ 		MsgBox(0,"","eingegebener itemname: "&$itemName)
		if not $itemName = "" then
			FileClose(FileWriteLine($playlistVZ,$itemName&"="&$selectedFolder))  ; SEHR SCHÖN Geschachtelt :-)
			RestartScript()
		EndIf


	EndIf

EndFunc

Func RestartScript()
	writeToLog(" *********************************** RESTART ******************** " )
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc


func contextMenue() ; trigger über Mouse-Rechtsklick auf Rahmen des Formulars - delete Eintraege in playlist
	;@GUI_CTRLID liefert die dem erstellten Controlitem in der GUI entsprechende Nummer. Es ist eine fortlaufende Nummer, die sich
	; ändert, sobald der GUI neue Elemente hinzugefügt werden. Im Moment ist die Zahl des 1. Kontextmenueitems : siehe global Variable $contextAbNummer (25)
;~ 	MsgBox($MB_SYSTEMMODAL, "context menu @GUI_CTRLID", @GUI_CTRLID)
	local $anzahlEintraege = UBound($playlistOrnder)-1
;~ 	MsgBox($MB_SYSTEMMODAL, "$playlistOrnder Anzahl eintraege", $anzahlEintraege)

;~ 	MsgBox($MB_SYSTEMMODAL, " @GUI_CTRLID",  @GUI_CTRLID)
	local $zuLoeschendeZeile = @GUI_CTRLID - ($contextAbNummer + $anzahlEintraege)
;~ 	MsgBox($MB_SYSTEMMODAL, "aus playlist zu loeschende Zeile: ", $zuLoeschendeZeile)

	local $frage = MsgBox (4, "** löschen ? **" ,"Playlist-Eintrag löschen?")
	if $frage = 6 then
		delEmptyLines($playlistVZ)
		ZeileLoeschen($playlistVZ, $zuLoeschendeZeile)
		sleep(100)
		RestartScript()
	EndIf

EndFunc

func delEmptyLines($sFileName)  ;Aufruf von contextMenue() aus
	;da aus array eventuell mehrere Elemente gelöscht werden, muss von hinten nach vorne navigiert werden
	Local $StrArray
	_FileReadToArray($sFileName, $StrArray)
	; Move backwards through the array deleting the blank lines
	For $i = UBound($StrArray) - 1 To 0 Step -1
		If $StrArray[$i] = "" Then
			_ArrayDelete($StrArray, $i)
		EndIf
	Next

	; Et voila!
;~ 	_ArrayDisplay($StrArray)

	$FileHwnd = FileOpen($sFileName, 2)

    For $i = 1 To UBound($StrArray) -1
        FileWriteLine($FileHwnd, $StrArray[$i])
    Next

    FileClose($FileHwnd)
EndFunc


Func ZeileLoeschen($sFileName, $sLine)  ;Aufruf von contextMenue() aus
    Local $FileHwnd
	Local $StrArray

    If Not FileExists($sFileName) Then
        MsgBox(16, "Error", "File not exist")
        Exit
    EndIf

    _FileReadToArray($sFileName, $StrArray)
    _ArrayDelete($StrArray, $sLine)
    ;_ArrayDisplay($StrArray)

    $FileHwnd = FileOpen($sFileName, 2)

    For $i = 1 To UBound($StrArray) -1
        FileWriteLine($FileHwnd, $StrArray[$i])
    Next

    FileClose($FileHwnd)
EndFunc


func playlistMenueInvoked()
;~ 	@GUI_CTRLID gibt die Nummer des Items aus (CAVE: wenn Controlitems in der GUI dazukommen, ändert sich die Nummer
;~ 	im Moment ist Nummer : siehe global Variable: $contextAbNummer (24 = Index 0)

;~ 	MsgBox($MB_SYSTEMMODAL, "@GUI_CTRLID", @GUI_CTRLID)

	local $index = @GUI_CTRLID - $contextAbNummer
;~ 	MsgBox($MB_SYSTEMMODAL, "$index", $index)
;~ 	MsgBox($MB_SYSTEMMODAL, "zugehoeriger Ordner: ", $playlistOrnder[$index])
	$selectedFolder = $playlistOrnder[$index]
	if FileExists($selectedFolder)  then
	;~ 	_ArrayDisplay($selectedFolder)
		labFolderSetData()
		stop()
		PopulateList()
	Else
		SplashImageOn("Splash Screen", $ordnerMissing, 250, 184)
		sleep(3000)
		SplashOff()
	EndIf

EndFunc


	While 1
		if $pauseModus = 0 then
			if $spielDauerInMillisek = 0 Then
				if $hotkeysActive = 1 then
					HotKeySet("!^d", "doNothing")
					HotKeySet("!^f", "doNothing")
				endif
				GUICtrlSetData($labMin,"-")
				GUICtrlSetData($labSec,"-")
				sleep(50)
			elseif ($diff < $spielDauerInMillisek And $soundActive = 1) Then
;~ 				ConsoleWrite("while $diff < $spielDauerInMillisek And $soundActive = 1): Spieldauer: "&$spielDauerInMillisek & " $diff: "&$diff& " $soundActive: " & $soundActive& @CRLF)
				if $hotkeysActive = 1 then
					HotKeySet("!^d", "deleteSongAndPlayNext")
					HotKeySet("{RIGHT}", "forward")
					HotKeySet("{LEFT}", "back")
					HotKeySet("{up}", "volumeUp")
					HotKeySet("{down}", "volumeDown")
					HotKeySet("!^f", "copy2FavoritesFolder")  ;! = alt  ^ = CTRL
				endif

				sleep(50)
				$diff = round(TimerDiff($hTimerInit))
	;~ 			ConsoleWrite("while spieldauer: "& $spielDauerInMillisek & @CRLF)
	;~ 			ConsoleWrite("while Timerdiff: "& $diff & @CRLF)
	;~ 			ConsoleWrite("while $soundActive: "& $soundActive & @CRLF)
	;~ 			ConsoleWrite(@CRLF& @CRLF)

				local $restSpielInMilli = $spielDauerInMillisek - $diff
				local $min = int($restSpielInMilli/1000/60)
				local $restSec = int(mod($restSpielInMilli/1000,60))

				GUICtrlSetData($labMin,$min)
				GUICtrlSetData($labSec,$restSec)
			elseif ($diff >= $spielDauerInMillisek And $soundActive = 1) then
;~ 				ConsoleWrite("while $diff >= $spielDauerInMillisek And $soundActive = 1): Spieldauer: "&$spielDauerInMillisek & " $diff: "&$diff& " $soundActive: " & $soundActive& @CRLF)
				sleep(50)
				if $hotkeysActive = 1 then
					HotKeySet("!^d", "deleteSongAndPlayNext")
					HotKeySet("!^f", "copy2FavoritesFolder")
				endif

	;~ 			ConsoleWrite("while else spieldauer: "& $spielDauerInMillisek & @CRLF)
	;~ 			ConsoleWrite("while else diff: "& $diff & @CRLF)

				$spielDauerInMillisek = 0
				$soundActive = 0

				forward()

			EndIf

		EndIf ;end if pausemodus aktive


	WEnd


func assignEvents()
	Opt("GUIOnEventMode", 1)
	GUISetOnEvent($GUI_EVENT_DROPPED, "DragAndDrop")
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Main")
	GUICtrlSetOnEvent($butZurueck, "back")
	GUICtrlSetOnEvent($butVor, "forward")
	GUICtrlSetOnEvent($butPlay, "play")
	GUICtrlSetOnEvent($butStop, "stop")
	GUICtrlSetOnEvent($butOpen, "selectOrdner")
	GUICtrlSetOnEvent($mAutoitLink, "autoitLink")
	GUICtrlSetOnEvent($mToolInfo, "infoTool")
	GUICtrlSetOnEvent($butShuffle, "randomPlay")
	GUICtrlSetOnEvent($butEndlos, "endlosPlay")
	GUICtrlSetOnEvent($butPlaylist, "add2playlist")
	GUICtrlSetOnEvent($mSuche, "suche")
	GUICtrlSetOnEvent($mDeleted, "ladeGeloeschte")
	GUICtrlSetOnEvent($mFavoriten, "ladeFavoriten")
	GUICtrlSetOnEvent($mOpenDeleted, "openGeloeschte")
	GUICtrlSetOnEvent($mOpenFavoriten, "openFavoriten")
	GUICtrlSetOnEvent($mOpenPlaylistFile, "favInNotepad")
	GUICtrlSetOnEvent($mOpenLogs, "logsInNotepad")
	GUICtrlSetOnEvent($mRestart, "RestartScript")
	GUICtrlSetOnEvent($mAsciiRenamer, "asciiRenamer")
	GUICtrlSetOnEvent($mOpenSakisFolder, "openSakisPlayerFolder")
EndFunc

func openSakisPlayerFolder()
	$Path = "C:\SakisPlayer"
	Run("explorer /e, " & '"' & $Path & '"')
EndFunc

func openGeloeschte()
	$Path = "C:\SakisPlayer\deletedSongs"
	Run("explorer /e, " & '"' & $Path & '"')
EndFunc

func openFavoriten()
	$Path = "C:\SakisPlayer\favoriteSongs"
	Run("explorer /e, " & '"' & $Path & '"')
EndFunc

func ladeGeloeschte()
	$selectedFolder="C:\SakisPlayer\deletedSongs"
	labFolderSetData()
	stop()
	populatelist()
EndFunc

func ladeFavoriten()
	$selectedFolder="C:\SakisPlayer\favoriteSongs"
	labFolderSetData()
	stop()
	populatelist()
EndFunc

func randomPlay()
	if $shuffleFlag = 1 Then
		$shuffleFlag = 0
		GUICtrlSetData ($butShuffle, "Zufall Mix ist aus")
		GUICtrlSetColor ( $butShuffle, $COLOR_BLACK )
		PopulateList()
		play()
	else
		$shuffleFlag = 1
		GUICtrlSetData ($butShuffle, "Zufall Mix ist an")
		GUICtrlSetColor ( $butShuffle, $COLOR_GREEN )
		PopulateList()
		play()
	EndIf
EndFunc

func endlosPlay()
	if $endlosFlag = 1 Then
		$endlosFlag = 0
		GUICtrlSetData ($butEndlos, "Schleife ist aus")
		GUICtrlSetColor ( $butEndlos, $COLOR_BLACK )
	else
		$endlosFlag = 1
		GUICtrlSetData ($butEndlos, "Schleife ist an")
		GUICtrlSetColor ( $butEndlos, $COLOR_GREEN )
	EndIf
EndFunc

func unsetAllHotkeys()
	HotKeySet("!^d", "doNothing")
	HotKeySet("{RIGHT}", "doNothing")
	HotKeySet("{LEFT}", "doNothing")
	HotKeySet("{up}", "doNothing")
	HotKeySet("{down}", "doNothing")
	HotKeySet("!^f", "doNothing")
	HotKeySet("^f", "doNothing")
	HotKeySet("^u", "doNothing")
	HotKeySet("!^o", "doNothing")
	HotKeySet("{Tab}", "doNothing")
EndFunc


func unsetHotkeys() ;wird in while schleife benötigt - deshalb unsetAllHotkeys() für ALLE
	HotKeySet("!^d", "doNothing")
	HotKeySet("{RIGHT}", "doNothing")
	HotKeySet("{LEFT}", "doNothing")
	HotKeySet("!^f", "doNothing")
EndFunc

func setHotkeys()
	HotKeySet("!^d", "deleteSongAndPlayNext")
	HotKeySet("{RIGHT}", "forward")
	HotKeySet("{LEFT}", "back")
	HotKeySet("{up}", "volumeUp")
	HotKeySet("{down}", "volumeDown")
	HotKeySet("!^f", "copy2FavoritesFolder")
	HotKeySet("^f", "suche")
	HotKeySet("^u", "populatelist")
	HotKeySet("!^o", "openSakisPlayerFolder")
	HotKeySet("{Tab}", "pauseSoundToggle")
EndFunc


func volumeUp()
	  Send("{VOLUME_UP}")
EndFunc

func volumeDown()
	  Send("{VOLUME_Down}")
EndFunc

func copy2FavoritesFolder()
	$song2copy = $selectedFolder &"\"& $titel
;~ 	MsgBox("","copy title: ",$song2copy)
	FileCopy($song2copy, $FavoritesFolder, $FC_OVERWRITE)
	_SoundPlay(_SoundOpen($favoritenBeep),0)

EndFunc

func deleteSongAndPlayNext()
	_SoundClose($hSoundOpen)
	unsetHotkeys()
	$song2delete = $selectedFolder &"\"& $titel
;~ 	MsgBox("","delete title: ",$song2delete)
	$saveIndexPlaylist = $iIndexPlaylist
	stop()
	FileMove($song2delete, $delFolder, $FC_OVERWRITE)
;~ 	consoleWrite("count lines in deleteSongAndPlayNext: "&$iCount)
;~ 	ConsoleWrite("saveIndexPlaylist:  " & $saveIndexPlaylist &@CRLF)
;~ 	ConsoleWrite("IndexPlaylist:  " & $iIndexPlaylist &@CRLF)
;~ 	ConsoleWrite("Anzahl songs in deleteSongAndPlayNext:  " & $songAnzahl &@CRLF)
	if $songAnzahl >= 2 then
		PopulateList()
		if $saveIndexPlaylist  < ($songAnzahl - 1) Then
			$soundActive = 1
			 _GUICtrlListView_ClickItem($hListView, $saveIndexPlaylist)
			$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
			$titel = StringSplit ( $selectedFolder &"\"&$a2d[$saveIndexPlaylist][1], "\")
			$titel = $titel[$titel[0]]
			if StringLen($titel) > 60 then
				GUICtrlSetData($labAnzeige, "..... "&StringRight($titel, 60))
			Else
				GUICtrlSetData($labAnzeige,$titel)
			EndIf

			$hSoundOpen = _SoundOpen($selectedFolder &"\"&$a2d[$saveIndexPlaylist][1])
			_SoundPlay($hSoundOpen,0)
			$hTimerInit = TimerInit()
			$spielDauerInMillisek = _SoundLength($hSoundOpen,2)
			$diff = round(TimerDiff($hTimerInit))
			 _GUICtrlListView_ClickItem($hListView, $saveIndexPlaylist)
			 $iIndexPlaylist = $saveIndexPlaylist
		Else
			$soundActive = 1
			$lastIndex = $songAnzahl - 1
			 _GUICtrlListView_ClickItem($hListView, $lastIndex)
			$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
			$titel = StringSplit ( $selectedFolder &"\"&$a2d[$lastIndex][1], "\")
			$titel = $titel[$titel[0]]
			if StringLen($titel) > 50 then
				GUICtrlSetData($labAnzeige, "..... "&StringRight($titel, 50))
			Else
				GUICtrlSetData($labAnzeige,$titel)
			EndIf

			$hSoundOpen = _SoundOpen($selectedFolder &"\"&$a2d[$lastIndex][1])
			_SoundPlay($hSoundOpen,0)
			$hTimerInit = TimerInit()
			$spielDauerInMillisek = _SoundLength($hSoundOpen,2)
			$diff = round(TimerDiff($hTimerInit))
			 _GUICtrlListView_ClickItem($hListView, $lastIndex)
			 $iIndexPlaylist = $lastIndex
	;~ 		ConsoleWrite("else zweig:  " & $iIndexPlaylist &@CRLF)
		EndIf
	Else
		_GUICtrlListView_DeleteAllItems ( $hListView )
		enableDisableButtons(0)
		$labFolder = GUICtrlCreateLabel("Ordner waehlen", 40, 104, 278, 17)
		GUICtrlSetData($labAnzeige,"...")
	EndIf
	sleep(50)
EndFunc

func doNothing()
EndFunc

func enableDisableButtons($bool)
	if $bool = 0 Then
;~ 		disable
	GUICtrlSetState($butStop, $GUI_DISABLE)
	GUICtrlSetState($butPlay, $GUI_DISABLE)
	GUICtrlSetState($butVor, $GUI_DISABLE)
	GUICtrlSetState($butZurueck, $GUI_DISABLE)
	GUICtrlSetState($butShuffle, $GUI_DISABLE)
	GUICtrlSetState($butEndlos, $GUI_DISABLE)
	GUICtrlSetState($butPlaylist, $GUI_DISABLE)
	GUICtrlSetState($mSuche, $GUI_DISABLE)
	Else
;~ 		enable
	GUICtrlSetState($butStop, $GUI_ENABLE)
	GUICtrlSetState($butPlay, $GUI_ENABLE)
	GUICtrlSetState($butVor, $GUI_ENABLE)
	GUICtrlSetState($butZurueck, $GUI_ENABLE)
	GUICtrlSetState($butShuffle, $GUI_ENABLE)
	GUICtrlSetState($butEndlos, $GUI_ENABLE)
	GUICtrlSetState($butPlaylist, $GUI_ENABLE)
	GUICtrlSetState($mSuche, $GUI_ENABLE)

	EndIf

EndFunc

Func DragAndDrop()
;~ 	 **************** Drop Element prüfen *******************************************
;~ 		möglich ist ein Ordner (FileGetAttrib = D) oder file (FileGetAttrib = A)
;~ 		beim Ordner ist zu prüfen, ob er mp3 enthält - falls nicht, buttons nicht enablen
;~ 		beim File ist zu prüfen, ob es sich um ein mp3 handelt
	$selectedFolder = @GUI_DRAGFILE
;~ 	ConsoleWrite("File: "&$selectedFolder)
	local $attrib = FileGetAttrib($selectedFolder)
;~ 	MsgBox($MB_SYSTEMMODAL, "", $attrib)
	if $attrib="D" or $attrib = "AD" Then
		$selectedFile = ""
		folderDropped()
	Else
		fileDropped()
	EndIf
EndFunc

func fileDropped()
	_SoundClose($hSoundOpen)
	stop()
	enableDisableButtons(0)
	_ArrayDelete($aResult,0)
	Global $aResult = []
	_ArrayDelete($aResult,0)
	Global $aResult = []
	Global $a2d = []
	_GUICtrlListView_DeleteAllItems ( $hListView )
	GUICtrlSetData($labFolder,"Ordner waehlen")
	$selectedFile = $selectedFolder ;nur der Leserlichkeit wegen

;~ 	$sFile = mp3List.txt
	$titel = StringSplit ( $selectedFile, "\")
	$titel = $titel[$titel[0]]
	if StringInStr( $titel, "mp3") then
		$hFileOpen = FileOpen($sFile,2)
		FileWrite($hFileOpen, $titel)
		FileClose($hFileOpen)
	EndIf

	$checkContent = FileRead ($sFile)
	If $checkContent = "" Then
		MsgBox (0,"","nur mp3 Dateien moeglich")
	Else
		$hFile = FileOpen($sFile,0)
		for $i = 1 to _FileCountLines($sFile)
			$sLine = FileReadLine($hFile,$i)
	;~ 		MsgBox($MB_SYSTEMMODAL, "", $sLine)
			_ArrayAdd($aResult,$sLine)
		Next
	;~ 	_ArrayDisplay($aResult)
		FileClose($hFile)

		;~ 	**************** create 2d array *********************
		$iCount = UBound($aResult)  ; zeilenanzahl des Arrays ermitteln $aResult
		$songAnzahl = $iCount -1
		Global $a2d[$iCount][2]  ;zeile - spalte
		for $i = 1 to $iCount -1
			$a2d[$i][0] = $i
			$a2d[$i][1] = $aResult[$i]
		Next
		_ArrayDelete($a2d,0)
	;~ 	_ArrayDisplay($a2d)
		;~ 	**************** 2d array in listview füllen *********************
		_GUICtrlListView_AddArray($hListView,$a2d)
		enableDisableButtons(1)
		GUICtrlSetState($butShuffle, $GUI_DISABLE)
		GUICtrlSetState($butEndlos, $GUI_DISABLE)
		GUICtrlSetState($butPlaylist, $GUI_DISABLE)
	EndIf
EndFunc

func folderDropped()
	labFolderSetData()
	PopulateList()
EndFunc

func autoitLink()
	Run(@ComSpec & " /c Start https://www.autoitscript.com/site/autoit/")
EndFunc

func infoTool()
	MsgBox(64, "Info", "Tool zum Abspielen von mp3 Files" & @CRLF & _
	"Für Sakis Sette Bar" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"Alt+Strg + d : verschiebt gerade laufendes Lied in Ordner deletesSongs " & @CRLF & _
	"Alt+Strg + f : kopiert gerade laufendes Lied in Ordner Favorites" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"Strg + f : suche Lied" & @CRLF & _
	"Strg + u : beende Suchmodus (zeige ganze Liste wieder an)" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"Tab Taste (3. Taste oberhalb der STRG Taste) : pausiert bzw. spielt Lied weiter" & @CRLF & _
	"" & @CRLF & _
	"Alt+Strg + x : aktiviert bzw. deaktiviert alle Hotkeys - erkennbar an gruenem/roten Quadrat " & @CRLF & _
	"" & @CRLF & _
	"Alt+Strg + o : öffnet Player Ordner " & @CRLF & _
	"" & @CRLF & _
	"Rechtsklick(Kontextmenue) auf oberen Rand neben Icon : Auswahl der zu löschenden Playlist" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"Rechts- und Linkspfeil fuer vor und zurueck" & @CRLF & _
	"Oben- und Untenpfeil fuer Lautstaerke" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"" & @CRLF & _
	"Dieses Tool wurde mit Autoit erstellt." & @CRLF & _
	""&@CRLF&"Natalie Scheuble, April 2019")
EndFunc

func forward()
;~ 	writeToLog("forward")
	$pauseModus = 0
	$spielDauerInMillisek = 0
	_SoundStop($hSoundOpen)
	_SoundClose($hSoundOpen)
;~ 	ConsoleWrite("in forward: " & @CRLF)
	unsetHotkeys()
	$soundActive = 0
	$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
	if $iIndexPlaylist = ($songAnzahl -1) then
;~ 		ConsoleWrite("in forward: $iIndexPlaylist : " & $iIndexPlaylist& @CRLF)
;~ 		ConsoleWrite("in forward: $songAnzahl : " & $songAnzahl& @CRLF)
		if $endlosFlag = 1 Then
			$iIndexPlaylist = 0
			_GUICtrlListView_ClickItem($hListView, $iIndexPlaylist)
			play()
		Else
			doNothing()
		EndIf
	Else
		$iIndexPlaylist +=1
		_GUICtrlListView_ClickItem($hListView, $iIndexPlaylist)
		play()
	EndIf

EndFunc

func back()
	$pauseModus = 0
	$spielDauerInMillisek = 0
	_SoundStop($hSoundOpen)
	_SoundClose($hSoundOpen)
	unsetHotkeys()
	$soundActive = 0
	$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
	$iIndexPlaylist -=1
	_GUICtrlListView_ClickItem($hListView, $iIndexPlaylist)
	play()

EndFunc

func stop()
	$pauseModus = 0
;~ 	MsgBox(0, "$iIndexPlaylist", $iIndexPlaylist)
	_SoundStop($hSoundOpen)
	_SoundClose($hSoundOpen)
;~ 	ConsoleWrite("in stop: $iIndexPlaylist : " &$iIndexPlaylist& @CRLF)
	$soundActive = 0
	$spielDauerInMillisek = 0
	$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
	_GUICtrlListView_ClickItem($hListView, $iIndexPlaylist)

EndFunc

func pauseSoundToggle()
;~ 	MsgBox($MB_SYSTEMMODAL, "test","pausentoggle")
	if 	$pauseModus = 1 then ;pause ist aktiv
		_SoundResume($hSoundOpen)
		$pauseModus = 0
	Else
		_SoundPause($hSoundOpen)
		$pauseModus = 1
	EndIf
EndFunc

func play()
;~ 	ConsoleWrite("in play Anfang: spieldauer: "&$spielDauerInMillisek&" $diff: "&$diff & @CRLF)
	$pauseModus = 0
	_SoundStop($hSoundOpen)
	_SoundClose($hSoundOpen)

;~ 	MsgBox(0, "$iIndexPlaylist", $iIndexPlaylist)
	$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
	if $iIndexPlaylist = 0 Then
	    _GUICtrlListView_ClickItem($hListView, 0)
		$iIndexPlaylist = _GUICtrlListView_GetSelectedIndices($hListView)
	Else
		_GUICtrlListView_ClickItem($hListView, $iIndexPlaylist)
	EndIf

;~ 	MsgBox(0, "in play() $hSoundOpen", $hSoundOpen)

;~   MsgBox(0, "$iIndexPlaylist", $iIndexPlaylist)
;~   MsgBox(0, "$songAnzahl", $songAnzahl)

;~   MsgBox(0, "Selected Item", $a2d[$iIndexPlaylist][1])
;~   MsgBox(0, "Selected Item", $selectedFolder &"\"&$a2d[$iIndexPlaylist][1])
	$titel = StringSplit ( $selectedFolder &"\"&$a2d[$iIndexPlaylist][1], "\")
	$titel = $titel[$titel[0]]
;~ 	MsgBox(0, "Titel ist: ", $titel)

	if StringLen($titel) > 50 then
		GUICtrlSetData($labAnzeige, "..... "&StringRight($titel, 50))
	Else
		GUICtrlSetData($labAnzeige,$titel)
	EndIf

	if $selectedFile = "" then
		local $soundFile = $selectedFolder &"\"&$a2d[$iIndexPlaylist][1]
	else
		local $soundFile = $selectedFile
	EndIf

	if FileExists($soundFile) then
		writeToLog("Spiele : "&$soundFile )
		$hSoundOpen = _SoundOpen($soundFile)

		$spielDauerInMillisek = _SoundLength($hSoundOpen,2)
;~ 		ConsoleWrite("in play $spielDauerInMillisek : "&$spielDauerInMillisek& @CRLF)
		$diff = round(TimerDiff($hTimerInit))
		$soundActive = 1
;~ 	 	MsgBox(0, "Länge des Stücks", $spielDauerInMillisek)

		if $spielDauerInMillisek = 0 Then ;vermutlich kein mp3
			writeToLog("Spieldauer 0 Sekunden von : "& $soundFile)
			if $songAnzahl = 1 Then
				stop()
			Else
				forward()
			EndIf

		Else
			_SoundPlay($hSoundOpen,0)
			$hTimerInit = TimerInit()
			$diff = round(TimerDiff($hTimerInit))
		EndIf

	;~ 	_GUICtrlListView_ClickItem($hListView, $iIndexPlaylist)
	Else
;~ 		File nicht gefunden - vermutlich Sonderzeichen im Namen oder umbenannt - siehe logs
;~ 		_ArrayDisplay($aFileNotFound)
		local $searchArray = _ArraySearch ( $aFileNotFound, $soundFile)
;~ 		MsgBox($MB_SYSTEMMODAL, "searchArray -1 heisst nicht in array", $searchArray)
		if $searchArray = -1 then
			writeToLog("Datei nicht gefunden: "&$soundFile )
	;~ 		ConsoleWrite("play function else file not found - $soundFile: " & $soundFile &@CRLF)
			_ArrayAdd($aFileNotFound,$soundFile)
			forward()
		Else
			stop()
			SplashImageOn("Splash Screen", $soundfileMissing, 400, 329)
			Sleep(4000)
			SplashOff()
		EndIf

	EndIf

;~ 	ConsoleWrite("in play Ende: spieldauer: "&$spielDauerInMillisek&" $diff: "&$diff & @CRLF)
EndFunc

func labFolderSetData()
	if StringLen($selectedFolder) > 40 then
		GUICtrlSetData($labFolder, "..... "&StringRight($selectedFolder, 40))
	Else
		GUICtrlSetData($labFolder,$selectedFolder)
	EndIf
EndFunc


func selectOrdner()

;~ 	 **************** Ordner wählen *******************************************
;~     $selectedFolder = FileSelectFolder("Ordner wählen", @scriptdir & "\testMp3")
;~     $selectedFolder = FileSelectFolder("Ordner wählen", "c:\")
		$selectedFolder = FileSelectFolder("Ordner wählen", "c:\")
		If @error Then
			stop()
			_GUICtrlListView_DeleteAllItems ( $hListView )
			GUICtrlSetData($labAnzeige,"...")
			enableDisableButtons(0)
			GUICtrlSetData($labFolder,"...")
			MsgBox($MB_SYSTEMMODAL, "", "Kein Ordner ausgewählt")

		Else
			labFolderSetData()
			PopulateList()
		EndIf

EndFunc

func PopulateList()
	_SoundClose($hSoundOpen)
;~ 	$selectedFile = ""
	_ArrayDelete($aResult,0)
	Global $aResult = []
	Global $a2d = []
	_GUICtrlListView_DeleteAllItems ( $hListView )

;~ 	MsgBox($MB_SYSTEMMODAL, "in populate list: selected folder", $selectedFolder)
	Global $aResult = _FileListToArray($selectedFolder, "*.mp3")

	if $shuffleFlag = 1 Then   ;vor Shuffle Position 0 entfernen : enthält anzahl songs
		_ArrayDelete($aResult,0)
;~ 		_ArrayDisplay($aResult)
		_ArrayShuffle($aResult)
;~ 		_ArrayDisplay($aResult)
		_ArrayInsert($aResult, 0, "platzhalter")			;nach Shuffle an Position 0 wieder ein Element hinzufuegen: wird weiter unten gelöscht: 		_ArrayDelete($a2d,0)
	EndIf


    If @error = 1 Then
		GUICtrlSetData($labAnzeige,"...")
		enableDisableButtons(0)
		MsgBox($MB_SYSTEMMODAL, "", "Ordner enthaelt keine mp3 Dateien")
    Else

		;~ 	**************** create 2d array für listview *********************
		$iCount = UBound($aResult)  ; zeilenanzahl des Arrays ermitteln $aResult
		$songAnzahl = $iCount -1
		Global $a2d[$iCount][2]  ;zeile - spalte
		for $i = 1 to $iCount -1
			$a2d[$i][0] = $i
			$a2d[$i][1] = $aResult[$i]
		Next
		_ArrayDelete($a2d,0)


	;~ 	_ArrayDisplay($a2d)
		;~ 	**************** 2d array in listview füllen *********************
		_GUICtrlListView_AddArray($hListView,$a2d)
		enableDisableButtons(1)
		$listViewFilled = 1
	EndIf
	_GUICtrlListView_ClickItem($hListView, 0)

	HotKeySet("^f", "suche")
	HotKeySet("^u", "populatelist")
EndFunc

Func On_Close_Main()
	FileDelete( $sFile )
	writeToLog("--------- ENDE Anwendung ---------------" &@CRLF)
	Exit
EndFunc

