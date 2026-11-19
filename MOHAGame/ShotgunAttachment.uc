class ShotgunAttachment extends SingleShotReloadWeaponAttachment
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

var export editinline array<export editinline ParticleSystemComponent> HitspangPSCArray;
var int HitspangPSCIndex;

simulated function SetPelletsPerShot(int pellets_per_shot)
{
    local int I;
    local editinline ParticleSystemComponent lHS_PSC;

    HitspangPSCArray.Length = pellets_per_shot;
    I = 0;
    J0x13:

    // End:0x4C [Loop If]
    if(I < pellets_per_shot)
    {
        InitHitspangPSC(lHS_PSC);
        HitspangPSCArray[I] = lHS_PSC;
        I++;
        // [Loop Continue]
        goto J0x13;
    }
    //return;    
}

simulated function KickoffHitSpang(ImpactInfo Impact, int ImpactType)
{
    local editinline ParticleSystemComponent lHS_PSC;

    lHS_PSC = HitspangPSCArray[HitspangPSCIndex];
    CreateHitSpangEffect(lHS_PSC, Impact, ImpactType);
    HitspangPSCIndex++;
    // End:0x48
    if(HitspangPSCIndex >= HitspangPSCArray.Length)
    {
        HitspangPSCIndex = 0;
    }
    //return;    
}

defaultproperties
{
    ShellImpactType=23
    ShotsNeededForBarrelSmoke=0
    // Reference: MOHASkeletalMeshComponent'Default__ShotgunAttachment.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__ShotgunAttachment.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    // Reference: AudioComponent'Default__ShotgunAttachment.DryFireSound'
    begin object name=DryFireSound
    end object
    WeaponDryFireSound=DryFireSound
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__ShotgunAttachment.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}