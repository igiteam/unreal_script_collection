//=============================================================================
// BasicHUD
// Heads up display
//=============================================================================
//class BasicHUD extends HUD
class BasicHUD extends LevelLoadHUD
	native
	config(user);

struct native ZHUDLocalizedMessage
{
	var Class<LocalMessage> Message;
	var int Switch;
	var PlayerReplicationInfo RelatedPRI;
	var Object OptionalObject;
	var float EndOfLife;
	var float LifeTime;
	var bool bDrawing;
	var int numLines;
	var string StringMessage;
	var color DrawColor;
	var font StringFont;
	var float XL, YL;
	var float YPos;
	var float TextSize;
	var float Kern;
};

const PULSE_SCALE = 0.5;
const PULSE_TIME = 0.5;
var float HealthPulseTime;
var float AmmoPulseTime[5];
var int AmmoPulseIcon[5];

const OBJECTIVE_TIME = 5;
const OBJECTIVE_TIME_FADE_IN = 1;
const OBJECTIVE_TIME_FADE_OUT = 2;

const CHECKPOINT_TIME = 3;
const CHECKPOINT_TIME_FADE_IN = 0.75;
const CHECKPOINT_TIME_FADE_OUT = 1.5;

var float CheckpointMsgTimer;

var int HudTest;

var() int SizeY,Count;
var bool bDrawingSpecial; //handles special hud icons brett
var bool loading;
var bool FirstRender;
var float LoadoutTime;
const LOADOUT_DISPLAY_TIME = 2.f; // time displayed without animation
const LOADOUT_FADE_TIME = 2.f;    // time it takes to animate

var string ObjDescription;

var Pawn PawnOwner;	// pawn currently managing this HUD (may be the viewtarget of the owner rather than the owner)
var PlayerReplicationInfo ViewedInfo;
//var FontInfo MyFont;
var float StartupMessageEnd;
var int StartupHeight;	// half of height in text lines of startup window
var byte StartupStage;

var float ObjectiveUpdateTimer;
var float ObjectivesIncompleteTimer;

// Localized Messages
var HUDLocalizedMessage LocalMessages[10];

const NUM_PICKUP_MSGS = 3;
var ZHUDLocalizedMessage PickupMessages[NUM_PICKUP_MSGS];
var int CurPickupMsg;
var int EmptySlotPickupMsg;

//
const NUM_SUBTITLE_MSGS = 3;
var ZHUDLocalizedMessage SubtitleMessages[NUM_SUBTITLE_MSGS];
var int CurSubtitleMsg;
var int EmptySlotSubtitleMsg;
//

const NUM_GUIDE_MSGS = 10;
var ZHUDLocalizedMessage WeaponMessage;
var ZHUDLocalizedMessage GuideMessage[NUM_GUIDE_MSGS];
var bool bMoveGuides;
var ZHUDLocalizedMessage TempGuideMessage;

const NUM_TELETYPE_MSGS = 2;
var ZHUDLocalizedMessage TeleTypeMessage[NUM_TELETYPE_MSGS];

const NUM_GAME_MSGS = 10;
var ZHUDLocalizedMessage GameMessages[NUM_GAME_MSGS];
var int CurGameMsg;
var int EmptySlotGameMsg;

var int OldClipX;
var bool bStartUpMessage;

// configuration options
var byte Style;

var float PickupTime;

var float WeaponFadeTime;
var float MessageFadeTime;
var class<CriticalEventPlus> TimeMessageClass;
//var string FontInfoClass;

var float LastTime, CurrentDeltaTime;

var float Scale;

var() float AimPerturb;		//AimPerturb goes from 0 to 1, 0 indicates horrible aim, 1 indicates perfect aim.
var() float CurEndurance;
var() int	CurHealth;
var() int	CurClips;
var() int	CurRounds;
var() int Glow;
var() float GlowFact;
var() float GlowDir;
var float GlowTime;

var() float CHAlpha;

const HIT_INDICATOR_TIMEOUT = 2.0f;
//const HIT_INDICATOR_TIMEOUT = 4.0f;

var float HitIndicatorTime;

//var float HitX;
//var float HitY;
//var float HitAngle;
//var int HitSector;
var float HitSectorTime[8];

var bool InScopeMode;
var bool IsSniperScope;
var() class<SimpleCrosshairRenderInfo> OverrideCHClass;

var ZMLRender ZMLDevice;

var bool ForceHideHud;
var string CurModeName;
var float ModeNameTime;
var const float ModeNameTimeBase;

var Texture BarBlurMat;
var Texture ControllerMat;

var Sound TeletypeSound;

var float Duration;

var bool shouldDrawTitleSafe;
var float BasePos;
var float RealBasePos;
var float WidthAdjust;
var float OpacityAdjust;
var float BasePosAdjust;

var bool CountdownTimerIsOn;
var float CountdownTimerTime;

var color AmberColor;
var color RedColor;
var color YellowColor;
var color GreenColor;
var color WhiteColor;

var int CurCHIndex;
var int CurWeapIndex;
var int OldCHIndex;
var int OldWeapIndex;

const HUD_FLASH_TIME = 0.5;

var float HealthFlashTime;

var pawn HealthWatchPawn;
var string HealthWatchName;

var bool bNoMessageDisplay;
var config bool bDisplaySubtitles;

var float TweakValX;
var float TweakValY;
var float TweakValZ;

var float SubTitleAdjust;
var float SubTitleLastAdjust;

var (HealthBoxes) int HealthBoxWidth;
var (HealthBoxes) int HealthBoxHeight;
var (HealthBoxes) int HealthBoxBorderThickness;

var localized string SpectatorSwitchText;
var localized string SpectatingText;
var localized string SpectatingSelfText;

enum EHUDIcon	//keep this in sync with the HUDIconMgr's array
{
	EHI_HitD_V,
	EHI_HitD_H
};

var bool bGrenadingNow;	// Used to help configure ammo display when doing grenade
var bool bGrenadingFlashbang;

var float MaxRedReticleDist;  // Max distance at which reticle will turn red (changes according to weapon)
var float NotifyTime;

var localized String ObjectivesUpdatedText;

exec function ShowScores()
{
	if( !InScopeMode )
	{
		super.ShowScores();
	}
	else
	{
		bShowScores = false;
	}
}

simulated function DrawNotify(Canvas c)
{
	if (NotifyTime == 0)
	{
		return;
	}
	
	if (Level.TimeSeconds > NotifyTime)
	{
		NotifyTime = 0;
		return;
	}
	
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_XBL_INVITE_REC, 48-WidthAdjust, basePos-96-36, 32, 32);
}

simulated function SetSFColor(Canvas c)
{
	c.SetDrawColor(0,91,143);	
}

simulated function SetTerrColor(Canvas c)
{
	c.SetDrawColor(229,135,25);
}

simulated function SetTeamColor(Canvas c, PlayerReplicationInfo PRI)
{
	if (PRI.Team != None && PRI.Team.TeamIndex == 1)
	{
		SetTerrColor(c);
	}
	else
	{
		SetSFColor(c);
	}
}

simulated function SetOppTeamColor(Canvas c, PlayerReplicationInfo PRI)
{
	if (PRI.Team != None && PRI.Team.TeamIndex == 0)
	{
		SetTerrColor(c);
	}
	else
	{
		SetSFColor(c);
	}
}

simulated function SetHUDColor(canvas c)
{
	SetSFColor(c);
}

// kkm: helper to get the correct safe frame offsets for split screen
function GetSafeFrame(Canvas c, bool right, bool bottom, out float x, out float y)
{
	if (right)
	{
		x = c.SafeFrame.Right;
	}
	else
	{
		x = c.SafeFrame.Left;
	}
	
	if (bottom)
	{
		y = c.SafeFrame.Bottom;
	}
	else
	{
		y = c.SafeFrame.Top;
	}
}

function SetHeightOffset(float newVal)
{
	newVal -= 0.5f;

	BasePosAdjust = int(newVal * 50);
	
	// text must move at pixel boundaries only
	BasePos = RealBasePos + BasePosAdjust;
	log(newVal);
}

function SetWidthOffset(float newVal)
{
	newVal -= 0.5f;
	
	// text must move at pixel boundaries only
	WidthAdjust = int(newVal * 60);
	log(newVal);
}

function SetOpacity(float newVal)
{	
	OpacityAdjust = newVal;
}

function SetNewTime(float TimeLeft)
{
	CountdownTimerTime = TimeLeft;
}

function ShowTimerDisplay(bool newState)
{
	CountdownTimerIsOn = newState;
}

function DrawCountdownTimer(Canvas c)
{
	local string time;
	local int min;
	local int sec;
	local int miliSec;
	
	min = CountdownTimerTime/60;
	
	sec = CountdownTimerTime-(min*60);
	
	miliSec = CountdownTimerTime;
	miliSec = (CountdownTimerTime*100) - (miliSec*100);
	
	time = ""$min$":";
	
	if (sec < 10)
	{
		time = time $ "0";
	}
	
	time = time $ sec $".";

	if (miliSec < 10)
	{
		time = time $ "0";
	}
	
	time = time $ miliSec;

	
	c.SetDrawColor(117,149,67);	
	class'ZombieFontDescriptor'.static.SetHUDFont(c, 27*1.5);
	
//	DrawTextJustify(c, time, 590, 50, JUST_Right, false);
	c.DrawText2(time, c.SafeFrame.Right-100, c.SafeFrame.Bottom-50, 100,,JH_RIGHT);
	
	class'ZombieFontDescriptor'.static.ResetFont(c);
}

simulated event Destroyed()
{
	ZMLDevice.HUDOwner = none;
//	ZMLDevice = none;
}

event InitHUD(optional String changeTo)
{
	ForceLoadScreen=false;
	LoadDone=true;
}

function ClearZMessage(out ZHUDLocalizedMessage M)
{
	M.Message = None;
	M.Switch = 0;
	M.RelatedPRI = None;
	M.OptionalObject = None;
	M.EndOfLife = 0;
	M.StringMessage = "";
	M.DrawColor = class'Canvas'.Static.MakeColor(255,255,255);
	M.XL = 0;
	M.bDrawing = false;
}

function DrawZMessage(Canvas c, ZHUDLocalizedMessage M, optional float yAdjust)
{
	local float yPos;
	local float xSafe;
	local float ySafe;
	local ETextJustify zmlJust;
	
	c.Font = M.StringFont;
	if( PlayerOwner.IsSharingScreen() )
	{
		c.TextWidth = 0;
		c.TextHeight = 1.5*M.TextSize;
	}
	else
	{
		c.TextWidth = 0;
		c.TextHeight = M.TextSize;
	}

	c.Style = ERenderStyle.STY_Normal;
	c.SpaceX = M.Kern;
	
	GetSafeFrame( c, false, false, xSafe, ySafe );
	 
	if (class<ZombieMessage>(M.Message).default.UseBasePos)
	{
		yPos = RealBasePos - M.Message.default.YPos + yAdjust;
//		log("YPos: " $ yPos @ basePos @ M.Message.default.YPos @ yAdjust);
	}
	else
	{
		yPos = M.Message.default.YPos + yAdjust;
//		log("YPos2: " $ yPos @ M.Message.default.YPos @ yAdjust);
	}
	
	// make absolutely sure we don't go out of safe frame on split screen
	if( yPos < ySafe )
		yPos = ySafe;
	
	c.bCenter = class<ZombieMessage>(M.Message).default.bCenter;
	
	if (!class<ZombieMessage>(M.Message).default.bHasMarkup)
	{
		c.DrawText2(M.StringMessage,
			class<ZombieMessage>(M.Message).default.XReset,
			yPos,
			class<ZombieMessage>(M.Message).default.XWrap-class<ZombieMessage>(M.Message).default.XReset,
			0,
			class<ZombieMessage>(M.Message).default.HJust);
	}
	else
	{
		zmlJust = JUST_Left;
		
		if (class<ZombieMessage>(M.Message).default.HJust == JH_Center)
		{
			zmlJust = JUST_Center;
		}
		else if (class<ZombieMessage>(M.Message).default.HJust == JH_Right)
		{
			zmlJust = JUST_Right;
		}
		
		ZMLDevice.RenderMarkupString(M.StringMessage, 
								c,
								M.Message.default.XPos,
								yPos,
								zmlJust,
								class<ZombieMessage>(M.Message).default.XWrap);
	}

	class'ZombieFontDescriptor'.static.ResetFont(c);
	c.bCenter = false;
}

