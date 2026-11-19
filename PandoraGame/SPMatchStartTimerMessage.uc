class SPMatchStartTimerMessage extends SPTimerMessage
    abstract;

var(Message) const localized string MatchBeginsIn;
var(Message) const localized string Seconds;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return (default.MatchBeginsIn @ string(Switch)) @ default.Seconds;
    //return ReturnValue;    
}

defaultproperties
{
    MatchBeginsIn="La m?quina de monstruos se iniciar? en"
    Seconds="segundos..."
}