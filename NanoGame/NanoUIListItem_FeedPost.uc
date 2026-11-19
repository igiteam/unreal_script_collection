/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Entry for the NanoUIPage_Feed page
 */
class NanoUIListItem_FeedPost extends NanoUIListItem_Base;

/** Name of person that posted the information */
var string  FromUserName;

/** Actual text to display for this post */
var string  PostText;

/** Timestamp when this post occured */
var string  Timestamp;

/** Used to indicate what kind of post this is - used to pick the icon */
var enum EFeedPostType
{
	FPT_Handprint,
	FPT_Timetrial,
	FPT_Status,
	FPT_Bounty,
	FPT_MOTD,
	FPT_Bomb,
	FPT_Deal,
	FPT_CallForHelp,
	FPT_Misc
} PostType;

/** This post is 'important' */
var bool    bImportant;

/** This message has not yet been read */
var bool    bUnread;

/** Icon for handprint posts */
var	NanoIconData		HandprintIcon;
/** Icon for time trial posts */
var NanoIconData        TimetrialIcon;
/** Icon for status update posts */
var NanoIconData        StatusIcon;
/** Icon for bounty posts */
var NanoIconData        BountyIcon;
/** Icon for message of the day */
var NanoIconData        MOTDIcon;
/** Icon for Bomb posts */
var NanoIconData        BombIcon;
/** Icon for deal posts */
var NanoIconData        DealIcon;
/** Icon for call for help posts */
var NanoIconData        CallForHelpIcon;
/** Icon for misc posts */
var NanoIconData        MiscIcon;

/** Util for getting an icon for  */
function NanoIconData GetIconForType(EFeedPostType Type)
{
	if(Type == FPT_Handprint)
	{
		return HandprintIcon;
	}
	else if(Type == FPT_Timetrial)
	{
		return TimetrialIcon;
	}
	else if(Type == FPT_Status)
	{
		return StatusIcon;
	}
	else if(Type == FPT_Bounty)
	{
		return BountyIcon;
	}
	else if(Type == FPT_MOTD)
	{
		return MOTDIcon;
	}
	else if(Type == FPT_Bomb)
	{
		return BombIcon;
	}
	else if(Type == FPT_Deal)
	{
		return DealIcon;
	}
	else if(Type == FPT_CallForHelp)
	{
		return CallForHelpIcon;
	}
	else
	{
		return MiscIcon;
	}
}

/** Get icon info for a user name */
function NanoIconData GetFaceForUser(string UserName)
{
	local NanoIconData ReturnData;

	// Try to load a face for this person
	ReturnData.IconTex = Texture2D( DynamicLoadObject("UI_Faces." $ UserName, class'Texture', TRUE) );
	ReturnData.Coords.UL = 128;
	ReturnData.Coords.VL = 128;

	// Fallback texture...
	if(ReturnData.IconTex == None)
	{
		ReturnData.IconTex = Texture2D'UI_Common.Noise';
		ReturnData.Coords.UL = 256;
		ReturnData.Coords.VL = 256;
	}

	return ReturnData;
}

/** Turn a number of seconds into a friendly period  */
function string GetFriendlyTimeString(int NumSecs)
{
	if(NumSecs < 60)
	{
		return NumSecs @ "secs";
	}
	else if(NumSecs < 3600)
	{
		return (NumSecs / 60) @ "mins";
	}
	else if(NumSecs < 86400)
	{
		return (NumSecs / 3600) @ "hours";
	}
	else
	{
		return (NumSecs / 86400) @ "days";
	}
}

