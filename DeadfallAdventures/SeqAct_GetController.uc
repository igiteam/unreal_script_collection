class SeqAct_GetController extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Object Target;
var Object Controller;

event Activated()
{
    local Pawn P;
    local PlayerController PC;

    // End:0x37
    if(PlayerController(Target) != none)
    {
        PC = PlayerController(Target);        
    }
    else
    {
        P = Pawn(Target);
        // End:0x9C
        if(P != none)
        {
            PC = PlayerController(Pawn(Target).Controller);
        }
    }
    Controller = PC;
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Controller",LinkVar="None",PropertyName="Controller",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Get Controller"
}