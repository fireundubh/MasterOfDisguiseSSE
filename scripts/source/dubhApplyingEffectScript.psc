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
FormList Property DisguiseFactions Auto
FormList Property ExcludedActors Auto
FormList Property ExcludedFactions Auto
Spell Property MonitorAbility Auto

; =============================================================================
; SCRIPT-LOCAL VARIABLES
; =============================================================================

Actor NPC
Bool[] FactionStatesPlayer
Bool[] FactionStatesTarget

; =============================================================================
; FUNCTIONS
; =============================================================================

Function _Log(String asTextToPrint, Int aiSeverity = 0)
  If Global_iPapyrusLoggingEnabled.GetValue() as Bool
    Debug.OpenUserLog("MasterOfDisguise")
    Debug.TraceUser("MasterOfDisguise", "dubhApplyingEffectScript> " + asTextToPrint, aiSeverity)
  EndIf
EndFunction


Function LogInfo(String asTextToPrint)
  _Log("[INFO] " + asTextToPrint, 0)
EndFunction


Function LogWarning(String asTextToPrint)
  _Log("[WARN] " + asTextToPrint, 1)
EndFunction


Function LogError(String asTextToPrint)
  _Log("[ERRO] " + asTextToPrint, 2)
EndFunction


Int Function FindActiveDisguise()
  ; Returns the index of the active disguise faction when player and NPC are in matching factions

  If !TurtleClub.ActorIsInAnyFaction(PlayerRef, DisguiseFactions)
    Return -1
  EndIf

  If NPC && !TurtleClub.ActorIsInAnyFaction(NPC, BaseFactions)
    Return -1
  EndIF

  Int i = 0

  While i < FactionStatesPlayer.Length && NPC
    If FactionStatesPlayer[i] && FactionStatesTarget[i]
      If NPC && TurtleClub.ActorIsInFaction(NPC, BaseFactions.GetAt(i) as Faction)
        Return i
      EndIf
    EndIf

    i += 1
  EndWhile

  Return -1
EndFunction

; =============================================================================
; EVENTS
; =============================================================================

Event OnEffectStart(Actor akTarget, Actor akCaster)
  NPC = akTarget

  If !(Global_iDiscoveryEnabled.GetValue() as Bool)
    LogInfo("Cannot attach monitor because the discovery system is disabled")
    NPC = None
    Return
  EndIf

  If !TurtleClub.ActorIsInAnyFaction(PlayerRef, DisguiseFactions)
    LogError(NPC + ": cannot attach monitor because Player is not in any disguise factions")
    NPC = None
    Return
  EndIf

  If NPC.HasSpell(MonitorAbility)
    LogError(NPC + ": cannot attach monitor because NPC monitor already attached")
    NPC = None
    Return
  EndIf

  If Global_iAlwaysSucceedDremora.GetValue() as Int == 1 && TurtleClub.ActorIsInFaction(NPC, BaseFactions.GetAt(28) as Faction)
    LogError(NPC + ": cannot attach monitor because NPC is a dremora and always succeed vs. dremora is enabled")
    NPC = None
    Return
  EndIf

  If Global_iAlwaysSucceedWerewolves.GetValue() as Int == 1 && TurtleClub.ActorIsInFaction(NPC, BaseFactions.GetAt(16) as Faction)
    LogError(NPC + ": cannot attach monitor because NPC is a werewolf and always succeed vs. werewolves is enabled")
    NPC = None
    Return
  EndIf

  If TurtleClub.ActorIsInAnyFaction(NPC, ExcludedFactions)
    LogError(NPC + ": cannot attach monitor because NPC is an excluded faction")
    NPC = None
    Return
  EndIf

  If TurtleClub.ActorHasAnyKeyword(NPC, ExcludedActors)
    LogError(NPC + ": cannot attach monitor because NPC has an excluded keyword")
    NPC = None
    Return
  EndIf

  If !TurtleClub.ActorIsInAnyFaction(NPC, BaseFactions)
    LogError(NPC + ": cannot attach monitor because NPC is not in any base factions")
    NPC = None
    Return
  EndIf

  FactionStatesPlayer = TurtleClub.GetFactionStates(PlayerRef, DisguiseFactions)
  FactionStatesTarget = TurtleClub.GetFactionStates(NPC, BaseFactions)

  If FindActiveDisguise() < 0
    LogError(NPC + ": cannot attach monitor because Player and NPC are not in matching factions")
    NPC = None
    Return
  EndIf

  If NPC.AddSpell(MonitorAbility)
    LogInfo(NPC + ": attached monitor after satisfying all conditions")
    NPC = None
    Return
  EndIf

  LogError(NPC + ": cannot attach monitor for reasons unknown")
  NPC = None
EndEvent