simulated function SetScopeMode(bool inScope, optional bool isSniper)
{
	InScopeMode	= inScope;
	
	if (InScopeMode)
	{
		IsSniperScope = isSniper;
		if (IsSniperScope)
		{
			CurCHIndex = 6;
		}
	}
	else
	{
		IsSniperScope = false;
	}
}

simulated function HideHUD(optional bool force)
{
	bHideHUD = true;

	if (force)
	{
		ForceHideHud = true;
	}
}

simulated function ShowHUD(optional bool force)
{
	bHideHUD = false;

	if (force)
	{
		ForceHideHud = false;
	}
}

simulated function SetCHIndex(int ch, int WeapIdx)
{
	CurCHIndex = ch;
	
	//DEMO_HACK
	CurWeapIndex = WeapIdx;

	if( PawnOwner != None && PawnOwner.Weapon != None )
	{
		if( ABSTRACT_WeapGrenade(PawnOwner.Weapon) != None )
		{
			bGrenadingNow = true;
			if( PawnOwner.Weapon.IsA('WeapStunGrenade') )
				bGrenadingFlashbang = true;
		}
		else
			bGrenadingNow = false;

		// Find the max distance at which to allow the reticle to turn red
		MaxRedReticleDist = ZombieWeapon(PawnOwner.Weapon).GetRedReticleRange();
	}
}

simulated function GotAmmo( ZombieWeapon weap )
{
	local int i;

	if( weap == none )
		return;
	
	//
	AmmoPulseTime[0] = 0;
	AmmoPulseIcon[0] = weap.WeaponIconIndex;
	
	return;
	//
	
	// ammo for the current weapon--easy case
	if( CurWeapIndex == weap.WeaponIconIndex )
		AmmoPulseTime[0] = 0;
	else
	{
		log("cur: "$CurWeapIndex$", yar: "$weap.WeaponIconIndex);
		// find a slot
		for( i = 1; i < 5; ++i )
		{
			if( AmmoPulseTime[i] > PULSE_TIME ||
				( AmmoPulseTime[i] <= PULSE_TIME &&
				  AmmoPulseIcon[i] == weap.WeaponIconIndex ) )
			{
				AmmoPulseTime[i] = 0;
				AmmoPulseIcon[i] = weap.WeaponIconIndex;
				break;
			}
		}
	}
}

simulated function GotHealth( string InStr )
{
	HealthPulseTime = 0;
}

function OwnerHit(vector momentum)
{
	local vector hitDir;
	local vector lookDir;
	local vector crossProd;
	local float hitAngle;
	local int hitSector;
	
	hitDir = -1*momentum;

	lookDir = (vector(PawnOwner.GetViewRotation()));
	
	hitDir.Z = 0;
	lookDir.Z = 0;
	
	hitDir = normal(hitDir);
	lookDir = normal(lookDir);
	
	crossProd = hitDir cross lookDir;
	
	hitAngle = acos(hitDir dot lookDir);
	
	if (crossProd.Z < 0)
	{
//		hitAngle += PI;
		hitAngle = (PI*2)-hitAngle;
	}

	hitSector = hitAngle/(PI/4);
	
	Clamp( hitSector, 0, 7 );

//	log("OwnerHit: " $ hitAngle @ crossProd.Z @ hitSector);

	HitIndicatorTime = Level.TimeSeconds;
	HitSectorTime[hitSector] = Level.TimeSeconds;
}

simulated function PostBeginPlay()
{
//	FaceAreaOffset = -64;
//	MyFont = FontInfo(spawn(Class<Actor>(DynamicLoadObject(FontInfoClass, class'Class'))));
	Super.PostBeginPlay();
	SetTimer(1.0, True);
	PlayerOwner = PlayerController(Owner);

	if (ZMLDevice == None)
	{
		ZMLDevice = new class'ZombieGame.ZMLRender';
		ZMLDevice.HUDOwner = self;
//		log("ZML Owner: " $ ZMLDevice.Outer);
	}

//	if (IconMgr == None)
//	{
//		IconMgr = new class'ZombieGame.HUDIconMgr';
//	}

//	if ( (PlayerOwner.GameReplicationInfo != None)
//		&& (PlayerOwner.GameReplicationInfo.RemainingTime > 0) )
//		TimeMessageClass = class<CriticalEventPlus>(DynamicLoadObject("ZombieGame.TimeMessage", class'Class'));
}

simulated function HUDSetup(canvas canvas)
{
	super.HUDSetup(canvas);
	
	OldClipX = Canvas.ClipX;

	CurrentDeltaTime = Level.TimeSeconds - LastTime;
	LastTime = Level.TimeSeconds;
	
	if (PlayerOwner.ViewTarget == PlayerOwner)
	{
		PawnOwner = PlayerOwner.Pawn;
	}
	else if (PlayerOwner.ViewTarget.IsA('Pawn') && Pawn(PlayerOwner.ViewTarget).Controller != None)
	{	
		PawnOwner = Pawn(PlayerOwner.ViewTarget);
	}
	else if ( PlayerOwner.Pawn != None )
	{
		PawnOwner = PlayerOwner.Pawn;
	}
	else
	{
		PawnOwner = None;
	}
	
	if ( (PawnOwner != None) && (PawnOwner.Controller != None) )
		ViewedInfo = PawnOwner.PlayerReplicationInfo;
	else
		ViewedInfo = PlayerOwner.PlayerReplicationInfo;

	// Setup the way we want to draw all HUD elements
	Canvas.Reset();
	Canvas.SpaceX=0;
	Canvas.bNoSmooth = True;

	Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor = WhiteColor;
	Canvas.Style = Style;
//	Scale = Canvas.ClipX/640.0;
	Scale = Canvas.ClipX / 1024.0;
	class'ZombieFontDescriptor'.static.SetHUDFont(Canvas, 20);	
}

function SetHealthWatch(pawn p, string WatchName)
{
	HealthWatchPawn = p;
	HealthWatchName = watchName;
}

simulated function bool IsMP()
{
	return ((Level.Game == none) || ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer') );
}

simulated event DrawCrosshair(Canvas Canvas)
{
	local actor aimAct;
	local ZombiePawn zAimPawn;
	local int targetHealthYCoord;
	local Color oldCanvasColor;
	local int FogDist;
	local SearchableActor temp; //brett
	targetHealthYCoord=240+30;
	aimAct = SFRMPlayerController(Owner).AimAct;
	AimPerturb = 1;

	bDecelerateAiming=false;

	Canvas.DrawColor = AmberColor;
	//SetHUDColor(canvas);
	Canvas.DrawColor.A = CHAlpha;

	Canvas.Style = ERenderStyle.STY_Normal;

	zAimPawn = ZombiePawn(aimAct);
	temp = SearchableActor(aimAct);
	
	
	//if we're not aiming at a zombiepawn (and it's not a projectile), maybe it's owner is a zombie pawn
	if (zAimPawn == None && aimAct != None && aimAct.Owner != None && aimAct.Owner.IsA('ZombiePawn')
	 && Projectile(AimAct)==None )
	{
		aimAct = aimAct.Owner;
		zAimPawn = ZombiePawn(aimAct);
	}

	//Draw a no-shoot icon if necessary.
	if( ShouldDrawNoShoot(zAimPawn) )
	{
		DrawNoShoot(Canvas, zAimPawn);
		Canvas.DrawColor = oldCanvasColor;

		return;  // It it was necessary, then don't do the rest of this function.
	}

	// Ensure MaxRedReticleDist is valid
	if( MaxRedReticleDist == 0 && PawnOwner != None && PawnOwner.Weapon != None )
		MaxRedReticleDist = ZombieWeapon(PawnOwner.Weapon).GetRedReticleRange();

	if( PawnOwner != None && PawnOwner.Controller != None )
		FogDist = PlayerController(PawnOwner.Controller).LastDistanceFogEnd;
	else
		FogDist = 65535;

	//check all the various factors to see if we should color the reticle red.
	//  some of the things checked:
	//  -Is the PawnOwner not aiming at itself?
	//  -Are we aiming at a pawn?  
	//  -Is the pawn alive?
	//  -Should pawn being aimed at cause the reticle to highlight?
	//  -Is this multiplayer, or is the difficultly level less than "very hard"?
	//  -Is	the pawn being aimed at in range of the player's current weapon
	//   or at farthest distance one can see (whichever is less) ?
	//  -Is this not a sniper rifle?
	if ( aimAct != PawnOwner && zAimPawn!=none && zAimPawn.Health > 0 && 
		zAimPawn.bReticuleHighlight && (IsMP() || Level.Game.GameDifficulty < 3) 
		&& (PawnOwner != None && ZombieWeapon(PawnOwner.Weapon) != None 
		      && VSize(zAimPawn.Location - PawnOwner.Location) < FMin(MaxRedReticleDist,FogDist) )
			  && CurCHIndex != 6 )
	{
		Canvas.SetDrawColor(255,0,0, CHAlpha);
		if (zAimPawn.bEasyAiming)
			bDecelerateAiming=true;
	}

	//wrc stupid quick hack because vehicles don't have a faction and we're near GM.
	if (aimAct!=None && aimAct.IsA('SFRMVehiclePawn') && SFRMVehiclePawn(aimAct).bAlwaysTurnPlayerReticuleRed)
	{
		Canvas.SetDrawColor(255,0,0, CHAlpha);
		if (SFRMVehiclePawn(aimAct).bEasyAiming)
			bDecelerateAiming=true;
	}

	if (CurCHIndex != -1 && !bDrawingSpecial)
	{
		if (overrideCHClass == none )
		{
			//log("BDrawingSpecial = "$bdrawingSpecial);
			//log("just drew because overrideCHClass == none");
			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, CurCHIndex, Canvas.LogSizeX/2, Canvas.LogSizeY/2);
		}
		else 
		{
			//log("just drew it anyways");
			overrideCHClass.static.DrawCrosshair(canvas, self);
		}
	}

	//currently only the helicopter shows healthboxes, but we can extend it to any zombie pawn just by flipping the switch
	if (Pawn(aimAct)!=None && Pawn(aimAct).bDrawHealthBarInHUDWhenTargeted)
	{
		DrawTargetHealthCentered(Canvas,Pawn(aimAct),320,targetHealthYCoord);
	}

	Canvas.DrawColor = oldCanvasColor;
	
}
simulated event DrawAmmoIcon(Canvas Canvas)
{
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, 89, (Canvas.LogSizeX/2), 240);
}

