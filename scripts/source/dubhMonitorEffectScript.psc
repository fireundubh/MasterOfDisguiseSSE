ScriptName dubhMonitorEffectScript Extends ActiveMagicEffect

Import dubhUtilityScript

; =============================================================================
; PROPERTIES
; =============================================================================

GlobalVariable Property Global_fBestSkillContribMax Auto
GlobalVariable Property Global_fLOSDistanceMax Auto
GlobalVariable Property Global_fFOVPenaltyClear Auto
GlobalVariable Property Global_fFOVPenaltyDistorted Auto
GlobalVariable Property Global_fFOVPenaltyPeripheral Auto
GlobalVariable Property Global_fLOSPenaltyFar Auto
GlobalVariable Property Global_fLOSPenaltyMid Auto
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
Faction Property PlayerFaction Auto
Formlist Property BaseFactions Auto
Formlist Property DisguiseFactions Auto
Formlist Property DisguiseFormlists Auto
Formlist Property DisguiseSlots Auto
Formlist Property ExcludedDamageSources Auto
GlobalVariable[] Property RaceWeights Auto
MagicEffect Property FactionEnemyEffect Auto
Message Property DisguiseWarningSuspicious Auto   ; "You are being watched..." (5 second delay)
Race[] Property Races Auto
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


Float Function GetBestSkillWeight()
	; Calculates the skill score for the player's best skill

	Float fBestSkillValue = GetBestSkill(PlayerRef)

	If fBestSkillValue > 100.0
		fBestSkillValue = 100.0
	EndIf

	Return ((Global_fBestSkillContribMax.GetValue() * fBestSkillValue) / 100.0)
EndFunction


Float Function GetRaceWeight(Race akRace)
	; Gets the actor's race, if the actor is in the associated faction, and returns
	;   the weight of the race on the chance to remain to undetected
	;   Ex: fDetectionWeight += GetRaceWeight(PlayerRef, CustomFaction11, HighElfRace, 20)

	Race kPlayerRace = PlayerRef.GetRace()

	If akRace != kPlayerRace
		Return 0.0
	EndIf

	Int iRaceIndex = Races.Find(akRace)

	If iRaceIndex < 0
		Return 0.0
	EndIf

	Return (RaceWeights[iRaceIndex] as GlobalVariable).GetValue()
EndFunction


Bool[] Function WhichSlotMasks_SKSE(Faction akFaction)
	Bool[] rgbSlotsEquipped = new Bool[10]

	Int iFactionIndex = DisguiseFactions.Find(akFaction)

	If iFactionIndex < 0
		LogError("Cannot find faction in factions formlist: " + akFaction)
		Return rgbSlotsEquipped
	EndIf

	Formlist currentDisguise = DisguiseFormlists.GetAt(iFactionIndex) as Formlist

	rgbSlotsEquipped[0] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000002) as Form) ; 0 Hair
	rgbSlotsEquipped[1] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000004) as Form) ; 1 Body
	rgbSlotsEquipped[2] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000008) as Form) ; 2 Hands
	rgbSlotsEquipped[3] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000020) as Form) ; 3 Amulet
	rgbSlotsEquipped[4] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000040) as Form) ; 4 Ring
	rgbSlotsEquipped[5] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000080) as Form) ; 5 Feet
	rgbSlotsEquipped[6] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00000200) as Form) ; 6 Shield
	rgbSlotsEquipped[7] = currentDisguise.HasForm(PlayerRef.GetWornForm(0x00001000) as Form) ; 7 Circlet
	rgbSlotsEquipped[8] = currentDisguise.HasForm(PlayerRef.GetEquippedWeapon(true) as Form) ; 8 Weapon - Left
	rgbSlotsEquipped[9] = currentDisguise.HasForm(PlayerRef.GetEquippedWeapon() as Form)     ; 9 Weapon - Right

	Return rgbSlotsEquipped
EndFunction


