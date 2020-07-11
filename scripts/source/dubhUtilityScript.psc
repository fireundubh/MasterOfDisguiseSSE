ScriptName dubhUtilityScript

Float Function Max(Float afValue1, Float afValue2) Global
	If afValue1 > afValue2
		Return afValue1
	EndIf
	Return afValue2
EndFunction


Float Function Min(Float afValue1, Float afValue2) Global
	If afValue1 < afValue2
		Return afValue1
	EndIf
	Return afValue2
EndFunction


Bool Function TryAddToFaction(Actor akActor, Faction akFaction) Global
	If !akActor.IsInFaction(akFaction)
		akActor.AddToFaction(akFaction)
		Return akActor.IsInFaction(akFaction)
	EndIf
	Return False
EndFunction


Bool Function TryRemoveFromFaction(Actor akActor, Faction akFaction) Global
	If akActor.IsInFaction(akFaction)
		akActor.RemoveFromFaction(akFaction)
		Return !akActor.IsInFaction(akFaction)
	EndIf
	Return False
EndFunction

; =============================================================================
; Used in:
; - dubhApplyingEffectScript
; - dubhPlayerScript
; =============================================================================

Bool Function ActorIsInFaction(Actor akActor, Faction akFaction) Global
	If !akActor.IsInFaction(akFaction)
		Return False
	EndIf

	Return akActor.GetFactionRank(akFaction) > -1
EndFunction

; =============================================================================
; Used in:
; - dubhFactionEnemyScript
; - dubhMonitorEffectScript
; =============================================================================

Function Suspend(Float afSeconds) Global
	; Suspends the script from processing for some number of seconds

	Float fRealTimeCurrent = Utility.GetCurrentRealTime()
	Float fRealTimeGoal = (Utility.GetCurrentRealTime() + afSeconds)

	While fRealTimeCurrent < fRealTimeGoal
		fRealTimeCurrent = Utility.GetCurrentRealTime()
	EndWhile
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

	Return Max(fSneakValue, Max(fIllusionValue, fSpeechValue))
EndFunction


Bool Function InFloatRange(Float afValue, Float afMin, Float afMax) Global
	; Indicates whether a float value falls within a specified range
	Return (afValue >= afMin) && (afValue <= afMax)
EndFunction


Bool Function InIntRange(Int aiValue, Int aiMin, Int aiMax) Global
	; Indicates whether a int value falls within a specified range
	Return (aiValue >= aiMin) && (aiValue <= aiMax)
EndFunction


Int Function GetFovType(Float afHeadingAngle, Float afMaxHeadingAngle) Global
	; Returns type of field of view (clear, distorted, peripheral)

	; When fDetectionViewCone == 190.0, fClearAngleMax = 15 degrees
	Float fClearAngleMax = afMaxHeadingAngle / (190.0 / 15.0)

	If InFloatRange(afHeadingAngle, -fClearAngleMax, fClearAngleMax)
		Return 1
	EndIf

	; When fDetectionViewCone == 190.0, fDistortedAngleMax = 30 degrees
	Float fDistortedAngleMax = fClearAngleMax * 2.0

	If InFloatRange(afHeadingAngle, -fDistortedAngleMax, fDistortedAngleMax)
		Return 2
	EndIf

	; When fDetectionViewCone == 190.0, fPeripheralAngleMax = 60 degrees
	Float fPeripheralAngleMax = fDistortedAngleMax * 2.0

	If InFloatRange(afHeadingAngle, -fPeripheralAngleMax, fPeripheralAngleMax)
		Return 3
	EndIf

	Return 0
EndFunction


Int Function GetLosType(Float afDistanceToPlayer, Float afMaxDistanceToPlayer) Global
	; Returns type of line of sight (near, mid, far)

	; When afMaxDistanceToPlayer == 2048, fNearDistanceMax = 512
	Float fNearDistanceMax = afMaxDistanceToPlayer / 4.0

	; When afMaxDistanceToPlayer == 2048, fMidDistanceMax = 1024
	Float fMidDistanceMax  = afMaxDistanceToPlayer / 2.0

	If InFloatRange(afDistanceToPlayer, 0.0, fNearDistanceMax)
		Return 1
	EndIf

	If InFloatRange(afDistanceToPlayer, fNearDistanceMax, fMidDistanceMax)
		Return 2
	EndIf

	If InFloatRange(afDistanceToPlayer, fMidDistanceMax, afMaxDistanceToPlayer)
		Return 3
	EndIf

	Return 0
EndFunction

; =============================================================================
; Used in:
; - dubhPlayerScript
; =============================================================================

Bool Function IsDay(GlobalVariable aiHourBegin, GlobalVariable aiHourEnd) Global
	; Returns True if the current hour is within the user-defined range

	Float fGameTimeCurrent = Utility.GetCurrentGameTime()
	fGameTimeCurrent -= Math.Floor(fGameTimeCurrent)
	fGameTimeCurrent *= 24

	Int iHourCurrent = fGameTimeCurrent as Int

	Return iHourCurrent >= aiHourBegin.GetValueInt() && iHourCurrent < aiHourEnd.GetValueInt()
EndFunction
