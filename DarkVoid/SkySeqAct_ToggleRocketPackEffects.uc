class SkySeqAct_ToggleRocketPackEffects extends SequenceAction;

var() SkyItem_RocketPack.RocketPackTags ActivateTag;
var() SkyItem_RocketPack.RocketPackTags DeactivateTag;

event Activated()
{
    local SkyPawn pPawn;

    pPawn = SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0xCA
    if((pPawn != none) && pPawn.RocketPack != none)
    {
        // End:0x91
        if(InputLinks[0].bHasImpulse)
        {
            pPawn.RocketPack.RocketPackPlayTag(ActivateTag);            
        }
        else
        {
            // End:0xCA
            if(InputLinks[1].bHasImpulse)
            {
                pPawn.RocketPack.RocketPackPlayTag(DeactivateTag);
            }
        }
    }
    //return;    
}
