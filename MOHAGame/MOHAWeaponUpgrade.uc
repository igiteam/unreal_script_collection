class MOHAWeaponUpgrade extends Object
    abstract;

enum EMeshVisibility
{
    MESH_VISIBILITY_SHOW,           // 0
    MESH_VISIBILITY_HIDE,           // 1
    MESH_VISIBILITY_MAX             // 2
};

enum EWEaponUpgradeApplied
{
    WEAPON_UPGRADE_APPLIED,         // 0
    WEAPON_UPGRADE_NOTAPPLIED,      // 1
    WEAPON_UPGRADE_MAX              // 2
};

var MOHAIncludeClass.EWeaponType WeaponTypeIdentifier;
var MOHAWeaponUpgrade.EWEaponUpgradeApplied UpgradeApplied;
var int WeaponUpgradeLevel;
var int WeaponUpgradeId;
var const localized string WeaponUpgradeName;
var array<name> UpgradeMeshesToAdd;
var array<name> UpgradeMeshesToReplace;
var array<name> UpgradeMeshesToHideOnly;

static simulated function StaticInitWeaponAttachmentUpgrade(WeaponAttachment Attachment)
{
    UpdateMeshVisibility(SkeletalMeshComponent(Attachment.Mesh), default.UpgradeMeshesToAdd, 1);
    UpdateMeshVisibility(SkeletalMeshComponent(Attachment.Mesh), default.UpgradeMeshesToHideOnly, 1);
    UpdateMeshVisibility(SkeletalMeshComponent(Attachment.Mesh), default.UpgradeMeshesToReplace, 0);
    //return;    
}

static simulated function StaticUpgradeWeapon(EALAWeapon W)
{
    UpdateMeshVisibility(W.WeaponSkeletalMesh, default.UpgradeMeshesToReplace, 1);
    UpdateMeshVisibility(W.WeaponSkeletalMesh, default.UpgradeMeshesToAdd, 0);
    // End:0x6A
    if(W.CurrentUpgradeLevel < default.WeaponUpgradeLevel)
    {
        W.CurrentUpgradeLevel = default.WeaponUpgradeLevel;
    }
    //return;    
}

static simulated function StaticUpgradeWeaponAttachment(WeaponAttachment Attachment)
{
    UpdateMeshVisibility(SkeletalMeshComponent(Attachment.Mesh), default.UpgradeMeshesToReplace, 1);
    UpdateMeshVisibility(SkeletalMeshComponent(Attachment.Mesh), default.UpgradeMeshesToAdd, 0);
    //return;    
}

static simulated function StaticPreUpgradeWeapon(EALAWeapon W)
{
    //return;    
}

static simulated function UpdateMeshVisibility(SkeletalMeshComponent SkelMesh, array<name> MeshArray, MOHAWeaponUpgrade.EMeshVisibility eVisibility)
{
    local int I;
    local SkelControlSingleBone SkCtrl;

    // End:0x0D
    if(none == SkelMesh)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0xAA [Loop If]
    if(I < MeshArray.Length)
    {
        SkCtrl = SkelControlSingleBone(SkelMesh.FindSkelControl(MeshArray[I]));
        // End:0x57
        if(none == SkCtrl)
        {
            // [Explicit Continue]
            goto J0xA0;
        }
        SkCtrl.ControlStrength = 1.0000000;
        SkCtrl.SetSkelControlActive(true);
        SkCtrl.BoneScale = float(((int(eVisibility) == int(0)) ? 1 : 0));
        J0xA0:

        I++;
        // [Loop Continue]
        goto J0x14;
    }
    //return;    
}

