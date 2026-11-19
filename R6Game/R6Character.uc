class R6Character extends R6Pawn
    native
    config(Character)
    hidecategories(lighting);

const DEFAULT_TEMPLATE_LOOK = 2;
const DEFAULT_TEMPLATE_EQUIPMENT = 4;
const DEFAULT_TEMPLATE_AI = 8;
const DEFAULT_TEMPLATE_ALL = 15;

enum R6FacialEmotion
{
    EFACIAL_Neutral,                // 0
    EFACIAL_Afraid,                 // 1
    EFACIAL_Aggressive,             // 2
    EFACIAL_Pain,                   // 3
    EFACIAL_TakeCover_PeekRight,    // 4
    EFACIAL_TakeCover_PeekLeft,     // 5
    EFACIAL_TakeCover_BlindFireRight,// 6
    EFACIAL_TakeCover_BlindFireLeft,// 7
    EFACIAL_TakeCover_Exposed,      // 8
    EFACIAL_MAX                     // 9
};

enum HIKEffSpace
{
    EHIKEFFSPACE_World,             // 0
    EHIKEFFSPACE_Local,             // 1
    EHIKEFFSPACE_MAX                // 2
};

enum HIKEffMode
{
    EHIKEFFMODE_Absolute,           // 0
    EHIKEFFMODE_Snap,               // 1
    EHIKEFFMODE_MAX                 // 2
};

enum EFootSide
{
    EFootSideLeft,                  // 0
    EFootSideRight,                 // 1
    EFootSide_MAX                   // 2
};

struct HIKEffectorInfo
{
    var bool m_bActive;
    var bool m_bUsePos;
    var bool m_bUseRot;
    var bool m_bUseTargetPos;
    var R6Character.HIKEffSpace m_eSpace;
    var R6Character.HIKEffMode m_eMode;
    var float m_fSnapDist;
    var Vector m_vPos;
    var Vector m_vTargetPos;
    var Vector m_vLocalCurrentPos;
    var Rotator m_rRot;
    var R6EngineEnums.EHIKPassIndex m_ePassIndex;
    var Matrix m_mTransform;
    var float m_fWeight;
    var float m_fInterpDuration;
    var float m_fTargetWeight;
    var float m_fReachTargetSpeed;

    structdefaultproperties
    {
        m_bActive=false
        m_bUsePos=false
        m_bUseRot=false
        m_bUseTargetPos=false
        m_eSpace=0
        m_eMode=0
        m_fSnapDist=0.0000000
        m_vPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vTargetPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vLocalCurrentPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_rRot=(Pitch=0,Yaw=0,Roll=0)
        m_ePassIndex=0
        m_mTransform=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_fWeight=0.0000000
        m_fInterpDuration=0.0000000
        m_fTargetWeight=0.0000000
        m_fReachTargetSpeed=0.0000000
    }
};

