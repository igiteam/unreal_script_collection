//////////////////////////////////////////////////////////////////////////////
//
//		CLASS SASActionMenu.uc
//
//////////////////////////////////////////////////////////////////////////////

class SASActionMenu extends Actor
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


//////////////////////////////////////////////////////////////////////////////
//	Consts

const HOSTAGE_HANDCUFF_MAX_DIST		= 120.0f;	// ~2.4m
const HOSTAGE_ORDER_MAX_DIST		= 500.0f;	// ~10m
const CLIMB_MAX_ANGLE				= 10922;	// ~60deg
const ASSAULT_DOOR_MAX_DIST			= 750.0f;	// ~15m
const OPEN_CLOSE_DOOR_MAX_DIST		= 150.0f;	// ~3m
const WEAPON_PICKUP_MAX_DIST		= 125.0f;	// ~2.5m
const WEAPON_PICKUP_MAX_DIST_FROM_CENTRE = 18.0; 
const SECONDARY_OBJ_MAX_DIST		= 125.0f;	// ~2.5m
const SECONDARY_OBJ_MAX_ANGLE		= 5460.0f;	// ~30deg

//////////////////////////////////////////////////////////////////////////////
//	Enums

enum eActionOptions
{
	ACTIONOPT_Default,
	ACTIONOPT_Left,
	ACTIONOPT_Right,
	ACTIONOPT_Cancel
};

enum EActionButtonAction
{
	ACTION_CloseCombat,
	ACTION_BreachingDoor,
	ACTION_DoorInProximity,
	ACTION_DoorOutOfProximity,
	ACTION_EntryPointVolume,
	ACTION_BoobyTrap,
	ACTION_SecondaryObjective,
	ACTION_Hostages,
	ACTION_HostagesCuffed,
	ACTION_FollowHostage,
	ACTION_ExplosiveHostage,
	ACTION_HandcuffCaptive,
	ACTION_Wall,
	ACTION_PickupWeapon,
	ACTION_CaptiveTerrorists,
	ACTION_StandingOrder,
	ACTION_None
};

enum eActionType
{
	ACTIONTYPE_Menu,
	ACTIONTYPE_Timer,
	ACTIONTYPE_NoMenu
};


//////////////////////////////////////////////////////////////////////////////
// STRUCTS

struct native sActionMenuOption
{
	var EActionButtonAction	mAction;
	var eActionType			mType;
	var Localized String	mMessages [3];		// Message 4 is always "Cancel"
};


//////////////////////////////////////////////////////////////////////////////
// VARS

var SASHUD					mOwnerHUD;
var float					mMaxLevelGeomTraceDist;
var (ActionMenu) float		mActionButtonAlphaTime;
var float					mActionButtonHeldTime;
var Texture					mHUDPieTexture;
var Texture					mBlankTexture;
var Texture					mCasualFull;
var Texture					mCasualEmpty;
var Texture					mActionIconTextures [17];
var localized string		mActionIconText [17];
var localized string		mCloseDoorMessage;
var EActionButtonAction		mCurrentAction;
var Actor					mCurrentActionActor;
var sActionMenuOption		mActionMenus [17];
var eActionOptions			mCurrentActionSelection;
var bool					mNotEnoughSquadForAssault;
var bool					mbMissionOver;
var SASPawn					mLastCloseCombatTarget;
var float					mLastCloseCombatTime;

var (Colours) Color			mSelectedTextColour;
var (Colours) Color			mTextColour;
var (Colours) Color			mGreyedOutColour;

var() float	mHandcuffingSoundRepeatTime;
var   float mHandcuffingSoundTime;
var() sound	mHandcuffingSound;
var() float mHandcuffingSoundVolume;
var() float mHandcuffingSoundRadius;
var() sound	mHandcuffedSound;
var() float mHandcuffedSoundVolume;
var() float mHandcuffedSoundRadius;

var() float mDefusingHostageSoundRepeatTime;
var   float mDefusingHostageSoundTime;
var() sound	mDefusingHostageSound;
var() float mDefusingHostageSoundVolume;
var() float mDefusingHostageSoundRadius;
var() sound	mDefusedHostageSound;
var() float mDefusedHostageVolume;
var() float mDefusedHostageRadius;

const PIE_TEXTURE_SIZE = 512;

// Used to be constants, then realised I was being silly and made them variable for easy iterating.
var float BRACKET_WIDTH;
var float BRACKET_HEIGHT;
var float BRACKET_U;
var float BRACKET_V;
var float BRACKET_HORIZ_OFFSET;
var float BRACKET_VERT_OFFSET;
var float BRACKET_HORIZONTAL_START_OFFSET;
var float BRACKET_VERT_FORSCALE;

var float HORIZ_HIGHLIGHT_WIDTH;
var float HORIZ_HIGHLIGHT_HEIGHT;

var float HORIZ_HIGHLIGHT_U;
var float HORIZ_HIGHLIGHT_V;

var float VERT_HIGHLIGHT_WIDTH;
var float VERT_HIGHLIGHT_HEIGHT;

var float VERT_HIGHLIGHT_U;
var float VERT_HIGHLIGHT_V;

var float HORIZ_HIGHLIGHT_OFFSET;
var float VERT_HIGHLIGHT_OFFSET;


//////////////////////////////////////////////////////////////////////////////
// NATIVE FUNCTIONS

native(750) final function SASPlayerController GetPlayerController();

native(751) final function SASPawn GetPlayerPawn( 
	optional SASPlayerController	aPC );

native(752) final function EActionButtonAction  DetermineHighestPriorityAction();


//////////////////////////////////////////////////////////////////////////////
// FUNCTIONS

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION endMission
//
function endMission ()
{
	mbMissionOver = true;
} // endMission


function DrawArrow(Canvas aCanvas, float istop, float isright, bool topbottom, float xmid, float ymid)
{
	local float fMiddleRightPie;
	
	// note that topbottom reverses the sense of X and Y!
	
	local float x0, y0, x1, y1;
	local float u0, v0, u1, v1;
	
	//top
	if (aCanvas.ClipX < 1024)
	{
		// Resolution 1 (640/480 and 800/600)
		u0 = 0.6;
		v0 = 0.46;
		u1 = 0.7;
		v1 = 0.4;
		
		fMiddleRightPie = xmid + isright * 100;
		x0 = fMiddleRightPie;
		y0 = ymid - istop * 100;
	}
	else
	{
		u0 = 0.0;
		v0 = 0.76;
		u1 = 0.1;
		v1 = 0.65;
		
		fMiddleRightPie = xmid + isright * 150;
		x0 = fMiddleRightPie + isright * ( - 35);
		y0 = ymid + istop * ( - 142.5 - 10);
	}
	
	x1 = x0 - isright * (v1 - v0) * float(mHUDPieTexture.VSize);
	y1 = y0 - istop * (v1 - v0) * float(mHUDPieTexture.VSize);
	
	if (topbottom)
	{
		aCanvas.SetPos(y0, x0);
		mOwnerHUD.DrawMyTile( aCanvas,
							mHUDPieTexture,
							y0,
							x1,
							y1,
							x0,
							y1,
							x1,
							u0,
							v0,
							u0,
							v1,
							u1,
							v0,
							u1,
							v1);
	}
	else
	{
		aCanvas.SetPos(x0, y0);
		mOwnerHUD.DrawMyTile( aCanvas,
							mHUDPieTexture,
							x1,
							y0,
							x0,
							y1,
							x1,
							y1,
							u0,
							v0,
							u0,
							v1,
							u1,
							v0,
							u1,
							v1);
	}
}

