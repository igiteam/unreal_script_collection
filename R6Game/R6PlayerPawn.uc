class R6PlayerPawn extends R6RainbowPawn
    native
    config(Character)
    hidecategories(lighting);

const kHeadFeature_Skin = 0;
const kHeadFeature_Eyes = 1;
const kHeadFeature_FacialHair = 2;
const kTorsoFeature_Clothes = 0;
const kTorsoFeature_Gloves = 1;
const kTorsoFeature_Skin = 2;
const kInvalidArmorWearStyle = 999;
const kNumFacialHairsStyles = 6;

var bool m_bShouldUpdateAppearance;
var bool m_bUseGasMask;
var bool m_bUseGasMaskSF10;
var bool m_bPendingPecAppearanceUpdate;
var name m_FacePaintTextureParamName;
var name m_FaceScarTextureParamName;
var name m_CamoTextureParamNameDiffuse;
var name m_CamoTextureParamNameSpecular;
var string m_strDefaultEquipmentTemplate;
var string m_strDefaultFacialHairPath;
var string m_strEmptyFacialHairPath;
var name m_HeadGearSocketName;
var name m_FaceGearSocketName;
var export editinline StaticMeshComponent m_pClientGasMaskMesh;
var R6CarriedObject m_pCarriedObject;
var export editinline StaticMeshComponent m_pCarriedObjectComponent;
var string m_strTorsoSkinTexturePath;
var array<string> m_strFacialHairChannels;
var array<string> m_strRankBadgeChannels;
var R6EngineEnums.EPlayerCharacterType m_eCharacterType;
var byte m_bArmorArmsWearStyle;
var byte m_bArmorLegsWearStyle;
var byte m_bArmorShouldersWearStyle;
var R6EngineEnums.EEncumbranceType m_eArmorEncumbrance;
var int m_iForceComponentsUpdateTick;
var array<string> m_strFacialHairColors;
var int m_iCurrentHeadIndex;
var int m_iCurrentFacialHair;
var int m_iCurrentFacialFeature;
var int m_iCurrentHairColor;
var export editinline array<export editinline StaticMeshComponent> m_aHeadAttachments;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_eArmorEncumbrance, m_eCharacterType, 
        m_pCarriedObject;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner)
        m_bUseGasMask, m_bUseGasMaskSF10;
}

// Export UR6PlayerPawn::execApplyHead(FFrame&, void* const)
native function bool ApplyHead(string strName);

// Export UR6PlayerPawn::execApplyTorso(FFrame&, void* const)
native function bool ApplyTorso(string strName);

// Export UR6PlayerPawn::execApplyLegs(FFrame&, void* const)
native function bool ApplyLegs(string strName);

// Export UR6PlayerPawn::execApplyFacialHair(FFrame&, void* const)
native function bool ApplyFacialHair(int iFacialHairID, byte bColor);

// Export UR6PlayerPawn::execApplyFacialFeature(FFrame&, void* const)
native function bool ApplyFacialFeature(string strName);

// Export UR6PlayerPawn::execApplyFacialFeatureTexture(FFrame&, void* const)
native function bool ApplyFacialFeatureTexture(Texture2D pTexture);

// Export UR6PlayerPawn::execApplyRankBadge(FFrame&, void* const)
native function bool ApplyRankBadge(int rank);

// Export UR6PlayerPawn::execApplyChinStrap(FFrame&, void* const)
native function bool ApplyChinStrap(bool bApply);

// Export UR6PlayerPawn::execApplyArmorBody(FFrame&, void* const)
native function bool ApplyArmorBody(string strName);

// Export UR6PlayerPawn::execApplyArmorShoulder1(FFrame&, void* const)
native function bool ApplyArmorShoulder1(string strName);

// Export UR6PlayerPawn::execApplyArmorShoulder2(FFrame&, void* const)
native function bool ApplyArmorShoulder2(string strName);

// Export UR6PlayerPawn::execApplyArmorShin1(FFrame&, void* const)
native function bool ApplyArmorShin1(string strName);

// Export UR6PlayerPawn::execApplyArmorShin2(FFrame&, void* const)
native function bool ApplyArmorShin2(string strName);

// Export UR6PlayerPawn::execApplyArmorArm1(FFrame&, void* const)
native function bool ApplyArmorArm1(string strName);

// Export UR6PlayerPawn::execApplyArmorArm2(FFrame&, void* const)
native function bool ApplyArmorArm2(string strName);

