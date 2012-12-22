Import ld

Class MortarLauncher

	Field level:Level
	
	Field Active:Bool

	Field X:Float
	Field Y:Float
	Const Width:Int = 16
	Const Height:Int = 16
	
	Const READY:Int = 0
	Const RELOADING:Int = 1
	
	Field Status:Int
	
	Field ReloadCounter:Float
	Const ReloadTarget:Float = 60.0
	
	Const DRAW_OFFSET_X:Int = 0
	Const DRAW_OFFSET_Y:Int = 16
	
	Method New(tLev:Level)
		level = tLev
		Active = True
	End
	
	Method Update:Void()
		Select Status
		Case READY
		
		Case RELOADING
			ReloadCounter += 1.0 * level.delta
			If ReloadCounter >= ReloadTarget
				Status = READY
			EndIf
		End
	End
	
	Method Render:Void()
		GFX.Draw(X - (Width * 0.5) - DRAW_OFFSET_X, Y - (Height * 0.5) - DRAW_OFFSET_Y, 192, 0, 16, 32)
	End
	
	Method Shoot:Void()
		Status = RELOADING
		ReloadCounter = 0.0
		level.ActivateMortar(X, Y)
		SFX.Play("MortarShoot", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y))
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5) - DRAW_OFFSET_X, Y - (Width * 0.5) - DRAW_OFFSET_Y, Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End


End