//////////////////////////////////////////////////////////////////////////////
//
//		CLASS SASPlaybackWidget.uc
//
//////////////////////////////////////////////////////////////////////////////

class SASPlaybackWidget extends Object within SASHUD
	transient;


//////////////////////////////////////////////////////////////////////////////
//	Consts


//////////////////////////////////////////////////////////////////////////////
//	Enums

enum EPlaybackActions
{
	PLAYBACK_Eject,		// Hard stop, return to main menu
	PLAYBACK_Rewind,	// Replay from beginning.
	PLAYBACK_Pause,		// Pause playback
	PLAYBACK_Unpause,	// Play
	PLAYBACK_Slow,		// Increase playback speed (via time scaling)
	PLAYBACK_Faster,	// Decrease playback speed (via time scaling)
	PLAYBACK_None
};


//////////////////////////////////////////////////////////////////////////////
// STRUCTS

struct native sPlaybackWidgetItem
{
	var EPlaybackActions	mAction;
	var Texture				mTexture;
	var float				posX;
	var float				posY;
	var localized string	mActionIconText;
};


//////////////////////////////////////////////////////////////////////////////
// VARS

var HUD						mOwnerHUD;

var float					mButtonHeldTime;
var EPlaybackActions		mCurrentAction;
var EPlaybackActions		mCurrentActionSelection;
var (Colours) Color			mSelectedTextColour;
var (Colours) Color			mTextColour;
var (Colours) Color			mGreyedOutColour;
var localized string		mHUDPlaybackWidgetLabel;
var Texture					mHUDPlaybackWidgetBackground;
var sPlaybackWidgetItem		mPlaybackWidgetItem [6];



//////////////////////////////////////////////////////////////////////////////
// NATIVE FUNCTIONS

