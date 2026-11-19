class R6RainbowPawn extends R6Character
    native
    config(Character)
    hidecategories(lighting);

var bool m_bRainbowDebug;
var bool m_bSyringeAttached;
var bool m_bToldWarning1TeammateMayDie;
var bool m_bToldWarning2TeammateMayDie;
var R6EngineEnums.ERainbowMembers m_eRainbowMember;
var SoundCue m_TakeCoverReadySound;
var SoundCue m_TakeCoverPeekSound;
var private string m_strRainbowNameLocKey;
var string m_strRainbowName;
var export editinline SkeletalMeshComponent m_SyringeComponentFP;
var export editinline SkeletalMeshComponent m_SyringeComponentTP;

// Export UR6RainbowPawn::execGetRainbowName(FFrame&, void* const)
native function string GetRainbowName();

// Export UR6RainbowPawn::execAllowBloodStains(FFrame&, void* const)
native function bool AllowBloodStains();

// Export UR6RainbowPawn::execLoadEquipmentTemplate(FFrame&, void* const)
native function bool LoadEquipmentTemplate(string strTemplate);

function InteractSuccesful(Pawn pInteractor)
{
    local R6Pawn pPawn;

    InteractSuccesful(pInteractor);
    pPawn = R6Pawn(pInteractor);
    // End:0x38
    if(pPawn != none)
    {
        pPawn.Revive(self);
    }
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    return;
}

function int GetMaxHealth()
{
    return GetDifficultyConfig().GetPlayerMaxHealth();
    return;
}

// Export UR6RainbowPawn::execAttachSyringe(FFrame&, void* const)
native final function AttachSyringe(bool bAttach);

