class SeqAct_GetPlayers extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var int Amount;

event Activated()
{
    Amount = Class'Engine.WorldInfo'.static.GetWorldInfo().Game.NumPlayers;
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Amount",LinkVar="None",PropertyName="Amount",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Get Number of Players"
}