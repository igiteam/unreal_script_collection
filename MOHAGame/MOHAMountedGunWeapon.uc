class MOHAMountedGunWeapon extends EALASmallArms
    native
    config(Weapon)
    hidecategories(Navigation);

var(Tuning_MG) config float fMaxYaw;
var(Tuning_MG) config float fMaxPitch;
var(Tuning_MG) config float fAdjustedFOV;
var(Tuning_MG) export editinline StaticMeshComponent StandMesh;
var(Tuning_MG) config int ViewableChainBullets;
var(Tuning_MG) config Vector vMGOffsetFromPlayerRoot_AS;
var(Tuning_MGCameraShake) config float TimeForMaxShake;
var(Tuning_MGCameraShake) config float ShakeFrequencyYaw_Min;
var(Tuning_MGCameraShake) config float ShakeFrequencyYaw_Max;
var(Tuning_MGCameraShake) config float ShakeFrequencyPitch_Min;
var(Tuning_MGCameraShake) config float ShakeFrequencyPitch_Max;
var(Tuning_MGCameraShake) config float ShakeAmplitudeYaw_Min;
var(Tuning_MGCameraShake) config float ShakeAmplitudeYaw_Max;
var(Tuning_MGCameraShake) config float ShakeAmplitudePitch_Min;
var(Tuning_MGCameraShake) config float ShakeAmplitudePitch_Max;
var SkelControlSingleBone PitchController;
var SkelControlSingleBone YawController;
var Rotator LocalRotation;
var Rotator DefaultRotation;
var float ReturnSpeed;
var float fStateTime;
var float fLastShakeYaw;
var float fLastShakePitch;

// Export UMOHAMountedGunWeapon::execFaceRotation(FFrame&, void* const)
native simulated function FaceRotation(Rotator NewRotation, float DeltaTime);

// Export UMOHAMountedGunWeapon::execReturnToCenter(FFrame&, void* const)
native function ReturnToCenter(float DeltaTime);

simulated function bool HasReserveAmmo()
{
    return true;
    //return ReturnValue;    
}

simulated function ConsumeAmmo(byte FireModeNum)
{
    super(EALAWeapon).ConsumeAmmo(FireModeNum);
    // End:0x3B
    if(ViewableChainBullets > (GetAmmoInClip()))
    {
        ScaleChainBullets(0.0000000, (GetAmmoInClip()) + 1);
    }
    //return;    
}

simulated function ScaleChainBullets(float fScale, int iBulletToScale)
{
    local SkelControlSingleBone SkCtrl;
    local name nBulletBoneName;

    // End:0x0D
    if(WeaponSkeletalMesh == none)
    {
        return;
    }
    nBulletBoneName = name(string('BeltBone_') $ string(iBulletToScale));
    SkCtrl = SkelControlSingleBone(WeaponSkeletalMesh.FindSkelControl(nBulletBoneName));
    // End:0x55
    if(SkCtrl == none)
    {
        return;
    }
    SkCtrl.ControlStrength = 1.0000000;
    SkCtrl.SetSkelControlActive(true);
    SkCtrl.BoneScale = fScale;
    //return;    
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    // End:0x8B
    if((thisPawn != none) && thisPawn.IsA('MOHAPlayerPawn'))
    {
        WeaponSkeletalMesh.AttachComponent(StandMesh, 'Root');
        StandMesh.SetAbsolute(false, true, false);
        StandMesh.SetRotation(thisPawn.Rotation);
        super(Weapon).GivenTo(thisPawn, false);        
    }
    else
    {
        super(Weapon).GivenTo(thisPawn, false);
    }
    //return;    
}