// Export UR6PlayerPawn::execUpdateSkinTone(FFrame&, void* const)
native function bool UpdateSkinTone(SkeletalMeshComponent pMeshComponent, int iSkinTone, bool bFemale);

// Export UR6PlayerPawn::execApplyCamoToSkelMesh(FFrame&, void* const)
native function bool ApplyCamoToSkelMesh(int iID, SkeletalMeshComponent pMesh);

// Export UR6PlayerPawn::execApplyCamoToStaticMesh(FFrame&, void* const)
native function bool ApplyCamoToStaticMesh(int iID, StaticMeshComponent pMesh);

// Export UR6PlayerPawn::execApplyHeadGear(FFrame&, void* const)
native function StaticMeshComponent ApplyHeadGear(string strName);

// Export UR6PlayerPawn::execApplyFaceGear(FFrame&, void* const)
native function StaticMeshComponent ApplyFaceGear(string strName);

// Export UR6PlayerPawn::execApplyEyeWear(FFrame&, void* const)
native function StaticMeshComponent ApplyEyeWear(string strName);

// Export UR6PlayerPawn::execAttachGear(FFrame&, void* const)
native function StaticMeshComponent AttachGear(SkeletalMeshComponent pSkelComponent, StaticMesh pMesh, name strSocketName, optional bool bCheckGasMask);

// Export UR6PlayerPawn::execLoadEquipmentTemplate(FFrame&, void* const)
native function bool LoadEquipmentTemplate(string strTemplate);

reliable server event CallServerSetCharacterType(R6EngineEnums.EPlayerCharacterType eCharacterType)
{
    m_eCharacterType = eCharacterType;
    UpdatePlayerAppearance();
    return;
}

// Export UR6PlayerPawn::execUpdatePlayerAppearance(FFrame&, void* const)
native function UpdatePlayerAppearance();

// Export UR6PlayerPawn::execUpdatePecPlayerAppearance(FFrame&, void* const)
native function UpdatePecPlayerAppearance();

reliable client simulated function ClientUpdatePlayerAppearance()
{
    UpdatePlayerAppearance();
    return;
}

// Export UR6PlayerPawn::execGenerateRandomCharacter(FFrame&, void* const)
native function GenerateRandomCharacter(optional bool bRandomSeed, optional bool bNoCheckForBonesNumber);

defaultproperties
{
    m_FacePaintTextureParamName="FXP"
    m_FaceScarTextureParamName="fX"
    m_CamoTextureParamNameDiffuse="D"
    m_CamoTextureParamNameSpecular="S"
    m_strDefaultEquipmentTemplate="EquipmentTemplates.DefaultAssaultTemplate"
    m_strDefaultFacialHairPath="RS5MPCharacters_Head_%02dM.RS5MPC_Head_%02d_%s_hair%d%s"
    m_strEmptyFacialHairPath="RS5MPCharacters_Head_%02dM.RS5MPC_Head_%02d_%s"
    m_HeadGearSocketName="R65_HalfmaskSocket"
    m_FaceGearSocketName="R65_HalfmaskSocket"
    m_strTorsoSkinTexturePath="RS5MPCharacters_Torso.RS5MPC_TorsoSkin_%s_%02d_%s"
    m_strFacialHairChannels[0]="D"
    m_strFacialHairChannels[1]="S"
    m_strFacialHairChannels[2]="N"
    m_strRankBadgeChannels[0]="D"
    m_strRankBadgeChannels[1]="S"
    m_strRankBadgeChannels[2]="N"
    m_bArmorArmsWearStyle=231
    m_bArmorLegsWearStyle=231
    m_bArmorShouldersWearStyle=231
    m_strFacialHairColors[0]="a"
    m_strFacialHairColors[1]="b"
    m_strFacialHairColors[2]="c"
    m_strFacialHairColors[3]="d"
    m_SyringeComponentFP=none
    m_SyringeComponentTP=none
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
    m_ThirdPersonAnimSets[122]=AnimSet'Anims_General_Gadgets.Depot_Station'
    m_eHelicopterSeat=6
    m_EquipmentTemplate=R6EquipmentTemplate'EquipmentTemplates.DefaultPawnEquipment'
    m_strPlayerEquipmentTemplate="PlayerEquipment.PlayerEquipment"
    bHidden=true
    m_bAlwaysUpdate=true
}