var() R6CharacterTemplate m_CharacterTemplate;
var transient int m_iCharacterTemplateSeed;
var int m_iTeamTemplateFlags;
var const R6Character.R6FacialEmotion m_eFacialEmotion;
var() export editinline SkeletalMeshComponent m_FPMesh;
var export editinline SkeletalMeshComponent m_HeadMesh;
var export editinline SkeletalMeshComponent m_TorsoMesh;
var export editinline SkeletalMeshComponent m_LegsMesh;
var export editinline SkeletalMeshComponent m_HairMesh;
var export editinline SkeletalMeshComponent m_ArmorTorsoMesh;
var export editinline SkeletalMeshComponent m_ArmorShoulderMesh1;
var export editinline SkeletalMeshComponent m_ArmorShoulderMesh2;
var export editinline SkeletalMeshComponent m_ArmorLegsMesh1;
var export editinline SkeletalMeshComponent m_ArmorLegsMesh2;
var export editinline SkeletalMeshComponent m_ArmorArmsMesh1;
var export editinline SkeletalMeshComponent m_ArmorArmsMesh2;
var export editinline MeshComponent m_pHelmetMesh;
var export editinline SkeletalMeshComponent m_pSkelHelmet;
var export editinline SkeletalMeshComponent m_pGasMaskMesh;
var export editinline StaticMeshComponent m_pSnakeCamMeshTP;
var export editinline array<export editinline StaticMeshComponent> m_arrAttachments;
var() array<AnimSet> m_ThirdPersonAnimSets;
var transient bool m_bTPAnimSetsInitialized;
var transient bool m_bWorstSkeletonInitialized;
var() array<AnimSet> m_FirstPersonAnimSets;
var AnimTree m_FirstPersonAnimtree;
var transient float m_fBlendOutStart;
var transient float m_fRagdollSpring;
var config array<config string> m_sBreatheAnims;
var config array<config string> m_sIdlesAnims;
var config array<config string> m_sIdlesTcAnims;
var array<string> m_sIdlesRappelAnims;
var array<string> m_sIdlesLadderAnims;
var native Pointer m_aCacheHeadAttachments[2];
var config array<config string> m_aExtraAnimsets;
var bool m_bDisableHandIK;
var bool m_bCanDisableHandIK;
var bool m_bDontUseFacialExpression;
var bool m_bHelmetAttached;
var bool m_bSnakeCamHand;
var bool m_bSnakeCamHelmet;
var bool m_bDisableIK;
var bool m_bLFeetDown;
var bool m_bRFeetDown;
var bool m_bFeetLockingActive;
var bool m_bRightFootLock;
var bool m_bLeftFootLock;
var bool m_bLeftFootHitInitialized;
var bool m_bRightFootHitInitialized;
var bool m_bGogglesUseIK;
var bool m_bGasMaskOnFace;
var bool m_bGasMaskOnHand;
var float m_fStopTransitionLenght;
var float m_fStartTransitionLenght;
var AnimTree m_RagdollAnimTree;
var transient HIKEffectorInfo m_LHandPlacingIKEffectorPostAttachment;
var transient HIKEffectorInfo m_RHandPlacingIKEffectorPostAttachment;
var transient HIKEffectorInfo m_LHandIKEffectorPreAttachment;
var transient HIKEffectorInfo m_LHandIKEffectorPostAttachment;
var transient HIKEffectorInfo m_LHandIKFPEffectorPostAttachment;
var transient HIKEffectorInfo m_LHandIKFPEffectorPreAttachment;
var transient HIKEffectorInfo m_RHandIKEffectorPreAttachment;
var transient HIKEffectorInfo m_RHandIKEffectorPostAttachment;
var transient HIKEffectorInfo m_LFeetIKEffector;
var transient HIKEffectorInfo m_RFeetIKEffector;
var transient HIKEffectorInfo m_HipsIKEffector;
var Vector m_HipsOffset;
var Vector m_vHipsOffsetTarget;
var float m_fHipsReachSpeed;
var Vector m_vLFeetOffset;
var Vector m_vRFeetOffset;
var Vector m_vLFeetOffsetTarget;
var Vector m_vRFeetOffsetTarget;
var float m_fFeetReachSpeed;
var float m_fLeftFeetLockWeight;
var float m_fRightFeetLockWeight;
var Vector m_vRightFeetLockPos;
var Rotator m_rRightFeetLockRot;
var Vector m_vLeftFeetLockPos;
var Rotator m_rLeftFeetLockRot;
var float m_fLeftFootZHitPos;
var float m_fRightFootZHitPos;
var MaterialInstance m_LFeetMaterial;
var MaterialInstance m_RFeetMaterial;
var R6BlockVolume m_pBlockVolume;
var transient array<byte> m_MinRequiredBones;
var export editinline SkeletalMeshComponent m_pWeaponOnChest;
var transient float m_fRecoilWeight;
var transient float m_fRecoilPitchRotActual;
var transient float m_fRecoilPitchRotDest;
var transient int m_iRecoilSpine;
var transient float m_fRecoilBreathMultiplier;
var transient float m_fRecoilBreathMaster;
var transient float m_fRecoilBoltFirePosWeight;
var transient float m_fRecoilBoltRecoverPosWeight;
var transient float m_fRecoilBoltOperatePosWeight;
var transient float m_fRecoilBoltFireRotWeight;
var transient float m_fRecoilBoltRecoverRotWeight;
var transient float m_fRecoilBoltOperateRotWeight;
var transient int currentBloodStainCounter;
var transient int wantedBloodStainCounter;
var transient name bloodStainBone;
var transient Vector bloodStainPos;
var transient Vector bloodStainNormal;
var transient Matrix m_mNeck;
var int m_iForceRender;
var int m_iMaxTickWithoutAnimate;
var int m_iLastAnimateTick;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_pBlockVolume;

    // Pos:0x00D
    if(((int(Role) == int(ROLE_Authority)) && !bNetOwner) && bNetInitial)
        m_CharacterTemplate, m_bGasMaskOnFace, 
        m_bGasMaskOnHand, m_iCharacterTemplateSeed;

    // Pos:0x032
    if((int(Role) == int(ROLE_Authority)) && bNetDirty)
        m_bDisableIK;
}