function DrawLeftRightTopBottom(Canvas aCanvas, float right, bool ishighlight, bool topbottom)
{
	local float x0, y0, x1, y1;
	local float u0, v0, u1, v1;
	
	// note that the sense of X and Y are switched by "topbottom"
	local float xmid;
	local float ymid;
	
	if (topbottom)
	{
		xmid = aCanvas.SizeY * 0.5;
		ymid = aCanvas.SizeX * 0.5;
	}
	else
	{
		xmid = aCanvas.SizeX * 0.5;
		ymid = aCanvas.SizeY * 0.5;
	}
	
	if (aCanvas.ClipX < 1024)
	{
		// Resolution 1 (640/480 and 800/600)
		u0 = 0.63;
		u1 = 1;
		
		if (ishighlight)
		{
			v0 = 0.2;
			v1 = 0.4;
		}
		else
		{
			v0 = 0.0;
			v1 = 0.2;
		}
		
		x0 = xmid + right * (BRACKET_HORIZ_OFFSET + BRACKET_HORIZ_OFFSET/4 - 20);
	}
	else
	{
		u0 = 0.0;
		u1 = 0.58;
		
		if (ishighlight)
		{
			v1 = 0.62;
			v0 = 0.31;
		}
		else
		{
			v0 = 0.0;
			v1 = 0.31;
		}
		
		x0 = xmid + right * 120;
	}
	
	y0 = ymid - (u1 - u0) * float(mHUDPieTexture.USize) * 0.5;
	x1 = x0 + right * (v1 - v0) * float(mHUDPieTexture.VSize);
	y1 = ymid + (u1 - u0) * float(mHUDPieTexture.USize) * 0.5;
	
	
	if (topbottom)
	{
		aCanvas.SetPos (y0, x0);
		mOwnerHUD.DrawMyTile( aCanvas,
							mHUDPieTexture,
							y0,
							x1,
							y1,
							x0,
							y1,
							x1,
							u0,
							v1,
							u0,
							v0,
							u1,
							v1,
							u1,
							v0);
	}
	else
	{
		aCanvas.SetPos (x0, y0);
		mOwnerHUD.DrawMyTile( aCanvas,
							mHUDPieTexture,
							x1,
							y0,
							x0,
							y1,
							x1,
							y1,
							u0,
							v1,
							u0,
							v0,
							u1,
							v1,
							u1,
							v0);
	}	
	
	if (ishighlight)
	{
		// arrows
		DrawArrow(aCanvas,  1, right, topbottom, xmid, ymid);
		DrawArrow(aCanvas, -1, right, topbottom, xmid, ymid);
	}
}

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION shouldDrawActionMenu
//
//	Returns true if the action menu is to be drawn
function bool shouldDrawActionMenu ()
{
	if (mbMissionOver)
	{
		return false;
	} // if

	// Timer bar for appropriate items
	if (mActionMenus [mCurrentAction].mType == ACTIONTYPE_Timer)
	{
		if (mActionButtonHeldTime > 0.0F)
		{	
			return true;
		} // if
	} // if

	// Don't draw if button not held for long enough or no-menu action
	else if (mActionMenus [mCurrentAction].mType == ACTIONTYPE_Menu)
	{
		// Don't draw action menu for door actions if in multiplayer.
		switch( mCurrentAction )
		{
		case ACTION_BreachingDoor:
		case ACTION_DoorInProximity:
		case ACTION_DoorOutOfProximity:
		case ACTION_EntryPointVolume:
			if ( Level.Netmode != NM_Standalone )
			{
				return false;
			}
			break;
		}

		if (mActionButtonHeldTime > 0.0)
		{
			return true;
		} // if
	} // if

	return false;
} // shouldDrawActionMenu

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DrawActionMenu
//
//	Guess what this one draws ?
function DrawActionMenu (SASHUD hud, canvas aCanvas, float left, float top, float size)
{
	local SASPlayerController tPC;
	local float centreX;
	local float centreY;
	local float width;
	local int alpha;
	local float pieSize;
	
	local float fMiddleTopPie;
	local float fMiddleRightPie;
	local array<string> TextWrappedRight,
						TextWrappedLeft,
						TextWrappedTop,
						TextWrappedBottom;
	local int iLength,
				i;
	local float sX,
			sY;

	tPC = GetPlayerController ();

	centreX = left + size / 2;
	centreY = top + size / 2;

	if (aCanvas.ClipX < 1024)
	{
		// Resolution 1 (640/480 and 800/600)
		BRACKET_WIDTH = 191;
		BRACKET_HEIGHT = 103;
		pieSize = 260;
		aCanvas.Font = aCanvas.FontBig14;
	}
	else
	{
		// Resolution 2 (1024/768 and higher)
		BRACKET_WIDTH = 285;
		BRACKET_HEIGHT = 165;
		pieSize = 390;
		aCanvas.Font = aCanvas.FontBig20;
	}

	// Timer bar for defusing bombs or secondary actions
	if (mActionMenus [mCurrentAction].mType == ACTIONTYPE_Timer)
	{
		// Progress bar
		switch ( mCurrentAction )
		{
		case ACTION_SecondaryObjective:
			width = mActionButtonHeldTime / SASSecondaryObjective (mCurrentActionActor).mCompletionTime;
			break;

		case ACTION_BoobyTrap:
			width = mActionButtonHeldTime / SASBoobyTrapDevice (mCurrentActionActor).mDisarmTime;
			break;

		case ACTION_ExplosiveHostage:
			width = mActionButtonHeldTime / SASHostage (mCurrentActionActor).mExplosiveDisarmTime;
			break;

		case ACTION_HandcuffCaptive:
			width = mActionButtonHeldTime / tPC.mSecureCaptiveTime;
			break;
		}

		if (width > 1.0)
		{
			width = 1.0;
		} // if
		
		if(width < 0.0)
		{
			width = 0.0;
		}
		
		aCanvas.SetDrawColor( 255, 255, 255 );
		aCanvas.Style = ERenderStyle.STY_Alpha;
		aCanvas.SetPos( (aCanvas.SizeX/2 - mCasualFull.USize/2), aCanvas.SizeY - 122 );
		mOwnerHUD.DrawMyTile(aCanvas,
						mCasualEmpty,
						(aCanvas.SizeX/2 + mCasualFull.USize/2),
						aCanvas.SizeY - 122,
						(aCanvas.SizeX/2 - mCasualFull.USize/2),
						aCanvas.SizeY - 90,
						(aCanvas.SizeX/2 + mCasualFull.USize/2),
						aCanvas.SizeY - 90,
						0,
						0,
						1,
						0,
						0,
						1,
						1,
						1);
		
	//aCanvas.SetDrawColor (255, 152, 0,230);
		
		
		aCanvas.SetPos( (aCanvas.SizeX/2 - mCasualFull.USize/2), aCanvas.SizeY - 122 );
		mOwnerHUD.DrawMyTile(aCanvas,
						mCasualFull,
						(aCanvas.SizeX/2 - mCasualFull.USize/2) + (mCasualFull.USize)*width,
						aCanvas.SizeY - 122,
						(aCanvas.SizeX/2 - mCasualFull.USize/2),
						aCanvas.SizeY - 90,
						(aCanvas.SizeX/2 - mCasualFull.USize/2) + (mCasualFull.USize)*width,
						aCanvas.SizeY - 90,
						0,
						0,
						1*width,
						0,
						0,
						1,
						1*width,
						1);	
		
		
		
		return;
	} // if

	// Draw action menu if necessary
	
	aCanvas.Style = ERenderStyle.STY_Alpha;
	
	// Alpha in
	if (mActionButtonHeldTime < mActionButtonAlphaTime)
	{
		alpha = int ((255 * mActionButtonHeldTime) / mActionButtonAlphaTime + 0.5);
	} // if
	else
	{
		alpha = 255;
	} // else
	
	
		
	aCanvas.SetDrawColor( 255, 255, 255 );
	aCanvas.Style = ERenderStyle.STY_Alpha;
	//right
	
	if (mCurrentActionSelection != ACTIONOPT_Right)
		DrawLeftRightTopBottom(aCanvas, 1, false, false);
	if (mCurrentActionSelection != ACTIONOPT_Left)
		DrawLeftRightTopBottom(aCanvas, -1, false, false);
	if (mCurrentActionSelection != ACTIONOPT_Default) // top
		DrawLeftRightTopBottom(aCanvas, -1, false, true);
	if (mCurrentActionSelection != ACTIONOPT_Cancel)
		DrawLeftRightTopBottom(aCanvas, 1, false, true);
	
	
		
	/////////////////////////////////////////////////////////////////////////////////////////////		
	
	
	// Then, whichever slice is currently activated has a highlight drawn.
	if (mCurrentActionSelection == ACTIONOPT_Default) // top
		DrawLeftRightTopBottom(aCanvas, -1, true, true);
	else
	if (mCurrentActionSelection == ACTIONOPT_Cancel) // bottom
		DrawLeftRightTopBottom(aCanvas, 1, true, true);
	else
	if (mCurrentActionSelection == ACTIONOPT_Left)
		DrawLeftRightTopBottom(aCanvas, -1, true, false);
	else
	if (mCurrentActionSelection == ACTIONOPT_Right)
		DrawLeftRightTopBottom(aCanvas, 1, true, false);

	switch (mCurrentAction)
	{
		case ACTION_BreachingDoor:
		case ACTION_DoorInProximity:
		case ACTION_DoorOutOfProximity:
		case ACTION_EntryPointVolume:
			DrawDoorActionMenuItems( aCanvas, centreX, centreY, pieSize, alpha, tPC );
			break;

		case ACTION_Hostages:
			DrawUncuffedHostageActionMenuItems( aCanvas, centreX, centreY, pieSize, alpha );
			break;

		case ACTION_HostagesCuffed:
		case ACTION_FollowHostage:
			DrawCuffedHostageActionMenuItems( aCanvas, centreX, centreY, pieSize, alpha );
			break;

		case ACTION_CaptiveTerrorists:
			DrawTerroristActionMenuItems( aCanvas, centreX, centreY, pieSize, alpha );
			break;

		default:
			aCanvas.DrawColor = mTextColour;
			aCanvas.DrawColor.A = alpha;
			//formatting for top
			aCanvas.WrapStringToArray(  mActionMenus [mCurrentAction].mMessages [0], TextWrappedTop, 150, " ");
			aCanvas.StrLen( mActionMenus [mCurrentAction].mMessages [0], sX, sY );
			sy = sy+4;
			iLength = TextWrappedTop.Length;
			for( i = 0;i < iLength; i++ )
			{
				aCanvas.CentreText (TextWrappedTop[i], CentreX , CentreY - (( iLength)* sY/2 - i*sY ) - PieSize / 2 - 30 );
			}
			
			
				//text formatting for right
			//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [2], aCentreX + aPieSize / 2, aCentreY);
			aCanvas.WrapStringToArray( mActionMenus [mCurrentAction].mMessages [2], TextWrappedRight, 150, " ");
			aCanvas.StrLen(mActionMenus [mCurrentAction].mMessages [2], sX, sY );
			sy = sy+4;
			iLength = TextWrappedRight.Length;
			for( i = 0;i < iLength; i++ )
			{
				aCanvas.CentreText (TextWrappedRight[i], CentreX + PieSize / 2, CentreY - (( iLength)* sY/2 - i*sY ) );
			}
			
			//text formatting for left side
			aCanvas.WrapStringToArray( mActionMenus [mCurrentAction].mMessages [1], TextWrappedLeft, 150, " ");
			aCanvas.StrLen( mActionMenus [mCurrentAction].mMessages [1], sX, sY );
			sy = sy+4;
			iLength = TextWrappedLeft.Length;
			for( i = 0;i < iLength; i++ )
			{
				aCanvas.CentreText (TextWrappedLeft[i], CentreX - PieSize / 2, CentreY - (( iLength)* sY/2 - i*sY ) );
			}
			//text formatting for bottom
			//aCanvas.CentreText (mLabelCancel, aCentreX, aCentreY + aPieSize / 2);
			aCanvas.WrapStringToArray(  mOwnerHUD.mLabelCancel, TextWrappedBottom, 150, " ");
			aCanvas.StrLen( mOwnerHUD.mLabelCancel, sX, sY );
			sy = sy+4;
			iLength = TextWrappedBottom.Length;
			for( i = 0;i < iLength; i++ )
			{
				aCanvas.CentreText (TextWrappedBottom[i], CentreX, CentreY - (( iLength)* sY/2 - i*sY ) + 30 + PieSize/2);
			}
			//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [0], centreX, centreY - pieSize / 2);
			//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [1], centreX - pieSize / 2, centreY);
			//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [2], centreX + pieSize / 2, centreY);
			//aCanvas.CentreText (mLabelCancel, centreX, centreY + pieSize / 2);
			break;
	}
} // DrawActionMenu


