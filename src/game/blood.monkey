Import ld

Class Blood

	Field level:Level
	
	Field X:Float
	Field Y:Float
	Field Z:Float
	
	Const Width:Int = 8
	Const Height:Int = 8
	
	Field D:Float
	Field S:Float
	Field ZS:Float
	
	Field Active:Bool
	
	Field Frame:Int
	Const FrameDelay:Float = 8.0
	Field FrameDelayTimer:Float
	
	
	Method New(tLev:Level)
		Active = False
		level = tLev
	End
	
	Method Activate:Void(tX:Float, tY:Float, tZ:Float)
		Active = True
		X = tX
		Y = tY
		Z = tZ
		
		D = Rnd(0, 360)
		S = Rnd(0.2, 0.4)
		
		ZS = 0.0
		
		Frame = 0
		FrameDelayTimer = 0
		
	End
	
	Method Deactivate:Void()
		Active = False
	End
	
	Method Update:Void()
	
		X += Sin(D) * S * level.delta
		Y += Cos(D) * S * level.delta
	
		ZS += 0.01 * level.delta
		
		Z += ZS * level.delta
		
		If Z > 0
			Z = 0
			Deactivate()
			
		EndIf
		
		FrameDelayTimer += 1.0 * level.delta
		If FrameDelayTimer >= FrameDelay
			FrameDelayTimer = 0.0
			Frame += 1
			
			If Frame > 3
				Frame = 3
			EndIf
		EndIf
		
	End
	
	Method Render:Void()
		GFX.Draw(X - 4, Y - 4 + Z, 0 + (Frame * 8), 72, 8, 8)
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5), Y - (Width * 0.5), Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End


End