simulated event bool ShouldDrawNoShoot(ZombiePawn zAimPawn)
{
//	if(zAimPawn != None )
//	{
//		Log("BH.SDNS  <factions same:"$ (zAimPawn.GetFaction() == ZombiePawn(PawnOwner).GetFaction())
//			$" || civ:"$ (zAimPawn.GetFaction() == FACTION_Civilian) $">"); 
//	}
	if( zAimPawn != None
	 && (zAimPawn.GetFaction() == ZombiePawn(PawnOwner).GetFaction() || zAimPawn.GetFaction() == FACTION_Civilian) )
	{
		 return true;
	}
	else
	{
		return false;
	}
}

simulated event DrawNoShoot(Canvas Canvas, ZombiePawn zAimPawn)
{
	Canvas.DrawColor = AmberColor;
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(canvas, HIM_CH_NO_SHOOT, (Canvas.LogSizeX/2), 240);

	if( zAimPawn.TargetedName != 'None' )
	{
		Canvas.SetDrawColor(255,255,255,200);
		class'ZombieFontDescriptor'.static.SetHUDFont(Canvas, 12*1.5);
		DrawTextJustify(Canvas, zAimPawn.TargetedName, Canvas.LogSizeX/2, 240 + 30, JUST_Center, true);
		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}
}


simulated function SetSectorColor(Canvas C, byte normalAlpha, byte hitAlpha)
{
	if (hitAlpha > 0)
	{
		c.DrawColor.R = 255;
		c.DrawColor.G = 0;
		c.DrawColor.B = 0;
		c.DrawColor.A = hitAlpha*OpacityAdjust;
		return;
	}
	
	c.DrawColor = AmberColor;
	c.DrawColor.A = normalAlpha*OpacityAdjust;
}

simulated function DrawHitSector(Canvas c, int sectorNum)
{
	if (sectorNum == 0)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_HIT_V, (c.LogSizeX/2) - 24, (c.LogSizeY/2)-35);
	}
	else if (sectorNum == 1)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_HIT_H, (c.LogSizeX/2) - 36, (c.LogSizeY/2)-23);
	}
	else if (sectorNum == 2)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_HIT_H, (c.LogSizeX/2) - 36, (c.LogSizeY/2) + 23 - 28, false, true);
	}
	else if (sectorNum == 3)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_HIT_V, (c.LogSizeX/2) - 24, (c.LogSizeY/2) + 35 - 13, false, true);
	}
	else if (sectorNum == 4)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_HIT_V, (c.LogSizeX/2) + 24 - 28, (c.LogSizeY/2) + 35 - 13, true, true);
	}
	else if (sectorNum == 5)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_HIT_H, (c.LogSizeX/2) + 36 - 13, (c.LogSizeY/2) + 23 - 28, true, true);
	}
	else if (sectorNum == 6)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_HIT_H, (c.LogSizeX/2) + 36 - 13, (c.LogSizeY/2) - 23, true, false);
	}
	else if (sectorNum == 7)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_HIT_V, (c.LogSizeX/2) + 24 - 28, (c.LogSizeY/2) - 35, true, false);
	}
}

simulated function DrawHitIndicator(Canvas c)
{	
	local int sectorNum;
	local byte ringAlpha;
	c.Style = ERenderStyle.STY_Normal;

	ringAlpha = int(128 * (1-(Level.TimeSeconds-HitIndicatorTime)/HIT_INDICATOR_TIMEOUT));

	for (sectorNum = 0; sectorNum<8; ++sectorNum)
	{
	//	SetSectorColor(c, ringAlpha, 0);
	//	DrawHitSector(c, sectorNum);
		
		if ((Level.TimeSeconds-HitSectorTime[SectorNum]) < HIT_INDICATOR_TIMEOUT)
		{
			SetSectorColor(c, 0, int(255 * (1-(Level.TimeSeconds-HitSectorTime[SectorNum])/HIT_INDICATOR_TIMEOUT)));
			DrawHitSector(c, sectorNum);
		}
	}
}

simulated function DrawBackground(Canvas c)
{
}

simulated function DrawAmmo(Canvas c)
{
	local float BaseX;
	local float BaseY;
	local int ReloadCount;
	local int NumStrips;
	local int TailAmmo;
	local int NumStripsLeft;
	
	local int BulletsPerTex;
	local int BulletsPerStrip;
	local float StripOffsetX;
	local float StripOffsetY;
	local float StripAlpha;
	local float StripDarken;
	local byte StripIdx;
	local byte WeaponIdx;
	
	local ZombieWeapon zWeapon;

	local float oldScale;
	local float oldScaleY;

	BaseX = c.SafeFrame.Right+WidthAdjust;
	BaseY = c.SafeFrame.Top-BasePosAdjust;
	
	SetHUDColor(c);
	c.DrawColor.A = 255*OpacityAdjust;

	c.Style = ERenderStyle.STY_Normal;
	
	// no point of doing anything if threre is no weapon or ammo
	
	if	(PawnOwner.Weapon==none)
	{
		return;
	}
	
	zWeapon = ZombieWeapon(PawnOwner.Weapon);
	
	if (zWeapon == none)
	{
		return;
	}

	//
	oldScaleY = c.ScaleY;
	oldScale = c.Scale;
	
	c.Scale = oldScale*0.75;
	c.ScaleY = oldScaleY*0.75;
	
	BaseX = c.SafeFrame.Right*(oldScale/c.Scale);
	BaseY = c.SafeFrame.Top*(oldScale/c.Scale);
	//

	WeaponIdx=zWeapon.hudProps.WeaponIconIdx;
	StripIdx=zWeapon.hudProps.AmmoIconIdx;
	BulletsPerTex=zWeapon.hudProps.ItemsPerTex;
	
	BulletsPerStrip=30;
	StripOffsetX=5;
	StripOffsetY=3;
	StripAlpha=0.9;
	StripDarken=0.9;

	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, WeaponIdx, BaseX-96, BaseY, 96, 24);

	if	(	(PawnOwner.Weapon.AmmoType==none) || 
			( (SFRMAmmunition(PawnOwner.Weapon.AmmoType)!=none) && (SFRMAmmunition(PawnOwner.Weapon.AmmoType).bHideAmmoCount) )
		)
	{	
		//
		c.Scale = oldScale;
		c.ScaleY = oldScaleY;
		//
	
		return;
	}


	class'ZombieFontDescriptor'.static.SetHUDFont(c, 22);

	c.DrawText2(PawnOwner.Weapon.GetAmmoAmount(), BaseX-100, BaseY+29, 50,,JH_RIGHT);

	class'ZombieFontDescriptor'.static.SetHUDFont(c, 16);

	c.DrawText2("X", BaseX-44, BaseY+29,,,JH_LEFT);
		
	class'ZombieFontDescriptor'.static.ResetFont(c);
	
	ReloadCount = PawnOwner.Weapon.GetReloadCount();
	
	NumStrips = ReloadCount/BulletsPerStrip;
	TailAmmo = ReloadCount-(BulletsPerStrip*NumStrips);

	++NumStrips;

	NumStripsLeft = NumStrips;
	
	while(NumStripsLeft > 0)
	{
		SetHUDColor(c);
		
		if (NumStripsLeft > 1)
		{
			c.DrawColor.A = (255*OpacityAdjust)*(StripAlpha**(NumStripsLeft-1));
			c.DrawColor.R = (c.DrawColor.R)*(StripDarken**(NumStripsLeft-1));
			c.DrawColor.G = (c.DrawColor.G)*(StripDarken**(NumStripsLeft-1));
			c.DrawColor.B = (c.DrawColor.B)*(StripDarken**(NumStripsLeft-1));
		}
		else
		{
			c.DrawColor.A = (255*OpacityAdjust);
		}
	
		if (NumStrips == NumStripsLeft)
		{
			//for the first strip, we need to draw the tail...
			class'ZombieGame.HUDIconMgr'.static.DrawImageTile(c, StripIdx, 
					//BaseX-20-(StripOffsetX*NumStripsLeft), 
					BaseX-28+(StripOffsetX*NumStripsLeft), 
					BaseY+29+(StripOffsetY*NumStripsLeft), 
					1, (float(TailAmmo)/BulletsPerTex));
		}
		else
		{
			//draw a whole strip...
			class'ZombieGame.HUDIconMgr'.static.DrawImageTile(c, StripIdx, 
					//BaseX-20-(StripOffsetX*NumStripsLeft), 
					BaseX-28+(StripOffsetX*NumStripsLeft), 
					BaseY+29+(StripOffsetY*NumStripsLeft), 
					1, (float(BulletsPerStrip)/BulletsPerTex));
		}
	
		--NumStripsLeft;
	}
	
	//
	c.Scale = oldScale;
	c.ScaleY = oldScaleY;
	//
}

simulated function DrawHealthWatch(Canvas c)
{
	c.DrawColor=AmberColor;
	
	class'ZombieFontDescriptor'.static.SetHUDFont(c, 20);
	DrawTextJustify(c, HealthWatchName, 35, basePos-148, JUST_Left, false);
	
	DrawBox(c, 35, basePos-128, HealthWatchPawn.Health*0.85f, 10);
	
	c.DrawColor.A = 128;
	
	DrawBox(c, 35, basePos-128, 85, 10);
}

native simulated function DrawTargetHealthCentered(Canvas c, Pawn zTarget,float x,float y);

simulated function DrawHealth(Canvas c)
{
	local float baseX;
	local float baseY;
	local bool isCrouched;
	local byte GuyIdx;
	//local float healthWeight;
	//local float pulse;
	local float oldScaleY, oldScale;
	local float maxHealth;
	
	BaseX = c.SafeFrame.Left-WidthAdjust;
	BaseY = c.SafeFrame.Top-BasePosAdjust;

	SetHUDColor(c);
	c.DrawColor.A = 255*OpacityAdjust;

	c.Style = ERenderStyle.STY_Normal;
	
	//
	oldScaleY = c.ScaleY;
	oldScale = c.Scale;
	
	c.Scale = oldScale*0.75;
	c.ScaleY = oldScaleY*0.75;
	
	BaseX = c.SafeFrame.Left*(oldScale/c.Scale);
	BaseY = c.SafeFrame.Top*(oldScale/c.Scale);
	//
	
	// If PawnOwner is a crew served weapon pawn, use its controller pawn's health
	// Otherwise, can use PawnOwner's health directly
	CurHealth = PawnOwner.Health;
	isCrouched = PawnOwner.bIsCrouched;

	if (!isCrouched)
	{
		GuyIdx = HIM_HEALTH_STAND;
	}
	else
	{
		GuyIdx = HIM_HEALTH_CROUCH;
	}
	
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, GuyIdx, BaseX, BaseY);

	class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_HEALTH_CROSS, BaseX+50, BaseY+6);
	
	//alpha bkg
	c.DrawColor.R = c.DrawColor.R*0.5f;
	c.DrawColor.G = c.DrawColor.G*0.5f;
	c.DrawColor.B = c.DrawColor.B*0.5f;
	c.DrawColor.A = 255*OpacityAdjust*0.4f;
	
	maxHealth = 100;
	if ((PlayerOwner.PlayerReplicationInfo != none) && (PlayerOwner.PlayerReplicationInfo.ClassIdx == 6))
	{
		maxHealth = 150;
	}
	
	DrawBox(c, BaseX+50+20, BaseY+7, 80*(MaxHealth/100.0), 12);
	
	SetHUDColor(c);
	c.DrawColor.A = 255*OpacityAdjust;
	
	//curHealth
	DrawBox(c, BaseX+50+20, BaseY+7, 80*(CurHealth/100.0), 12);
	
	//outline
	DrawOpenBox(c, BaseX+50+20, BaseY+7, 80*(MaxHealth/100.0), 12, 2/c.Scale);
	
	//
	c.Scale = oldScale;
	c.ScaleY = oldScaleY;
	//
	
	//Draw Text
