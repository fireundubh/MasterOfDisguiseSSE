ScriptName dubhUtilityScript

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

	Float fSneakValue = akActor.GetActorValue("Sneak")
	Float fIllusionValue = akActor.GetActorValue("Illusion")

	If fSneakValue > fIllusionValue
		Return fSneakValue
	EndIf

	Return fIllusionValue
EndFunction


Int Function GetLosType(Float afDistanceToPlayer, Float afMaxDistanceToPlayer, Float afHeadingAngle, Float afMinHeadingAngle, Float afMaxHeadingAngle) Global
	; Retrieves line of sight type

	Float fDistanceNear = afMaxDistanceToPlayer / 4.0
	Float fDistanceFar  = afMaxDistanceToPlayer / 2.0

	Float fMaxHeadingAngleClear = afMaxHeadingAngle / 4.0
	Float fMinHeadingAngleClear = Math.Abs(fMaxHeadingAngleClear) * -1.0

	Float fMaxHeadingAngleDistant = fMaxHeadingAngleClear * 2.0
	Float fMinHeadingAngleDistant = Math.Abs(fMaxHeadingAngleDistant) * -1.0

	Int result = 0

	If (afDistanceToPlayer >= 0.0) && (afDistanceToPlayer < fDistanceNear)
		; 0 - 512
		If (afHeadingAngle >= fMinHeadingAngleClear) && (afHeadingAngle <= fMaxHeadingAngleClear)
			result = 1
		EndIf
	ElseIf (afDistanceToPlayer >= fDistanceNear) && (afDistanceToPlayer < fDistanceFar)
		; 512 - 1024
		If (afHeadingAngle >= fMinHeadingAngleDistant) && (afHeadingAngle < fMinHeadingAngleClear)
			result = 2
		ElseIf (afHeadingAngle > fMaxHeadingAngleClear) && (afHeadingAngle <= fMaxHeadingAngleDistant)
			result = 2
		EndIf
	ElseIf (afDistanceToPlayer >= fDistanceFar) && (afDistanceToPlayer <= afMaxDistanceToPlayer)
		; 1024 - 2048
		If (afHeadingAngle >= afMinHeadingAngle) && (afHeadingAngle < fMinHeadingAngleDistant)
			result = 3
		ElseIf (afHeadingAngle > fMaxHeadingAngleDistant) && (afHeadingAngle <= afMaxHeadingAngle)
			result = 3
		EndIf
	EndIf

	Return result
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
