Option Explicit

	Dim strComputer, objComputer, objUser
		strComputer = "."
		Set objComputer = GetObject("WinNT://" & strComputer)
			objComputer.Filter = Array("user")
				For Each objUser In objComputer
					On Error Resume Next
					Wscript.Echo objUser.Name & ", " & objUser.LastLogin
				If (Err.Number <> 0) Then
					On Error GoTo 0
					Wscript.Echo objUser.Name & ", "
				End If
					On Error GoTo 0
Next