class TurokFEMultiplayerGamePlayModeOverlay extends TurokFEMultiplayerLobbyOverlay
    native;

var @NULL mOverlayEdges[2];

// Export UTurokFEMultiplayerGamePlayModeOverlay::execInitialize(FFrame&, void* const)
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

// Export UTurokFEMultiplayerGamePlayModeOverlay::execInitList(FFrame&, void* const)
protected native function InitList();

// Export UTurokFEMultiplayerGamePlayModeOverlay::execActivate(FFrame&, void* const)
protected native function Activate();

defaultproperties
{
    SceneName="TurokFEMultiplayer.GameModeOverlay"
}