class R6MagmaInteractionInGameBase extends R6MagmaInteraction
    transient
    native;

enum EMoviesToLoad
{
    EMovie_None,                    // 0
    EMovie_MexicoIntro,             // 1
    EMovie_EndCredits,              // 2
    EMovie_MAX                      // 3
};

var TextureMovie m_pSnakeCamMovie;
var float m_fFadeCounter;

// Export UR6MagmaInteractionInGameBase::execOnPlayerStatusChanged(FFrame&, void* const)
native function OnPlayerStatusChanged(string szNewStatus);

// Export UR6MagmaInteractionInGameBase::execShowHud(FFrame&, void* const)
native function ShowHud(bool bShow);

// Export UR6MagmaInteractionInGameBase::execIsHudDisplayed(FFrame&, void* const)
native function bool IsHudDisplayed();

// Export UR6MagmaInteractionInGameBase::execIsPauseMenuShown(FFrame&, void* const)
native function bool IsPauseMenuShown();

// Export UR6MagmaInteractionInGameBase::execCanDrawHud(FFrame&, void* const)
native function bool CanDrawHud();

// Export UR6MagmaInteractionInGameBase::execOrderUp(FFrame&, void* const)
native function OrderUp(Object.EInputEvent eInput);

// Export UR6MagmaInteractionInGameBase::execOrderLeft(FFrame&, void* const)
native function OrderLeft(Object.EInputEvent eInput);

// Export UR6MagmaInteractionInGameBase::execOrderRight(FFrame&, void* const)
native function OrderRight(Object.EInputEvent eInput);

// Export UR6MagmaInteractionInGameBase::execOrderDown(FFrame&, void* const)
native function OrderDown(Object.EInputEvent eInput);

// Export UR6MagmaInteractionInGameBase::execShowOrdersMenu(FFrame&, void* const)
native function ShowOrdersMenu(bool bShow);

// Export UR6MagmaInteractionInGameBase::execShowGadgetMenu(FFrame&, void* const)
native function ShowGadgetMenu(bool bShow);

// Export UR6MagmaInteractionInGameBase::execShowWeaponMenu(FFrame&, void* const)
native function ShowWeaponMenu(bool bShow);

// Export UR6MagmaInteractionInGameBase::execShowVisionModesSelector(FFrame&, void* const)
native function ShowVisionModesSelector(bool bShow);

// Export UR6MagmaInteractionInGameBase::execShowWeaponOptionsMenu(FFrame&, void* const)
native function ShowWeaponOptionsMenu(bool bShow);

// Export UR6MagmaInteractionInGameBase::execShowNoAmmo(FFrame&, void* const)
native function ShowNoAmmo(bool bGadget);

// Export UR6MagmaInteractionInGameBase::execShowHeatSignature(FFrame&, void* const)
native function ShowHeatSignature(float fDuration);

// Export UR6MagmaInteractionInGameBase::execSetVisionModeTexture(FFrame&, void* const)
native function SetVisionModeTexture(R6EngineEnums.EVisionMode eVision);

// Export UR6MagmaInteractionInGameBase::execHideVisionModeTexture(FFrame&, void* const)
native function HideVisionModeTexture();

// Export UR6MagmaInteractionInGameBase::execRoFChanged(FFrame&, void* const)
native function RoFChanged();

// Export UR6MagmaInteractionInGameBase::execNotifyPIPChanged(FFrame&, void* const)
native function NotifyPIPChanged();

// Export UR6MagmaInteractionInGameBase::execShowSnakeCam(FFrame&, void* const)
native function ShowSnakeCam(bool bShow);

// Export UR6MagmaInteractionInGameBase::execNotifyRainbowTeamChanged(FFrame&, void* const)
native function NotifyRainbowTeamChanged(bool bAdded);

// Export UR6MagmaInteractionInGameBase::execStartHealingProgress(FFrame&, void* const)
native function StartHealingProgress(int iAnimTime);

// Export UR6MagmaInteractionInGameBase::execStopHealingProgress(FFrame&, void* const)
native function StopHealingProgress();

// Export UR6MagmaInteractionInGameBase::execPlayerDied(FFrame&, void* const)
native function PlayerDied();

// Export UR6MagmaInteractionInGameBase::execTogglePauseMenu(FFrame&, void* const)
native function TogglePauseMenu();

// Export UR6MagmaInteractionInGameBase::execControllerUnplugged(FFrame&, void* const)
native function ControllerUnplugged(int iJoystickId);

// Export UR6MagmaInteractionInGameBase::execShowMissionFailed(FFrame&, void* const)
native function ShowMissionFailed(out R6MissionFailedInfo FailureInfo);