//////////////////////////////////////////////////////////////////////////////
// DrawHostageActionMenuItems
//
function DrawDoorActionMenuItems(
	Canvas				aCanvas,
	float				aCentreX,
	float				aCentreY,
	float				aPieSize,
	int					aAlpha,
	SASPlayerController	aPC )
{
	local SASPawn	playerPawn;
	
	local array<string> TextWrappedRight,
						TextWrappedLeft,
						TextWrappedTop,
						TextWrappedBottom;
	local int iLength,
				i;
	local float sX,
			sY;
	local string		defaultMessage;
	
	playerPawn = GetPlayerPawn( aPC );

	aCanvas.DrawColor = mTextColour;
	aCanvas.DrawColor.A	= aAlpha;
	
	// HACK: When displaying door in proximity actions - if door is not closed then change
	// default action message to 'close door'.
	if (	mCurrentAction == ACTION_DoorInProximity && 
			(	(SASDoorMover( mCurrentActionActor ).KeyNum != 0) && 
				(SASDoorMover( mCurrentActionActor ).KeyNum >= SASDoorMover( mCurrentActionActor ).PrevKeyNum) ) )
	{
		defaultMessage = mCloseDoorMessage;
	}
	else
	{
		defaultMessage = mActionMenus[mCurrentAction].mMessages [0];
	}

	//text formatting for top
	aCanvas.WrapStringToArray( defaultMessage, TextWrappedTop, 150, " ");
	aCanvas.StrLen( mActionMenus[mCurrentAction].mMessages [0], sX, sY );
	sy = sy+4;
	iLength = TextWrappedTop.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedTop[i], aCentreX , aCentreY - (( iLength)* sY/2 - i*sY ) - aPieSize / 2 );
	}
	//aCanvas.CentreText (mActionMenus[mCurrentAction].mMessages [0], aCentreX, aCentreY - aPieSize / 2);
	
	//text formatting for right
	//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [2], aCentreX + aPieSize / 2, aCentreY);
	aCanvas.WrapStringToArray(  mActionMenus [mCurrentAction].mMessages [2], TextWrappedRight, 150, " ");
	aCanvas.StrLen( mActionMenus [mCurrentAction].mMessages[2], sX, sY );
	sy = sy+4;
	iLength = TextWrappedRight.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedRight[i], aCentreX + aPieSize / 2, aCentreY - (( iLength)* sY/2 - i*sY ) );
	}
	//text formatting for bottom
	//aCanvas.CentreText (mLabelCancel, aCentreX, aCentreY + aPieSize / 2);
	aCanvas.WrapStringToArray(  mOwnerHUD.mLabelCancel, TextWrappedBottom, 150, " ");
	aCanvas.StrLen( mOwnerHUD.mLabelCancel, sX, sY );
	sy = sy+4;
	iLength = TextWrappedBottom.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedBottom[i], aCentreX, aCentreY - (( iLength)* sY/2 - i*sY ) + aPieSize/2);
	}

	// Grenade asasult only available if player has a grenade.
	if ( playerPawn == None || !playerPawn.HasAGrenade() )
	{
		aCanvas.DrawColor = mGreyedOutColour;
		aCanvas.DrawColor.A	= aAlpha;
	}
	
	
	//text formatting for left side
	aCanvas.WrapStringToArray(  mActionMenus[mCurrentAction].mMessages [1], TextWrappedLeft, 150, " ");
	aCanvas.StrLen( mActionMenus[mCurrentAction].mMessages [1], sX, sY );
	sy = sy+4;
	iLength = TextWrappedLeft.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedLeft[i], aCentreX - aPieSize / 2, aCentreY - (( iLength)* sY/2 - i*sY ) );
	}
	
}


