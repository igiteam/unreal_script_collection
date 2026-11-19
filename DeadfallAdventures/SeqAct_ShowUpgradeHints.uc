class SeqAct_ShowUpgradeHints extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var class<AdvFocusHighlightComponent_UpgradesEgypt> HighlightComponentClassEgypt;
var class<AdvFocusHighlightComponent_UpgradesMayan> HighlightComponentClassMayan;
var() bool bHightlightInstantly;

event Activated()
{
    local Actor TheActor;
    local int I;

    I = 0;
    J0x0B:

    // End:0x1B8 [Loop If]
    if(I < Targets.Length)
    {
        TheActor = Actor(Targets[I]);
        // End:0xC1
        if(TheActor == none)
        {
            ScriptLog((((("WARNING: Invalid target in " @ string(self)) @ ". Target[") $ string(I)) $ "] = ") $ string(Targets[I]));            
        }
        else
        {
            // End:0x197
            if(InputLinks[0].bHasImpulse)
            {
                // End:0x162
                if(DynamicSMActor(TheActor).StaticMeshComponent.StaticMesh == StaticMesh'adv_en_egypt_Treasure_01.Meshes.sm_en_treasureegypt_04_01')
                {
                    HighlightComponentClassEgypt.static.HighlightActor(TheActor, bHightlightInstantly);                    
                }
                else
                {
                    HighlightComponentClassMayan.static.HighlightActor(TheActor, bHightlightInstantly);
                }                
            }
            else
            {
                DisableHighlights(TheActor);
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

protected function DisableHighlights(Actor A)
{
    local editinline AdvFocusHighlightComponent FHC;

    // End:0x7F
    if(DynamicSMActor(A).StaticMeshComponent.StaticMesh == StaticMesh'adv_en_egypt_Treasure_01.Meshes.sm_en_treasureegypt_04_01')
    {
        FHC = HighlightComponentClassEgypt.static.GetForActor(A);        
    }
    else
    {
        FHC = HighlightComponentClassMayan.static.GetForActor(A);
    }
    // End:0xE9
    if(FHC != none)
    {
        FHC.Dehighlight(bHightlightInstantly);
    }
    //return;    
}

defaultproperties
{
    HighlightComponentClassEgypt=Class'AdvFocusHighlightComponent_UpgradesEgypt'
    HighlightComponentClassMayan=Class'AdvFocusHighlightComponent_UpgradesMayan'
    bCallHandler=false
    InputLinks[0]=(LinkDesc="On",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Off",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Upgrade Hints"
}