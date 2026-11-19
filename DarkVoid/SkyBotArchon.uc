class SkyBotArchon extends SkyBotBoss
    native
    config(AI);

var(Movement) float BeamSpeed;
var transient Vector CachedAimLocation;

simulated function Tick(float DeltaTime)
{
    local Rotator AimDir;
    local SkyWeaponBeam BeamWeap;
    local float BeamTargetSpeed;

    super(Actor).Tick(DeltaTime);
    BeamWeap = SkyWeaponBeam(Pawn.Weapon);
    // End:0x104
    if(((FireTarget != none) && BeamWeap != none) && BeamWeap.IsFiring())
    {
        bForceDesiredRotation = true;
        AimDir = Rotator(CachedAimLocation - Pawn.GetWeaponStartTraceLocation());
        DesiredRotation = AimDir + BeamWeap.GetSweepOffset();
        BeamTargetSpeed = 3.0000000 * DeltaTime;
        // End:0xDD
        if(BeamTargetSpeed > 1.0000000)
        {
            CachedAimLocation = FireTarget.Location;            
        }
        else
        {
            CachedAimLocation += (BeamTargetSpeed * (FireTarget.Location - CachedAimLocation));
        }        
    }
    else
    {
        bForceDesiredRotation = false;
    }
    //return;    
}

final event Actor ChooseBestPrimaryTarget(bool bMustBeVisible, optional Pawn PreviousEnemy)
{
    local int Idx;
    local float MostDamage, Dist, ClosestDist;
    local Pawn DamagePawn, ClosestPawn;
    local SightMemory SM;
    local array<Pawn> ValidEnemies;
    local float myDot;

    // End:0x73
    if(PreviousEnemy != none)
    {
        MostDamage = BotMemory.GetMemoryOf(PreviousEnemy).DamageCausedBy;
        ClosestDist = VSize(PreviousEnemy.Location - Pawn.Location);
        DamagePawn = PreviousEnemy;
        ClosestPawn = PreviousEnemy;        
    }
    else
    {
        MostDamage = -1.0000000;
        ClosestDist = 1000000.0000000;
    }
    BotMemory.GetKnownEnemies(((bMustBeVisible) ? 0.0000000 : 1000000.0000000), ValidEnemies);
    Idx = 0;
    J0xBA:

    // End:0x227 [Loop If]
    if(Idx < ValidEnemies.Length)
    {
        // End:0xE3
        if(SkyAirVehicle_RocketPackThrust(ValidEnemies[Idx]) != none)
        {
            // [Explicit Continue]
            goto J0x21D;
        }
        myDot = Normal(ValidEnemies[Idx].Location - Pawn.Location) Dot Vector(Pawn.Rotation);
        // End:0x21D
        if(myDot >= Pawn.PeripheralVision)
        {
            SM = BotMemory.GetMemoryOf(ValidEnemies[Idx]);
            // End:0x21D
            if(SM.PawnSeen != none)
            {
                // End:0x1BA
                if(SM.DamageCausedBy > MostDamage)
                {
                    DamagePawn = SM.PawnSeen;
                    MostDamage = SM.DamageCausedBy;
                }
                Dist = VSize(SM.PawnSeen.Location - Pawn.Location);
                // End:0x21D
                if(Dist < ClosestDist)
                {
                    ClosestDist = Dist;
                    ClosestPawn = SM.PawnSeen;
                }
            }
        }
        J0x21D:

        ++Idx;
        // [Loop Continue]
        goto J0xBA;
    }
    // End:0x26E
    if((ClosestPawn != none) && ClosestPawn != PreviousEnemy)
    {
        // End:0x26E
        if((PreviousEnemy == none) || InShortRange(ClosestPawn.Location))
        {
            return ClosestPawn;
        }
    }
    // End:0x2B5
    if((DamagePawn != none) && DamagePawn != PreviousEnemy)
    {
        // End:0x2B5
        if((PreviousEnemy == none) || InMediumRange(DamagePawn.Location))
        {
            return DamagePawn;
        }
    }
    // End:0x2C6
    if(PreviousEnemy != none)
    {
        return PreviousEnemy;
    }
    // End:0x2D7
    if(ClosestPawn != none)
    {
        return ClosestPawn;
    }
    // End:0x2E8
    if(KismetScriptedFireTarget != none)
    {
        return KismetScriptedFireTarget;
    }
    return none;
    //return ReturnValue;    
}

event bool BossFireWeaponAt(Actor myFireTarget)
{
    SkyPawn_Boss(Pawn).bLastPrimaryAttackCausedDamage = false;
    return FireWeaponAt(myFireTarget);
    //return ReturnValue;    
}

// Export USkyBotArchon::execGetAdjustedAimFor(FFrame&, void* const)
native function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc);

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    super(SkyBot).Possess(aPawn, bVehicleTransition);
    Pawn.bCanJump = Pawn.default.bCanJump;
    Pawn.bJumpCapable = Pawn.default.bJumpCapable;
    Pawn.JumpZ = Pawn.default.JumpZ;
    //return;    
}
