ScriptName dubhPlayerScript Extends ReferenceAlias

Import dubhUtilityScript

; =============================================================================
; PROPERTIES
; =============================================================================

GlobalVariable Property Global_iCloakEnabled Auto
GlobalVariable Property Global_iDisguiseEnabledBandit Auto
GlobalVariable Property Global_iDisguiseEquippedVampire Auto
GlobalVariable Property Global_iDisguiseEssentialSlotBandit Auto
GlobalVariable Property Global_iFactionsUpdateAutoRun Auto
GlobalVariable Property Global_iFactionsUpdateCompleted Auto
GlobalVariable Property Global_iNotifyEnabled Auto
GlobalVariable Property Global_iPapyrusLoggingEnabled Auto
GlobalVariable Property Global_iTutorialCompleted Auto
GlobalVariable Property Global_iVampireNightOnly Auto
GlobalVariable Property Global_iVampireNightOnlyDayHourBegin Auto
GlobalVariable Property Global_iVampireNightOnlyDayHourEnd Auto

Actor Property PlayerRef Auto
Spell Property CloakAbility Auto

; FormLists
FormList Property BaseFactions Auto
FormList Property DisguiseFactions Auto
FormList Property DisguiseFormlists Auto
FormList Property DisguiseMessageOff Auto
FormList Property DisguiseMessageOn Auto
FormList Property DisguiseNotifyOff Auto
FormList Property DisguiseNotifyOn Auto
FormList Property DisguiseSlots Auto

; States
Bool[] Property ArrayDisguisesEnabled Auto

; Other Arrays
Int[] Property ArrayDisguisesVampire Auto
Int[] Property VsArrayExclusionsVigilOfStendarr Auto
Int[] Property VsArrayExclusionsWindhelmGuard Auto

Message[] Property MessageChain Auto


; =============================================================================
; SCRIPT-LOCAL VARIABLES
; =============================================================================

; Slot Masks
Int iHair    = 31 ; 0x00000002
Int iBody    = 32 ; 0x00000004
Int iHands   = 33 ; 0x00000008
Int iAmulet  = 35 ; 0x00000020
Int iRing    = 36 ; 0x00000040
Int iFeet    = 37 ; 0x00000080
Int iShield  = 39 ; 0x00000200
Int iCirclet = 42 ; 0x00001000

; =============================================================================
; FUNCTIONS
; =============================================================================

Function _Log(String asTextToPrint)
	If Global_iPapyrusLoggingEnabled.GetValue() as Bool
		Debug.Trace("Master of Disguise: dubhPlayerScript> " + asTextToPrint)
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


