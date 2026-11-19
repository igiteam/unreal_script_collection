class Attachment_MountedWeapon extends SmallArmsAttachment
    config(Weapon)
    notplaceable
    hidecategories(Navigation);

var SkeletalMesh PlayerSkelMesh;
var SkeletalMesh NPCSkelMesh;
var bool bMountedByLocalPlayer;
var bool bMountedByNPCPawn;
var bool bTimeToPlaySound;
var(Tuning_MountedWeaponSounds) config float YawSoundSpeed;
var(Tuning_MountedWeaponSounds) config float PitchSoundSpeed;
var(Tuning_MountedWeaponSounds) config float TimeBetweenSounds;
var(Tuning_Sounds) export editinline AudioComponent RightMotionSound;
var(Tuning_Sounds) export editinline AudioComponent LeftMotionSound;
var(Tuning_Sounds) export editinline AudioComponent UpMotionSound;
var(Tuning_Sounds) export editinline AudioComponent DownMotionSound;
var(Tuning_Sounds) export editinline AudioComponent NPCRightMotionSound;
var(Tuning_Sounds) export editinline AudioComponent NPCLeftMotionSound;
var(Tuning_Sounds) export editinline AudioComponent NPCUpMotionSound;
var(Tuning_Sounds) export editinline AudioComponent NPCDownMotionSound;
var(Tuning_Sounds) export editinline AudioComponent WeaponMountingSound;
var(Tuning_Sounds) export editinline AudioComponent NPCWeaponMountingSound;
var(Tuning_Sounds) export editinline AudioComponent WeaponDismountingSound;
var(Tuning_Sounds) export editinline AudioComponent NPCWeaponDismountingSound;

function SwitchToPlayerMesh(MOHAPlayerPawn GunUser)
{
    SkeletalMeshComponent(Mesh).SetSkeletalMesh(PlayerSkelMesh);
    bMountedByLocalPlayer = (GunUser != none) && GunUser.IsLocallyControlled();
    //return;    
}

function SwitchToNPCMesh()
{
    SkeletalMeshComponent(Mesh).SetSkeletalMesh(NPCSkelMesh);
    bMountedByLocalPlayer = false;
    //return;    
}

simulated event bool OwnerIsLocalPlayer()
{
    return bMountedByLocalPlayer;
    //return ReturnValue;    
}

simulated function bool DestroyWhenDetatched()
{
    return false;
    //return ReturnValue;    
}

function PlayMovementSound(AudioComponent Comp)
{
    // End:0x1B
    if((Comp == none) || bTimeToPlaySound == false)
    {
        return;
    }
    bTimeToPlaySound = false;
    Comp.Stop();
    Comp.Play();
    SetTimer(TimeBetweenSounds, false, 'ResetSoundTime');
    //return;    
}

simulated function ResetSoundTime()
{
    bTimeToPlaySound = true;
    //return;    
}

function PlayMovementSounds(Rotator out_DeltaRot, float DeltaTime)
{
    local Rotator rNormalizedDelta;

    // End:0x0E
    if(false == bTimeToPlaySound)
    {
        return;
    }
    // End:0x3C
    if((0 == out_DeltaRot.Yaw) && 0 == out_DeltaRot.Pitch)
    {
        return;
    }
    rNormalizedDelta = (1.0000000 / DeltaTime) * out_DeltaRot;
    // End:0xB4
    if(float(rNormalizedDelta.Yaw) >= YawSoundSpeed)
    {
        PlayMovementSound(((Instigator.IsFirstPerson() && Instigator.IsLocallyControlled()) ? RightMotionSound : NPCRightMotionSound));        
    }
    else
    {
        // End:0x114
        if(float(rNormalizedDelta.Yaw) < -YawSoundSpeed)
        {
            PlayMovementSound(((Instigator.IsFirstPerson() && Instigator.IsLocallyControlled()) ? LeftMotionSound : NPCLeftMotionSound));            
        }
        else
        {
            // End:0x172
            if(float(rNormalizedDelta.Pitch) >= PitchSoundSpeed)
            {
                PlayMovementSound(((Instigator.IsFirstPerson() && Instigator.IsLocallyControlled()) ? UpMotionSound : NPCUpMotionSound));                
            }
            else
            {
                // End:0x1CF
                if(float(rNormalizedDelta.Pitch) < -PitchSoundSpeed)
                {
                    PlayMovementSound(((Instigator.IsFirstPerson() && Instigator.IsLocallyControlled()) ? DownMotionSound : NPCDownMotionSound));
                }
            }
        }
    }
    //return;    
}

function MountingWeapon()
{
    // End:0x28
    if(bMountedByLocalPlayer && WeaponMountingSound != none)
    {
        WeaponMountingSound.Play();        
    }
    else
    {
        // End:0x4D
        if(bMountedByNPCPawn && NPCWeaponMountingSound != none)
        {
            NPCWeaponMountingSound.Play();
        }
    }
    AttachVisualEffects();
    // End:0x7D
    if(MOHASkeletalMeshComponent(Mesh) != none)
    {
        MOHASkeletalMeshComponent(Mesh).bForceNoTick = false;
    }
    // End:0xA3
    if(MOHASkeletalMeshComponent(ThirdPersonMesh) != none)
    {
        MOHASkeletalMeshComponent(ThirdPersonMesh).bForceNoTick = false;
    }
    AssignSoundSetIndex();
    //return;    
}

function DismountingWeapon()
{
    // End:0x28
    if(bMountedByLocalPlayer && WeaponDismountingSound != none)
    {
        WeaponDismountingSound.Play();        
    }
    else
    {
        // End:0x4D
        if(bMountedByNPCPawn && NPCWeaponDismountingSound != none)
        {
            NPCWeaponDismountingSound.Play();
        }
    }
    // End:0x73
    if(MOHASkeletalMeshComponent(Mesh) != none)
    {
        MOHASkeletalMeshComponent(Mesh).bForceNoTick = true;
    }
    // End:0x99
    if(MOHASkeletalMeshComponent(ThirdPersonMesh) != none)
    {
        MOHASkeletalMeshComponent(ThirdPersonMesh).bForceNoTick = true;
    }
    //return;    
}

simulated function bool InstigatorRenderedRecently()
{
    // End:0x0D
    if(Instigator != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bTimeToPlaySound=true
    // Reference: MOHASkeletalMeshComponent'Default__Attachment_MountedWeapon.WeaponMeshComponent'
    begin object name=WeaponMeshComponent
    end object
    Mesh=WeaponMeshComponent
    ThirdPersonMesh=WeaponMeshComponent
    // Reference: WeaponFlashDLight'Default__Attachment_MountedWeapon.WeaponMuzzleFlashDLight'
    begin object name=WeaponMuzzleFlashDLight
    end object
    MuzzleFlashDLight=WeaponMuzzleFlashDLight
    // Reference: AudioComponent'Default__Attachment_MountedWeapon.DryFireSound'
    begin object name=DryFireSound
    end object
    WeaponDryFireSound=DryFireSound
    Components[0]=WeaponMeshComponent
    // Reference: SpriteComponent'Default__Attachment_MountedWeapon.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
    Components[2]=WeaponMuzzleFlashDLight
    Components[3]=DryFireSound
}