class SkySeqAct_ToggleRocketPack extends SequenceAction;

var() bool bToggleThrustInsteadOfHover;
var() bool bResetPlayerCompletely;

event Activated()
{
    local SkyPawn pPawn;

    pPawn = SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x182
    if((pPawn != none) && pPawn.RocketPack != none)
    {
        // End:0x137
        if(InputLinks[0].bHasImpulse)
        {
            // End:0x120
            if(bToggleThrustInsteadOfHover)
            {
                // End:0x109
                if(bResetPlayerCompletely)
                {
                    SkyVehicle(pPawn.DrivenVehicle).DriverLeave(true);
                    pPawn.TurnOffRocketPackThrust();
                    pPawn.StopRocketPack();
                    pPawn.RocketPack.bHasDoubleJump = true;
                    pPawn.bIsRocketPacking = false;
                    pPawn.SetPhysics(1);                    
                }
                else
                {
                    pPawn.TurnOffRocketPackThrust();
                }                
            }
            else
            {
                pPawn.TurnOffRocketPack();
            }            
        }
        else
        {
            // End:0x182
            if(InputLinks[1].bHasImpulse)
            {
                // End:0x16D
                if(bToggleThrustInsteadOfHover)
                {
                    pPawn.TurnOnRocketPackThrust();                    
                }
                else
                {
                    pPawn.TurnOnRocketPack(true);
                }
            }
        }
    }
    //return;    
}
