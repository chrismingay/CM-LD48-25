Import ld

Class Level

	Const MIN_WIDTH:Int = 23
	Const MIN_HEIGHT:Int = 23
	
	Const MAX_WIDTH:Int = 80
	Const MAX_HEIGHT:Int = 80
	
	Const MAX_HEROES:Int = 10
	Const MIN_HEROES:Int = 2
	
	Const MAX_BULLETS:Int = 200
	Field NextBullet:Int = 0
	
	Const MAX_GIBS:Int = 50
	Field NextGib:Int = 0
	
	Const MAX_BLOODS:Int = 200
	Field NextBlood:Int = 0
	
	Field Width:Int
	Field Height:Int
	Field Tiles:Tile[][]
	
	Field HeroCount:Int
	Field ZombieCount:Int
	Field AliveZombies:Int
	Field AliveHeroes:Int
	
	Const PLAYING:Int = 0
	Const HEROES_WON:Int = 1
	Const ZOMBIES_WON:Int = 2
	Const WAR_DRAWN:Int = 3
	Field GameStatus:Int
	
	Field TransitionTimer:Int = 0
	
	Field Heroes:Hero[]
	Field Zombies:Zombie[]
	Field Bullets:Bullet[]
	Field Gibs:Gib[]
	Field Bloods:Blood[]
	Field MortarLaunchers:MortarLauncher[]
	Field Mortars:Mortar[]
	
	Field NextMortar:Int = 0
	
	Const MAX_MORTARS:Int = 20
	Field MortarLauncherCount:Int
	
	Field controlledZombie:Int
	
	Field safezone:SafeZone
	
	Field delta:Float = 1.0
	
	Method New()
		GameStatus = PLAYING
		TransitionTimer = 0
	End
	
	Method InitTiles:Void()
		Tiles = New Tile[Width][]
		For Local x:Int = 0 Until Width
			Tiles[x] = New Tile[Height]
			For Local y:Int = 0 Until Height
				Tiles[x][y] = New Tile(x * Tile.WIDTH, y * Tile.HEIGHT)
			Next
		Next
	End
	
	Method InitHeroes:Void()
		Heroes = New Hero[HeroCount]
		For Local i:Int = 0 Until HeroCount
			Heroes[i] = New Hero(Self, i)
			Heroes[i].Name = New RazText(NameGenerator.Generate(Rnd(0.0, 2.0)))
		Next
		
		AliveHeroes = HeroCount
	End
	
	Method InitZombies:Void()
		Zombies = New Zombie[ZombieCount]
		For Local i:Int = 0 Until ZombieCount
			Zombies[i] = New Zombie(Self, i)
		Next
		AliveZombies = ZombieCount
	End
	
	Method InitBullets:Void()
		Bullets = New Bullet[MAX_BULLETS]
		For Local i:Int = 0 Until MAX_BULLETS
			Bullets[i] = New Bullet(Self)
		Next
	End
	
	Method InitGibs:Void()
		Gibs = New Gib[MAX_GIBS]
		For Local i:Int = 0 Until MAX_GIBS
			Gibs[i] = New Gib(Self)
		Next
	End
	
	Method InitBlood:Void()
		Bloods = New Blood[MAX_BLOODS]
		For Local i:Int = 0 Until MAX_BLOODS
			Bloods[i] = New Blood(Self)
		Next
	End
	
	Method InitMortarLaunchers:Void()
		MortarLaunchers = New MortarLauncher[MortarLauncherCount]
		For Local i:Int = 0 Until MortarLauncherCount
			MortarLaunchers[i] = New MortarLauncher(Self)
		Next
	End
	
	Method InitMortars:Void()
		Mortars = New Mortar[MAX_MORTARS]
		For Local i:Int = 0 Until MAX_MORTARS
			Mortars[i] = New Mortar(Self)
		Next
		NextMortar = 0
	End
	
	Method SubUpdate:Void()
	
		If Zombies[controlledZombie].Alive = True
			LDApp.ScreenX = Zombies[controlledZombie].X - (LDApp.ScreenWidth * 0.5)
			LDApp.ScreenY = Zombies[controlledZombie].Y - (LDApp.ScreenHeight * 0.5)
		Else
			If Controls.LeftDown
				LDApp.ScreenX -= 4
			EndIf
			If Controls.RightDown
				LDApp.ScreenX += 4
			EndIf
			If Controls.UpDown
				LDApp.ScreenY -= 4
			EndIf
			If Controls.DownDown
				LDApp.ScreenY += 4
			EndIf
		End
		
		LDApp.ScreenX = Clamp(LDApp.ScreenX, 0, (Width * Tile.WIDTH) - LDApp.ScreenWidth)
		LDApp.ScreenY = Clamp(LDApp.ScreenY, 0, (Height * Tile.HEIGHT) - LDApp.ScreenHeight)
		
		If GameStatus = Level.PLAYING
			If AliveZombies = 0 And AliveHeroes = 0
				GameStatus = Level.WAR_DRAWN
			EndIf
			If AliveZombies = 0 And AliveHeroes > 0
				GameStatus = Level.HEROES_WON
			EndIf
			If AliveZombies > 0 And AliveHeroes = 0
				GameStatus = Level.ZOMBIES_WON
			EndIf
		Else
			If TransitionTimer < 360
				TransitionTimer += 1
			ElseIf TransitionTimer = 360
				TransitionTimer += 1
				Select GameStatus
					Case Level.HEROES_WON
						ScreenManager.ChangeScreen("postgamehero")
					Case Level.ZOMBIES_WON
						ScreenManager.ChangeScreen("postgamezombie")
					Case Level.WAR_DRAWN
						ScreenManager.ChangeScreen("postgamedraw")
				End
			End
		EndIf
		
		UpdateHeroes()
		UpdateZombies()
		UpdateBullets()
		UpdateGibs()
		UpdateBloods()
		UpdateMortarLaunchers()
		UpdateMortars()
	End
	
	Method Update:Void()
	
		SubUpdate()
		If Zombies[controlledZombie].Alive = False And Controls.ActionDown And GameStatus = PLAYING
			SubUpdate()
			SubUpdate()
			' SubUpdate()
		EndIf
		
		
		If KeyHit(KEY_ENTER)
			If delta = 1.0
				delta = 0.25
			Else
				delta = 1.0
			EndIf
		EndIf
	End
	
	Method UpdateHeroes:Void()
		For Local i:Int = 0 Until HeroCount
			Heroes[i].FullUpdate()
		Next
	End
	
	Method UpdateZombies:Void()
		For Local i:Int = 0 Until ZombieCount
			Zombies[i].FullUpdate()
		Next
	End
	
	Method UpdateBullets:Void()
		For Local i:Int = 0 Until MAX_BULLETS
			If Bullets[i].Active = True
				Bullets[i].Update()
			EndIf
		Next
	End
	
	Method UpdateGibs:Void()
		For Local i:Int = 0 Until MAX_GIBS
			If Gibs[i].Active = True
				Gibs[i].Update()
			EndIf
		Next
	End
	
	Method UpdateBloods:Void()
		For Local i:Int = 0 Until MAX_BLOODS
			If Bloods[i].Active = True
				Bloods[i].Update()
			EndIf
		Next
	End
	
	Method UpdateMortarLaunchers:Void()
		For Local i:Int = 0 Until MortarLauncherCount
			If MortarLaunchers[i].Active = True
				MortarLaunchers[i].Update()
			EndIf
		Next
	End
	
	Method UpdateMortars:Void()
		For Local i:Int = 0 Until MAX_MORTARS
			If Mortars[i].Active = True
				Mortars[i].Update()
			EndIf
		Next
	End
	
	Method Render:Void()
		RenderTiles()
		safezone.Render()
		RenderZombies(False)
		RenderHeroes(False)
		RenderMortarLaunchers()
		RenderHeroes()
		RenderBullets()
		RenderZombies()
		RenderMortars()
		RenderBloods()
		RenderGibs()
		RenderGUI()
		
		If Zombies[controlledZombie].Alive = False And GameStatus = PLAYING
			If Controls.ActionDown
				GFX.Draw(342, 2, 128, 256, 16, 8, False)
			Else
				GFX.Draw(318, 2, 128, 272, 48, 16, False)
			End
		EndIf
		
		Select GameStatus
			Case Level.HEROES_WON
				GFX.Draw(0, 100, 0, 200, 360, 24, False)
			Case Level.ZOMBIES_WON
				GFX.Draw(0, 100, 0, 176, 360, 24, False)
			Case Level.WAR_DRAWN
				GFX.Draw(0, 100, 0, 144, 360, 24, False)
		End
		
		
		
	End
	
	Method RenderTiles:Void()
		SetAlpha(1.0)
		For Local x:Int = 0 Until Width
			For Local y:Int = 0 Until Height
				If Tiles[x][y].IsOnScreen()
					Tiles[x][y].Render()
				End
			Next
		Next
	End
	
	Method RenderZombies:Void(tAlive:Bool = True)
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until ZombieCount
			If i <> controlledZombie
				If Zombies[i].IsOnScreen()
					If Zombies[i].Alive = tAlive
						Zombies[i].Render()
					EndIf
				End
			EndIf
		Next
		
		Zombies[controlledZombie].Render()
	End
	
	Method RenderHeroes:Void(tALive:Bool = True)
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until HeroCount
			If Heroes[i].IsOnScreen()
				If Heroes[i].Alive = tALive
					'If Heroes[i].lastSeenByPlayer > Millisecs() -2000 Or Zombies[controlledZombie].Alive = False Or Heroes[i].Alive = False
						Heroes[i].Render()
					'EndIf
				EndIf
			EndIf
		Next
	End
	
	Method RenderBullets:Void()
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until MAX_BULLETS
			If Bullets[i].Active = True
				If Bullets[i].IsOnScreen()
					Bullets[i].Render()
				EndIf
			EndIf
		Next
	End
	
	Method RenderGibs:Void()
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until MAX_GIBS
			If Gibs[i].Active = True
				If Gibs[i].IsOnScreen()
					Gibs[i].Render()
				EndIf
			EndIf
		Next
	End
	
	Method RenderMortars:Void()
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until MAX_MORTARS
			If Mortars[i].Active = True
				If Mortars[i].IsOnScreen()
					Mortars[i].Render()
				EndIf
			EndIf
		Next
	End
	
	Method RenderMortarLaunchers:Void()
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until MortarLauncherCount
			If MortarLaunchers[i].Active = True
				If MortarLaunchers[i].IsOnScreen()
					MortarLaunchers[i].Render()
				EndIf
			EndIf
		Next
	End
	
	Method RenderBloods:Void()
		SetAlpha(1.0)
		SetColor(255, 255, 255)
		For Local i:Int = 0 Until MAX_BLOODS
			If Bloods[i].Active = True
				If Bloods[i].IsOnScreen()
					Bloods[i].Render()
				EndIf
			EndIf
		Next
	End
	
	Method RenderGUI:Void()
		SetColor(255, 255, 255)
		SetAlpha(1.0)
		GFX.Draw(0, 240 - 24, 0, 232, 360, 24, False)
		
		' Draw Health
		If Zombies[controlledZombie].Health > 0
			GFX.Draw(32, 240 - 6, 32, 228, Zombies[controlledZombie].Health + 2, 3, False)
		End
		
		' DRAW THE HERO BASED GUI ITEMS
		Local StartY:Int = 240 - 24
		
		For Local i:Int = 0 Until HeroCount
			GFX.Draw(0, StartY - (i * 8), 0, 256, 8, 8, False)
			If Heroes[i].Alive = False
				GFX.Draw(0, StartY - (i * 8), 8, 256, 8, 8, False)
			Else
				GFX.Draw(8, StartY - (i * 8), 0, 264, 8, 8, False)
				GFX.Draw(8, StartY - (i * 8), 8, 264, (8.0 * (Heroes[i].Health / 100.0)), 4, False)
				GFX.Draw(8, StartY - (i * 8) + 4, 8, 268, (8.0 * (Float(Heroes[i].Ammo) / Float(Hero.MAX_AMMO))), 4, False)
				'DrawText( (8.0 * (Float(Heroes[i].Ammo) / Float(Hero.MAX_AMMO))), 16, StartY - (i * 16))
				'DrawText( 8.0 * (Heroes[i].Health / 100.0), 32, StartY - (i * 16))
				
				
			End
			
		Next
		
		
		'DRAW THE ZOMBIE BASED GUI ITEMS
		Local cY:Int = 240 - 20
		Local FullLines:Int = (AliveZombies - (AliveZombies Mod 5)) / 5
		Local Partial:Int = AliveZombies Mod 5
		For Local i:Int = 0 Until FullLines
			GFX.Draw(LDApp.ScreenWidth - 17, cY, 0, 272, 16, 4, False)
			cY -= 3
		Next
		
		If Partial > 0
			GFX.Draw(LDApp.ScreenWidth - 17, cY, 0, 272, (Partial * 3) + 1, 4, False)
		EndIf
		
		' DRAW ACTION GUI STUFF
		Local hX:Int = 248
		Local hY:Int = 216
		
		Local stepX:Int = 24
		
		GFX.Draw(hX + (Zombies[controlledZombie].CurrentAction * stepX), hY, 248, 224, 12, 8, False)
		
		hX = 254
		hY = 220
		
		GFX.Draw(hX, hY, 0 + (Zombies[controlledZombie].Action1 * 16), 320, 16, 16, False)
		'Print(0 + (Zombies[controlledZombie].Action1 * 16))
		hX += 24
		GFX.Draw(hX, hY, 0 + (Zombies[controlledZombie].Action2 * 16), 320, 16, 16, False)
		hX += 24
		GFX.Draw(hX, hY, 0 + (Zombies[controlledZombie].Action2 * 16), 320, 16, 16, False)
		
		' DrawText(AliveZombies,320-17,cY - 16)
		
	End
	
	Method UpdateTileFrames:Void()
		For Local x:Int = 0 Until Width
			For Local y:Int = 0 Until Height
			
				If Tiles[x][y].Obstacle = True And Tiles[x][y].AniFrame <> Tile.FLAGGED
			
					Local Left:Int = 0
					Local Right:Int = 0
					Local Above:Int = 0
					Local Below:Int = 0
					
					If y = 0
						Above = Tile.ITEM_ABOVE
					Else
						If Tiles[x][y - 1].Obstacle = True And Tiles[x][y - 1].AniFrame <> Tile.FLAGGED
							Above = Tile.ITEM_ABOVE
						End
					End
					
					If y = Height - 1
						Below = Tile.ITEM_BELOW
					Else
						If Tiles[x][y + 1].Obstacle = True And Tiles[x][y + 1].AniFrame <> Tile.FLAGGED
							Below = Tile.ITEM_BELOW
						End
					EndIf
					
					If x = 0
						Left = Tile.ITEM_LEFT
					Else
						If Tiles[x - 1][y].Obstacle = True And Tiles[x - 1][y].AniFrame <> Tile.FLAGGED
							Left = Tile.ITEM_LEFT
						End
					EndIf
					
					If x = Width - 1
						Right = Tile.ITEM_RIGHT
					Else
						If Tiles[x + 1][y].Obstacle = True And Tiles[x + 1][y].AniFrame <> Tile.FLAGGED
							Right = Tile.ITEM_RIGHT
						End
					EndIf
					
					Tiles[x][y].AniFrame = 1 + (Left + Right + Above + Below)
				
				End
				
			Next
		Next
	End
	
	Method CollidesWith:Bool(X:Float, Y:Float, W:Float, H:Float)
		Local cX1:Int = (X - (X Mod Tile.WIDTH)) / Tile.WIDTH
		Local cY1:Int = (Y - (Y Mod Tile.HEIGHT)) / Tile.HEIGHT
		Local cX2:Int = ( (X + W) - ( (X + W) Mod Tile.WIDTH)) / Tile.WIDTH
		Local cY2:Int = ( (Y + H) - ( (Y + H) Mod Tile.HEIGHT)) / Tile.HEIGHT
		
		For Local x:Int = cX1 To cX2
			For Local y:Int = cY1 To cY2
				If Tiles[x][y].Obstacle = True
					If RectOverRect(X, Y, W, H, x * Tile.WIDTH, y * Tile.HEIGHT, Tile.WIDTH, Tile.HEIGHT)
						Return True
					End
				EndIf
			Next
		Next
		
		Return False
	End
	
	Method ActivateBullet:Void(tX:Float, tY:Float, tD:Float)
		Local done:Bool = False
		While done = False
			'If Bullets[NextBullet].Active = False
				Bullets[NextBullet].Activate(tX, tY, tD)
				done = True
			'EndIf
			NextBullet += 1
			If NextBullet = MAX_BULLETS
				NextBullet = 0
			EndIf
		Wend
	End
	
	Method ActivateBlood:Void(tX:Float, tY:Float, tZ:Float)
		Local done:Bool = False
		
		
		While done = False
			'If Bloods[NextBlood].Active = False
				Bloods[NextBlood].Activate(tX, tY, tZ)
				done = True
			'EndIf
			NextBlood += 1
			If NextBlood = MAX_BLOODS
				NextBlood = 0
			EndIf
		Wend
	End
	
	Method ActivateGib:Void(tX:Float, tY:Float)
		Local done:Bool = False
		While done = False
			'If Gibs[NextGib].Active = False
				Gibs[NextGib].Activate(tX, tY)
				done = True
			'EndIf
			NextGib += 1
			If NextGib = MAX_GIBS
				NextGib = 0
			EndIf
		Wend
	End
	
	Method ActivateMortar:Void(tX:Float, tY:Float)
		Local done:Bool = False
		While done = False
			'If Gibs[NextGib].Active = False
				Mortars[NextMortar].Activate(tX, tY)
				done = True
			'EndIf
			NextMortar += 1
			If NextMortar = MAX_MORTARS
				NextMortar = 0
			EndIf
		Wend
	End
	
	Method CheckLineOfSight:Bool(X1:Int, Y1:Int, X2:Int, Y2:Int)
	
		Local CX:Float = X1
		Local CY:Float = Y1
		
		Local CStep:Float = 8
		Local D:Float = DirectionBetweenPoints(X1, Y1, X2, Y2)
		
		Local XStep:Float = Sin(D) * CStep
		Local YStep:Float = Cos(D) * CStep
		
		
		Local LastCheckedX:Int = - 1
		Local lastCheckedY:Int = - 1
		
		While DistanceBetweenPoints(CX, CY, X2, Y2) > CStep
		
			
			
			Local TileX:Int = (CX - (CX Mod Tile.WIDTH)) / Tile.WIDTH
			Local TileY:Int = (CY - (CY Mod Tile.HEIGHT)) / Tile.HEIGHT
			
			If TileX <> LastCheckedX Or TileY <> lastCheckedY
				
				If PointInRect(TileX, TileY, 0, 0, Width, Height)
					If Tiles[TileX][TileY].Obstacle = True
						Return False
					EndIf
				Else
					Return False
				End
				
				LastCheckedX = TileX
				lastCheckedY = TileY
			
			EndIf
			
			CX += XStep
			CY += YStep
			
		Wend
		
		Return True
	
	
	End
	
	Method AlertNearbyZombies:Void(tX:Float, tY:Float, tZ:Int, tH:Int)
		For Local i:Int = 0 Until ZombieCount
			If i <> tZ
				If Zombies[i].Alive = True
					If Zombies[i].Controlled = False
						If Zombies[i].Mood = ZombieMood.WANDERING
							If DistanceBetweenPoints(tX, tY, Zombies[i].X, Zombies[i].Y) < 100
								Zombies[i].GoForHero(tH)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	End
	
	Method CallToArms:Void(tX:Float, tY:Float, tZ:Int)
		For Local i:Int = 0 Until ZombieCount
			If i <> tZ
				If Zombies[i].Alive = True
					If Zombies[i].Controlled = False
						If Zombies[i].Mood = ZombieMood.WANDERING
							If DistanceBetweenPoints(tX, tY, Zombies[i].X, Zombies[i].Y) < 100
								Zombies[i].GoForZombie(tZ)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	End
	
	Method Explosion:Void(tX:Float, tY:Float, tPower:Float)
		SFX.Play("ZombieExplode", SFX.VolumeFromPosition(tX, tY), SFX.PanFromPosition(tX, tY), Rnd(0.9, 1.1))
	End
	
