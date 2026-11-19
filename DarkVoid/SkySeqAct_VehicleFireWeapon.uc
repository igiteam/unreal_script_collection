class SkySeqAct_VehicleFireWeapon extends SequenceAction;

var() bool bStartPrimary;
var() bool bStartSecondary;
var() bool bStopPrimary;
var() bool bStopSecondary;

event Activated()
{
    local SkyVehicle SV;
    local SkyPawn SP;
    local SkyPlayerController SPC;

    SV = SkyVehicle(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x133
    if(SV == none)
    {
        SP = SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
        SPC = SkyPlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
        // End:0x10E
        if(SP != none)
        {
            // End:0xE1
            if(SP.DrivenVehicle != none)
            {
                SV = SkyVehicle(SP.DrivenVehicle);                
            }
            else
            {
                // End:0x10B
                if(SP.RocketPackThrustVehicle != none)
                {
                    SV = SP.RocketPackThrustVehicle;
                }
            }            
        }
        else
        {
            // End:0x133
            if(SPC != none)
            {
                SV = SkyVehicle(SPC.Pawn);
            }
        }
    }
    // End:0x1B2
    if(SV != none)
    {
        // End:0x15D
        if(bStartPrimary)
        {
            SV.StartFire(0);
        }
        // End:0x178
        if(bStartSecondary)
        {
            SV.StartSecondaryFire(0);
        }
        // End:0x197
        if(bStopPrimary)
        {
            SV.StopFire(0);
        }
        // End:0x1B2
        if(bStopSecondary)
        {
            SV.StopSecondaryFire(0);
        }
    }
    //return;    
}
