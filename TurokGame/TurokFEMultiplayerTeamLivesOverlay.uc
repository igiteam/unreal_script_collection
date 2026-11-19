class TurokFEMultiplayerTeamLivesOverlay extends TurokFEMultiplayerSelectorOverlay
    native;

const kM_SelectLives = 801753764;
const kM_SelectLivesSingular = 356315941;

// Export UTurokFEMultiplayerTeamLivesOverlay::execUpdateValueLabel(FFrame&, void* const)
protected native function UpdateValueLabel();

// Export UTurokFEMultiplayerTeamLivesOverlay::execSetGameSettingsValue(FFrame&, void* const)
protected native function SetGameSettingsValue();

defaultproperties
{
    kGameSettingID=4
    SceneName="TurokFEMultiplayer.teamLivesOverlay"
}