End

Function GenerateLevel:Level(tSeed:Int = 19132006)

	If tSeed <> 19132006
		Seed = tSeed
	End
	
	'' Print "Generating for seed " + Seed

	Local tLev:Level = New Level()
	Local Width:Int = Rnd(Level.MIN_WIDTH, Level.MAX_WIDTH)
	Local Height:Int = Rnd(Level.MIN_HEIGHT, Level.MAX_HEIGHT)
	tLev.Width = Width
	tLev.Height = Height
	
	tLev.GameStatus = Level.PLAYING
	
	tLev.InitBlood()
	tLev.InitBullets()
	tLev.InitGibs()
	
	tLev.InitTiles()
	
	For Local x:Int = 0 Until Width
		tLev.Tiles[x][0].Obstacle = True
		tLev.Tiles[x][Height - 1].Obstacle = True
	Next
	
	For Local y:Int = 0 Until Height
		tLev.Tiles[0][y].Obstacle = True
		tLev.Tiles[Width - 1][y].Obstacle = True
	Next
	
	' TODO - GENERATE SAFE ZONE
	Local safeZoneReady:Bool = False
	Local sZW:Int = 8
	Local sZH:Int = 5
	
	Local sZX:Int
	Local sZY:Int
	
	While safeZoneReady = False
		Local tX:Float = Int(Rnd(2, Width - 2 - sZW))
		Local tY:Float = Int(Rnd(2, Height - 2 - sZH))
		
		'Local tX:Float = 5
		'Local tY:Float = 5
		
		' Generate the actual SafeZone
		tLev.safezone = New SafeZone()
		tLev.safezone.X = tX * Tile.WIDTH
		tLev.safezone.Y = tY * Tile.HEIGHT
		tLev.safezone.W = sZW * Tile.WIDTH
		tLev.safezone.H = sZH * Tile.HEIGHT
		
		' Generate the borders surrounding it
		tLev.Tiles[tX - 1][tY - 1].Obstacle = True
		tLev.Tiles[tX - 1][tY - 1].AniFrame = Tile.FLAGGED
		tLev.Tiles[tX][tY - 1].Obstacle = True
		tLev.Tiles[tX - 1][tY].Obstacle = True
		
		tLev.Tiles[tX + sZW - 1][tY - 1].Obstacle = True
		tLev.Tiles[tX + sZW][tY - 1].Obstacle = True
		tLev.Tiles[tX + sZW][tY - 1].AniFrame = Tile.FLAGGED
		tLev.Tiles[tX + sZW][tY].Obstacle = True
		
		tLev.Tiles[tX - 1][tY + sZH - 1].Obstacle = True
		tLev.Tiles[tX - 1][tY + sZH].Obstacle = True
		tLev.Tiles[tX - 1][tY + sZH].AniFrame = Tile.FLAGGED
		tLev.Tiles[tX][tY + sZH].Obstacle = True
		
		tLev.Tiles[tX + sZW - 1][tY + sZH].Obstacle = True
		tLev.Tiles[tX + sZW][tY + sZH].Obstacle = True
		tLev.Tiles[tX + sZW][tY + sZH].AniFrame = Tile.FLAGGED
		tLev.Tiles[tX + sZW][tY + sZH - 1].Obstacle = True
		
		sZX = tX
		sZY = tY
		
		safeZoneReady = True
		
	Wend
	
	' TODO - GENERATE LEVEL FORMATION
	Local tilesGenMin:Int = (tLev.Width * tLev.Height * 0.05)
	Local tilesGenMax:Int = (tLev.Width * tLev.Height * 0.1) + 1
	Local tilesToGenerate:Int = Rnd(tilesGenMin, tilesGenMax)
	Local generatedTiles:Int = 0
	
	'' Print "Trying to generate " + tilesToGenerate + " tiles"
	
	While generatedTiles < tilesToGenerate
		
		Local tX:Float = Rnd(2, Width - 2)
		Local tY:Float = Rnd(2, Height - 2)
		
		If tLev.Tiles[tX][tY].Obstacle = False
			If PointInRect(tX, tY, sZX, sZY, sZW, sZH) = False
				tLev.Tiles[tX][tY].Obstacle = True
				
				generatedTiles += 1
				
			EndIf
		EndIf
	
	Wend
	
	' TODO - GENERATE HEROES AND ZOMBIES
	Local HC:Int = Rnd(Level.MIN_HEROES, Level.MAX_HEROES + 1.0)
	Local ZC:Int = HC * (8 + (Rnd(0.0, 2.0)))
	
	tLev.HeroCount = HC
	tLev.ZombieCount = ZC
	
	tLev.delta = 0.75
	
	tLev.InitHeroes()
	tLev.InitZombies()
	
	tLev.MortarLauncherCount = Rnd(0.0, 12.0)
	tLev.InitMortarLaunchers()
	tLev.InitMortars()
	
	' MORTARS
	Local generatedMLs:Int = 0
	While generatedMLs < tLev.MortarLauncherCount
		
		Local tX:Int = Int(Rnd(1, (tLev.Width) - 2)) * Tile.WIDTH
		Local tY:Int = Int(Rnd(1, (tLev.Height) - 2)) * Tile.HEIGHT
		
		
		Local goodFind:Bool = True
		
		If RectOverRect(tX, tY, MortarLauncher.Width, MortarLauncher.Height, tLev.safezone.X, tLev.safezone.Y, tLev.safezone.W, tLev.safezone.H)
			goodFind = False
		EndIf
		
		
		If goodFind = True
			For Local blockX:Int = 0 Until tLev.Width
				If goodFind = True
					For Local blockY:Int = 0 Until tLev.Height
						If goodFind = True
							If tLev.CollidesWith(tX, tY, MortarLauncher.Width, MortarLauncher.Height)
								goodFind = False
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf
		
		If goodFind = True
			
			tLev.MortarLaunchers[generatedMLs].X = tX
			tLev.MortarLaunchers[generatedMLs].Y = tY
			
			Print tX + "," + tY
			
			generatedMLs += 1
			
		End
	
	Wend
	
	' HEROES
	Local generatedHeroes:Int = 0
	While generatedHeroes < HC
		Local tX:Float = Rnd(tLev.safezone.X + (Hero.Width * 0.5), tLev.safezone.X + tLev.safezone.W - (Hero.Width * 0.5))
		Local tY:Float = Rnd(tLev.safezone.Y + (Hero.Height * 0.5), tLev.safezone.Y + tLev.safezone.H - (Hero.Height * 0.5))
		
		tLev.Heroes[generatedHeroes].X = tX
		tLev.Heroes[generatedHeroes].Y = tY
		
		generatedHeroes += 1
		
	Wend
	
	' ZOMBIES
	Local generatedZombies:Int = 0
	While generatedZombies < ZC
		Local tX:Float = Rnd(16 + (Zombie.Width * 0.5), (tLev.Width * Tile.WIDTH) - 32 - (Zombie.Width * 0.5))
		Local tY:Float = Rnd(16 + (Zombie.Height * 0.5), (tLev.Height * Tile.HEIGHT) - 32 - (Zombie.Height * 0.5))
		Local goodFind:Bool = True
		
		If RectOverRect(tX - (Zombie.Width * 0.5), tY - (Zombie.Height * 0.5),Zombie.Width,Zombie.Height,tLev.safezone.X,tLev.safezone.Y,tLev.safezone.W,tLev.safezone.H)
			goodFind = False
		EndIf
		
		
		If goodFind = True
			For Local blockX:Int = 0 Until tLev.Width
				If goodFind = True
					For Local blockY:Int = 0 Until tLev.Height
						If goodFind = True
							If tLev.CollidesWith(tX - (Zombie.Width * 0.5), tY - (Zombie.Height * 0.5), Zombie.Width, Zombie.Height)
								goodFind = False
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf
		
		If goodFind = True
			
			tLev.Zombies[generatedZombies].X = tX
			tLev.Zombies[generatedZombies].Y = tY
			
			generatedZombies += 1
			
		End
		
	Wend
	
	Local controlledZombie:Int = Rnd(0.0, generatedZombies)
	tLev.controlledZombie = controlledZombie
	tLev.Zombies[controlledZombie].Controlled = True
	
	tLev.AliveZombies = generatedZombies
	
	'' Print "Generated " + generatedZombies + " zombies"
	
	tLev.UpdateTileFrames()
	
	Return tLev

End