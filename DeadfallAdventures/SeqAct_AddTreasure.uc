class SeqAct_AddTreasure extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var AdvPlayerPawn TargetPawn;
var AdvPlayerController TargetController;
var() int TreasureAmount;

event Activated()
{
    local SeqVar_ObjectList ObjList;
    local Object ObjVar;
    local int Counter;

    // End:0x418
    foreach LinkedVariables(Class'Engine.SeqVar_ObjectList', ObjList, "Target")
    {
        // End:0x416
        foreach ObjList.ObjList(ObjVar)
        {
            // End:0x253
            if(AdvPlayerPawn(ObjVar) != none)
            {
                TargetPawn = AdvPlayerPawn(ObjVar);
                // End:0x250
                if(((((TargetPawn != none) && TargetPawn.Controller != none) && Class'Engine.WorldInfo'.static.GetWorldInfo().Game != none) && AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none) && AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PerkManager != none)
                {
                    Counter = 0;
                    J0x1A2:

                    // End:0x250 [Loop If]
                    if(Counter < TreasureAmount)
                    {
                        AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PerkManager.IncreaseKillStrikeScore(1, TargetPawn.Controller);
                        Counter++;
                        // [Loop Continue]
                        goto J0x1A2;
                    }
                }                
            }
            else
            {
                // End:0x415
                if(AdvPlayerController(ObjVar) != none)
                {
                    TargetController = AdvPlayerController(ObjVar);
                    // End:0x415
                    if((((TargetController != none) && Class'Engine.WorldInfo'.static.GetWorldInfo().Game != none) && AdvGameSurvivalBase(Class'Engine.WorldInfo'.static.GetWorldInfo().Game) != none) && AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PerkManager != none)
                    {
                        Counter = 0;
                        J0x37C:

                        // End:0x415 [Loop If]
                        if(Counter < TreasureAmount)
                        {
                            AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).PerkManager.IncreaseKillStrikeScore(1, TargetController);
                            Counter++;
                            // [Loop Continue]
                            goto J0x37C;
                        }
                    }
                }
            }            
        }                
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    TreasureAmount=1
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Amount",LinkVar="None",PropertyName="TreasureAmount",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Add Treasure"
}