Bool Function CanDisguiseActivate(Int aiFactionIndex)
	; Returns TRUE if the disguise can be activated without conflicts (mutually exclusive disguises)

	If aiFactionIndex == 1 || aiFactionIndex == 4 || aiFactionIndex == 8
		; Cultists vs. Vigil of Stendarr
		If aiFactionIndex == 1 && ArrayDisguisesEnabled[12]
			Return False
		EndIf

		; Forsworn vs. Windhelm Guard
		If aiFactionIndex == 4 && ArrayDisguisesEnabled[26]
			Return False
		EndIf

		; Silver Hand
		If aiFactionIndex == 8
			; Silver Hand vs. Werewolves
			If ArrayDisguisesEnabled[16]
				Return False
			EndIf

			; Silver Hand vs. The Companions
			If ArrayDisguisesEnabled[17]
				Return False
			EndIf

			; Silver Hand vs. Bandits
			If ArrayDisguisesEnabled[30]
				Return False
			EndIf
		EndIf
	EndIf

	; VsArrayExclusionsVigilOfStendarr
	If ArrayDisguisesEnabled[12] && VsArrayExclusionsVigilOfStendarr.Find(aiFactionIndex) > -1
		Return False
	EndIf

	; Vigil of Stendarr
	If aiFactionIndex == 12
		; Vigil of Stendarr vs. Cultists
		If ArrayDisguisesEnabled[1]
			Return False
		EndIf

		; Vigil of Stendarr vs. Clan Volkihar
		If ArrayDisguisesEnabled[13]
			Return False
		EndIf

		; Vigil of Stendarr vs. Necromancers
		If ArrayDisguisesEnabled[14]
			Return False
		EndIf

		; Vigil of Stendarr vs. Vampires
		If ArrayDisguisesEnabled[15]
			Return False
		EndIf

		; Vigil of Stendarr vs. Werewolves
		If ArrayDisguisesEnabled[16]
			Return False
		EndIf

		; Vigil of Stendarr vs. The Companions
		If ArrayDisguisesEnabled[17]
			Return False
		EndIf

		; Vigil of Stendarr vs. Daedric Influence
		If ArrayDisguisesEnabled[28]
			Return False
		EndIf
	EndIf

	; VsArrayExclusionsWindhelmGuard
	If ArrayDisguisesEnabled[26] && VsArrayExclusionsWindhelmGuard.Find(aiFactionIndex) > -1
		Return False
	EndIf

	; Windhelm Guard
	If aiFactionIndex == 26
		; Windhelm Guard vs. Forsworn
		If ArrayDisguisesEnabled[4]
			Return False
		EndIf

		; Windhelm Guard vs. Falkreath Guard
		If ArrayDisguisesEnabled[18]
			Return False
		EndIf

		; Windhelm Guard vs. Hjaalmarch Guard
		If ArrayDisguisesEnabled[19]
			Return False
		EndIf

		; Windhelm Guard vs. Markarth Guard
		If ArrayDisguisesEnabled[20]
			Return False
		EndIf

		; Windhelm Guard vs. Pale Guard
		If ArrayDisguisesEnabled[21]
			Return False
		EndIf

		; Windhelm Guard vs. Raven Rock Guard
		If ArrayDisguisesEnabled[22]
			Return False
		EndIf

		; Windhelm Guard vs. Riften Guard
		If ArrayDisguisesEnabled[23]
			Return False
		EndIf

		; Windhelm Guard vs. Solitude Guard
		If ArrayDisguisesEnabled[24]
			Return False
		EndIf

		; Windhelm Guard vs. Whiterun Guard
		If ArrayDisguisesEnabled[25]
			Return False
		EndIf

		; Windhelm Guard vs. Winterhold Guard
		If ArrayDisguisesEnabled[27]
			Return False
		EndIf

		; Windhelm Guard vs. Bandits
		If ArrayDisguisesEnabled[30]
			Return False
		EndIf
	EndIf

	If aiFactionIndex == 27 || aiFactionIndex == 28
		; Winterhold Guard vs. Windhelm Guard
		If aiFactionIndex == 27 && ArrayDisguisesEnabled[26]
			Return False
		EndIf

		; Daedric Influence vs. Vigil of Stendarr
		If aiFactionIndex == 28 && ArrayDisguisesEnabled[12]
			Return False
		EndIf
	EndIf

	; Bandits
	If aiFactionIndex == 30
		; Bandits can be toggled on/off through MCM
		If !(Global_iDisguiseEnabledBandit.GetValue() as Bool)
			Return False
		EndIf

		; Bandits vs. Silver Hand
		If ArrayDisguisesEnabled[8]
			Return False
		EndIf

		; Bandits vs. Windhelm Guard
		If ArrayDisguisesEnabled[26]
			Return False
		EndIf
	EndIf

	Return True
EndFunction


Bool[] Function GetPossibleDisguisesByForm(Form akBaseObject)
	Bool[] rgbPossibleDisguises = new Bool[31]

	Int i = 0

	While i < DisguiseFormlists.GetSize()
		rgbPossibleDisguises[i] = (DisguiseFormlists.GetAt(i) as FormList).HasForm(akBaseObject)
		i += 1
	EndWhile

	Return rgbPossibleDisguises
EndFunction


