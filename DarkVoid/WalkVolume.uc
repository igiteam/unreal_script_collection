class WalkVolume extends PhysicsVolume
    native;

var() bool bDisabled;
var() float WalkingPercentOverride;

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bDisabled = false;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bDisabled = true;            
        }
        else
        {
            // End:0x86
            if(Action.InputLinks[2].bHasImpulse)
            {
                bDisabled = !bDisabled;
            }
        }
    }
    //return;    
}
