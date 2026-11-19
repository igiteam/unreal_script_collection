class Attachment_Pistol extends SmallArmsAttachment
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    ShellImpactType=22
    ShotsNeededForBarrelSmoke=0
    // Reference: MOHASkeletalMeshComponent'Default__Attachment_Pistol.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__Attachment_Pistol.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    // Reference: AudioComponent'Default__Attachment_Pistol.DryFireSound'
    begin object name=DryFireSound
    end object
    WeaponDryFireSound=DryFireSound
    WeaponClass=Class'MOHAPistol'
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__Attachment_Pistol.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}