//////////////////////////////////////////////////////////////////////////////
// DrawUncuffedHostageActionMenuItems
//
function DrawUncuffedHostageActionMenuItems(
	Canvas	aCanvas,
	float	aCentreX,
	float	aCentreY,
	float	aPieSize,
	int		aAlpha )
{
	local SASHostage	hostage;
	local array<string> TextWrappedRight,
						TextWrappedLeft,
						TextWrappedTop,
						TextWrappedBottom;
	local int			iLength,
						i;
	local float			sX,
						sY;

	hostage = SASHostage( mCurrentActionActor );
	if ( hostage == None )
	{
		return;
	}
	
	// All commands are 'get down' related - if not orderable down then grey out the text.
	if ( hostage.CanBeOrdered( HOSTAGEORDER_GetDown ) )
	{
		aCanvas.DrawColor = mTextColour;
	}
	else
	{
		aCanvas.DrawColor = mGreyedOutColour;
	}
	aCanvas.DrawColor.A = aAlpha;
	
		//text formatting for top
	aCanvas.WrapStringToArray(  mActionMenus[mCurrentAction].mMessages [0], TextWrappedTop, 150, " ");
	aCanvas.StrLen( mActionMenus[mCurrentAction].mMessages [0], sX, sY );
	sy = sy+4;
	iLength = TextWrappedTop.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedTop[i], aCentreX , aCentreY - (( iLength)* sY/2 - i*sY ) - aPieSize / 2 );
	}
	//aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [0], aCentreX, aCentreY - aPieSize / 2 );
	
	//text formatting for left side
	aCanvas.WrapStringToArray(  mActionMenus[mCurrentAction].mMessages [1], TextWrappedLeft, 150, " ");
	aCanvas.StrLen( mActionMenus[mCurrentAction].mMessages [1], sX, sY );
	sy = sy+4;
	iLength = TextWrappedLeft.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedLeft[i], aCentreX - aPieSize / 2, aCentreY - (( iLength)* sY/2 - i*sY ) );
	}
	
	//text formatting for right
	//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [2], aCentreX + aPieSize / 2, aCentreY);
	aCanvas.WrapStringToArray(  mActionMenus [mCurrentAction].mMessages [2], TextWrappedRight, 150, " ");
	aCanvas.StrLen( mActionMenus [mCurrentAction].mMessages[2], sX, sY );
	sy = sy+4;
	iLength = TextWrappedRight.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedRight[i], aCentreX + aPieSize / 2, aCentreY - (( iLength)* sY/2 - i*sY ) );
	}
	//aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [1], aCentreX - aPieSize / 2, aCentreY );
	
	//aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [2], aCentreX + aPieSize / 2, aCentreY );

	// Bottom pie quarter = 'Cancel'
	aCanvas.DrawColor = mTextColour;
	aCanvas.DrawColor.A = aAlpha;
	//text formatting for bottom
	//aCanvas.CentreText (mLabelCancel, aCentreX, aCentreY + aPieSize / 2);
	aCanvas.WrapStringToArray(  mOwnerHUD.mLabelCancel, TextWrappedBottom, 150, " ");
	aCanvas.StrLen( mOwnerHUD.mLabelCancel, sX, sY );
	sy = sy+4;
	iLength = TextWrappedBottom.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedBottom[i], aCentreX, aCentreY - (( iLength)* sY/2 - i*sY ) + 30 + aPieSize/2);
	}
	
	//aCanvas.CentreText( mLabelCancel, aCentreX, aCentreY + aPieSize / 2 );
}

//////////////////////////////////////////////////////////////////////////////
// DrawCuffedHostageActionMenuItems
//
function DrawCuffedHostageActionMenuItems(
	Canvas	aCanvas,
	float	aCentreX,
	float	aCentreY,
	float	aPieSize,
	int		aAlpha )
{
	local SASHostage	hostage;
	
	local array<string> TextWrappedRight,
						TextWrappedLeft,
						TextWrappedTop,
						TextWrappedBottom;
	local int iLength,
				i;
	local float sX,
			sY;

	hostage = SASHostage( mCurrentActionActor );
	if ( hostage == None )
	{
		return;
	}
	
	// All commands are 'follow' related - if not orderable down then grey out the text.
	if ( hostage.CanBeOrdered( HOSTAGEORDER_Follow ) )
	{
		aCanvas.DrawColor = mTextColour;
	}
	else
	{
		aCanvas.DrawColor = mGreyedOutColour;
	}
	aCanvas.DrawColor.A = aAlpha;
	
		//text formatting for top
	aCanvas.WrapStringToArray(  mActionMenus[mCurrentAction].mMessages [0], TextWrappedTop, 200, "\n");
	aCanvas.StrLen( mActionMenus[mCurrentAction].mMessages [0], sX, sY );
	sy = sy+4;
	iLength = TextWrappedTop.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedTop[i], aCentreX , aCentreY - (( iLength)* sY/2 - i*sY ) - aPieSize / 2 );
	}
	//aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [0], aCentreX, aCentreY - aPieSize / 2 );
	
	
	//text formatting for left side
	aCanvas.WrapStringToArray(  mActionMenus[mCurrentAction].mMessages [1], TextWrappedLeft, 150, " ");
	aCanvas.StrLen( mActionMenus[mCurrentAction].mMessages [1], sX, sY );
	sy = sy+4;
	iLength = TextWrappedLeft.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedLeft[i], aCentreX - aPieSize / 2, aCentreY - (( iLength)* sY/2 - i*sY ) );
	}
	
			//text formatting for right
	//aCanvas.CentreText (mActionMenus [mCurrentAction].mMessages [2], aCentreX + aPieSize / 2, aCentreY);
	aCanvas.WrapStringToArray(  mActionMenus [mCurrentAction].mMessages [2], TextWrappedRight, 150, " ");
	aCanvas.StrLen( mActionMenus [mCurrentAction].mMessages[2], sX, sY );
	sy = sy+4;
	iLength = TextWrappedRight.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedRight[i], aCentreX + aPieSize / 2, aCentreY - (( iLength)* sY/2 - i*sY ) );
	}
	//aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [1], aCentreX - aPieSize / 2, aCentreY );
	
	//aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [2], aCentreX + aPieSize / 2, aCentreY );

	// Bottom pie quarter = 'Cancel'
	aCanvas.DrawColor = mTextColour;
	aCanvas.DrawColor.A = aAlpha;
	//text formatting for bottom
	//aCanvas.CentreText (mLabelCancel, aCentreX, aCentreY + aPieSize / 2);
	aCanvas.WrapStringToArray(  mOwnerHUD.mLabelCancel, TextWrappedBottom, 150, " ");
	aCanvas.StrLen( mOwnerHUD.mLabelCancel, sX, sY );
	sy = sy+4;
	iLength = TextWrappedBottom.Length;
	for( i = 0;i < iLength; i++ )
	{
		aCanvas.CentreText (TextWrappedBottom[i], aCentreX, aCentreY - (( iLength)* sY/2 - i*sY ) + 30 + aPieSize/2);
	}
	
	//aCanvas.CentreText( mLabelCancel, aCentreX, aCentreY + aPieSize / 2 );
}


