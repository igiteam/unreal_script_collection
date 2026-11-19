class SeqAct_CompassWaypoint extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvTreasureTrigger_Base LastTarget;
var AdvTreasureTrigger_Base NextTarget;
var() bool bHideLast;

event Activated()
{
    local AdvInventoryItem_Compass Compass;
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x238
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
        // End:0x237
        if(P != none)
        {
            // End:0x194
            if(LastTarget != none)
            {
                // End:0x194
                if(NextTarget == none)
                {
                    Compass = AdvInventoryItem_Compass(P.FindInventoryType(Class'AdvInventoryItem_Compass'));
                    // End:0x194
                    if(Compass != none)
                    {
                        Compass.SetNextTarget(none);
                        Compass.AutomaticTargetFinding = true;
                    }
                }
            }
            // End:0x237
            if(NextTarget != none)
            {
                Compass = AdvInventoryItem_Compass(P.FindInventoryType(Class'AdvInventoryItem_Compass'));
                // End:0x237
                if(Compass != none)
                {
                    Compass.AutomaticTargetFinding = false;
                    Compass.SetNextTarget(NextTarget);
                }
            }
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Last Target",LinkVar="None",PropertyName="LastTarget",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Next Target",LinkVar="None",PropertyName="NextTarget",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Compass Waypoint"
}