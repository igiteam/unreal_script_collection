class EvilVictimMessage extends EvilWeaponKillMessage;

var(Message) const localized string YouWereKilledBy;
var(Message) const localized string KilledByTrailer;
var(Message) const localized string OrbSuicideString;
var(Message) const localized string RunOverString;
var(Message) const localized string SpiderMineString;
var(Message) const localized string ScorpionKamikazeString;
var(Message) const localized string ViperKamikazeString;
var(Message) const localized string TelefragString;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string VictimString;
    local class<EvilDmgType_Base> VictimDamageType;

    // End:0x17
    if(RelatedPRI_1 == none)
    {
        return "";
    }
    // End:0x2C4
    if(RelatedPRI_1.PlayerName != "")
    {
        VictimString = (default.YouWereKilledBy @ RelatedPRI_1.PlayerName) $ default.KilledByTrailer;
        VictimDamageType = class<EvilDmgType_Base>(OptionalObject);
        // End:0x2B7
        if(VictimDamageType != none)
        {
            // End:0x11F
            if(VictimDamageType.default.DamageWeaponClass != none)
            {
                VictimString = ((VictimString $ " (") $ VictimDamageType.default.DamageWeaponClass.default.ItemName) $ ")";                
            }
            else
            {
                // End:0x186
                if((class<UTDmgType_RanOver>(VictimDamageType) != none) || VictimDamageType.default.KillStatsName == 'KILLS_SCORPIONBLADE')
                {
                    VictimString = VictimString @ default.RunOverString;                    
                }
                else
                {
                    // End:0x1D3
                    if(VictimDamageType.default.KillStatsName == 'KILLS_SPIDERMINE')
                    {
                        VictimString = VictimString @ default.SpiderMineString;                        
                    }
                    else
                    {
                        // End:0x220
                        if(VictimDamageType.default.KillStatsName == 'KILLS_SCORPIONSELFDESTRUCT')
                        {
                            VictimString = VictimString @ default.ScorpionKamikazeString;                            
                        }
                        else
                        {
                            // End:0x26D
                            if(VictimDamageType.default.KillStatsName == 'KILLS_VIPERSELFDESTRUCT')
                            {
                                VictimString = VictimString @ default.ViperKamikazeString;                                
                            }
                            else
                            {
                                // End:0x2B7
                                if(VictimDamageType.default.KillStatsName == 'KILLS_TRANSLOCATOR')
                                {
                                    VictimString = VictimString @ default.TelefragString;
                                }
                            }
                        }
                    }
                }
            }
        }
        return VictimString;        
    }
    else
    {
        return "";
    }
    //return ReturnValue;    
}

defaultproperties
{
    bIsUnique=true
    Lifetime=6.0000000
    DrawColor=(R=255,G=0,B=0,A=255)
    FontSize=2
}