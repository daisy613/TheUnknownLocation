Global $txtUse = 0

Func UpgradeWall()
	$ichkWalls = GUICtrlRead($chkWalls)
	If $ichkWalls = 1 And WallCurrentStorage() Then
		While checkWall()
			Click(1, 1) ; Click Away
			If _Sleep(600) Then ExitLoop
			Click($WallX, $WallY)
			If _Sleep(600) Then ExitLoop
			Click(432, 597) ; Select Row
			If _Sleep(600) Then ExitLoop
			_CaptureRegion()
			If (($iUseStorage = 0 Or $iUseStorage = 2) And _ColorCheck(_GetPixelColor(500, 570), Hex(0xFF0000, 6), 20)) Then
				SetLog("Not enough " & $txtUse & ", Trying upgrade only one wall...", $COLOR_ORANGE)
				Click($WallX, $WallY)
				If _Sleep(2000) Then ExitLoop
				_CaptureRegion()
				If (($iUseStorage = 0 Or $iUseStorage = 2) And _ColorCheck(_GetPixelColor(549, 570), Hex(0xFFFFFF, 6), 20) = False) Then
					SetLog("Not enough " & $txtUse & ", Upgrading later...", $COLOR_ORANGE)
					Click(1, 1) ; Click Away
					ExitLoop
				EndIf
			ElseIf _ColorCheck(_GetPixelColor(500, 570), Hex(0xFFFFFF, 6), 20) = False Then
				SetLog("Walls already upgraded", $COLOR_GREEN)
				ExitLoop
			EndIf
			Click(507, 599) ; Click Upgrade
			If _Sleep(2000) Then ExitLoop
			_CaptureRegion()
			If _ColorCheck(_GetPixelColor(472, 482), Hex(0xFFFFFF, 6), 20) Then
				Click(472, 482) ; Click Okay
				If _Sleep(3000) Then ExitLoop
			Else
				Click(506, 396) ; Click Okay
				If _Sleep(3000) Then ExitLoop
			EndIf
			Click(1, 1) ; Click Away
		WEnd
	EndIf
EndFunc

Func WallCurrentStorage()
    VillageReport()
    SetLog("Upgrading Walls..")
	If GUICtrlRead($UseGold) = $GUI_CHECKED Then
		$iUseStorage = 0
	ElseIf GUICtrlRead($UseElixir) = $GUI_CHECKED Then
		$iUseStorage = 1
	ElseIf GUICtrlRead($UseGoldElix) = $GUI_CHECKED Then
		$iUseStorage = 2
	EndIf
	$itxtWallMinGold = GUICtrlRead($txtWallMinGold)
	$itxtWallMinElixir = GUICtrlRead($txtWallMinElixir)
	Local $MinWallGold = Number($GoldCount) > Number($itxtWallMinGold)
	Local $MinWallElixir = Number($ElixirCount) > Number($itxtWallMinElixir)

	If $iUseStorage = 1 Or $iUseStorage = 2 Then
		If $MinWallElixir Then
			SetLog("Upgrading Walls Using Elixir", $COLOR_BLUE)
			$txtUse = "Elixir"
			Return True
		ElseIf $iUseStorage = 2 Then
			SetLog("Elixir is lower than Min. Elixir condition, Using Gold...")
		Else
			SetLog("Elixir is lower than Min. Elixir condition, upgrading later...", $COLOR_ORANGE)
			Return False
		EndIf
	EndIf
	If $iUseStorage = 0 Or $iUseStorage = 2 Then
		If $MinWallGold Then
			SetLog("Upgrading Walls Using Gold...", $COLOR_BLUE)
			$txtUse = "Gold"
			Return True
		Else
			SetLog("Gold is lower than Min. Gold condition, upgrading later...", $COLOR_ORANGE)
			Return False
		EndIf
	EndIf
EndFunc