//	class'ZombieFontDescriptor'.static.SetHUDFont(c, 24);
//
//	DrawTextJustify(c, TweakValX $ ", " $ TweakValY $ ", " $ TweakValZ, 320, 200, JUST_Center, false);
//
//	class'ZombieFontDescriptor'.static.ResetFont(c);
}

exec function HUDTweakUp()
{
	TweakValY -= 2;
}

exec function HUDTweakDown()
{
	TweakValY += 2;
}

exec function HUDTweakLeft()
{
	TweakValX -= 5.0;
}

exec function HUDTweakRight()
{
	TweakValX += 5.0;
}

exec function HUDTweakZUp()
{
	TweakValZ += 0.05;
}

exec function HUDTweakZDown()
{
	TweakValZ -= 0.05;
}

exec function AmberR(int val)
{
	AmberColor.R = val;
}

exec function AmberG(int val)
{
	AmberColor.G = val;
}

exec function AmberB(int val)
{
	AmberColor.B = val;
}

exec function TitleSafe()
{
	ShouldDrawTitleSafe = !ShouldDrawTitleSafe;
}

simulated function DrawTitleSafe(Canvas c)
{
	c.SetDrawColor(255,0,0,75);
	
	DrawBox(c, 0, 0, 48, 480);
	DrawBox(c, 640-0, 0, -48, 480);
	DrawBox(c, 48, 0, 544, 36);
	DrawBox(c, 48, 480-0, 544, -36);
}

simulated function DrawGameSynopsis(Canvas Canvas);

exec function testHUD(int t)
{
	HUDTest = t;
}

function DrawSpectatingHud (Canvas C)
{
	if (!PlayerOwner.IsInState('Spectating'))
	{
		//log("Not drawing spectating hud, state is: " $ PlayerOwner.GetStateName());
		return;
	}	
	
	HUDSetup(C);
	
	if (PlayerOwner.IsSharingScreen())
	{
		class'ZombieFontDescriptor'.static.SetRadarFont(C, 32);
	}
	else
	{
		class'ZombieFontDescriptor'.static.SetRadarFont(C, 20);
	}
	c.SpaceX = -2;
	c.SetDrawColor(255,255,255, 255*OpacityAdjust);
	
//	log("SpectatingHUD: " $ PlayerOwner @ PlayerOwner.ViewTarget @ Pawn(PlayerOwner.ViewTarget) @ Pawn(PlayerOwner.ViewTarget).Controller @ (Pawn(PlayerOwner.ViewTarget).Controller.PlayerReplicationInfo == none));
	
	if ((PlayerOwner == none) || (PlayerOwner.ViewTarget == PlayerOwner) || 
		(PlayerOwner.ViewTarget == none) || (Pawn(PlayerOwner.ViewTarget) == none))
	{
		DrawTextJustify(c, SpectatingSelfText, 130, 90, JUST_Left);
		DrawTextJustify(c, SpectatorSwitchText, 120, 145, JUST_Left,,c.ClipX/c.ScaleY,120);
	}
	else if (ClassIsChildOf(PlayerOwner.ViewTarget.class, class'Engine.Pawn'))
	{
		c.SetDropShadow( true );
		c.TextWidth = 0;

		c.DrawText2( SpectatingText $ Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo.PlayerName, 120, 90 );
		c.DrawText2( SpectatorSwitchText, 120, 145 );
	}	
}

simulated function DrawWaitMessage( Canvas C )
{
	local GameReplicationInfo GRI;
	local string waitMsg, delayMsg;
	local array<string> args;

    C.TextWidth = 0;
	C.TextHeight = 30;
	C.ForceAlpha = 1;
	C.SetDrawColor( 255,255,255 );
	C.Font = MedFont;

	GRI = PlayerController(Owner).GameReplicationInfo;
	if( GRI.bMatchPending )
	{
		if( GRI.bStartedCountDown )
		{
			if( !GRI.bMatchHasBegun )
			{
				waitMsg = class'Strings'.default.GameWillBegin;//"Game will begin in" @ GRI.CountDown;
			}
			else
			{
				waitMsg = class'Strings'.default.GameWillResume;//"Game will resume in" @ GRI.CountDown;
			}

		}
		else
		{
			waitMsg = class'Strings'.default.WaitingForPlayers;//"WAITING FOR PLAYERS";
		}

		if( Level.NetMode == NM_ListenServer )
		{
			args[0] = PlayerOwner.ConsoleCommand( "BINDINGTOKEY DelayCountdown" );
			args[0] = PlayerOwner.ConsoleCommand( "KEYNUMBER" @ args[0] );
			args[0] = PlayerOwner.ConsoleCommand( "LOCALIZEDKEYNAME" @ args[0] );
			if( GRI.bStartedCountdown )
			{
				delayMsg = Localize( "Strings", "DelayCountdown", "Core" );
			}
			else if( SFRMMultiplayer(Level.Game).bReadyToStart && SFRMMultiplayer(Level.Game).bDelayCountdown )
			{
				delayMsg = Localize( "Strings", "CountdownDelayed", "Core" );
			}
			delayMsg = Format( delayMsg, args );
			waitMsg = waitMsg $ Chr(10) $ delayMsg;
		}

		args[0] = string(GRI.CountDown);
		C.DrawText2(
			self.Format( waitMsg, args ),
			C.SafeFrame.Left, C.SafeFrame.Top,
			C.SafeFrame.Right-C.SafeFrame.Left, (C.SafeFrame.Bottom-C.SafeFrame.Top)/2,
			JH_CENTER, JV_CENTER );
	}
}

