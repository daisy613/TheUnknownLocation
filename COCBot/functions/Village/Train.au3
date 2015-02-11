 ;Uses the location of manually set Barracks to train specified troops

; Train the troops (Fill the barracks)
#CS
Func GetTrainPos($troopKind)
   Switch $troopKind
   Case $eBarbarian ; 261, 366: 0x39D8E0
	  Return $TrainBarbarian
   Case $eArcher ; 369, 366: 0x39D8E0
	  Return $TrainArcher
   Case $eGiant ; 475, 366: 0x3DD8E0
	  Return $TrainGiant
   Case $eGoblin ; 581, 366: 0x39D8E0
	  Return $TrainGoblin
   Case $eWallbreaker ; 688, 366, 0x3AD8E0
	  Return $TrainWallbreaker
   Case Else
	  SetLog("Don't know how to train the troop " & $troopKind & " yet")
	  Return 0
   EndSwitch
EndFunc

Func TrainIt($troopKind, $howMuch = 1, $iSleep = 900)
   _CaptureRegion()
   Local $pos = GetTrainPos($troopKind)
   If IsArray($pos) Then
	  If CheckPixel($pos) Then
		 ClickP($pos, $howMuch, 20)
		 if _Sleep($iSleep) Then Return False
		 Return True
	  EndIf
   EndIf
EndFunc
#CE

