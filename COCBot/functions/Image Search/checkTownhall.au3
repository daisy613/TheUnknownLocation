Global $atkTH[5]
For $i = 0 To 4
   $atkTH[$i] = @ScriptDir & "\images\TH\" & $i+6 & ".bmp"
Next
Global $Tolerance1 = 85

Func checkTownhall()
   Local $x = 0
   For $x = 0 To 3
	   _CaptureRegion()
	  For $i = 4 To 0 Step -1
	   $THLocation = _ImageSearch($atkTH[$i], 1, $THx, $THy, $Tolerance1) ; Getting TH Location
	   If $THLocation = 1 Then
		   Return $THText[$i]
	   EndIf
	  Next
   Next
   If $THLocation = 0 Then Return "-"
EndFunc