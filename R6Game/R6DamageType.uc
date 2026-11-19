class R6DamageType extends DamageType
    native
    config(DamageTypesConfig);

var class<Inventory> m_DamageInventoryClass;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, optional bool bKillerIsATerrorist)
{
    // End:0x243
    if(Victim != none)
    {
        // End:0x14F
        if(Killer != none)
        {
            // End:0xAC
            if((Killer.Team != none) && Killer.Team == Victim.Team)
            {
                return FormatStrings(Localize("R6DamageType", "m_szPlayerTeamKilledMsg", "R6Game"), Killer.PlayerName, Victim.PlayerName);                
            }
            else
            {
                // End:0xF5
                if(default.m_DamageInventoryClass != none)
                {
                    return (((Killer.PlayerName $ " [") $ default.m_DamageInventoryClass.default.ItemName) $ "] ") $ Victim.PlayerName;                    
                }
                else
                {
                    return FormatStrings(Localize("R6DamageType", "m_szPlayerKilledMsg", "R6Game"), Killer.PlayerName, Victim.PlayerName);
                }
            }            
        }
        else
        {
            // End:0x1FB
            if(bKillerIsATerrorist)
            {
                // End:0x1A1
                if(default.m_DamageInventoryClass != none)
                {
                    return (((Class'GameMessage'.default.TerroristName $ " [") $ default.m_DamageInventoryClass.default.ItemName) $ "] ") $ Victim.PlayerName;                    
                }
                else
                {
                    return FormatStrings(Localize("R6DamageType", "m_szPlayerKilledMsg", "R6Game"), Class'GameMessage'.default.TerroristName, Victim.PlayerName);
                }                
            }
            else
            {
                return FormatStrings(Localize("R6DamageType", "m_szPlayerFellMsg", "R6Game"), Victim.PlayerName);
            }
        }
    }
    return Localize("R6DamageType", "DeathString", "R6Game");
    return;
}

static function string SuicideMessage(PlayerReplicationInfo Victim)
{
    // End:0x66
    if((Victim != none) && Victim.bIsFemale)
    {
        return FormatStrings(Localize("R6DamageType", "FemaleSuicide", "R6Game"), Victim.PlayerName);        
    }
    else
    {
        return FormatStrings(Localize("R6DamageType", "MaleSuicide", "R6Game"), Victim.PlayerName);
    }
    return;
}

defaultproperties
{
    m_bBulletDamage=true
}