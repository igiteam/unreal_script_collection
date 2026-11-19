class SeqAct_PandoraCheckPoint extends SequenceAction
    native;

var UIScene CheckDeviceScene;
/** Whether to display the checkpointing text on the screen */
var() bool bDisplayCheckpointingText;
/** Whether to fire off the check poing activated event */
var() bool bFireCheckPointActivedEvent;
/** Whether to fire off the Toggle HUD enable command. */
var() bool bFireToggleHUDOn;
var bool bIsDone;
var transient bool bShouldSave;

event SetupScene(UIScene_CheckDevice Scene)
{
    Scene.__OnSceneClose__Delegate = OnSceneClose;
    //return;    
}

function OnSceneClose()
{
    bIsDone = true;
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 2;
    //return ReturnValue;    
}
