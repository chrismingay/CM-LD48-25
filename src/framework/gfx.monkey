Import ld

Class GFX

	Global Tileset:Image
	
	Function Init:Void()
		Tileset = LoadImage("gfx/sheet.png")
	End
	
	Function Draw:Void(tX:Float, tY:Float, X:Int, Y:Int, W:Int, H:Int, Follow:Bool = True)
		If Follow = True
			DrawImageRect(Tileset, Int(tX - LDApp.ScreenX), Int(tY - LDApp.ScreenY), X, Y, W, H)
		Else
			DrawImageRect(Tileset, tX, tY, X, Y, W, H)
		End
	End
	
	Function DL:Void(X1:Float, Y1:Float, X2:Float, Y2:Float)
		DrawLine(Int(X1 - LDApp.ScreenX), Int(Y1 - LDApp.ScreenY), Int(X2 - LDApp.ScreenX), Int(Y2 - LDApp.ScreenY))
	End

End

Function DrawBackground:Void()
	For Local x:Int = 0 Until LDApp.ScreenWidth Step 32
		For Local y:Int = 0 Until LDApp.ScreenHeight Step 32
			GFX.Draw(x, y, 32, 256, 32, 32, False)
		Next
	Next
End