Bool Function EssentialGearIsEquipped(Int aiFactionIndex, FormList akCurrentDisguise)
	Bool bDaedricResult = False

	Form kWornForm = None

	If aiFactionIndex == 1 || aiFactionIndex == 8 || aiFactionIndex == 12 || aiFactionIndex == 26 || aiFactionIndex == 28 || aiFactionIndex == 30
		; Cultists
		If aiFactionIndex == 1
			kWornForm = PlayerRef.GetWornForm(0x00001000) as Form

		; Silver Hand
		ElseIf aiFactionIndex == 8
			kWornForm = PlayerRef.GetWornForm(0x00000040) as Form

		 ; Vigil of Stendarr
		ElseIf aiFactionIndex == 12
			kWornForm = PlayerRef.GetWornForm(0x00000020) as Form

		 ; Windhelm Guard
		ElseIf aiFactionIndex == 26
			kWornForm = PlayerRef.GetWornForm(0x00000200) as Form

		; Daedric Influence
		ElseIf aiFactionIndex == 28
			; When Daedric gear is equipped in ANY slot, that's enough to match.

			Bool[] rgbDaedricWornForms = new Bool[10]

			rgbDaedricWornForms[0] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000002) as Form) ; 0 Hair
			rgbDaedricWornForms[1] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000004) as Form) ; 1 Body
			rgbDaedricWornForms[2] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000008) as Form) ; 2 Hands
			rgbDaedricWornForms[3] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000020) as Form) ; 3 Amulet
			rgbDaedricWornForms[4] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000040) as Form) ; 4 Ring
			rgbDaedricWornForms[5] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000080) as Form) ; 5 Feet
			rgbDaedricWornForms[6] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00000200) as Form) ; 6 Shield
			rgbDaedricWornForms[7] = akCurrentDisguise.HasForm(PlayerRef.GetWornForm(0x00001000) as Form) ; 7 Circlet
			rgbDaedricWornForms[8] = akCurrentDisguise.HasForm(PlayerRef.GetEquippedWeapon(true) as Form) ; 8 Weapon - Left
			rgbDaedricWornForms[9] = akCurrentDisguise.HasForm(PlayerRef.GetEquippedWeapon() as Form)     ; 9 Weapon - Right

			bDaedricResult = rgbDaedricWornForms.Find(True) > -1

		; Bandits
		ElseIf aiFactionIndex == 30
			; The essential slot for Bandits is configurable because this disguise can be disabled.
			Int iSlot = Global_iDisguiseEssentialSlotBandit.GetValueInt()

			If iSlot == 0
				kWornForm = PlayerRef.GetWornForm(0x00000002) as Form
			ElseIf iSlot == 1
				kWornForm = PlayerRef.GetWornForm(0x00000004) as Form
			ElseIf iSlot == 2
				kWornForm = PlayerRef.GetWornForm(0x00000008) as Form
			ElseIf iSlot == 3
				kWornForm = PlayerRef.GetWornForm(0x00000020) as Form
			ElseIf iSlot == 4
				kWornForm = PlayerRef.GetWornForm(0x00000040) as Form
			ElseIf iSlot == 5
				kWornForm = PlayerRef.GetWornForm(0x00000080) as Form
			ElseIf iSlot == 6
				kWornForm = PlayerRef.GetWornForm(0x00000200) as Form
			ElseIf iSlot == 7
				kWornForm = PlayerRef.GetWornForm(0x00001000) as Form
			ElseIf iSlot == 8
				kWornForm = PlayerRef.GetEquippedWeapon(True) as Form
			ElseIf iSlot == 9
				kWornForm = PlayerRef.GetEquippedWeapon() as Form
			Else
				kWornForm = PlayerRef.GetWornForm(0x00000004) as Form
			EndIf
		EndIf
	Else
		kWornForm = PlayerRef.GetWornForm(0x00000004) as Form
	EndIf

	If aiFactionIndex == 28
		Return bDaedricResult
	EndIf

	Return kWornForm && akCurrentDisguise.HasForm(kWornForm)
EndFunction


Function ShowMessageChain()
	Int i = 0

	While i < MessageChain.Length
		Message kMessage = MessageChain[i] as Message

		If !(kMessage.Show() == 0)
			Return
		EndIf

		i += 1
	EndWhile

	Global_iTutorialCompleted.SetValueInt(1)
EndFunction


Function EnableDisguise(Int aiFactionIndex)
	Message kMessage = None

	If Global_iNotifyEnabled.GetValue() as Bool
		kMessage = DisguiseNotifyOn.GetAt(aiFactionIndex) as Message
	Else
		kMessage = DisguiseMessageOn.GetAt(aiFactionIndex) as Message
	EndIf

	kMessage.Show()

	ArrayDisguisesEnabled[aiFactionIndex] = True
	LogInfo("Enabled disguise: aiFactionIndex = " + aiFactionIndex)
EndFunction


Function DisableDisguise(Int aiFactionIndex)
	Message kMessage = None

	If Global_iNotifyEnabled.GetValue() as Bool
		kMessage = DisguiseNotifyOff.GetAt(aiFactionIndex) as Message
	Else
		kMessage = DisguiseMessageOff.GetAt(aiFactionIndex) as Message
	EndIf

	kMessage.Show()

	ArrayDisguisesEnabled[aiFactionIndex] = False
	LogInfo("Disabled disguise: aiFactionIndex = " + aiFactionIndex)
