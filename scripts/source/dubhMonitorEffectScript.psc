ScriptName dubhMonitorEffectScript Extends ActiveMagicEffect

Import dubhUtilityScript

; =============================================================================
; PROPERTIES
; =============================================================================

GlobalVariable Property Global_fBestSkillContribMax Auto
GlobalVariable Property Global_fLOSDistanceMax Auto
GlobalVariable Property Global_fLOSPenaltyClearMin Auto
GlobalVariable Property Global_fLOSPenaltyDistanceFar Auto
GlobalVariable Property Global_fLOSPenaltyDistanceMid Auto
GlobalVariable Property Global_fLOSPenaltyDistortedMin Auto
GlobalVariable Property Global_fLOSPenaltyPeripheralMin Auto
GlobalVariable Property Global_fMobilityBonus Auto
GlobalVariable Property Global_fMobilityPenalty Auto
GlobalVariable Property Global_fRaceArgonian Auto
GlobalVariable Property Global_fRaceArgonianVampire Auto
GlobalVariable Property Global_fRaceBreton Auto
GlobalVariable Property Global_fRaceBretonVampire Auto
GlobalVariable Property Global_fRaceDarkElf Auto
GlobalVariable Property Global_fRaceDarkElfVampire Auto
GlobalVariable Property Global_fRaceHighElf Auto
GlobalVariable Property Global_fRaceHighElfVampire Auto
GlobalVariable Property Global_fRaceImperial Auto
GlobalVariable Property Global_fRaceImperialVampire Auto
GlobalVariable Property Global_fRaceKhajiit Auto
GlobalVariable Property Global_fRaceKhajiitVampire Auto
GlobalVariable Property Global_fRaceNord Auto
GlobalVariable Property Global_fRaceNordVampire Auto
GlobalVariable Property Global_fRaceOrc Auto
GlobalVariable Property Global_fRaceOrcVampire Auto
GlobalVariable Property Global_fRaceRedguard Auto
GlobalVariable Property Global_fRaceRedguardVampire Auto
GlobalVariable Property Global_fRaceWoodElf Auto
GlobalVariable Property Global_fRaceWoodElfVampire Auto
GlobalVariable Property Global_fScriptDistanceMax Auto
GlobalVariable Property Global_fScriptSuspendTime Auto
GlobalVariable Property Global_fScriptSuspendTimeBeforeAttack Auto
GlobalVariable Property Global_fScriptUpdateFrequencyMonitor Auto
GlobalVariable Property Global_fSlotAmulet Auto
GlobalVariable Property Global_fSlotBody Auto
GlobalVariable Property Global_fSlotCirclet Auto
GlobalVariable Property Global_fSlotFeet Auto
GlobalVariable Property Global_fSlotHair Auto
GlobalVariable Property Global_fSlotHands Auto
GlobalVariable Property Global_fSlotRing Auto
GlobalVariable Property Global_fSlotShield Auto
GlobalVariable Property Global_fSlotWeaponLeft Auto
GlobalVariable Property Global_fSlotWeaponRight Auto
GlobalVariable Property Global_iPapyrusLoggingEnabled Auto