//////////////////////////////////////////////////////////////////////////////
// DrawTerroristActionMenuItems
//
function DrawTerroristActionMenuItems(
	Canvas	aCanvas,
	float	aCentreX,
	float	aCentreY,
	float	aPieSize,
	int		aAlpha )
{
	local SASTerrorist			terrorist;

	terrorist = SASTerrorist( mCurrentActionActor );
	if ( terrorist == None )
	{
		return;
	}

	aCanvas.DrawColor = mTextColour;
	aCanvas.DrawColor.A = aAlpha;

	// Top pie quarter = 'Get down'
	aCanvas.CentreText( mActionMenus[mCurrentAction].mMessages [0], aCentreX, aCentreY - aPieSize / 2 );

	// Bottom pie quarter = 'Cancel'
	aCanvas.CentreText( mOwnerHUD.mLabelCancel, aCentreX, aCentreY + aPieSize / 2 );
}


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DrawActionIcon
//
function DrawActionIcon (SASHUD hud, canvas aCanvas, float left, float top, float size)
{
	if (	(	(mCurrentAction == ACTION_BreachingDoor) || 
				(mCurrentAction == ACTION_DoorOutOfProximity) ||
				(mCurrentAction == ACTION_EntryPointVolume) ) &&
			mNotEnoughSquadForAssault )
	{
		hud.SetDarkOrangeColour( aCanvas );
	} // if
	else
	{
		hud.SetOrangeColour( aCanvas );
	} // else

	if (mActionIconTextures [mCurrentAction] != None)
	{
		aCanvas.SetPos (left, top);
		aCanvas.DrawTileClipped (
			mActionIconTextures [mCurrentAction],
			size, size,
			0, 0,
			mActionIconTextures [mCurrentAction].USize, mActionIconTextures [mCurrentAction].VSize
			);
	} // if

	switch (mCurrentAction)
	{
		// Draw red line through assault modes when too many squad members are dead
		case ACTION_BreachingDoor :
		case ACTION_DoorOutOfProximity :
		case ACTION_EntryPointVolume:
			if (mNotEnoughSquadForAssault)
			{
				aCanvas.SetDrawColor (255, 0, 0);
				aCanvas.SetPos (left, top + size / 2);
				aCanvas.DrawHorizontal (top + size / 2, size);
			} // if
			break;
	} // switch
} // DrawActionIcon


function Reset()
{
	mCurrentAction			= ACTION_None;
	mCurrentActionActor		= None;
	mActionButtonHeldTime	= 0.0;
	mLastCloseCombatTarget  = None;
}

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION UpdateActionMenu
//
function UpdateActionMenu (float timeDelta)
{
	local SASPlayerController	pc;
	local EActionButtonAction	newAction;
	local SASPawn				cuffingPawn;

	if (mbMissionOver)
	{
		return;
	}

	// get handle to local player
	pc = GetPlayerController();	
	if ( pc == None )
	{
		return;
	}

	// If cuffing a cative last frame, remeber who it is so can notify
	// that cuffing has been interupted if action changes in DetermineHighestPriorityAction.
	if (	(mCurrentAction == ACTION_HandcuffCaptive) &&
			(mCurrentActionActor != None) &&
			(mActionButtonHeldTime > 0.0) )
	{
		cuffingPawn = SASPawn( mCurrentActionActor );
	}

	// Determine the highest priority action. 
	newAction = DetermineHighestPriorityAction ();

	// If we were, but aren't now cuffing a captive - let them know.
	if (	(cuffingPawn != None) &&
				(	(mCurrentAction != ACTION_HandcuffCaptive) ||
					(mCurrentActionActor != cuffingPawn) ||
					(pc.bAction == 0)) )
	{
		pc.ServerHandcuffCaptiveStop( cuffingPawn );
	}

	// Check to see if we have enough squad left for room assaults
	if (	(mNotEnoughSquadForAssault == false) && 
			((Level.NetMode != NM_Standalone) || (pc.mSquadManager == None) || (pc.mSquadManager.GetNumLiveSquadMembers () <= 2)) )
	{
		mNotEnoughSquadForAssault = true;

		// Remove the menus from door assault options
		mActionMenus [1].mType = ACTIONTYPE_NoMenu;
		mActionMenus [2].mType = ACTIONTYPE_NoMenu;
		mActionMenus [3].mType = ACTIONTYPE_NoMenu;
		mActionMenus [4].mType = ACTIONTYPE_NoMenu;
	} // if

	// Can't change action if button is currently held down
	if (newAction != mCurrentAction && mActionButtonHeldTime > 0)
	{
		mCurrentAction = ACTION_None;
	} // if
	else
	{
		mCurrentAction = newAction;
	} // else

	// Action button up
	if (pc.bAction == 0)
	{
		// If we've held button for short period of time and then release it, activate selected action
		if (mActionButtonHeldTime > 0)
		{
			// Activate selected action
			pc.ExitActionMenu ();
			if ( mActionMenus [mCurrentAction].mType != ACTIONTYPE_Timer )
			{
				ActionActivate (timeDelta);
			}
		} // if
		else
		{
			mCurrentActionSelection = ACTIONOPT_Default;
		} // else

		mActionButtonHeldTime = 0;
	} // if

	// Action button down
	else
	{
		if (mActionMenus [mCurrentAction].mType == ACTIONTYPE_Menu)
		{
			pc.ActivateActionMenu ();
		} // if
		mActionButtonHeldTime += timeDelta;

		// Timer activated actions
		switch ( mCurrentAction )
		{
		case ACTION_SecondaryObjective:
			DoActionSecondaryObjective (timeDelta);
			break;

		case ACTION_BoobyTrap:
			DoActionBoobyTrap (timeDelta);
			break;

		case ACTION_ExplosiveHostage:
			DoActionExplosiveHostage(timeDelta);
			break;

		case ACTION_HandcuffCaptive:
			DoActionSecureCaptive(timeDelta);
			break;

		}
	} // else
} // UpdateActionMenu


