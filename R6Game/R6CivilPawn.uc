class R6CivilPawn extends R6Character
    native
    config(Character)
    hidecategories(lighting);

enum ECivilInteraction
{
    CIVILINTERACTION_NONE,          // 0
    CIVILINTERACTION_RUN_FROM_DANGER,// 1
    CIVILINTERACTION_RUN_FROM_GUNSHOTS,// 2
    CIVILINTERACTION_REACT_TO_GUNSHOTS,// 3
    CIVILINTERACTION_MAX            // 4
};

enum ECivilMood
{
    CIVILMOOD_NORMAL,               // 0
    CIVILMOOD_MAX                   // 1
};

enum EHostagePose
{
    HOSTAGEPOSE_STAND,              // 0
    HOSTAGEPOSE_COWER,              // 1
    HOSTAGEPOSE_KNEEL,              // 2
    HOSTAGEPOSE_FREE,               // 3
    HOSTAGEPOSE_MAX                 // 4
};

enum EHostageMood
{
    HOSTAGEMOOD_RELIEF,             // 0
    HOSTAGEMOOD_MAX                 // 1
};

enum EHostageTransition
{
    HOSTAGETRANS_NONE,              // 0
    HOSTAGETRANS_COWER_TO_KNEEL,    // 1
    HOSTAGETRANS_COWER_TO_STAND,    // 2
    HOSTAGETRANS_KNEEL_TO_COWER,    // 3
    HOSTAGETRANS_KNEEL_TO_STAND,    // 4
    HOSTAGETRANS_STAND_TO_COWER,    // 5
    HOSTAGETRANS_STAND_TO_KNEEL,    // 6
    HOSTAGETRANS_STAND_TO_CROUCH,   // 7
    HOSTAGETRANS_CROUCH_TO_STAND,   // 8
    HOSTAGETRANS_SAYING_LINE,       // 9
    HOSTAGETRANS_MAX                // 10
};

var config array<config string> m_sIdlesAnimsFear;
var config array<config string> m_sIdlesAnimsPanic;
var config array<config string> m_sIdlesAnimsHideA;
var config array<config string> m_sIdlesAnimsHideB;
var(AI_Civil) R6CivilController.ePROFILETYPE m_eCurrentProfile;
var R6CivilPawn.ECivilMood m_eNewMood;
var R6CivilPawn.ECivilMood m_eMood;
var R6CivilPawn.ECivilInteraction m_eCivilInteraction;
var R6GameEnums.EEventRelativeLocation m_eEventLocation;
var R6CivilPawn.EHostagePose m_ePose;
var R6CivilPawn.EHostageTransition m_eTransition;
var(AI_Civil) bool m_bIsHostage;
var(AI_Civil) bool m_bIsSpecialRainbow;
var() bool m_bCivilDebug;
var() bool m_bKeepMood;
var() int m_iCivilZoneID;
var R6DelimiterInfoPoint m_pLastCivilZoneGoal;
var Vector m_vRoamingTarget;
var config array<config string> m_sIdlesAnimsStand;
var config array<config string> m_sIdlesAnimsCower;
var config array<config string> m_sIdlesAnimsKneel;
var transient float m_fTimeLeftBeforeNextCheck;

// Export UR6CivilPawn::execChangeMood(FFrame&, void* const)
native final function ChangeMood(R6CivilPawn.ECivilMood eNewMood);

// Export UR6CivilPawn::execChangeMoodLatent(FFrame&, void* const)
native final function ChangeMoodLatent(R6CivilPawn.ECivilMood eNewMood);

// Export UR6CivilPawn::execChangePose(FFrame&, void* const)
native final function ChangePose(R6CivilPawn.EHostagePose ePose);

// Export UR6CivilPawn::execStartInteraction(FFrame&, void* const)
native final function StartInteraction(R6CivilPawn.EHostageTransition eInteraction);

// Export UR6CivilPawn::execHasBeenFreed(FFrame&, void* const)
native final function HasBeenFreed();

function int GetMaxHealth()
{
    return GetHealthConfig().m_iMaxHealthCivil;
    return;
}

