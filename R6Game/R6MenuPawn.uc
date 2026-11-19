class R6MenuPawn extends R6PlayerPawn
    native
    config(Character)
    hidecategories(lighting);

enum EMenuCameraMovement
{
    MENUCAM_ArmorToClothing,        // 0
    MENUCAM_ArmorToMain,            // 1
    MENUCAM_ArmorToWeapon,          // 2
    MENUCAM_ClothingToArmor,        // 3
    MENUCAM_ClothingToMain,         // 4
    MENUCAM_ClothingToWeapon,       // 5
    MENUCAM_CompStationToMain,      // 6
    MENUCAM_CompStationToTrophies,  // 7
    MENUCAM_MainToArmor,            // 8
    MENUCAM_MainToClothing,         // 9
    MENUCAM_MainToCompStation,      // 10
    MENUCAM_MainToTrophies,         // 11
    MENUCAM_MainToWeapon,           // 12
    MENUCAM_TrophiesToCompStation,  // 13
    MENUCAM_TrophiesToMain,         // 14
    MENUCAM_WeaponToArmor,          // 15
    MENUCAM_WeaponToClothing,       // 16
    MENUCAM_WeaponToMain,           // 17
    MENUCAM_MainZoomIn,             // 18
    MENUCAM_MainZoomOut,            // 19
    MENUCAM_ArmoryZoomIn,           // 20
    MENUCAM_ArmoryZoomOut,          // 21
    MENUCAM_MAX                     // 22
};

enum EPlayerAnimState
{
    MENUPLAYER_ANIM_EquipArm,       // 0
    MENUPLAYER_ANIM_EquipArmAlt,    // 1
    MENUPLAYER_ANIM_EquipBoots,     // 2
    MENUPLAYER_ANIM_CheckHimself,   // 3
    MENUPLAYER_ANIM_EquipChest,     // 4
    MENUPLAYER_ANIM_EquipChestAlt1, // 5
    MENUPLAYER_ANIM_EquipChestAlt2, // 6
    MENUPLAYER_ANIM_EquipChestAlt3, // 7
    MENUPLAYER_ANIM_ChangeFace,     // 8
    MENUPLAYER_ANIM_EquipGlove,     // 9
    MENUPLAYER_ANIM_ChangeHead,     // 10
    MENUPLAYER_ANIM_ChangeLegs,     // 11
    MENUPLAYER_ANIM_EquipShoulders, // 12
    MENUPLAYER_ANIM_StandIdle,      // 13
    MENUPLAYER_ANIM_StandIdle2,     // 14
    MENUPLAYER_ANIM_EquipWeaponPrimary,// 15
    MENUPLAYER_ANIM_EquipWeaponSecondary,// 16
    MENUPLAYER_ANIM_CloseUpIdle,    // 17
    MENUPLAYER_ANIM_EquipGadget,    // 18
    MENUPLAYER_ANIM_EquipPistol,    // 19
    MENUPLAYER_ANIM_DEBUG1,         // 20
    MENUPLAYER_ANIM_DEBUG2,         // 21
    MENUPLAYER_ANIM_DEBUG3,         // 22
    MENUPLAYER_ANIM_MAX             // 23
};

enum EFacialHairsColors
{
    COLOR_FacialHairs_Chatain,      // 0
    COLOR_FacialHairs_Blond,        // 1
    COLOR_FacialHairs_Grey,         // 2
    COLOR_FacialHairs_Black,        // 3
    COLOR_FacialHairs_MAX           // 4
};

var export editinline array<export editinline StaticMeshComponent> m_aHeadGearAttachments;
var export editinline array<export editinline StaticMeshComponent> m_aFaceGearAttachments;
var export editinline array<export editinline StaticMeshComponent> m_aEyeWearAttachments;
var export editinline SkeletalMeshComponent m_CustomHeadMesh;
var AnimTree m_CharacterMenuAnim;
var int m_iDebugAnimations;
var R6MenuPawn.EPlayerAnimState m_eCurrentAnimState;
var array<Actor> m_CameraActors;
var bool m_bIsInArmory;
var bool m_bIsInZoomMode;
var bool m_bHasCustomHead;
var bool m_bIsACameraInMotion;
var SkeletalMesh m_pCustomHeadMesh;
var array<Vector> m_CameraActorsLocation;
var int m_iPreviewShoulderArmor;
var int m_iPreviewArmArmor;
var int m_iPreviewLegArmor;
var int m_iPreviewBodyArmor;

// Export UR6MenuPawn::execLoadEquipmentTemplate(FFrame&, void* const)
native function bool LoadEquipmentTemplate(string strTemplate);

// Export UR6MenuPawn::execUpdateCameraRotation(FFrame&, void* const)
native function bool UpdateCameraRotation(float fTriggerLeft, float fTriggerRight);

// Export UR6MenuPawn::execApplyHeadGear(FFrame&, void* const)
native function StaticMeshComponent ApplyHeadGear(string strName);

// Export UR6MenuPawn::execApplyFaceGear(FFrame&, void* const)
native function StaticMeshComponent ApplyFaceGear(string strName);

// Export UR6MenuPawn::execApplyEyeWear(FFrame&, void* const)
native function StaticMeshComponent ApplyEyeWear(string strName);