function bool IsTimedActionActive(
	EActionButtonAction	aeAction )
{
	// Passed in action must be a timed action.
	if ( mActionMenus[aeAction].mType != ACTIONTYPE_Timer )
	{
		return false;
	}

	// Check current action is checking action and action button is being held
	if ( mCurrentAction != aeAction || mActionButtonHeldTime == 0.0 )
	{
		return false;
	}

	return true;
}

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION ActionActivate
//
// Activate current highest priority action
//
function ActionActivate (float timeDelta)
{
	if (mbMissionOver)
	{
		return;
	} // if

	// Global cancel option
	if (mActionMenus [mCurrentAction].mType == ACTIONTYPE_Menu && mCurrentActionSelection == ACTIONOPT_Cancel)
	{
		return;
	} // if

	switch (mCurrentAction)
	{
		case ACTION_CloseCombat :
			DoActionCloseCombat ();
			break;

		case ACTION_BreachingDoor :
			DoActionBreachDoor ();
			break;

		case ACTION_DoorInProximity :
			DoActionDoorInProximity ();
			break;

		case ACTION_DoorOutOfProximity :
			DoActionDoorOutOfProximity ();
			break;

		case ACTION_EntryPointVolume:
			DoActionEntryPointVolume();
			break;

		case ACTION_BoobyTrap :
			//DoActionBoobyTrap (timeDelta);
			break;

		case ACTION_SecondaryObjective :
			//DoActionSecondaryObjective (timeDelta);
			break;

		case ACTION_Hostages :
			DoActionHostages ();
			break;

		case ACTION_HostagesCuffed:
			DoActionCuffedHostages();
			break;

		case ACTION_FollowHostage :
			DoActionFollowHostages ();
			break;

		case ACTION_ExplosiveHostage:
			//DoActionExplosiveHostage(timeDelta);
			break;

		case ACTION_HandcuffCaptive:
			//DoActionSecureCaptive(timeDelta);
			break;

		case ACTION_Wall :
			DoActionWall ();
			break;

		case ACTION_PickupWeapon :
			DoActionPickupWeapon ();
			break;

		case ACTION_StandingOrder :
			DoActionStandingOrder ();
			break;

		case ACTION_CaptiveTerrorists:
			DoActionCaptiveTerrorists();
			break;
	} // switch

	mCurrentActionSelection = ACTIONOPT_Default;
} // ActionActivate

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionCloseCombat
//
function DoActionCloseCombat ()
{
	local SASPlayerController	pc;
	local SASPawn				p,
								playerPawn;

	// Identify the controller of the person we've hit
	p = SASPawn (mCurrentActionActor);
	if (p == None)
	{
		Warn ("WARNING : DoActionCloseCombat - (" $mCurrentActionActor$ ") isn't a pawn");
		return;
	} // if

	pc = GetPlayerController();
	playerPawn = GetPlayerPawn( pc );

	// Play first person anim.
	SASFighter( playerPawn ).PlayPunch( p );
} // DoActionCloseCombat

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionBreachDoor
//
// Set off door breaching squad AI
//
function DoActionBreachDoor ()
{
	local SASEntryPoint			EP;
	local SASDoorMover			door;
	local SASPlayerController	pc;
	local SASPawn				playerPawn;

	pc = GetPlayerController();
	playerPawn = GetPlayerPawn( pc );

	door = SASDoorMover( mCurrentActionActor );
	if ( door == None )
	{
		Warn ("WARNING : DoActionBreachDoor - (" $mCurrentActionActor$ ") isn't a door");
		return;
	} // if

	if ( door.myMarker != None )
	{
		EP = SASEntryPoint( door.myMarker );
	}

	// Cant breach doors without an EP.
	if ( EP == None )
	{
		Warn ("WARNING : DoActionBreachDoor - (" $mCurrentActionActor$ ") doesn't have a linked EP.");
		return;
	}

	switch (mCurrentActionSelection)
	{
		case ACTIONOPT_Default :
			// Nothing happens here
			break;

		case ACTIONOPT_Left :
			// Grenade assault - only if player has a grenade available
			if ( !playerPawn.HasAGrenade() )
			{
				return;
			}
			pc.mSquadManager.doRoomAssault (EP, true, true);
			door.TriggerAssaultEvent ( pc.Pawn );
			break;

		case ACTIONOPT_Right :
			pc.mSquadManager.doRoomAssault (EP, true, false);
			door.TriggerAssaultEvent ( pc.Pawn );
			break;

		default :
			Warn ("WARNING - DoActionBreachDoor - unknown option (" $mCurrentActionSelection$ ")");
			break;
	} // switch
} // DoActionBreachDoor

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionDoorInProximity
//
// Open door or alternatively set off room assault AI
//
function DoActionDoorInProximity ()
{
	local SASEntryPoint			EP;
	local SASDoormover			door;
	local SASPlayerController	pc;
	local SASPawn				playerPawn;

	pc = GetPlayerController();
	playerPawn = GetPlayerPawn( pc );

	door = SASDoorMover( mCurrentActionActor );
	if ( door == None )
	{
		Warn ("WARNING : DoActionDoorInProximity - (" $mCurrentActionActor$ ") isn't a door");
		return;
	}

	if ( door.myMarker != None )
	{
		EP = SASEntryPoint( door.myMarker );
	}

	switch (mCurrentActionSelection)
	{
		case ACTIONOPT_Default :
			if ( pc != None && door != None )
			{
				pc.OpenCloseDoor( door );
				door.TriggerOpenEvent( pc.Pawn );
			}
			break;

		case ACTIONOPT_Left :
			if ( EP != None )
			{
				if ( !playerPawn.HasAGrenade() )
				{
					return;
				}
				pc.mSquadManager.doRoomAssault ( EP, false, true );
				door.TriggerAssaultEvent ( pc.Pawn );
			}
			else
			{
				Warn ("WARNING : DoActionDoorOutOfProximity - (" $mCurrentActionActor$ ") doesn't link to an EP - can't assault door.");
			}
			break;

		case ACTIONOPT_Right :
			if ( EP != None )
			{
				pc.mSquadManager.doRoomAssault ( EP, false, false);
				door.TriggerAssaultEvent ( pc.Pawn );
			}
			else
			{
				Warn ("WARNING : DoActionDoorOutOfProximity - (" $mCurrentActionActor$ ") doesn't link to an EP - can't assault door.");
			}
			break;

		default :
			Warn ("WARNING - DoActionDoorInProximity - unknown option (" $mCurrentActionSelection$ ")");
			break;
	} // switch
} // DoActionDoorInProximity

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionDoorOutOfProximity
//
// Set off room assault AI
//
function DoActionDoorOutOfProximity ()
{
	local SASEntryPoint			EP;
	local SASDoorMover			door;
	local SASPlayerController	pc;
	local SASPawn				playerPawn;

	pc = GetPlayerController();
	playerPawn = GetPlayerPawn( pc );

	door = SASDoorMover( mCurrentActionActor );
	if ( door == None )
	{
		Warn ("WARNING : DoActionDoorOutOfProximity - (" $mCurrentActionActor$ ") isn't a door");
		return;
	}

	if ( door.myMarker != None )
	{
		EP = SASEntryPoint( door.myMarker );
	}

	if ( EP == None )
	{
		Warn ("WARNING : DoActionDoorOutOfProximity - (" $mCurrentActionActor$ ") doesn't link to an EP");
		return;
	}

	switch (mCurrentActionSelection)
	{
		case ACTIONOPT_Default :
			// Nothing happens here
			break;

		case ACTIONOPT_Left :
			if ( !playerPawn.HasAGrenade() )
			{
				return;
			}
			pc.mSquadManager.doRoomAssault ( EP, false, true);
			if ( door != None )
			{
				door.TriggerAssaultEvent ( pc.Pawn );
			}
			break;

		case ACTIONOPT_Right :
			pc.mSquadManager.doRoomAssault ( EP, false, false);
			if ( door != None )
			{
				door.TriggerAssaultEvent ( pc.Pawn );
			}
			break;

		default :
			Warn ("WARNING - DoActionDoorOutOfProximity - unknown option (" $mCurrentActionSelection$ ")");
			break;
	} // switch
} // DoActionDoorOutOfProximity


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionEntryPointVolume
//
// Set off room assault AI using an entry point volume rather than a door.
//
function DoActionEntryPointVolume()
{	
	local SASEntryPoint			EP;
	local SASDoorMover			door;
	local SASPlayerController	PC;
	local SASPawn				playerPawn;

	PC = GetPlayerController();
	playerPawn = GetPlayerPawn( pc );

	EP = SASEntryPoint( mCurrentActionActor );
	if ( EP == None )
	{
		Warn ("WARNING : DoActionEntryPointVolume - (" $mCurrentActionActor$ ") isn't an EP");
		return;
	}

	// See if this EP has a door.
	if ( EP.MyDoor != None )
	{
		door = SASDoorMover( EP.MyDoor );
	}

	switch ( mCurrentActionSelection )
	{
	case ACTIONOPT_Default :
		// Nothing happens here
		break;

	case ACTIONOPT_Left :
		if ( !playerPawn.HasAGrenade() )
		{
			return;
		}
		pc.mSquadManager.doRoomAssault( EP, false, true );
		if ( door != None )
		{
			door.TriggerAssaultEvent( pc.Pawn );
		}
		break;

	case ACTIONOPT_Right :
		pc.mSquadManager.doRoomAssault( EP, false, false );
		if ( door != None )
		{
			door.TriggerAssaultEvent( pc.Pawn );
		}
		break;

	default :
		Warn ("WARNING - DoActionEntryPointVolume - unknown option (" $mCurrentActionSelection$ ")");
		break;
	}
}

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionBoobyTrap
//
// Defuse booby trap
//
function DoActionBoobyTrap (float timeDelta)
{
	local SASPlayerController	pc;
	local SASBoobyTrapDevice	bt;

	pc = GetPlayerController();
	bt = SASBoobyTrapDevice( mCurrentActionActor );

	if ( pc == None || bt == None )
	{
		return;
	} 

	if( pc.mBoobyTrapDevice != None )
	{
		if( pc.mBoobyTrapDevice.mDisarmingSoundTime <= 0 )
		{
			pc.mBoobyTrapDevice.mDisarmingSoundTime = pc.mBoobyTrapDevice.mDisarmingSoundRepeatTime;
			if(pc.mBoobyTrapDevice.mDisarmingSound!=None)
			{
				pc.mBoobyTrapDevice.PlaySound(pc.mBoobyTrapDevice.mDisarmingSound,,pc.mBoobyTrapDevice.mDisarmingSoundVolume,,pc.mBoobyTrapDevice.mDisarmingSoundRadius);
			}
		}
		pc.mBoobyTrapDevice.mDisarmingSoundTime -= timeDelta;
	}

	// Ensure player controller is in disarm state.
	pc.GotoLatentActionButtonState( ACTION_BoobyTrap );

	if ( mActionButtonHeldTime > bt.mDisarmTime )
	{
		pc.BoobyTrapDisarmed();
	} 
} // DoActionBoobyTrap

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionSecondaryObjective
//
// Secondary objective AI
//
function DoActionSecondaryObjective (float timeDelta)
{
	local SASSecondaryObjective so;
	local SASPlayerController	pc;

	so = SASSecondaryObjective (mCurrentActionActor);

	if (so == None || so.isCompleted () == true)
	{
		return;
	} // if

	pc = GetPlayerController();

	// Ensure player controller is in latend action button state.
	pc.GotoLatentActionButtonState( ACTION_SecondaryObjective );

	if( so.mProcessingSoundTime <= 0 )
	{
		so.mProcessingSoundTime = so.mProcessingSoundRepeatTime;
		if(so.mProcessingSound!=None)
		{
			so.PlaySound(so.mProcessingSound,,so.mProcessingSoundVolume,,so.mProcessingSoundRadius);
		}
	}
	so.mProcessingSoundTime -= timeDelta;

	if (mActionButtonHeldTime > so.mCompletionTime)
	{
		pc.ServerCompleteSecondaryObjective( so );
	}
} // DoActionSecondaryObjective


