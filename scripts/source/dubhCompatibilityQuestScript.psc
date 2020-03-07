ScriptName dubhCompatibilityQuestScript Extends Quest

; =============================================================================
; PROPERTIES
; =============================================================================

GlobalVariable Property Global_fDetectionViewConeMCM Auto
GlobalVariable Property Global_fScriptUpdateFrequencyCompatibility Auto
GlobalVariable Property Global_iFactionsUpdateAutoRun Auto
GlobalVariable Property Global_iFactionsUpdateCompleted Auto
GlobalVariable Property Global_iPapyrusLoggingEnabled Auto

Message Property Message_FactionsUpdateStarting Auto
Message Property Message_FactionsUpdateCompleted Auto

Faction Property BanditAllyFaction Auto
Faction Property BanditFaction Auto
Faction Property BanditFriendFaction Auto
Faction Property BladesFaction Auto
Faction Property BladesRecruitsFaction Auto
Faction Property CollegeofWinterholdArchMageFaction Auto
Faction Property CollegeofWinterholdFaction Auto
Faction Property CompanionsFaction Auto
Faction Property CrimeFactionEastmarch Auto
Faction Property CrimeFactionFalkreath Auto
Faction Property CrimeFactionHaafingar Auto
Faction Property CrimeFactionHjaalmarch Auto
Faction Property CrimeFactionImperial Auto
Faction Property CrimeFactionOrcs Auto
Faction Property CrimeFactionPale Auto
Faction Property CrimeFactionReach Auto
Faction Property CrimeFactionRift Auto
Faction Property CrimeFactionSons Auto
Faction Property CrimeFactionWhiterun Auto
Faction Property CrimeFactionWinterhold Auto
Faction Property CWImperialFaction Auto
Faction Property CWImperialFactionNPC Auto
Faction Property CWSonsFaction Auto
Faction Property CWSonsFactionNPC Auto
Faction Property DA01NelacarFaction Auto
Faction Property DA03VampireFaction Auto
Faction Property DA11AttackPlayerFaction Auto
Faction Property DarkBrotherhoodFaction Auto
Faction Property DB10SanctuaryFamilyFaction Auto
Faction Property DB11KatariahCrewFaction Auto
Faction Property DBPenitusOculatusFaction Auto
Faction Property DisguiseFaction01 Auto
Faction Property DisguiseFaction02 Auto
Faction Property DisguiseFaction03 Auto
Faction Property DisguiseFaction04 Auto
Faction Property DisguiseFaction05 Auto
Faction Property DisguiseFaction06 Auto
Faction Property DisguiseFaction07 Auto
Faction Property DisguiseFaction08 Auto
Faction Property DisguiseFaction09 Auto
Faction Property DisguiseFaction10 Auto
Faction Property DisguiseFaction11 Auto
Faction Property DisguiseFaction12 Auto
Faction Property DisguiseFaction13 Auto
Faction Property DisguiseFaction14 Auto
Faction Property DisguiseFaction15 Auto
Faction Property DisguiseFaction16 Auto
Faction Property DisguiseFaction17 Auto
Faction Property DisguiseFaction18 Auto
Faction Property DisguiseFaction19 Auto
Faction Property DisguiseFaction20 Auto
Faction Property DisguiseFaction21 Auto
Faction Property DisguiseFaction22 Auto
Faction Property DisguiseFaction23 Auto
Faction Property DisguiseFaction24 Auto
Faction Property DisguiseFaction25 Auto
Faction Property DisguiseFaction26 Auto
Faction Property DisguiseFaction27 Auto
Faction Property DisguiseFaction28 Auto
Faction Property DisguiseFaction29 Auto
Faction Property DisguiseFaction30 Auto
Faction Property DisguiseFaction31 Auto
Faction Property DLC1HunterFaction Auto
Faction Property DLC1VampireFaction Auto
Faction Property DLC2CrimeRavenRockFaction Auto
Faction Property DLC2CultistFaction Auto
Faction Property DLC2MoragTongFaction Auto
Faction Property DLC2RavenRockGuardFaction Auto
Faction Property DremoraFaction Auto
Faction Property DruadachRedoubtFaction Auto
Faction Property DunAnsilvundBanditFaction Auto
Faction Property dunIcerunnerBanditFaction Auto
Faction Property dunLinweFaction Auto
Faction Property dunLostKnifeCatFaction Auto
Faction Property dunMarkarthWizard_SecureAreaFaction Auto
Faction Property dunRobbersGorgeBanditFaction Auto
Faction Property dunValtheimKeepBanditFaction Auto
Faction Property ForswornDogFaction Auto
Faction Property ForswornFaction Auto
Faction Property GuardFactionFalkreath Auto
Faction Property GuardFactionHaafingar Auto
Faction Property GuardFactionHjaalmarch Auto
Faction Property GuardFactionMarkarth Auto
Faction Property GuardFactionPale Auto
Faction Property GuardFactionRiften Auto
Faction Property GuardFactionSolitude Auto
Faction Property GuardFactionWhiterun Auto
Faction Property GuardFactionWindhelm Auto
Faction Property GuardFactionWinterhold Auto
Faction Property HagravenFaction Auto
Faction Property HunterFaction Auto
Faction Property ImperialJusticiarFaction Auto
Faction Property IsGuardFaction Auto
Faction Property KhajiitCaravanFaction Auto
Faction Property MarkarthKeepFaction Auto
Faction Property MarkarthWizardFaction Auto
Faction Property MG03OrthornFaction Auto
Faction Property MGRitualDremoraFaction Auto
Faction Property MGThalmorFaction Auto
Faction Property MQ201ThalmorFooledFaction Auto
Faction Property MS01ConspiracyCombatFaction Auto
Faction Property MS01TreasuryHouseForsworn Auto
Faction Property MS01WeylinBeserk Auto
Faction Property MS02ForswornFaction Auto
Faction Property MS07BanditFaction Auto
Faction Property MS07BanditSiblings Auto
Faction Property MS08AlikrFaction Auto
Faction Property MS08SaadiaFaction Auto
Faction Property MS09NorthwatchFaction Auto
Faction Property MS09NorthwatchPrisonerFaction Auto
Faction Property NecromancerFaction Auto
Faction Property PenitusOculatusFaction Auto
Faction Property RiftenRatwayFactionEnemy Auto
Faction Property RiftenRatwayFactionNeutral Auto
Faction Property RiftenSkoomaDealerFactionEnemy Auto
Faction Property RiftenSkoomaDealerFactionFriend Auto
Faction Property SailorFaction Auto
Faction Property SalvianusFaction Auto
Faction Property SilverHandFaction Auto
Faction Property SilverHandFactionPacified Auto
Faction Property SkeletonFaction Auto
Faction Property T01EnmonFaction Auto
Faction Property TG04BrinewaterGrottoFaction Auto
Faction Property TG04EastEmpireFaction Auto
Faction Property TG04EastEmpireFactionHostile Auto
Faction Property TG04GulumEiPlayerFriendFaction Auto
Faction Property ThalmorFaction Auto
Faction Property ThievesGuildFaction Auto
Faction Property VampireFaction Auto
Faction Property VampireThrallFaction Auto
Faction Property VigilantOfStendarrFaction Auto
Faction Property WarlockFaction Auto
Faction Property WE19BanditFaction Auto
Faction Property WE20BanditFaction Auto
Faction Property WerewolfFaction Auto
Faction Property WinterholdJailFaction Auto
Faction Property WIThiefFaction Auto

