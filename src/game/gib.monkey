Import ld

Class Gib

	Const DRAW_X:Int = 32
	Const DRAW_Y:Int = 64
	

	Field level:Level
	
	Const Width:Int = 8
	Const Height:Int = 8
	
	Field X:Float
	Field Y:Float
	Field Z:Float
	
	Field D:Float
	Field S:Float
	Field ZS:Float
	
	Field Active:Bool
	
	Field Frame:Int
	Const FrameDelay:Float = 6.0
	Field FrameDelayTimer:Float
	
	Field canBleed:Bool
	Const BloodDelay:Float = 6.0
	Field BloodDelayTimer:Float
	
	Field Type:Int
	
	
	Method New(tLev:Level)
		Active = False
		level = tLev
	End
	
	Method Activate:Void(tX:Float, tY:Float, tType:Int = GibType.ZOMBIE_FLESH)
		Active = True
		X = tX
		Y = tY
		
		Type = tType
		
		D = Rnd(0, 360)
		S = Rnd(0.5, 1.0)
		
		ZS = Rnd(-2, -1)
		
		Select Type
			Case GibType.ZOMBIE_FLESH, GibType.HUMAN_FLESH
				canBleed = True
			Default
				canBleed = False
		End
		
		Frame = 0
		FrameDelayTimer = 0
		BloodDelayTimer = 0
		
	End
	
	Method Deactivate:Void()
		Active = False
	End
	
	Method Update:Void()
		ZS += 0.05 * level.delta
		
		Z += ZS * level.delta
		X += Sin(D) * S * level.delta
		Y += Cos(D) * S * level.delta
		
		If Z > 0
			Z = 0
			If ZS > 1
				ZS = 0 - (ZS * 0.75)
				S = S * 0.5
			Else
				Deactivate()
			End
		EndIf
		
		FrameDelayTimer += 1.0 * level.delta
		If FrameDelayTimer >= FrameDelay
			FrameDelayTimer = 0.0
			Frame += 1
			
			If Frame > 3
				Frame = 0
			EndIf
		EndIf
		
		If canBleed
			BloodDelayTimer += 1.0 * level.delta
			If BloodDelayTimer >= BloodDelay
				level.ActivateBlood(X, Y, Z)
				BloodDelayTimer = 0.0
			EndIf
		EndIf
	End
	
	Method Render:Void()
		GFX.Draw(X - 4, Y - 4, 16, 56, 8, 8)
		GFX.Draw(X - 4, Y - 4 + Z, (Type * 32) + (Frame * 8), 64, 8, 8)
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5), Y - (Width * 0.5), Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End


End

Class GibType
	Const ZOMBIE_FLESH:Int = 0
	Const HUMAN_FLESH:Int = 1
	Const SKULL:Int = 2
	Const BONE:Int = 3
End