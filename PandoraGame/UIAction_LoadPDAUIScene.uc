class UIAction_LoadPDAUIScene extends UIAction
    native;

var() PandoraGameInfo.EMessage_Type MsgType;
var() UIScene loadedUIScene;
var int Index;
var bool bIsDone;
var UIScene PDALoadingUIScene;
var transient UIScene OpenedPDALoadingUIScene;

function PDAAsyncPackageLoadedNotify(PDAAsyncPackageCBData CBData)
{
    local UIScene SceneOwner;

    bIsDone = true;
    loadedUIScene = CBData.LoadedScene;
    PopulateLinkedVariableValues();
    // End:0x82
    if(OpenedPDALoadingUIScene != none)
    {
        SceneOwner = GetOwnerScene();
        // End:0x7B
        if(SceneOwner != none)
        {
            // End:0x7B
            if(SceneOwner.SceneClient != none)
            {
                SceneOwner.SceneClient.CloseScene(OpenedPDALoadingUIScene);
            }
        }
        OpenedPDALoadingUIScene = none;
    }
    //return;    
}

event OnActivated(PandoraGameInfo GameInfo, string UISceneName)
{
    local bool bStartedLoading, bOpenedLoadingScene;
    local UIScene SceneOwner;

    bIsDone = false;
    loadedUIScene = none;
    PopulateLinkedVariableValues();
    bStartedLoading = GameInfo.LoadCurrPDAUIScene(self, UISceneName, PDAAsyncPackageLoadedNotify);
    // End:0xF4
    if(bStartedLoading)
    {
        SceneOwner = GetOwnerScene();
        // End:0xF1
        if(SceneOwner != none)
        {
            // End:0xEE
            if(SceneOwner.SceneClient != none)
            {
                // End:0xA6
                if(OpenedPDALoadingUIScene != none)
                {
                    SceneOwner.SceneClient.CloseScene(OpenedPDALoadingUIScene);
                    OpenedPDALoadingUIScene = none;
                }
                bOpenedLoadingScene = SceneOwner.SceneClient.OpenScene(PDALoadingUIScene, none, OpenedPDALoadingUIScene);
                // End:0xEB
                if(!bOpenedLoadingScene || OpenedPDALoadingUIScene == none)
                {
                }                
            }            
        }        
    }
    else
    {
        bIsDone = true;
    }
    //return;    
}
