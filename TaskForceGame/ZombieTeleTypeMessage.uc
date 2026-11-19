class ZombieTeleTypeMessage extends ZombieMessage;

var int SwitchChange;
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
var Sound TeletypeSound;
var float TypeTime;

static event string GetString(
	optional int SwitchChange,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
//	if ( class<Actor>(OptionalObject) != None )
//		return class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);

	if(OptionalObject.IsA('TitleDisplay'))
	{
		return TitleDisplay(OptionalObject).GetLocalMsg();
	}

	return "";
}

event DrawBox(Canvas c, float x, float y, float w, float h)
{
	local float sf;
	sf = c.ScaleY;

	c.SetPos(x*sf, y*sf);
	c.DrawTile(class'HUDIconMgr'.default.WhiteSquare, w*sf, h*sf, 0, 0, 1, 1);
}

simulated static function float DrawTextJustify(Canvas c, coerce string s, float x, float y, ETextJustify just, optional bool blur, optional int xWrap, optional int xReset, optional float LeftEdge, optional float RightEdge)
{
	local float textW;
	local float textH;
	local float justifyOffset;
	local float ret;
	local float sf;
	
//	sf = c.ClipX/640;
	sf = c.ScaleY;

	xWrap *= sf;
	xReset *= sf;

	//Sigh, uc won't let you specify default vals, so we need to remap 0 to -1, so it works right in C++
	if (xWrap == 0)
	{
		xWrap = -1;
	}

	if (xReset == 0)
	{
		xReset = -1;
	}

	if (just != JUST_Left)
	{
		c.StrLen(s, textW, textH);
//		log("DrawTextJust: " $ textW @ textH @ s);
		if (just == JUST_Right)
		{
			justifyOffset = textW;
			ret = -textW;
		}
		else
		{
			justifyOffset = textW/2;
			
			if (LeftEdge != 0)
			{
				if ((x*sf-justifyOffset) < (LeftEdge*sf))
				{
					justifyOffset = (x*sf) - (LeftEdge*sf);
				}
			}
			
			if (RightEdge != 0)
			{
				if ((x*sf+justifyOffset) > (RightEdge*sf))
				{
					justifyOffset += ((x*sf)+justifyOffset) - (RightEdge*sf);
				}
			}
			
			ret = justifyOffset;
		}
	}
	else
	{
		justifyOffset = 0;
		ret = textW;
	}

	c.SetPos(x*sf-justifyOffset, y*sf);
	//48 for titleSafe
	//c.SetPos(Max(x*sf-justifyOffset, 48), y*sf);

	c.DrawText(s, false, xWrap, xReset);
	
	return ret;
}


// Call periodically to update drawing of the TeleTypeMessage
function DrawMessageUpdate(canvas C, PlayerController Owner,float CurrentTime)
{
	local float XPos;

	local float Time;
	local string TTMsg;
	local int i;
	local float xl, yl;


	// Draw a TeleTypeMessage OnScreen
	Time = CurrentTime - (EndOfLife - LifeTime);
	Time /= default.TypeTime;
	// Time now equals the timeslice relative to the length of the message

//		AddTextMessage("Got our message:" @ Time @ int(Time), class'StringMessagePlus');

	C.Font = StringFont;
	C.TextWidth = TextSize;
	C.TextHeight = TextSize;
	//Canvas.TextKern = Kern;


	// If the current time is less than the message length (ie, we haven't shown the whole message)
	if (int(Time) < Len(StringMessage))
	{
		if (int(Time) > SwitchChange)
		{
			// Play the teletype sound
			Owner.PlaySound(TeletypeSound, SLOT_Interface, 1.0f,,5000,,false);
			SwitchChange = int(Time);
		}
		
		// Return the string in StringMessage that's to the left of position Time
		TTMsg = Left(StringMessage, int(Time));
	}
	else
	{
		// Set the whole message
		TTMsg = StringMessage;
	}

	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;
	C.DrawColor.A = 128;
	
	//Canvas.StrLen(StringMessage,xl,yl);
	C.StrLen(TTMsg,xl,yl);

	DrawBox(C, 640, YPos + i*1.1*TextSize,
		-1.0*(xl+(640-XPos)+(TextSize/2)), 1.1*TextSize);
		
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.DrawColor.A = 255;
	
/*	DrawTextJustify(C, 
		Left(StringMessage, int(Time)), 
		XPos,
		YPos + i*1.1*TextSize,
		Justify,
		false,
		XWrap);*/
		
	c.DrawText2(Left(StringMessage, int(Time)),
		XReset,
		yPos,
		XWrap-XReset,
		0,
		hJust);
}


// Decompiled with UE Explorer.
defaultproperties
{
    Lifetime=10.0000000
    YPos=375.0000000
    TextSize=16.0000000
    Kern=2.0000000
    TeletypeSound=Sound'CBW_DYN_interface.teletype.Type'
    TypeTime=0.1000000
    XPos=590.0000000
}