Float Function CalculateEquipWeight(Bool[] rgbEquippedSlots)
	; Returns the equipment score from worn items
	; 1. Get worn items
	; 2. Check if worn items are in formlist
	; 3. If worn items are in formlist, return those slots as Bool array

	Float fEquipScore = 0.0

	; Hair and Circlet
	If rgbEquippedSlots[0] || rgbEquippedSlots[7]
		; Both
		If rgbEquippedSlots[0] && rgbEquippedSlots[7]
			fEquipScore += Global_fSlotCirclet.GetValue()
		Else
			; Hair, but not Circlet
			If rgbEquippedSlots[0] && !rgbEquippedSlots[7]
				fEquipScore += Global_fSlotHair.GetValue()
			; Circlet, but not Hair
			Else
				fEquipScore += Global_fSlotCirclet.GetValue()
			EndIf
		EndIf
	EndIf

	If rgbEquippedSlots[1] ; Body
		fEquipScore += Global_fSlotBody.GetValue()
	EndIf

	If rgbEquippedSlots[2] ; Hands
		fEquipScore += Global_fSlotHands.GetValue()
	EndIf

	If rgbEquippedSlots[3] ; Amulet
		fEquipScore += Global_fSlotAmulet.GetValue()
	EndIf

	If rgbEquippedSlots[4] ; Ring
		fEquipScore += Global_fSlotRing.GetValue()
	EndIf

	If rgbEquippedSlots[5] ; Feet
		fEquipScore += Global_fSlotFeet.GetValue()
	EndIf

	If rgbEquippedSlots[6] ; Shield
		fEquipScore += Global_fSlotShield.GetValue()
	EndIf

	; Weapons Left and Right
	If rgbEquippedSlots[8] || rgbEquippedSlots[9]
		If rgbEquippedSlots[8]
			fEquipScore += Global_fSlotWeaponLeft.GetValue()
		ElseIf rgbEquippedSlots[9]
			fEquipScore += Global_fSlotWeaponRight.GetValue()
		EndIf
	EndIf

	If fEquipScore > 100.0
		Return 100.0
	EndIf

	Return fEquipScore
EndFunction


Float Function SumRaceWeight()
	; Calculates the race score for player based on faction

	Float fRaceWeightSum = 0.0

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(0) as Faction)  ; Blades
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(1) as Faction)  ; Cultists
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(2) as Faction)  ; Dark Brotherhood
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(3) as Faction)  ; Dawnguard
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(4) as Faction)  ; Forsworn
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(5) as Faction)  ; Imperial Legion
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(6) as Faction)  ; Morag Tong
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(7) as Faction)  ; Penitus Oculatus
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(8) as Faction)  ; Silver Hand
		fRaceWeightSum += GetRaceWeight(NordRace)
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(9) as Faction)  ; Stormcloaks
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		fRaceWeightSum -= GetRaceWeight(ImperialRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(10) as Faction)  ; Thalmor
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(11) as Faction)  ; Thieves Guild
		fRaceWeightSum += GetRaceWeight(ArgonianRace)
		fRaceWeightSum += GetRaceWeight(KhajiitRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(12) as Faction)  ; Vigil of Stendarr
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(13) as Faction)  ; Clan Volkihar
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(14) as Faction)  ; Necromancers
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(15) as Faction)  ; Vampires
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(16) as Faction)  ; Werewolves
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	; [17] Companions - no race bonuses or penalties because faction is members only

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(18) as Faction)  ; Falkreath Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(19) as Faction)  ; Hjaalmarch Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(20) as Faction)  ; Markarth Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(BretonRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(21) as Faction)  ; Pale Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(22) as Faction)  ; Raven Rock Guard
		fRaceWeightSum += GetRaceWeight(DarkElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(23) as Faction)  ; Riften Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(24) as Faction)  ; Solitude Guard
		fRaceWeightSum += GetRaceWeight(ImperialRace)
		fRaceWeightSum += GetRaceWeight(OrcRace)
		fRaceWeightSum -= GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(25) as Faction)  ; Whiterun Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(26) as Faction)  ; Windhelm Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		fRaceWeightSum -= GetRaceWeight(HighElfRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(27) as Faction)  ; Winterhold Guard
		fRaceWeightSum += GetRaceWeight(NordRace)
		Return fRaceWeightSum
	EndIf

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(28) as Faction)  ; Daedric Influence
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(29) as Faction)  ; Alik'r Mercenaries
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

	If PlayerRef.IsInFaction(DisguiseFactions.GetAt(30) as Faction)  ; Bandits
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

	Bool[] rgbSlotsEquipped = WhichSlotMasks_SKSE(akFaction)

	Return CalculateEquipWeight(rgbSlotsEquipped)
EndFunction


Float Function SumEquipWeight()
	; Calculates the equipment score for player

	Int i = 0

	While i < DisguiseFactions.GetSize()
		Faction kDisguiseFaction = DisguiseFactions.GetAt(i) as Faction

		If PlayerRef.IsInFaction(kDisguiseFaction)
			Return CalculateFactionEquipWeight(kDisguiseFaction)
		EndIf

		i += 1
	EndWhile

	Return 0.0
EndFunction


Float Function Roll()
	; Returns a value between 0.0 and 1.0 weighted by skill, race, and equipment

	Float result = 0.0
	result += GetBestSkillWeight()
	result += SumRaceWeight()
	result += SumEquipWeight()

	If result > 100.0
		Return 1.0
	EndIf

	Return Min(result * 0.01, 1.0)
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


