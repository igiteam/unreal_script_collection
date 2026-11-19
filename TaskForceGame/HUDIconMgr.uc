class HUDIconMgr extends object
	native;

var array<HUDRenderInfo> ris;
var texture WhiteSquare;

static event DrawImageC( Canvas c, byte icon, float x, float y, optional float w, optional float h )
{
	if( w == 0 || h == 0 )
	{
		default.ris[icon].nsDrawImage( c, x - default.ris[icon].W/2, y - default.ris[icon].H/2 );
	}
	else
	{
		default.ris[icon].nsDrawImageHW( c, x - w/2, y - h/2, w, h );
	}
}

static event DrawImageHW(Canvas c, byte icon, float x, float y, optional float wOverride, optional float hOverride)
{
	if ((wOverride == 0) || (hOverride == 0))
	{
		default.ris[icon].nsDrawImage(c, x, y);
	}
	else
	{
		default.ris[icon].nsDrawImageHW(c, x, y, wOverride, hOverride);
	}
}

static function DrawImageTile(Canvas c, byte icon, float x, float y, float uTile, float vTile)
{
	default.ris[icon].nsDrawImageTile(c, x, y, uTile, vTile);
}

static function DrawImageFlip(Canvas c, byte icon, float x, float y, bool flipU, bool flipV)
{
	default.ris[icon].nsDrawImageFlip(c, x, y, flipU, flipV);
}

static function DrawImageClipV(Canvas c, byte icon, float x, float y, float YClip)
{
	default.ris[icon].nsDrawImageClipV(c, x, y, YClip);
}

