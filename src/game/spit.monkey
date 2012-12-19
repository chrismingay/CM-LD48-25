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
		Endif
		
	End
	
	Method Render:Void()
	
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5),Y - (Height * 0.5),Width, Height, LDApp.ScreenX,LDApp.ScreenY,LDApp.ScreenWidth,LDApp.ScreenHeight)
	End
	
	Method Activate:Void(tX:Float,tY:Float,tD:Float)
		X = tX
		Y = tY
		D = tD
		Z = -8
		ZS = -0.1
		Active = True
	End
	
	Method Deactivate:Void()
		Active = False
	End
	
	
	