// Export UR6MagmaInteractionInGameBase::execShowMissionSuccess(FFrame&, void* const)
native function ShowMissionSuccess();

// Export UR6MagmaInteractionInGameBase::execShowTextInformationBox(FFrame&, void* const)
native function ShowTextInformationBox(string strText, float fTimeShown, optional Color TextColor);

// Export UR6MagmaInteractionInGameBase::execShowTextInformationBoxObjective(FFrame&, void* const)
native function ShowTextInformationBoxObjective(string strNoLocText, float fTimeShown, optional Color TextColor);

// Export UR6MagmaInteractionInGameBase::execShowWhiteFlash(FFrame&, void* const)
native function ShowWhiteFlash();

// Export UR6MagmaInteractionInGameBase::execDisplayOutfitting(FFrame&, void* const)
native function bool DisplayOutfitting(bool bShow, optional R6InteractiveReplenish pReplenishBox);

// Export UR6MagmaInteractionInGameBase::execShowTacticalMap(FFrame&, void* const)
native function ShowTacticalMap(bool bShow);

// Export UR6MagmaInteractionInGameBase::execToggleMinimap(FFrame&, void* const)
native function ToggleMinimap();

// Export UR6MagmaInteractionInGameBase::execIsTacticalMapVisible(FFrame&, void* const)
native function bool IsTacticalMapVisible();

// Export UR6MagmaInteractionInGameBase::execShowRadarJamGlitch(FFrame&, void* const)
native function ShowRadarJamGlitch();

// Export UR6MagmaInteractionInGameBase::execShowCharacterCreationHud(FFrame&, void* const)
native function ShowCharacterCreationHud(bool bShow);

// Export UR6MagmaInteractionInGameBase::execIsCharacterCreationHudDisplayed(FFrame&, void* const)
native function bool IsCharacterCreationHudDisplayed();

// Export UR6MagmaInteractionInGameBase::execShowOutfittingHud(FFrame&, void* const)
native function ShowOutfittingHud(bool bShow);

// Export UR6MagmaInteractionInGameBase::execIsOutfittingHudDisplayed(FFrame&, void* const)
native function bool IsOutfittingHudDisplayed();

// Export UR6MagmaInteractionInGameBase::execIsMainOnlineHudDisplayed(FFrame&, void* const)
native function bool IsMainOnlineHudDisplayed();

// Export UR6MagmaInteractionInGameBase::execShowMainOnlineHud(FFrame&, void* const)
native function ShowMainOnlineHud(bool bShow);

// Export UR6MagmaInteractionInGameBase::execShowSOLMenu(FFrame&, void* const)
native function ShowSOLMenu(bool bShow);

// Export UR6MagmaInteractionInGameBase::execUpdateROE(FFrame&, void* const)
native function UpdateROE();

// Export UR6MagmaInteractionInGameBase::execToggleTerroristIcons(FFrame&, void* const)
native function ToggleTerroristIcons();

// Export UR6MagmaInteractionInGameBase::execLoadMovie(FFrame&, void* const)
native function TextureMovie LoadMovie(R6MagmaInteractionInGameBase.EMoviesToLoad eMovie);

// Export UR6MagmaInteractionInGameBase::execUnloadMovie(FFrame&, void* const)
native function UnloadMovie(R6MagmaInteractionInGameBase.EMoviesToLoad eMovie);

// Export UR6MagmaInteractionInGameBase::execShowGameMessage(FFrame&, void* const)
native function ShowGameMessage(R6GameEnums.EGAMEMSG eMsg, string strText, float fTimeShown, optional Color TextColor);

// Export UR6MagmaInteractionInGameBase::execShowRespawnScreen(FFrame&, void* const)
native function ShowRespawnScreen(bool bShow);

// Export UR6MagmaInteractionInGameBase::execRechargeBatteryChargeBar(FFrame&, void* const)
native function RechargeBatteryChargeBar(optional float fRechargeTime);

// Export UR6MagmaInteractionInGameBase::execFadeOnReset(FFrame&, void* const)
native final function FadeOnReset(bool bBlockInput);

// Export UR6MagmaInteractionInGameBase::execOpenChat(FFrame&, void* const)
native function OpenChat();

// Export UR6MagmaInteractionInGameBase::execOpenTeamChat(FFrame&, void* const)
native function OpenTeamChat();

// Export UR6MagmaInteractionInGameBase::execDisplayChatMessage(FFrame&, void* const)
native function DisplayChatMessage(string Msg, bool bTeam);