Float Function QueryFOVPenalty(Int aiFovType)
	; Returns the FOV penalty to max FOV width (affects NPC roll)

	If aiFovType == 1 ; Clear
		Return Global_fFOVPenaltyClear.GetValue()
	EndIf

	If aiFovType == 2 ; Distorted
		Return Global_fFOVPenaltyDistorted.GetValue()
	EndIf

	If aiFovType == 3 ; Peripheral
		Return Global_fFOVPenaltyPeripheral.GetValue()
	EndIf

	Return 1.0
EndFunction


Float Function QueryLOSPenalty(Int aiLosType)
	; Returns the LOS penalty to max LOS distance (affects NPC roll)

	If aiLosType == 1 ; Near
		Return 1.0
	EndIf

	If aiLosType == 2 ; Mid
		Return Global_fLOSPenaltyMid.GetValue()
	EndIf

	If aiLosType == 3 ; Far
		Return Global_fLOSPenaltyFar.GetValue()
	EndIf

	Return 1.0
EndFunction


Float Function QueryMobilityMult()
	; Retrieves mobility bonus or penalty (affects Player roll)

	If PlayerRef.IsRunning() || PlayerRef.IsSprinting() || PlayerRef.IsSneaking() || PlayerRef.IsWeaponDrawn()
		Return Global_fMobilityPenalty.GetValue()
	EndIf

	Return Global_fMobilityBonus.GetValue()
EndFunction


Bool Function TryToDiscoverPlayer()
	; Returns whether PlayerRef was discovered by NPC

	If !NPC
		Return False
	EndIf

	If NPC && !NPC.HasLOS(PlayerRef)
		LogInfo("Cannot start rolling for discovery because " + NPC + " lost line of sight to Player")
		Return False
	EndIf

	Float fLightLevel = PlayerRef.GetLightLevel()

	Float fMaxDistance = (Global_fLOSDistanceMax.GetValue() * (fLightLevel / 100))

	If Global_fScriptSuspendTime.GetValue() > 0.0
		Float fDistanceToPlayer = NPC.GetDistance(PlayerRef)

		If InFloatRange(fDistanceToPlayer, 0.0, fMaxDistance)
			If !PlayerRef.IsRunning() && !PlayerRef.IsSprinting() && !PlayerRef.IsSneaking() && !PlayerRef.IsWeaponDrawn()
				LogInfo("Player is being watched by " + NPC)
				NPC.SetLookAt(PlayerRef)

				DisguiseWarningSuspicious.Show()
				Suspend(Global_fScriptSuspendTime.GetValue())

				If NPC && !NPC.HasLOS(PlayerRef)
					LogInfo("Exiting early while rolling for discovery because " + NPC + " lost line of sight to Player")
					Return False
				EndIf
			EndIf
		EndIf
	EndIf

	Float fMaxHeadingAngle = Game.GetGameSettingFloat("fDetectionViewCone")

	Float fHeadingAngle = NPC.GetHeadingAngle(PlayerRef)

	If !InFloatRange(fHeadingAngle, Math.Abs(fMaxHeadingAngle) * -1.0, fMaxHeadingAngle)
		LogInfo("Exiting discovery roll because Player is outside " + NPC + "'s detection view cone")
		Return False
	EndIf

	Float fDistanceToPlayer = NPC.GetDistance(PlayerRef)

	If !InFloatRange(fDistanceToPlayer, 0.0, fMaxDistance)
		LogInfo("Exiting discovery roll because light-adjusted distance between " + NPC + " and Player is too great")
		Return False
	EndIf

	If NPC && !NPC.HasLOS(PlayerRef)
		LogInfo("Exiting discovery roll because " + NPC + " lost line of sight to Player")
		Return False
	EndIf

	Int iFovType = GetFovType(fHeadingAngle, fMaxHeadingAngle)
	Int iLosType = GetLosType(fDistanceToPlayer, fMaxDistance)

	Float fFOVPenalty   = QueryFOVPenalty(iFovType)
	Float fLOSPenalty   = QueryLOSPenalty(iLosType)

	Float fDiceRollNPC    = Utility.RandomFloat(0.0, 1.0)
	Float fDiceRollPlayer = Roll()

	; Adjustments
	Float fMobilityMult = QueryMobilityMult()
	fDiceRollPlayer = fDiceRollPlayer * fMobilityMult

	fDiceRollNPC *= fFOVPenalty
	fDiceRollNPC /= fLOSPenalty + 1

	If fDiceRollPlayer > fDiceRollNPC
		LogInfo("Player won dice roll and escaped notice from " + NPC)
		Return False
	EndIf

	LogInfo("Player lost dice roll and was discovered by " + NPC)
	Return True
