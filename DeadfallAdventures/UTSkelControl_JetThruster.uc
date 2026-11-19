class UTSkelControl_JetThruster extends SkelControlSingleBone
    hidecategories(Object,Object,Translation,Rotation,Adjustment);

var(Thruster) float MaxForwardVelocity;
var(Thruster) float BlendRate;
var transient float DesiredStrength;

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    local UDKVehicle OwnerVehicle;
    local float NewDesiredStrength, DPV, Thrust;

    OwnerVehicle = UDKVehicle(SkelComp.Owner);
    // End:0x220
    if((OwnerVehicle != none) && SkelComp.LastRenderTime > (OwnerVehicle.WorldInfo.TimeSeconds - 0.2000000))
    {
        // End:0x19A
        if(OwnerVehicle.bDriving)
        {
            DPV = OwnerVehicle.Velocity Dot Vector(OwnerVehicle.Rotation);
            // End:0x188
            if(DPV > 0.0000000)
            {
                Thrust = FClamp(VSize2D(OwnerVehicle.Velocity), 0.0000000, MaxForwardVelocity);
                NewDesiredStrength = 1.0000000 - (Thrust / MaxForwardVelocity);                
            }
            else
            {
                NewDesiredStrength = 1.0000000;
            }            
        }
        else
        {
            NewDesiredStrength = 1.0000000;
        }
        // End:0x220
        if(NewDesiredStrength != DesiredStrength)
        {
            BlendTimeToGo += ((NewDesiredStrength - DesiredStrength) * BlendRate);
            BlendTimeToGo = FClamp(BlendTimeToGo, 0.0000000, BlendRate);
            StrengthTarget = NewDesiredStrength;
        }
    }
    //return;    
}

defaultproperties
{
    MaxForwardVelocity=1500.0000000
    BlendRate=0.3000000
    DesiredStrength=1.0000000
    bIgnoreWhenNotRendered=true
    bShouldTickInScript=true
}