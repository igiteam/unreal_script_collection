class TurokFEMultiplayerLobbyModeOverlay extends TurokFEMultiplayerLobbyOverlay
    native;

const kMaxGameTypeItems = 6;
const kMaxSaveSlots = 3;

enum eLobbyModeType
{
    LMT_PublicRanked,               // 0
    LMT_PublicUnranked,             // 1
    LMT_Private,                    // 2
    LMT_SaveSlot,                   // 3
    LMT_MAX                         // 4
};

struct native LobbyModeItem
{
    var byte mType;
    var int mNameHash;
    var int mDescHash;

    structdefaultproperties
    {
        mType=0
        mNameHash=0
        mDescHash=0
    }
};

var protected const array kXbox360LobbyModes;
var protected const array kPS3LobbyModes;
var protected string mSaveSlots[3];
var protected int mNumSaves;
var @NULL mParentLobbyScreen;
var @NULL mOverlayEdges[2];

// Export UTurokFEMultiplayerLobbyModeOverlay::execInitialize(FFrame&, void* const)
native function Initialize(@NULL newScene, @NULL curSceneClient);

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

event SCInitialized()
{
    super.SCInitialized();
    // DebugMode: 0
    assert(mParentLobbyScreen != none);
    //return;    
}

// Export UTurokFEMultiplayerLobbyModeOverlay::execInitList(FFrame&, void* const)
protected native function InitList();

// Export UTurokFEMultiplayerLobbyModeOverlay::execActivate(FFrame&, void* const)
protected native function Activate();

// Export UTurokFEMultiplayerLobbyModeOverlay::execChangeDescriptionLabel(FFrame&, void* const)
protected native function ChangeDescriptionLabel();

// Export UTurokFEMultiplayerLobbyModeOverlay::execOnModeClick(FFrame&, void* const)
native function OnModeClick(byte SelectedMode);

// Export UTurokFEMultiplayerLobbyModeOverlay::execOnSaveClick(FFrame&, void* const)
native function OnSaveClick(int Index);

defaultproperties
{
    kXbox360LobbyModes=/* Array type was not detected. */
    kPS3LobbyModes=/* Array type was not detected. */
    SceneName="TurokFEMultiplayer.LobbyModeOverlay"
}