// Export UR6MenuPawn::execUpdatePecPlayerAppearance(FFrame&, void* const)
native function UpdatePecPlayerAppearance();

// Export UR6MenuPawn::execApplyCamoToSkelMesh(FFrame&, void* const)
native function bool ApplyCamoToSkelMesh(int iID, SkeletalMeshComponent pMesh);

// Export UR6MenuPawn::execApplyCamoToStaticMesh(FFrame&, void* const)
native function bool ApplyCamoToStaticMesh(int iID, StaticMeshComponent pMesh);

event SetWeaponAttachments(R6GameEnums.EWeaponAttachmentLevel eAttachmentLevel)
{
    // End:0x20
    if(m_R6Weapon != none)
    {
        m_R6Weapon.SetCustomAttachment(eAttachmentLevel);
    }
    return;
}

event bool UpdateWeapon(class<R6Weapon> weapClass)
{
    local R6Weapon OldWeapon;
    local int iSlot;

    // End:0x0D
    if(m_R6InvManager == none)
    {
        return false;
    }
    iSlot = m_R6InvManager.m_iActiveWeapon;
    // End:0xAB
    if(m_R6InvManager.m_inventorySlots[iSlot].CanContain(weapClass))
    {
        OldWeapon = m_R6Weapon;
        m_R6InvManager.RemoveFromInventory(OldWeapon);
        // End:0xAB
        if(m_R6InvManager.CreateInventoryInSlot(weapClass, iSlot) != none)
        {
            m_R6InvManager.SetCurrentWeaponIndex(iSlot, false, true);
            OldWeapon.Destroy();
        }
    }
    return;
}

event bool FindCameraForMenuPlayer()
{
    local CameraActor aCamera;

    // End:0x23
    foreach AllActors(Class'Engine.CameraActor', aCamera)
    {
        m_CameraActors[m_CameraActors.Length] = aCamera;        
    }    
    return true;
    return;
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.CustomHeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CustomHeadMesh" class=Class'Engine.SkeletalMeshComponent'
        AnimTreeTemplate=AnimTree'AnimTreePlayer.MenuPlayerTree'
        m_bUseHumanIK=true
        m_bEnableHumanIK=true
        Rotation=(Pitch=0,Yaw=-16384,Roll=0)
        m_eComponentVisibility=2
        m_bDontSupportFirstPersonPOVInThird=true
    end object
    m_CustomHeadMesh=CustomHeadMesh
    m_CharacterMenuAnim=AnimTree'AnimTreePlayer.MenuPlayerTree'
    m_eCurrentAnimState=13
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.HeadMesh'
    begin object name="HeadMesh"
        AnimTreeTemplate=AnimTree'AnimTreePlayer.MenuPlayerTree'
    end object
    m_HeadMesh=HeadMesh
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.TorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.TorsoMesh'
    begin object name="TorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_TorsoMesh=TorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.LegsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.LegsMesh'
    begin object name="LegsMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_LegsMesh=LegsMesh
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.HairMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.HairMesh'
    begin object name="HairMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_HairMesh=HairMesh
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorTorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorTorsoMesh'
    begin object name="ArmorTorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorTorsoMesh=ArmorTorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorShoulderMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorShoulderMesh1'
    begin object name="ArmorShoulderMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorShoulderMesh1=ArmorShoulderMesh1
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorShoulderMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorShoulderMesh2'
    begin object name="ArmorShoulderMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorShoulderMesh2=ArmorShoulderMesh2
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorLegsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorLegsMesh1'
    begin object name="ArmorLegsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorLegsMesh1=ArmorLegsMesh1
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorLegsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorLegsMesh2'
    begin object name="ArmorLegsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorLegsMesh2=ArmorLegsMesh2
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorArmsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorArmsMesh1'
    begin object name="ArmorArmsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorArmsMesh1=ArmorArmsMesh1
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.ArmorArmsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.ArmorArmsMesh2'
    begin object name="ArmorArmsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_ArmorArmsMesh2=ArmorArmsMesh2
    // Reference: SkeletalMeshComponent'Default__R6MenuPawn.GasMaskMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6PlayerPawn.GasMaskMesh'
    begin object name="GasMaskMesh"
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_pGasMaskMesh=GasMaskMesh
    // Reference: StaticMeshComponent'Default__R6MenuPawn.SnakeCamMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6PlayerPawn.SnakeCamMeshTP'
    begin object name="SnakeCamMeshTP"
        ShadowParent=SkeletalMeshComponent'Default__R6MenuPawn.HeadMesh'
    end object
    m_pSnakeCamMeshTP=SnakeCamMeshTP
    m_ThirdPersonAnimSets[0]=AnimSet'Anims_PEC.Male'
    m_ThirdPersonAnimSets[1]=AnimSet'Anims_General_Stance.Stand.MG'
    m_ThirdPersonAnimSets[2]=AnimSet'Anims_General_Movement.FastWalk.MG'
    m_ThirdPersonAnimSets[3]=AnimSet'Anims_General_Weapons.General.Stances'
    Mesh=HeadMesh
    // Reference: CylinderComponent'Default__R6MenuPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6PlayerPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6MenuPawn.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6PlayerPawn.Arrow'
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