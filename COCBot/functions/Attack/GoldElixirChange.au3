
;==========================================================================
; Function name: GoldElixirChange
; Authored by:
; Edited by: Samota,
;
; Description: Checks if the gold/elixir changes values within 60 seconds, Returns True if changed. Also
; checks every 5 seconds if gold/elixir = "", meaning battle is over. If either condition is met, return
; false.
;
; Notes: If all troops are used, the battle will end when they are all dead, the timer runs out, or the
; base has been 3-starred. When the battle ends, it is detected within 5 seconds, otherwise it takes up
; to 60 seconds.
;
;==========================================================================
Func GoldElixirChange()
	Local $Gold1, $Gold2
	Local $Elixir1, $Elixir2
	SetLog("Checking if battle is ended", $COLOR_GREEN)
	While 1
		$Gold1 = getGold(51, 66)
		$Elixir1 = getElixir(51, 66 + 29)
		Local $iBegin = TimerInit()
		While TimerDiff($iBegin) < 60000
			If _Sleep(5000) Then Return
			$Gold2 = getGold(51, 66)
			$Elixir2 = getElixir(51, 66 + 29)
			If ($Gold2 = "" And $Elixir2 = "") Then
				SetLog("Battle is ended", $COLOR_GREEN)
				Return False
			EndIf
		WEnd
		$Gold2 = getGold(51, 66)
		$Elixir2 = getElixir(51, 66 + 29)
		If ($Gold1 = $Gold2 And $Elixir1 = $Elixir2) Or ($Gold2 = "" And $Elixir2 = "") Then
			Return False
		Else
			SetLog("Gold & Elixir change detected, waiting...", $COLOR_GREEN)
			Return True
		EndIf
		ExitLoop
	WEnd
EndFunc   ;==>GoldElixirChange