//////////////////////////////////////////////////////////////////////////////
// FUNCTIONS


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION shouldDrawPlaybackWidget
//
//	Returns true if the playback widget is to be drawn
//::function bool shouldDrawPlaybackWidget()
//::{
//:://	if (mbInReplayMode)
//:://	{
//:://		return false;
//:://	} // if
//::
//::	return true;
//::} // shouldDrawPlaybackWidget


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DrawPlaybackWidget
//
//::function DrawPlaybackWidget (SASHUD hud, canvas aCanvas, float left, float top, float right, float bottom )
//::{
//::	local float width;
//::	local float height;
//::
//::	local float numButtons;
//::	local float divs;
//::	local float pixelsPerDiv;
//::	local float pixelsPerSpacer;
//::	local float pixelsPerButton;
//::
//::	local int i;
//::	local float buttonLeftSide;
//::	local float buttonRightSide;
//::
//::	// Set the general style to render in.
//::	aCanvas.Style = ERenderStyle.STY_Alpha;
//::	hud.SetOrangeColour(aCanvas);
//::
//::	// Draw the background for the DVD style buttons.
//::	width = right - left;
//::	height = bottom - top;
//::	aCanvas.SetPos ( left, top );
//::	aCanvas.DrawColor.A	= 128;
//::	aCanvas.DrawRect (mHUDPlaybackWidgetBackground, width, height);
//::
//::	// Draw the DVD style buttons.
//::	numButtons		= 6.0f;
//::	divs			= (5.0f*numButtons)+1.0f;
//::	pixelsPerDiv	= width/divs;
//::	pixelsPerSpacer	= pixelsPerDiv;
//::	pixelsPerButton	= 4.0f*pixelsPerDiv;
//::	for( i = 0; i < 6; i++ )
//::	{
//::		buttonLeftSide = ( ( (i+1) * pixelsPerSpacer ) + ( i * pixelsPerButton ) );
//::		buttonRightSide = buttonLeftSide + pixelsPerButton;
//::		
//::		aCanvas.SetPos ( (left+buttonLeftSide), (top + (height/10)) );
//::		aCanvas.DrawRect( mPlaybackWidgetItem[i].mTexture, (buttonRightSide - buttonLeftSide), pixelsPerButton );
//::	}
//::
//::	// Draw a text label for what the widget is (replay controls).
//:://	aCanvas.DrawColor	= mTextColour;
//::	aCanvas.DrawColor.A	= 255;
//::	aCanvas.Font		= aCanvas.SmallFont;
//::	aCanvas.CentreText ( mHUDPlaybackWidgetLabel, (left+(width /2)), (top+(height/2)+(pixelsPerButton/2)) );
//::
//:://	// Progress bar for curent playback position.
//:://	{
//:://		progressWidth = mCurrentPlayTime / mTotalPlayTime;
//:://		if (progressWidth > 1.0)
//:://		{
//:://			progressWidth = 1.0;
//:://		}
//:://		progressWidth *= width;
//:://
//:://		aCanvas.SetPos (left, top + size * 7 / 16);
//:://		aCanvas.SetDrawColor (150, 0, 0);
//:://		aCanvas.DrawRect (mBlankTexture, width, size / 8);
//:://	}
//::} // DrawPlaybackWidget


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DrawPlaybackWidgetIcon
//
//::function DrawPlaybackWidgetIcon (SASHUD hud, canvas aCanvas, float left, float top, float size)
//::{
//:://	if ( true )
//:://	{
//:://		hud.SetDarkOrangeColour( aCanvas );
//:://	} // if
//:://	else
//:://	{
//:://		hud.SetOrangeColour( aCanvas );
//:://	} // else
//:://
//:://	if (mActionIconTextures [mCurrentAction] != None)
//:://	{
//:://		aCanvas.SetPos (left, top);
//:://		aCanvas.DrawTileClipped (
//:://			mActionIconTextures [mCurrentAction],
//:://			size, size,
//:://			0, 0,
//:://			mActionIconTextures [mCurrentAction].USize, mActionIconTextures [mCurrentAction].VSize
//:://			);
//:://	} // if
//::
//::
//:://	// Draw red line through assault modes when too many squad members are dead
//:://	aCanvas.SetDrawColor (255, 0, 0);
//:://	aCanvas.SetPos (left, top + size / 2);
//:://	aCanvas.DrawHorizontal (top + size / 2, size);
//::
//::	// Text is for debug testing only until we get proper icons
//:://	aCanvas.DrawColor = mTextColour;
//:://	aCanvas.CentreText (mActionIconText [mCurrentAction], left + size / 2, top + size / 2);
//:://	aCanvas.CentreText (String (GetPlayerController ().mReticuleTarget), left + size / 2, top + size / 2 + 10);
//::
//::} // DrawPlaybackWidgetIcon

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION UpdatePlaybackWidget
//
//::function UpdatePlaybackWidget (float timeDelta)
//::{
//::
//:://	local EPlaybackActions	newAction;
//:://
//:://	if (mbInReplayMode)
//:://	{
//:://		return;
//:://	}
//:://
//:://	// Determine action button we are over.
//::////	newAction = DetermineHighestPriorityAction ();
//:://
//:://	// Can't change action if button is currently held down
//:://	if (newAction != mCurrentAction && mButtonHeldTime > 0)
//:://	{
//:://		mCurrentAction = PLAYBACK_None;
//:://	}
//:://	else
//:://	{
//:://		mCurrentAction = newAction;
//:://	}
//:://
//:://	// Action button up or down.
//:://	if (pc.bAction != 0)
//:://	{
//:://		// Action button is down
//:://		mButtonHeldTime += timeDelta;
//:://	}
//:://	else
//:://	{
//:://		// Action button is up.
//:://
//:://		// If we've held button for short period of time and then release it, activate selected action
//:://		if (mButtonHeldTime > 0)
//:://		{
//:://			// Activate selected action
//:://			pc.ExitActionMenu ();
//:://			ActionActivate (timeDelta);
//:://		}
//:://		else
//:://		{
//:://			mCurrentActionSelection = PLAYBACK_None;
//:://		}
//:://
//:://		mButtonHeldTime = 0;
//:://	}
//::
//::} // UpdatePlaybackWidget


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION ActionSelect
//
//::function ActionSelect (int select)
//::{
//::	mCurrentActionSelection = EPlaybackActions (select);
//::} // ActionSelect



