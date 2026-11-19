class UTSkelControl_CicadaEngine extends SkelControlSingleBone
    hidecategories(Object,Object,Translation,Rotation,Adjustment);

var() float ForwardPitch;
var() float BackPitch;
var() float PitchRate;
var() float MaxVelocity;
var() float MinVelocity;
var() float MaxVelocityPitchRateMultiplier;
var transient float PitchTime;
var transient float LastThrust;
var transient int DesiredPitch;

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    local UDKVehicle OwnerVehicle;
    local float Speed, Pct;

    OwnerVehicle = UDKVehicle(SkelComp.Owner);
    PitchTime = PitchRate;
    // End:0x265
    if(((OwnerVehicle != none) && OwnerVehicle.bDriving) && SkelComp.LastRenderTime > (OwnerVehicle.WorldInfo.TimeSeconds - 0.2000000))
    {
        // End:0x23A
        if(OwnerVehicle.OutputGas != LastThrust)
        {
            // End:0x147
            if(OwnerVehicle.OutputGas > float(0))
            {
                DesiredPitch = int(ForwardPitch * 182.0444000);                
            }
            else
            {
                // End:0x18C
                if(OwnerVehicle.OutputGas < float(0))
                {
                    DesiredPitch = int(BackPitch * 182.0444000);                    
                }
                else
                {
                    DesiredPitch = 0;
                }
            }
            Speed = FClamp(VSize2D(OwnerVehicle.Velocity), MinVelocity, MaxVelocity);
            Pct = (Speed - MinVelocity) / (MaxVelocity - MinVelocity);
            PitchTime *= (float(1) + ((MaxVelocityPitchRateMultiplier - float(1)) * Pct));
        }
        LastThrust = OwnerVehicle.OutputGas;        
    }
    else
    {
        DesiredPitch = 0;
    }
    // End:0x37F
    if(BoneRotation.Pitch != DesiredPitch)
    {
        BoneRotation.Pitch += int((float(DesiredPitch - BoneRotation.Pitch) * DeltaTime) / PitchTime);
        PitchTime -= DeltaTime;
        // End:0x37F
        if((PitchTime <= float(0)) || DesiredPitch == BoneRotation.Pitch)
        {
            PitchTime = 0.0000000;
            BoneRotation.Pitch = DesiredPitch;
        }
    }
    //return;    
}

defaultproperties
{
    ForwardPitch=-40.0000000
    BackPitch=40.0000000
    PitchRate=0.5000000
    MaxVelocity=2100.0000000
    MinVelocity=100.0000000
    MaxVelocityPitchRateMultiplier=0.1500000
    bApplyRotation=true
    bAddRotation=true
    BoneRotationSpace=EBoneControlSpace.BCS_ActorSpace
    bIgnoreWhenNotRendered=true
    bShouldTickInScript=true
}