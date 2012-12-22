Import ld

Class Spit

	Global Spits:Spit[]
	Global NextSpit:Int =0
	Const MAX_SPITS:Int = 50
	
	Function Init:Void(tLev:Level)
		Spits = New Spit[MAX_SPITS]
		For Local i:Int = 0 Until MAX_SPITS
			Spits[i] = New Spit(tLev)
		Next
		NextSpit = 0
	End
	
	Function RenderAll:Void()
		For Local i:Int = 0 Until MAX_SPITS
			If Spits[i].Active = True
				If Spits[i].IsOnScreen()
					Spits[i].Render()
				Endif
			Endif
		Next	
	End
	
	Function UpdateAll:Void()
		For Local i:Int = 0 Until MAX_SPITS
			If Spits[i].Active = True
				Spits[i].Update()
			Endif
		Next	
	End
	
	Function Create:Void(tX:Float, tY:Float, tD:Float)
		Spits[NextSpit].Activate(tX, tY, tD)
		NextSpit += 1
		If NextSpit = MAX_SPITS
			NextSpit = 0
		EndIf
	End


	Const Width:Int = 4
	Const Height:Int = 4

	Field X:Float
	Field Y:Float
	Field Z:Float
	Field D:Float
	Field S:Float
	Field ZS:Float
	
	Field level:Level
	Field Active:Bool
	
	Field Frame:Int
	Const FrameTimerTarget:Float = 4
	Field FrameTimer:Float
	
	Method New(tLev:Level)
		Active = False
		level = tLev
	End
	
	Method Update:Void()
		X += Sin(D) * S * level.delta
		Y += Cos(D) * S * level.delta
		Z += ZS * level.delta
		ZS += 0.01 * level.delta
		
		If Z >=0
			Deactivate()
		EndIf
		
		FrameTimer += 1.0 * level.delta
		If FrameTimer >= FrameTimerTarget
			FrameTimer = 0
			Frame += 1
			If Frame > 1
				Frame = 0
			EndIf
			
		EndIf
		
		If Z > - 8
			If level.CollidesWith(X - (Width * 0.5), Y - (Height * 0.5), Width, Height)
				Deactivate()
			End
		EndIf
		
		For Local i:Int = 0 Until level.HeroCount
			If level.Heroes[i].Alive = True
				If level.Heroes[i].CollidesWith(X - (Width * 0.5), Y - (Height * 0.5), Width, Height)
					level.Heroes[i].ReactToSpit(Self)
					Deactivate()
				EndIf
			EndIf
		Next
		
	End
	
	
	
	Method Render:Void()
		GFX.Draw(X - (Width * 0.5), Y - (Height * 0.5), 16, 88, Width, Height)
		GFX.Draw(X - (Width * 0.5), Y - (Height * 0.5) + Z, 0 + (8 * Frame), 88, Width, Height)
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5),Y - (Height * 0.5),Width, Height, LDApp.ScreenX,LDApp.ScreenY,LDApp.ScreenWidth,LDApp.ScreenHeight)
	End
	
	Method Activate:Void(tX:Float,tY:Float,tD:Float)
		X = tX
		Y = tY
		D = tD
		Z = -8
		ZS = -0.3
		Active = True
		S = 2
	End
	
	Method Deactivate:Void()
		If Active = True
			Active = False
			SFX.Play("SpitDeactivate", SFX.VolumeFromPosition(X, Y) * 0.1, SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
		EndIf
	End
	
	
End	