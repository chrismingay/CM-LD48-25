Import ld

Class GameScreen Extends Screen

	Field title:Image
	
	Method New()
		
	End

	Method OnScreenStart:Void()
		'level = GenerateLevel()
		SFX.Music("ruth")
		SFX.SetGlobalMusicVolume(1.0)
	End
	
	Method OnScreenEnd:Void()
		SFX.SetGlobalMusicVolume(1.0)
	End
	
	Method Update:Void()
		LDApp.level.Update()
		
		If Controls.EscapeHit
			ScreenManager.ChangeScreen("title")
		EndIf
		
	End
	
	Method Render:Void()
	
		LDApp.level.Render()
	
	End

End