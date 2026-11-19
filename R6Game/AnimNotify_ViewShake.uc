class AnimNotify_ViewShake extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float ShakeRadius;
var() float Duration;
var() Vector RotAmplitude;
var() Vector RotFrequency;
var() Vector LocAmplitude;
var() Vector LocFrequency;
var() float FOVAmplitude;
var() float FOVFrequency;
var() bool bUseBoneLocation;
var() name BoneName;

event Notify(SkeletalMeshComponent SkelComponent)
{
    local PlayerController PC;
    local float Pct, DistToOrigin;
    local Vector ViewShakeOrigin, CamLoc;
    local Rotator CamRot;

    // End:0x12D
    if(SkelComponent != none)
    {
        // End:0x2F
        if(bUseBoneLocation)
        {
            ViewShakeOrigin = SkelComponent.GetBoneLocation(BoneName);
        }
        // End:0x12D
        if(SkelComponent.Owner != none)
        {
            // End:0x12C
            foreach SkelComponent.Owner.WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                PC.GetPlayerViewPoint(CamLoc, CamRot);
                DistToOrigin = VSize(ViewShakeOrigin - CamLoc);
                // End:0x12B
                if(DistToOrigin < ShakeRadius)
                {
                    Pct = 1.0000000 - (DistToOrigin / ShakeRadius);
                    PC.CameraShake(Duration * Pct, RotAmplitude * Pct, RotFrequency * Pct, LocAmplitude * Pct, LocFrequency * Pct, FOVAmplitude * Pct, FOVFrequency * Pct);
                }                
            }            
        }
    }
    return;
}

defaultproperties
{
    ShakeRadius=4096.0000000
    Duration=1.0000000
    RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000)
    RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000)
    LocAmplitude=(X=0.0000000,Y=3.0000000,Z=6.0000000)
    LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000)
    FOVAmplitude=2.0000000
    FOVFrequency=5.0000000
}