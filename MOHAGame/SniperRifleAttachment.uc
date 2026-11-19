class SniperRifleAttachment extends SingleShotReloadWeaponAttachment
    abstract
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

var bool bIsSniping;

function BeginSniperZoom()
{
    bIsSniping = true;
    //return;    
}

function EndSniperZoom()
{
    bIsSniping = false;
    //return;    
}

simulated function EjectShell()
{
    // End:0x0E
    if(bIsSniping == true)
    {
        return;
    }
    super.EjectShell();
    //return;    
}

simulated function StartMuzzleFlash()
{
    // End:0x0E
    if(bIsSniping == true)
    {
        return;
    }
    super(SmallArmsAttachment).StartMuzzleFlash();
    //return;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__SniperRifleAttachment.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__SniperRifleAttachment.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    // Reference: AudioComponent'Default__SniperRifleAttachment.DryFireSound'
    begin object name=DryFireSound
    end object
    WeaponDryFireSound=DryFireSound
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__SniperRifleAttachment.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}