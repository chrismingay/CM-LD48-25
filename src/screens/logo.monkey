Import ld

Class LogoScreen Extends Screen

	Field LogoText:RazText
	
	Field Timer:Int = 0
	Const TimerTarget:Int = 300
	
	Method OnScreenStart:Void()
		Timer = 0
	End

	Method New()
		LogoText = New RazText()
		LogoText.AddMutliLines(LoadString("txt/logo.txt"))
	End
	
	Method Render:Void()
		Cls(28, 0, 113)
		LogoText.Draw(0, 0)
	End
	
	Method Update:Void()
		If KeyHit(KEY_SPACE) Or Timer >= TimerTarget
			ScreenManager.ChangeScreen("title")
		EndIf
		
		Timer += 1
	End

End