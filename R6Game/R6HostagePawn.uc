class R6HostagePawn extends R6Character
    native
    config(Character)
    hidecategories(lighting);

enum EHostageState
{
    HOSTAGESTATE_AWAITINGRESCUE,    // 0
    HOSTAGESTATE_FOLLOWING,         // 1
    HOSTAGESTATE_WAITING,           // 2
    HOSTAGESTATE_MAX                // 3
};

var(AI_Hostage) R6CivilController.ePROFILETYPE m_eCurrentProfile;
var R6HostagePawn.EHostageState m_eState;
var() bool m_bHostageDebug;
var int m_iCivilZoneID;
var R6DelimiterInfoPoint m_pLastCivilZoneGoal;
var R6Pawn m_pR6PawnFollowing;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_eState;
}

function int GetMaxHealth()
{
    local R6GameInfo pGameInfo;

    pGameInfo = R6GameInfo(WorldInfo.Game);
    // End:0x54
    if((pGameInfo != none) && int(pGameInfo.GetGameMode()) == int(7))
    {
        return GetHealthConfig().m_iMaxHealthHostage;        
    }
    else
    {
        return GetHealthConfig().m_iMaxHealthHostageMP;
    }
    return;
}

function RemoveHostage()
{
    m_bTickOnlyWhenVisible = true;
    bDisableAI = true;
    ShutDown();
    // End:0x34
    if(m_pTeamManager != none)
    {
        m_pTeamManager.RemovePawnFromTeam(self, true);
    }
    // End:0x4B
    if(m_pAI != none)
    {
        m_pAI.Destroy();
    }
    Health = 0;
    Destroy();
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

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    switch(m_eState)
    {
        // End:0x17
        case 1:
            eDesc = 18;
            return true;
        // End:0x1C
        case 2:
        // End:0x2B
        case 0:
            eDesc = 17;
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6HostageManager pHostageMgr;

    // End:0x52
    if(GetGameManager().IsMultiplayer())
    {
        // End:0x52
        if(WorldInfo.Game != none)
        {
            R6GameInfo(WorldInfo.Game).PawnInteracted(self, R6Pawn(pInteractor), true);
        }
    }
    // End:0x6C
    if((IsIncapacitated()) || !IsAlive())
    {
        return;
    }
    pHostageMgr = R6HostageManager(m_pTeamManager);
    // End:0xEB
    if(pHostageMgr != none)
    {
        // End:0xC2
        if(int(pHostageMgr.GetCurrentTacticFor(self)) != int(13))
        {
            pHostageMgr.ChangeTacticFor(self, 13, R6Pawn(pInteractor));            
        }
        else
        {
            pHostageMgr.ChangeTacticFor(self, 31, R6Pawn(pInteractor));
        }
        TriggerInteractSuccessEvent(pInteractor);
    }
    // End:0x125
    if((pInteractor != none) && pInteractor.Controller != none)
    {
        pInteractor.Controller.PropagateReturnFromInteractState();
    }
    return;
}

defaultproperties
{
    m_iCivilZoneID=-1
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
    m_ThirdPersonAnimSets[122]=AnimSet'Anims_Civilians_Movement.Crossover.Male'
    m_ThirdPersonAnimSets[123]=AnimSet'Anims_Civilians_Movement.FastWalk.Male'
    m_ThirdPersonAnimSets[124]=AnimSet'Anims_Civilians_Movement.Jog.Male'
    m_ThirdPersonAnimSets[125]=AnimSet'Anims_Civilians_Movement.Step.Male'
    m_ThirdPersonAnimSets[126]=AnimSet'Anims_Civilians_Movement.Transition.Male'
    m_ThirdPersonAnimSets[127]=AnimSet'Anims_Civilians_Movement.Turn.Male'
    m_ThirdPersonAnimSets[128]=AnimSet'Anims_Civilians_Movement.Walk.Male'
    m_ThirdPersonAnimSets[129]=AnimSet'Anims_Civilians.Stances.Male'
    m_ThirdPersonAnimSets[130]=AnimSet'Anims_Civilians.Idles.Male'
    m_ThirdPersonAnimSets[131]=AnimSet'Anims_Civilians.Reactions.Male'
    m_ThirdPersonAnimSets[132]=AnimSet'Anims_Civilians.Transitions.Male'
    m_eAlliance=1
    m_EquipmentTemplate=none
    ControllerClass=Class'R6HostageController'
}