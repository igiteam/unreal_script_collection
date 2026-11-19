class SingleShotReloadWeaponAttachment extends SmallArmsAttachment
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

var(Attachment_SingleShotReloadWeapon) config float ShellEjectDelay;
var(Attachment_SingleShotReloadWeapon) config float ReloadShellEjectDelay;

simulated function WeaponBeingReloaded()
{
    super(WeaponAttachment).WeaponBeingReloaded();
    ClearTimer('EjectRechamberedShell');
    SetTimer(ReloadShellEjectDelay, false, 'EjectRechamberedShell');
    //return;    
}

simulated function EjectRechamberedShell()
{
    EjectShell();
    //return;    
}

simulated function EjectShell()
{
    //return;    
}

simulated function Rechamber()
{
    SetTimer(ShellEjectDelay, false, 'EjectRechamberedShell');
    //return;    
}

defaultproperties
{
    ShotsNeededForBarrelSmoke=1
    // Reference: MOHASkeletalMeshComponent'Default__SingleShotReloadWeaponAttachment.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__SingleShotReloadWeaponAttachment.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    // Reference: AudioComponent'Default__SingleShotReloadWeaponAttachment.DryFireSound'
    begin object name=DryFireSound
    end object
    WeaponDryFireSound=DryFireSound
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__SingleShotReloadWeaponAttachment.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}