function IncapacitateTimer()
{
    // End:0x20
    if(int(m_eIncapaciteState) == int(4))
    {
        // End:0x20
        if(m_bSyringeAttached)
        {
            AttachSyringe(false);
        }
    }
    IncapacitateTimer();
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    // End:0x1E
    if(int(m_eIncapaciteState) == int(2))
    {
        eDesc = 16;
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x1A
    if(int(m_eIncapaciteState) == int(1))
    {
        eDesc = 16;
        return true;
    }
    return false;
    return;
}

defaultproperties
{
    m_TakeCoverReadySound=SoundCue'Dare.Foley_Rainbow.Play_Wall_TakeCover_UnAim'
    m_TakeCoverPeekSound=SoundCue'Dare.Foley_Rainbow.Play_Wall_TakeCover_Aim'
    m_strRainbowNameLocKey="Michael"
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawn.SyringeMeshComponentFP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SyringeMeshComponentFP" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Weapons.Gadgets.W_Gad_Medpack1stPerson_Syringe'
        AnimTreeTemplate=AnimNodeSequence'Default__R6RainbowPawn.SyringeAnimSeq'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_1st2.Syringe'
        m_eComponentVisibility=1
    end object
    m_SyringeComponentFP=SyringeMeshComponentFP
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawn.SyringeMeshComponentTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SyringeMeshComponentTP" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Weapons.Gadgets.W_Gad_Medpack1stPerson_Syringe'
        AnimTreeTemplate=AnimNodeSequence'Default__R6RainbowPawn.SyringeAnimSeq'
        PhysicsAsset=PhysicsAsset'RS5Weapons.Gadgets.W_Gad_Syringe1st_Physics'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_1st2.Syringe'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawn.HeadMesh'
        m_eComponentVisibility=2
    end object
    m_SyringeComponentTP=SyringeMeshComponentTP
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawn.GasMaskMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="GasMaskMesh" class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'RS5Accessories.RS5_GasMask'
        AnimSets[0]=AnimSet'Anims_Props_Gadgets_3rd.GasMask'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawn.HeadMesh'
        m_eComponentVisibility=2
        m_bDontSupportFirstPersonPOVInThird=true
    end object
    m_pGasMaskMesh=GasMaskMesh
    // Reference: StaticMeshComponent'Default__R6RainbowPawn.SnakeCamMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SnakeCamMeshTP" class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'RS5Accessories.RS5_MiniCam'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawn.HeadMesh'
        bAcceptsDecalsDuringGameplay=false
        BlockActors=false
        m_eComponentVisibility=2
        m_bDontSupportFirstPersonPOVInThird=true
    end object
    m_pSnakeCamMeshTP=SnakeCamMeshTP
    m_FirstPersonAnimSets[0]=AnimSet'Anims_FirstPerson.General.Idle'
    m_FirstPersonAnimSets[1]=AnimSet'Anims_FirstPerson.General.Movement'
    m_FirstPersonAnimSets[2]=AnimSet'Anims_FirstPerson.General.C4_and_Tripwire'
    m_FirstPersonAnimSets[3]=AnimSet'Anims_FirstPerson.General.Detonator'
    m_FirstPersonAnimSets[4]=AnimSet'Anims_FirstPerson.General.Throwing'
    m_FirstPersonAnimSets[5]=AnimSet'Anims_FirstPerson.01_Pistols.Pistol'
    m_FirstPersonAnimSets[6]=AnimSet'Anims_FirstPerson.01_Pistols.Mk23'
    m_FirstPersonAnimSets[7]=AnimSet'Anims_FirstPerson.01_Pistols.92FS'
    m_FirstPersonAnimSets[8]=AnimSet'Anims_FirstPerson.01_Pistols.TRBull'
    m_FirstPersonAnimSets[9]=AnimSet'Anims_FirstPerson.01_Pistols.USP40'
    m_FirstPersonAnimSets[10]=AnimSet'Anims_FirstPerson.02_SMGs.MG'
    m_FirstPersonAnimSets[11]=AnimSet'Anims_FirstPerson.02_SMGs.MP5'
    m_FirstPersonAnimSets[12]=AnimSet'Anims_FirstPerson.02_SMGs.MP7A1'
    m_FirstPersonAnimSets[13]=AnimSet'Anims_FirstPerson.02_SMGs.MP9'
    m_FirstPersonAnimSets[14]=AnimSet'Anims_FirstPerson.02_SMGs.P90'
    m_FirstPersonAnimSets[15]=AnimSet'Anims_FirstPerson.02_SMGs.UMP45'
    m_FirstPersonAnimSets[16]=AnimSet'Anims_FirstPerson.02_SMGs.MAC11'
    m_FirstPersonAnimSets[17]=AnimSet'Anims_FirstPerson.03_AssaultRifles.Assault'
    m_FirstPersonAnimSets[18]=AnimSet'Anims_FirstPerson.03_AssaultRifles.M8'
    m_FirstPersonAnimSets[19]=AnimSet'Anims_FirstPerson.03_AssaultRifles.552Commando'
    m_FirstPersonAnimSets[20]=AnimSet'Anims_FirstPerson.03_AssaultRifles.TAR21'
    m_FirstPersonAnimSets[21]=AnimSet'Anims_FirstPerson.03_AssaultRifles.AUGA3'
    m_FirstPersonAnimSets[22]=AnimSet'Anims_FirstPerson.03_AssaultRifles.G36C'
    m_FirstPersonAnimSets[23]=AnimSet'Anims_FirstPerson.03_AssaultRifles.SCAR'
    m_FirstPersonAnimSets[24]=AnimSet'Anims_FirstPerson.03_AssaultRifles.FAMAS'
    m_FirstPersonAnimSets[25]=AnimSet'Anims_FirstPerson.03_AssaultRifles.G3KA4'
    m_FirstPersonAnimSets[26]=AnimSet'Anims_FirstPerson.03_AssaultRifles.AK47'
    m_FirstPersonAnimSets[27]=AnimSet'Anims_FirstPerson.04_LMGs.21E'
    m_FirstPersonAnimSets[28]=AnimSet'Anims_FirstPerson.04_LMGs.Mk46'
    m_FirstPersonAnimSets[29]=AnimSet'Anims_FirstPerson.04_LMGs.MG36'
    m_FirstPersonAnimSets[30]=AnimSet'Anims_FirstPerson.05_Shotguns.Shotgun'
    m_FirstPersonAnimSets[31]=AnimSet'Anims_FirstPerson.05_Shotguns.XM26'
    m_FirstPersonAnimSets[32]=AnimSet'Anims_FirstPerson.05_Shotguns.M3'
    m_FirstPersonAnimSets[33]=AnimSet'Anims_FirstPerson.05_Shotguns.870MCS'
    m_FirstPersonAnimSets[34]=AnimSet'Anims_FirstPerson.06_SniperRifles.SV98'
    m_FirstPersonAnimSets[35]=AnimSet'Anims_FirstPerson.06_SniperRifles.PSG1'
    m_FirstPersonAnimSets[36]=AnimSet'Anims_FirstPerson.06_SniperRifles.M40A1'
    m_FirstPersonAnimSets[37]=AnimSet'Anims_FirstPerson.07_Shield.Shield'
    m_FirstPersonAnimSets[38]=AnimSet'Anims_FirstPerson.07_Shield.TRBull'
    m_FirstPersonAnimSets[39]=AnimSet'Anims_FirstPerson.General.WeaponPickup'
    m_FirstPersonAnimSets[40]=AnimSet'Anims_FirstPerson.General.Stances'
    m_FirstPersonAnimSets[41]=AnimSet'Anims_FirstPerson.General.HandSignals'
    m_FirstPersonAnimSets[42]=AnimSet'Anims_FirstPerson.General.Obstacle'
    m_FirstPersonAnimSets[43]=AnimSet'Anims_FirstPerson.General.Revive'
    m_FirstPersonAnimSets[44]=AnimSet'Anims_FirstPerson.General.Knockout'
    m_FirstPersonAnimtree=AnimTree'AnimTreeFirstPerson.FirstPersonTree'
    m_bDelayInvSpawn=false
    m_eAlliance=2
    m_eHelicopterSeat=2
    m_EquipmentTemplate=R6EquipmentTemplate'EquipmentTemplates.DefaultLoganEquipment'
    m_AITemplate=R6AITemplate'RS5CharacterAITemplate.AItemplate.DefaultRainbowAI'
    m_helicopterEntryAnims[0]="LOGAN_HeliEntry_1_Cam"
    m_helicopterEntryAnims[1]="LOGAN_HeliEntry_2_Cam"
    m_helicopterEntryAnims[2]="LOGAN_HeliEntry_3_Cam"
    m_helicopterEntryAnims[3]="LOGAN_HeliEntry_4_Cam"
    m_helicopterEntryAlone="LOGAN_HeliEntry_Alone_Cam"
    m_helicopterSittingAnims[0]="HeliIdle4"
    m_supportedExplosionEffects=/* Array type was not detected. */
}