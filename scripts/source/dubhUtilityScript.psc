ScriptName dubhUtilityScript


Bool Function TryAddToFaction(Actor akActor, Faction akFaction) Global
  If !akActor.IsInFaction(akFaction)
    akActor.AddToFaction(akFaction)
  EndIf
  Return akActor.IsInFaction(akFaction)
EndFunction


Bool Function TryRemoveFromFaction(Actor akActor, Faction akFaction) Global
  If akActor.IsInFaction(akFaction)
    akActor.RemoveFromFaction(akFaction)
  EndIf
  Return !akActor.IsInFaction(akFaction)
EndFunction

; =============================================================================
; Used in:
; - dubhMonitorEffectScript
; =============================================================================

Float Function GetBestSkill(Actor akActor) Global
  ; Gets the actor's best skill, either Sneak or Illusion, and returns the weight
  ;   of the best skill on the chance to remain undetected
  ;   Ex: fDetectionWeight += GetBestSkillWeight(PlayerRef)

  Float fSneakValue    = akActor.GetActorValue("Sneak")
  Float fIllusionValue = akActor.GetActorValue("Illusion")
  Float fSpeechValue   = akActor.GetActorValue("Speechcraft")

  Return Mathf.Max(fSneakValue, Mathf.Max(fIllusionValue, fSpeechValue))
EndFunction


Int Function GetFovType(Float afHeadingAngle, Float afMaxHeadingAngle) Global
  ; Returns type of field of view (clear, distorted, peripheral)

  ; When fDetectionViewCone == 190.0, fClearAngleMax = 15 degrees
  Float fClearAngleMax = afMaxHeadingAngle / (190.0 / 15.0)

  If Mathf.InRange(afHeadingAngle, -fClearAngleMax, fClearAngleMax)
    Return 1
  EndIf

  ; When fDetectionViewCone == 190.0, fDistortedAngleMax = 30 degrees
  Float fDistortedAngleMax = fClearAngleMax * 2.0

  If Mathf.InRange(afHeadingAngle, -fDistortedAngleMax, fDistortedAngleMax)
    Return 2
  EndIf

  ; When fDetectionViewCone == 190.0, fPeripheralAngleMax = 60 degrees
  Float fPeripheralAngleMax = fDistortedAngleMax * 2.0

  If Mathf.InRange(afHeadingAngle, -fPeripheralAngleMax, fPeripheralAngleMax)
    Return 3
  EndIf

  Return 0
EndFunction


Int Function GetLosType(Float afDistanceToPlayer, Float afMaxDistanceToPlayer) Global
  ; Returns type of line of sight (near, mid, far)

  ; When afMaxDistanceToPlayer == 2048, fNearDistanceMax = 512
  Float fNearDistanceMax = afMaxDistanceToPlayer / 4.0

  If Mathf.InRange(afDistanceToPlayer, 0.0, fNearDistanceMax)
    Return 1
  EndIf

  ; When afMaxDistanceToPlayer == 2048, fMidDistanceMax = 1024
  Float fMidDistanceMax  = afMaxDistanceToPlayer / 2.0

  If Mathf.InRange(afDistanceToPlayer, fNearDistanceMax, fMidDistanceMax)
    Return 2
  EndIf

  If Mathf.InRange(afDistanceToPlayer, fMidDistanceMax, afMaxDistanceToPlayer)
    Return 3
  EndIf

  Return 0
EndFunction


Function Suspend(Float afSeconds) Global
  Float fGoal = Utility.GetCurrentRealTime() + afSeconds

  While (Utility.GetCurrentRealTime() < fGoal)
    Utility.Wait(1.0)
  EndWhile
EndFunction