simulated function DrawHUD( canvas Canvas )
{
	local float XL, YL, FadeValue; //XPos, YPos,
	//local string Message;
	local int  i, j, k; //FaceNum, M, XOverflow,
	local float OldOriginX;
//	local float ObjDescWidth, ObjDescHeight;
	local float ObjectiveAlpha;
	local array<String> ParsedStrings;
	local float Alpha;
	local float ObjectivesOffset;
	local float fontScale;

	DrawWaitMessage( Canvas );

	HUDSetup(canvas);

	if ( ForceHideHUD || bHideHUD || (ViewedInfo == None) || loading)
		return;

	if( PlayerOwner.IsSharingScreen() )
		fontScale = 1.3;
	else
		fontScale = 1;

	OldOriginX = Canvas.OrgX;
	// Master message short queue control loop.
//	FaceNum = -1;
	Canvas.DrawColor = WhiteColor;
	Canvas.SetClip(OldClipX, Canvas.ClipY);
	
	//
	if ( !ViewedInfo.bIsSpectator )
	{
		Canvas.Style = Style;

		// Let the Weapon draw it's info
		if ( PawnOwner != None )
		{
			if (!InScopeMode)
			{
				DrawComponents(Canvas);
			}
			else
			{
				DrawScopeComponents(Canvas);
			}

			if ((Level.TimeSeconds-HitIndicatorTime) < HIT_INDICATOR_TIMEOUT)
			{
				DrawHitIndicator(Canvas);
			}

//			OwnerHit(vect(1, 0, 0));
//			DrawHitIndicator(Canvas);

//			
			if(shouldDrawTitleSafe)
			{
				DrawTitleSafe(Canvas);
			}
//			
		}
	}
	//
		
//	else if ( !bHideCenterMessages )
//	{
		// Master localized message control loop.
		for (i=0; i<10; i++)
		{
			if (LocalMessages[i].Message != None)
			{
				if ( LocalMessages[i].Message.Default.bFadeMessage )
				{
					Canvas.Style = ERenderStyle.STY_Translucent;
					FadeValue = (LocalMessages[i].EndOfLife - Level.TimeSeconds);
					if ( FadeValue > 0.0 ) 
					{
						Canvas.Font = LocalMessages[i].StringFont;
//						Canvas.DrawColor = LocalMessages[i].DrawColor * (FadeValue/LocalMessages[i].LifeTime);
						Canvas.DrawColor = LocalMessages[i].DrawColor;
						Canvas.DrawColor.A = (FadeValue/LocalMessages[i].LifeTime)*255;
						Canvas.StrLen(LocalMessages[i].StringMessage, XL, YL);
						LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, YL, Canvas.ClipY);
						if ( (WeaponFadeTime < Level.TimeSeconds) || (LocalMessages[i].YPos != Canvas.ClipY - YL - (64.0/768)*Canvas.ClipY) )
						{
							Canvas.SetPos( 0.5 * (Canvas.ClipX - XL), LocalMessages[i].YPos );
							Canvas.DrawText( LocalMessages[i].StringMessage, False );
						}
						else
							LocalMessages[i].EndOfLife = Level.TimeSeconds;
					}
				} 
				else 
				{
					Canvas.Font = LocalMessages[i].StringFont;
					Canvas.Style = ERenderStyle.STY_Normal;
					Canvas.DrawColor = LocalMessages[i].DrawColor;
					Canvas.StrLen(LocalMessages[i].StringMessage, XL, YL);
					LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, YL, Canvas.ClipY);
					Canvas.SetPos( 0.5 * (Canvas.ClipX - XL), LocalMessages[i].YPos );
					Canvas.DrawText( LocalMessages[i].StringMessage, False );
				}
			}
		}

	j=0; k=0;
	//note that i-1%X == i+x-1%x, except that that latter will preserve sign
	for (i=CurPickupMsg; j<NUM_PICKUP_MSGS; i=(i+NUM_PICKUP_MSGS-1)%NUM_PICKUP_MSGS)
	{
		if (PickupMessages[i].Message != None)
		{
			Canvas.SetDrawColor(0,91,143); //= PickupMessages[i].DrawColor;
			Canvas.SetDropShadow(true);
			if ( PickupMessages[i].Message.Default.bFadeMessage )
			{
				//Canvas.Style = ERenderStyle.STY_Translucent;
				FadeValue = (PickupMessages[i].EndOfLife - Level.TimeSeconds);
				if ( FadeValue > 0.0 ) 
				{
					FadeValue = (FadeValue/PickupMessages[i].LifeTime)*255;
					Canvas.DrawColor.A = FadeValue;
					DrawZMessage(Canvas, PickupMessages[i], (k*1.1*PickupMessages[i].TextSize));
					k++;
//					k--;
				}

			} 
			else 
			{
				Canvas.Style = ERenderStyle.STY_Normal;
				DrawZMessage(Canvas, PickupMessages[i], (k*1.1*PickupMessages[i].TextSize));
				k++;
//				k--;
			}
		}

		j++;
		Canvas.SetDropShadow(false);
	}

	j=0; k=0;
	//note that i-1%X == i+x-1%x, except that that latter will preserve sign
	for (i=CurGameMsg; j<NUM_GAME_MSGS; i=(i+NUM_GAME_MSGS-1)%NUM_GAME_MSGS)
	{
		if (GameMessages[i].Message != None)
		{
			Canvas.DrawColor = GameMessages[i].DrawColor;
			Canvas.SetDropShadow(true);
			if ( GameMessages[i].Message.Default.bFadeMessage )
			{
				Canvas.Style = ERenderStyle.STY_Translucent;
				FadeValue = (GameMessages[i].EndOfLife - Level.TimeSeconds);
				if ( FadeValue > 0.0 ) 
				{
					FadeValue = (FadeValue/GameMessages[i].LifeTime)*255;
					Canvas.DrawColor.A = FadeValue;
					DrawZMessage(Canvas, GameMessages[i], (k*1.1*GameMessages[i].TextSize));
					//k++;
					k--;
				}
			} 
			else 
			{
				Canvas.Style = ERenderStyle.STY_Normal;
				DrawZMessage(Canvas, GameMessages[i], (k*1.1*GameMessages[i].TextSize));
				//k++;
				k--;
			}
		}

		j++;
		Canvas.SetDropShadow(false);
	}

	if (WeaponMessage.Message != None)
	{
//		c.SetDrawColor(255, 255, 255, 40);
//		DrawMsgHighlight(Canvas, 320, 202, 309, 40);
		Canvas.SetDrawColor(255,255,255);
		DrawZMessage(Canvas, WeaponMessage);
	}

	if (TempGuideMessage.Message != None)
	{
		Canvas.Font = TempGuideMessage.StringFont;
		Canvas.TextWidth = 0;
		Canvas.TextHeight = TempGuideMessage.TextSize*Canvas.ScaleY;
		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SpaceX = TempGuideMessage.Kern*Canvas.ScaleY;
		Canvas.bCenter = class<ZombieMessage>(TempGuideMessage.Message).default.bCenter;

		//Canvas.WrapStringToArray(TempGuideMessage.StringMessage,ParsedStrings,class'ZombieMessage'(TempGuideMessage.Message).default.XWrap - class'ZombieMessage'(TempGuideMessage.Message).default.XReset,Chr(0));
		Canvas.WrapStringToArray(TempGuideMessage.StringMessage,ParsedStrings,330);

		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
		Canvas.bCenter = false;

		if(ParsedStrings.Length != 0)
		{
			BumpGuideMessage(ParsedStrings.Length);
		}

		j=0;
		for(i=ParsedStrings.Length-1; i >= 0; --i)
		{
			GuideMessage[i] = TempGuideMessage;
			GuideMessage[i].StringMessage = ParsedStrings[j];
			j++;
		}

		ClearZMessage(TempGuideMessage);
	}

	if(bMoveGuides)
	{
		if(abs(SubtitleAdjust) >= class'ZombieGuideMessage'.default.TextSize)
		{
			BumpGuideMessage(1,true);
		}
		else
		{
			if( (Level.TimeSeconds - SubTitleLastAdjust) > 0.02f)
			{
				SubTitleLastAdjust = Level.TimeSeconds;
				SubTitleAdjust-=1.0f;
			}
		}
	}
	
	for(i=0; i < NUM_GUIDE_MSGS; i++)
	{
		if (GuideMessage[i].Message != None)
		{	

			Alpha = (GuideMessage[i].EndOfLife - Level.TimeSeconds)/GuideMessage[i].LifeTime;
			if(Alpha >= 0.25)
			{
				Alpha = 1.0f;
			}
			else
			{
				Alpha = Alpha * 4.0f;
			}

			if(i <= 3)
			{
				GuideMessage[i].EndOfLife = Level.TimeSeconds+GuideMessage[i].LifeTime;
			}
			

			Canvas.SetDrawColor(255,255,255,Max(255*Alpha,1));
			
			DrawZMessage(Canvas, GuideMessage[i],SubTitleAdjust-(class'ZombieGuideMessage'.default.TextSize*i));
		}
	}

	if (ObjectiveUpdateTimer >= 0)
	{	
		if ((ObjectiveUpdateTimer - Level.TimeSeconds) < OBJECTIVE_TIME_FADE_OUT)
		{
			ObjectiveAlpha = ((ObjectiveUpdateTimer - Level.TimeSeconds)/OBJECTIVE_TIME_FADE_OUT);
//			log("BasicHUD: ObjectiveAlpha1 " $ ObjectiveAlpha @ BYTE(255*ObjectiveAlpha) @ (ObjectiveUpdateTimer - Level.TimeSeconds));
		}
		else if ((OBJECTIVE_TIME - (ObjectiveUpdateTimer - Level.TimeSeconds)) < OBJECTIVE_TIME_FADE_IN)
		{
			ObjectiveAlpha = ((OBJECTIVE_TIME - (ObjectiveUpdateTimer - Level.TimeSeconds))/OBJECTIVE_TIME_FADE_IN);
//			log("BasicHUD: ObjectiveAlpha2 " $ ObjectiveAlpha @ (ObjectiveUpdateTimer - Level.TimeSeconds) @ BYTE(255*ObjectiveAlpha));
		}
		else
		{
			ObjectiveAlpha = 1;
//			log("BasicHUD: ObjectiveAlpha3 " $ ObjectiveAlpha @ BYTE(255*ObjectiveAlpha));
		}

		if ((canvas.ClipY<480) && (canvas.offY == 0))
		{
			ObjectivesOffset = 32;
		}
		
		Canvas.SetDrawColor(255, 255, 255, max(1, 40*ObjectiveAlpha));

		DrawBox(Canvas, 0, 35+ObjectivesOffset, Canvas.LogSizeX, 50);

		Canvas.SetDrawColor(255,255,255, max(1, 255*ObjectiveAlpha));
//		Canvas.DrawColor = AmberColor;
						
		Canvas.Style = ERenderStyle.STY_Normal;

		if(Level.TimeSeconds >= TimeOfNextFlash)
		{
			bMsgOn = !bMsgOn;
			if(bMsgOn)
			{
				TimeOfNextFlash = Level.TimeSeconds + MESSAGE_ON_TIME;
			}
			else
			{
				TimeOfNextFlash = Level.TimeSeconds + MESSAGE_OFF_TIME;
			}
			
		}
		
		class'ZombieFontDescriptor'.static.SetHUDFont(canvas, 24*fontScale);
	
		if(bMsgOn)
		{
			DrawTextJustify(Canvas, 
			ObjectivesUpdatedText, 
			Canvas.LogSizeX/2,
			40+ObjectivesOffset,
			JUST_Center);
		}
		
		if (ObjDescription != "")
		{
			class'ZombieFontDescriptor'.static.SetRadarFont(canvas, 20*fontScale);
			
			DrawTextJustify(Canvas, 
			ObjDescription, 
			Canvas.LogSizeX/2,
			40+ObjectivesOffset+19*fontScale,
			JUST_Center);		
		}
		
		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}
	
	//
	if (CheckpointMsgTimer >= 0)
	{	
		if ((CheckpointMsgTimer - Level.TimeSeconds) < CHECKPOINT_TIME_FADE_OUT)
		{
			ObjectiveAlpha = ((CheckpointMsgTimer - Level.TimeSeconds)/CHECKPOINT_TIME_FADE_OUT);
		}
		else if ((CHECKPOINT_TIME - (CheckpointMsgTimer - Level.TimeSeconds)) < CHECKPOINT_TIME_FADE_IN)
		{
			ObjectiveAlpha = ((CHECKPOINT_TIME - (CheckpointMsgTimer - Level.TimeSeconds))/CHECKPOINT_TIME_FADE_IN);
		}
		else
		{
			ObjectiveAlpha = 1;
		}

//		Canvas.SetDrawColor(255, 255, 255, max(1, 40*ObjectiveAlpha));

//		DrawBox(Canvas, 0, Canvas.SafeFrame.Top-5, offset, 30);

		Canvas.SetDrawColor(255,255,255, max(1, 255*ObjectiveAlpha));
						
		Canvas.Style = ERenderStyle.STY_Normal;

		class'ZombieFontDescriptor'.static.SetHUDFont(canvas, 24*fontScale);
	
		DrawTextJustify(Canvas, 
			class'Strings'.default.CheckpointSaved, 
			Canvas.LogSizeX/2,
			265,
			JUST_Center);
		
		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}
	//
	
	//RDN OBJECTIVESINCOMPLETE MESSAGE
	if (ObjectivesIncompleteTimer >= 0)
	{		
		Canvas.SetDrawColor(255, 255, 255, 40);

//		DrawMsgHighlight(Canvas, 320, 87, 265, 34);

//		class'ZombieFontDescriptor'.static.SetHUDFont(canvas, 24);
		class'ZombieFontDescriptor'.static.SetHUDFont(canvas, 20*fontScale);

//		Canvas.SetDrawColor(255,255,255);
		Canvas.DrawColor = AmberColor;
						
		Canvas.Style = ERenderStyle.STY_Normal;

		Canvas.SpaceX = 2;
		if(Level.TimeSeconds >= TimeOfNextFlash)
		{
			bMsgOn = !bMsgOn;
			if(bMsgOn)
			{
				TimeOfNextFlash = Level.TimeSeconds + MESSAGE_ON_TIME;
			}
			else
			{
				TimeOfNextFlash = Level.TimeSeconds + MESSAGE_OFF_TIME;
			}
			
		}
		
		if(bMsgOn)
		{
			DrawTextJustify(Canvas, 
			"Objectives Incomplete", 
			320,
			//75,
			380,
			JUST_Center);
		}
		
		Canvas.SpaceX = 0;
		
		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}
	//RDN OBJECTIVESINCOMPLETE MESSAGE

/*
// MAT: disabled weapon mode name display
	if (ModeNameTime > 0)
	{
		class'ZombieFontDescriptor'.static.SetRadarFont(Canvas, 20);

		Canvas.SpaceX = 2;
		Canvas.Style = ERenderStyle.STY_Normal;

		if (ModeNameTime <= 1)
		{
			Canvas.SetDrawColor(255, 255, 255, Max(ModeNameTime*255, 1));
		}
		else
		{
			Canvas.SetDrawColor(255, 255, 255);
		}

		DrawTextJustify(Canvas, 
			CurModeName, 
			320*Canvas.ScaleX/Canvas.ScaleY,
			39,
			JUST_Center);

		class'ZombieFontDescriptor'.static.ResetFont(Canvas);
	}
// END MAT: disabled weapon mode name display
*/

	class'ZombieFontDescriptor'.static.ResetFont(Canvas);

//	}
	Canvas.Style = ERenderStyle.STY_Normal;

	if ( bStartUpMessage && (Level.TimeSeconds < 5) )
	{
		bStartUpMessage = false;
		PlayerOwner.SetProgressTime(7);
	}

	//
	if (GlowFact != 0)
	{
		if (GlowTime == 0)
		{
			GlowTime = Level.TimeSeconds + GlowFact;
		}

		if (Level.TimeSeconds > GlowTime)
		{
			Glow += GlowDir;
			GlowTime = Level.TimeSeconds + GlowFact;

			if ((Glow == 255) || (Glow == 0))
			{
				GlowFact = 0;
				GlowTime = 0;
				GlowDir *= -1;
			}
		}
	}
	//
	/*
	if ( !ViewedInfo.bIsSpectator )
	{
		Canvas.Style = Style;

		// Let the Weapon draw it's info
		if ( PawnOwner != None )
		{
			if (!InScopeMode)
			{
				DrawComponents(Canvas);
			}
			else
			{
				DrawScopeComponents(Canvas);
			}

			if ((Level.TimeSeconds-HitIndicatorTime) < HIT_INDICATOR_TIMEOUT)
			{
				DrawHitIndicator(Canvas);
			}

//			OwnerHit(vect(1, 0, 0));
//			DrawHitIndicator(Canvas);

//			
			if(shouldDrawTitleSafe)
			{
				DrawTitleSafe(Canvas);
			}
//			
		}
	}*/
}