function InitSkeletalControls()
{
    // End:0x150
    if(WeaponSkeletalMesh != none)
    {
        PitchController = SkelControlSingleBone(WeaponSkeletalMesh.FindSkelControl('PitchControl'));
        YawController = SkelControlSingleBone(WeaponSkeletalMesh.FindSkelControl('YawControl'));
        // End:0x150
        if((none != PitchController) && none != YawController)
        {
            PitchController.ControlStrength = 1.0000000;
            PitchController.SetSkelControlActive(true);
            YawController.ControlStrength = 1.0000000;
            YawController.SetSkelControlActive(true);
            PitchController.BoneRotation.Roll = 0;
            PitchController.BoneRotation.Yaw = 0;
            PitchController.BoneRotation.Pitch = 0;
            YawController.BoneRotation.Roll = 0;
            YawController.BoneRotation.Yaw = 0;
            YawController.BoneRotation.Pitch = 0;            
        }
    }
    //return;    
}

function EnableSkelControls(bool Enable)
{
    // End:0x20
    if(none != PitchController)
    {
        PitchController.SetSkelControlActive(Enable);
    }
    // End:0x40
    if(none != YawController)
    {
        YawController.SetSkelControlActive(Enable);
    }
    //return;    
}

function FaceDefault()
{
    LocalRotation = DefaultRotation;
    FaceRotation(LocalRotation, 0.0000000);
    //return;    
}

function FaceNull()
{
    LocalRotation.Pitch = 0;
    LocalRotation.Yaw = 0;
    LocalRotation.Roll = 0;
    FaceRotation(LocalRotation, 0.0000000);
    //return;    
}

function Vector GetMGOffsetFromPlayerRoot()
{
    return vMGOffsetFromPlayerRoot_AS;
    //return ReturnValue;    
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    return fAdjustedFOV;
    //return ReturnValue;    
}

simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    Attachment_MountedWeapon(GetWeaponAttachment()).PlayMovementSounds(out_DeltaRot, DeltaTime);
    //return;    
}

simulated function bool ProcessWeaponAttachmentChanged()
{
    return false;
    //return ReturnValue;    
}

