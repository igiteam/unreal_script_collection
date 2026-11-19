class AdvSkelControl_HandIK extends SkelControlLimb
    native(Anim)
    hidecategories(Object,Object);

var(Effector) name EffectorWeaponSocket;
var(Effector) name EffectorActualBoneName;
var(Effector) Object.EAxis EffectorBoneLookAxis;
var(Effector) Object.EAxis EffectorBoneHingeAxis;
var(Recoil) Object.AlphaBlendType RecoilBlendType;
var(Joint) Object.EAxis JointAngleFixupAxis;
var(Recoil) bool bEnableRecoil;
var(Recoil) transient bool bPlayRecoil;
var transient bool bHasSocket;
var() bool bShouldUseIK;
var(Recoil) Vector RecoilOffset;
var(Recoil) float RecoilRecoveryRate;
var transient float RecoilAlpha;
var transient EvilPawn CachedOwner;
var transient AdvTurret_Base CachedTurret;
var transient int CachedBoneIndex;
var transient Vector CurrentRecoilOffset;
var(Joint) float CosMaxJointAngle;

simulated function OnIKStatusUpdate(EvilPawn Instigator, bool ZoomIn)
{
    // End:0x3B
    if((CachedOwner != Instigator) && Instigator != none)
    {
        CachedOwner = Instigator;
    }
    // End:0xB4
    if((CachedOwner != none) && AdvPawn(CachedOwner).bIsOnTurret)
    {
        CachedTurret = AdvTurret_Base(AdvPawn(CachedOwner).DrivenVehicle);        
    }
    else
    {
        CachedTurret = none;
    }
    bHasSocket = ((none != CachedOwner) && 'None' != EffectorWeaponSocket) && ((((none != CachedOwner.CurrentWeaponAttachment) && none == CachedOwner.CurrentWeaponLeftAttachment) && none != CachedOwner.CurrentWeaponAttachment.Mesh.SkeletalMesh) && none != CachedOwner.CurrentWeaponAttachment.Mesh.GetSocketByName(EffectorWeaponSocket)) || ((none != CachedTurret) && none != CachedTurret.Mesh.SkeletalMesh) && none != CachedTurret.Mesh.GetSocketByName(EffectorWeaponSocket);
    bShouldUseIK = ((CachedOwner != none) && !CachedOwner.bDisableIK) && ((bHasSocket) ? (((((CachedOwner.CurrentWeaponAttachment != none) && CachedOwner.CurrentWeaponAttachment.bEnableIK) && CachedOwner.CurrentWeaponAttachment.bEnableIKOnAim || !ZoomIn) || (CachedTurret != none) && CachedTurret.bEnableIK) && !CachedOwner.IsDoingAPawnAction() && CachedOwner.PawnActions[int(CachedOwner.PawnAction)].bDisableIK) && !(CachedOwner.CurrentNavPointAction != none) && CachedOwner.CurrentNavPointAction.bDisableIK : bEnableRecoil);
    //return;    
}

defaultproperties
{
    EffectorBoneLookAxis=EAxis.AXIS_X
    EffectorBoneHingeAxis=EAxis.AXIS_Y
    RecoilBlendType=AlphaBlendType.ABT_Cubic
    JointAngleFixupAxis=EAxis.AXIS_X
    RecoilOffset=(X=-1.7500000,Y=0.5000000,Z=0.0000000)
    RecoilRecoveryRate=8.0000000
    CachedBoneIndex=-1
    CosMaxJointAngle=-2.0000000
}