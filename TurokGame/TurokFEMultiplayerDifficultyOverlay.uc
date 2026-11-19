class TurokFEMultiplayerDifficultyOverlay extends TurokFEMultiplayerLobbyOverlay
    native;

var const array kDifficultyHashes;
var @NULL mOverlayEdges[2];

// Export UTurokFEMultiplayerDifficultyOverlay::execInitialize(FFrame&, void* const)
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

// Export UTurokFEMultiplayerDifficultyOverlay::execInitList(FFrame&, void* const)
protected native function InitList();

// Export UTurokFEMultiplayerDifficultyOverlay::execActivate(FFrame&, void* const)
protected native function Activate();

protected event BeginIntroAnimations()
{
    //return;    
}

defaultproperties
{
    kDifficultyHashes=/* Array type was not detected. */
    SceneName="TurokFEMultiplayer.GameModeOverlay"
}