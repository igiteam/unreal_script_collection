class SkyAnimNotify_CameraShake extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() ViewShakeInfo CameraShake;
var() float MaxRadius;
var() bool bOnlyOnGround;
var() bool bAllowShakeWhenBasedOnShaker;
var() bool bNoFalloffFromDistance;
var() bool bUseBoneLocation;
var() name BoneName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPlayerController SPC;
    local float DistToOrigin;
    local Vector ViewShakeOrigin, CamLoc;
    local Rotator CamRot;
    local Actor Instigator;

    // End:0x88
    if(((bUseBoneLocation && MaxRadius != float(-1)) && AnimSeqInstigator != none) && AnimSeqInstigator.SkelComponent != none)
    {
        ViewShakeOrigin = AnimSeqInstigator.SkelComponent.GetBoneLocation(BoneName);
        Instigator = AnimSeqInstigator.SkelComponent.Owner;        
    }
    else
    {
        ViewShakeOrigin = Owner.Location;
        Instigator = Owner;
    }
    // End:0x24D
    if(Owner != none)
    {
        // End:0x24C
        foreach Owner.WorldInfo.LocalPlayerControllers(Class'SkyPlayerController', SPC)
        {
            // End:0x10D
            if(!bAllowShakeWhenBasedOnShaker && SPC.Pawn.IsBasedOn(Instigator))
            {
                continue;                
            }
            // End:0x195
            if(bOnlyOnGround)
            {
                // End:0x13C
                if(SPC.Pawn.Base == none)
                {
                    continue;                                        
                }
                else
                {
                    // End:0x195
                    if((SkyAirVehicle(SPC.Pawn.Base) != none) && SkyAirVehicle(SPC.Pawn.Base).bVehicleOnGround == false)
                    {
                        continue;                        
                    }
                }
            }
            // End:0x1C2
            if(MaxRadius == float(-1))
            {
                SPC.ShakeView(CameraShake);
                // End:0x24B
                continue;
            }
            SPC.GetPlayerViewPoint(CamLoc, CamRot);
            DistToOrigin = VSize(ViewShakeOrigin - CamLoc);
            // End:0x24B
            if(DistToOrigin < MaxRadius)
            {
                // End:0x228
                if(bNoFalloffFromDistance)
                {
                    SPC.ShakeView(CameraShake);
                    // End:0x24B
                    continue;
                }
                SPC.CameraShakeByDistance(CameraShake, DistToOrigin, MaxRadius);
            }            
        }        
    }
    //return;    
}
