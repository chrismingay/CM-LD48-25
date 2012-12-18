Import ld

Class NameGenerator

	Global FemaleFirstNames:String[]
	Global MaleFirstNames:String[]
	Global Syllables:String[]
	
	Function Init:Void()
	
		FemaleFirstNames = LoadString("txt/femalefirstnames.txt").Split("~r~n")
		MaleFirstNames = LoadString("txt/malefirstnames.txt").Split("~r~n")
		Syllables = LoadString("txt/syllables.txt").Split("~r~n")
	
	End
	
	Function Generate:String(tGender:Int)
		
		Local SurnameSyllables:Int = Rnd(1, 5) ' Syllables between 1 and 4
		Local tFirst:String
		Local tSur:String
		
		If tGender = GenderType.FEMALE
			tFirst = FemaleFirstNames[Rnd(0, FemaleFirstNames.Length())]
		Else
			tFirst = MaleFirstNames[Rnd(0, MaleFirstNames.Length())]
		End
		
		For Local i:Int = 0 Until SurnameSyllables
			tSur += Syllables[Rnd(0, Syllables.Length())]
		Next
		
		Return tFirst+" "+tSur
	End
	
End

Class GenderType
	Const MALE:Int = 0
	Const FEMALE:Int = 1
End