; =============================================================================
; FUNCTIONS
; =============================================================================

Function _Log(String asTextToPrint)
	If Global_iPapyrusLoggingEnabled.GetValue() as Bool
		Debug.Trace("Master of Disguise: dubhCompatibilityQuestScript> " + asTextToPrint)
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


Function SetUpFactions()
	LogInfo("Updating faction relationships...")

	BanditAllyFaction.SetAlly(DisguiseFaction31)
	BanditFaction.SetEnemy(DisguiseFaction19)
	BanditFaction.SetEnemy(DisguiseFaction20)
	BanditFaction.SetEnemy(DisguiseFaction21)
	BanditFaction.SetEnemy(DisguiseFaction22)
	BanditFaction.SetEnemy(DisguiseFaction23)
	BanditFaction.SetEnemy(DisguiseFaction24)
	BanditFaction.SetEnemy(DisguiseFaction25)
	BanditFaction.SetEnemy(DisguiseFaction26)
	BanditFaction.SetEnemy(DisguiseFaction27)
	BanditFaction.SetEnemy(DisguiseFaction28)
	BanditFaction.SetAlly(DisguiseFaction31)
	BanditFriendFaction.SetAlly(DisguiseFaction31, true, true)  ; Friend
	BladesFaction.SetAlly(DisguiseFaction01)
	BladesFaction.SetEnemy(DisguiseFaction06, true, true)  ; Neutral
	BladesFaction.SetEnemy(DisguiseFaction11)
	BladesRecruitsFaction.SetAlly(DisguiseFaction01)
	BladesRecruitsFaction.SetEnemy(DisguiseFaction06, true, true)  ; Neutral
	BladesRecruitsFaction.SetEnemy(DisguiseFaction11)
	CollegeofWinterholdArchMageFaction.SetAlly(DisguiseFaction28)
	CollegeofWinterholdFaction.SetAlly(DisguiseFaction28)
	CompanionsFaction.SetEnemy(DisguiseFaction09)
	CompanionsFaction.SetAlly(DisguiseFaction18)
	CrimeFactionEastmarch.SetEnemy(DisguiseFaction14)
	CrimeFactionEastmarch.SetEnemy(DisguiseFaction15)
	CrimeFactionEastmarch.SetEnemy(DisguiseFaction16)
	CrimeFactionEastmarch.SetEnemy(DisguiseFaction31)
	CrimeFactionFalkreath.SetEnemy(DisguiseFaction14)
	CrimeFactionFalkreath.SetEnemy(DisguiseFaction15)
	CrimeFactionFalkreath.SetEnemy(DisguiseFaction16)
	CrimeFactionFalkreath.SetEnemy(DisguiseFaction31)
	CrimeFactionHaafingar.SetEnemy(DisguiseFaction14)
	CrimeFactionHaafingar.SetEnemy(DisguiseFaction15)
	CrimeFactionHaafingar.SetEnemy(DisguiseFaction16)
	CrimeFactionHaafingar.SetEnemy(DisguiseFaction31)
	CrimeFactionHjaalmarch.SetEnemy(DisguiseFaction14)
	CrimeFactionHjaalmarch.SetEnemy(DisguiseFaction15)
	CrimeFactionHjaalmarch.SetEnemy(DisguiseFaction16)
	CrimeFactionHjaalmarch.SetEnemy(DisguiseFaction31)
	CrimeFactionImperial.SetEnemy(DisguiseFaction14)
	CrimeFactionImperial.SetEnemy(DisguiseFaction15)
	CrimeFactionImperial.SetEnemy(DisguiseFaction16)
	CrimeFactionImperial.SetEnemy(DisguiseFaction31)
	CrimeFactionOrcs.SetEnemy(DisguiseFaction14)
	CrimeFactionOrcs.SetEnemy(DisguiseFaction15)
	CrimeFactionOrcs.SetEnemy(DisguiseFaction16)
	CrimeFactionOrcs.SetEnemy(DisguiseFaction31)
	CrimeFactionPale.SetEnemy(DisguiseFaction14)
	CrimeFactionPale.SetEnemy(DisguiseFaction15)
	CrimeFactionPale.SetEnemy(DisguiseFaction16)
	CrimeFactionPale.SetEnemy(DisguiseFaction31)
	CrimeFactionReach.SetEnemy(DisguiseFaction14)
	CrimeFactionReach.SetEnemy(DisguiseFaction15)
	CrimeFactionReach.SetEnemy(DisguiseFaction16)
	CrimeFactionReach.SetEnemy(DisguiseFaction31)
	CrimeFactionRift.SetEnemy(DisguiseFaction14)
	CrimeFactionRift.SetEnemy(DisguiseFaction15)
	CrimeFactionRift.SetEnemy(DisguiseFaction16)
	CrimeFactionRift.SetEnemy(DisguiseFaction31)
	CrimeFactionSons.SetEnemy(DisguiseFaction14)
	CrimeFactionSons.SetEnemy(DisguiseFaction15)
	CrimeFactionSons.SetEnemy(DisguiseFaction16)
	CrimeFactionSons.SetEnemy(DisguiseFaction31)
	CrimeFactionWhiterun.SetEnemy(DisguiseFaction14)
	CrimeFactionWhiterun.SetEnemy(DisguiseFaction15)
	CrimeFactionWhiterun.SetEnemy(DisguiseFaction16)
	CrimeFactionWhiterun.SetEnemy(DisguiseFaction31)
	CrimeFactionWinterhold.SetEnemy(DisguiseFaction14)
	CrimeFactionWinterhold.SetEnemy(DisguiseFaction15)
	CrimeFactionWinterhold.SetEnemy(DisguiseFaction16)
	CrimeFactionWinterhold.SetEnemy(DisguiseFaction31)
	CWImperialFaction.SetEnemy(DisguiseFaction01, true, true)  ; Neutral
	CWImperialFaction.SetEnemy(DisguiseFaction05)
	CWImperialFaction.SetAlly(DisguiseFaction06)
	CWImperialFaction.SetAlly(DisguiseFaction08)
	CWImperialFaction.SetEnemy(DisguiseFaction10)
	CWImperialFaction.SetAlly(DisguiseFaction11, true, true)  ; Friend
	CWImperialFactionNPC.SetAlly(DisguiseFaction06)
	CWImperialFactionNPC.SetEnemy(DisguiseFaction10)
	CWSonsFaction.SetEnemy(DisguiseFaction05)
	CWSonsFaction.SetEnemy(DisguiseFaction06)
	CWSonsFaction.SetEnemy(DisguiseFaction08)
	CWSonsFaction.SetAlly(DisguiseFaction10)
	CWSonsFaction.SetEnemy(DisguiseFaction11)
	CWSonsFactionNPC.SetEnemy(DisguiseFaction06)
	CWSonsFactionNPC.SetEnemy(DisguiseFaction08)
	CWSonsFactionNPC.SetAlly(DisguiseFaction10)
	CWSonsFactionNPC.SetEnemy(DisguiseFaction11)
	DA01NelacarFaction.SetEnemy(DisguiseFaction29)
	DA03VampireFaction.SetEnemy(DisguiseFaction13)
	DA03VampireFaction.SetAlly(DisguiseFaction14)
	DA03VampireFaction.SetAlly(DisguiseFaction16)
	DA11AttackPlayerFaction.SetAlly(DisguiseFaction21)
	DarkBrotherhoodFaction.SetAlly(DisguiseFaction03)
	DarkBrotherhoodFaction.SetEnemy(DisguiseFaction07)
	DarkBrotherhoodFaction.SetEnemy(DisguiseFaction08)
	DB10SanctuaryFamilyFaction.SetAlly(DisguiseFaction03)
	DB10SanctuaryFamilyFaction.SetEnemy(DisguiseFaction07)
	DB10SanctuaryFamilyFaction.SetEnemy(DisguiseFaction08)
	DB11KatariahCrewFaction.SetEnemy(DisguiseFaction03)
	DB11KatariahCrewFaction.SetAlly(DisguiseFaction08)
	DBPenitusOculatusFaction.SetEnemy(DisguiseFaction03)
	DBPenitusOculatusFaction.SetAlly(DisguiseFaction08)
	DLC1HunterFaction.SetAlly(DisguiseFaction04)
	DLC1HunterFaction.SetEnemy(DisguiseFaction14)
	DLC1HunterFaction.SetEnemy(DisguiseFaction16)
	DLC1VampireFaction.SetEnemy(DisguiseFaction13)
	DLC1VampireFaction.SetAlly(DisguiseFaction14, true, true)  ; Friend
	DLC1VampireFaction.SetAlly(DisguiseFaction16, true, true)  ; Friend
	DLC2CrimeRavenRockFaction.SetEnemy(DisguiseFaction14)
	DLC2CrimeRavenRockFaction.SetEnemy(DisguiseFaction15)
	DLC2CrimeRavenRockFaction.SetEnemy(DisguiseFaction16)
	DLC2CrimeRavenRockFaction.SetEnemy(DisguiseFaction31)
	DLC2CultistFaction.SetAlly(DisguiseFaction02)
	DLC2CultistFaction.SetEnemy(DisguiseFaction13)
	DLC2MoragTongFaction.SetEnemy(DisguiseFaction03)
	DLC2MoragTongFaction.SetAlly(DisguiseFaction07)
	DLC2RavenRockGuardFaction.SetAlly(DisguiseFaction23)
	DLC2RavenRockGuardFaction.SetEnemy(DisguiseFaction31)
	DremoraFaction.SetAlly(DisguiseFaction29)
	DruadachRedoubtFaction.SetAlly(DisguiseFaction05)
	DruadachRedoubtFaction.SetEnemy(DisguiseFaction06)
	DruadachRedoubtFaction.SetEnemy(DisguiseFaction10)
	DruadachRedoubtFaction.SetEnemy(DisguiseFaction11)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction19)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction20)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction21)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction22)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction23)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction24)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction25)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction26)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction27)
	DunAnsilvundBanditFaction.SetEnemy(DisguiseFaction28)
	DunAnsilvundBanditFaction.SetAlly(DisguiseFaction31)
	dunIcerunnerBanditFaction.SetAlly(DisguiseFaction31)
	dunLinweFaction.SetEnemy(DisguiseFaction19)
	dunLinweFaction.SetEnemy(DisguiseFaction20)
	dunLinweFaction.SetEnemy(DisguiseFaction21)
	dunLinweFaction.SetEnemy(DisguiseFaction22)
	dunLinweFaction.SetEnemy(DisguiseFaction23)
	dunLinweFaction.SetEnemy(DisguiseFaction24)
	dunLinweFaction.SetEnemy(DisguiseFaction25)
	dunLinweFaction.SetEnemy(DisguiseFaction26)
	dunLinweFaction.SetEnemy(DisguiseFaction27)
	dunLinweFaction.SetEnemy(DisguiseFaction28)
	dunLinweFaction.SetAlly(DisguiseFaction31)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction19)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction20)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction21)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction22)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction23)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction24)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction25)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction26)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction27)
	dunLostKnifeCatFaction.SetEnemy(DisguiseFaction28)
	dunLostKnifeCatFaction.SetAlly(DisguiseFaction31, true, true)  ; Friend
	dunMarkarthWizard_SecureAreaFaction.SetAlly(DisguiseFaction21)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction19)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction20)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction21)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction22)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction23)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction24)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction25)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction26)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction27)
	dunRobbersGorgeBanditFaction.SetEnemy(DisguiseFaction28)
	dunRobbersGorgeBanditFaction.SetAlly(DisguiseFaction31)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction19)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction20)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction21)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction22)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction23)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction24)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction25)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction26)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction27)
	dunValtheimKeepBanditFaction.SetEnemy(DisguiseFaction28)
	dunValtheimKeepBanditFaction.SetAlly(DisguiseFaction31)
	ForswornDogFaction.SetAlly(DisguiseFaction05)
	ForswornFaction.SetAlly(DisguiseFaction05)
	ForswornFaction.SetEnemy(DisguiseFaction06)
	ForswornFaction.SetEnemy(DisguiseFaction10)
	ForswornFaction.SetEnemy(DisguiseFaction11)
	GuardFactionFalkreath.SetAlly(DisguiseFaction19)
	GuardFactionFalkreath.SetEnemy(DisguiseFaction31)
	GuardFactionHaafingar.SetAlly(DisguiseFaction25)
	GuardFactionHaafingar.SetEnemy(DisguiseFaction31)
	GuardFactionHjaalmarch.SetAlly(DisguiseFaction20)
	GuardFactionHjaalmarch.SetEnemy(DisguiseFaction31)
	GuardFactionMarkarth.SetAlly(DisguiseFaction21)
	GuardFactionMarkarth.SetEnemy(DisguiseFaction31)
	GuardFactionPale.SetAlly(DisguiseFaction22)
	GuardFactionPale.SetEnemy(DisguiseFaction31)
	GuardFactionRiften.SetAlly(DisguiseFaction24)
	GuardFactionRiften.SetEnemy(DisguiseFaction31)
	GuardFactionSolitude.SetAlly(DisguiseFaction25)
	GuardFactionSolitude.SetEnemy(DisguiseFaction31)
	GuardFactionWhiterun.SetAlly(DisguiseFaction26)
	GuardFactionWhiterun.SetEnemy(DisguiseFaction31)
	GuardFactionWindhelm.SetEnemy(DisguiseFaction06)
	GuardFactionWindhelm.SetAlly(DisguiseFaction27)
	GuardFactionWindhelm.SetEnemy(DisguiseFaction31)
	GuardFactionWinterhold.SetAlly(DisguiseFaction28)
	GuardFactionWinterhold.SetEnemy(DisguiseFaction31)
	HagravenFaction.SetAlly(DisguiseFaction05)
	HunterFaction.SetAlly(DisguiseFaction05)
	ImperialJusticiarFaction.SetEnemy(DisguiseFaction01)
	ImperialJusticiarFaction.SetAlly(DisguiseFaction06)
	ImperialJusticiarFaction.SetAlly(DisguiseFaction08)
	ImperialJusticiarFaction.SetAlly(DisguiseFaction11, true, true)  ; Friend
	IsGuardFaction.SetEnemy(DisguiseFaction14)
	IsGuardFaction.SetEnemy(DisguiseFaction15)
	IsGuardFaction.SetEnemy(DisguiseFaction16)
	IsGuardFaction.SetEnemy(DisguiseFaction31)
	KhajiitCaravanFaction.SetAlly(DisguiseFaction05, true, true)  ; Friend
	MarkarthKeepFaction.SetAlly(DisguiseFaction21, true, true)  ; Friend
	MarkarthWizardFaction.SetAlly(DisguiseFaction21, true, true)  ; Friend
	MG03OrthornFaction.SetAlly(DisguiseFaction28)
	MGRitualDremoraFaction.SetAlly(DisguiseFaction29, true, true)  ; Friend
	MGThalmorFaction.SetAlly(DisguiseFaction11)
	MQ201ThalmorFooledFaction.SetAlly(DisguiseFaction11)
	MS01ConspiracyCombatFaction.SetEnemy(DisguiseFaction21)
	MS01TreasuryHouseForsworn.SetAlly(DisguiseFaction05)
	MS01WeylinBeserk.SetAlly(DisguiseFaction05)
	MS01WeylinBeserk.SetEnemy(DisguiseFaction21)
	MS02ForswornFaction.SetAlly(DisguiseFaction05)
	MS07BanditFaction.SetEnemy(DisguiseFaction19)
	MS07BanditFaction.SetEnemy(DisguiseFaction20)
	MS07BanditFaction.SetEnemy(DisguiseFaction21)
	MS07BanditFaction.SetEnemy(DisguiseFaction22)
	MS07BanditFaction.SetEnemy(DisguiseFaction23)
	MS07BanditFaction.SetEnemy(DisguiseFaction24)
	MS07BanditFaction.SetEnemy(DisguiseFaction25)
	MS07BanditFaction.SetEnemy(DisguiseFaction26)
	MS07BanditFaction.SetEnemy(DisguiseFaction27)
	MS07BanditFaction.SetEnemy(DisguiseFaction28)
	MS07BanditFaction.SetAlly(DisguiseFaction31)
	MS07BanditSiblings.SetAlly(DisguiseFaction31)
	MS08AlikrFaction.SetAlly(DisguiseFaction30)
	MS08SaadiaFaction.SetEnemy(DisguiseFaction30)
	MS09NorthwatchFaction.SetEnemy(DisguiseFaction01)
	MS09NorthwatchFaction.SetAlly(DisguiseFaction06)
	MS09NorthwatchFaction.SetAlly(DisguiseFaction08)
	MS09NorthwatchFaction.SetAlly(DisguiseFaction11)
	MS09NorthwatchPrisonerFaction.SetEnemy(DisguiseFaction11)
	NecromancerFaction.SetAlly(DisguiseFaction02)
	NecromancerFaction.SetEnemy(DisguiseFaction13)
	NecromancerFaction.SetAlly(DisguiseFaction15)
	PenitusOculatusFaction.SetEnemy(DisguiseFaction03)
	PenitusOculatusFaction.SetAlly(DisguiseFaction06)
	PenitusOculatusFaction.SetAlly(DisguiseFaction08)
	PenitusOculatusFaction.SetAlly(DisguiseFaction11, true, true)  ; Friend
	RiftenRatwayFactionEnemy.SetAlly(DisguiseFaction12)
	RiftenRatwayFactionNeutral.SetAlly(DisguiseFaction12)
	RiftenSkoomaDealerFactionEnemy.SetAlly(DisguiseFaction12, true, true)  ; Friend
	RiftenSkoomaDealerFactionEnemy.SetAlly(DisguiseFaction24, true, true)  ; Friend
	RiftenSkoomaDealerFactionFriend.SetAlly(DisguiseFaction12, true, true)  ; Friend
	RiftenSkoomaDealerFactionFriend.SetAlly(DisguiseFaction24, true, true)  ; Friend
	SailorFaction.SetEnemy(DisguiseFaction03)
	SailorFaction.SetAlly(DisguiseFaction08)
	SalvianusFaction.SetEnemy(DisguiseFaction11)
	SilverHandFaction.SetAlly(DisguiseFaction09)
	SilverHandFaction.SetEnemy(DisguiseFaction18)
	SilverHandFactionPacified.SetAlly(DisguiseFaction09)
	SilverHandFactionPacified.SetAlly(DisguiseFaction18, true, true)  ; Friend
	SkeletonFaction.SetAlly(DisguiseFaction15, true, true)  ; Friend
	T01EnmonFaction.SetEnemy(DisguiseFaction05)
	TG04BrinewaterGrottoFaction.SetAlly(DisguiseFaction31, true, true)  ; Friend
	TG04EastEmpireFaction.SetEnemy(DisguiseFaction12)
	TG04EastEmpireFaction.SetAlly(DisguiseFaction25, true, true)  ; Friend
	TG04EastEmpireFactionHostile.SetEnemy(DisguiseFaction12)
	TG04EastEmpireFactionHostile.SetAlly(DisguiseFaction25)
	TG04GulumEiPlayerFriendFaction.SetAlly(DisguiseFaction12)
	ThalmorFaction.SetEnemy(DisguiseFaction01)
	ThalmorFaction.SetAlly(DisguiseFaction06)
	ThalmorFaction.SetAlly(DisguiseFaction08)
	ThalmorFaction.SetAlly(DisguiseFaction11)
	ThievesGuildFaction.SetAlly(DisguiseFaction12)
	VampireFaction.SetEnemy(DisguiseFaction13)
	VampireFaction.SetAlly(DisguiseFaction14)
	VampireFaction.SetAlly(DisguiseFaction16)
	VampireThrallFaction.SetEnemy(DisguiseFaction04)
	VampireThrallFaction.SetEnemy(DisguiseFaction13)
	VampireThrallFaction.SetAlly(DisguiseFaction16)
	VigilantOfStendarrFaction.SetEnemy(DisguiseFaction02)
	VigilantOfStendarrFaction.SetAlly(DisguiseFaction13)
	VigilantOfStendarrFaction.SetEnemy(DisguiseFaction14)
	VigilantOfStendarrFaction.SetEnemy(DisguiseFaction15)
	VigilantOfStendarrFaction.SetEnemy(DisguiseFaction16)
	VigilantOfStendarrFaction.SetEnemy(DisguiseFaction29)
	WarlockFaction.SetAlly(DisguiseFaction15)
	WE19BanditFaction.SetEnemy(DisguiseFaction31)
	WE20BanditFaction.SetEnemy(DisguiseFaction19)
	WE20BanditFaction.SetEnemy(DisguiseFaction20)
	WE20BanditFaction.SetEnemy(DisguiseFaction21)
	WE20BanditFaction.SetEnemy(DisguiseFaction22)
	WE20BanditFaction.SetEnemy(DisguiseFaction23)
	WE20BanditFaction.SetEnemy(DisguiseFaction24)
	WE20BanditFaction.SetEnemy(DisguiseFaction25)
	WE20BanditFaction.SetEnemy(DisguiseFaction26)
	WE20BanditFaction.SetEnemy(DisguiseFaction27)
	WE20BanditFaction.SetEnemy(DisguiseFaction28)
	WE20BanditFaction.SetAlly(DisguiseFaction31)
	WerewolfFaction.SetEnemy(DisguiseFaction13)
	WerewolfFaction.SetAlly(DisguiseFaction17)
	WerewolfFaction.SetAlly(DisguiseFaction18)
	WinterholdJailFaction.SetAlly(DisguiseFaction28)
	WIThiefFaction.SetAlly(DisguiseFaction12, true, true)  ; Friend

  Faction UDGPVampireFriendFaction = Game.GetFormFromFile(0x000969F9, "Unofficial Skyrim Special Edition Patch.esp") as Faction

  If UDGPVampireFriendFaction
    DA03VampireFaction.SetAlly(UDGPVampireFriendFaction, true, true)  ; Friend
    VampireFaction.SetAlly(UDGPVampireFriendFaction, true, true)  ; Friend
    VampireThrallFaction.SetAlly(UDGPVampireFriendFaction, true, true)  ; Friend
  EndIf

	LogInfo("Finished factions update.")
EndFunction

; =============================================================================
; EVENTS
; =============================================================================

Event OnInit()
	RegisterForSingleUpdate(Global_fScriptUpdateFrequencyCompatibility.GetValue())
EndEvent


Event OnUpdate()
	If !(Global_iFactionsUpdateCompleted.GetValue() as Bool)
		Int mbResult = Message_FactionsUpdateStarting.Show()

		If mbResult == 0 || mbResult == 1
			SetUpFactions()

			Global_iFactionsUpdateCompleted.SetValue(1)
			Message_FactionsUpdateCompleted.Show()

			If mbResult == 1
				Global_iFactionsUpdateAutoRun.SetValue(0)
			EndIf
		EndIf
	EndIf

	Float fDetectionViewCone = Game.GetGameSettingFloat("fDetectionViewCone")
	Global_fDetectionViewConeMCM.SetValue(fDetectionViewCone)

	RegisterForSingleUpdate(Global_fScriptUpdateFrequencyCompatibility.GetValue())
EndEvent
