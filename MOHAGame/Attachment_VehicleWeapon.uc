class Attachment_VehicleWeapon extends SmallArmsAttachment
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x4A
    if(MOHAVehicle(Owner) != none)
    {
        Mesh = MOHAVehicle(Owner).Mesh;
        Instigator = Pawn(Owner);
        SetBase(Owner);
    }
    AttachVisualEffects();
    AssignSoundSetIndex();
    //return;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__Attachment_VehicleWeapon.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__Attachment_VehicleWeapon.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    // Reference: AudioComponent'Default__Attachment_VehicleWeapon.DryFireSound'
    begin object name=DryFireSound
    end object
    WeaponDryFireSound=DryFireSound
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__Attachment_VehicleWeapon.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}