static simulated function AddReserveAmmoCapactity(EALAWeapon W, int iAmmoCapacityIncrease)
{
    local int iMaxAmmoCount;

    // End:0x2E
    if(W.IsRestoringExperience() && !Class'Engine.SaveLoadSystem'.static.AtLevelStartCheckpoint())
    {
        return;
    }
    // End:0x1B1
    if(MOHAInventoryManager(W.Instigator.InvManager) != none)
    {
        iMaxAmmoCount = MOHAInventoryManager(W.Instigator.InvManager).GetMaxAmmoCount(W.AmmoClass[0]);
        // End:0xF1
        if(W.Instigator.IsLocallyControlled())
        {
            MOHAInventoryManager(W.Instigator.InvManager).SetMaxAmmoCount(W.AmmoClass[0], iMaxAmmoCount + iAmmoCapacityIncrease);
        }
        // End:0x159
        if(int(W.WorldInfo.NetMode) == int(NM_Client))
        {
            MOHAMultiplayerController(W.Instigator.Controller).ServerSetMaxAmmoCount(W.AmmoClass[0], iMaxAmmoCount + iAmmoCapacityIncrease);
        }
        // End:0x1B1
        if(!W.IsRestoringExperience())
        {
            MOHAInventoryManager(W.Instigator.InvManager).AddReserveAmmo(W.AmmoClass[0], iAmmoCapacityIncrease);
        }
    }
    //return;    
}

static simulated function UpdateKick(EALASmallArms W, ViewKickTuning KickParams, ViewKickTuning IronsightsKickParams)
{
    // End:0x268
    if(W != none)
    {
        W.KickComponent.KickParams = KickParams;
        W.IronsightsKickComponent.KickParams = IronsightsKickParams;
        // End:0xC9
        if(KickParams.ConstantPitchReturn && KickParams.PitchDistance != float(0))
        {
            W.KickComponent.KickParams.PitchDistance = KickParams.PitchDistance + (KickParams.PitchRecenterRate * W.GetEffectiveFireRate(false));
        }
        // End:0x14D
        if(KickParams.ConstantPushReturn && KickParams.PushDistance != float(0))
        {
            W.KickComponent.KickParams.PushDistance = KickParams.PushDistance + (KickParams.PushRecenterRate * W.GetEffectiveFireRate(false));
        }
        // End:0x1D1
        if(IronsightsKickParams.ConstantPitchReturn && IronsightsKickParams.PitchDistance != float(0))
        {
            W.IronsightsKickComponent.KickParams.PitchDistance = IronsightsKickParams.PitchDistance + (IronsightsKickParams.PitchRecenterRate * W.GetEffectiveFireRate(true));
        }
        // End:0x255
        if(IronsightsKickParams.ConstantPushReturn && IronsightsKickParams.PushDistance != float(0))
        {
            W.IronsightsKickComponent.KickParams.PushDistance = IronsightsKickParams.PushDistance + (IronsightsKickParams.PushRecenterRate * W.GetEffectiveFireRate(true));
        }
        W.UpdateKick();
    }
    //return;    
}

static simulated function UpdateAccuracy(EALASmallArms W, AccuracyTuning AccuracyParams, AccuracyTuning IronsightsAccuracyParams)
{
    // End:0x58
    if(W != none)
    {
        W.AccuracyComponent.AccuracyParams = AccuracyParams;
        W.IronsightsAccuracyComponent.AccuracyParams = IronsightsAccuracyParams;
        W.UpdateAccuracy();
    }
    //return;    
}

static simulated function EnableAltFireMode(EALASmallArms Weap)
{
    local int iMaxAmmoCount;

    // End:0xDA
    if(Weap != none)
    {
        Weap.EnableAlternateFireToggle();
        // End:0xDA
        if(!Weap.IsRestoringExperience() && int(Weap.WorldInfo.NetMode) == int(NM_Standalone))
        {
            iMaxAmmoCount = MOHAInventoryManager(Weap.Instigator.InvManager).GetMaxAmmoCount(Weap.AmmoClass[1]);
            MOHAInventoryManager(Weap.Instigator.InvManager).AddReserveAmmo(Weap.AmmoClass[1], iMaxAmmoCount);
        }
    }
    //return;    
}

defaultproperties
{
    UpgradeApplied=1
    WeaponUpgradeId=-1
}