Import ld

Class TitleScreen Extends Screen

	Field title:Image

	Field ButPlay:RazText
	Field ButHow:RazText
	Field ButCredits:RazText
	Field ButQuit:RazText
	
	Field URL:RazText
	
	Field ActiveButton:Int = 0
	
	Field OffSet:Int = 0
	Field OffsetTimer:Int = 0
	
	Method OnScreenStart:Void()
		ActiveButton = 0
		SFX.Music("jovial")
		ScreenManager.SetFadeRate(0.1)
	End
	
	Method New()
	
		title = LoadImage("gfx/title.png", 1, Image.MidHandle)
	
		ButPlay = New RazText("Play")
		ButPlay.SetPos(100, 100)
		
		ButHow = New RazText("How To")
		ButHow.SetPos(100, 116)
		
		ButCredits = New RazText("Credits")
		ButCredits.SetPos(100, 132)
		
		ButQuit = New RazText("Quit")
		ButQuit.SetPos(100, 148)
		
		URL = New RazText("chrismingay.co.uk")
		URL.SetPos(2, LDApp.ScreenHeight - 12)
	End
	
	Method Update:Void()
	
		Local t:Int = Rnd()
	
		If Controls.DownHit
			ActiveButton += 1
			If ActiveButton = 4
				ActiveButton = 0
			EndIf
			
			SFX.Play("Click")
		EndIf
		
		If Controls.UpHit
			ActiveButton -= 1
			If ActiveButton = -1
				ActiveButton = 3
			EndIf
			
			SFX.Play("Click")
		EndIf
		
		If Controls.ActionHit
			Select ActiveButton
				Case 0
					ScreenManager.ChangeScreen("pregame")
					
				Case 1
					ScreenManager.ChangeScreen("howto")
				Case 2
					ScreenManager.ChangeScreen("credits")
				Case 3
					ScreenManager.ChangeScreen("exit")
			End
			SFX.Play("Select")
		EndIf
		
		If OffsetTimer = 7
			OffSet += 1
			If OffSet = 4
				OffSet = 0
			EndIf
			OffsetTimer = 0
		Else
			OffsetTimer += 1
		End
	End
	
	Method Render:Void()
	
		DrawBackground()
		
		Local tOff:Int
		Select OffSet
			Case 0
				tOff = 0
			Case 1, 3
				tOff = 2
			Case 2
				tOff = 3
		End
		
		DrawImage(title, LDApp.ScreenWidth * 0.5, 30 - tOff)
		
		ButPlay.Draw()
		ButHow.Draw()
		ButCredits.Draw()
		ButQuit.Draw()
		URL.Draw()
		
		GFX.Draw(84, 96 + (ActiveButton * 16), 16, 256, 16, 16, False)
		
		GFX.Draw(LDApp.ScreenWidth - 58, LDApp.ScreenHeight - 24, 64, 256, 64, 20, False)
		
		
	
	End

End