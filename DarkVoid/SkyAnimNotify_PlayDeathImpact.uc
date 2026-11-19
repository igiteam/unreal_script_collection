class SkyAnimNotify_PlayDeathImpact extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() float ImpactSpeed;
var() Vector CheckDirection;
var() SkyPawnSoundGroup.EBoneImpactType BoneImpactType;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;
    local TraceHitInfo HitInfo;
    local Vector StartLoc, EndLoc, HitLoc, HitNorm;
    local Actor HitActor;
    local SkyPhysicalMaterialProperty PhysProp;
    local name PABone;
    local SkyPawnSoundGroup SGroup;

    SP = SkyPawn(Owner);
    StartLoc = SP.Location;
    EndLoc = StartLoc + CheckDirection;
    HitActor = SP.Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo);
    // End:0x197
    if(HitActor != none)
    {
        PhysProp = SkyPhysicalMaterialProperty(HitInfo.PhysMaterial.PhysicalMaterialProperty);
        SGroup = SkyPawnSoundGroup(SP.SoundGroup);
        // End:0x197
        if((PhysProp != none) && SGroup != none)
        {
            PABone = 'None';
            // End:0x125
            if((int(BoneImpactType) == int(1)) && SGroup.UpperTorsoBones.Length > 0)
            {
                PABone = SGroup.UpperTorsoBones[0];                
            }
            else
            {
                // End:0x164
                if((int(BoneImpactType) == int(2)) && SGroup.ArmsLegsBones.Length > 0)
                {
                    PABone = SGroup.ArmsLegsBones[0];
                }
            }
            SP.PlayDeathImpact(ImpactSpeed, PhysProp.MaterialType, PABone, HitLoc, HitNorm);
        }
    }
    //return;    
}