// Export UR6Character::execSetFacialEmotion(FFrame&, void* const)
native final function SetFacialEmotion(R6Character.R6FacialEmotion eFacialEmotion);

// Export UR6Character::execUpdateMeshTranslation(FFrame&, void* const)
native final function UpdateMeshTranslation();

// Export UR6Character::execLoadEquipmentTemplate(FFrame&, void* const)
native function bool LoadEquipmentTemplate(string strTemplate);

// Export UR6Character::execGenerateRandomCharacter(FFrame&, void* const)
native function GenerateRandomCharacter(optional bool bRandomSeed, optional bool bNoCheckForBonesNumber);

// Export UR6Character::execAttachSnakeCamHand(FFrame&, void* const)
native final function AttachSnakeCamHand();

// Export UR6Character::execAttachSnakeCamHelmet(FFrame&, void* const)
native final function AttachSnakeCamHelmet();

// Export UR6Character::execDettachSnakeCam(FFrame&, void* const)
native final function DettachSnakeCam();

// Export UR6Character::execAttachGasmaskHand(FFrame&, void* const)
native final function AttachGasmaskHand();

// Export UR6Character::execAttachGasmaskBody(FFrame&, void* const)
native final function AttachGasmaskBody();

// Export UR6Character::execAttachGasmaskFace(FFrame&, void* const)
native final function AttachGasmaskFace();

// Export UR6Character::execEnableGoggleIK(FFrame&, void* const)
native final function EnableGoggleIK();

// Export UR6Character::execDisableGoggleIK(FFrame&, void* const)
native final function DisableGoggleIK();

// Export UR6Character::execReenableWeaponIK(FFrame&, void* const)
native final function ReenableWeaponIK();

// Export UR6Character::execVisionModeTimerEnd(FFrame&, void* const)
native final function VisionModeTimerEnd();

// Export UR6Character::execCommunicateCivilianInTheWay(FFrame&, void* const)
native final function CommunicateCivilianInTheWay(Actor pCollidingActor);

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
{
    // End:0x43
    if((IsFirstPerson()) && m_FPMesh != none)
    {
        m_FPMesh.super(SkeletalMeshComponent).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, m_bAnimDebugRelevantOnly);        
    }
    else
    {
        Mesh.super(SkeletalMeshComponent).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, m_bAnimDebugRelevantOnly);
    }
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    // End:0x71
    if(GetGameManager().IsMultiplayer() && int(WorldInfo.NetMode) != int(NM_Client))
    {
        // End:0x71
        if(m_RadarPawnRepInfo == none)
        {
            m_RadarPawnRepInfo = __NFUN_278__(Class'R6RadarPawnRepInfo');
            m_RadarPawnRepInfo.Init(self);
        }
    }
    return;
}

function OnR6DisableIK(SeqAct_R6DisableIK Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bDisableIK = false;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bDisableIK = true;
        }
    }
    return;
}

event Bump(Actor other, PrimitiveComponent pComponent, Vector vBumpNormal)
{
    Bump(other, pComponent, vBumpNormal);
    CommunicateCivilianInTheWay(other);
    return;
}

