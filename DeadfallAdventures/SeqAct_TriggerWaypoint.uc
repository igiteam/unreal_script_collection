class SeqAct_TriggerWaypoint extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor Target;
var() bool Hidden;

event Activated()
{
    local EvilObjectives Objectives;
    local EvilGame Game;

    Game = EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    Objectives = Game.Objectives;
    Objectives.SetWaypoint(Hidden, Target);
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Trigger Waypoint"
}