simulated function DrawSniperScope(Canvas c)
{
	local int scopeSize;
	local int i;
	local int fatSize;
	
	scopeSize = 233;
	fatSize = 82;
	
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERSCOPE, 
			(c.LogSizeX/2)-scopeSize, 
			(c.LogSizeY/2)-scopeSize, 
			scopeSize, 
			scopeSize );
			
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERSCOPE, 
			(c.LogSizeX/2)+scopeSize, 
			(c.LogSizeY/2)-scopeSize, 
			-scopeSize, 
			scopeSize );
			
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERSCOPE, 
			(c.LogSizeX/2)+scopeSize, 
			(c.LogSizeY/2)+scopeSize, 
			-scopeSize, 
			-scopeSize );
			
	class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERSCOPE, 
			(c.LogSizeX/2)-scopeSize, 
			(c.LogSizeY/2)+scopeSize, 
			scopeSize, 
			-scopeSize );
	
	c.SetDrawColor(0,0,0);
	
	DrawBox(c, 0, (c.LogSizeY/2)-0, c.LogSizeX, 2);
	DrawBox(c, (c.LogSizeX/2)-0, 0, 2, c.LogSizeY);
	
	DrawBox(c, (c.LogSizeX/2)-scopeSize, (c.LogSizeY/2)-3, fatSize, 8);
	DrawBox(c, (c.LogSizeX/2)+scopeSize, (c.LogSizeY/2)-3, -fatSize, 8);
	DrawBox(c, (c.LogSizeX/2)-3, (c.LogSizeY/2)-scopeSize, 8, fatSize);
	DrawBox(c, (c.LogSizeX/2)-3, (c.LogSizeY/2)+scopeSize, 8, -fatSize);
	
	DrawBox(c, 0, 0, (c.LogSizeX/2)-scopeSize+1, c.LogSizeY+1);
	DrawBox(c, (c.LogSizeX/2)+scopeSize-1, 0, c.LogSizeX-((c.LogSizeX/2)+scopeSize)+2, c.LogSizeY);
	
	DrawBox(c, 0, 0, c.LogSizeX, (c.LogSizeY/2)-scopeSize+1);
	DrawBox(c, 0, (c.LogSizeY/2)+scopeSize-1, c.LogSizeX, c.LogSizeY-((c.LogSizeY/2)+scopeSize)+2);
	
	for (i=0; i<5; ++i)
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERDOT, 
			(c.LogSizeX/2)-scopeSize+fatSize-4+(i*24), 
			(c.LogSizeY/2)-3);
			
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERDOT, 
			(c.LogSizeX/2)+scopeSize-fatSize-4-(i*24), 
			(c.LogSizeY/2)-3);
			
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERDOT, 
			(c.LogSizeX/2)-3, 
			(c.LogSizeY/2)-scopeSize+fatSize-4+(i*24));
			
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			HIM_SNIPERDOT, 
			(c.LogSizeX/2)-3, 
			(c.LogSizeY/2)+scopeSize-fatSize-4-(i*24));
	}
}

simulated function DrawScopeComponents(Canvas c)
{
	local actor aimAct;
	local ZombiePawn zAimPawn;
	local ZombieWeapon weap;
	local int LevelOfDifficulty;
	
//	Draw sniper scope here...

	if (IsSniperScope)
	{
		DrawSniperScope(c);
	
		aimAct = SFRMPlayerController(Owner).AimAct;

		zAimPawn = ZombiePawn(aimAct);

		weap = ZombieWeapon(PawnOwner.Weapon);

		if( Level.Game == None || Level.NetMode != NM_Standalone )
			LevelOfDifficulty = weap.MP_DIFFICULTY_HACK;
		else
			LevelOfDifficulty = Level.Game.GameDifficulty;

		//if we're not aiming at a zombiepawn, maybe it's owner is a zombie pawn
		if (zAimPawn == None && aimAct != None)
		{
			aimAct = aimAct.Owner;
			zAimPawn = ZombiePawn(aimAct);
		}

		//Draw a no-shoot icon if neccessary
		if( ShouldDrawNoShoot(zAimPawn) )
			DrawNoShoot(c, zAimPawn);
		else
			DrawSniperShoot(c, zAimPawn);

		//Draw sway indicator
		if( LevelOfDifficulty > 0 )
		{
			//draw sway here...
		}
		//Draw zoom indicator
		if( Level.TimeSeconds > weap.fZoomStartTime + 0.15 )
		{
			//draw zoom here...
		}
	}

	if (!IsSniperScope)
	{
		DrawAmmo(c);
		DrawHealth(c);
		DrawCrosshair(c);
		
		if (HealthWatchPawn != none)
		{
			DrawHealthWatch(c);
		}
		
		if (CountdownTimerIsOn)
		{
			DrawCountdownTimer(c);
		}
	}
}

// Sucky hack.
// Just in case we need some symbology other than NoShoot (e.g. in multiplayer) if non-ally targeted
// while in sniper scope mode
simulated event DrawSniperShoot(Canvas Canvas, ZombiePawn zAimPawn)
{
	local int oldCHIndex;
	
	oldCHIndex = CurCHIndex;
	CurCHIndex = 6;

	//
	DrawCrosshair(Canvas);
	//

	CurCHIndex = oldCHIndex;
}

function DrawLoadOut( Canvas c )
{
	// see if we should still be drawing
	// find out which weapons i have
	// draw their icons on top of the ammo HUD
	// gradually fade out
	local Inventory Inv;
	local ZombieWeapon weap[5];
	local int numWeaps;
	local int i;
	local float tmp;
	local float ratio;

	if( LoadoutTime > LOADOUT_DISPLAY_TIME + 2*LOADOUT_FADE_TIME )
		return;

	c.DrawColor.R = 255;
	c.DrawColor.G = 255;
	c.DrawColor.B = 255;
	c.DrawColor.A = 255*OpacityAdjust;

	// TODO: sync with DrawAmmo
	tmp = offset-48+WidthAdjust;

	for( Inv=PawnOwner.Inventory; Inv!=None ; Inv=Inv.Inventory )
	{ 
		if( Inv.IsA('ZombieWeapon') && !Inv.IsA('ABSTRACT_WeapGrenade') && !Inv.IsA('WeapSOFLAM') &&
			numWeaps < 5 )
		{
			weap[numWeaps++] = ZombieWeapon( Inv );
//			log( "BasicHUD.DrawLoadOut: Found " $ Inv.class.name );
		}
	}

//	c.SetAngle(-80-TweakValY-WidthAdjust/400*(80+TweakValY), (320-tmp)/320, ((140+(BasePos-RealBasePos))/480)*2, 1);

	// move up
	if( LoadoutTime < LOADOUT_FADE_TIME )
	{
		ratio = sin( LoadoutTime / LOADOUT_FADE_TIME * PI / 2 );
	}
	else if( LoadoutTime > LOADOUT_FADE_TIME + LOADOUT_DISPLAY_TIME )
	{
		ratio = 1 - sin( (LoadoutTime - LOADOUT_FADE_TIME - LOADOUT_DISPLAY_TIME) / LOADOUT_FADE_TIME * PI / 2 );
	}
	else
	{
		ratio = 1;
	}

	c.DrawColor.A = 255*ratio;

	for( i = 0; i < numWeaps; ++i )
	{
		class'ZombieGame.HUDIconMgr'.static.DrawImageHW( 
			c, 
			weap[i].WeaponIconIndex, 
			tmp-123, 
			basePos-51-(49+32*i)*ratio, 
			112, 
			28 );
	}
//	c.SetAngle( 0 );
}

function DrawComponents(Canvas c)
{
	local Color origDrawColor;
	origDrawColor = c.DrawColor;

//	DrawBackground(c);
	DrawCrosshair(c);
//	DrawLoadout(c); // draw ammo over top of this
	DrawAmmo(c);
	DrawHealth(c);

	c.DrawColor=origDrawColor;
	DrawNotify(c);

	if( !FirstRender )
		FirstRender = true;
	
//	if (HealthWatchPawn != none)
//	{
//		DrawHealthWatch(c);
//	}
	
	if (CountdownTimerIsOn)
	{
		DrawCountdownTimer(c);
	}
}

function NewCheckpoint()
{
	CheckpointMsgTimer = Level.TimeSeconds + CHECKPOINT_TIME;
}

function ObjectivesUpdated(string Description)
{
	ObjectiveUpdateTimer = Level.TimeSeconds + OBJECTIVE_TIME;
	ObjDescription = Description;
	
	//Disable objectives incomplete timer
	ObjectivesIncompleteTimer = -1;
}

function ObjectivesIncomplete()
{
	ObjectivesIncompleteTimer = Level.TimeSeconds + 5;
	
	//Disable objectives updated timer
	ObjectiveUpdateTimer = -1;
}

function Timer()
{
	local int i, j;
	local ProxyMenuManager MM;

	if (Level.TimeSeconds >= ObjectiveUpdateTimer)
	{
		ObjectiveUpdateTimer = -1;
	}
	
	if (Level.TimeSeconds >= CheckpointMsgTimer)
	{
		CheckpointMsgTimer = -1;
	}
	
	if (Level.TimeSeconds >= ObjectivesIncompleteTimer)
	{
		ObjectivesIncompleteTimer = -1;
	}

	// Age all localized messages.
	for (i=0; i<10; i++)
	{
		// Purge expired messages.
		if ( (LocalMessages[i].Message != None) && (Level.TimeSeconds >= LocalMessages[i].EndOfLife) )
			ClearMessage(LocalMessages[i]);
	}

	//
	j=0;
	for (i=EmptySlotPickupMsg; j<NUM_PICKUP_MSGS; i=(i+1)%NUM_PICKUP_MSGS)
	{
		// Purge expired messages.
		if ( (PickupMessages[i].Message != None) && (Level.TimeSeconds >= PickupMessages[i].EndOfLife) )
		{
			ClearZMessage(PickupMessages[i]);
			EmptySlotPickupMsg = i;
		}
		j++;
	}
	//

	j=0;
	for (i=EmptySlotGameMsg; j<NUM_GAME_MSGS; i=(i+1)%NUM_GAME_MSGS)
	{
		// Purge expired messages.
		if ( (GameMessages[i].Message != None) && (Level.TimeSeconds >= GameMessages[i].EndOfLife) )
		{
			ClearZMessage(GameMessages[i]);
			EmptySlotGameMsg = i;
		}
		j++;
	}

	//
	j=0;
	for (i=EmptySlotSubtitleMsg; j<NUM_SUBTITLE_MSGS; i=(i+1)%NUM_SUBTITLE_MSGS)
	{
		// Purge expired messages.
		if ( (SubtitleMessages[i].Message != None) && (Level.TimeSeconds >= SubtitleMessages[i].EndOfLife) )
		{
			//log("PurgeSubtitle, time expired");
			ClearZMessage(SubtitleMessages[i]);
			EmptySlotSubtitleMsg = i;
		}
		j++;
	}
	//
	
	//log("just before I try to clear it " $ WeaponMessage.EndOfLife @ Level.TimeSeconds);
	if ( (WeaponMessage.Message != None) && (WeaponMessage.EndOfLife>0) && (Level.TimeSeconds >= WeaponMessage.EndOfLife) )
	{
		ClearZMessage(WeaponMessage);
	}

	for(i=0;i < NUM_GUIDE_MSGS; i++)
	{
		if ( (GuideMessage[i].Message != None) && (Level.TimeSeconds >= GuideMessage[i].EndOfLife) )
		{
			ClearZMessage(GuideMessage[i]);
		}
	}

	// Age all localized messages.
	for (i=0; i<NUM_TELETYPE_MSGS; i++)
	{
		if ( (TeleTypeMessage[i].Message != None) && (Level.TimeSeconds >= TeleTypeMessage[i].EndOfLife) )
		{
			ClearZMessage(TeleTypeMessage[i]);
		}
	}

	// Clean empty slots.
	for (i=0; i<9; i++)
	{
		if ((LocalMessages[i+1].Message != None) && (LocalMessages[i].Message == None ))
		{
			CopyMessage(LocalMessages[i],LocalMessages[i+1]);
			ClearMessage(LocalMessages[i+1]);
		}
	}

	if ( (PlayerOwner == None) || (PawnOwner == None) || (PlayerOwner.GameReplicationInfo == None)
		|| (ViewedInfo == None) )
		return;

	MM = ProxyMenuManager(PlayerOwner.Player.BasePlayerMenu);
	if ((MM!=none) && (MM.XBLiveMgr != none))
	{
		if (MM.XBliveMgr.GetInGameNotify(PlayerOwner.Player) == EXBLN_RecInvite)
		{
			log("Setting notify time");
			NotifyTime=Level.TimeSeconds + 4.0f;
		}
	}

}

