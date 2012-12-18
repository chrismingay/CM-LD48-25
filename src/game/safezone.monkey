Import ld

Class SafeZone

	Field level:Level

	Field X:Float
	Field Y:Float
	Field W:Float
	Field H:Float
	
	Method New(tLev:Level)
		level = tLev
	End
	
	Method Render:Void()
		SetAlpha(0.25)
		SetColor(0, 255, 0)
		'DrawRect(X - LDApp.ScreenX, Y - LDApp.ScreenY, W, H)
		For Local tX:Int = X Until X + W Step 16
			For Local tY:Int = Y Until Y + H Step 16
				GFX.Draw(tX, tY, 0, 432, 16, 16)
			Next
		Next
		
	End

End