Actor Property PlayerRef Auto
Faction Property DisguiseFaction01 Auto ; Blades
Faction Property DisguiseFaction02 Auto ; Cultists
Faction Property DisguiseFaction03 Auto ; Dark Brotherhood
Faction Property DisguiseFaction04 Auto ; Dawnguard
Faction Property DisguiseFaction05 Auto ; Forsworn
Faction Property DisguiseFaction06 Auto ; Imperial Legion
Faction Property DisguiseFaction07 Auto ; Morag Tong
Faction Property DisguiseFaction08 Auto ; Penitus Oculatus
Faction Property DisguiseFaction09 Auto ; Silver Hand
Faction Property DisguiseFaction10 Auto ; Stormcloaks
Faction Property DisguiseFaction11 Auto ; Thalmor
Faction Property DisguiseFaction12 Auto ; Thieves Guild
Faction Property DisguiseFaction13 Auto ; Vigil of Stendarr
Faction Property DisguiseFaction14 Auto ; Volkihar Clan
Faction Property DisguiseFaction15 Auto ; Necromancers
Faction Property DisguiseFaction16 Auto ; Vampires
Faction Property DisguiseFaction17 Auto ; Werewolves
Faction Property DisguiseFaction18 Auto ; Companions
Faction Property DisguiseFaction19 Auto ; Falkreath Guard
Faction Property DisguiseFaction20 Auto ; Hjaalmarch Guard
Faction Property DisguiseFaction21 Auto ; Markarth Guard
Faction Property DisguiseFaction22 Auto ; Pale Guard
Faction Property DisguiseFaction23 Auto ; Raven Rock Guard
Faction Property DisguiseFaction24 Auto ; Riften Guard
Faction Property DisguiseFaction25 Auto ; Solitude Guard
Faction Property DisguiseFaction26 Auto ; Whiterun Guard
Faction Property DisguiseFaction27 Auto ; Windhelm Guard
Faction Property DisguiseFaction28 Auto ; Winterhold Guard
Faction Property DisguiseFaction29 Auto ; Daedric Influence
Faction Property DisguiseFaction30 Auto ; Alik'r Mercenaries
Faction Property DisguiseFaction31 Auto ; Bandits
Faction Property PlayerFaction Auto
Formlist Property BaseFactions Auto
Formlist Property DisguiseFactions Auto
Formlist Property DisguiseFormlists Auto
Formlist Property DisguiseSlots Auto
Formlist Property ExcludedDamageSources Auto
MagicEffect Property FactionEnemyEffect Auto
Message Property DisguiseWarningSuspicious Auto   ; "You are being watched..." (5 second delay)
Race Property ArgonianRace Auto
Race Property ArgonianRaceVampire Auto
Race Property BretonRace Auto
Race Property BretonRaceVampire Auto
Race Property DarkElfRace Auto
Race Property DarkElfRaceVampire Auto
Race Property HighElfRace Auto
Race Property HighElfRaceVampire Auto
Race Property ImperialRace Auto
Race Property ImperialRaceVampire Auto
Race Property KhajiitRace Auto
Race Property KhajiitRaceVampire Auto
Race Property NordRace Auto
Race Property NordRaceVampire Auto
Race Property OrcRace Auto
Race Property OrcRaceVampire Auto
Race Property RedguardRace Auto
Race Property RedguardRaceVampire Auto
Race Property WoodElfRace Auto
Race Property WoodElfRaceVampire Auto
Spell Property FactionEnemyAbility Auto
Spell Property MonitorAbility Auto

; =============================================================================
; SCRIPT-LOCAL VARIABLES
; =============================================================================

Int iHair    = 31 ; 0x00000002
Int iBody    = 32 ; 0x00000004
Int iHands   = 33 ; 0x00000008
Int iAmulet  = 35 ; 0x00000020
Int iRing    = 36 ; 0x00000040
Int iFeet    = 37 ; 0x00000080
Int iShield  = 39 ; 0x00000200
Int iCirclet = 42 ; 0x00001000

Actor NPC

; ===============================================================================
; FUNCTIONS
; ===============================================================================

Function _Log(String asTextToPrint)
	If Global_iPapyrusLoggingEnabled.GetValue() as Bool
		Debug.Trace("Master of Disguise: dubhMonitorEffectScript> " + asTextToPrint)
	EndIf
EndFunction


Function LogInfo(String asTextToPrint)
	_Log("[INFO] " + asTextToPrint)
EndFunction


Function LogWarning(String asTextToPrint)
	_Log("[WARN] " + asTextToPrint)
EndFunction


Function LogError(String asTextToPrint)
	_Log("[ERRO] " + asTextToPrint)
EndFunction


Bool Function IsExcludedDamageSource(Form akDamageSource)
	Int i = 0

	While i < ExcludedDamageSources.GetSize()
		Form kDamageSource = ExcludedDamageSources.GetAt(i)

		If akDamageSource == kDamageSource
			Return True
		EndIf

		i += 1
	EndWhile

	Return False
EndFunction


Float Function GetBestSkillWeight(Float afSkillPenalty)
	; Calculates the skill score for the player's best skill

	Float fBestSkillValue = GetBestSkill(PlayerRef)

	If fBestSkillValue > 100.0
		fBestSkillValue = 100.0
	EndIf

	Return ((Global_fBestSkillContribMax.GetValue() * fBestSkillValue) / 100.0) * afSkillPenalty
EndFunction


