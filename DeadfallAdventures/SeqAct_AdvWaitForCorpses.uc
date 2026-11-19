class SeqAct_AdvWaitForCorpses extends SeqAct_AIFactoryObserver
    forcescriptorder(true)
    hidecategories(Object);

var() int LimitOfCorpses;
var() bool KillAllToActive;

event bool Update(float DeltaTime)
{
    local SeqVar_Int Var_Int;

    // End:0x109
    if(KillAllToActive)
    {
        EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).AIDirectorInstance.CleanDeadActors();
        // End:0x106
        if(EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).AIDirectorInstance.GetInfluenceActorCount() == 0)
        {
            OutputLinks[0].bHasImpulse = true;
            return false;
        }        
    }
    else
    {
        // End:0x161
        foreach LinkedVariables(Class'Engine.SeqVar_Int', Var_Int, "LimitOfCorpses")
        {
            LimitOfCorpses = Var_Int.IntValue;            
        }        
        // End:0x19C
        if(CountedCorpses >= LimitOfCorpses)
        {
            OutputLinks[0].bHasImpulse = true;
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    ObservableFactoryClass=Class'SeqAct_AdvAIFactory'
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="LimitOfCorpses",LinkVar="None",PropertyName="LimitOfCorpses",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Wait For Corpses"
}