Import ld

Class HowToScreen Extends Screen

	Field GuideText:RazText
	
	
	Method OnScreenStart:Void()
		
	End

	Method New()
		GuideText = New RazText()
		GuideText.AddMutliLines(LoadString("txt/guide.txt"))
	End
	
	Method Render:Void()
		DrawBackground()
		GuideText.Draw(0, 0)
	End
	
	Method Update:Void()
		If Controls.ActionHit Or Controls.EscapeHit
			ScreenManager.ChangeScreen("title")
		EndIf
	End

End