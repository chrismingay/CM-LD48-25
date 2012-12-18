Import ld

Class Bullet

	Field level:Level
	
	Field X:Float
	Field Y:Float
	Field D:Float
	Field S:Float
	
	Const Width:Int = 4
	Const Height:Int = 4
	
	Field Active:Bool
	
	Method New(tLev:Level)
		level = tLev
		Active = False
	End
	
	Method Activate:Void(tX:Float, tY:Float, tD:Float)
		X = tX
		Y = tY
		D = tD
		S = 4.0
		Active = True
	End
	
	Method Deactive:Void()
		If Active = True
			Active = False
		End
	End
	
	Method Update:Void()
		X += Sin(D) * S * level.delta
		Y += Cos(D) * S * level.delta
		
		For Local i:Int = 0 Until level.ZombieCount
			If level.Zombies[i].Alive = True
				If RectOverRect(X, Y, Width, Height, level.Zombies[i].X, level.Zombies[i].Y, Zombie.Width, Zombie.Height)
				
					level.Zombies[i].ReactToBullet(Self)
					
				
					Deactive()
					
				End
			EndIf
		Next
		
		If level.CollidesWith(X - (Width * 0.5), Y - (Height * 0.5), Width, Height)
			Deactive()
		EndIf
		
		
		
		
	End
	
	Method Render:Void()
		GFX.Draw(X - 2, Y - 2, 0, 400, 4, 4)
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5), Y - (Width * 0.5), Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End

End