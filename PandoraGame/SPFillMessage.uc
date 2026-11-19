class SPFillMessage extends LocalMessage;

var const localized string FilledMonsterMachineString;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0xCC
    if(RelatedPRI_1 != none)
    {
        // End:0x6F
        if(RelatedPRI_1.Team.TeamIndex == 1)
        {
            return ((("[FillMachineMessage]" $ "[1]") $ RelatedPRI_1.PlayerName) $ "[0]") @ default.FilledMonsterMachineString;            
        }
        else
        {
            // End:0xCC
            if(RelatedPRI_1.Team.TeamIndex == 2)
            {
                return ((("[FillMachineMessage]" $ "[2]") $ RelatedPRI_1.PlayerName) $ "[0]") @ default.FilledMonsterMachineString;
            }
        }
    }
    return "";
    //return ReturnValue;    
}

defaultproperties
{
    FilledMonsterMachineString="est? cargando la m?quina."
    Lifetime=6.0000000
    PosY=2.0000000
}