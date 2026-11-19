//
//	This is the message that tells you how to progress
//
class ZombieGuideMessage extends ZombieMessage;

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if(StreamingSoundTrigger(OptionalObject) != None)
	{
		return StreamingSoundTrigger(OptionalObject).Subtitle;	
	}

	if(ACTION_PlayDialog(OptionalObject) != None)
	{
		return ACTION_PlayDialog(OptionalObject).Subtitle;
	}
	
	// ifdef WITH_LIPSINC
	/*
	if(ACTION_PlayLIPSinc(OptionalObject) != None)
	{
		return ACTION_PlayLIPSinc(OptionalObject).Subtitle;
	}
	*/
	
	return "Test Subtitle Msg: " $ Rand(1000);
}

static function float GetZLifetime(int switch, Object optionalObject)
{
	local float MinTime;
	
	if (IsDemo())
	{
		MinTime = 5;
	}

	if(ACTION_PlayDialog(OptionalObject) != None)
	{
		return Max(ACTION_PlayDialog(OptionalObject).SubtitleTime, MinTime);
	}
	
	// ifdef WITH_LIPSINC
	/*
	if(ACTION_PlayLIPSinc(OptionalObject) != None)
	{
		return Max(ACTION_PlayLIPSinc(OptionalObject).SubtitleTime, MinTime);
	}
	*/
	
	return Max(super.GetZLifetime(switch, optionalObject), MinTime);
}


// Decompiled with UE Explorer.
defaultproperties
{
    TextSize=14.0000000
    xWrap=485
    xReset=155
    UseBasePos=true
    bCenter=true
    XPos=155.0000000
    YPos=-72.0000000
}