EndFunction


Bool Function TryRemoveMonitorAbility(String asLogMessage)
	If NPC && MonitorAbility && NPC.RemoveSpell(MonitorAbility)
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
	If NPC && !NPC.HasSpell(MonitorAbility)
		LogInfo("Stopping monitor on " + NPC + " because the monitor ability was removed")
		NPC = None
		Return
	EndIf

	If NPC && NPC.IsDead()
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
		If NPC && !PlayerRef.IsDead() && !NPC.IsDead() && NPC.GetCombatTarget() == PlayerRef && !NPC.HasMagicEffect(FactionEnemyEffect)
			; player and npc must be in an appropriate disguise/base faction pair
			If IsDisguiseActive()
				; try to make the npc hostile
				If NPC && NPC.AddSpell(FactionEnemyAbility)
					LogInfo("Attached " + FactionEnemyAbility + " to " + NPC + " due to unknown hostility")
				EndIf
			EndIf
		EndIf

		; -----------------------------------------------------------------------
		; CORE LOOP
		; -----------------------------------------------------------------------
		If NPC && !PlayerRef.IsDead() && !NPC.IsDead()
			; NPC must satisfy various conditions before running expensive loops and math calculations
			If NPC && !NPC.IsHostileToActor(PlayerRef) && !NPC.HasMagicEffect(FactionEnemyEffect) && !NPC.IsInCombat() && NPC.HasLOS(PlayerRef) && PlayerRef.IsDetectedBy(NPC) && !NPC.IsAlerted() && !NPC.IsArrested() && !NPC.IsArrestingTarget() && !NPC.IsBleedingOut() && !NPC.IsCommandedActor() && !NPC.IsGhost() && !NPC.IsInKillMove() && !NPC.IsPlayerTeammate() && !NPC.IsTrespassing() && !NPC.IsUnconscious() && (NPC.GetSleepState() != 3) && (NPC.GetSleepState() != 4)
				; player and NPC must be in an appropriate disguise/base faction pair
				If IsDisguiseActive()
					; try to roll for detection
					If TryToDiscoverPlayer()
						; suspend for some amount of seconds, if global set
						If Global_fScriptSuspendTimeBeforeAttack.GetValue() > 0.0
							Suspend(Global_fScriptSuspendTimeBeforeAttack.GetValue())
						EndIf

						; ensure that the actor still has line of sight to the Player
						If NPC && NPC.HasLOS(PlayerRef)
							; try to make the npc hostile
							If NPC && NPC.AddSpell(FactionEnemyAbility)
								LogInfo("Attached " + FactionEnemyAbility + " to " + NPC + " who won detection roll")
								NPC.ClearLookAt()
							EndIf
						Else
							If NPC
								LogInfo("Discarded dice roll because " + NPC + " lost line of sight to Player")
								NPC.ClearLookAt()
							EndIf
						EndIf
					Else
						If NPC
							NPC.ClearLookAt()
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		; extra performance management
		Suspend(Global_fScriptUpdateFrequencyMonitor.GetValue())
	EndIf

	If NPC && !NPC.Is3DLoaded()
		If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC is not loaded")
			Return
		EndIf
	EndIf

	If NPC && NPC.IsDead()
		If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC is dead")
			Return
		EndIf
	EndIf

	If PlayerRef.IsDead()
		If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the Player is dead")
			Return
		EndIf
	EndIf

	If NPC && (NPC.GetDistance(PlayerRef) > Global_fScriptDistanceMax.GetValue())
		If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the Player is too far away")
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

	If NPC && NPC.IsDead()
		Return
	EndIf

	If NPC && NPC.IsHostileToActor(PlayerRef)
		Return
	EndIf

	If NPC && NPC.HasMagicEffect(FactionEnemyEffect)
		Return
	EndIf

	If ExcludedDamageSources.HasForm(akSource)
		Return
	EndIf

	If !NPC
		Return
	EndIf

	If NPC
		LogInfo(NPC + " was attacked by " + PlayerRef + " with " + akSource)
	EndIf

	If NPC
		NPC.StartCombat(PlayerRef)
	EndIf

	If NPC && FactionEnemyAbility && NPC.AddSpell(FactionEnemyAbility)
		LogInfo("Attached " + FactionEnemyAbility + " to " + NPC + " who was hit by " + akAggressor)

		If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC was attacked by " + akAggressor)
			Return
		EndIf
	EndIf
EndEvent


Event OnDeath(Actor akKiller)
	If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the NPC was killed by " + akKiller)
		Return
	EndIf
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If NPC && TryRemoveMonitorAbility("Detached monitor from " + NPC + " because the effect finished")
		Return
	EndIf
EndEvent
