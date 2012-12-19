Import ld

Class Zombie Extends Entity

	Const DRAWOFFSET_X:Int = 8
	Const DRAWOFFSET_Y:Int = 12
	
	Field Controlled:Bool = False

	Field TargetHero:Int
	Field TargetZombie:Int
	
	Field AITick:Float
	Field MAX_AI_TICK:Float = 20.0
	
	Field distanceSinceLastStep:Float
	Const STEP_LENGTH:Float = 24.0
	Field stepOne:Bool
	
	Const BiteDelay:Float = 40.0
	Field BiteDelayTimer:Float = 0.0
	
	Const Width:Int = 12
	Const Height:Int = 12
	
	Const MoveSpeed:Float = 1.5
	
	Const ShowZombieThoughts:Bool = False
	
	Field TimeChasingCurrentHero:Float = 0
	Field TimeSinceStartedFollowing:Float = 0
	
	Field CurrentAction:Int
	Field Action1:Int
	Field Action2:Int
	Field Action3:Int
	
	Field AICanSpit:Bool = True
	
	
	Field ProcessedLongPress:Bool = False
	
	
	Field ActionKeyDownTime:Int = 0
	
	Method New(tLev:Level, tID:Int)
		level = tLev
		D = 0.0
		S = Rnd(0.5, 0.7)
		AXS = 0.0
		AYS = 0.0
		distanceSinceLastStep = 0.0
		stepOne = False
		Health = 100.0
		Alive = True
		BiteDelayTimer = 0.0
		AITick = MAX_AI_TICK
		ID = tID
		StartWandering()
		
		Action1 = ActionType.CALL_TO_ARMS
		Action2 = ActionType.NOTHING
		Action3 = ActionType.NOTHING
		
	End

	Method Update:Void()
	
		UpdateAdditionalForces()
		
		If Alive
			UpdateALive()
		Else
			UpdateDead()
		EndIf
		
	End
	
	Method UpdateALive:Void()
	
		X += (Sin(D) * S * level.delta)
		Y += (Cos(D) * S * level.delta)
	
		If Controlled
			UpdateControlled()
		Else
			UpdateAI()
		End
		
		CheckAgainstLevel(Width, Height)
		
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
			SFX.Play("ZombieStep", SFX.VolumeFromPosition(X, Y) * 0.2, SFX.PanFromPosition(X, Y), tRate)
		EndIf
		
		If BiteDelayTimer <= 0
			For Local i:Int = 0 Until level.HeroCount
				If level.Heroes[i].Alive = True
					If RectOverRect(X, Y, Width, Height, level.Heroes[i].X, level.Heroes[i].Y, Hero.Width, Hero.Height)
						
						level.Heroes[i].ReactToZombie(Self)
						Health += 20.0
						If Health > 100.0
							Health = 100.0
						EndIf
						
						SFX.Play("ZombieBite", SFX.VolumeFromPosition(X, Y) * 1.0, SFX.PanFromPosition(X, Y), Rnd(0.75, 1.5))
						
						BiteDelayTimer = BiteDelay
						
					End
				EndIf
			Next
		Else
			BiteDelayTimer -= 1.0 * level.delta
		EndIf
		
		Health -= 0.008 * level.delta
		
		If Health <= 0.0
			Die()
		EndIf
	End
	
	Method StartWandering:Void()
		D = Rnd(0.0, 360.0)
		S = Rnd(0.5, 1.0)
		Mood = ZombieMood.WANDERING
	End
	
	Method UpdateDead:Void()
		
		CheckAgainstLevel(Width, Height)
	
	End
	
	Method UpdateControlled:Void()
		S = 0
		If Controls.LeftDown
			If Controls.UpDown
				D = 225
			ElseIf Controls.DownDown
				D = 315
			Else
				D = 270
			EndIf
			
			S = MoveSpeed
		ElseIf Controls.RightDown
			If Controls.UpDown
				D = 135
			ElseIf Controls.DownDown
				D = 45
			Else
				D = 90
			EndIf
			S = MoveSpeed
		ElseIf Controls.UpDown
			D = 180
			S = MoveSpeed
		ElseIf Controls.DownDown
			D = 0
			S = MoveSpeed
		EndIf
		
		'For Local i:Int = 0 Until level.HeroCount
		'	If level.CheckLineOfSight(X, Y, level.Heroes[i].X, level.Heroes[i].Y)
		'		level.Heroes[i].lastSeenByPlayer = Millisecs()
		'		
		'	EndIf
		'Next
		
		Local hasHoldPress:Bool = False
		Local hasShortPress:Bool = False
		
		If Controls.ActionHit
			ActionKeyDownTime += 1
		EndIf
		
		If Controls.ActionDown
			
			ActionKeyDownTime += 1
			
			If ActionKeyDownTime >= 30
				hasHoldPress = True
				ActionKeyDownTime = 0
				ProcessedLongPress = True
			EndIf
		
		Else
			If ActionKeyDownTime < 10 And ActionKeyDownTime >= 1 And ProcessedLongPress = False
				hasShortPress = True
			EndIf
			ActionKeyDownTime = 0
			
			ProcessedLongPress = False
		EndIf
		
		If hasHoldPress = True
			SFX.Play("click")
			CurrentAction += 1
			If CurrentAction = 3
				CurrentAction = 0
			EndIf
		ElseIf hasShortPress = True
			Local tA:Int
			Select CurrentAction
				Case 0
					tA = Action1
				Case 1
					tA = Action2
				Case 2
					tA = Action3
			End
			
			Select tA
				Case ActionType.NOTHING
				
				Case ActionType.CALL_TO_ARMS
					level.CallToArms(X, Y, ID)
					SFX.Play("ZombieSpotHero", SFX.VolumeFromPosition(X, Y) * 0.5, SFX.PanFromPosition(X, Y), Rnd(0.5, 2.0))
				Case ActionType.SCARE
				
				Case ActionType.SHIELD
				
				Case ActionType.SPIT
				
			End
			
		EndIf
		
	End
	
	Method UpdateAI:Void()
	
		' ' Print Millisecs()+" Update AI "+ID
	
		For Local i:Int = 0 To Mood
			AITick -= (1.0 * level.delta) * Rnd(0.1, 0.2)
		Next
		If AITick <= 0
			AITick = MAX_AI_TICK
			Think()
		EndIf
	End
	
	Method Think:Void()
	
		' ' Print Millisecs() + " Zombie " + ID + " is thinking"
	
		Select Mood
			Case ZombieMood.WANDERING
				' chance of a groan
				If Rnd() < 0.05
					SFX.Play("ZombieGroan1", SFX.VolumeFromPosition(X, Y) * 0.5, SFX.PanFromPosition(X, Y), Rnd(0.5, 2.0))
				EndIf
				
				If Rnd() < 0.3
					
					D = Rnd(0.0, 360.0)
					S = Rnd(0.5, 1.0)
				EndIf
				
				' 0.2 chance of looking for heroes
				If Rnd() < 0.2
					LookForHero()
				EndIf
			Case ZombieMood.FOLLOWING
			
				
				S = 1.0
				D = DirectionBetweenPoints(X, Y, level.Zombies[TargetZombie].X, level.Zombies[TargetZombie].Y)
			
				TimeSinceStartedFollowing += 1.0 * level.delta
				
				If TimeSinceStartedFollowing > 36.0 Or level.Zombies[TargetZombie].Alive = False
					D = Rnd(0.0, 360.0)
					S = Rnd(0.5, 1.0)
					Mood = ZombieMood.WANDERING
					'' Print "Zombie " + ID + " lost interest"
					TimeSinceStartedFollowing = 0.0
				EndIf
				
				If Rnd() < 0.2
					'' Print "Zombie " + ID + " is following but looking for a hero"
					LookForHero()
				EndIf
				
				If Rnd() < 0.1
					ZombieSpit()
				EndIf
				
				
			
			Case ZombieMood.CHASING
			
				' ' Print "Zombie " + ID + " is chasing hero " + TargetHero
			
				S = 1.5
				D = DirectionBetweenPoints(X, Y, level.Heroes[TargetHero].X, level.Heroes[TargetHero].Y)
				
				If level.Heroes[TargetHero].Alive = False
					D = Rnd(0.0, 360.0)
					S = Rnd(0.5, 1.0)
					Mood = ZombieMood.WANDERING
				Else
					
					If Rnd() < 0.1
						SFX.Play("ZombieSpotHero", SFX.VolumeFromPosition(X, Y) * 0.5, SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
						level.AlertNearbyZombies(X, Y, ID, TargetHero)
					EndIf
					
					If Rnd() < 0.25
						ZombieSpit()
					EndIf
					
				End
				
				TimeChasingCurrentHero += 1.0 * level.delta
				
				If TimeChasingCurrentHero > 36.0
					D = Rnd(0.0, 360.0)
					S = Rnd(0.5, 1.0)
					Mood = ZombieMood.WANDERING
					' Print "Zombie " + ID + " lost interest"
					
				EndIf
				
		End
		
	End
	
	Method LookForHero:Void()
	
	
		Local heroFound:Bool = False
		
		Local currentClosest:Int = -1
		Local currentDistance:Float = 999999999
		
		For Local i:Int = 0 Until level.HeroCount
			If level.Heroes[i].Alive = True
				Local tDist:Float = DistanceBetweenPoints(X, Y, level.Heroes[i].X, level.Heroes[i].Y)
				If tDist < 300
					If level.CheckLineOfSight(X, Y, level.Heroes[i].X, level.Heroes[i].Y)
						heroFound = True
						If tDist < currentDistance
							
							currentDistance = tDist
							currentClosest = i
						End
					EndIf
				EndIf
			EndIf
		Next
		
		If heroFound = True
			
			GoForHero(currentClosest)
		EndIf
	End
	
	Method GoForHero:Void(tH:Int)
		TargetHero = tH
		Mood = ZombieMood.CHASING
		SFX.Play("ZombieSpotHero", SFX.VolumeFromPosition(X, Y) * 1.0, SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
		TimeChasingCurrentHero = 0
	End
	
	Method GoForZombie:Void(tZ:Int)
		TargetZombie = tZ
		Mood = ZombieMood.FOLLOWING
		' SFX.Play("ZombieSpotHero", SFX.VolumeFromPosition(X, Y) * 1.0, SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
		TimeSinceStartedFollowing = 0
	End
	
	
	Method Render:Void()
		SetColor(255, 255, 255)
		If Alive
			GFX.Draw(X - DRAWOFFSET_X, Y - DRAWOFFSET_Y, 0, 0, 16, 16)
			If Mood = ZombieMood.CHASING Or Mood = ZombieMood.FOLLOWING
				
				GFX.Draw(X - 2, Y - 17, 0, 80, 4, 7)
			
			EndIf
			
			If Health < 20
				GFX.Draw(X + 7, Y - 10, 16, 80, 7, 6)
			EndIf
		Else
			GFX.Draw(X - DRAWOFFSET_X, Y - DRAWOFFSET_Y, 0, 32, 16, 16)
		End
		
	End
	
	Method IsOnScreen:Bool()
		Return RectOverRect(X - (Width * 0.5), Y - (Height * 0.5), Width, Height, LDApp.ScreenX, LDApp.ScreenY, LDApp.ScreenWidth, LDApp.ScreenHeight)
	End
	
	Method ReactToBullet:Void(tBul:Bullet)
		AdditionalForce(Sin(tBul.D) * tBul.S * 0.5, Cos(tBul.D) * tBul.S * 0.5)
		Local tDam:Float = Rnd(50.0, 100.0)
		Health -= tDam
		SFX.Play("ZombieHurt1", SFX.VolumeFromPosition(X, Y) * 0.5, SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
		level.ActivateGib(X,Y)
	End
	
	Method Die:Void()
		If Alive = True
			If Health < - 50.0
				SFX.Play("ZombieExplode", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
				For Local i:Int = 0 Until 10
					level.ActivateGib(X, Y)
				Next
			EndIf
			Alive = False
			level.AliveZombies -= 1
		EndIf
	End
	
	Method ZombieSpit:Void()
		SFX.Play("ZombieSpit", SFX.VolumeFromPosition(X, Y), SFX.PanFromPosition(X, Y), Rnd(0.9, 1.1))
	
		If Mood = ZombieMood.CHASING And TargetHero <> - 1
			For Local i:Int = 0 To 3
				Spit.Create(X, Y, D + Rnd(-5, 5))
			Next
		Else
			For Local i:Int = 0 To 1
				Spit.Create(X, Y, D + Rnd(-25, 25))
			Next
		EndIf
	End
	
	
	
End

Class ZombieMood
	
	Const WANDERING:Int = 0
	Const FOLLOWING:Int = 1
	Const CHASING:Int = 3
	
End

Class ActionType

	Const NOTHING:Int = 0
	Const CALL_TO_ARMS:Int = 1
	Const SPIT:Int = 2
	Const SHIELD:Int = 3
	Const SCARE:Int = 4
	
End