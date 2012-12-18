Import ld

Class Credits2Screen Extends Screen

	Field CreditText:RazText

	Method New()
		CreditText = New RazText()
		CreditText.AddMutliLines(LoadString("txt/credits2.txt"))
	End
	
	Method Render:Void()
		DrawBackground()
		CreditText.Draw(10, 10)
	End
	
	Method Update:Void()
	
		If Controls.ActionHit Or Controls.EscapeHit
			ScreenManager.ChangeScreen("title")
		EndIf
	End

End