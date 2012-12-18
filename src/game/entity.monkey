Import ld

Class Entity

	Field level:Level
	
	Field OldX:Float
	Field OldY:Float
	
	Field X:Float
	Field Y:Float
	Field D:Float
	Field S:Float
	
	Field AXS:Float
	Field AYS:Float
	
	Field Health:Float
	Field Mood:Int
	
	Field ID:Int
	
	Field Alive:Bool
	
	Method New(tLev:Level, tID:Int)
		level = tLev
		Alive = True
		ID = tID
	End
	
	Method FullUpdate:Void()
		OldX = X
		OldY = Y
		Update()
	End
	
	Method Update:Void()
	
	End
	
	Method FullRender:Void()
		
	End
	
	Method UpdateAdditionalForces:Void()
		X += (AXS * level.delta)
		Y += (AYS * level.delta)
		AXS *= (1 - (0.1 * level.delta))
		AYS *= (1 - (0.1 * level.delta))
	End
	
	Method CheckAgainstLevel:Void(Width:Float, Height:Float)
		If level.CollidesWith(X - (Width * 0.5), Y - (Height * 0.5), Width, Height)
			Local colLeft:Bool = level.CollidesWith(X - (Width * 0.5), Y - (Height * 0.25), 2, Height * 0.5)
			Local colRight:Bool = level.CollidesWith(X + (Width * 0.5) - 2, Y - (Height * 0.25), 2, Height * 0.5)
			Local colAbove:Bool = level.CollidesWith(X + (Width * 0.25), Y - (Height * 0.5), Width * 0.5, 2)
			Local colBelow:Bool = level.CollidesWith(X + (Width * 0.25), Y + (Height * 0.5) - 2, Width * 0.5, 2)
			
			If colLeft And Sin(D) < 0.0
				D = 180 + (180 - D)
				X = OldX
			EndIf
			
			If colRight And Sin(D) > 0.0
				D = 180 + (180 - D)
				X = OldX
			EndIf
			
			If colAbove And Cos(D) < 0.0
				D = 90 + (90 - D)
				Y = OldY
			EndIf
			
			If colBelow And Cos(D) > 0.0
				D = 90 + (90 - D)
				Y = OldY
			EndIf
			
			If D < 0.0 Then D += 360.0
			If D > 360.0 Then D -= 360.0
			
		End
	End
	
	Method AdditionalForce:Void(tXS:Float, tYS:Float)
		AXS += tXS
		AYS += tYS
	End
	

End