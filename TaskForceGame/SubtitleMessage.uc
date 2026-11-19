class SubtitleMessage extends ZombieMessage;

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	//Testing code...
	if(OptionalObject == None)
	{
		return "Test Subtitle Msg: " $ Rand(1000);
	}
	//
	
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
    TextSize=19.0000000
    Kern=2.0000000
    hJust=1
    xWrap=495
    xReset=125
    bCenter=true
    XPos=320.0000000
    YPos=390.0000000
}