simulated function TellTime(int num)
{
	PlayerOwner.ReceiveLocalizedMessage( TimeMessageClass, Num );
}

simulated function Tick(float DeltaTime)
{
	local int i;

	Super.Tick(DeltaTime);

	ModeNameTime -= DeltaTime;

	if ( MessageFadeTime < 1.0 )
	{
		MessageFadeTime += DeltaTime * 8;
		if (MessageFadeTime > 1.0)
			MessageFadeTime = 1.0;
	}

	HealthPulseTime += DeltaTime;
	for( i = 0; i < 5; ++i )
		AmmoPulseTime[i] += DeltaTime;

	if( FirstRender )
		LoadoutTime += DeltaTime;
}

function ClearMessages()
{
	local int i;

	Super.ClearMessages();

//	AddTextMessage("Clear: " $ Level.TimeSeconds, class'StringMessagePlus');

	for (i=0; i<NUM_TELETYPE_MSGS; i++)
	{
		if (TeleTypeMessage[i].Message != None)
		{
			ClearZMessage(TeleTypeMessage[i]);
		}
	}
	
	for (i=0; i<NUM_SUBTITLE_MSGS; i++)
	{
		if (SubtitleMessages[i].Message != None)
		{
			//log("Purge Subtitle, ClearCalled");
			ClearZMessage(SubtitleMessages[i]);
		}
	}
	EmptySlotSubtitleMsg = 0;
	
	for(i=0;i < NUM_GUIDE_MSGS; i++)
	{
		ClearZMessage(GuideMessage[i]);
	}
	
	ClearZMessage(WeaponMessage);
}
event ClearWeaponMessage()
{
	ClearZMessage(WeaponMessage);	
}


function ClearLocalMessages(optional class<LocalMessage> MsgClass)
{
	local int i;

	if (ClassIsChildOf(class'LocalMessage', MsgClass))
	{
		for (i=0; i<10; i++)
		{
			ClearMessage(LocalMessages[i]);
		}
	}

	//
	if (ClassIsChildOf(class'ZombieGame.ZombiePickupMessage', MsgClass))
	{
		for (i=0; i<NUM_PICKUP_MSGS; i++)
		{
			ClearZMessage(PickupMessages[i]);
		}
		EmptySlotPickupMsg = 0;
	}

	//
	if (ClassIsChildOf(class'ZombieGame.ZombieGameMessage', MsgClass))
	{
		for (i=0; i<NUM_GAME_MSGS; i++)
		{
			ClearZMessage(GameMessages[i]);
		}
		EmptySlotGameMsg = 0;
	}

	//
	if (ClassIsChildOf(class'ZombieGame.SubtitleMessage', MsgClass))
	{
		for (i=0; i<NUM_SUBTITLE_MSGS; i++)
		{
			log("Purge Subtitle, ClearLocalMsg Called");
			ClearZMessage(SubtitleMessages[i]);
		}
		EmptySlotSubtitleMsg = 0;
	}
	//

	if (ClassIsChildOf(class'ZombieGame.ZombieInfoMessage', MsgClass))
	{
		ClearZMessage(WeaponMessage);
	}

	if (ClassIsChildOf(class'ZombieGame.ZombieWeaponMessage', MsgClass))
	{
		ClearZMessage(WeaponMessage);
	}
	

	if (ClassIsChildOf(class'ZombieGame.ZombieGuideMessage', MsgClass))
	{
		for(i=0;i < NUM_GUIDE_MSGS; i++)
		{
			ClearZMessage(GuideMessage[i]);
		}
	}

	if (ClassIsChildOf(class'ZombieGame.ZombieTeleTypeMessage', MsgClass))
	{
		for (i=0; i<NUM_TELETYPE_MSGS; i++)
		{
			ClearZMessage(TeleTypeMessage[i]);
		}
	}
}

// Entry point for string messages.
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
	local int i;
	local class<ZombieMessage> MessageClass;

	switch (MsgType)
	{
	case 'ZombieTeleTypeMessage':
		MessageClass = class'ZombieTeleTypeMessage';

		for (i=0; i<NUM_TELETYPE_MSGS; i++)
		{
			if (TeleTypeMessage[i].Message == none)
			{
				break;
			}
		}

		if (i != NUM_TELETYPE_MSGS)
		{
			TeleTypeMessage[i].Message = MessageClass;
			TeleTypeMessage[i].Switch = 0;
			TeleTypeMessage[i].RelatedPRI = PRI;
			TeleTypeMessage[i].OptionalObject = None;
			if (Duration == 0)
			{
				TeleTypeMessage[i].EndOfLife = MessageClass.Default.Lifetime + Level.TimeSeconds;
				TeleTypeMessage[i].LifeTime = MessageClass.Default.Lifetime;
			}
			else
			{
				TeleTypeMessage[i].EndOfLife = Duration + Level.TimeSeconds;
				TeleTypeMessage[i].LifeTime = Duration;
			}
			TeleTypeMessage[i].StringMessage = Msg;
			TeleTypeMessage[i].StringFont = class<ZombieTeleTypeMessage>(MessageClass).Default.Font;
			TeleTypeMessage[i].TextSize = class<ZombieTeleTypeMessage>(MessageClass).Default.TextSize;
			TeleTypeMessage[i].Kern = class<ZombieTeleTypeMessage>(MessageClass).Default.Kern;
		}

		//AddTextMessage("Msg: " $ Level.TimeSeconds, class'StringMessagePlus');
		//AddTextMessage("Whole thing went in fine", class'StringMessagePlus');
		return;
	case 'Pickup':
		PickupTime = Level.TimeSeconds;
	default:
		MessageClass = class'ZombieMessage';
		break;
	}

	/*
	if ( ClassIsChildOf(MessageClass, class'SayMessagePlus') || 
				     ClassIsChildOf(MessageClass, class'TeamSayMessagePlus') )
	{
		TalkTime = MessageClass.Default.Lifetime + Level.TimeSeconds;
		TalkPRI = PRI;
	}
	*/ 
//	AddTextMessage(Msg,MessageClass,ViewedInfo);
}

//=====================================================================
// Deal with a localized message.

//allow derived specialization
simulated function bool HandleLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString );

