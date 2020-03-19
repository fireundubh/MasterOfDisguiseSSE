ScriptName dubhDisguiseMCMQuestScript Extends dubhDisguiseMCMHelper

GlobalVariable Property Global_fBestSkillContribMax Auto
GlobalVariable Property Global_fBountyPenaltyMult Auto
GlobalVariable Property Global_fDetectionViewConeMCM Auto
GlobalVariable Property Global_fEscapeDistance Auto
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
GlobalVariable Property Global_fScriptUpdateFrequencyCompatibility Auto
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
GlobalVariable Property Global_iAlwaysSucceedDremora Auto
GlobalVariable Property Global_iAlwaysSucceedWerewolves Auto
GlobalVariable Property Global_iCrimeFalkreath Auto
GlobalVariable Property Global_iCrimeHjaalmarch Auto
GlobalVariable Property Global_iCrimeImperial Auto
GlobalVariable Property Global_iCrimeMarkarth Auto
GlobalVariable Property Global_iCrimePale Auto
GlobalVariable Property Global_iCrimeRavenRock Auto
GlobalVariable Property Global_iCrimeRiften Auto
GlobalVariable Property Global_iCrimeSolitude Auto
GlobalVariable Property Global_iCrimeStormcloaks Auto
GlobalVariable Property Global_iCrimeWhiterun Auto
GlobalVariable Property Global_iCrimeWindhelm Auto
GlobalVariable Property Global_iCrimeWinterhold Auto
GlobalVariable Property Global_iDiscoveryEnabled Auto
GlobalVariable Property Global_iDisguiseEnabledBandit Auto
GlobalVariable Property Global_iDisguiseEssentialSlotBandit Auto
GlobalVariable Property Global_iFactionsUpdateAutoRun Auto
GlobalVariable Property Global_iNotifyEnabled Auto
GlobalVariable Property Global_iPapyrusLoggingEnabled Auto
GlobalVariable Property Global_iVampireNightOnly Auto
GlobalVariable Property Global_iVampireNightOnlyDayHourBegin Auto
GlobalVariable Property Global_iVampireNightOnlyDayHourEnd Auto

Actor Property PlayerRef Auto
Faction Property DisguiseFaction03 Auto  ; Dark Brotherhood
Faction Property DisguiseFaction12 Auto  ; Thieves Guild
Faction Property DisguiseFaction31 Auto  ; Bandits
Faction Property DarkBrotherhoodFaction Auto
Faction Property ThievesGuildFaction Auto
Formlist Property BaseFactions Auto
Formlist Property DisguiseFactions Auto
Formlist Property DisguiseFormlists Auto
Formlist Property GuardFactions Auto
Formlist Property TrackedBounties Auto
Quest Property CompatibilityQuest Auto
Quest Property DetectionQuest Auto

Bool bCompatibilitySystem        = True
Bool bDiscoverySystem            = True
Bool bGuardsVsDarkBrotherhood    = False
Bool bGuardsVsDarkBrotherhoodNPC = False
Bool bGuardsVsThievesGuild       = False
Bool bGuardsVsThievesGuildNPC    = False

String ModName

; =============================================================================
; FUNCTIONS
; =============================================================================

Function _Log(String asTextToPrint)
  If Global_iPapyrusLoggingEnabled.GetValue() as Bool
    Debug.Trace("Master of Disguise: dubhDisguiseMCMQuestScript> " + asTextToPrint)
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


Function Alias_DefineMCMToggleOptionModEvent(String asName, String asModEvent, Bool abInitialState = False, Int aiFlags = 0)
  ; when asName and asModEvent need to differ
  RegisterForModEvent(asModEvent, "OnBooleanToggleClick")
  DefineMCMToggleOption("$dubh" + asName, abInitialState, aiFlags, "$dubhHelp" + asName, asModEvent)
EndFunction


Function Alias_DefineMCMToggleModEvent(String asModEvent, Bool abInitialState = False, Int aiFlags = 0)
  ; when mod event name will be used as option name
  RegisterForModEvent(asModEvent, "OnBooleanToggleClick")
  DefineMCMToggleOption("$dubh" + asModEvent, abInitialState, aiFlags, "$dubhHelp" + asModEvent, asModEvent)
EndFunction


Function Alias_DefineMCMToggleOptionGlobal(String asName, GlobalVariable akGlobal, Int aiFlags = 0)
  DefineMCMToggleOptionGlobal("$dubh" + asName, akGlobal, aiFlags, "$dubhHelp" + asName)
