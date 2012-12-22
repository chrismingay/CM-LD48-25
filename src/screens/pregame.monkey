Import ld

Class PreGameScreen Extends Screen

	Field TheWorld:RazText
	Field SaluteYou:RazText
	
	Field Timer:Int = 0

	Method New()
		
		TheWorld = New RazText("The fate of the world...")
		TheWorld.AddLine("rests in the hands of...")
		TheWorld.SetPos(10, 10)
	End
	
	Method OnScreenStart:Void()
		Timer = 0
		
		Randomize()
		
		SFX.Music("8bitbite")
	End
	
	Method Randomize:Void()
		LDApp.level = GenerateLevel()
		
		Local tString:String = ""
		Local cLineLength:Int = 0
		For Local i:Int = 0 Until LDApp.level.HeroCount
			Local tName:String[] = LDApp.level.Heroes[i].Name.OriginalString.Split(" ")
			tString = tString + tName[0] + ", "
			cLineLength += (tName[0].Length() +2)
			If cLineLength > 26
				' Print "yes!"
				tString = tString + "~r"
				cLineLength = 0
			EndIf
		Next
		
		tString = tString + "we salute you! ~r~r"
		
		tString = tString + "Press Enter to randomize the war"
		
		SaluteYou = New RazText()
		SaluteYou.AddMutliLines(tString)
	End
	
	Method Update:Void()
	
		Timer += 1
		' If Timer = 720 Or Controls.ActionHit
		If Controls.ActionHit
			ScreenManager.ChangeScreen("game")
		EndIf
		
		If Controls.Action2Hit
			Randomize()
		EndIf
		
		If Controls.EscapeHit
			ScreenManager.ChangeScreen("title")
		End
	End
	
	Method Render:Void()
		DrawBackground()
		TheWorld.Draw()
		
		Local tX:Int = 34
		Local tY:Int = 40
		
		For Local i:Int = 0 Until LDApp.level.HeroCount
			GFX.Draw(20, tY - 4, 16, 256, 16, 16, False)
			LDApp.level.Heroes[i].Name.Draw(tX, tY)
			tY += 12
		Next
		
		tY += 4
		
		SaluteYou.Draw(10, tY)
	End

End