/** Draw this item at the specified location */
function DrawItem(NanoUIPage_List Page, vector2d ItemOrigin)
{
	local Canvas Canvas;
	local Color C;
	local NanoIconData IconData, FaceData;
	local string NowTimestamp, AgoText;
	local int SecDiff;
	local float XL, YL;

	Canvas = Page.NanoHUD.Canvas;
	C = GetItemColor(Page);

	// If unread draw a background
	if(bUnread)
	{
		Canvas.SetDrawColor(170,194,255,64);
		Canvas.SetPos(ItemOrigin.X, ItemOrigin.Y);
		Canvas.DrawRect(ItemSize.X, ItemSize.Y) ;
	}

	// Frame
	if(bImportant)
	{
		Canvas.SetDrawColor(255,109,12,255);
	}
	else
	{
		Canvas.SetDrawColorStruct(C);
	}

	Canvas.SetPos(ItemOrigin.X, ItemOrigin.Y);
	Canvas.DrawBox(ItemSize.X, ItemSize.Y) ;


	// Face
	if(FromUserName != "")
	{
		FaceData = GetFaceForUser(FromUserName);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.SetPos(ItemOrigin.X + 5, ItemOrigin.Y + 5);
		Page.NanoHUD.DrawTileCoords(FaceData.IconTex, 40, 40, FaceData.Coords);
	}

	// type icon
	IconData = GetIconForType(PostType);
	Canvas.SetDrawColorStruct(C);
	Canvas.SetPos(ItemOrigin.X + 50, ItemOrigin.Y + 5);
	Page.NanoHUD.DrawTileCoords(IconData.IconTex, 28, 28, IconData.Coords);


	// User name text
	Canvas.SetDrawColor(170,194,255,255);
	Canvas.SetPos(ItemOrigin.X + ItemTextOffset.X, ItemOrigin.Y + ItemTextOffset.Y);
	Canvas.DrawText( FromUserName );

	
	// Actual text of message
	Canvas.SetDrawColor(255,255,255,180);
	Canvas.SetPos(ItemOrigin.X + ItemTextOffset.X, ItemOrigin.Y + ItemTextOffset.Y + 15);
	Canvas.DrawText( PostText );

	// When this happened
	if(Timestamp != "")
	{
		NowTimestamp = class'NanoTypes'.static.GetTimestampForCurrentTime();
		SecDiff = class'NanoTypes'.static.GetSecondsBetweenTimestamps(Timestamp, NowTimestamp);

		AgoText = GetFriendlyTimeString(SecDiff) @ "ago";
		Canvas.TextSize(AgoText, XL, YL);

		Canvas.SetDrawColor(255,255,255,180);
		Canvas.SetPos(ItemOrigin.X + ItemSize.X - XL - 10, ItemOrigin.Y + ItemTextOffset.Y);
		Canvas.DrawText(AgoText);
	}
}




defaultproperties
{
	PostType=FPT_Misc

	HandprintIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintHandForge',Coords=(U=0,V=0,UL=256,VL=256))
	TimetrialIcon=(IconTex=Texture2D'UI_HUD.MiniMap.TimeTrial',Coords=(U=0,V=0,UL=256,VL=256))
	StatusIcon=(IconTex=Texture2D'UI_HUD.Menu.SpeechBubble',Coords=(U=0,V=0,UL=256,VL=256))
	BountyIcon=(IconTex=Texture2D'UI_HUD.MiniMap.EnemyBoss',Coords=(U=0,V=0,UL=256,VL=256))
	MOTDIcon=(IconTex=Texture2D'UI_HUD.MiniMap.MissionProc',Coords=(U=0,V=0,UL=256,VL=256))
	BombIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintBomb',Coords=(U=0,V=0,UL=256,VL=256))	
	DealIcon=(IconTex=Texture2D'UI_HUD.Menu.Handshake',Coords=(U=0,V=0,UL=256,VL=256))
	CallForHelpIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintAntenna',Coords=(U=0,V=0,UL=256,VL=256))
	MiscIcon=(IconTex=Texture2D'UI_HUD.Minimap.MissionSubSearch',Coords=(U=0,V=0,UL=256,VL=256))

	bDrawFrame=TRUE
	ItemTextOffset=(X=90,Y=8)
	ItemSize=(X=885,Y=55)
}