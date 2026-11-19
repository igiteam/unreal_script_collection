class TurokStatTracker extends Info
    native
    hidecategories(Navigation,Movement,Collision);

struct native StatRecord
{
    var @NULL mPlayerStats;
    var @NULL mController;

    structdefaultproperties
    {
        mPlayerStats=none
        mController=none
    }
};

var array mPlayerStats;
var array mHitActors;

event Destroyed()
{
    mPlayerStats.Length = 0;
    mHitActors.Length = 0;
    //return;    
}

function RegisterPlayerStats(@NULL Controller, @NULL playerStats)
{
    local int NewIndex;

    NewIndex = mPlayerStats.Length;
    mPlayerStats.Length = NewIndex + 1;
    mPlayerStats[NewIndex].mController = Controller;
    mPlayerStats[NewIndex].mPlayerStats = playerStats;
    //return;    
}

function (@NULL playerStats)
{
    local int Index;

    Index = mPlayerStats.Find(, @NULL);
    @NULL
    @NULL
    @NULL
    @NULL    
    @NULL
    default.@NULL
    @NULL
}

function WriteStatsToFile()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x6B [Loop If]
    if(I < mPlayerStats.Length)
    {
        mPlayerStats[I].mPlayerStats.WriteToFile(mPlayerStats[I].mController.PlayerReplicationInfo.PlayerName);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export UTurokStatTracker::execRecordShotFired(FFrame&, void* const)
native function RecordShotFired(@NULL Shooter, @NULL Weapon, class<Class> projectileType);

event RecordExplosionHit(@NULL Shooter, @NULL Projectile, float DamageRadius, @NULL HitLocation, bool bTraceToTopOfBBox)
{
    local bool bRegisterStat, bIsTeamGame;
    local @NULL Victim, playerStats;

    playerStats = GetPlayerStats(Shooter);
    // End:0x22
    if(playerStats == none)
    {
        return;
    }
    bRegisterStat = false;
    bIsTeamGame = TurokTeamGame(WorldInfo.Game) != none;
    // End:0xD5
    foreach VisibleCollidingActors(Class'Engine.Pawn', Victim, DamageRadius, HitLocation,, bTraceToTopOfBBox)
    {
        // End:0xD4
        if((Victim != Shooter.Pawn) && !bIsTeamGame || bIsTeamGame && int(Shooter.GetTeamNum()) != int(Victim.GetTeamNum()))
        {
            bRegisterStat = true;
            // End:0xD5
            break;
        }        
    }    
    // End:0x312
    if(bRegisterStat)
    {
        playerStats.RecordStat(31, playerStats.mConsecutiveHeadShots, 2);
        playerStats.mConsecutiveHeadShots = 0;
        // End:0x152
        if(Projectile.IsA('TurokProjFragGrenade'))
        {
            playerStats.RecordStat(1, 1, 1);
            playerStats.RecordStat(110, 1, 1);            
        }
        else
        {
            // End:0x194
            if(Projectile.IsA('TurokProjTimedGrenade'))
            {
                playerStats.RecordStat(1, 1, 1);
                playerStats.RecordStat(89, 1, 1);                
            }
            else
            {
                // End:0x1D6
                if(Projectile.IsA('TurokProjExplodingArrow'))
                {
                    playerStats.RecordStat(1, 1, 1);
                    playerStats.RecordStat(68, 1, 1);                    
                }
                else
                {
                    // End:0x218
                    if(Projectile.IsA('TurokProjNapalmGrenade'))
                    {
                        playerStats.RecordStat(1, 1, 1);
                        playerStats.RecordStat(72, 1, 1);                        
                    }
                    else
                    {
                        // End:0x25A
                        if(Projectile.IsA('turokProjStickyGun'))
                        {
                            playerStats.RecordStat(1, 1, 1);
                            playerStats.RecordStat(108, 1, 1);                            
                        }
                        else
                        {
                            // End:0x312
                            if(Projectile.IsA('TurokProjRocket'))
                            {
                                playerStats.RecordStat(1, 1, 1);
                                // End:0x312
                                if(((TurokPawnPlayer(Shooter.Pawn) != none) && TurokPawnPlayer(Shooter.Pawn).GetPrimaryWeapon() != none) && int(TurokPawnPlayer(Shooter.Pawn).GetPrimaryWeapon().mWeaponType) != int(6))
                                {
                                    playerStats.RecordStat(93, 1, 1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

// Export UTurokStatTracker::execRecordShotHit(FFrame&, void* const)
native function RecordShotHit(@NULL Shooter, @NULL Weapon, array ImpactList, class<Class> projectileType);

// Export UTurokStatTracker::execRecordPinning(FFrame&, void* const)
native function RecordPinning(@NULL Arrow);

// Export UTurokStatTracker::execRecordKill(FFrame&, void* const)
native function RecordKill(@NULL Killer, @NULL Victim, class<Class> DamageType, @NULL HitInfo);

// Export UTurokStatTracker::execRecordDeath(FFrame&, void* const)
native function RecordDeath(@NULL Victim, @NULL Killer, class<Class> DamageType);

// Export UTurokStatTracker::execRecordMatchEnded(FFrame&, void* const)
native function RecordMatchEnded(@NULL Player, @NULL Winner, @NULL Game, bool GameCompleted);

// Export UTurokStatTracker::execRecordStat(FFrame&, void* const)
native function RecordStat(@NULL Player, byte stat, float Value, byte Op);

// Export UTurokStatTracker::execGetPlayerStats(FFrame&, void* const)
native function @NULL GetPlayerStats(@NULL Controller);

function @NULL GetPlayerStatsByName(string PlayerName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x8E [Loop If]
    if(I < mPlayerStats.Length)
    {
        // End:0x84
        if((mPlayerStats[I].mController.PlayerReplicationInfo != none) && mPlayerStats[I].mController.PlayerReplicationInfo.PlayerName ~= PlayerName)
        {
            return mPlayerStats[I].mPlayerStats;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

// Export UTurokStatTracker::execActorAlreadyHit(FFrame&, void* const)
native function bool ActorAlreadyHit(@NULL HitActor);

// Export UTurokStatTracker::execMarkActorHit(FFrame&, void* const)
native function MarkActorHit(@NULL HitActor);

// Export UTurokStatTracker::execClearHitActors(FFrame&, void* const)
native function ClearHitActors();

defaultproperties
{
    bMovable=false
    Components=none
    TickGroup=3
}