class SkyWeap_ArchonLauncher extends SkyWeapon
    config(Game);

simulated function StartFire(byte FireModeNum)
{
    // End:0x66
    if(SkyPawn_Archon(Owner) != none)
    {
        SkyBotArchon(SkyPawn_Archon(Owner).Controller).CachedAimLocation = SkyBotArchon(SkyPawn_Archon(Owner).Controller).GetFireTarget().Location;
    }
    super(Weapon).StartFire(FireModeNum);
    //return;    
}
