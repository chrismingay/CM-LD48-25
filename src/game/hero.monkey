Import ld

Class Hero Extends Entity

	Const DRAWOFFSET_X:Int = 8
	Const DRAWOFFSET_Y:Int = 8

	Field TargetZombie:Int
	
	Field lastSpottedX:Float
	Field lastSpottedY:Float
	
	Field stepOne:Bool
	Field distanceSinceLastStep:Float
	Const STEP_LENGTH:Float = 16.0
	
	Const Width:Int = 16
	Const Height:Int = 16
	
	Const MAX_AMMO:Int = 200
	Field Ammo:Int
	Field Magazine:Int
	Field MagazineSize:Int = 16
	
	Field ShotDelay:Float = 0.0
	Field ShotDelayTime:Float = 0.3
	
	Field MagazineDelay:Float = 0.0
	Field MagazineDelayTime:Float = 6.0
	
	Field Name:RazText
	
	Field lastSeenByPlayer:Int
	
	Field InPain:Float = 0.0
	Const InPainMax:Float = 1.5
	
	Field TargetX:Float
	Field TargetY:Float
	
	Field TargetLauncher:Int
	
	Field TimeFollowingTarget:Float = 0.0
	
	
	Method New(tLev:Level, tID:Int)
		level = tLev
		S = Rnd(0.25, 1.0)
		D = Rnd(0.0, 360.0)
		distanceSinceLastStep = 0.0
		stepOne = False
		
		Ammo = MAX_AMMO
		Magazine = MagazineSize
		
		TargetZombie = -1
		
		Health = 100.0
		Alive = True
		
		ID = tID
		
		
		StartWandering()
	End
	
	Method Update:Void()
	
		UpdateAdditionalForces()
		
		
		
		If Alive
		
			If Health <= 0.0
				Die()
			Else
				UpdateAlive()
			End
			
		Else
			UpdateDead()
		EndIf
		
	End
	
	Method UpdateAttacking:Void()
		If level.Zombies[TargetZombie].Alive = True
		
			TimeFollowingTarget += 1.0 * level.delta
			
			If TimeFollowingTarget >= 200.0
				' Print "Hero " + ID + " Lost interest"
				StartWandering()
			EndIf
			
			If Rnd() < 0.02
				D = DirectionBetweenPoints(X, Y, level.Zombies[TargetZombie].X, level.Zombies[TargetZombie].Y)
			EndIf
			
			If Magazine > 0
			
				S = 0.75
			
				ShotDelay += (0.1 * level.delta) * Rnd(0.5, 1.0)
				If ShotDelay >= ShotDelayTime
					ShotDelay = 0.0
					AttemptShot()
				EndIf
			ElseIf Ammo > 0
			
				S = 0.2
			
				If MagazineDelay = 0.0
					SFX.Play("HeroReload", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y))
				EndIf
				MagazineDelay += (0.1 * level.delta)
				If MagazineDelay >= MagazineDelayTime
					MagazineDelay = 0.0
					Reload()
				EndIf
			End
			
		Else
			StartWandering()
		EndIf
	End
	
	Method StartAttacking:Void()
		Mood = HeroMood.ATTACKING
		TimeFollowingTarget = 0.0
		' Print "Hero " + ID + " is starting attacking"
	End
	
	
	Method UpdateWandering:Void()
		If Rnd() < 0.01
			StartWandering()
		ElseIf Rnd() < 0.02
			D += Rnd(-1.0, 1.0)
		ElseIf Rnd() < 0.03
			StartGoingForMortarLauncher()
		ElseIf Rnd() < 0.04
		
			Local alreadyHasTarget:Bool = False
			If TargetZombie <> - 1
				If level.Zombies[TargetZombie].Alive = True
					StartAttacking()
					alreadyHasTarget = True
				EndIf
			EndIf
			
			If alreadyHasTarget = False
				Local zomFound:Bool = False
				Local zomID:Int = -1
				Local zomDist:Float = 99999999999999
				For Local i:Int = 0 Until level.ZombieCount
					If level.Zombies[i].Alive = True
						Local tDist:Float = DistanceBetweenPoints(X, Y, level.Zombies[i].X, level.Zombies[i].Y)
						If tDist < zomDist
							If level.CheckLineOfSight(X, Y, level.Zombies[i].X, level.Zombies[i].Y)
								zomFound = True
								zomID = i
								zomDist = tDist
							End
						EndIf
					EndIf
				Next
				
				If zomFound = True
					TargetZombie = zomID
					StartAttacking()
				End
			End
		
		EndIf
		
		
	End
	
	Method StartWandering:Void()
		Mood = HeroMood.WANDERING
		S = Rnd(0.5, 1.0)
		
		TargetX = Rnd(24, (level.Width * Tile.WIDTH) - 24)
		TargetY = Rnd(24, (level.Height * Tile.HEIGHT) - 24)
		
		D = DirectionBetweenPoints(X, Y, TargetX, TargetY)
		' Print "Hero " + ID + " is starting wandering"
		' Print "Target Pos " + TargetX + "," + TargetY
	End
	
	Method UpdateHurting:Void()
		InPain -= (1.0 * level.delta)
		If InPain <= 0
			If TargetZombie <> - 1
				If level.Zombies[TargetZombie].Alive = True
					StartAttacking()
				End
			End
			StartWandering()
		EndIf
	End
	
	Method StartHurting:Void()
		Mood = HeroMood.HURTING
		InPain = InPainMax
		' Print "Hero " + ID + " is starting hurting"
	End
	
	Method UpdateRetreating:Void()
		If Rnd() < 0.01
			D = DirectionBetweenPoints(X, Y, level.safezone.X + (level.safezone.W * 0.5), level.safezone.Y + (level.safezone.H * 0.5))
		ElseIf Rnd() < 0.02
			D += Rnd(-1.0, 1.0)
		EndIf
		
		If Health > 50.0 And Ammo > (MAX_AMMO * 0.5)
			StartWandering()
		EndIf
		
		If InSafeZone()
			S = 0.2
		Else
			S = 2.0
		EndIf
		
	End
	
	Method StartRetreating:Void()
		Mood = HeroMood.RETREATING
		D = DirectionBetweenPoints(X, Y, level.safezone.X + (level.safezone.W * 0.5), level.safezone.Y + (level.safezone.H * 0.5))
		S = 2.0
		' Print "Hero " + ID + " is starting retreating"
	End
	
	Method StartGoingForMortarLauncher:Void()
		LookForMortarLauncher()
	End
	
	Method LookForMortarLauncher:Void()
	
	
		Local launcherFound:Bool = False
		
		Local currentClosest:Int = -1
		Local currentDistance:Float = 999999999
		
		For Local i:Int = 0 Until level.MortarLauncherCount
			If level.MortarLaunchers[i].Active = True
				Local tDist:Float = DistanceBetweenPoints(X, Y, level.MortarLaunchers[i].X, level.MortarLaunchers[i].Y)
				If tDist < 300
					launcherFound = True
					If tDist < currentDistance
						
						currentDistance = tDist
						currentClosest = i
					End
				EndIf
			EndIf
		Next
		
		If launcherFound = True
			
			GoForLauncher(currentClosest)
		EndIf
	End
	
	Method GoForLauncher:Void(tL:Int)
		TargetLauncher = tL
		Mood = HeroMood.GOING_FOR_MORTAR
	End
	
	Method UpdateGoingForMortarLauncher:Void()
	
		If Rnd() < 0.1
			D = DirectionBetweenPoints(X, Y, level.MortarLaunchers[TargetLauncher].X, level.MortarLaunchers[TargetLauncher].Y) + Rnd(-20.0, 20.0)
			S = 1.0
		EndIf
		
		If RectOverRect(X, Y, Width, Height, level.MortarLaunchers[TargetLauncher].X, level.MortarLaunchers[TargetLauncher].Y, MortarLauncher.Width, MortarLauncher.Height)
			If level.MortarLaunchers[TargetLauncher].Status = MortarLauncher.READY
				level.MortarLaunchers[TargetLauncher].Shoot()
				StartWandering()
			End
		End
		
		
		
	End
	
	Method UpdateAlive:Void()
		X += Sin(D) * S * level.delta
		Y += Cos(D) * S * level.delta
		
		If Mood <> HeroMood.RETREATING
			If Health < 25.0 Or Ammo = 0
				StartRetreating()
			EndIf
		EndIf
		
		Select Mood
			Case HeroMood.ATTACKING
				UpdateAttacking()
			Case HeroMood.WANDERING
				UpdateWandering()
			Case HeroMood.HURTING
				UpdateHurting()
			Case HeroMood.RETREATING
				UpdateRetreating()
			Case HeroMood.GOING_FOR_MORTAR
				UpdateGoingForMortarLauncher()
		End
		
		CheckAgainstLevel(Width, Height)
		
		If InSafeZone()
			Health += 1 * level.delta
			Ammo += 1
			
			If Ammo >= MAX_AMMO
				Ammo = MAX_AMMO
			EndIf
			
			If Health >= 100.0
				Health = 100.0
			EndIf
		EndIf
		
		distanceSinceLastStep += S * level.delta
		If distanceSinceLastStep >= STEP_LENGTH
			distanceSinceLastStep = 0
			Local tRate:Float
			If stepOne = True
				stepOne = False
				tRate = 1.1
			Else
				stepOne = True
				tRate = 0.9
			EndIf
			SFX.Play("HeroStep", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y), tRate)
		EndIf
		
	End
	
	Method Die:Void()
		If Alive = True
			Alive = False
			SFX.Play("HeroDie", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y))
			level.AliveHeroes -= 1
		End
	End
	
	Method UpdateDead:Void()
		CheckAgainstLevel(Width, Height)
	End
	
	Method Render:Void()
		SetColor(255, 255, 255)
		If Alive
		
			GFX.Draw(X + (Sin(D) * 8), Y + (Cos(D) * 8) + 8, 0, 112, 1, 1)
			GFX.Draw(X + (Sin(D) * 16), Y + (Cos(D) * 16) + 8, 2, 112, 2, 2)
		
			If Mood = HeroMood.ATTACKING
				If MagazineDelay > 0
					GFX.Draw(X - 38, Y - 18, 0, 96, 60, 12)
				EndIf
			EndIf
		
			GFX.Draw(X - DRAWOFFSET_X, Y - DRAWOFFSET_Y, 0, 16, 16, 16)
			If InSafeZone()
				GFX.Draw(X + 4, Y - 6, 8, 80, 5, 5)
			Else
				If Health < 20
					GFX.Draw(X + 3, Y - 6, 16, 80, 7, 6)
				EndIf
			EndIf
			
			If Mood = HeroMood.ATTACKING
				GFX.Draw(X + 3, Y + 1, 0, 80, 4, 7)
			EndIf
			
			If Mood = HeroMood.RETREATING
				GFX.Draw(X + 3, Y + 1, 24, 80, 5, 5)
			EndIf
			
		Else
			GFX.Draw(X - DRAWOFFSET_X, Y - DRAWOFFSET_Y, 0, 48, 16, 16)
		End
		
		'If Mood = HeroMood.ATTACKING
		'	GFX.DL(X, Y, level.Zombies[TargetZombie].X, level.Zombies[TargetZombie].Y)
		'EndIf
		'DrawCircle(X - LDApp.ScreenX, Y - LDApp.ScreenY, (Width * 0.5))
	End
	
	Method InSafeZone:Bool()
		Return PointInRect(X, Y, level.safezone.X, level.safezone.Y, level.safezone.W, level.safezone.H)
	End
	
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5), Y - (Width * 0.5), Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End
	
	Method AttemptShot:Void()
		If Magazine > 0
			Shoot()
		EndIf
	End
	
	Method Shoot:Void()
		Local tD:Float
		If TargetZombie >= 0
			tD = DirectionBetweenPoints(X, Y, level.Zombies[TargetZombie].X, level.Zombies[TargetZombie].Y)
		Else
			tD = D
		EndIf
		level.ActivateBullet(X, Y, D)
		SFX.Play("HeroShoot", SFX.VolumeFromPosition(X, Y) * 0.25, SFX.PanFromPosition(X, Y), Rnd(0.8, 1.2))
		Magazine -= 1
	End
	
	Method Reload:Void()
		If Ammo > MagazineSize
			Ammo -= MagazineSize
			Magazine = MagazineSize
		Else
			Magazine = Ammo
			Ammo = 0
		End
	End
	
	Method ReactToZombie:Void(tZom:Zombie)
		Health -= (20.0 + Rnd(0.0, 5.0))
		Local tD:Float = DirectionBetweenPoints(X, Y, tZom.X, tZom.Y) + Rnd(-30, 30)
		Local tXS:Float = Sin(tD) * tZom.S * level.delta
		Local tYS:Float = Cos(tD) * tZom.S * level.delta
		D = tD
		S = -2
		StartHurting()
		TargetZombie = tZom.ID
	End
	
	Method ReactToSpit:Void(tSpit:Spit)
		Health -= (2.0 + Rnd(0.0, 2.0))
		Local tD:Float = DirectionBetweenPoints(X, Y, tSpit.X, tSpit.Y) + Rnd(-30, 30)
		Local tXS:Float = Sin(tD) * tSpit.S * level.delta
		Local tYS:Float = Cos(tD) * tSpit.S * level.delta
		D = tD
		S = -2
		StartHurting()
	End
	
	Method CollidesWith:Bool(tX:Float, tY:Float, tW:Float, tH:Float)
		Return RectOverRect(X - (Width * 0.5), Y - (Height * 0.5), Width, Height, tX, tY, tW, tH)
	End
	
End

Class HeroMood
	
	Const WANDERING:Int = 0
	Const ATTACKING:Int = 1
	Const RETREATING:Int = 2
	Const HURTING:Int = 3
	Const GOING_FOR_MORTAR:Int = 4
	

End

