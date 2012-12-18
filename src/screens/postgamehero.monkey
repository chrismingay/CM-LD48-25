Import ld

Class PostGameHeroScreen Extends Screen

	Field Congratulations:RazText
	
	Const MAX_CONFETS:Int = 400
	Field NextConfet:Int = 0
	Field Confets:Confet[]
	
	Method New()
		Confets = New Confet[MAX_CONFETS]
		For Local i:Int = 0 Until MAX_CONFETS
			Confets[i] = New Confet()
		Next
	End
	
	Method OnScreenStart:Void()
		NextConfet = 0
		SFX.Music("notre")
		
		Local tString:String = "YAY!~r~r"
		tString = tString + "The courageous heroes have saved the world!~r~r"
		
		Local tAlive:String = ""
		Local tDead:String = ""
		
		Local deathCount:Int = 0
		Local aliveCount:Int = 0
		
		Local currentLineAlive:Int = 0
		Local currentLineDead:Int = 0
		
		For Local i:Int = 0 Until LDApp.level.HeroCount
			Local tName:String[] = LDApp.level.Heroes[i].Name.OriginalString.Split(" ")
			If LDApp.level.Heroes[i].Alive = True
				tAlive = tAlive + tName[0] + ", "
				aliveCount += 1
				currentLineAlive += (tName[0].Length + 2)
				If currentLineAlive > 26
					tAlive = tAlive + "~r"
					currentLineAlive = 0
				EndIf
			Else
				deathCount += 1
				tDead = tDead + tName[0] + ", "
				currentLineDead += (tName[0].Length + 2)
				If currentLineDead > 26
					tDead = tDead + "~r"
					currentLineDead = 0
				EndIf
			EndIf
		Next
		
		If aliveCount = 1
			tString = tString + tAlive + "was the only survivor.~r~r"
		Else
			tString = tString + tAlive + "were the " + aliveCount + " survivors.~r~r"
		EndIf
		
		If deathCount = 0
			tString = tString + " and we had no casualties!~r~r"
			tString = tString + "Man, those were some dumb zombies!"
		ElseIf deathCount = 1
			tString = tString + tDead + "was the only casualty. R.I.P~r~r"
		Else
			tString = tString + tDead + "were the " + deathCount + " casulaties.~n R.I.P~r~r"
		EndIf
		
		Congratulations = New RazText()
		Congratulations.AddMutliLines(tString)
		Congratulations.SetPos(10, 60)
		
		
		
	End
	
	Method Update:Void()
	
		If Controls.ActionHit Or Controls.EscapeHit
			ScreenManager.SetFadeRate(0.01)
			ScreenManager.ChangeScreen("title")
		EndIf
	
		For Local i:Int = 0 Until MAX_CONFETS
			If Confets[i].Active = True
				Confets[i].Update()
			EndIf
		Next
		
		If Rnd() < 0.25
			AddConfet()
		EndIf
	End
	
	Method Render:Void()
		SetColor(255, 255, 255)
		DrawBackground()
		GFX.Draw(0, 10, 0, 200, 360, 24, False)
		Congratulations.Draw()
		For Local i:Int = 0 Until MAX_CONFETS
			If Confets[i].Active = True
				Confets[i].Render()
			EndIf
		Next
	End
	
	Method AddConfet:Void()
		Confets[NextConfet].Activate()
		NextConfet += 1
		If NextConfet >= MAX_CONFETS
			NextConfet = 0
		EndIf
	End
	
End

Class Confet
	Field X:Float
	Field Y:Float
	Field XS:Float
	Field YS:Float
	
	Field Active = False
	
	Field Frame:Int = 0
	Field FrameOffset:Int = 0
	Const FrameDelay:Int = 15
	Field FrameDelayTimer:Int = 0
	
	Method Activate:Void()
		If Rnd() < 0.5
			X = Rnd(0 - 50, LDApp.ScreenWidth)
			Y = 0 - 10
		Else
			X = 0 - 10
			Y = Rnd(0 - 50, LDApp.ScreenHeight)
		End
		
		XS = Rnd(0.2, 1.0)
		YS = Rnd(0.2, 0.4)
		
		Active = True
		
		Frame = 0
		FrameOffset = Rnd(0.0, 5.0)
		
	End
	
	Method Update:Void()
	
		FrameDelayTimer += 1
		If FrameDelayTimer >= FrameDelay
			Frame += 1
			If Frame = 2
				Frame = 0
			EndIf
			FrameDelayTimer = 0
		EndIf
		
	
		XS += Rnd(-0.01, 0.01)
		
		X += XS
		Y += YS
		
		If X > LDApp.ScreenWidth + 50
			Active = False
		EndIf
		
		If Y > LDApp.ScreenHeight + 50
			Active = False
		EndIf
		
	End
	
	Method Render:Void()
		GFX.Draw(X, Y, 0 + ( ( (FrameOffset * 2) + Frame) * 8), 304, 4, 4, False)
		
	End
End