EndFunction


Function Alias_DefineMCMSliderOptionGlobal(String asName, GlobalVariable akGlobal, Float afMin, Float afMax, Float afInterval, Int aiFlags = 0)
  DefineMCMSliderOptionGlobal("$dubh" + asName, akGlobal, akGlobal.GetValue(), afMin, afMax, afInterval, "$dubhHelp" + asName, "{2}", aiFlags)
EndFunction

Function Alias_DefineMCMMenuOptionGlobal(String asTextLabel, String asValuesCSV, GlobalVariable akGlobal, Int iDefault = 0)
  DefineMCMMenuOptionGlobal("$dubh" + asTextLabel, asValuesCSV, akGlobal, iDefault, 0, "$dubhHelp" + asTextLabel, "")
EndFunction


Function ClearDisguiseFactions()
  ; Removes player from all disguise factions

  Int i = 0

  While i < DisguiseFactions.GetSize()
    Faction kFaction = DisguiseFactions.GetAt(i) as Faction
    If PlayerRef.IsInFaction(kFaction)
      PlayerRef.RemoveFromFaction(kFaction)
    EndIf
    i += 1
  EndWhile

  LogInfo("Removed the player from all disguise factions.")
EndFunction


Function SetFactionRelations(Formlist akFactions, Faction akTargetFaction, String asRelation)
  ; Sets relations between a faction and ALL factions in a formlist with string

  Int i = 0

  While i < akFactions.GetSize()
    Faction kFaction = akFactions.GetAt(i) as Faction

    If asRelation == "Ally"
      kFaction.SetAlly(akTargetFaction)
      LogInfo(akTargetFaction + " is now allies with " + kFaction)
    ElseIf asRelation == "Friend"
      kFaction.SetAlly(akTargetFaction, True, True)
      LogInfo(akTargetFaction + " is now friends with " + kFaction)
    ElseIf asRelation == "Neutral"
      kFaction.SetEnemy(akTargetFaction, True, True)
      LogInfo(akTargetFaction + " is now neutral with " + kFaction)
    ElseIf asRelation == "Enemy"
      kFaction.SetEnemy(akTargetFaction)
      LogInfo(akTargetFaction + " is now enemies with " + kFaction)
    EndIf

    i += 1
  EndWhile
EndFunction


Bool Function StartQuest(Quest akQuest)
  ; Starts quest with debug output

  If !akQuest.IsStopped()
    LogInfo("Could not start " + akQuest + " because the quest was not stopped")
    Return False
  EndIf

  If akQuest.Start()
    LogInfo("Successfully started quest: " + akQuest)
    Return True
  EndIf

  LogWarning("Could not start " + akQuest + " because the quest was not stopped")
  Return False
EndFunction


Bool Function StopQuest(Quest akQuest)
  ; Stops quest with debug output

  If akQuest.IsRunning()
    LogWarning("Could not stop " + akQuest + " because the quest was not running")
    Return False
  EndIf

  Int _cycles = 0

  akQuest.Stop()

  While akQuest.IsRunning()
    _cycles += 1
  EndWhile

  While akQuest.IsStopping()
    _cycles += 1
  EndWhile

  If akQuest.IsStopped()
    LogInfo("Successfully stopped: " + akQuest)
    Return True
  EndIf

  LogWarning("Could not stop " + akQuest + " because the quest was not running")
  Return False
EndFunction
; =============================================================================
; EVENTS
; =============================================================================

Event OnConfigInit()
  Pages = new String[8]
  Pages[0] = "$dubhPageInformation"
  Pages[1] = "$dubhPageDiscovery"
  Pages[2] = "$dubhPageScoring"
  Pages[3] = "$dubhPageRace"
  Pages[4] = "$dubhPageCrime"
  Pages[5] = "$dubhPageCrimeBounties"
  Pages[6] = "$dubhPageAdvanced"
  Pages[7] = "$dubhPageCheats"
EndEvent

