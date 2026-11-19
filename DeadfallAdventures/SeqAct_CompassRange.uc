class SeqAct_CompassRange extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() float MaxDistance;

event Activated()
{
    local AdvInventoryItem_Compass Compass;
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x15E
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(EvilPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = EvilPawn(EvilPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = EvilPawn(ObjVar.GetObjectValue());
        }
        // End:0x15D
        if(P != none)
        {
            Compass = AdvInventoryItem_Compass(P.FindInventoryType(Class'AdvInventoryItem_Compass'));
            // End:0x15D
            if(Compass != none)
            {
                Compass.MaxDistanceToTarget = MaxDistance;
            }
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    MaxDistance=3000.0000000
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Compass Range"
}