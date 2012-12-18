Import ld

Class PostGameDrawScreen Extends Screen

	Field GeneralText:RazText

	Method New()
		GeneralText = New RazText()
		Local tString:String = "Err... not entirely sure how that happened~r~r"
		tString = tString + "to be honest I don't know why I added this page~r"
		tString = tString + "but there you go, you managed to draw~r"
		tString = tString + "a perfect balance of heroes and zombies.~r~r"
		tString = tString + "Very Well Done!"
		
		GeneralText.AddMutliLines(tString)
		GeneralText.SetPos(10, 60)
		
	End
	
	Method OnScreenStart:Void()
		SFX.Music("cucaracha")
	End
	
	Method Update:Void()
		If Controls.ActionHit or Controls.EscapeHit
			ScreenManager.ChangeScreen("title")
		EndIf
	End
	
	Method Render:Void()
		DrawBackground()
		GFX.Draw(0, 10, 0, 144, 360, 24, False)
		GeneralText.Draw()
	End
	
End