simulated event LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString )
{
	local int i;
	local class<ZombieMessage> ZMessage;
	local float zlifetime;
	
	if(bNoMessageDisplay)
	{
		return;
	}

	if ( bMessageBeep && Message.Default.bBeep )
		PlayerOwner.PlayBeepSound();

	if ( !Message.Default.bIsSpecial )
	{
		/*
		if ( ClassIsChildOf(Message, class'SayMessagePlus') || 
						 ClassIsChildOf(Message, class'TeamSayMessagePlus') )
		{
			TalkTime = Message.Default.Lifetime + Level.TimeSeconds;
			TalkPRI = RelatedPRI_1;
		}
		*/
		return;
	} 
	else 
	{
		if ( CriticalString == "" )
			CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		if ( Message.Default.bIsUnique )
		{
			for (i=0; i<10; i++)
			{
				if (LocalMessages[i].Message != None)
				{
					if ((LocalMessages[i].Message == Message) 
						|| (LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, 24, 640) 
								== Message.Static.GetOffset(Switch, 24, 640)) ) 
					{
						LocalMessages[i].Message = Message;
						LocalMessages[i].Switch = Switch;
						LocalMessages[i].RelatedPRI = RelatedPRI_1;
						LocalMessages[i].OptionalObject = OptionalObject;
						LocalMessages[i].LifeTime = Message.Default.Lifetime;
						LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
						LocalMessages[i].StringMessage = CriticalString;
						LocalMessages[i].DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
					/*	if ( LocalMessages[i].Message.Static.GetFontSize(LocalMessages[i].Switch,RelatedPRI_1,RelatedPRI_2,ViewedInfo) == 1 )
							LocalMessages[i].StringFont = MyFont.GetBigFont(OldClipX);
						else // == 2
							LocalMessages[i].StringFont = MyFont.GetHugeFont(OldClipX);*/
						LocalMessages[i].StringFont = class'ZombieFontDescriptor'.default.Normal;
						return;
					}
				}
			}
		}

		if (ClassIsChildOf(Message, class'ZombiePickupMessage'))
		{
			//log("Got pickup Message: " $ CriticalString $ Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject));
			//log("Got pickup Message: " $ OptionalObject);
			ZMessage = class<ZombieMessage>(Message);
			PickupMessages[EmptySlotPickupMsg].Message = ZMessage;
			PickupMessages[EmptySlotPickupMsg].Switch = Switch;
			PickupMessages[EmptySlotPickupMsg].RelatedPRI = RelatedPRI_1;
			PickupMessages[EmptySlotPickupMsg].OptionalObject = OptionalObject;
			PickupMessages[EmptySlotPickupMsg].EndOfLife = ZMessage.Default.Lifetime + Level.TimeSeconds;
			PickupMessages[EmptySlotPickupMsg].StringMessage = CriticalString;
			PickupMessages[EmptySlotPickupMsg].LifeTime = ZMessage.Default.Lifetime;
			PickupMessages[EmptySlotPickupMsg].StringFont = ZMessage.Default.Font;
			PickupMessages[EmptySlotPickupMsg].TextSize = ZMessage.Default.TextSize;
			PickupMessages[EmptySlotPickupMsg].Kern = ZMessage.Default.Kern;

			CurPickupMsg = EmptySlotPickupMsg;
			
			EmptySlotPickupMsg++;
			EmptySlotPickupMsg = EmptySlotPickupMsg%NUM_PICKUP_MSGS;
			return;
		}

		if (ClassIsChildOf(Message, class'ZombieGameMessage'))
		{
			ZMessage = class<ZombieMessage>(Message);
			GameMessages[EmptySlotGameMsg].Message = ZMessage;
			GameMessages[EmptySlotGameMsg].Switch = Switch;
			GameMessages[EmptySlotGameMsg].RelatedPRI = RelatedPRI_1;
			GameMessages[EmptySlotGameMsg].OptionalObject = OptionalObject;
			GameMessages[EmptySlotGameMsg].EndOfLife = ZMessage.Default.Lifetime + Level.TimeSeconds;
			GameMessages[EmptySlotGameMsg].StringMessage = CriticalString;
			GameMessages[EmptySlotGameMsg].LifeTime = ZMessage.Default.Lifetime;
			GameMessages[EmptySlotGameMsg].StringFont = ZMessage.Default.Font;
			GameMessages[EmptySlotGameMsg].TextSize = ZMessage.Default.TextSize;
			GameMessages[EmptySlotGameMsg].Kern = ZMessage.Default.Kern;

			CurGameMsg = EmptySlotGameMsg;
			
			EmptySlotGameMsg++;
			EmptySlotGameMsg = EmptySlotGameMsg%NUM_GAME_MSGS;
			return;
		}

		//
		//BRETT: Look here
		if ( ClassIsChildOf(Message, class'SubtitleMessage'))
		{
			if(!bDisplaySubtitles)
			{
				if ( ACTION_PlayDialog ( OptionalObject ) == None || !ACTION_PlayDialog ( OptionalObject ).bForceSubtitle )
				{
					return;
				}
			}
			ZMessage = class<ZombieMessage>(Message);
			SubtitleMessages[EmptySlotSubtitleMsg].Message = ZMessage;
			SubtitleMessages[EmptySlotSubtitleMsg].Switch = Switch;
			SubtitleMessages[EmptySlotSubtitleMsg].RelatedPRI = RelatedPRI_1;
			SubtitleMessages[EmptySlotSubtitleMsg].OptionalObject = OptionalObject;
			SubtitleMessages[EmptySlotSubtitleMsg].EndOfLife = ZMessage.static.GetZLifetime(switch, optionalObject) + Level.TimeSeconds;
			SubtitleMessages[EmptySlotSubtitleMsg].StringMessage = CriticalString;
			//SubtitleMessages[EmptySlotSubtitleMsg].LifeTime = ZMessage.Default.Lifetime;
			SubtitleMessages[EmptySlotSubtitleMsg].LifeTime = ZMessage.static.GetZLifetime(switch, optionalObject);
			SubtitleMessages[EmptySlotSubtitleMsg].StringFont = ZMessage.Default.Font;
			SubtitleMessages[EmptySlotSubtitleMsg].TextSize = ZMessage.Default.TextSize;
			SubtitleMessages[EmptySlotSubtitleMsg].Kern = ZMessage.Default.Kern;


			CurSubtitleMsg = EmptySlotSubtitleMsg;
			
			EmptySlotSubtitleMsg++;
			EmptySlotSubtitleMsg = EmptySlotSubtitleMsg%NUM_PICKUP_MSGS;
			
//			log("Got Sub Msg: " $ CriticalString @ ZMessage.static.GetZLifetime(switch, optionalObject));
			
			return;
		}
		//
		
		if (ClassIsChildOf(Message, class'ZombieWeaponMessage'))
		{
			ZMessage = class<ZombieMessage>(Message);
			WeaponMessage.Message = ZMessage;
			WeaponMessage.Switch = Switch;
			WeaponMessage.RelatedPRI = RelatedPRI_1;
			WeaponMessage.OptionalObject = OptionalObject;

			zlifetime = ZMessage.static.GetZLifetime(switch, optionalObject);

			if (zlifetime != 0)
			{
				WeaponMessage.EndOfLife = ZMessage.static.GetZLifetime(switch, optionalObject) + Level.TimeSeconds;
			}
			else
			{
				WeaponMessage.EndOfLife = 0;
			}
			//WeaponMessage.StringMessage = CriticalString;
			WeaponMessage.StringMessage = class<ZombieWeaponMessage>(Message).Static.GetStringPC(PlayerOwner, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
			WeaponMessage.LifeTime = zlifetime;
			WeaponMessage.StringFont = ZMessage.Default.Font;
			WeaponMessage.TextSize = ZMessage.Default.TextSize;
			WeaponMessage.Kern = ZMessage.Default.Kern;
			
			//log("Received ZombieWeaponMessage: " $ WeaponMessage.StringMessage @ WeaponMessage.EndOfLife @ zlifetime);

			return;
		}

		if (ClassIsChildOf(Message, class'ZombieGuideMessage'))
		{
			if(!bDisplaySubtitles)
			{
				if ( ACTION_PlayDialog ( OptionalObject ) == None || !ACTION_PlayDialog ( OptionalObject ).bForceSubtitle )				
				{
					return;
				}
			}

			ZMessage = class<ZombieMessage>(Message);
			TempGuideMessage.Message = ZMessage;
			TempGuideMessage.Switch = Switch;
			TempGuideMessage.RelatedPRI = RelatedPRI_1;
			TempGuideMessage.OptionalObject = OptionalObject;
			TempGuideMessage.EndOfLife = ZMessage.static.GetZLifetime(switch, optionalObject) + Level.TimeSeconds;
			TempGuideMessage.StringMessage = CriticalString;
			TempGuideMessage.LifeTime = ZMessage.static.GetZLifetime(switch, optionalObject);
			TempGuideMessage.StringFont = ZMessage.Default.Font;
			TempGuideMessage.TextSize = ZMessage.Default.TextSize;
			TempGuideMessage.Kern = ZMessage.Default.Kern;
			bMoveguides=true;
			return;
		}

		if (HandleLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString ))
		{
			return;
		}

		for (i=0; i<10; i++)
		{
			if (LocalMessages[i].Message == None)
			{
	
				LocalMessages[i].Message = Message;
				LocalMessages[i].Switch = Switch;
				LocalMessages[i].RelatedPRI = RelatedPRI_1;
				LocalMessages[i].OptionalObject = OptionalObject;
				LocalMessages[i].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
				LocalMessages[i].StringMessage = CriticalString;
				LocalMessages[i].DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);				
				LocalMessages[i].LifeTime = Message.Default.Lifetime;
				/*if ( LocalMessages[i].Message.Static.GetFontSize(LocalMessages[i].Switch,RelatedPRI_1,RelatedPRI_2,ViewedInfo) == 1 )
					LocalMessages[i].StringFont = MyFont.GetBigFont(OldClipX);
				else // == 2
					LocalMessages[i].StringFont = MyFont.GetHugeFont(OldClipX);*/
				LocalMessages[i].StringFont = class'ZombieFontDescriptor'.default.Normal;
				return;
			}
		}

		// No empty slots.  Force a message out.
		for (i=0; i<9; i++)
			CopyMessage(LocalMessages[i],LocalMessages[i+1]);

		LocalMessages[9].Message = Message;
		LocalMessages[9].Switch = Switch;
		LocalMessages[9].RelatedPRI = RelatedPRI_1;
		LocalMessages[9].OptionalObject = OptionalObject;
		LocalMessages[9].EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
		LocalMessages[9].StringMessage = CriticalString;
		LocalMessages[9].DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);				
		LocalMessages[9].LifeTime = Message.Default.Lifetime;
		/*if ( LocalMessages[9].Message.Static.GetFontSize(LocalMessages[9].Switch,RelatedPRI_1,RelatedPRI_2,ViewedInfo) == 1 )
			LocalMessages[9].StringFont = MyFont.GetBigFont(OldClipX);
		else // == 2
			LocalMessages[9].StringFont = MyFont.GetHugeFont(OldClipX);*/
		LocalMessages[9].StringFont = class'ZombieFontDescriptor'.default.Normal;
		return;
	}
}

function DisplayMessages(canvas Canvas)
{
}

function DisplayChatMessages(Canvas C)
{
}

function bool DrawLevelAction( canvas C )
{
	local string BigMessage;
//	local MenuManager MM;

	loading = false;

	if (Level.LevelAction == LEVACT_None )
	{
		if ( (Level.Pauser != None) && (Level.TimeSeconds > Level.PauseDelay + 0.2))
		{
//FIXME_OLDMENUS
//			MM = MenuManager(PlayerOwner.Player.BasePlayerMenu);
//			if ((MM!=none) && (!MM.ShowPauseMessage()))
//			{
//				BigMessage = "";
//				return false;
//			}
//			BigMessage = PausedMessage; // Add pauser name?
//		}
//		else
//		{
			BigMessage = "";
			return false;
		}
	}
	else if ( Level.LevelAction == LEVACT_Loading )
	{
		LoadDone=false;
		DrawLoadScreen(C);
		loading = true;
		return true;
	}

	return Super.DrawLevelAction(C);
}

function bool BumpGuideMessage(int Amount, optional bool bForce)
{
	local int i;
	local int j;

	local int numSlotsFree;

	SubTitleAdjust=0;
	bMoveGuides = true;

	//log("Bumping messages up"@Amount);
	if(bForce)
	{
		for ( i = NUM_GUIDE_MSGS - 1; i > 0; --i )
		{
			//log ( "BumpGuideMessage : "$GuideMessage[i].StringMessage@i@"with"@GuideMessage[i-1].StringMessage@i-1);
			GuideMessage[i] = GuideMessage[i-1];
		}
		ClearZMessage(GuideMessage[0]);
	}

	for( i=0; i < NUM_GUIDE_MSGS; i++)
	{
		if(GuideMessage[i].StringMessage != "")
		{
			numSlotsFree = i;
			break;
		}
	}	

	// bumping up old guidemessages
	for ( j = 0; j < Amount - numSlotsFree; ++j )
	{
		for ( i = NUM_GUIDE_MSGS - 1; i > 0; --i )
		{
			//log ( "BumpGuideMessage : "$GuideMessage[i].StringMessage@i@"with"@GuideMessage[i-1].StringMessage@i-1);
			GuideMessage[i] = GuideMessage[i-1];
		}
	}

	for ( i = 0; i < numSlotsFree; ++i )
	{
		//log ( "BumpGuideMessage : Clearing index"@i );
		ClearZMessage ( GuideMessage[i] );
	}

	return numSlotsFree == (NUM_GUIDE_MSGS -1);
}

function float CalcPulseScale( float time )
{
	local float ratio;

    ratio = time / PULSE_TIME;
	if( ratio < 0.5 )
	{
		// growing
		return 1 + 2*ratio*PULSE_SCALE;
	}
	else if( ratio < 1 )
	{
		// shrinking
		return 1 + PULSE_SCALE - 2*(ratio - 0.5)*PULSE_SCALE;
	}
	else
	{
		return 1;
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Decompiled with UE Explorer.
defaultproperties
{
    CheckpointMsgTimer=-1.0000000
    HudTest=5
    StartupHeight=3
    ObjectiveUpdateTimer=-1.0000000
    ObjectivesIncompleteTimer=-1.0000000
    bStartUpMessage=true
    Style=3
    AimPerturb=1.0000000
    CurEndurance=1.0000000
    CurHealth=100
    CurClips=6
    CurRounds=30
    GlowDir=1.0000000
    CHAlpha=128.0000000
    HitIndicatorTime=-1000.0000000
    ModeNameTimeBase=3.0000000
    TeletypeSound=Sound'CBW_DYN_interface.teletype.Type'
    BasePos=436.0000000
    RealBasePos=436.0000000
    OpacityAdjust=1.0000000
    AmberColor=(R=255,G=255,B=255,A=255)
    RedColor=(R=255,G=0,B=0,A=255)
    YellowColor=(R=255,G=255,B=0,A=255)
    GreenColor=(R=0,G=255,B=0,A=255)
    WhiteColor=(R=255,G=255,B=255,A=255)
    CurCHIndex=3
    HealthBoxWidth=100
    HealthBoxHeight=12
    HealthBoxBorderThickness=1
    SpectatorSwitchText="Press fire to view other players"
    SpectatingText="Spectating: "
    SpectatingSelfText="Spectating"
    ObjectivesUpdatedText="OBJECTIVES UPDATED"
    ForceLoadScreen=false
    LoadDone=true
    SmallFont=Font'CBT_DYN_Fonts.Verdana24CT'
    MedFont=Font'CBT_DYN_Fonts.Verdana24CT'
    BigFont=Font'CBT_DYN_Fonts.Verdana24CT'
    LargeFont=Font'CBT_DYN_Fonts.Verdana24CT'
}