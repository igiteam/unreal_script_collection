class SkySeqAct_DisableVehicleWeapons extends SequenceAction;

var() bool bDisablePrimaryFire;
var() bool bDisableSecondaryFire;

event Activated()
{
    local SkyVehicle SV;
    local SkyPawn SP;

    SV = SkyVehicle(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0x6E
    if(SV != none)
    {
        SV.bKismetDisabledPrimaryFire = bDisablePrimaryFire;
        SV.bKismetDisabledSecondaryFire = bDisableSecondaryFire;
        return;
    }
    SP = SkyPawn(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue());
    // End:0xEE
    if(SP == none)
    {
        SP = SkyPawn(SkyPlayerController(SeqVar_Object(VariableLinks[0].LinkedVariables[0]).GetObjectValue()).Pawn);
    }
    // End:0x17E
    if(SP != none)
    {
        SP.bKismetDisabledRPPrimaryFire = bDisablePrimaryFire;
        SP.bKismetDisabledRPSecondaryFire = bDisableSecondaryFire;
        // End:0x17E
        if(SP.RocketPackThrustVehicle != none)
        {
            SP.RocketPackThrustVehicle.bKismetDisabledPrimaryFire = bDisablePrimaryFire;
            SP.RocketPackThrustVehicle.bKismetDisabledSecondaryFire = bDisableSecondaryFire;
        }
    }
    //return;    
}
