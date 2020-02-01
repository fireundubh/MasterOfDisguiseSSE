ScriptName dubhApplyingEffectScript Extends ActiveMagicEffect

Import dubhUtilityScript

; =============================================================================
; PROPERTIES
; =============================================================================

GlobalVariable Property Global_fLOSDistanceMax Auto
GlobalVariable Property Global_iAlwaysSucceedDremora Auto
GlobalVariable Property Global_iAlwaysSucceedWerewolves Auto
GlobalVariable Property Global_iDiscoveryEnabled Auto
GlobalVariable Property Global_iPapyrusLoggingEnabled Auto

Actor Property PlayerRef Auto
FormList Property BaseFactions Auto
FormList Property ExcludedActors Auto
FormList Property ExcludedFactions Auto
Spell Property MonitorAbility Auto

; =============================================================================
; SCRIPT-LOCAL VARIABLES
; =============================================================================

Actor NPC

; =============================================================================
; FUNCTIONS
; =============================================================================

Function _Log(String asTextToPrint)
	If Global_iPapyrusLoggingEnabled.GetValue() as Bool
		Debug.Trace("Master of Disguise: dubhApplyingEffectScript> " + asTextToPrint)
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


Bool Function ActorIsExcludedByAnyKeyword(Actor akActor, FormList akKeywords)
	Int i = 0

	While i < akKeywords.GetSize()
		If akActor.HasKeyword(akKeywords.GetAt(i) as Keyword)
			Return True
		EndIf

		i += 1
	EndWhile

	Return False
EndFunction


Bool Function ActorIsInAnyBaseFaction(Actor akActor)
	Int i = 0
	
	While i < BaseFactions.GetSize()
		If ActorIsInFaction(akActor, BaseFactions.GetAt(i) as Faction)
			Return True
		EndIf
		i += 1
	EndWhile

	Return False
EndFunction


Bool Function ActorIsInAnyFaction(Actor akActor, FormList akFactions)
	Int i = 0

	While i < akFactions.GetSize()
		If ActorIsInFaction(akActor, akFactions.GetAt(i) as Faction)
			Return True
		EndIf

		i += 1
	EndWhile

	Return False
EndFunction

; =============================================================================
; EVENTS
; =============================================================================

Event OnEffectStart(Actor akTarget, Actor akCaster)
	NPC = akTarget

	If !(Global_iDiscoveryEnabled.GetValue() as Bool)
		NPC = None
		Return
	EndIf

	If PlayerRef.IsDead()
		NPC = None
		Return
	EndIf

	If NPC.IsDead()
		NPC = None
		Return
	EndIf

	If NPC.HasSpell(MonitorAbility)
		NPC = None
		Return
	EndIf

	If NPC.GetRelationshipRank(PlayerRef) > 0
		NPC = None
		Return
	EndIf

	If NPC.GetDistance(PlayerRef) > Global_fLOSDistanceMax.GetValue()
		NPC = None
		Return
	EndIf

	If Global_iAlwaysSucceedDremora.GetValue() as Bool && ActorIsInFaction(NPC, BaseFactions.GetAt(28) as Faction)
		NPC = None
		Return
	EndIf

	If Global_iAlwaysSucceedWerewolves.GetValue() as Bool && ActorIsInFaction(NPC, BaseFactions.GetAt(16) as Faction)
		NPC = None
		Return
	EndIf

	If ActorIsInAnyFaction(NPC, ExcludedFactions)
		NPC = None
		Return
	EndIf

	If ActorIsExcludedByAnyKeyword(NPC, ExcludedActors)
		NPC = None
		Return
	EndIf

	If !ActorIsInAnyBaseFaction(NPC)
		NPC = None
		Return
	EndIf

	If NPC.AddSpell(MonitorAbility)
		LogInfo("Attached monitor after satisfying all conditions to: " + NPC)
		NPC = None
	EndIf
EndEvent