event bool DontPlayIdles()
{
    return (m_pAI != none) && m_pAI.IsAScriptZombie();
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    // End:0x5F
    if((GetGameManager().IsMultiplayer() && int(WorldInfo.NetMode) != int(NM_Client)) && m_RadarPawnRepInfo != none)
    {
        m_RadarPawnRepInfo.m_bNeutral = true;
    }
    return;
}

function TimerInteractionFinished()
{
    m_eCivilInteraction = 0;
    m_fInteractLength = 0.0000000;
    return;
}

defaultproperties
{
    m_eCurrentProfile=1
    m_iCivilZoneID=-1
    m_sIdlesAnimsStand[0]="StandIdle_1"
    m_sIdlesAnimsStand[1]="StandIdle_2"
    m_sIdlesAnimsStand[2]="StandIdle_3"
    m_sIdlesAnimsStand[3]="StandIdle_4"
    m_sIdlesAnimsStand[4]="StandIdle_5"
    m_sIdlesAnimsCower[0]="CowerIdle_1"
    m_sIdlesAnimsCower[1]="CowerIdle_2"
    m_sIdlesAnimsCower[2]="CowerIdle_3"
    m_sIdlesAnimsKneel[0]="KneelingIdle_1"
    m_sIdlesAnimsKneel[1]="KneelingIdle_2"
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.HeadMesh'
    begin object name="HeadMesh"
        AnimTreeTemplate=AnimTree'AnimTreeCivilian.CivilianTree'
    end object
    m_HeadMesh=HeadMesh
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.TorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.TorsoMesh'
    begin object name="TorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_TorsoMesh=TorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.LegsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.LegsMesh'
    begin object name="LegsMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_LegsMesh=LegsMesh
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.HairMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.HairMesh'
    begin object name="HairMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_HairMesh=HairMesh
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorTorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorTorsoMesh'
    begin object name="ArmorTorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorTorsoMesh=ArmorTorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorShoulderMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorShoulderMesh1'
    begin object name="ArmorShoulderMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorShoulderMesh1=ArmorShoulderMesh1
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorShoulderMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorShoulderMesh2'
    begin object name="ArmorShoulderMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorShoulderMesh2=ArmorShoulderMesh2
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorLegsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorLegsMesh1'
    begin object name="ArmorLegsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorLegsMesh1=ArmorLegsMesh1
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorLegsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorLegsMesh2'
    begin object name="ArmorLegsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorLegsMesh2=ArmorLegsMesh2
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorArmsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorArmsMesh1'
    begin object name="ArmorArmsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorArmsMesh1=ArmorArmsMesh1
    // Reference: SkeletalMeshComponent'Default__R6CivilPawn.ArmorArmsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6Character.ArmorArmsMesh2'
    begin object name="ArmorArmsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6CivilPawn.HeadMesh'
    end object
    m_ArmorArmsMesh2=ArmorArmsMesh2
    m_ThirdPersonAnimSets[0]=AnimSet'Anims_Civilians_Movement.FastWalk.Male'
    m_ThirdPersonAnimSets[1]=AnimSet'Anims_Civilians_Movement.Jog.Male'
    m_ThirdPersonAnimSets[2]=AnimSet'Anims_Civilians_Movement.Transition.Male'
    m_ThirdPersonAnimSets[3]=AnimSet'Anims_Civilians_Movement.Turn.Male'
    m_ThirdPersonAnimSets[4]=AnimSet'Anims_Civilians_Movement.Walk.Male'
    m_ThirdPersonAnimSets[5]=AnimSet'Anims_Civilians.Stances.Male'
    m_ThirdPersonAnimSets[6]=AnimSet'Anims_Civilians.Idles.Male'
    m_ThirdPersonAnimSets[7]=AnimSet'Anims_Civilians.Reactions.Male'
    m_ThirdPersonAnimSets[8]=AnimSet'Anims_Facial_Generic.Talking'
    m_eAlliance=1
    m_EquipmentTemplate=none
    ControllerClass=Class'R6CivilController'
    Mesh=HeadMesh
    // Reference: CylinderComponent'Default__R6CivilPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6Character.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6CivilPawn.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6Character.Arrow'
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
}