EndFunction


Function AddDisguise(Int aiFactionIndex)
	Faction kDisguiseFaction = DisguiseFactions.GetAt(aiFactionIndex) as Faction

	If PlayerRef.IsInFaction(kDisguiseFaction)
		LogWarning("Cannot add disguise because player is in disguise faction: kDisguiseFaction = " + kDisguiseFaction)
		Return
	EndIf

	If TryAddToFaction(PlayerRef, kDisguiseFaction)
		LogInfo("Added player to disguise faction: " + kDisguiseFaction)

		EnableDisguise(aiFactionIndex)

		If !(Global_iTutorialCompleted.GetValue() as Bool)
			ShowMessageChain()
		EndIf

		; TODO: if faction is a guard disguise, save bounties to crime gold arrays and clear actual crime gold
		;If InRange(aiFactionIndex, 18, 27)
			; save bounties to crime gold arrays
			; clear actual crime gold
		;EndIf
	EndIf
EndFunction


Function TryAddDisguise(Int aiFactionIndex)
	If ArrayDisguisesEnabled.Find(True) > -1
		LogWarning("Cannot add disguise because player has an enabled disguise: aiFactionIndex = " + aiFactionIndex)
		Return
	EndIf

	If ArrayDisguisesEnabled[aiFactionIndex]
		LogWarning("Cannot add disguise because disguise is already enabled: aiFactionIndex = " + aiFactionIndex)
		Return
	EndIf

	Faction kBaseFaction = BaseFactions.GetAt(aiFactionIndex) as Faction
	If ActorIsInFaction(PlayerRef, kBaseFaction)
		LogWarning("Cannot add disguise because player is in base faction: aiFactionIndex = " + aiFactionIndex)
		Return
	EndIf

	Faction kDisguiseFaction = DisguiseFactions.GetAt(aiFactionIndex) as Faction
	If PlayerRef.IsInFaction(kDisguiseFaction)
		LogWarning("Cannot add disguise because player is in disguise faction: " + kDisguiseFaction)
		Return
	EndIf

	If !CanDisguiseActivate(aiFactionIndex)
		LogWarning("Cannot add disguise because disguise cannot be activated: aiFactionIndex = " + aiFactionIndex)
		Return
	EndIf

	Bool bVampireDisguise  = ArrayDisguisesVampire.Find(aiFactionIndex) > -1
	Bool bEquippedSlotMask = EssentialGearIsEquipped(aiFactionIndex, DisguiseFormlists.GetAt(aiFactionIndex) as FormList)

	; for vampire night only feature
	If bVampireDisguise
		If bEquippedSlotMask
			Global_iDisguiseEquippedVampire.SetValueInt(aiFactionIndex)
		Else
			Global_iDisguiseEquippedVampire.SetValueInt(0)
		EndIf
	EndIf

	If bVampireDisguise
		If Global_iVampireNightOnly.GetValue() as Bool
			If IsDay(Global_iVampireNightOnlyDayHourBegin, Global_iVampireNightOnlyDayHourEnd)
				LogWarning("Vampire disguise can be activated at night only because day/night mode is enabled.")
				Return
			EndIf
		EndIf
	EndIf

	If bEquippedSlotMask && !ArrayDisguisesEnabled[aiFactionIndex]
		AddDisguise(aiFactionIndex)
	EndIf
EndFunction


Function RemoveDisguise(Int aiFactionIndex)
	Faction kDisguiseFaction = DisguiseFactions.GetAt(aiFactionIndex) as Faction

	If !PlayerRef.IsInFaction(kDisguiseFaction)
		LogWarning("Cannot remove disguise because player is not in disguise faction: kDisguiseFaction = " + kDisguiseFaction)
		Return
	EndIf

	If TryRemoveFromFaction(PlayerRef, kDisguiseFaction)
		LogInfo("Removed player from disguise faction: kDisguiseFaction = " + kDisguiseFaction)

		DisableDisguise(aiFactionIndex)

		; TODO: if faction is a guard disguise, restore bounties and clear crime gold arrays
		;If InRange(aiFactionIndex, 18, 27)
			; restore bounties
			; clear crime gold arrays
		;EndIf
	EndIf
EndFunction