//////////////////////////////////////////////////////////////////////////////
// DoActionHostages
//
// Order hostages about.
function DoActionHostages()
{
	local SASPlayerController	pc;

	pc = GetPlayerController();

	switch ( mCurrentActionSelection )
	{
		case ACTIONOPT_Default:
			if ( SASHostage( mCurrentActionActor ) != None )
			{
				pc.ServerOrderHostageDown( SASHostage( mCurrentActionActor ) );
			}
			break;

		case ACTIONOPT_Left :
			if ( SASHostage( mCurrentActionActor ) != None )
			{
				pc.ServerOrderRadiusHostagesDown();
			}
			break;

		case ACTIONOPT_Right:
			break;

		default:
			Warn ("WARNING - DoActionHostages - unknown option(" $mCurrentActionSelection$ ")");
			break;
	}
}

//////////////////////////////////////////////////////////////////////////////
// DoActionCuffedHostages
//
// Order hostages about.
function DoActionCuffedHostages()
{
	local SASPlayerController	pc;

	pc = GetPlayerController();

	switch ( mCurrentActionSelection )
	{
		case ACTIONOPT_Default:
			if ( SASHostage( mCurrentActionActor ) != None )
			{
				pc.ServerOrderHostageFollow( SASHostage( mCurrentActionActor ), true );
			}
			break;

		case ACTIONOPT_Left :
			pc.ServerOrderRadiusHostagesFollow( true );
			break;

		case ACTIONOPT_Right:
			break;

		default:
			Warn ("WARNING - DoActionHostages - unknown option(" $mCurrentActionSelection$ ")");
			break;
	}
}


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoActionFollowHostages
//
// Give orders to hostage following me
//
function DoActionFollowHostages()
{
	local SASPlayerController	pc;

	pc = GetPlayerController();

	switch ( mCurrentActionSelection )
	{
		case ACTIONOPT_Default:
			if ( SASHostage( mCurrentActionActor ) != None )
			{
				//pc.ServerOrderHostageDown( SASHostage( mCurrentActionActor ) );
				pc.ServerOrderHostageFollow( SASHostage( mCurrentActionActor ), false );
			}
			break;

		case ACTIONOPT_Left:
			if ( SASHostage( mCurrentActionActor ) != None )
			{
				pc.ServerOrderRadiusHostagesFollow( false );
			}
			break;

		case ACTIONOPT_Right:
			//pc.ServerOrderRadiusHostagesFollow( false );
			break;

		default:
			Warn ("WARNING - DoActionFollowHostages - unknown option(" $mCurrentActionSelection$ ")");
			break;
	}
}


//////////////////////////////////////////////////////////////////////////////
// DoActionCaptiveTerrorists
//
function DoActionCaptiveTerrorists()
{
	local SASPlayerController	pc;

	pc = GetPlayerController();

	switch ( mCurrentActionSelection )
	{
		case ACTIONOPT_Default:
			if ( SASTerrorist( mCurrentActionActor ) != None )
			{
				pc.ServerOrderTerroristDown( SASTerrorist( mCurrentActionActor ) );
			}
			break;

		default:
			Warn( "WARNING - DoActionCaptiveTerrorists - unknown option ("$mCurrentActionSelection$")" );
			break;
	}
}

//////////////////////////////////////////////////////////////////////////////
// DoActionExplosiveHostage
// 
function DoActionExplosiveHostage(float timeDelta)
{
	local SASPlayerController	pc;
	local SASHostage			hostage;

	pc = GetPlayerController();
	hostage = SASHostage( mCurrentActionActor );

	if ( pc == None || hostage == None )
	{
		return;
	} 

	// Ensure player controller is in latend action button state.
	pc.GotoLatentActionButtonState( ACTION_ExplosiveHostage );

	if( mDefusingHostageSoundTime <= 0 )
	{
		mDefusingHostageSoundTime = mDefusingHostageSoundRepeatTime;
		if(mDefusingHostageSound!=None)
		{
			Hostage.PlaySound(mDefusingHostageSound,,mDefusingHostageSoundVolume,,mDefusingHostageSoundRadius);
		}
	}
	mDefusingHostageSoundTime -= timeDelta;

	if ( mActionButtonHeldTime > hostage.mExplosiveDisarmTime )
	{
		if(mDefusedHostageSound!=None)
		{
			Hostage.PlaySound(mDefusedHostageSound,,mDefusedHostageVolume,,mDefusedHostageRadius);
		}
		pc.ServerDisarmHostage( hostage );
	} 
}

//////////////////////////////////////////////////////////////////////////////
// DoActionSecureCaptive
// 
function DoActionSecureCaptive(float timeDelta)
{
	local SASPlayerController	pc;
	local SASPawn				captivePawn;

	pc = GetPlayerController();
	captivePawn = SASPawn( mCurrentActionActor );

	if ( pc == None || captivePawn == None )
	{
		return;
	} 

	// Ensure player controller is in latend action button state.
	pc.GotoLatentActionButtonState( ACTION_HandcuffCaptive );

	if( mHandcuffingSoundTime <= 0 )
	{
		mHandcuffingSoundTime = mHandcuffingSoundRepeatTime;
		if(mHandcuffingSound!=None)
		{
			captivePawn.PlaySound(mHandcuffingSound,,mHandcuffingSoundVolume,,mHandcuffingSoundRadius);
		}
	}
	mHandcuffingSoundTime -= timeDelta;

	// Let pawn know its being cuffed.

	if ( !captivePawn.mbCuffingStarted )
	{
		pc.ServerHandcuffCaptiveStart( captivePawn );
	}

	if ( mActionButtonHeldTime > pc.mSecureCaptiveTime )
	{
		if(mHandcuffedSound!=None)
		{
			captivePawn.PlaySound(mHandcuffedSound,,mHandcuffedSoundVolume,,mHandcuffedSoundRadius);
		}

		// Complete cuffing.
		pc.ServerHandcuffCaptiveComplete( captivePawn );
	} 
}

//////////////////////////////////////////////////////////////////////////////
// DoActionWall
//
// Climb wall
function DoActionWall()
{
	local SASPlayerController pc;

	pc = GetPlayerController();
	if ( (pc != None) && (mCurrentActionActor != None) )
	{	
		pc.ServerDoClimbing( SASPlayerClimbVolume( mCurrentActionActor ) );
	}
}

//////////////////////////////////////////////////////////////////////////////
// DoActionPickupWeapon
//
// Optional weapon pickup
function DoActionPickupWeapon()
{
	local SASPlayerController pc;
	local SASPickup spu;

	// Paranoia checks
	if (mCurrentActionActor == None)
	{
		Warn ("WARNING - DoActionPickupWeapon - current actor is None");
		return;
	} // if

	spu = SASPickup (mCurrentActionActor);
	if (spu == None)
	{
		Warn ("WARNING - DoActionPickupWeapon - pickup " $spu$ " is not SASPickup");
		return;
	} // if

	pc = GetPlayerController ();
	if ( pc != None )
	{
		pc.PickupWeapon( spu );
	}
}


