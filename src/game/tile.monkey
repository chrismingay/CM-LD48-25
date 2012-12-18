Import ld

Class Tile
	
	Const WIDTH:Int = 16
	Const HEIGHT:Int = 16
	
	Field X:Float
	Field Y:Float
	
	Const STANDARD:Int = 1
	Const FLAGGED:Int = 0
	
	Const ITEM_BELOW:Int = 1
	Const ITEM_ABOVE:Int = 2
	Const ITEM_LEFT:Int = 4
	Const ITEM_RIGHT:Int = 8
	
	Field AniFrame:Int
	
	Field Obstacle:Bool
	
	Method New(tX:Float, tY:Float)
		X = tX
		Y = tY
		AniFrame = STANDARD
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X, Y, WIDTH, HEIGHT, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End
	
	Method Render:Void()
		'If Obstacle = False
		'	SetColor(200, 200, 200)
		'Else
		'	SetColor(64, 64, 64)
		'EndIf
		'DrawRect(X - LDApp.ScreenX, Y - LDApp.ScreenY, Tile.WIDTH, Tile.HEIGHT)
		SetColor(255, 255, 255)
		GFX.Draw(X, Y, 0, 480, 16, 16)
		If Obstacle
			GFX.Draw(X, Y, (AniFrame * 16), 464, 16, 16)
		Else
			
		EndIf
		
	End
End