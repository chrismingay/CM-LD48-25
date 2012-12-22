Import ld

Class Shout

	Global Shouts:Shout[]
	Global NextShout:Int = 0
	Const MAX_SHOUTS:Int = 10
	
	Const RADIUS:Float = 100.0
	
	Function Init:Void(tLev:Level)
		Shouts = New Shout[MAX_SHOUTS]
		For Local i:Int = 0 Until MAX_SHOUTS
			Shouts[i] = New Shout(tLev)
		Next
		NextShout = 0
	End
	
	Function RenderAll:Void()
		For Local i:Int = 0 Until MAX_SHOUTS
			If Shouts[i].Active = True
				If Shouts[i].IsOnScreen()
					Shouts[i].Render()
				Endif
			Endif
		Next	
	End
	
	Function UpdateAll:Void()
		For Local i:Int = 0 Until MAX_SHOUTS
			If Shouts[i].Active = True
				Shouts[i].Update()
			Endif
		Next	
	End
	
	Function Create:Void(tX:Float, tY:Float)
		Shouts[NextShout].Activate(tX, tY)
		NextShout += 1
		If NextShout = MAX_SHOUTS
			NextShout = 0
		EndIf
	End


	Const Width:Int = 4
	Const Height:Int = 4

	Field X:Float
	Field Y:Float
	Field R:Float
	
	Field level:Level
	Field Active:Bool
	
	Field lifeSpan:Float
	Method New(tLev:Level)
		Active = False
		level = tLev
	End
	
	Method Update:Void()
		
		lifeSpan -= 1.0 * level.delta
		
		If lifeSpan <= 0.0
			Deactivate()
		EndIf
		
	End
	
	
	
	Method Render:Void()
		If lifeSpan > 20.0
			SetAlpha(0.25)
		Else
			SetAlpha(lifeSpan / 80.0)
		EndIf
		
		' Print GetAlpha()
		SetColor(20, 220, 40)
		DrawCircle(X - LDApp.ScreenX, Y - LDApp.ScreenY, R)
		
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (R), Y - (R), R * 2, R * 2, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End
	
	Method Activate:Void(tX:Float, tY:Float)
		X = tX
		Y = tY
		R = RADIUS
		lifeSpan = 30.0
		Active = True
	End
	
	Method Deactivate:Void()
		Active = False
	End
	
	
End	