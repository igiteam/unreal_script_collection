class SkyAnimNotify_Rumble extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() array<WaveformSample> Rumble;
var() float RumbleRadius;
var() bool bOnlyOnGround;
var() bool bAllowShakeWhenBasedOnShaker;
var() bool bNoFalloffFromDistance;
var() bool bUseBoneLocation;
var() bool bPlayerOwnerOnly;
var() name BoneName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPlayerController SPC;
    local float DistToOrigin;
    local Vector RumbleShakeOrigin, CamLoc;
    local Rotator CamRot;
    local ForceFeedbackWaveform FFWaveform;
    local int I;
    local Actor Instigator;

    // End:0x88
    if(((bUseBoneLocation && RumbleRadius != float(-1)) && AnimSeqInstigator != none) && AnimSeqInstigator.SkelComponent != none)
    {
        RumbleShakeOrigin = AnimSeqInstigator.SkelComponent.GetBoneLocation(BoneName);
        Instigator = AnimSeqInstigator.SkelComponent.Owner;        
    }
    else
    {
        RumbleShakeOrigin = Owner.Location;
        Instigator = Owner;
    }
    // End:0xE6
    if((bPlayerOwnerOnly && Pawn(Owner) != none) && SkyPlayerController(Pawn(Owner).Controller) == none)
    {
        return;
    }
    FFWaveform = new (Outer) Class'Engine.ForceFeedbackWaveform';
    // End:0x15E
    if(FFWaveform != none)
    {
        FFWaveform.Samples.Insert(0, Rumble.Length);
        I = 0;
        J0x123:

        // End:0x15E [Loop If]
        if(I < Rumble.Length)
        {
            FFWaveform.Samples[I] = Rumble[I];
            ++I;
            // [Loop Continue]
            goto J0x123;
        }
    }
    // End:0x303
    if(Owner != none)
    {
        // End:0x302
        foreach Owner.WorldInfo.LocalPlayerControllers(Class'SkyPlayerController', SPC)
        {
            // End:0x1C3
            if(!bAllowShakeWhenBasedOnShaker && SPC.Pawn.IsBasedOn(Instigator))
            {
                continue;                
            }
            // End:0x24B
            if(bOnlyOnGround)
            {
                // End:0x1F2
                if(SPC.Pawn.Base == none)
                {
                    continue;                                        
                }
                else
                {
                    // End:0x24B
                    if((SkyAirVehicle(SPC.Pawn.Base) != none) && SkyAirVehicle(SPC.Pawn.Base).bVehicleOnGround == false)
                    {
                        continue;                        
                    }
                }
            }
            // End:0x278
            if(RumbleRadius == float(-1))
            {
                SPC.ClientPlayForceFeedbackWaveform(FFWaveform);
                // End:0x301
                continue;
            }
            SPC.GetPlayerViewPoint(CamLoc, CamRot);
            DistToOrigin = VSize(RumbleShakeOrigin - CamLoc);
            // End:0x301
            if(DistToOrigin < RumbleRadius)
            {
                // End:0x2DE
                if(bNoFalloffFromDistance)
                {
                    SPC.ClientPlayForceFeedbackWaveform(FFWaveform);
                    // End:0x301
                    continue;
                }
                SPC.RumbleByDistance(FFWaveform, DistToOrigin, RumbleRadius);
            }            
        }        
    }
    //return;    
}
