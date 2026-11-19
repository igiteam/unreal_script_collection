class SeqAct_StartPuzzle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvPuzzle_Base Puzzle;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local AdvPlayerController PC;

    // End:0xF8
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = EvilPawn(ObjVar.GetObjectValue());
        // End:0x6D
        if(P == none)
        {
            continue;            
        }
        // End:0xF7
        if(InputLinks[0].bHasImpulse)
        {
            PC = AdvPlayerController(P.Controller);
            // End:0xF7
            if(PC != none)
            {
                PC.StartPuzzle(Puzzle);
            }
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Puzzle",LinkVar="None",PropertyName="Puzzle",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Start Puzzle"
}