Import ld

Class CreditsScreen Extends Screen

	Field CreditText:RazText

	Method New()
		CreditText = New RazText()
		CreditText.AddMutliLines(LoadString("txt/credits.txt"))
	End
	
	Method Render:Void()
		DrawBackground()
		CreditText.Draw(10, 10)
	End
	
	Method Update:Void()
	
		If Controls.ActionHit Or Controls.EscapeHit
			ScreenManager.ChangeScreen("credits2")
		EndIf
	End

End