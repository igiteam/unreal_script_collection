class R6RainbowPawnJoanna extends R6RainbowPawn
    native
    config(Character)
    hidecategories(lighting);

function int GetMaxHealth()
{
    return GetDifficultyConfig().GetRainbowMaxHealth();
    return;
}

defaultproperties
{
    m_strRainbowNameLocKey="Joanna"
    m_SyringeComponentFP=none
    m_SyringeComponentTP=none
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.HeadMesh'
    begin object name="HeadMesh"
        AnimTreeTemplate=AnimTree'AnimTreePlayer.LightPlayerTree'
    end object
    m_HeadMesh=HeadMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.TorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.TorsoMesh'
    begin object name="TorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_TorsoMesh=TorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.LegsMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.LegsMesh'
    begin object name="LegsMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_LegsMesh=LegsMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HairMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.HairMesh'
    begin object name="HairMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_HairMesh=HairMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorTorsoMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorTorsoMesh'
    begin object name="ArmorTorsoMesh"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorTorsoMesh=ArmorTorsoMesh
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorShoulderMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorShoulderMesh1'
    begin object name="ArmorShoulderMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorShoulderMesh1=ArmorShoulderMesh1
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorShoulderMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorShoulderMesh2'
    begin object name="ArmorShoulderMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorShoulderMesh2=ArmorShoulderMesh2
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorLegsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorLegsMesh1'
    begin object name="ArmorLegsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorLegsMesh1=ArmorLegsMesh1
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorLegsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorLegsMesh2'
    begin object name="ArmorLegsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorLegsMesh2=ArmorLegsMesh2
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorArmsMesh1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorArmsMesh1'
    begin object name="ArmorArmsMesh1"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorArmsMesh1=ArmorArmsMesh1
    // Reference: SkeletalMeshComponent'Default__R6RainbowPawnJoanna.ArmorArmsMesh2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__R6RainbowPawn.ArmorArmsMesh2'
    begin object name="ArmorArmsMesh2"
        ParentAnimComponent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_ArmorArmsMesh2=ArmorArmsMesh2
    m_pGasMaskMesh=none
    // Reference: StaticMeshComponent'Default__R6RainbowPawnJoanna.SnakeCamMeshTP'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6RainbowPawn.SnakeCamMeshTP'
    begin object name="SnakeCamMeshTP"
        ShadowParent=SkeletalMeshComponent'Default__R6RainbowPawnJoanna.HeadMesh'
    end object
    m_pSnakeCamMeshTP=SnakeCamMeshTP
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
    m_ThirdPersonAnimSets[122]=AnimSet'Anims_General_Chopper.Idle.Joanna'
    m_FirstPersonAnimSets=none
    m_bDontUseFacialExpression=true
    m_EquipmentTemplate=none
    m_AITemplate=R6AITemplate'RS5CharacterAITemplate.AItemplate.JoannaAITemplate'
    m_helicopterSittingAnims[0]="HeliIdle_A"
    m_helicopterSittingAnims[1]="HeliIdle_B"
    m_helicopterSittingAnims[2]="HeliIdle_C"
    Mesh=HeadMesh
    m_bTickOnlyWhenVisible=true
    // Reference: CylinderComponent'Default__R6RainbowPawnJoanna.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6RainbowPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__R6RainbowPawnJoanna.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6RainbowPawn.Arrow'
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