Float Function GetRaceWeight(Race akRace)
	; Gets the actor's race, if the actor is in the associated faction, and returns
	;   the weight of the race on the chance to remain to undetected
	;   Ex: fDetectionWeight += GetRaceWeight(PlayerRef, CustomFaction11, HighElfRace, 20)

	Race kPlayerRace = PlayerRef.GetRace()

	If akRace == ArgonianRace && akRace == kPlayerRace
		Return Global_fRaceArgonian.GetValue()
	EndIf

	If akRace == ArgonianRaceVampire && akRace == kPlayerRace
		Return Global_fRaceArgonianVampire.GetValue()
	EndIf

	If akRace == BretonRace && akRace == kPlayerRace
		Return Global_fRaceBreton.GetValue()
	EndIf

	If akRace == BretonRaceVampire && akRace == kPlayerRace
		Return Global_fRaceBretonVampire.GetValue()
	EndIf

	If akRace == DarkElfRace && akRace == kPlayerRace
		Return Global_fRaceDarkElf.GetValue()
	EndIf

	If akRace == DarkElfRaceVampire && akRace == kPlayerRace
		Return Global_fRaceDarkElfVampire.GetValue()
	EndIf

	If akRace == HighElfRace && akRace == kPlayerRace
		Return Global_fRaceHighElf.GetValue()
	EndIf

	If akRace == HighElfRaceVampire && akRace == kPlayerRace
		Return Global_fRaceHighElfVampire.GetValue()
	EndIf

	If akRace == ImperialRace && akRace == kPlayerRace
		Return Global_fRaceImperial.GetValue()
	EndIf

	If akRace == ImperialRaceVampire && akRace == kPlayerRace
		Return Global_fRaceImperialVampire.GetValue()
	EndIf

	If akRace == KhajiitRace && akRace == kPlayerRace
		Return Global_fRaceKhajiit.GetValue()
	EndIf

	If akRace == KhajiitRaceVampire && akRace == kPlayerRace
		Return Global_fRaceKhajiitVampire.GetValue()
	EndIf

	If akRace == NordRace && akRace == kPlayerRace
		Return Global_fRaceNord.GetValue()
	EndIf

	If akRace == NordRaceVampire && akRace == kPlayerRace
		Return Global_fRaceNordVampire.GetValue()
	EndIf

	If akRace == OrcRace && akRace == kPlayerRace
		Return Global_fRaceOrc.GetValue()
	EndIf

	If akRace == OrcRaceVampire && akRace == kPlayerRace
		Return Global_fRaceOrcVampire.GetValue()
	EndIf

	If akRace == RedguardRace && akRace == kPlayerRace
		Return Global_fRaceRedguard.GetValue()
	EndIf

	If akRace == RedguardRaceVampire && akRace == kPlayerRace
		Return Global_fRaceRedguardVampire.GetValue()
	EndIf

	If akRace == WoodElfRace && akRace == kPlayerRace
		Return Global_fRaceWoodElf.GetValue()
	EndIf

	If akRace == WoodElfRaceVampire && akRace == kPlayerRace
		Return Global_fRaceWoodElfVampire.GetValue()
	EndIf

	Return 0.0
EndFunction


Bool[] Function WhichSlotMasks(Faction akFaction)
	; Returns bool array indicating which slots are equipped with disguise items

	Bool[] results = new Bool[10]

	Int iFactionIndex = DisguiseFactions.Find(akFaction)

	If iFactionIndex == -1
		LogError("Cannot find faction in factions formlist: " + akFaction)
		Return results
	EndIf

	Formlist kDisguise = DisguiseFormlists.GetAt(iFactionIndex) as Formlist
	Formlist kSlots    = DisguiseSlots.GetAt(iFactionIndex) as Formlist

	Form kHair         = PlayerRef.GetEquippedArmorInSlot(iHair) as Form
	Form kBody         = PlayerRef.GetEquippedArmorInSlot(iBody) as Form
	Form kHands        = PlayerRef.GetEquippedArmorInSlot(iHands) as Form
	Form kAmulet       = PlayerRef.GetEquippedArmorInSlot(iAmulet) as Form
	Form kRing         = PlayerRef.GetEquippedArmorInSlot(iRing) as Form
	Form kFeet         = PlayerRef.GetEquippedArmorInSlot(iFeet) as Form
	Form kShield       = PlayerRef.GetEquippedArmorInSlot(iShield) as Form
	Form kCirclet      = PlayerRef.GetEquippedArmorInSlot(iCirclet) as Form
	Form kWeaponLeft   = PlayerRef.GetEquippedWeapon(true) as Form
	Form kWeaponRight  = PlayerRef.GetEquippedWeapon() as Form

	If kHair
		results[0] = (kSlots.GetAt(0) as Formlist).HasForm(kHair)
	Else
		results[0] = False
	EndIf

	If kBody
		results[1] = (kSlots.GetAt(1) as Formlist).HasForm(kBody)
	Else
		results[1] = False
	EndIf

	If kHands
		results[2] = (kSlots.GetAt(2) as Formlist).HasForm(kHands)
	Else
		results[2] = False
	EndIf

	If kAmulet
		results[3] = (kSlots.GetAt(3) as Formlist).HasForm(kAmulet)
	Else
		results[3] = False
	EndIf

	If kRing
		results[4] = (kSlots.GetAt(4) as Formlist).HasForm(kRing)
	Else
		results[4] = False
	EndIf

	If kFeet
		results[5] = (kSlots.GetAt(5) as Formlist).HasForm(kFeet)
	Else
		results[5] = False
	EndIf

	If kShield
		results[6] = (kSlots.GetAt(6) as Formlist).HasForm(kShield)
	Else
		results[6] = False
	EndIf

	If kCirclet
		results[7] = (kSlots.GetAt(7) as Formlist).HasForm(kCirclet)
	Else
		results[7] = False
	EndIf

	If kWeaponLeft
		results[8] = kDisguise.HasForm(kWeaponLeft)
	Else
		results[8] = False
	EndIf

	If kWeaponRight
		results[9] = kDisguise.HasForm(kWeaponRight)
	Else
		results[9] = False
	EndIf

	Return results
