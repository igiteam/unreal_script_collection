class SkySeqAct_UIPopUpMessage extends SequenceAction
    native;

var() array<UIPopUpChildParameter> arInitParms;
var() UIScene SceneTemplate;
var() byte ForcedPriority;
var() bool bCloseChildScenesOnClose;
var transient bool bFinished;
var() float MessageLifeTime;
var transient SkyPlayerControllerBase SPCB;
var transient UIScene OpenedScene;
var transient name OpenedSceneTag;

function OnSpawnedSceneDeactivated(UIScene DeactivatedScene)
{
    bFinished = true;
    OpenedScene = none;
    //return;    
}

function bool OptionChosen(UIScreenObject EventObject, int iPlayer)
{
    local int iOut;
    local UIObject Obj;
    local string szTest;

    Obj = UIObject(EventObject);
    // End:0xC4
    if(Obj != none)
    {
        szTest = string(Obj.WidgetTag);
        iOut = 0;
        J0x39:

        // End:0xC4 [Loop If]
        if(iOut < OutputLinks.Length)
        {
            // End:0x63
            if(OutputLinks[iOut].bDisabled)
            {
            }
            // End:0xBA
            if((OutputLinks[iOut].LinkDesc == szTest) && !OutputLinks[iOut].bDisabled)
            {
                OutputLinks[iOut].bHasImpulse = true;
            }
            iOut++;
            // [Loop Continue]
            goto J0x39;
        }
    }
    return false;
    //return ReturnValue;    
}

event Activated()
{
    local LocalPlayer LP;
    local GameUISceneClient GameSceneClient;

    GameSceneClient = Class'Engine.UIRoot'.static.GetSceneClient();
    bFinished = false;
    // End:0xD8
    if(InputLinks[0].bHasImpulse && OpenedScene == none)
    {
        // End:0x66
        if(SPCB != none)
        {
            LP = LocalPlayer(SPCB.Player);
        }
        GameSceneClient.MessageBoxOpen(SceneTemplate, arInitParms, OpenedScene, LP, OptionChosen, MessageLifeTime);
        // End:0xD5
        if(OpenedScene != none)
        {
            OpenedScene.__OnSceneDeactivated__Delegate = OnSpawnedSceneDeactivated;
            OpenedSceneTag = OpenedScene.SceneTag;
        }        
    }
    else
    {
        // End:0x114
        if(InputLinks[1].bHasImpulse)
        {
            GameSceneClient.MessageBoxCloseByTag(OpenedSceneTag, bCloseChildScenesOnClose);
            OpenedScene = none;
        }
    }
    //return;    
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}
