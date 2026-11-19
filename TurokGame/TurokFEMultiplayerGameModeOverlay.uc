class TurokFEMultiplayerGameModeOverlay extends TurokFEMultiplayerLobbyOverlay
    native;

var @NULL mOverlayEdges[2];

// Export UTurokFEMultiplayerGameModeOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

event SCInitialized()
{
    super.SCInitialized();
    //return;    
}

event SCTick(float DeltaTime)
{
    super.SCTick(DeltaTime);
    //return;    
}

event SCCleanUpOnExit()
{
    local int I;

    super.SCCleanUpOnExit();
    I = 0;
    J0x0D:

    // End:0x49 [Loop If]
    if(I < 2)
    {
        mOverlayEdges[I].Stop();
        mOverlayEdges[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

protected function InitList()
{
    local int I, numGameModes;
    local @NULL GameMode;
    local int SelectedIndex;
    local string Description;
    local @NULL Lobby, SearchSettings;

    Lobby = Class'Engine.Engine'.static.GetTurokNet().GetLobby();
    // DebugMode: 0
    assert(Lobby != none);
    mList = TurokUIList(Scene.FindChild('List'));
    // DebugMode: 0
    assert(mList != none);
    SelectedIndex = 0;
    SearchSettings = Lobby.GetSearchSettings();
    numGameModes = Class'Engine.TurokOnlineGameSettings'.static.GetGameModeCount();
    I = 0;
    J0x93:

    // End:0x23A [Loop If]
    if(I < numGameModes)
    {
        Class'Engine.TurokOnlineGameSettings'.static.GetGameModeByIndex(I, GameMode);
        mList.AddDataString(Class'TurokEngine.TurokUI'.static.GetLocalizedString(GameMode.NameHash), I);
        // End:0x169
        if(!bool(SearchSettings.RankedMatch) || GameMode.AllowRanked)
        {
            mDescriptionText[I] = Class'TurokEngine.TurokUI'.static.GetLocalizedString(GameMode.DescriptionHash);
            mList.SetDataActive(I);            
        }
        else
        {
            Description = Repl(Class'TurokEngine.TurokUI'.static.GetLocalizedString(-1178106821), "%s", Class'TurokEngine.TurokUI'.static.GetLocalizedString(GameMode.NameHash));
            mDescriptionText[I] = Description;
            mList.SetDataInactive(I);
        }
        // End:0x230
        if((GameMode.Id == int(SearchSettings.GameMode)) && GameMode.SizeId == int(SearchSettings.GameSize))
        {
            SelectedIndex = I;
        }
        I++;
        // [Loop Continue]
        goto J0x93;
    }
    mList.PostSetupInitialize();
    mList.SetSelection(SelectedIndex);
    RefreshList();
    ChangeDescriptionLabel();
    //return;    
}

// Export UTurokFEMultiplayerGameModeOverlay::execActivate(FFrame&, void* const)
protected native function Activate();

defaultproperties
{
    SceneName="TurokFEMultiplayer.GameModeOverlay"
}