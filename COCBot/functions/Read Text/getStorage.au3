;Gets complete value of Gold and Elixir Storage x,xxx,xxx

Func getStorage($x_start, $y_start)
	_CaptureRegion(0, 0, $x_start + 120, $y_start + 20)
	;-----------------------------------------------------------------------------
	Local $x = $x_start, $y = $y_start
	Local $Number, $Number2, $i = 0
	$Number = getDigit($x, $y, "Storage")

	While $Number = ""
		If $i >= 26 Then ExitLoop
		$i += 1
		$x += 1
		$Number = getDigit($x, $y, "Storage")
	WEnd
	If $Number <> "" Then
		$x += 4
		$Number &= getDigit($x, $y, "Storage")
		$Number &= getDigit($x, $y, "Storage")
		$Number &= getDigit($x, $y, "Storage")
	Else
		$i = 0
		While $Number = ""
			If $i >= 64 Then ExitLoop
			$i += 1
			$x += 1
			$Number = getDigit($x, $y, "Storage")
		WEnd
		If $Number <> "" Then
			$Number &= getDigit($x, $y, "Storage")
			$Number &= getDigit($x, $y, "Storage")
		EndIf
	EndIf

	If $Number Then $x += 3
	$i = 0
	While $Number2 = ""
		If $i >= 99 Then ExitLoop
		$i += 1
		$x += 1
		$Number2 = getDigit($x, $y, "Storage")
	WEnd
	$Number2 &= getDigit($x, $y, "Storage")
	$Number2 &= getDigit($x, $y, "Storage")
	Return $Number & $Number2
EndFunc   ;==>getStorage