EndFunction


Float Function CalculateEquipWeight(Bool[] abSlots)
	; Returns the equipment score from worn items
	; 1. Get worn items
	; 2. Check if worn items are in formlist
	; 3. If worn items are in formlist, return those slots as Bool array

	Float fEquipWeightSum = 0.0

	; Hair and Circlet
	If abSlots[0] || !abSlots[7]
		; Hair, but not Circlet
		If abSlots[0] && !abSlots[7]
			fEquipWeightSum += Global_fSlotHair.GetValue()
		; Circlet, but not Hair
		ElseIf !abSlots[0] && abSlots[7]
			fEquipWeightSum += Global_fSlotCirclet.GetValue()
		; Both
		ElseIf abSlots[0] && abSlots[7]
			fEquipWeightSum += Global_fSlotCirclet.GetValue()
		EndIf
	EndIf

	If abSlots[1] ; Body
		fEquipWeightSum += Global_fSlotBody.GetValue()
	EndIf

	If abSlots[2] ; Hands
		fEquipWeightSum += Global_fSlotHands.GetValue()
	EndIf

	If abSlots[3] ; Amulet
		fEquipWeightSum += Global_fSlotAmulet.GetValue()
	EndIf

	If abSlots[4] ; Ring
		fEquipWeightSum += Global_fSlotRing.GetValue()
	EndIf

	If abSlots[5] ; Feet
		fEquipWeightSum += Global_fSlotFeet.GetValue()
	EndIf

	If abSlots[6] ; Shield
		fEquipWeightSum += Global_fSlotShield.GetValue()
	EndIf

	If abSlots[8] || abSlots[9]
		; Weapon Left, but not Weapon Right
		If abSlots[8] && !abSlots[9]
			fEquipWeightSum += Global_fSlotWeaponLeft.GetValue()
		; Weapon Right, but not Weapon Left
		ElseIf !abSlots[8] && abSlots[9]
			fEquipWeightSum += Global_fSlotWeaponRight.GetValue()
		; Both
		ElseIf abSlots[8] && abSlots[9]
			fEquipWeightSum += Global_fSlotWeaponLeft.GetValue()
		EndIf
	EndIf

	If fEquipWeightSum > 100.0
		Return 100.0
	EndIf

	Return fEquipWeightSum
EndFunction


