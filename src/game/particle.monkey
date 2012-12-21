Import ld

Class Particle

	Const DRAW_X:Int = 192
	Const DRAW_Y:Int = 48
	Const WIDTH:Int = 16
	Const HEIGHT:Int = 16

	Global Particles:Particle[]
	Const MAX_PARTICLES:Int = 200
	Global NextParticle:Int = 0
	
	Function Init:Void(tLev:Level)
		Particles = New Particle[MAX_PARTICLES]
		For Local i:Int = 0 Until MAX_PARTICLES
			Particles[i] = New Particle(tLev)
		Next
	End
	
	Function Add:Void(tX:Float, tY:Float, tXS:Float, tYS:Float, tType:Int)
		Particles[NextParticle].Activate(tX, tY, tXS, tYS, tType)
		NextParticle += 1
		If NextParticle >= MAX_PARTICLES
			NextParticle = 0
		EndIf
	End
	
	Function UpdateAll:Void()
		For Local i:Int = 0 Until MAX_PARTICLES
			If Particles[i].Active = True
				Particles[i].Update()
			EndIf
		Next
	End
	
	Function RenderAll:Void()
		For Local i:Int = 0 Until MAX_PARTICLES
			If Particles[i].Active = True
				If Particles[i].IsOnScreen()
					Particles[i].Render()
				EndIf
			EndIf
		Next
	End
	
	Field X:Float
	Field Y:Float
	Field XS:Float
	Field YS:Float
	
	Field Type:Int
	
	Field Active:Bool
	
	Field lifeSpan:Float
	
	Field level:Level
	
	Method New(tlev:Level)
		level = tlev
		Active = False
	End
	
	Method Update:Void()
	
		X += (XS * level.delta)
		Y += (YS * level.delta)
		
		Select Type
			Case ParticleTypes.SMOKE
				XS *= 1.0 - (0.02 * level.delta)
				YS *= 1.0 - (0.02 * level.delta)
		End
	
		lifeSpan -= 1.0 * level.delta
		If lifeSpan <= 0
			Deactivate()
		EndIf
	End
	
	Method Render:Void()
		If lifeSpan < 20.0
			SetAlpha(lifeSpan / 20.0)
		Else
			SetAlpha(1.0)
		EndIf
		GFX.Draw(X - 8, Y - 8, DRAW_X + (Type * 16), DRAW_Y, 16, 16)
	End
	
	Method Deactivate:Void()
		Active = False
	End
	
	Method Activate(tX:Float, tY:Float, tXS:Float, tYS:Float, tType:Int)
		Active = True
		X = tX
		Y = tY
		XS = tXS
		YS = tYS
		
		Type = tType
		Select tType
			Case ParticleTypes.SMOKE
				lifeSpan = 40.0
		End
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (WIDTH * 0.5), Y - (HEIGHT * 0.5), WIDTH, HEIGHT, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End

End

Class ParticleTypes
	Const SMOKE:Int = 0
End