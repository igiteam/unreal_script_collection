class R6TerroristPawn extends R6Character
    native
    config(Character)
    hidecategories(lighting);

var SLocationBasedHitPoints m_LocationHealth;
var bool m_bHasReceivedHealthBonus;
var bool m_bAlertStatusChangingToAware;
var bool m_bAlertStatusChangingToCombat;

// Export UR6TerroristPawn::execUpdateLimbDamageHPInfo(FFrame&, void* const)
native final function UpdateLimbDamageHPInfo(TraceHitInfo HitInfo, out int Damage);

function int GetMaxHealth()
{
    local int iHealth;

    // End:0xAE
    if(m_CharacterTemplate != none)
    {
        switch(m_CharacterTemplate.m_eArmorLevel)
        {
            // End:0x3F
            case 1:
                iHealth = GetHealthConfig().m_aTerroMaxHealth[1].m_iHealth;
                // End:0xAB
                break;
            // End:0x64
            case 2:
                iHealth = GetHealthConfig().m_aTerroMaxHealth[2].m_iHealth;
                // End:0xAB
                break;
            // End:0x89
            case 3:
                iHealth = GetHealthConfig().m_aTerroMaxHealth[3].m_iHealth;
                // End:0xAB
                break;
            // End:0xFFFF
            default:
                iHealth = GetHealthConfig().m_aTerroMaxHealth[0].m_iHealth;
                // End:0xAB
                break;
                break;
        }        
    }
    else
    {
        iHealth = 100;
    }
    return iHealth;
    return;
}

function InitHealth()
{
    Health = GetMaxHealth();
    m_LocationHealth = GetHealthConfig().m_LocationBased;
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    return;
}

event StartTimerStatusChangedToAware()
{
    // End:0x54
    if(!m_bAlertStatusChangingToAware)
    {
        m_bAlertStatusChangingToAware = true;
        // End:0x54
        if((m_pTeamManager != none) && m_pTeamManager.m_pTeamActor != none)
        {
            SetTimer(m_pTeamManager.m_pTeamActor.m_fTimeBeforePawnIsConsideredAware, false, 'SetStatusAware');
        }
    }
    return;
}

event StartTimerStatusChangedToCombat()
{
    // End:0x54
    if(!m_bAlertStatusChangingToCombat)
    {
        m_bAlertStatusChangingToCombat = true;
        // End:0x54
        if((m_pTeamManager != none) && m_pTeamManager.m_pTeamActor != none)
        {
            SetTimer(m_pTeamManager.m_pTeamActor.m_fTimeBeforePawnIsConsideredInCombat, false, 'SetStatusCombat');
        }
    }
    return;
}

// Export UR6TerroristPawn::execSetStatusAware(FFrame&, void* const)
native final function SetStatusAware();

// Export UR6TerroristPawn::execSetStatusCombat(FFrame&, void* const)
native final function SetStatusCombat();

defaultproperties
{
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
    m_ThirdPersonAnimSets[122]=AnimSet'Anims_Terrorist_Reactions.OnFire'
    m_ThirdPersonAnimSets[123]=AnimSet'Anims_Terrorist_Reactions.BulletReactions'
    m_ThirdPersonAnimSets[124]=AnimSet'Anims_Terrorist_Reactions.Terro_ReactAlert.Terro_ReactAlert'
    m_ThirdPersonAnimSets[125]=AnimSet'Anims_Terrorist_Reactions.Terro_ReactUnaware.Terro_ReactUnaware'
    m_ThirdPersonAnimSets[126]=AnimSet'Anims_Terrorist_Interaction.HShield.Poses'
    m_ThirdPersonAnimSets[127]=AnimSet'Anims_Terrorist_Interaction.Injuries'
    m_ThirdPersonAnimSets[128]=AnimSet'Anims_Terrorist_Reactions.Terro_handsignals.handsignals_pistol'
    m_ThirdPersonAnimSets[129]=AnimSet'Anims_Russians_Movement.Jog.MG'
    m_ThirdPersonAnimSets[130]=AnimSet'Anims_Russians_Movement.FastWalk.MG'
    m_ThirdPersonAnimSets[131]=AnimSet'Anims_Russians_Movement.FastWalk.Pistol'
    m_ThirdPersonAnimSets[132]=AnimSet'Anims_Russians_Movement.Walk.MG'
    m_ThirdPersonAnimSets[133]=AnimSet'Anims_Russians_Movement.Walk.Pistol'
    m_ThirdPersonAnimSets[134]=AnimSet'Anims_Russians_Movement.Crossover.MG'
    m_ThirdPersonAnimSets[135]=AnimSet'Anims_Russians_Movement.Crossover.Pistol'
    m_ThirdPersonAnimSets[136]=AnimSet'Anims_Russians_Movement.Transition.MG'
    m_ThirdPersonAnimSets[137]=AnimSet'Anims_Russians_Movement.Transition.Pistol'
    m_ThirdPersonAnimSets[138]=AnimSet'Anims_Russians_Movement.Turn.MG'
    m_ThirdPersonAnimSets[139]=AnimSet'Anims_Russians_Movement.Turn.Pistol'
    m_ThirdPersonAnimSets[140]=AnimSet'Anims_Russians_Movement.Step.MG'
    m_ThirdPersonAnimSets[141]=AnimSet'Anims_Russians_Movement.Step.Pistol'
    m_ThirdPersonAnimSets[142]=AnimSet'Anims_Dialogue.Terrorist.Alert'
    m_ThirdPersonAnimSets[143]=AnimSet'Anims_Dialogue.Terrorist.Unaware'
    m_fStartTransitionLenght=126.0000000
}