Float Function SumRaceWeight()
	; Calculates the race score for player based on faction

	Float fRaceWeightSum = 0.0

	If PlayerRef.IsInFaction(DisguiseFaction01)  ; Blades
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction02)  ; Cultists
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction03)  ; Dark Brotherhood
		fRaceWeightSum += GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum += GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum += GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum += GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum += GetRaceWeight(NordRaceVampire)
		fRaceWeightSum += GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum += GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum += GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction04)  ; Dawnguard
		fRaceWeightSum -= GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum -= GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum -= GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum -= GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum -= GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum -= GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum -= GetRaceWeight(NordRaceVampire)
		fRaceWeightSum -= GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum -= GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum -= GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction05)  ; Forsworn
		fRaceWeightSum += GetRaceWeight(BretonRace)
		fRaceWeightSum -= GetRaceWeight(ArgonianRace)
		fRaceWeightSum -= GetRaceWeight(DarkElfRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		fRaceWeightSum -= GetRaceWeight(ImperialRace)
		fRaceWeightSum -= GetRaceWeight(KhajiitRace)
		fRaceWeightSum -= GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(OrcRace)
		fRaceWeightSum -= GetRaceWeight(RedguardRace)
		fRaceWeightSum -= GetRaceWeight(WoodElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction06)  ; Imperial Legion
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction07)  ; Morag Tong
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction08)  ; Penitus Oculatus
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction09)  ; Stormcloaks
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		fRaceWeightSum -= GetRaceWeight(ImperialRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction11)  ; Thalmor
		fRaceWeightSum += GetRaceWeight(HighElfRace)
		fRaceWeightSum += GetRaceWeight(WoodElfRace)
		fRaceWeightSum -= GetRaceWeight(ArgonianRace)
		fRaceWeightSum -= GetRaceWeight(BretonRace)
		fRaceWeightSum -= GetRaceWeight(DarkElfRace)
		fRaceWeightSum -= GetRaceWeight(KhajiitRace)
		fRaceWeightSum -= GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(OrcRace)
		fRaceWeightSum -= GetRaceWeight(RedguardRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction12)  ; Thieves Guild
		fRaceWeightSum += GetRaceWeight(ArgonianRace)
		fRaceWeightSum += GetRaceWeight(KhajiitRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction13)  ; Vigil of Stendarr
		fRaceWeightSum -= GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum -= GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum -= GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum -= GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum -= GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum -= GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum -= GetRaceWeight(NordRaceVampire)
		fRaceWeightSum -= GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum -= GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum -= GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction14)  ; Clan Volkihar
		fRaceWeightSum += GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum += GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum += GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum += GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum += GetRaceWeight(NordRaceVampire)
		fRaceWeightSum += GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum += GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum += GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction15)  ; Necromancers
		fRaceWeightSum += GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum += GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum += GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum += GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum += GetRaceWeight(NordRaceVampire)
		fRaceWeightSum += GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum += GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum += GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction16)  ; Vampires
		fRaceWeightSum += GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum += GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum += GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum += GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum += GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum += GetRaceWeight(NordRaceVampire)
		fRaceWeightSum += GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum += GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum += GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction17)  ; Werewolves
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction21)  ; Markarth Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(BretonRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction23)  ; Redoran Guard
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction25)  ; Solitude Guard
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		fRaceWeightSum -= GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction27)  ; Windhelm Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction29)  ; Daedric Influence
		fRaceWeightSum -= GetRaceWeight(ArgonianRace)
		fRaceWeightSum -= GetRaceWeight(BretonRace)
		fRaceWeightSum -= GetRaceWeight(DarkElfRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		fRaceWeightSum -= GetRaceWeight(ImperialRace)
		fRaceWeightSum -= GetRaceWeight(KhajiitRace)
		fRaceWeightSum -= GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(OrcRace)
		fRaceWeightSum -= GetRaceWeight(RedguardRace)
		fRaceWeightSum -= GetRaceWeight(WoodElfRace)
		fRaceWeightSum -= GetRaceWeight(ArgonianRaceVampire)
		fRaceWeightSum -= GetRaceWeight(BretonRaceVampire)
		fRaceWeightSum -= GetRaceWeight(DarkElfRaceVampire)
		fRaceWeightSum -= GetRaceWeight(HighElfRaceVampire)
		fRaceWeightSum -= GetRaceWeight(ImperialRaceVampire)
		fRaceWeightSum -= GetRaceWeight(KhajiitRaceVampire)
		fRaceWeightSum -= GetRaceWeight(NordRaceVampire)
		fRaceWeightSum -= GetRaceWeight(OrcRaceVampire)
		fRaceWeightSum -= GetRaceWeight(RedguardRaceVampire)
		fRaceWeightSum -= GetRaceWeight(WoodElfRaceVampire)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction30)  ; Alik'r Mercenaries
		fRaceWeightSum += GetRaceWeight(RedguardRace)
		fRaceWeightSum -= GetRaceWeight(ArgonianRace)
		fRaceWeightSum -= GetRaceWeight(BretonRace)
		fRaceWeightSum -= GetRaceWeight(DarkElfRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		fRaceWeightSum -= GetRaceWeight(ImperialRace)
		fRaceWeightSum -= GetRaceWeight(KhajiitRace)
		fRaceWeightSum -= GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(OrcRace)
		fRaceWeightSum -= GetRaceWeight(WoodElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction31)  ; Bandits
		fRaceWeightSum += GetRaceWeight(ArgonianRace)
		fRaceWeightSum += GetRaceWeight(BretonRace)
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(KhajiitRace)
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		fRaceWeightSum += GetRaceWeight(RedguardRace)
		fRaceWeightSum += GetRaceWeight(WoodElfRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		Return fRaceWeightSum
	EndIf

	Return 0.0
EndFunction


Float Function CalculateFactionEquipWeight(Faction akFaction)
	; Calculates the equipment score for player based on faction

	Bool[] _slotMasks = WhichSlotMasks(akFaction)

	Return CalculateEquipWeight(_slotMasks)
EndFunction


Float Function SumEquipWeight()
	; Calculates the equipment score for player

	If PlayerRef.IsInFaction(DisguiseFaction01)
		Return CalculateFactionEquipWeight(DisguiseFaction01)  ; Blades
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction02)
		Return CalculateFactionEquipWeight(DisguiseFaction02)  ; Cultists
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction03)
		Return CalculateFactionEquipWeight(DisguiseFaction03)  ; Dark Brotherhood
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction04)
		Return CalculateFactionEquipWeight(DisguiseFaction04)  ; Dawnguard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction05)
		Return CalculateFactionEquipWeight(DisguiseFaction05)  ; Forsworn
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction06)
		Return CalculateFactionEquipWeight(DisguiseFaction06)  ; Imperial Legion
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction07)
		Return CalculateFactionEquipWeight(DisguiseFaction07)  ; Morag Tong
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction08)
		Return CalculateFactionEquipWeight(DisguiseFaction08)  ; Penitus Oculatus
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction09)
		Return CalculateFactionEquipWeight(DisguiseFaction09)  ; Silver Hand
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction10)
		Return CalculateFactionEquipWeight(DisguiseFaction10)  ; Stormcloaks
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction11)
		Return CalculateFactionEquipWeight(DisguiseFaction11)  ; Thalmor
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction12)
		Return CalculateFactionEquipWeight(DisguiseFaction12)  ; Thieves Guild
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction13)
		Return CalculateFactionEquipWeight(DisguiseFaction13)  ; Vigil of Stendarr
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction14)
		Return CalculateFactionEquipWeight(DisguiseFaction14)  ; Volkihar Clan
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction15)
		Return CalculateFactionEquipWeight(DisguiseFaction15)  ; Necromancers
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction16)
		Return CalculateFactionEquipWeight(DisguiseFaction16)  ; Vampires
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction17)
		Return CalculateFactionEquipWeight(DisguiseFaction17)  ; Werewolves
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction18)
		Return CalculateFactionEquipWeight(DisguiseFaction18)  ; Companions
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction19)
		Return CalculateFactionEquipWeight(DisguiseFaction19)  ; Falkreath Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction20)
		Return CalculateFactionEquipWeight(DisguiseFaction20)  ; Hjaalmarch Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction21)
		Return CalculateFactionEquipWeight(DisguiseFaction21)  ; Markarth Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction22)
		Return CalculateFactionEquipWeight(DisguiseFaction22)  ; Pale Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction23)
		Return CalculateFactionEquipWeight(DisguiseFaction23)  ; Raven Rock Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction24)
		Return CalculateFactionEquipWeight(DisguiseFaction24)  ; Riften Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction25)
		Return CalculateFactionEquipWeight(DisguiseFaction25)  ; Solitude Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction26)
		Return CalculateFactionEquipWeight(DisguiseFaction26)  ; Whiterun Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction27)
		Return CalculateFactionEquipWeight(DisguiseFaction27)  ; Windhelm Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction28)
		Return CalculateFactionEquipWeight(DisguiseFaction28)  ; Winterhold Guard
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction29)
		Return CalculateFactionEquipWeight(DisguiseFaction29)  ; Daedric Influence
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction30)
		Return CalculateFactionEquipWeight(DisguiseFaction30)  ; Alik'r Mercenaries
	EndIf

	If PlayerRef.IsInFaction(DisguiseFaction31)
		Return CalculateFactionEquipWeight(DisguiseFaction31)  ; Bandits
	EndIf

	Return 0.0
