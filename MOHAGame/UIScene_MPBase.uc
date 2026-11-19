class UIScene_MPBase extends UIScene_MOHABase
    abstract
    native
    hidecategories(Object,UIRoot,Object)
    implements(UIDataStoreSubscriber);

var private native const noexport Pointer VfTable_IUIDataStoreSubscriber;
var transient int m_WinningTeamIndex;
var transient int m_RoundStatus;
var UILabel m_RemainingTime;
var UILabel m_RemainingTimeText;
var name m_RemainingTimeWidgetName;
var name m_RemainingTimeTextWidgetName;
var string PreGameTimerMarkup;
var string EndRoundTimerMarkup;
var string EndMatchTimerMarkup;
var(Player) LinearColor NameColor;
var(Player) LinearColor DisconnectColor;

// Export UUIScene_MPBase::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

event SetupLabels()
{
    super.SetupLabels();
    m_RemainingTime = UILabel(FindChild(m_RemainingTimeWidgetName, true));
    m_RemainingTimeText = UILabel(FindChild(m_RemainingTimeTextWidgetName, true));
    //return;    
}

function bool OnShowGamerCard(UIScreenObject obj)
{
    //return ReturnValue;    
}

function bool OnLeaveFeedback(UIScreenObject obj)
{
    //return ReturnValue;    
}

function bool OnKickPlayer(UIScreenObject obj)
{
    //return ReturnValue;    
}

event bool ShowGamercard(int ControllerId, UniqueNetId Id)
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x44
    if(P != none)
    {
        return P.ShowGamerCardUI(byte(ControllerId), Id);
    }
    return false;
    //return ReturnValue;    
}

event bool LeaveFeedback(int ControllerId, UniqueNetId Id)
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x44
    if(P != none)
    {
        return P.ShowFeedbackUI(byte(ControllerId), Id);
    }
    return false;
    //return ReturnValue;    
}

event ExitToShell(MOHAIncludeClass.EShellStartPosition startPos)
{
    local Plasma P;
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameResourceDatastore;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x4B
    if((int(startPos) == int(2)) && !P.IsSignedIn())
    {
        startPos = 1;
    }
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x129
    if(DataStoreManager != none)
    {
        GameResourceDatastore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
        // End:0x129
        if(GameResourceDatastore != none)
        {
            GameResourceDatastore.ShellStartPos = int(startPos);
            LP = GetPlayerOwner();
            // End:0x129
            if((LP != none) && LP.Actor != none)
            {                
                LP.Actor.ConsoleCommand("open ?closed?game=MOHAGame.MOHAGameInfo");
            }
        }
    }
    //return;    
}

// Export UUIScene_MPBase::execSetDataStoreBinding(FFrame&, void* const)
native final function SetDataStoreBinding(string MarkupText, optional int BindingIndex);

// Export UUIScene_MPBase::execGetDataStoreBinding(FFrame&, void* const)
native final function string GetDataStoreBinding(optional int BindingIndex);

// Export UUIScene_MPBase::execRefreshSubscriberValue(FFrame&, void* const)
native final function bool RefreshSubscriberValue(optional int BindingIndex);

// Export UUIScene_MPBase::execGetBoundDataStores(FFrame&, void* const)
native final function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

// Export UUIScene_MPBase::execClearBoundDataStores(FFrame&, void* const)
native final function ClearBoundDataStores();

defaultproperties
{
    m_WinningTeamIndex=-1
    m_RoundStatus=-1
    m_RemainingTimeWidgetName="RemainingTime"
    m_RemainingTimeTextWidgetName="NextRound"
    PreGameTimerMarkup="<Strings:UIStrings.MP_Scoreboard.MatchStartsIn>"
    EndRoundTimerMarkup="<Strings:UIStrings.MP_Scoreboards.NextRound>"
    EndMatchTimerMarkup="<Strings:UIStrings.MP_Scoreboard.EndMatchIn>"
    NameColor=(R=0.0000000,G=0.2000000,B=0.7000000,A=1.0000000)
    DisconnectColor=(R=0.9000000,G=0.0000000,B=0.1000000,A=1.0000000)
    bPauseGameWhileActive=false
    bSaveSceneValuesOnClose=false
    // Reference: UIComp_Event'Default__UIScene_MPBase.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}