Func Train()
	If $barrackPos[0][0] = "" Then
		LocateBarrack()
		SaveConfig()
		If _Sleep(2000) Then Return
	EndIf
	SetLog("Training Troops...", $COLOR_BLUE)

   Local $BarrackCount = 0
   For $x = 0 To 3
	   If $barrackPos[$x][0] <> "" Then $BarrackCount += 1
   Next
	For $i = 0 To 3
		If _Sleep(500) Then ExitLoop

		ClickP($TopLeftClient) ;Click Away

		If _Sleep(500) Then ExitLoop

		Click($barrackPos[$i][0], $barrackPos[$i][1]) ;Click Barrack

		If _Sleep(500) Then ExitLoop

		Local $TrainPos = _PixelSearch(155, 603, 694, 605, Hex(0x603818, 6), 5) ;Finds Train Troops button
		If IsArray($TrainPos) = False Then
			SetLog("Barrack " & $i + 1 & " is not available", $COLOR_RED)
		Else
			Click($TrainPos[0], $TrainPos[1]) ;Click Train Troops button
			If _Sleep(800) Then ExitLoop

			CheckFullArmy()
			If _GUICtrlComboBox_GetCurSel($cmbTroopComp) = 8 Then
				Switch $barrackTroop[$i]
					Case 0
						While _ColorCheck(_GetPixelColor(329, 297), Hex(0xDC3F70, 6), 20)
							Click(220, 320, 5) ;Barbarian
							If _Sleep(10) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 1
						While _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
							Click(331, 320, 5) ;Archer
							If _Sleep(10) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 2
						While _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
							Click(432, 320, 5) ;Giant
							If _Sleep(10) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 3
						While _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
							Click(546, 320, 5) ;Goblin
							If _Sleep(10) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 4
						While _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
							Click(647, 320, 5) ;Wall breaker
							If _Sleep(10) Then ExitLoop
							_CaptureRegion()
						WEnd
				EndSwitch
			Else
				; More Troops Settings
				_CaptureRegion()
				If $fullArmy Then
					If _Sleep(1000) Then ExitLoop
					While _ColorCheck(_GetPixelColor(476, 211), Hex(0xE0E4D0, 6), 20) = False
						Click(496, 197, 20)
						_CaptureRegion()
					WEnd
					If $ArmyComp >= $icmbTroopCap Then
						$ArmyComp = 0
					EndIf
				 EndIf
				If $ArmyComp = 0 Then
					$CurGiant = GUICtrlRead($txtNumGiants)
					$CurWB = GUICtrlRead($txtNumWallbreakers)
					$CurArch = ($icmbTroopCap-(GUICtrlRead($txtNumGiants)*5)-(GUICtrlRead($txtNumWallbreakers)*2))*GUICtrlRead($txtArchers)/100
					$CurArch = Round($CurArch)
					$CurBarb = ($icmbTroopCap-(GUICtrlRead($txtNumGiants)*5)-(GUICtrlRead($txtNumWallbreakers)*2))*GUICtrlRead($txtBarbarians)/100
					$CurBarb = Round($CurBarb)
					$CurGoblin = ($icmbTroopCap-(GUICtrlRead($txtNumGiants)*5)-(GUICtrlRead($txtNumWallbreakers)*2))*GUICtrlRead($txtGoblins)/100
					$CurGoblin = Round($CurGoblin)
				 EndIf
				 Local $x
				 If GUICtrlRead($txtNumGiants) <> "0" And ($CurGiant <> -1 Or $CurGiant > 0) Then
					_CaptureRegion()
					$x = Ceiling($CurGiant/($BarrackCount-$i))
					 While _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
						 If $CurGiant > 0 Then
							 $CurGiant -= 1
							 $ArmyComp += 5
							 Click(432, 320) ;Giant
							 If _Sleep(300) Then ExitLoop
							 _CaptureRegion()
							 $x -= 1
							 If $x <= 0 Or $CurGiant <= 0 Then
								If _Sleep(1000) Then ExitLoop
							    ExitLoop
							  EndIf
						 Else
							 $CurGiant = "-1"
						 EndIf
					 WEnd
				  EndIf
				  If GUICtrlRead($txtNumWallbreakers) <> "0" And ($CurWB <> -1 Or $CurWB > 0) Then
					 _CaptureRegion()
					$x = Ceiling($CurWB/($BarrackCount-$i))
					 While _ColorCheck(_GetPixelColor(648, 292), Hex(0xE0E4D0, 6), 20) = False And _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
						 If $CurWB > 0 Then
							 $CurWB -= 1
							 $ArmyComp += 2
							 Click(647, 320) ;WB
							 If _Sleep(300) Then ExitLoop
							 _CaptureRegion()
							 $x -= 1
							 If $x <= 0 Or $CurWB <= 0 Then
								If _Sleep(1000) Then ExitLoop
							    ExitLoop
							  EndIf
						 Else
							 $CurWB = "-1"
						 EndIf
					 WEnd
				  EndIf
				  If GUICtrlRead($txtGoblins) <> "0" And ($CurGoblin <> -1 Or $CurGoblin > 0) Then
					 _CaptureRegion()
					$x = Ceiling($CurGoblin/($BarrackCount-$i))
					 While _ColorCheck(_GetPixelColor(509, 305), Hex(0xE0E4D0, 6), 20) = False And _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
						 If $CurGoblin > 0 Then
							 $CurGoblin -= 1
							 $ArmyComp += 1
							 Click(546, 320) ;Goblin
							 If _Sleep(300) Then ExitLoop
							 _CaptureRegion()
							 $x -= 1
							 If $x <= 0 Or $CurGoblin <= 0 Then
								If _Sleep(1000) Then ExitLoop
							    ExitLoop
							  EndIf
						 Else
							 $CurGoblin = "-1"
						 EndIf
					 WEnd
				  EndIf
				 If GUICtrlRead($txtArchers) <> "0" And ($CurArch <> -1 Or $CurArch > 0) Then
					_CaptureRegion()
					$x = Ceiling($CurArch/($BarrackCount-$i))
					 While _ColorCheck(_GetPixelColor(217, 297), Hex(0xF8AD20, 6), 20)
						 If $CurArch > 0 Then
							 $CurArch -= 1
							 $ArmyComp += 1
							 Click(331, 320) ;Archer
							 If _Sleep(300) Then ExitLoop
							 _CaptureRegion()
							 $x -= 1
							 If $x <= 0 Or $CurArch <= 0 Then
								If _Sleep(1000) Then ExitLoop
							    ExitLoop
							  EndIf
						 Else
							 $CurArch = "-1"
						 EndIf
					 WEnd
				 EndIf
				  If GUICtrlRead($txtBarbarians) <> "0" And ($CurBarb <> -1 Or $CurBarb > 0) Then
					$x = Ceiling($CurBarb/($BarrackCount-$i))
					_CaptureRegion()
					 While _ColorCheck(_GetPixelColor(329, 297), Hex(0xDC3F70, 6), 20)
						 If $CurBarb > 0 Then
							 $CurBarb -= 1
							 $ArmyComp += 1
							 Click(220, 320) ;Barbarian
							 If _Sleep(300) Then ExitLoop
							 _CaptureRegion()
							 $x -= 1
							 If $x <= 0 Or $CurBarb <= 0 Then
								If _Sleep(1000) Then ExitLoop
							    ExitLoop
							  EndIf
						 Else
							 $CurBarb = "-1"
						 EndIf
					 WEnd
				 EndIf
			EndIf
		 EndIf
	    If _ColorCheck(_GetPixelColor(476, 211), Hex(0xE0E4D0, 6), 20) Then $ArmyComp = 0
		If _Sleep(500) Then ExitLoop
		Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
	 Next
	SetLog("Training Troops Complete", $COLOR_BLUE)
 EndFunc   ;==>Train
