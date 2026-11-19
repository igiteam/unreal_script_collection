class UTSayMsg extends UTLocalMessage;

var Color RedTeamColor;
var Color BlueTeamColor;

static function Color GetConsoleColor(PlayerReplicationInfo RelatedPRI_1)
{
    // End:0x3F
    if((RelatedPRI_1 == none) || RelatedPRI_1.Team == none)
    {
        return default.DrawColor;
    }
    // End:0x85
    if(RelatedPRI_1.Team.TeamIndex == 0)
    {
        return default.RedTeamColor;        
    }
    else
    {
        return default.BlueTeamColor;
    }
    //return ReturnValue;    
}

defaultproperties
{
    RedTeamColor=(R=255,G=64,B=64,A=255)
    BlueTeamColor=(R=64,G=192,B=255,A=255)
    bBeep=true
    Lifetime=6.0000000
    DrawColor=(R=255,G=255,B=0,A=255)
}