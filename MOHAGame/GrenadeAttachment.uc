class GrenadeAttachment extends WeaponAttachment
    abstract
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

simulated function AssignSoundSetIndex()
{
    //return;    
}

simulated function AttachDynamicLight()
{
    //return;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__GrenadeAttachment.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__GrenadeAttachment.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
}