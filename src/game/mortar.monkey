Import ld

Class Mortar
	
	Field X:Float
	Field Y:Float
	Field Z:Float
	Field ZS:Float
	Field D:Float
	Field S:Float
	
	Const Width:Int = 5
	Const Height:Int = 5
	
	Field Active:Bool
	
	Field level:Level
	
	Method New(tLev:Level)
		level = tLev
	End
	
	Method Update:Void()
		X += Sin(D) * S * level.delta
		Y += Cos(D) * S * level.delta
		Z += ZS * level.delta
		
		ZS += (0.02 * level.delta)
		
		If Z >= 0
			Explode()
		EndIf
	End
	
	Method Render:Void()
		GFX.Draw(X - (Width * 0.5), Y - (Height * 0.5), 208, 24, Width, 2)
		GFX.Draw(X - (Width * 0.5), Y - (Height * 0.5) + Z, 208, 16, Width, Height)
	End
	
	Method Explode:Void()
		Active = False
		SFX.Play("ZombieExplode", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
		
		For Local i:Int = 0 Until level.ZombieCount
			If level.Zombies[i].Alive = True
				Local tDist:Float = DistanceBetweenPoints(X, Y, level.Zombies[i].X, level.Zombies[i].Y)
				If tDist < 50
					Local tDir:Float = DirectionBetweenPoints(X, Y, level.Zombies[i].X, level.Zombies[i].Y)
					Local tForce:Float = (50 - tDist) / 12.5
					level.Zombies[i].Health -= (tForce * 20)
					level.Zombies[i].AdditionalForce(Sin(tDir) * tForce, Cos(tDir) * tForce)
				EndIf
			EndIf
		Next
		
		For Local i:Float = 0 Until 350 Step 36
			Local tXS:Float = Sin(i) * 1.0
			Local tYS:Float = Cos(i) * 0.66
			Particle.Add(X,Y,tXS,tYS,ParticleTypes.SMOKE)
		Next
	End
	
	Method Activate:Void(tX:Float, tY:Float)
		X = tX
		Y = tY
		Z = -8
		D = Rnd(0, 360.0)
		S = Rnd(0.4, 1.2)
		ZS = -1.2
		Active = True
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5), Y - (Width * 0.5), Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End

End