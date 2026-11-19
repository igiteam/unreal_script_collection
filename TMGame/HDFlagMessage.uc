//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDFlagMessage extends TMLocalMessage;


static simulated function ClientReceive(
										PlayerController P,
										optional int Switch,
										optional PlayerReplicationInfo RelatedPRI_1,
										optional PlayerReplicationInfo RelatedPRI_2,
										optional Object OptionalObject
										)
{
	;

	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	//TMPlayerController(P).PlayAnnouncement(default.class, Switch); //?????
}

static function string GetString(
								 optional int Switch,
								 optional bool bPRI1HUD,
								 optional PlayerReplicationInfo RelatedPRI_1,
								 optional PlayerReplicationInfo RelatedPRI_2,
								 optional Object OptionalObject
								 )
{
	local int CurProc, TotalProc;

    ;

	//progress
    if(Switch > 100)
    {
    	TotalProc = class'HDFlag'.default.TotalProc;
    	CurProc =  Switch - 100;
    	if(CurProc > TotalProc)
    		CurProc = TotalProc;

    	return "Hold the Flag:" @ CurProc $ "/" $ TotalProc;
	}

	return "";
}