//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION ActionActivate
//
// Activate current action
//::function ActionActivate (float timeDelta)
//::{
//:://	if (!mbInReplayMode)
//:://	{
//:://		return;
//:://	} // if
//::
//::	switch (mCurrentAction)
//::	{
//::		case PLAYBACK_Eject :
//::			DoAction_Eject ();
//::			break;
//::
//::		case PLAYBACK_Rewind :
//::			DoAction_Rewind  ();
//::			break;
//::
//::		case PLAYBACK_Pause :
//::			DoAction_Pause ();
//::			break;
//::
//::		case PLAYBACK_Unpause :
//::			DoAction_Unpause ();
//::			break;
//::
//::		case PLAYBACK_Slow:
//::			DoAction_Slow();
//::			break;
//::
//::		case PLAYBACK_Faster :
//::			DoAction_Faster ();
//::			break;
//::	} // switch
//::
//::	mCurrentActionSelection = PLAYBACK_None;
//::} // ActionActivate


//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoAction_Eject
//
// Hard stop, return to main menu
//::function DoAction_Eject ()
//::{
//::
//::}
//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoAction_Eject
//
// Replay from beginning.
//::function DoAction_Rewind ()
//::{
//::
//::}

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoAction_Pause
//
// Pause playback
//::function DoAction_Pause ()
//::{
//::
//::}	

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoAction_Unpause
//
// Play
//::function DoAction_Unpause ()
//::{
//::
//::}	

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoAction_Slow
//
// Decrease playback speed (via time scaling)
//::function DoAction_Slow ()
//::{
//::
//::}	

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION DoAction_Faster
//
// Increase playback speed (via time scaling)
//::function DoAction_Faster ()
//::{
//::
//::}


//////////////////////////////////////////////////////////////////////////////
//
// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mCurrentAction=6
    mCurrentActionSelection=6
    mSelectedTextColour=(R=255,G=255,B=255,A=255)
    mTextColour=(R=255,G=255,B=255,A=255)
    mGreyedOutColour=(R=60,G=60,B=60,A=255)
    mHUDPlaybackWidgetLabel="Replay Controls"
    mHUDPlaybackWidgetBackground=Texture'Engine.WhiteSquareTexture'
    mPlaybackWidgetItem[0]=(mAction=0,mTexture=Texture'GUIContent.AwardIcons.Award08_ICap',posX=0.0000000,posY=0.0000000,mActionIconText="Eject")
    mPlaybackWidgetItem[1]=(mAction=1,mTexture=Texture'GUIContent.AwardIcons.Award09_Brut',posX=0.0000000,posY=0.0000000,mActionIconText="Rewind")
    mPlaybackWidgetItem[2]=(mAction=2,mTexture=Texture'GUIContent.AwardIcons.Award03_Hatchet',posX=0.0000000,posY=0.0000000,mActionIconText="Pause")
    mPlaybackWidgetItem[3]=(mAction=3,mTexture=Texture'GUIContent.AwardIcons.Award04_Frosty',posX=0.0000000,posY=0.0000000,mActionIconText="Unpause")
    mPlaybackWidgetItem[4]=(mAction=4,mTexture=Texture'GUIContent.AwardIcons.Award07_DTap',posX=0.0000000,posY=0.0000000,mActionIconText="Slow")
    mPlaybackWidgetItem[5]=(mAction=5,mTexture=Texture'GUIContent.AwardIcons.Award05_Ninja',posX=0.0000000,posY=0.0000000,mActionIconText="Faster")
}