Event OnPageReset(String asPageName)
  SetCursorFillMode(TOP_TO_BOTTOM)

  If asPageName == ""
    LoadCustomContent("dubhDisguiseLogo.dds")
    Return
  Else
    UnloadCustomContent()
  EndIf

  If asPageName == "$dubhPageInformation"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingInformationAccolades")
    DefineMCMParagraph("$dubhInformationAccoladesText01")
    DefineMCMParagraph("$dubhInformationAccoladesText02")
    DefineMCMParagraph("$dubhInformationAccoladesText03")
    DefineMCMParagraph("$dubhInformationAccoladesText04")
    DefineMCMParagraph("$dubhInformationAccoladesText05")
    DefineMCMParagraph("$dubhInformationAccoladesText06")

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingInformationCredits")
    DefineMCMParagraph("$dubhInformationCredits01")
    DefineMCMParagraph("$dubhInformationCredits02")
    DefineMCMParagraph("$dubhInformationCredits03")

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingInformationSupport")

    DefineMCMParagraph("$dubhInformationSupportText01")
    DefineMCMParagraph("$dubhInformationSupportText02")
    DefineMCMParagraph("$dubhInformationSupportText03")

    AddEmptyOption()

    DefineMCMParagraph("$dubhInformationSupportText04")
    DefineMCMParagraph("$dubhInformationSupportText05")

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingInformationPermissions")
    DefineMCMParagraph("$dubhInformationPermissions01")
    DefineMCMParagraph("$dubhInformationPermissions02")

  ElseIf asPageName == "$dubhPageDiscovery"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingDiscoveryViewCone")
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionViewCone", Global_fDetectionViewConeMCM, 30.0, 360.0, 5.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingDiscoveryLos")
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionLosMax",   Global_fLOSDistanceMax, 1024.0, Global_fScriptDistanceMax.GetValue(), 256.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingDiscoveryLosPenalties")
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionLosClear",      Global_fLOSPenaltyClearMin,      0.0, 1.0, 0.05)
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionLosDistorted",  Global_fLOSPenaltyDistortedMin,  0.0, 1.0, 0.05)
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionLosPeripheral", Global_fLOSPenaltyPeripheralMin, 0.0, 1.0, 0.05)

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingDiscoveryBiWinning")
    Alias_DefineMCMToggleOptionGlobal("DiscoveryOptionDremora",     Global_iAlwaysSucceedDremora)
    Alias_DefineMCMToggleOptionGlobal("DiscoveryOptionWerewolves",  Global_iAlwaysSucceedWerewolves)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingDiscoveryVN")
    Alias_DefineMCMToggleOptionGlobal("DiscoveryOptionVN",          Global_iVampireNightOnly)
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionVNDayBegins", Global_iVampireNightOnlyDayHourBegin, 0.0, 24.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("DiscoveryOptionVNDayEnds",   Global_iVampireNightOnlyDayHourEnd,   0.0, 24.0, 1.0)

  ElseIf asPageName == "$dubhPageScoring"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingScoringBestSkill")
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionBestSkillMax",  Global_fBestSkillContribMax, 0.0, 100.0, 10.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingScoringMobility")
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionMobilityBonus",   Global_fMobilityBonus,   1.0, 1.5, 0.05)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionMobilityPenalty", Global_fMobilityPenalty, 0.5, 1.0, 0.05)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingScoringWeapons")
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionWeaponLeft",    Global_fSlotWeaponLeft,      0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionWeaponRight",   Global_fSlotWeaponRight,     0.0, 100.0, 1.0)

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingScoringEquipment")
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionAmulet",        Global_fSlotAmulet,          0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionBody",          Global_fSlotBody,            0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionCirclet",       Global_fSlotCirclet,         0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionFeet",          Global_fSlotFeet,            0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionHair",          Global_fSlotHair,            0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionHands",         Global_fSlotHands,           0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionRing",          Global_fSlotRing,            0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("ScoringOptionShield",        Global_fSlotShield,          0.0, 100.0, 1.0)

  ElseIf asPageName == "$dubhPageRace"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingRaceModifiers1")
    Alias_DefineMCMSliderOptionGlobal("RaceOptionAltmer",           Global_fRaceHighElf,         0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionArgonian",         Global_fRaceArgonian,        0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionBosmer",           Global_fRaceWoodElf,         0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionBreton",           Global_fRaceBreton,          0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionDunmer",           Global_fRaceDarkElf,         0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionImperial",         Global_fRaceImperial,        0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionKhajiit",          Global_fRaceKhajiit,         0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionNord",             Global_fRaceNord,            0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionOrc",              Global_fRaceOrc,             0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionRedguard",         Global_fRaceRedguard,        0.0, 100.0, 1.0)

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingRaceModifiers2")
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireAltmer",    Global_fRaceHighElfVampire,  0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireArgonian",  Global_fRaceArgonianVampire, 0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireBosmer",    Global_fRaceWoodElfVampire,  0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireBreton",    Global_fRaceBretonVampire,   0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireDunmer",    Global_fRaceDarkElfVampire,  0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireImperial",  Global_fRaceImperialVampire, 0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireKhajiit",   Global_fRaceKhajiitVampire,  0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireNord",      Global_fRaceNordVampire,     0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireOrc",       Global_fRaceOrcVampire,      0.0, 100.0, 1.0)
    Alias_DefineMCMSliderOptionGlobal("RaceOptionVampireRedguard",  Global_fRaceRedguardVampire, 0.0, 100.0, 1.0)

  ElseIf asPageName == "$dubhPageCrime"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingCrimeBountyPenalty")
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionBountyMult", Global_fBountyPenaltyMult, 0.0, 1.0, 0.01, 1)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingCrimeBanditDisguise")
    Alias_DefineMCMToggleOptionGlobal("CrimeOptionBandits",    Global_iDisguiseEnabledBandit)
    Alias_DefineMCMMenuOptionGlobal(  "CrimeOptionBanditSlot", "$dubhSlot0,$dubhSlot1,$dubhSlot2,$dubhSlot3,$dubhSlot4,$dubhSlot5,$dubhSlot6,$dubhSlot7,$dubhSlot8,$dubhSlot9", Global_iDisguiseEssentialSlotBandit, 1)

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingCrimeFactionRelations")
    Alias_DefineMCMToggleOptionModEvent("CrimeOptionGuardsVsDB",    "dubhToggleGuardsVsDarkBrotherhood",    bGuardsVsDarkBrotherhood)
    Alias_DefineMCMToggleOptionModEvent("CrimeOptionGuardsVsTG",    "dubhToggleGuardsVsThievesGuild",       bGuardsVsThievesGuild)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingCrimeFactionRelationsNPC")
    Alias_DefineMCMToggleOptionModEvent("CrimeOptionGuardsVsDBNPC", "dubhToggleGuardsVsDarkBrotherhoodNPC", bGuardsVsDarkBrotherhoodNPC)
    Alias_DefineMCMToggleOptionModEvent("CrimeOptionGuardsVsTGNPC", "dubhToggleGuardsVsThievesGuildNPC",    bGuardsVsThievesGuildNPC)

  ElseIf asPageName == "$dubhPageCrimeBounties"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingCrimeEmpireLovesLists")
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionImperial",    Global_iCrimeImperial,    0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionStormcloaks", Global_iCrimeStormcloaks, 0.0, 99999.0, 1.0, 1)

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingCrimeTrackedBounties")
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionFalkreath",   Global_iCrimeFalkreath,   0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionHjaalmarch",  Global_iCrimeHjaalmarch,  0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionMarkarth",    Global_iCrimeMarkarth,    0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionPale",        Global_iCrimePale,        0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionRavenRock",   Global_iCrimeRavenRock,   0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionRiften",      Global_iCrimeRiften,      0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionSolitude",    Global_iCrimeSolitude,    0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionWhiterun",    Global_iCrimeWhiterun,    0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionWindhelm",    Global_iCrimeWindhelm,    0.0, 99999.0, 1.0, 1)
    Alias_DefineMCMSliderOptionGlobal("CrimeOptionWinterhold",  Global_iCrimeWinterhold,  0.0, 99999.0, 1.0, 1)

  ElseIf asPageName == "$dubhPageAdvanced"
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("$dubhHeadingAdvancedWatchRate")
    Alias_DefineMCMSliderOptionGlobal("AdvancedOptionWatchRate", Global_fScriptSuspendTime, 0.0, 60.0, 1.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingAdvancedDiscovery")
    Alias_DefineMCMSliderOptionGlobal("AdvancedOptionDiscoveryMax", Global_fScriptDistanceMax, 0.0, Global_fEscapeDistance.GetValue(), 256.0)
    Alias_DefineMCMSliderOptionGlobal("AdvancedOptionUpdateRateDiscovery", Global_fScriptUpdateFrequencyMonitor, 0.0, 30.0, 1.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingAdvancedCompatibility")
    Alias_DefineMCMSliderOptionGlobal("AdvancedOptionUpdateRateCompatibility", Global_fScriptUpdateFrequencyCompatibility, 0.0, 30.0, 1.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingAdvancedEnemies")
    Alias_DefineMCMSliderOptionGlobal("AdvancedOptionEscapeDistance", Global_fEscapeDistance, Global_fScriptDistanceMax.GetValue(), 8192.0, 256.0)

    SetCursorPosition(1)

    AddHeaderOption("$dubhHeadingAdvancedCombatDelay")
    Alias_DefineMCMSliderOptionGlobal("AdvancedOptionCombatDelay", Global_fScriptSuspendTimeBeforeAttack, 0.0, 60.0, 1.0)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingAdvancedDebug")
    Alias_DefineMCMToggleOptionGlobal("AdvancedOptionFactionsUpdateAutoRun", Global_iFactionsUpdateAutoRun)
    Alias_DefineMCMToggleOptionGlobal("AdvancedOptionNotifyEnabled", Global_iNotifyEnabled)
    Alias_DefineMCMToggleOptionGlobal("AdvancedOptionPapyrusLogging", Global_iPapyrusLoggingEnabled)

    AddEmptyOption()

    AddHeaderOption("$dubhHeadingAdvancedSetup")
    Alias_DefineMCMToggleOptionModEvent("AdvancedOptionCompatibility", "ToggleDynamicCompatibility", bCompatibilitySystem)
    Alias_DefineMCMToggleOptionModEvent("AdvancedOptionDiscoverySystem", "ToggleDiscoverySystem", bDiscoverySystem)

  ElseIf asPageName == "$dubhPageCheats"
    SetCursorFillMode(TOP_TO_BOTTOM)

    Alias_DefineMCMToggleModEvent("CheatAddDisguise01", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise02", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise03", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise04", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise05", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise06", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise07", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise08", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise09", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise10", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise11", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise12", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise13", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise14", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise15", False)

    SetCursorPosition(1)

    Alias_DefineMCMToggleModEvent("CheatAddDisguise16", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise17", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise18", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise19", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise20", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise21", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise22", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise23", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise24", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise25", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise26", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise27", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise28", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise29", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise30", False)
    Alias_DefineMCMToggleModEvent("CheatAddDisguise31", False)

  EndIf
EndEvent


Event OnBooleanToggleClick(string asEventName, string strArg, float numArg, Form sender)
  FormList kForms = None

  If asEventName == "dubhToggleDynamicCompatibility"
    bCompatibilitySystem = numArg as Bool

    If bCompatibilitySystem
      StartQuest(CompatibilityQuest)
    Else
      If StopQuest(CompatibilityQuest)
        ClearDisguiseFactions()
;       ClearTrackedBounties()
      EndIf
    EndIf
  ElseIf asEventName == "dubhToggleDiscoverySystem"
    bDiscoverySystem = numArg as Bool

    If bDiscoverySystem
      StartQuest(DetectionQuest)
    Else
      StopQuest(DetectionQuest)
    EndIf
  ElseIf asEventName == "dubhToggleGuardsVsDarkBrotherhood"
    bGuardsVsDarkBrotherhood = numArg as Bool
    If bGuardsVsDarkBrotherhood
      SetFactionRelations(GuardFactions, DisguiseFaction03, "Enemy")
    Else
      SetFactionRelations(GuardFactions, DisguiseFaction03, "Neutral")
    EndIf
  ElseIf asEventName == "dubhToggleGuardsVsDarkBrotherhoodNPC"
    bGuardsVsDarkBrotherhoodNPC = numArg as Bool
    If bGuardsVsDarkBrotherhoodNPC
      SetFactionRelations(GuardFactions, DarkBrotherhoodFaction, "Enemy")
    Else
      SetFactionRelations(GuardFactions, DarkBrotherhoodFaction, "Neutral")
    EndIf
  ElseIf asEventName == "dubhToggleGuardsVsThievesGuild"
    bGuardsVsThievesGuild = numArg as Bool
    If bGuardsVsThievesGuild
      SetFactionRelations(GuardFactions, DisguiseFaction12, "Enemy")
    Else
      SetFactionRelations(GuardFactions, DisguiseFaction12, "Neutral")
    EndIf
  ElseIf asEventName == "dubhToggleGuardsVsThievesGuildNPC"
    bGuardsVsThievesGuildNPC = numArg as Bool
    If bGuardsVsThievesGuildNPC
      SetFactionRelations(GuardFactions, ThievesGuildFaction, "Enemy")
    Else
      SetFactionRelations(GuardFactions, ThievesGuildFaction, "Neutral")
    EndIf
  ElseIf asEventName == "CheatAddDisguise01" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(0) as FormList, 1, True)
    LogInfo("Added items from Blades formlist.")
  ElseIf asEventName == "CheatAddDisguise02" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(1) as FormList, 1, True)
    LogInfo("Added items from Cultists formlist.")
  ElseIf asEventName == "CheatAddDisguise03" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(2) as FormList, 1, True)
    LogInfo("Added items from Dark Brotherhood formlist.")
  ElseIf asEventName == "CheatAddDisguise04" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(3) as FormList, 1, True)
    LogInfo("Added items from Dawnguard formlist.")
  ElseIf asEventName == "CheatAddDisguise05" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(4) as FormList, 1, True)
    LogInfo("Added items from Forsworn formlist.")
  ElseIf asEventName == "CheatAddDisguise06" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(5) as FormList, 1, True)
    LogInfo("Added items from Imperial Legion formlist.")
  ElseIf asEventName == "CheatAddDisguise07" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(6) as FormList, 1, True)
    LogInfo("Added items from Morag Tong formlist.")
  ElseIf asEventName == "CheatAddDisguise08" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(7) as FormList, 1, True)
    LogInfo("Added items from Penitus Oculatus formlist.")
  ElseIf asEventName == "CheatAddDisguise09" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(8) as FormList, 1, True)
    LogInfo("Added items from Silver Hand formlist.")
  ElseIf asEventName == "CheatAddDisguise10" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(9) as FormList, 1, True)
    LogInfo("Added items from Stormcloaks formlist.")
  ElseIf asEventName == "CheatAddDisguise11" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(10) as FormList, 1, True)
    LogInfo("Added items from Thalmor formlist.")
  ElseIf asEventName == "CheatAddDisguise12" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(11) as FormList, 1, True)
    LogInfo("Added items from Thieves Guild formlist.")
  ElseIf asEventName == "CheatAddDisguise13" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(12) as FormList, 1, True)
    LogInfo("Added items from Vigil of Stendarr formlist.")
  ElseIf asEventName == "CheatAddDisguise14" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(13) as FormList, 1, True)
    LogInfo("Added items from Volkihar Clan formlist.")
  ElseIf asEventName == "CheatAddDisguise15" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(14) as FormList, 1, True)
    LogInfo("Added items from Necromancers formlist.")
  ElseIf asEventName == "CheatAddDisguise16" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(15) as FormList, 1, True)
    LogInfo("Added items from Vampires formlist.")
  ElseIf asEventName == "CheatAddDisguise17" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(16) as FormList, 1, True)
    LogInfo("Added items from Werewolves formlist.")
  ElseIf asEventName == "CheatAddDisguise18" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(17) as FormList, 1, True)
    LogInfo("Added items from Companions formlist.")
  ElseIf asEventName == "CheatAddDisguise19" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(18) as FormList, 1, True)
    LogInfo("Added items from Falkreath Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise20" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(19) as FormList, 1, True)
    LogInfo("Added items from Hjaalmarch Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise21" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(20) as FormList, 1, True)
    LogInfo("Added items from Markarth Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise22" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(21) as FormList, 1, True)
    LogInfo("Added items from Pale Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise23" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(22) as FormList, 1, True)
    LogInfo("Added items from Raven Rock Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise24" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(23) as FormList, 1, True)
    LogInfo("Added items from Riften Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise25" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(24) as FormList, 1, True)
    LogInfo("Added items from Solitude Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise26" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(25) as FormList, 1, True)
    LogInfo("Added items from Whiterun Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise27" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(26) as FormList, 1, True)
    LogInfo("Added items from Windhelm Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise28" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(27) as FormList, 1, True)
    LogInfo("Added items from Winterhold Guard formlist.")
  ElseIf asEventName == "CheatAddDisguise29" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(28) as FormList, 1, True)
    LogInfo("Added items from Daedric Influence formlist.")
  ElseIf asEventName == "CheatAddDisguise30" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(29) as FormList, 1, True)
    LogInfo("Added items from Alik'r Mercenaries formlist.")
  ElseIf asEventName == "CheatAddDisguise31" && numArg as Bool
    PlayerRef.AddItem(DisguiseFormlists.GetAt(30) as FormList, 1, True)
    LogInfo("Added items from Bandits formlist.")
  EndIf
EndEvent