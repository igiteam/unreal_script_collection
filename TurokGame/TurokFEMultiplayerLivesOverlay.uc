class TurokFEMultiplayerLivesOverlay extends TurokFEMultiplayerSelectorOverlay
    native;

const kM_SelectLives = 801753764;
const kM_SelectLivesSingular = 356315941;

// Export UTurokFEMultiplayerLivesOverlay::execUpdateValueLabel(FFrame&, void* const)
protected native function UpdateValueLabel();

// Export UTurokFEMultiplayerLivesOverlay::execSetGameSettingsValue(FFrame&, void* const)
protected native function SetGameSettingsValue();

defaultproperties
{
    kGameSettingID=3
    SceneName="TurokFEMultiplayer.LivesOverlay"
}