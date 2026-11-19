class NavAct_POIBehavior extends AdvNavPointAction
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EPOI_Behaviour
{
    POI_Idle,                       // 0
    POI_View,                       // 1
    POI_Read,                       // 2
    POI_MAX                         // 3
};

var array< class<EvilAICommand> > BehaviorCommands;
var() NavAct_POIBehavior.EPOI_Behaviour BehaviourType;
var() float Duration;

function StartNavAction()
{
    //return;    
}

function bool IsNavActionActive()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    BehaviorCommands[0]=Class'AdvAICmd_POIBehavior'
    DefaultAICommand=Class'AdvAICmd_POIBehavior'
}