EndFunction


Int Function Roll(Float afPenalty)
	; Returns dice roll or 100

	Float fDiscoverySum = 0.0
	fDiscoverySum += GetBestSkillWeight(afPenalty)
	fDiscoverySum += SumRaceWeight()
	fDiscoverySum += SumEquipWeight()

	If fDiscoverySum > 100.0
		Return 100
	EndIf

	Return Math.Floor((100.0 * fDiscoverySum) / 100.0)
EndFunction


Bool Function IsDisguiseActive()
	; Returns whether the disguise has been activated

	Int i = 0

	While i < DisguiseFactions.GetSize()
		Faction kDisguiseFaction = DisguiseFactions.GetAt(i) as Faction

		If kDisguiseFaction != None
			Faction kBaseFaction = BaseFactions.GetAt(i) as Faction

			If PlayerRef.IsInFaction(kDisguiseFaction) && ActorIsInFaction(NPC, kBaseFaction)
				Return True
			EndIf
		EndIf

		i += 1
	EndWhile

	Return False
EndFunction


Float Function QueryDistantLOSPenalty(Int aiLosType)
	; Returns the distant LOS penalty based on the min and max LOS distances
	;   akPenalty = GetDistantLOSPenalty(0.0, 512.0)
	;   Reminder: Penalty only affects skill contribution to identity score
	;   Note: The penalties "increase" from close to far because we multiply Value * Penalty (100 * 0.9 = 90)

	If aiLosType == 1
		Return Global_fLOSPenaltyClearMin.GetValue()
	EndIf

	If aiLosType == 2
		Return Global_fLOSPenaltyDistanceMid.GetValue()
	EndIf

	If aiLosType == 3
		Return Global_fLOSPenaltyDistanceFar.GetValue()
	EndIf

	Return 1.0