defaultproperties
{
    m_CharacterTemplate=R6CharacterTemplate'RS5Rainbow.Template.LoganTemplate'
    m_iTeamTemplateFlags=15
    // Reference: SkeletalMeshComponent'Default__R6Character.HeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="HeadMesh" class=Class'Engine.SkeletalMeshComponent'
        AnimTreeTemplate=AnimTree'AnimTreePlayer.PlayerTree'
        m_bUseHumanIK=true
        m_bEnableHumanIK=true
        m_bInitAttachmentRBPhys=false
        Rotation=(Pitch=0,Yaw=-16384,Roll=0)
        m_eComponentVisibility=2
        m_bDontSupportFirstPersonPOVInThird=true
    end object
    m_HeadMesh=HeadMesh
    // Reference: SkeletalMeshComponent'Default__R6Character.TorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="TorsoMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_TorsoMesh=TorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6Character.LegsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="LegsMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_LegsMesh=LegsMesh
    // Reference: SkeletalMeshComponent'Default__R6Character.HairMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="HairMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
        m_bDontSupportFirstPersonPOVInThird=true
    end object
    m_HairMesh=HairMesh
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorTorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorTorsoMesh" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorTorsoMesh=ArmorTorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorShoulderMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorShoulderMesh1" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorShoulderMesh1=ArmorShoulderMesh1
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorShoulderMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorShoulderMesh2" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorShoulderMesh2=ArmorShoulderMesh2
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorLegsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorLegsMesh1" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorLegsMesh1=ArmorLegsMesh1
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorLegsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorLegsMesh2" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorLegsMesh2=ArmorLegsMesh2
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorArmsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorArmsMesh1" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorArmsMesh1=ArmorArmsMesh1
    // Reference: SkeletalMeshComponent'Default__R6Character.ArmorArmsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArmorArmsMesh2" class=Class'Engine.SkeletalMeshComponent'
        ParentAnimComponent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6Character.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_ArmorArmsMesh2=ArmorArmsMesh2
    m_ThirdPersonAnimSets[0]=AnimSet'Anims_Jung_Movement.Walk.MG'
    m_ThirdPersonAnimSets[1]=AnimSet'Anims_Jung_Movement.FastWalk.MG'
    m_ThirdPersonAnimSets[2]=AnimSet'Anims_Jung_Movement.Jog.MG'
    m_ThirdPersonAnimSets[3]=AnimSet'Anims_Jung_Movement.Turn.MG'
    m_ThirdPersonAnimSets[4]=AnimSet'Anims_Jung_Movement.Step2.MG'
    m_ThirdPersonAnimSets[5]=AnimSet'Anims_Jung_Movement.Transition.MG'
    m_ThirdPersonAnimSets[6]=AnimSet'Anims_Jung_Movement.Crossover.MG'
    m_ThirdPersonAnimSets[7]=AnimSet'Anims_Jung_Movement.Walk.Pistol'
    m_ThirdPersonAnimSets[8]=AnimSet'Anims_Jung_Movement.FastWalk.Pistol'
    m_ThirdPersonAnimSets[9]=AnimSet'Anims_Jung_Movement.Jog.Pistol'
    m_ThirdPersonAnimSets[10]=AnimSet'Anims_General_Gadgets.Detonator'
    m_ThirdPersonAnimSets[11]=AnimSet'Anims_General_Gadgets.GasMask'
    m_ThirdPersonAnimSets[12]=AnimSet'Anims_General_Gadgets.Goggles'
    m_ThirdPersonAnimSets[13]=AnimSet'Anims_General_Gadgets.Demolition_Charge_C4_and_Laser_mine'
    m_ThirdPersonAnimSets[14]=AnimSet'Anims_General_Gadgets.SnakeCam'
    m_ThirdPersonAnimSets[15]=AnimSet'Anims_General_Weapons.FIXEDGUN'
    m_ThirdPersonAnimSets[16]=AnimSet'Anims_General_Weapons.General.WeaponPickup'
    m_ThirdPersonAnimSets[17]=AnimSet'Anims_General_Weapons.01_Pistols.Pistol'
    m_ThirdPersonAnimSets[18]=AnimSet'Anims_General_Weapons.01_Pistols.TRBull'
    m_ThirdPersonAnimSets[19]=AnimSet'Anims_General_Weapons.02_SMGs.MG'
    m_ThirdPersonAnimSets[20]=AnimSet'Anims_General_Weapons.02_SMGs.P90'
    m_ThirdPersonAnimSets[21]=AnimSet'Anims_General_Weapons.04_LMGs.LMG'
    m_ThirdPersonAnimSets[22]=AnimSet'Anims_General_Weapons.04_LMGs.Mk46'
    m_ThirdPersonAnimSets[23]=AnimSet'Anims_General_Weapons.04_LMGs.21E'
    m_ThirdPersonAnimSets[24]=AnimSet'Anims_General_Weapons.05_Shotguns.Shotgun'
    m_ThirdPersonAnimSets[25]=AnimSet'Anims_General_Weapons.06_SniperRifles.Sniper'
    m_ThirdPersonAnimSets[26]=AnimSet'Anims_General_Weapons.07_Shield.Shield'
    m_ThirdPersonAnimSets[27]=AnimSet'Anims_General_Weapons.08_Grenades.Throw'
    m_ThirdPersonAnimSets[28]=AnimSet'Anims_General_Weapons.General.Stances'
    m_ThirdPersonAnimSets[29]=AnimSet'Anims_General_Hands.Death.Male'
    m_ThirdPersonAnimSets[30]=AnimSet'Anims_General_Reactions.bullets'
    m_ThirdPersonAnimSets[31]=AnimSet'Anims_General_Reactions.bullets.Generic'
    m_ThirdPersonAnimSets[32]=AnimSet'Anims_General_Reactions.Explosions'
    m_ThirdPersonAnimSets[33]=AnimSet'Anims_General_Reactions.FlashGrenade'
    m_ThirdPersonAnimSets[34]=AnimSet'Anims_General_Reactions.SmokeGrenade'
    m_ThirdPersonAnimSets[35]=AnimSet'Anims_Terrorist_Reactions.BulletReactions'
    m_ThirdPersonAnimSets[36]=AnimSet'Anims_Facial_Generic.TakeCover'
    m_ThirdPersonAnimSets[37]=AnimSet'Anims_Facial_Generic.Poses'
    m_ThirdPersonAnimSets[38]=AnimSet'Anims_Facial_Generic.Talking'
    m_ThirdPersonAnimSets[39]=AnimSet'Anims_General_Stance.Crouch.MG'
    m_ThirdPersonAnimSets[40]=AnimSet'Anims_General_Stance.Crouch.Pistol'
    m_ThirdPersonAnimSets[41]=AnimSet'Anims_General_Stance.Crouch.Shield'
    m_ThirdPersonAnimSets[42]=AnimSet'Anims_General_Stance.Stand.MG'
    m_ThirdPersonAnimSets[43]=AnimSet'Anims_General_Stance.Stand.Pistol'
    m_ThirdPersonAnimSets[44]=AnimSet'Anims_General_Stance.Stand.Shield'
    m_ThirdPersonAnimSets[45]=AnimSet'Anims_General_Stance.Neutral'
    m_ThirdPersonAnimSets[46]=AnimSet'Anims_General_Signals.Hand'
    m_ThirdPersonAnimSets[47]=AnimSet'Anims_General_Rope.Rappel'
    m_ThirdPersonAnimSets[48]=AnimSet'Anims_General_Rope.FastRope_v2'
    m_ThirdPersonAnimSets[49]=AnimSet'Anims_General_Obstacles.Ladders'
    m_ThirdPersonAnimSets[50]=AnimSet'Anims_General_Obstacles.Climb'
    m_ThirdPersonAnimSets[51]=AnimSet'Anims_General_Obstacles.Windows'
    m_ThirdPersonAnimSets[52]=AnimSet'Anims_General_TakeCover360.Doors.MG'
    m_ThirdPersonAnimSets[53]=AnimSet'Anims_General_Stacking.General.MG'
    m_ThirdPersonAnimSets[54]=AnimSet'Anims_General_Stacking.Windows.MG'
    m_ThirdPersonAnimSets[55]=AnimSet'Anims_General_TakeCover360.Idles.Jung'
    m_ThirdPersonAnimSets[56]=AnimSet'Anims_General_TakeCover360.Idles.Michael'
    m_ThirdPersonAnimSets[57]=AnimSet'Anims_Russians_MentalState.Lazy.MG'
    m_ThirdPersonAnimSets[58]=AnimSet'Anims_Russians_MentalState.Alert.MG'
    m_ThirdPersonAnimSets[59]=AnimSet'Anims_General_TakeCover360.Movement.MG'
    m_ThirdPersonAnimSets[60]=AnimSet'Anims_General_TakeCover360.Movement.Pistol'
    m_ThirdPersonAnimSets[61]=AnimSet'Anims_General_TakeCover360.Movement.Trans_Move'
    m_ThirdPersonAnimSets[62]=AnimSet'Anims_General_TakeCover360.Gadgets.Gadgets_Breaching_Charge'
    m_ThirdPersonAnimSets[63]=AnimSet'Anims_General_TakeCover360.Gadgets.Gadgets_Snake_Cam'
    m_ThirdPersonAnimSets[64]=AnimSet'Anims_General_TakeCover360.Gadgets.Gadgets_Detonator'
    m_ThirdPersonAnimSets[65]=AnimSet'Anims_General_TakeCover360.Throws.MG'
    m_ThirdPersonAnimSets[66]=AnimSet'Anims_General_TakeCover360.Aim_Throw.MG'
    m_ThirdPersonAnimSets[67]=AnimSet'Anims_General_TakeCover360.Aim_Throw.CrouchMG'
    m_ThirdPersonAnimSets[68]=AnimSet'Anims_General_TakeCover360.Draw_Holster.MG'
    m_ThirdPersonAnimSets[69]=AnimSet'Anims_General_TakeCover360.Draw_Holster.Pistol'
    m_ThirdPersonAnimSets[70]=AnimSet'Anims_General_TakeCover360.Reload.MG'
    m_ThirdPersonAnimSets[71]=AnimSet'Anims_General_TakeCover360.Reload.P90'
    m_ThirdPersonAnimSets[72]=AnimSet'Anims_General_TakeCover360.Reload.Pistol'
    m_ThirdPersonAnimSets[73]=AnimSet'Anims_General_TakeCover360.Reload.TRBull'
    m_ThirdPersonAnimSets[74]=AnimSet'Anims_General_TakeCover360.Reload.Shotgun'
    m_ThirdPersonAnimSets[75]=AnimSet'Anims_General_TakeCover360.Reload.LMG'
    m_ThirdPersonAnimSets[76]=AnimSet'Anims_General_TakeCover360.Reload.21E'
    m_ThirdPersonAnimSets[77]=AnimSet'Anims_General_TakeCover360.Reload.Mk46'
    m_ThirdPersonAnimSets[78]=AnimSet'Anims_General_TakeCover360.Suppressor.MG'
    m_ThirdPersonAnimSets[79]=AnimSet'Anims_General_TakeCover360.Suppressor.Pistol'
    m_ThirdPersonAnimSets[80]=AnimSet'Anims_General_TakeCover360.Suppressor.P90'
    m_ThirdPersonAnimSets[81]=AnimSet'Anims_General_TakeCover360.Trans_Left.MG'
    m_ThirdPersonAnimSets[82]=AnimSet'Anims_General_TakeCover360.Trans_Left.Y1_MG'
    m_ThirdPersonAnimSets[83]=AnimSet'Anims_General_TakeCover360.Trans_Left.Y2_MG'
    m_ThirdPersonAnimSets[84]=AnimSet'Anims_General_TakeCover360.Trans_Left.Y3_MG'
    m_ThirdPersonAnimSets[85]=AnimSet'Anims_General_TakeCover360.Trans_Left.Y4_MG'
    m_ThirdPersonAnimSets[86]=AnimSet'Anims_General_TakeCover360.Trans_Right.MG'
    m_ThirdPersonAnimSets[87]=AnimSet'Anims_General_TakeCover360.Trans_Right.X1_MG'
    m_ThirdPersonAnimSets[88]=AnimSet'Anims_General_TakeCover360.Trans_Right.X2_MG'
    m_ThirdPersonAnimSets[89]=AnimSet'Anims_General_TakeCover360.Trans_Right.X3_MG'
    m_ThirdPersonAnimSets[90]=AnimSet'Anims_General_TakeCover360.Trans_Right.X4_MG'
    m_ThirdPersonAnimSets[91]=AnimSet'Anims_General_TakeCover360.Poses.Ready_MG'
    m_ThirdPersonAnimSets[92]=AnimSet'Anims_General_TakeCover360.Poses.Ready_Pistol'
    m_ThirdPersonAnimSets[93]=AnimSet'Anims_General_TakeCover360.Poses.PoseFixes'
    m_ThirdPersonAnimSets[94]=AnimSet'Anims_General_TakeCover360.Aim.MG'
    m_ThirdPersonAnimSets[95]=AnimSet'Anims_General_TakeCover360.Aim.Pistol'
    m_ThirdPersonAnimSets[96]=AnimSet'Anims_General_TakeCover360.Aim.Crouch_MG'
    m_ThirdPersonAnimSets[97]=AnimSet'Anims_General_TakeCover360.Aim.Crouch_Pistol'
    m_ThirdPersonAnimSets[98]=AnimSet'Anims_General_TakeCover360.BlindFire.Crouch_MG'
    m_ThirdPersonAnimSets[99]=AnimSet'Anims_General_TakeCover360.BlindFire.Crouch_Pistol'
    m_ThirdPersonAnimSets[100]=AnimSet'Anims_General_TakeCover360.BlindFire.MG'
    m_ThirdPersonAnimSets[101]=AnimSet'Anims_General_TakeCover360.BlindFire.Pistol'
    m_ThirdPersonAnimSets[102]=AnimSet'Anims_General_TakeCover360.BlindFire.Shotgun'
    m_ThirdPersonAnimSets[103]=AnimSet'Anims_General_TakeCover360.BlindFire.Sniper'
    m_ThirdPersonAnimSets[104]=AnimSet'Anims_General_TakeCover360.Enter_Exit.MG'
    m_ThirdPersonAnimSets[105]=AnimSet'Anims_General_TakeCover360.Enter_Exit.Crouch_MG'
    m_ThirdPersonAnimSets[106]=AnimSet'Anims_General_TakeCover360.Look.MG'
    m_ThirdPersonAnimSets[107]=AnimSet'Anims_General_Interaction.BombDiffuse'
    m_ThirdPersonAnimSets[108]=AnimSet'Anims_General_Interaction.Freeing'
    m_ThirdPersonAnimSets[109]=AnimSet'Anims_General_Interaction.Replenishing_Crate'
    m_ThirdPersonAnimSets[110]=AnimSet'Anims_General_Interaction.Securing'
    m_ThirdPersonAnimSets[111]=AnimSet'Anims_General_Stacking.Doors.Mike'
    m_ThirdPersonAnimSets[112]=AnimSet'Anims_General_Reactions.Injuries.Jung'
    m_ThirdPersonAnimSets[113]=AnimSet'Anims_General_Gadgets.Syringe'
    m_ThirdPersonAnimSets[114]=AnimSet'Anims_General_Chopper.Temp.OldSitting'
    m_ThirdPersonAnimSets[115]=AnimSet'Anims_General_Chopper.entry.Logan'
    m_ThirdPersonAnimSets[116]=AnimSet'Anims_General_Chopper.Exit.Logan'
    m_ThirdPersonAnimSets[117]=AnimSet'Anims_General_Chopper.Idle.Logan'
    m_ThirdPersonAnimSets[118]=AnimSet'Anims_General_Transitions.Rappel'
    m_ThirdPersonAnimSets[119]=AnimSet'Anims_General_Transitions.FastRope'
    m_ThirdPersonAnimSets[120]=AnimSet'Anims_General_Transitions.Chopper'
    m_ThirdPersonAnimSets[121]=AnimSet'Anims_General_TakeCover360.Aim_Throw.MG'
    m_fStopTransitionLenght=140.0000000
    m_fStartTransitionLenght=127.0000000
    m_RagdollAnimTree=AnimTree'AnimTreeRagdoll.AnimTreeRagdoll'
    m_fHipsReachSpeed=85.0000000
    m_fFeetReachSpeed=135.0000000
    m_iMaxTickWithoutAnimate=120
    bCanWalkOffLedges=true
    CrouchHeight=64.0000000
    Mesh=HeadMesh
    // Reference: CylinderComponent'Default__R6Character.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6Pawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=84.0000000
    end object
    CylinderComponent=CollisionCylinder
    bStasis=true
    m_bIgnoreForNavMesh=true
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6Character.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6Pawn.Arrow'
    begin object name="Arrow"
    end object
    Components[1]=Arrow
    Components[2]=HeadMesh
    Components[3]=TorsoMesh
    Components[4]=LegsMesh
    Components[5]=HairMesh
    Components[6]=ArmorTorsoMesh
    Components[7]=ArmorShoulderMesh1
    Components[8]=ArmorShoulderMesh2
    Components[9]=ArmorLegsMesh1
    Components[10]=ArmorLegsMesh2
    Components[11]=ArmorArmsMesh1
    Components[12]=ArmorArmsMesh2
    CollisionComponent=CollisionCylinder
}