Import ld

Class Controls
	
	Global LeftKey:Int = KEY_A
	Global RightKey:Int = KEY_D
	Global UpKey:Int = KEY_W
	Global DownKey:Int = KEY_S
	Global ActionKey:Int = KEY_SPACE
	Global EscapeKey:Int = KEY_ESCAPE
	
	Global LeftHit:Bool
	Global RightHit:Bool
	Global UpHit:Bool
	Global DownHit:Bool
	
	Global LeftDown:Bool
	Global RightDown:Bool
	Global UpDown:Bool
	Global DownDown:Bool
	
	Global ActionHit:Bool
	Global ActionDown:Bool
	
	Global EscapeHit:Bool
	Global EscapeDown:Bool
	
	Function Update:Void()
	
		LeftHit = False
		RightHit = False
		DownHit = False
		UpHit = False
		ActionHit = False
		EscapeHit = False
		
		If KeyDown(LeftKey)
			If LeftDown = False
				LeftHit = True
			EndIf
			LeftDown = True
		Else
			LeftDown = False
		End
		
		If KeyDown(RightKey)
			If RightDown = False
				RightHit = True
			EndIf
			RightDown = True
		Else
			RightDown = False
		End
		
		If KeyDown(UpKey)
			If UpDown = False
				UpHit = True
			EndIf
			UpDown = True
		Else
			UpDown = False
		End
		
		If KeyDown(DownKey)
			If DownDown = False
				DownHit = True
			EndIf
			DownDown = True
		Else
			DownDown = False
		End
		
		If KeyDown(ActionKey)
			If ActionDown = False
				ActionHit = True
			EndIf
			ActionDown = True
		Else
			ActionDown = False
		End
		
		If KeyDown(EscapeKey)
			If EscapeDown = False
				EscapeHit = True
			EndIf
			EscapeDown = True
		Else
			EscapeDown = False
		End
	
	
	End

End