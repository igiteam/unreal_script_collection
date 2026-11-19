class EvilAI_Creature extends AIController
    hidecategories(Navigation);

var EvilCreature MyCreaturePawn;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super(Controller).Possess(NewPawn, bVehicleTransition);
    MyCreaturePawn = EvilCreature(NewPawn);
    //return;    
}

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
    // End:0x1C0
    if(MyCreaturePawn.bReactToNoise && VSize(NoiseMaker.Location - MyCreaturePawn.Location) < float(MyCreaturePawn.PanicRange))
    {
        // End:0xC8
        if(EvilCreature(NoiseMaker) == none)
        {
            MyCreaturePawn.GotoState('RunAway');            
        }
        else
        {
            // End:0x1C0
            if(VSize(NoiseMaker.Location - MyCreaturePawn.Location) < (MyCreaturePawn.GetCollisionRadius() * float(5)))
            {
                // End:0x1C0
                if((NoiseType == 'AggresiveStop') && MyCreaturePawn.GetStateName() == 'Idle')
                {
                    MyCreaturePawn.GotoState('RunAway');
                    EvilCreature(NoiseMaker).GotoState('RunAway');
                }
            }
        }
    }
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x7B
    if(self.Enemy != none)
    {
        // End:0x78
        if(!self.Enemy.IsAliveAndWell())
        {
            self.Enemy = none;
        }        
    }
    else
    {
        self.AutoAcquireEnemy();
    }
    //return;    
}

function bool HasEnemy()
{
    return self.Enemy != none;
    //return ReturnValue;    
}

function bool IsFriendly(Controller OtherAI)
{
    return OtherAI.IsA('EvilAI_Creature');
    //return ReturnValue;    
}

function AutoAcquireEnemy()
{
    local Controller PotentialEnemy;
    local array<Controller> PotentialEnemies;
    local float MinDist, Dist;
    local int X;

    // End:0x1EE
    foreach WorldInfo.AllControllers(Class'Engine.Controller', PotentialEnemy)
    {
        // End:0x1ED
        if(((PotentialEnemy != self) && PotentialEnemy.Pawn != none) && ((EvilPawn(PotentialEnemy.Pawn) == none) || EvilPawn(PotentialEnemy.Pawn).bSpawnDone) || EvilPawn(PotentialEnemy.Pawn).IsPlayerPawn())
        {
            // End:0x1ED
            if(!self.IsFriendly(PotentialEnemy) && Abs(VSize(PotentialEnemy.Pawn.Location - self.MyCreaturePawn.Location)) < self.MyCreaturePawn.MaxVisionDistance)
            {
                PotentialEnemies.AddItem(PotentialEnemy);                
            }
        }        
    }    
    // End:0x201
    if(PotentialEnemies.Length == 0)
    {
        return;
    }
    MinDist = self.MyCreaturePawn.MaxVisionDistance;
    self.Enemy = PotentialEnemies[0].Pawn;
    X = 0;
    J0x278:

    // End:0x37F [Loop If]
    if(X < PotentialEnemies.Length)
    {
        Dist = Abs(VSize(PotentialEnemies[X].Pawn.Location - self.MyCreaturePawn.Location));
        // End:0x371
        if(Dist < MinDist)
        {
            self.Enemy = PotentialEnemies[X].Pawn;
            MinDist = Dist;
        }
        X++;
        // [Loop Continue]
        goto J0x278;
    }
    //return;    
}

function string GetDebugString()
{
    return (((((((((((((((((((((((((((((((((((((((((((GetHumanReadableName()) @ "\n") $ string(MyCreaturePawn.GetStateName())) @ "Found spot:") @ string(MyCreaturePawn.bFoundSpot)) @ "\nHealth:") @ string(MyCreaturePawn.Health)) $ "/") $ string(MyCreaturePawn.HealthMax)) @ "Phys") @ string(MyCreaturePawn.Physics)) @ "\nDist to DesiredLocation:") @ string(VSize(MyCreaturePawn.DesiredLocation - MyCreaturePawn.Location))) @ "Location delta:") @ string(VSize(MyCreaturePawn.Location - MyCreaturePawn.LastLocation))) @ "\nVelocity:") @ string(MyCreaturePawn.Velocity)) @ "VelSize:") @ string(VSize(MyCreaturePawn.Velocity))) @ "Speed:") @ string(MyCreaturePawn.Speed)) @ "\nAcceleration:") @ string(MyCreaturePawn.Acceleration)) @ "Team #:") @ string(GetTeamNum())) @ "\nRun timer:") @ string(MyCreaturePawn.RunTimer)) @ "Idle timer:") @ string(MyCreaturePawn.IdleTimer)) @ "\n") @ ("SetRunAwayDestination:" @ string(MyCreaturePawn.GetTimerRate('SetRunAwayDestination') - MyCreaturePawn.GetTimerCount('SetRunAwayDestination')))) @ ("SetRandDest:" @ string(MyCreaturePawn.GetTimerRate('SetRandDest') - MyCreaturePawn.GetTimerCount('SetRandDest')))) @ "\n") @ ("SetRandDest:" @ string(MyCreaturePawn.GetTimerRate('SetRandDest') - MyCreaturePawn.GetTimerCount('SetRandDest')))) @ ("SetStopDestination:" @ string(MyCreaturePawn.GetTimerRate('SetStopDestination') - MyCreaturePawn.GetTimerCount('SetStopDestination')))) @ "\n") @ ("LookAhead:" @ string(MyCreaturePawn.GetTimerRate('LookAhead') - MyCreaturePawn.GetTimerCount('LookAhead')))) @ "Failure counter:") @ string(MyCreaturePawn.StopFailureCounter)) @ "IsDesiredRotationLocked/InUse:") @ string(MyCreaturePawn.IsDesiredRotationLocked())) @ string(MyCreaturePawn.IsDesiredRotationInUse())) @ "\nRot to desired delta:") @ string(FindDeltaAngle(float(MyCreaturePawn.MyDesiredRotation.Yaw) * 0.0000959, float(MyCreaturePawn.Rotation.Yaw) * 0.0000959));
    //return ReturnValue;    
}
