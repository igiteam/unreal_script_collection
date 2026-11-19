class SeqAct_PKWaitForCorpses extends SeqAct_AIFactoryObserver
    forcescriptorder(true)
    hidecategories(Object);

var() int LimitOfCorpses;

function NotifyPawnDied(SeqAct_AIFactory AIFactory, EvilPawn inPawn)
{
    local PKPawn P;

    P = PKPawn(inPawn);
    // End:0x5A
    if(P != none)
    {
        // End:0x5A
        if(!P.bNotCountable)
        {
            CountedCorpses++;
        }
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0x3A
    if(CountedCorpses >= LimitOfCorpses)
    {
        OutputLinks[0].bHasImpulse = true;
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    ObservableFactoryClass=Class'SeqAct_PKAIFactory'
    VariableLinks=none
    ObjName="Wait For Corpses"
}