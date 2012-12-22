Strict

Import mojo

Import src.framework.autofit
Import src.framework.camera
Import src.framework.controls
Import src.framework.functions
Import src.framework.gfx
Import src.framework.raztext
Import src.framework.rect
Import src.framework.screen
Import src.framework.screenmanager
Import src.framework.sfx
Import src.framework.touchbutton
Import src.framework.virtualstick

Import src.game.blood
Import src.game.bullet
Import src.game.entity
Import src.game.gib
Import src.game.hero
Import src.game.item
Import src.game.level
Import src.game.mortar
Import src.game.mortarlauncher
Import src.game.namegenerator
Import src.game.particle
Import src.game.powerup
Import src.game.safezone
Import src.game.shout
Import src.game.spit
Import src.game.tile
Import src.game.zombie

Import src.screens.credits
Import src.screens.credits2
Import src.screens.exitapp
Import src.screens.game
Import src.screens.howto
Import src.screens.logo
Import src.screens.postgamehero
Import src.screens.postgamezombie
Import src.screens.postgamedraw
Import src.screens.pregame
Import src.screens.title



Class LDApp Extends App

	Global level:Level

	Global ScreenWidth:Int = 360
	Global ScreenHeight:Int = 240
	Global ScreenX:Int = 0
	Global ScreenY:Int = 0
	
	Global TargetScreenX:Float = 0
	Global TargetScreenY:Float = 0
	
	Global ActualScreenX:Int = 0
	Global ActualScreenY:Int = 0
	
	Global ScreenMoveRate:Float = 0.1
	
	Global RefreshRate:Int
	Global Delta:Float
	
	
	Method OnCreate:Int()
		
		GFX.Init()
		ScreenManager.Init()
		SFX.Init()
		Controls.Init()
		
		
		RazText.SetTextSheet(LoadImage("gfx/fonts.png"))
		
		NameGenerator.Init()
		
		' Add the graphics
		' Use C:\Apps\Aseprite\
		
		' Add the screens
		ScreenManager.AddScreen("credits", New CreditsScreen())
		ScreenManager.AddScreen("credits2", New Credits2Screen())
		ScreenManager.AddScreen("exit", New ExitScreen())
		ScreenManager.AddScreen("game", New GameScreen())
		ScreenManager.AddScreen("logo", New LogoScreen())
		ScreenManager.AddScreen("title", New TitleScreen())
		ScreenManager.AddScreen("howto", New HowToScreen())
		ScreenManager.AddScreen("pregame", New PreGameScreen())
		ScreenManager.AddScreen("postgamehero", New PostGameHeroScreen())
		ScreenManager.AddScreen("postgamezombie", New PostGameZombieScreen())
		ScreenManager.AddScreen("postgamedraw", New PostGameDrawScreen())
		
		
		
		' Add the sound effects
		' USE C:\Apps\sfxr\
		
		SFX.Add("Click")
		SFX.Add("Select")
		
		SFX.Add("HeroDie")
		SFX.Add("HeroReload")
		SFX.Add("HeroShoot")
		SFX.Add("HeroSpotZombie")
		SFX.Add("HeroStep")
		
		SFX.Add("MortarShoot")
		
		SFX.Add("SpitDeactivate")
		
		SFX.Add("ZombieBite")
		SFX.Add("ZombieExplode")
		SFX.Add("ZombieGroan1")
		SFX.Add("ZombieHurt1")
		SFX.Add("ZombieSpit")
		SFX.Add("ZombieSpotHero")
		SFX.Add("ZombieStep")
		
		' Add the music
		' USE C:\Apps\MusicGen\
		SFX.AddMusic("jovial", "jovial.mp3")
		SFX.AddMusic("8bitbite", "8bitbite.mp3")
		SFX.AddMusic("ruth", "ruth.mp3")
		SFX.AddMusic("notre", "notre.mp3")
		SFX.AddMusic("cucaracha", "cucaracha.mp3")
		
		' Set the initial screen details
		ScreenManager.SetFadeColour(0, 0, 0)
		ScreenManager.SetFadeRate(0.1)
		ScreenManager.SetScreen("title")
		
		If Controls.ControlMethod = ControlMethodTypes.TOUCH
			RefreshRate = 30
		Else
			RefreshRate = 60
		End
		
		SetUpdateRate(RefreshRate)
		Delta = RefreshRate / 60.0
		
		
		SetVirtualDisplay(ScreenWidth, ScreenHeight)
		
		Return 0
	End
	
	Method OnUpdate:Int()
	
		Controls.Update()
	
		ActualScreenX += ( (TargetScreenX - ActualScreenX) * ScreenMoveRate)
		ActualScreenY += ( (TargetScreenY - ActualScreenY) * ScreenMoveRate)
		
		ScreenX = Int(ActualScreenX)
		ScreenY = Int(ActualScreenY)
		
		ScreenManager.Update()
		Return 0
	End
	
	Method OnRender:Int()
	
		UpdateVirtualDisplay()
	
		Cls
		ScreenManager.Render()
		Return 0
	End

End

Function Main:Int()
	New LDApp
	Return 0
End