Function TryRemoveDisguise(Int aiFactionIndex)
	If ArrayDisguisesEnabled.Find(True) < 0
		LogWarning("Cannot remove disguise because player has no enabled disguises: aiFactionIndex = " + aiFactionIndex)
		Return
	EndIf

	Faction kDisguiseFaction = DisguiseFactions.GetAt(aiFactionIndex) as Faction

	If aiFactionIndex == 30 && !(Global_iDisguiseEnabledBandit.GetValue() as Bool)
		RemoveDisguise(aiFactionIndex)
		LogWarning("Removed bandit disguise because bandit disguise is disabled.")
		Return
	EndIf

	Bool bVampireDisguise = ArrayDisguisesVampire.Find(aiFactionIndex) > -1

	If bVampireDisguise
		If Global_iVampireNightOnly.GetValue() as Bool
			If IsDay(Global_iVampireNightOnlyDayHourBegin, Global_iVampireNightOnlyDayHourEnd)
				RemoveDisguise(aiFactionIndex)
				LogWarning("Removed vampire disguise because vampire disguise day/night mode is enabled.")
				Return
			EndIf
		EndIf
	EndIf

	If ArrayDisguisesEnabled[aiFactionIndex]
		If EssentialGearIsEquipped(aiFactionIndex, DisguiseFormlists.GetAt(aiFactionIndex) as FormList)
			;LogWarning("Cannot remove disguise because essential gear is still equipped: aiFactionIndex = " + aiFactionIndex)
			Return
		EndIf

		RemoveDisguise(aiFactionIndex)

		; for vampire night only feature
		If bVampireDisguise
			Global_iDisguiseEquippedVampire.SetValueInt(aiFactionIndex)
		EndIf
	EndIf
EndFunction


Function UpdateDisguise(Int aiFactionIndex)  ; used in event scope
	TryAddDisguise(aiFactionIndex)
	TryRemoveDisguise(aiFactionIndex)
EndFunction


Function TryUpdateDisguise(Form akBaseObject)  ; used in event scope
	; Attempts to update disguise and base faction memberships

	Int iCycles = 0
	While Utility.IsInMenuMode()
		iCycles += 1
	EndWhile

	Bool[] rgbPossibleDisguises = GetPossibleDisguisesByForm(akBaseObject)

	If rgbPossibleDisguises.Find(True) == -1
		LogWarning("Cannot update disguise because form not associated with disguise: " + akBaseObject)
		Return
	EndIf

	Int i = 0

	While i < rgbPossibleDisguises.Length
		If rgbPossibleDisguises[i]
			UpdateDisguise(i)
		EndIf
		i += 1
	EndWhile
EndFunction

; =============================================================================
; EVENTS
; =============================================================================

Event OnInit()
	RegisterForSingleUpdate(1.0)
EndEvent


Event OnPlayerLoadGame()
	If Global_iFactionsUpdateAutoRun.GetValue() as Bool
		Global_iFactionsUpdateCompleted.SetValueInt(0)
	EndIf
	RegisterForSingleUpdate(1.0)
EndEvent


Event OnCellLoad()
	RegisterForSingleUpdate(1.0)
EndEvent


Event OnUpdate()
	If !PlayerRef.IsInCombat()
		If Global_iCloakEnabled.GetValue() as Bool
			If !PlayerRef.HasSpell(CloakAbility)
				PlayerRef.AddSpell(CloakAbility, False)
				Utility.Wait(1.0)
				PlayerRef.RemoveSpell(CloakAbility)
			EndIf
		EndIf

		; for vampire night only feature
		; try to add vampire disguise, needed for day/night cycle
		Int iVampireDisguiseIndex = Global_iDisguiseEquippedVampire.GetValueInt()

		If ArrayDisguisesVampire.Find(iVampireDisguiseIndex) > -1
			UpdateDisguise(iVampireDisguiseIndex)
		EndIf
	EndIf

	RegisterForSingleUpdate(4.0)
EndEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Int iCycles = 0

	While Utility.IsInMenuMode() || PlayerRef.IsInCombat()
		iCycles += 1
	EndWhile

	Utility.Wait(1.0)

	If akBaseObject
		LogInfo("Trying to update disguise because the player equipped: " + akBaseObject)
		TryUpdateDisguise(akBaseObject)
	EndIf
EndEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Int iCycles = 0

	While Utility.IsInMenuMode() || PlayerRef.IsInCombat()
		iCycles += 1
	EndWhile

	If akBaseObject
		LogInfo("Trying to update disguise because the player unequipped: " + akBaseObject)
		TryUpdateDisguise(akBaseObject)
	EndIf
EndEvent
