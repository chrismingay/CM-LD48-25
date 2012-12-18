Import ld

Class PostGameZombieScreen Extends Screen

	Field Congratulations:RazText
	Field Craps:Crap[]
	Const MAX_CRAP:Int = 400
	Field NextCrap:Int = 0
	Method New()
		Craps = New Crap[MAX_CRAP]
		For Local i:Int = 0 Until MAX_CRAP
			Craps[i] = New Crap()
		Next
	End
	
	Method OnScreenStart:Void()
		
		SFX.Music("cucaracha")
		
		Local tString:String = "NOOOOOO! :(~r~r"
		tString = tString + "The forces were not able to~rdefeat the zombie hordes~r~r"
		tString = tString + "Thanks Obama!"
		
		
		Congratulations = New RazText()
		Congratulations.AddMutliLines(tString)
		Congratulations.SetPos(10, 60)
		
		NextCrap = 0
		
	End
	
	Method Update:Void()
	
		If Controls.ActionHit Or Controls.EscapeHit
			ScreenManager.SetFadeRate(0.01)
			ScreenManager.ChangeScreen("title")
		EndIf
		
		For Local i:Int = 0 Until MAX_CRAP
			If Craps[i].Active = True
				Craps[i].Update()
			EndIf
		Next
		
		If Rnd() < 0.25
			AddCrap()
		EndIf
	
	End
	
	Method Render:Void()
		SetColor(255, 255, 255)
		DrawBackground()
		
		For Local i:Int = 0 Until MAX_CRAP
			If Craps[i].Active = True
				Craps[i].Render()
			EndIf
		Next
		
		GFX.Draw(0, 10, 0, 176, 360, 24, False)
		
		Congratulations.Draw()
	End
	
	Method AddCrap:Void()
		Craps[NextCrap].Activate()
		NextCrap += 1
		If NextCrap >= MAX_CRAP
			NextCrap = 0
		EndIf
	End
	
End

Class Crap
	Field X:Float
	Field Y:Float
	Field XS:Float
	Field YS:Float
	
	Field Active = False
	
	Field Frame:Int = 0
	
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
		
		Frame = Rnd(0.0, 10.0)
		
	End
	
	Method Update:Void()
	
		
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
		GFX.Draw(X, Y, 0 + (Frame * 8), 312, 8, 8, False)
		
	End
End