static function DrawImageClipU(Canvas c, byte icon, float x, float y, float XClip)
{
	default.ris[icon].nsDrawImageClipU(c, x, y, XClip);
}


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: HUDRenderInfo'HUDIconMgr.HitDV'
    begin object name=HitDV class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.damageicons.HitD_Vert'
        UL=32.0000000
        VL=16.0000000
        ItemU=1.0000000
        ItemV=1.0000000
        W=32.0000000
        H=16.0000000
    end object
    ris[0]=HitDV
    // Reference: HUDRenderInfo'HUDIconMgr.HitDH'
    begin object name=HitDH class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.damageicons.HitD_Horiz'
        UL=16.0000000
        VL=32.0000000
        ItemU=1.0000000
        ItemV=1.0000000
        W=16.0000000
        H=32.0000000
    end object
    ris[1]=HitDH
    // Reference: HUDRenderInfo'HUDIconMgr.CHNoShoot'
    begin object name=CHNoShoot class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.reticule.noshoot'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[2]=CHNoShoot
    // Reference: HUDRenderInfo'HUDIconMgr.CHAssault'
    begin object name=CHAssault class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.m4_reticule'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[3]=CHAssault
    // Reference: HUDRenderInfo'HUDIconMgr.CHPistol'
    begin object name=CHPistol class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.pistol_reticule'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[4]=CHPistol
    // Reference: HUDRenderInfo'HUDIconMgr.CHShotgun'
    begin object name=CHShotgun class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.shotgun_reticule'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[5]=CHShotgun
    // Reference: HUDRenderInfo'HUDIconMgr.CHSniper'
    begin object name=CHSniper class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.reticule.Sniper'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[6]=CHSniper
    // Reference: HUDRenderInfo'HUDIconMgr.CHSubmachinegun'
    begin object name=CHSubmachinegun class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.mp5_reticule'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[7]=CHSubmachinegun
    // Reference: HUDRenderInfo'HUDIconMgr.XBLFriend'
    begin object name=XBLFriend class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.Friend'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[8]=XBLFriend
    // Reference: HUDRenderInfo'HUDIconMgr.XBLFriendSent'
    begin object name=XBLFriendSent class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.friend_requested'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[9]=XBLFriendSent
    // Reference: HUDRenderInfo'HUDIconMgr.XBLFriendReq'
    begin object name=XBLFriendReq class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.friend_requester'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[10]=XBLFriendReq
    // Reference: HUDRenderInfo'HUDIconMgr.XBLInviteSent'
    begin object name=XBLInviteSent class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.invite_requested'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[11]=XBLInviteSent
    // Reference: HUDRenderInfo'HUDIconMgr.XBLInviteRec'
    begin object name=XBLInviteRec class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.invite_requester'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[12]=XBLInviteRec
    // Reference: HUDRenderInfo'HUDIconMgr.XBLHasVoice'
    begin object name=XBLHasVoice class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.voice_active'
        U=9.0000000
        V=9.0000000
        UL=46.0000000
        VL=46.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[13]=XBLHasVoice
    // Reference: HUDRenderInfo'HUDIconMgr.XBLVoiceActive'
    begin object name=XBLVoiceActive class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.voice_talking'
        U=9.0000000
        V=9.0000000
        UL=46.0000000
        VL=46.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[14]=XBLVoiceActive
    // Reference: HUDRenderInfo'HUDIconMgr.XBLVoiceMute'
    begin object name=XBLVoiceMute class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.voice_muted'
        U=9.0000000
        V=9.0000000
        UL=46.0000000
        VL=46.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[15]=XBLVoiceMute
    // Reference: HUDRenderInfo'HUDIconMgr.XBLPasscode'
    begin object name=XBLPasscode class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.PassCode'
        UL=32.0000000
        VL=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[16]=XBLPasscode
    // Reference: HUDRenderInfo'HUDIconMgr.gren'
    begin object name=gren class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.he_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[17]=gren
    // Reference: HUDRenderInfo'HUDIconMgr.HUDHealthBkg'
    begin object name=HUDHealthBkg class=Class'ZombieEngine.HUDRenderInfo'
        UL=128.0000000
        VL=64.0000000
        W=128.0000000
        H=74.0000000
    end object
    ris[18]=HUDHealthBkg
    // Reference: HUDRenderInfo'HUDIconMgr.HUDHealthGuyStand'
    begin object name=HUDHealthGuyStand class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.DanielHUD.HealthGuyStand'
        UL=64.0000000
        VL=64.0000000
        W=46.0000000
        H=46.0000000
    end object
    ris[19]=HUDHealthGuyStand
    // Reference: HUDRenderInfo'HUDIconMgr.HUDHealthGuyCrouch'
    begin object name=HUDHealthGuyCrouch class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.DanielHUD.HealthGuyCrouch'
        UL=64.0000000
        VL=64.0000000
        W=50.0000000
        H=50.0000000
    end object
    ris[20]=HUDHealthGuyCrouch
    // Reference: HUDRenderInfo'HUDIconMgr.MP_FlagIcon'
    begin object name=MP_FlagIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.MPIcons_Flag'
        UL=32.0000000
        VL=32.0000000
        W=48.0000000
        H=48.0000000
    end object
    ris[21]=MP_FlagIcon
    // Reference: HUDRenderInfo'HUDIconMgr.M4_W'
    begin object name=M4_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.m4_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[22]=M4_W
    // Reference: HUDRenderInfo'HUDIconMgr.DE_W'
    begin object name=DE_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.USP_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[23]=DE_W
    // Reference: HUDRenderInfo'HUDIconMgr.MSG90_W'
    begin object name=MSG90_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.sniper_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[24]=MSG90_W
    // Reference: HUDRenderInfo'HUDIconMgr.AK_W'
    begin object name=AK_W class=Class'ZombieEngine.HUDRenderInfo'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[25]=AK_W
    // Reference: HUDRenderInfo'HUDIconMgr.C4_w'
    begin object name=C4_w class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.C4_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[26]=C4_w
    // Reference: HUDRenderInfo'HUDIconMgr.knife_W'
    begin object name=knife_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Knife_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[27]=knife_W
    // Reference: HUDRenderInfo'HUDIconMgr.M203_W'
    begin object name=M203_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.m203_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[28]=M203_W
    // Reference: HUDRenderInfo'HUDIconMgr.MP_Flag_Have_Icon'
    begin object name=MP_Flag_Have_Icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.MPIcons_Misc'
        UL=15.0000000
        VL=15.0000000
        W=24.0000000
        H=24.0000000
    end object
    ris[29]=MP_Flag_Have_Icon
    // Reference: HUDRenderInfo'HUDIconMgr.CHHvyMachineGun'
    begin object name=CHHvyMachineGun class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.mk43_reticule'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[30]=CHHvyMachineGun
    ris[31]=none
    // Reference: HUDRenderInfo'HUDIconMgr.m249_W'
    begin object name=m249_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.mk43_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[32]=m249_W
    // Reference: HUDRenderInfo'HUDIconMgr.mp5_W'
    begin object name=mp5_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.mp5_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[33]=mp5_W
    // Reference: HUDRenderInfo'HUDIconMgr.Ammo_ShotgunIcon'
    begin object name=Ammo_ShotgunIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Ammo_Shotgun'
        UL=32.0000000
        VL=32.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[34]=Ammo_ShotgunIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Ammo_HEIcon'
    begin object name=Ammo_HEIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Ammo_HE'
        UL=32.0000000
        VL=32.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[35]=Ammo_HEIcon
    // Reference: HUDRenderInfo'HUDIconMgr.MP_Flag_Down_Icon'
    begin object name=MP_Flag_Down_Icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.MPIcons_Misc'
        U=16.0000000
        UL=15.0000000
        VL=15.0000000
        W=24.0000000
        H=24.0000000
    end object
    ris[36]=MP_Flag_Down_Icon
    // Reference: HUDRenderInfo'HUDIconMgr.shotgun_W'
    begin object name=shotgun_W class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.shotgun_wi'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[37]=shotgun_W
    // Reference: HUDRenderInfo'HUDIconMgr.MP_Flag_Missing_Icon'
    begin object name=MP_Flag_Missing_Icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.MPIcons_Misc'
        U=32.0000000
        UL=15.0000000
        VL=15.0000000
        W=24.0000000
        H=24.0000000
    end object
    ris[38]=MP_Flag_Missing_Icon
    // Reference: HUDRenderInfo'HUDIconMgr.MP_KOH_Icon'
    begin object name=MP_KOH_Icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.MPIcons_Misc'
        U=31.0000000
        V=31.0000000
        UL=32.0000000
        VL=32.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[39]=MP_KOH_Icon
    // Reference: HUDRenderInfo'HUDIconMgr.CHGrenadeLauncher'
    begin object name=CHGrenadeLauncher class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.m203_reticule'
        UL=64.0000000
        VL=64.0000000
        ItemU=31.0000000
        ItemV=31.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[40]=CHGrenadeLauncher
    // Reference: HUDRenderInfo'HUDIconMgr.SniperScopeDotTex'
    begin object name=SniperScopeDotTex class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.SniperScopeDot'
        UL=8.0000000
        VL=8.0000000
        W=8.0000000
        H=8.0000000
    end object
    ris[41]=SniperScopeDotTex
    // Reference: HUDRenderInfo'HUDIconMgr.SniperScopeRingTex'
    begin object name=SniperScopeRingTex class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.SniperScopeRing'
        UL=128.0000000
        VL=128.0000000
        W=128.0000000
        H=128.0000000
    end object
    ris[42]=SniperScopeRingTex
    // Reference: HUDRenderInfo'HUDIconMgr.Drag_S_W'
    begin object name=Drag_S_W class=Class'ZombieEngine.HUDRenderInfo'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[43]=Drag_S_W
    // Reference: HUDRenderInfo'HUDIconMgr.flashbang'
    begin object name=flashbang class=Class'ZombieEngine.HUDRenderInfo'
        UL=128.0000000
        VL=32.0000000
        W=118.0000000
        H=29.5000000
    end object
    ris[44]=flashbang
    // Reference: HUDRenderInfo'HUDIconMgr.Live_Wait_Icon'
    begin object name=Live_Wait_Icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.live_wait'
        UL=32.0000000
        VL=32.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[45]=Live_Wait_Icon
    // Reference: HUDRenderInfo'HUDIconMgr.gren_icon'
    begin object name=gren_icon class=Class'ZombieEngine.HUDRenderInfo'
        UL=32.0000000
        VL=32.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[46]=gren_icon
    // Reference: HUDRenderInfo'HUDIconMgr.flag_carry_icon'
    begin object name=flag_carry_icon class=Class'ZombieEngine.HUDRenderInfo'
        UL=64.0000000
        VL=64.0000000
        W=46.0000000
        H=46.0000000
    end object
    ris[47]=flag_carry_icon
    // Reference: HUDRenderInfo'HUDIconMgr.is_vip_icon'
    begin object name=is_vip_icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.MPIcons_Misc'
        V=32.0000000
        UL=31.0000000
        VL=31.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[48]=is_vip_icon
    // Reference: HUDRenderInfo'HUDIconMgr.team_sf_icon'
    begin object name=team_sf_icon class=Class'ZombieEngine.HUDRenderInfo'
        UL=64.0000000
        VL=64.0000000
        W=46.0000000
        H=46.0000000
    end object
    ris[49]=team_sf_icon
    // Reference: HUDRenderInfo'HUDIconMgr.team_terrorist_icon'
    begin object name=team_terrorist_icon class=Class'ZombieEngine.HUDRenderInfo'
        UL=64.0000000
        VL=64.0000000
        W=46.0000000
        H=46.0000000
    end object
    ris[50]=team_terrorist_icon
    // Reference: HUDRenderInfo'HUDIconMgr.Btn_A'
    begin object name=Btn_A class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        UL=31.0000000
        VL=31.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[51]=Btn_A
    // Reference: HUDRenderInfo'HUDIconMgr.Btn_B'
    begin object name=Btn_B class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=32.0000000
        UL=31.0000000
        VL=31.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[52]=Btn_B
    // Reference: HUDRenderInfo'HUDIconMgr.Btn_X'
    begin object name=Btn_X class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        V=32.0000000
        UL=31.0000000
        VL=31.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[53]=Btn_X
    // Reference: HUDRenderInfo'HUDIconMgr.Btn_Y'
    begin object name=Btn_Y class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=32.0000000
        V=32.0000000
        UL=31.0000000
        VL=31.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[54]=Btn_Y
    // Reference: HUDRenderInfo'HUDIconMgr.Btn_PC_Back'
    begin object name=Btn_PC_Back class=Class'ZombieEngine.HUDRenderInfo'
        UL=31.0000000
        VL=31.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[55]=Btn_PC_Back
    // Reference: HUDRenderInfo'HUDIconMgr.Menu_Logo'
    begin object name=Menu_Logo class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN.Menu.combat_logo'
        UL=256.0000000
        VL=128.0000000
        W=256.0000000
        H=128.0000000
    end object
    ris[56]=Menu_Logo
    // Reference: HUDRenderInfo'HUDIconMgr.OBJ_Complete'
    begin object name=OBJ_Complete class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.ObjBoxes'
        U=16.0000000
        UL=15.0000000
        VL=16.0000000
        W=20.0000000
        H=20.0000000
    end object
    ris[57]=OBJ_Complete
    // Reference: HUDRenderInfo'HUDIconMgr.OBJ_Incomplete'
    begin object name=OBJ_Incomplete class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.ObjBoxes'
        UL=16.0000000
        VL=16.0000000
        W=20.0000000
        H=20.0000000
    end object
    ris[58]=OBJ_Incomplete
    // Reference: HUDRenderInfo'HUDIconMgr.OBJ_Disabled'
    begin object name=OBJ_Disabled class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.ObjBoxes'
        V=15.0000000
        UL=16.0000000
        VL=16.0000000
        W=20.0000000
        H=20.0000000
    end object
    ris[59]=OBJ_Disabled
    // Reference: HUDRenderInfo'HUDIconMgr.Controller_Image'
    begin object name=Controller_Image class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.scontroller'
        UL=256.0000000
        VL=256.0000000
        W=192.0000000
        H=162.0000000
    end object
    ris[60]=Controller_Image
    // Reference: HUDRenderInfo'HUDIconMgr.ScrollArrow'
    begin object name=ScrollArrow class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.ScrollArrow'
        UL=16.0000000
        VL=16.0000000
        ItemU=4.0000000
        ItemV=1.0000000
        W=12.0000000
        H=12.0000000
    end object
    ris[61]=ScrollArrow
    // Reference: HUDRenderInfo'HUDIconMgr.WaypointIcon'
    begin object name=WaypointIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Icons.arrow_down'
        UL=16.0000000
        VL=16.0000000
        ItemU=8.0000000
        W=16.0000000
        H=16.0000000
    end object
    ris[62]=WaypointIcon
    // Reference: HUDRenderInfo'HUDIconMgr.WaypointOffscreen'
    begin object name=WaypointOffscreen class=Class'ZombieEngine.HUDRenderInfo'
        UL=32.0000000
        VL=32.0000000
        W=16.0000000
        H=16.0000000
    end object
    ris[63]=WaypointOffscreen
    // Reference: HUDRenderInfo'HUDIconMgr.WaypointOffscreenBlur'
    begin object name=WaypointOffscreenBlur class=Class'ZombieEngine.HUDRenderInfo'
        UL=32.0000000
        VL=32.0000000
        W=16.0000000
        H=16.0000000
    end object
    ris[64]=WaypointOffscreenBlur
    // Reference: HUDRenderInfo'HUDIconMgr.RadarBkgInfo'
    begin object name=RadarBkgInfo class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.RadarCircle'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[65]=RadarBkgInfo
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonA'
    begin object name=ButtonA class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        UL=33.0000000
        VL=33.0000000
        W=33.0000000
        H=33.0000000
    end object
    ris[66]=ButtonA
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonB'
    begin object name=ButtonB class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=41.0000000
        UL=33.0000000
        VL=33.0000000
        W=33.0000000
        H=33.0000000
    end object
    ris[67]=ButtonB
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonX'
    begin object name=ButtonX class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=82.0000000
        UL=33.0000000
        VL=33.0000000
        W=33.0000000
        H=33.0000000
    end object
    ris[68]=ButtonX
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonY'
    begin object name=ButtonY class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=123.0000000
        UL=33.0000000
        VL=33.0000000
        W=33.0000000
        H=33.0000000
    end object
    ris[69]=ButtonY
    // Reference: HUDRenderInfo'HUDIconMgr.TriggerL'
    begin object name=TriggerL class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=164.0000000
        UL=25.0000000
        VL=33.0000000
        W=25.0000000
        H=33.0000000
    end object
    ris[70]=TriggerL
    // Reference: HUDRenderInfo'HUDIconMgr.TriggerR'
    begin object name=TriggerR class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=197.0000000
        UL=25.0000000
        VL=33.0000000
        W=25.0000000
        H=33.0000000
    end object
    ris[71]=TriggerR
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonStart'
    begin object name=ButtonStart class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        V=42.0000000
        UL=47.0000000
        VL=33.0000000
        W=47.0000000
        H=33.0000000
    end object
    ris[72]=ButtonStart
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonBack'
    begin object name=ButtonBack class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=55.0000000
        V=42.0000000
        UL=42.0000000
        VL=33.0000000
        W=42.0000000
        H=33.0000000
    end object
    ris[73]=ButtonBack
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonW'
    begin object name=ButtonW class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=105.0000000
        V=42.0000000
        UL=29.0000000
        VL=33.0000000
        W=29.0000000
        H=33.0000000
    end object
    ris[74]=ButtonW
    // Reference: HUDRenderInfo'HUDIconMgr.ButtonBl'
    begin object name=ButtonBl class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=142.0000000
        V=42.0000000
        UL=29.0000000
        VL=33.0000000
        W=29.0000000
        H=33.0000000
    end object
    ris[75]=ButtonBl
    // Reference: HUDRenderInfo'HUDIconMgr.DPadLeft'
    begin object name=DPadLeft class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=179.0000000
        V=42.0000000
        UL=33.0000000
        VL=33.0000000
        W=33.0000000
        H=33.0000000
    end object
    ris[76]=DPadLeft
    // Reference: HUDRenderInfo'HUDIconMgr.DPadDownLeft'
    begin object name=DPadDownLeft class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=220.0000000
        V=42.0000000
        UL=28.0000000
        VL=33.0000000
        W=28.0000000
        H=33.0000000
    end object
    ris[77]=DPadDownLeft
    // Reference: HUDRenderInfo'HUDIconMgr.DPadDown'
    begin object name=DPadDown class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        V=84.0000000
        UL=29.0000000
        VL=33.0000000
        W=29.0000000
        H=33.0000000
    end object
    ris[78]=DPadDown
    // Reference: HUDRenderInfo'HUDIconMgr.DPadDownRight'
    begin object name=DPadDownRight class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=37.0000000
        V=84.0000000
        UL=28.0000000
        VL=33.0000000
        W=28.0000000
        H=33.0000000
    end object
    ris[79]=DPadDownRight
    // Reference: HUDRenderInfo'HUDIconMgr.DPadRight'
    begin object name=DPadRight class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=73.0000000
        V=84.0000000
        UL=33.0000000
        VL=33.0000000
        W=33.0000000
        H=33.0000000
    end object
    ris[80]=DPadRight
    // Reference: HUDRenderInfo'HUDIconMgr.DPadUpRight'
    begin object name=DPadUpRight class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=114.0000000
        V=84.0000000
        UL=29.0000000
        VL=33.0000000
        W=29.0000000
        H=33.0000000
    end object
    ris[81]=DPadUpRight
    // Reference: HUDRenderInfo'HUDIconMgr.DPadUp'
    begin object name=DPadUp class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=151.0000000
        V=84.0000000
        UL=29.0000000
        VL=33.0000000
        W=29.0000000
        H=33.0000000
    end object
    ris[82]=DPadUp
    // Reference: HUDRenderInfo'HUDIconMgr.DPadUpLeft'
    begin object name=DPadUpLeft class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.xboxdings'
        U=188.0000000
        V=84.0000000
        UL=28.0000000
        VL=33.0000000
        W=28.0000000
        H=33.0000000
    end object
    ris[83]=DPadUpLeft
    // Reference: HUDRenderInfo'HUDIconMgr.HealthCrossIcon'
    begin object name=HealthCrossIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.HealthCross'
        UL=32.0000000
        VL=32.0000000
        W=14.0000000
        H=14.0000000
    end object
    ris[84]=HealthCrossIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Ammo_BulletIcon'
    begin object name=Ammo_BulletIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Ammo_Bullet'
        UL=32.0000000
        VL=32.0000000
        W=20.0000000
        H=27.0000000
    end object
    ris[85]=Ammo_BulletIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Ammo_M203Icon'
    begin object name=Ammo_M203Icon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Ammo_M203'
        UL=32.0000000
        VL=32.0000000
        W=20.0000000
        H=27.0000000
    end object
    ris[86]=Ammo_M203Icon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_DefuseIcon'
    begin object name=Action_DefuseIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Action_Defuse'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[87]=Action_DefuseIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_DoorIcon'
    begin object name=Action_DoorIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Action_Door'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[88]=Action_DoorIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_GeneralIcon'
    begin object name=Action_GeneralIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Action_General'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[89]=Action_GeneralIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_SearchIcon'
    begin object name=Action_SearchIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Action_Search'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[90]=Action_SearchIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_LockIcon'
    begin object name=Action_LockIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Action_Lock'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[91]=Action_LockIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_CardIcon'
    begin object name=Action_CardIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Item_Card'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[92]=Action_CardIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_KeyIcon'
    begin object name=Action_KeyIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Item_Key'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[93]=Action_KeyIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_KeyRingIcon'
    begin object name=Action_KeyRingIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Item_KeyRing'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[94]=Action_KeyRingIcon
    // Reference: HUDRenderInfo'HUDIconMgr.Action_NoteIcon'
    begin object name=Action_NoteIcon class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.NewHUD.Item_Note'
        UL=64.0000000
        VL=64.0000000
        ItemU=32.0000000
        ItemV=32.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[95]=Action_NoteIcon
    // Reference: HUDRenderInfo'HUDIconMgr.dpad'
    begin object name=dpad class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.dpad'
        U=2.0000000
        V=2.0000000
        UL=30.0000000
        VL=30.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[96]=dpad
    // Reference: HUDRenderInfo'HUDIconMgr.lthumbstick'
    begin object name=lthumbstick class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.lthumbstick'
        U=2.0000000
        V=2.0000000
        UL=30.0000000
        VL=30.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[97]=lthumbstick
    // Reference: HUDRenderInfo'HUDIconMgr.rthumbstick'
    begin object name=rthumbstick class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.Menu.rthumbstick'
        U=2.0000000
        V=2.0000000
        UL=30.0000000
        VL=30.0000000
        W=32.0000000
        H=32.0000000
    end object
    ris[98]=rthumbstick
    // Reference: HUDRenderInfo'HUDIconMgr.XBLVoiceThruTV'
    begin object name=XBLVoiceThruTV class=Class'ZombieEngine.HUDRenderInfo'
        mat=Texture'CBT_DYN_Interface.LiveIcons.voice_thru_tv'
        UL=64.0000000
        VL=64.0000000
        W=64.0000000
        H=64.0000000
    end object
    ris[99]=XBLVoiceThruTV
    WhiteSquare=Texture'CBT_DYN_Interface.Menu.i_am_small'
}