state WeaponReload
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        I = 1;
        J0x07:

        // End:0x34 [Loop If]
        if(I <= ViewableChainBullets)
        {
            ScaleChainBullets(1.0000000, I);
            I++;
            // [Loop Continue]
            goto J0x07;
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponBurstFire
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        fLastShakeYaw = 0.0000000;
        fLastShakePitch = 0.0000000;
        fStateTime = 0.0000000;
        //return;        
    }

    simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        Attachment_MountedWeapon(GetWeaponAttachment()).PlayMovementSounds(out_DeltaRot, DeltaTime);
        InternalProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        fStateTime += DeltaTime;
        //return;        
    }

    simulated function InternalProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        local float fAmplitudeYaw, fAmplitudePitch, fFrequencyYaw, fFrequencyPitch, fPerc, fShakeYaw,
	        fShakePitch;

        ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        fPerc = FClamp(fStateTime / TimeForMaxShake, 0.0000000, 1.0000000);
        fAmplitudeYaw = Lerp(ShakeAmplitudeYaw_Min, ShakeAmplitudeYaw_Max, fPerc);
        fAmplitudePitch = Lerp(ShakeAmplitudePitch_Min, ShakeAmplitudePitch_Max, fPerc);
        fFrequencyYaw = Lerp(ShakeFrequencyYaw_Min, ShakeFrequencyYaw_Max, fPerc);
        fFrequencyPitch = Lerp(ShakeFrequencyPitch_Min, ShakeFrequencyPitch_Max, fPerc);
        fShakePitch = fAmplitudePitch * Sin(((fStateTime * 2.0000000) * 3.1415930) * fFrequencyPitch);
        fShakeYaw = fAmplitudeYaw * Cos(((fStateTime * 2.0000000) * 3.1415930) * fFrequencyYaw);
        out_DeltaRot.Pitch += int(fShakePitch - fLastShakePitch);
        out_DeltaRot.Yaw += int(fShakeYaw - fLastShakeYaw);
        fLastShakePitch = fShakePitch;
        fLastShakeYaw = fShakeYaw;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        fStateTime = 0.0000000;
        // End:0x48
        if(Attachment_MountedWeapon(GetWeaponAttachment()) != none)
        {
            Attachment_MountedWeapon(GetWeaponAttachment()).MountingWeapon();
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        fStateTime += DeltaTime;
        //return;        
    }

    simulated function float GetPlayerFOV()
    {
        local float fPlayerFOV, fWorldFOV, fPerc;

        fPlayerFOV = super(EALAWeapon).GetPlayerFOV();
        fWorldFOV = 80.0000000;
        fPerc = ((EquipTime > 0.0000000) ? FClamp(fStateTime / EquipTime, 0.0000000, 1.0000000) : 1.0000000);
        return fWorldFOV + ((fPlayerFOV - fWorldFOV) * fPerc);
        //return ReturnValue;        
    }

    simulated function float AdjustFOVAngle(float FOVAngle)
    {
        local float fWorldFOV, fPerc;

        fWorldFOV = 80.0000000;
        fPerc = ((EquipTime > 0.0000000) ? FClamp(fStateTime / EquipTime, 0.0000000, 1.0000000) : 1.0000000);
        return fWorldFOV + ((fAdjustedFOV - fWorldFOV) * fPerc);
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        fStateTime = 0.0000000;
        Attachment_MountedWeapon(GetWeaponAttachment()).DismountingWeapon();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        MOHASkeletalMeshComponent(Mesh).FOV = 0.0000000;
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        fStateTime += DeltaTime;
        //return;        
    }

    simulated function float GetPlayerFOV()
    {
        local float fPlayerFOV, fWorldFOV, fPerc;

        fPlayerFOV = super(EALAWeapon).GetPlayerFOV();
        fWorldFOV = 80.0000000;
        fPerc = ((PutDownTime > 0.0000000) ? FClamp(fStateTime / PutDownTime, 0.0000000, 1.0000000) : 1.0000000);
        return fPlayerFOV + ((fWorldFOV - fPlayerFOV) * fPerc);
        //return ReturnValue;        
    }

    simulated function float AdjustFOVAngle(float FOVAngle)
    {
        local float fWorldFOV, fPerc;

        fWorldFOV = 80.0000000;
        fPerc = ((PutDownTime > 0.0000000) ? FClamp(fStateTime / PutDownTime, 0.0000000, 1.0000000) : 1.0000000);
        return fAdjustedFOV + ((fWorldFOV - fAdjustedFOV) * fPerc);
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    fMaxYaw=8192.0000000
    fMaxPitch=5461.0000000
    fAdjustedFOV=65.0000000
    vMGOffsetFromPlayerRoot_AS=(X=92.4630000,Y=26.8100000,Z=120.0000000)
    TimeForMaxShake=3.0000000
    ShakeFrequencyYaw_Min=40.0000000
    ShakeFrequencyYaw_Max=40.0000000
    ShakeFrequencyPitch_Min=40.0000000
    ShakeFrequencyPitch_Max=40.0000000
    ShakeAmplitudeYaw_Min=50.0000000
    ShakeAmplitudeYaw_Max=80.0000000
    ShakeAmplitudePitch_Min=60.0000000
    ShakeAmplitudePitch_Max=200.0000000
    DefaultRotation=(Pitch=5086,Yaw=0,Roll=0)
    ReturnSpeed=1.3000000
    // Reference: WeaponAccuracyComponent'Default__MOHAMountedGunWeapon.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHAMountedGunWeapon.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    // Reference: WeaponKickComponent'Default__MOHAMountedGunWeapon.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHAMountedGunWeapon.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHAMountedGunWeapon.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    bCanIronsight=false
    AmmoClass[0]=Class'MOHAMMGAmmoClass'
    AmmoClass[1]=Class'MOHAMMGAmmoClass'
    PlayerFOV=60.0000000
    bCanThrow=false
    // Reference: MOHASkeletalMeshComponent'Default__MOHAMountedGunWeapon.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}