EndFunction


Float Function QueryMobilityMult()
	; Retrieves mobility bonus or penalty

	If PlayerRef.IsRunning() || PlayerRef.IsSprinting() || PlayerRef.IsSneaking() || PlayerRef.IsWeaponDrawn()
		Return Global_fMobilityPenalty.GetValue()
	EndIf

	Return Global_fMobilityBonus.GetValue()
EndFunction


Bool Function TryToDiscoverPlayer()
	; Returns whether PlayerRef was discovered by NPC

	If !NPC.HasLOS(PlayerRef)
		LogInfo("Cannot start rolling for discovery because " + NPC + " lost line of sight to Player")
		Return False
	EndIf

	Float fLightLevel = PlayerRef.GetLightLevel()

	Float fMaxDistance = (Global_fLOSDistanceMax.GetValue() * (fLightLevel / 100))

	Float fMaxHeadingAngle = Game.GetGameSettingFloat("fDetectionViewCone") / 2.0
	Float fMinHeadingAngle = Math.Abs(fMaxHeadingAngle) * -1.0

	If Global_fScriptSuspendTime.GetValue() > 0.0
		Float fDistanceToPlayer = NPC.GetDistance(PlayerRef)

		If (fDistanceToPlayer >= 0.0) && (fDistanceToPlayer <= fMaxDistance)
			If !PlayerRef.IsRunning() && !PlayerRef.IsSprinting() && !PlayerRef.IsSneaking() && !PlayerRef.IsWeaponDrawn()
				LogInfo("Player is being watched by " + NPC)
				NPC.SetLookAt(PlayerRef)

				DisguiseWarningSuspicious.Show()
				Suspend(Global_fScriptSuspendTime.GetValue())

				If !NPC.HasLOS(PlayerRef)
					LogInfo("Exiting early while rolling for discovery because " + NPC + " lost line of sight to Player")
					Return False
				EndIf
			EndIf
		EndIf
	EndIf

	Float fHeadingAngle = NPC.GetHeadingAngle(PlayerRef)

	If !(fHeadingAngle >= fMinHeadingAngle) || !(fHeadingAngle <= fMaxHeadingAngle)
		Return False
	EndIf

	Float fDistanceToPlayer = NPC.GetDistance(PlayerRef)

	If !(fDistanceToPlayer >= 0.0) || !(fDistanceToPlayer <= fMaxDistance)
		LogInfo("Exiting discovery roll because light-adjusted distance between " + NPC + " and Player is too great")
		Return False
	EndIf

	If !NPC.HasLOS(PlayerRef)
		LogInfo("Exiting discovery roll because " + NPC + " lost line of sight to Player")
		Return False
	EndIf

	Int   iLosType           = GetLosType(fDistanceToPlayer, fMaxDistance, fHeadingAngle, fMinHeadingAngle, fMaxHeadingAngle)
	Float fDistantLOSPenalty = QueryDistantLOSPenalty(iLosType)

	Int iDiceRollNPC    = Math.Floor(Utility.RandomInt(0, 99))
	Int iDiceRollPlayer = Roll(fDistantLOSPenalty)
	Float fMobilityMult = QueryMobilityMult()

	iDiceRollPlayer = Math.Floor(iDiceRollPlayer * fMobilityMult)

	If !(iDiceRollNPC > iDiceRollPlayer)
		LogInfo("Player won dice roll and escaped notice from " + NPC)
		Return False
	EndIf

	LogInfo("Player lost dice roll and was discovered by " + NPC)
	Return True
EndFunction


Bool Function TryRemoveMonitorAbility(String asLogMessage)
	If NPC.RemoveSpell(MonitorAbility)
		LogInfo(asLogMessage)
		NPC = None
		Return True
	EndIf
	Return False
EndFunction

; ===============================================================================
; EVENTS
; ===============================================================================

Event OnEffectStart(Actor akTarget, Actor akCaster)
	NPC = akTarget
	If akTarget.Is3DLoaded() && !akTarget.IsDead() && akTarget.HasSpell(MonitorAbility)
		RegisterForSingleUpdate(Global_fScriptUpdateFrequencyMonitor.GetValue())
	Else
		TryRemoveMonitorAbility("Detached monitor from " + akTarget + " because the NPC was not loaded and dead")
	EndIf
EndEvent


Event OnCellDetach()
	TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC's parent cell has been detached")
EndEvent


Event OnDetachedFromCell()
	TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC was detached from the cell")
EndEvent


Event OnUnload()
	TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC has been unloaded")
EndEvent


