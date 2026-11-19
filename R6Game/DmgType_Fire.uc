class DmgType_Fire extends DamageType
    abstract
    native
    config(DamageTypesConfig);

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, optional bool bKillerIsATerrorist)
{
    return FormatStrings(Localize("DmgType_Fire", "DeathString", "R6Game"), Caps(Victim.PlayerName));
    return;
}

defaultproperties
{
    bLocationalHit=false
    m_bIsFireDamage=true
}