//////////////////////////////////////////////////////////////////////////////
// DoActionStandingOrder
//
// Call 'Clear' or 'Need Backup' depending on circumstance
function DoActionStandingOrder()
{
	local SASPlayerController	pc;
	local SASPawn				playerPawn;

	pc = GetPlayerController();
	if ( pc == None || pc.mSquadManager == None )
	{
		return;
	}
	playerPawn = GetPlayerPawn( pc );
	if ( playerPawn == None )
	{
		return;
	}

	// Now we get backup regardless of whether or not we have enemies.
	pc.mSquadManager.callForBackup ();
	
	// However, the speech sample played changes depending on if we can see a terrorist
	if ( pc.mSquadManager.mNumSquadThreats > 0 )
	{
		playerPawn.PlaySpeech( SPEECH_SquadNeedBackup );
	} // if
	else
	{
		if ( pc.mSquadManager.mPlayerVolume != None && pc.mSquadManager.mPlayerVolume.mLargeVolume == false)
		{
			playerPawn.PlaySpeech( SPEECH_SquadClear);
		} // if
		else
		{
			playerPawn.PlaySpeech( SPEECH_SquadLargeVolumeClear);
		} // else
		if ( pc.mSquadManager != None )
		{
			pc.mSquadManager.ClearedRoom (SASSoldier( playerPawn ));
		}
	}
}


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION ActionSelect
//
function ActionSelect (int select)
{
	mCurrentActionSelection = eActionOptions (select);
} // ActionSelect

//////////////////////////////////////////////////////////////////////////////
//
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionButtonAlphaTime=0.5000000
    mHUDPieTexture=Texture'HUDTx.ActionPie.HUD_OptionsPie'
    mBlankTexture=Texture'Engine.WhiteSquareTexture'
    mCasualFull=Texture'HUDTx.Elements.HUD_CasualFull'
    mCasualEmpty=Texture'HUDTx.Elements.HUD_CasualEmpty'
    mActionIconTextures[0]=Texture'HUDTx.ActionIcons.ActionIcon_CloseCombat'
    mActionIconTextures[1]=Texture'HUDTx.ActionIcons.ActionIcon_LockedDoor'
    mActionIconTextures[2]=Texture'HUDTx.ActionIcons.ActionIcon_Door'
    mActionIconTextures[3]=Texture'HUDTx.ActionIcons.ActionIcon_DoorAction'
    mActionIconTextures[4]=Texture'HUDTx.ActionIcons.ActionIcon_DoorAction'
    mActionIconTextures[5]=Texture'HUDTx.ActionIcons.ActionIcon_Booby'
    mActionIconTextures[6]=Texture'HUDTx.ActionIcons.ActionIcon_2nd'
    mActionIconTextures[7]=Texture'HUDTx.ActionIcons.ActionIcon_Hostage'
    mActionIconTextures[8]=Texture'HUDTx.ActionIcons.ActionIcon_Hostage'
    mActionIconTextures[9]=Texture'HUDTx.ActionIcons.ActionIcon_Hostage'
    mActionIconTextures[10]=Texture'HUDTx.ActionIcons.ActionIcon_Booby'
    mActionIconTextures[11]=Texture'HUDTx.ActionIcons.ActionIcon_Handcuffs'
    mActionIconTextures[12]=Texture'HUDTx.ActionIcons.ActionIcon_Climb'
    mActionIconTextures[13]=Texture'HUDTx.ActionIcons.ActionIcon_Weapon'
    mActionIconTextures[14]=Texture'HUDTx.ActionIcons.ActionIcon_Hostage'
    mActionIconText[0]="Close Combat"
    mActionIconText[1]="Breaching Door"
    mActionIconText[2]="Door in Proximity"
    mActionIconText[3]="Door out of Proximity"
    mActionIconText[4]="Assault"
    mActionIconText[5]="Booby Trap"
    mActionIconText[6]="Secondary Objective"
    mActionIconText[7]="Hostages"
    mActionIconText[8]="Hostages"
    mActionIconText[9]="Following Hostage"
    mActionIconText[10]="Explosive Hostage"
    mActionIconText[11]="Secure Captive"
    mActionIconText[12]="Wall"
    mActionIconText[13]="Weapon Pickup"
    mActionIconText[14]="Captive Terrorists"
    mActionIconText[15]="Standing Order"
    mActionIconText[16]="[None]"
    mCloseDoorMessage="Close Door"
    mCurrentAction=16
    mActionMenus[0]=(mAction=0,mType=2,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[1]=(mAction=1,mType=0,mMessages="",mMessages[1]="Grenade Assault",mMessages[2]="Assault")
    mActionMenus[2]=(mAction=2,mType=0,mMessages="Open Door",mMessages[1]="Grenade Assault",mMessages[2]="Assault")
    mActionMenus[3]=(mAction=3,mType=0,mMessages="",mMessages[1]="Grenade Assault",mMessages[2]="Assault")
    mActionMenus[4]=(mAction=4,mType=0,mMessages="",mMessages[1]="GrenadeAssault",mMessages[2]="Assault")
    mActionMenus[5]=(mAction=5,mType=1,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[6]=(mAction=6,mType=1,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[7]=(mAction=7,mType=0,mMessages="Get On Floor",mMessages[1]="All Get On Floor",mMessages[2]="")
    mActionMenus[8]=(mAction=8,mType=0,mMessages="You Follow Me",mMessages[1]="All Follow Me",mMessages[2]="")
    mActionMenus[9]=(mAction=9,mType=0,mMessages="You Stop Following",mMessages[1]="All Stop Following",mMessages[2]="")
    mActionMenus[10]=(mAction=10,mType=1,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[11]=(mAction=11,mType=1,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[12]=(mAction=12,mType=2,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[13]=(mAction=13,mType=2,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[14]=(mAction=14,mType=0,mMessages="Get On Floor",mMessages[1]="",mMessages[2]="")
    mActionMenus[15]=(mAction=15,mType=2,mMessages="",mMessages[1]="",mMessages[2]="")
    mActionMenus[16]=(mAction=16,mType=2,mMessages="",mMessages[1]="",mMessages[2]="")
    mTextColour=(R=255,G=255,B=255,A=255)
    mGreyedOutColour=(R=60,G=60,B=60,A=255)
    mHandcuffingSoundRepeatTime=1.0000000
    mHandcuffingSound=Sound'mm_generic.Sounds.WD_handcuff_action_loop'
    mHandcuffingSoundVolume=0.4000000
    mHandcuffingSoundRadius=32.0000000
    mHandcuffedSound=Sound'mm_generic.Sounds.WD_handcuff_complete'
    mHandcuffedSoundVolume=0.9000000
    mHandcuffedSoundRadius=32.0000000
    mDefusingHostageSoundRepeatTime=1.0000000
    mDefusingHostageSound=Sound'mm_generic.Sounds.WD_disarming_bomb_01'
    mDefusingHostageSoundVolume=0.2500000
    mDefusingHostageSoundRadius=32.0000000
    mDefusedHostageSound=Sound'mm_generic.Sounds.WD_bomb_disarmed_01'
    mDefusedHostageVolume=0.5000000
    mDefusedHostageRadius=48.0000000
    BRACKET_WIDTH=285.0000000
    BRACKET_HEIGHT=165.0000000
    BRACKET_HORIZ_OFFSET=74.0000000
    BRACKET_VERT_OFFSET=56.0000000
    BRACKET_HORIZONTAL_START_OFFSET=153.0000000
    BRACKET_VERT_FORSCALE=16.0000000
    HORIZ_HIGHLIGHT_WIDTH=362.0000000
    HORIZ_HIGHLIGHT_HEIGHT=209.0000000
    HORIZ_HIGHLIGHT_U=1.0000000
    HORIZ_HIGHLIGHT_V=6.0000000
    VERT_HIGHLIGHT_WIDTH=194.0000000
    VERT_HIGHLIGHT_HEIGHT=255.0000000
    VERT_HIGHLIGHT_U=186.0000000
    VERT_HIGHLIGHT_V=223.0000000
    HORIZ_HIGHLIGHT_OFFSET=116.0000000
    VERT_HIGHLIGHT_OFFSET=133.0000000
    DrawType=0
    RemoteRole=0
    bHidden=true
}