Event OnUpdate()
	If !NPC.HasSpell(MonitorAbility)
		LogInfo("Stopping monitor on " + NPC + " because the monitor ability was removed")
		NPC = None
		Return
	EndIf

	If NPC.IsDead()
		If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC is dead")
			Return
		EndIf
	EndIf

	; don't execute anything if the player has a menu open
	If !Utility.IsInMenuMode()
		; -----------------------------------------------------------------------
		; ERRANT HOSTILITY
		; -----------------------------------------------------------------------
		; no reason to call TryToDiscoverPlayer() if the actor is already hostile
		; -----------------------------------------------------------------------
		If !PlayerRef.IsDead() && !NPC.IsDead() && NPC.GetCombatTarget() == PlayerRef && !NPC.HasMagicEffect(FactionEnemyEffect)
			; player and npc must be in an appropriate disguise/base faction pair
			If IsDisguiseActive()
				; try to make the npc hostile
				If NPC.AddSpell(FactionEnemyAbility)
					LogInfo("Attached " + FactionEnemyAbility + " to " + NPC + " due to unknown hostility")
				EndIf
			EndIf
		EndIf

		; -----------------------------------------------------------------------
		; CORE LOOP
		; -----------------------------------------------------------------------
		If !PlayerRef.IsDead() && !NPC.IsDead()
			; NPC must satisfy various conditions before running expensive loops and math calculations
			If !NPC.IsHostileToActor(PlayerRef) && !NPC.HasMagicEffect(FactionEnemyEffect) && !NPC.IsInCombat() && NPC.HasLOS(PlayerRef) && PlayerRef.IsDetectedBy(NPC) && !NPC.IsAlerted() && !NPC.IsArrested() && !NPC.IsArrestingTarget() && !NPC.IsBleedingOut() && !NPC.IsCommandedActor() && !NPC.IsGhost() && !NPC.IsInKillMove() && !NPC.IsPlayerTeammate() && !NPC.IsTrespassing() && !NPC.IsUnconscious() && (NPC.GetSleepState() != 3) && (NPC.GetSleepState() != 4)
				; player and NPC must be in an appropriate disguise/base faction pair
				If IsDisguiseActive()
					; try to roll for detection
					If TryToDiscoverPlayer()
						; suspend for some amount of seconds, if global set
						If Global_fScriptSuspendTimeBeforeAttack.GetValue() > 0.0
							Suspend(Global_fScriptSuspendTimeBeforeAttack.GetValue())
						EndIf

						; ensure that the actor still has line of sight to the Player
						If NPC.HasLOS(PlayerRef)
							; try to make the npc hostile
							If NPC.AddSpell(FactionEnemyAbility)
								LogInfo("Attached " + FactionEnemyAbility + " to " + NPC + " who won detection roll")
								NPC.ClearLookAt()
							EndIf
						Else
							LogInfo("Discarded dice roll because " + NPC + " lost line of sight to Player")
							NPC.ClearLookAt()
						EndIf
					Else
						NPC.ClearLookAt()
					EndIf
				EndIf
			EndIf
		EndIf

		; extra performance management
		Suspend(Global_fScriptUpdateFrequencyMonitor.GetValue())
	EndIf

	If !NPC.Is3DLoaded()
		If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC is not loaded")
			Return
		EndIf
	EndIf

	If NPC.IsDead()
		If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC is dead")
			Return
		EndIf
	EndIf

	If PlayerRef.IsDead()
		If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the Player is dead")
			Return
		EndIf
	EndIf

	If NPC.GetDistance(PlayerRef) > Global_fScriptDistanceMax.GetValue()
		If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the Player is too far away")
			Return
		EndIf
	EndIf

	RegisterForSingleUpdate(Global_fScriptUpdateFrequencyMonitor.GetValue())
EndEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
	If akAggressor != PlayerRef as ObjectReference
		Return
	EndIf

	If PlayerRef.IsDead()
		Return
	EndIf

	If NPC
		If NPC.IsDead()
			Return
		EndIf

		If NPC.IsHostileToActor(PlayerRef)
			Return
		EndIf

		If NPC.HasMagicEffect(FactionEnemyEffect)
			Return
		EndIf
	EndIf

	If IsExcludedDamageSource(akSource)
		Return
	EndIf

	If NPC
		LogInfo(NPC + " was attacked by " + PlayerRef + " with " + akSource)

		NPC.StartCombat(PlayerRef)

		If NPC.AddSpell(FactionEnemyAbility)
			LogInfo("Attached " + FactionEnemyAbility + " to " + NPC + " who was hit by " + akAggressor)

			If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC was attacked by " + akAggressor)
				Return
			EndIf
		EndIf
	EndIf
EndEvent


Event OnDeath(Actor akKiller)
	If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC was killed by " + akKiller)
		Return
	EndIf
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the effect finished")
		Return
	EndIf
EndEvent
