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
    // End:0x19C
    if(VSize(NoiseMaker.Location - MyCreaturePawn.Location) < float(MyCreaturePawn.PanicRange))
    {
        // End:0xA4
        if(EvilCreature(NoiseMaker) == none)
        {
            MyCreaturePawn.GotoState('RunAway');            
        }
        else
        {
            // End:0x19C
            if(VSize(NoiseMaker.Location - MyCreaturePawn.Location) < (MyCreaturePawn.GetCollisionRadius() * float(5)))
            {
                // End:0x19C
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

function string GetDebugString()
{
    return (((((((((((((((((((((((((((((((((((((((((((GetHumanReadableName()) @ "\n") $ string(MyCreaturePawn.GetStateName())) @ "Found spot:") @ string(MyCreaturePawn.bFoundSpot)) @ "\nHealth:") @ string(MyCreaturePawn.Health)) $ "/") $ string(MyCreaturePawn.HealthMax)) @ "Phys") @ string(MyCreaturePawn.Physics)) @ "\nDist to DesiredLocation:") @ string(VSize(MyCreaturePawn.DesiredLocation - MyCreaturePawn.Location))) @ "Location delta:") @ string(VSize(MyCreaturePawn.Location - MyCreaturePawn.LastLocation))) @ "\nVelocity:") @ string(MyCreaturePawn.Velocity)) @ "VelSize:") @ string(VSize(MyCreaturePawn.Velocity))) @ "Speed:") @ string(MyCreaturePawn.Speed)) @ "\nAcceleration:") @ string(MyCreaturePawn.Acceleration)) @ "Team #:") @ string(GetTeamNum())) @ "\nRun timer:") @ string(MyCreaturePawn.RunTimer)) @ "Idle timer:") @ string(MyCreaturePawn.IdleTimer)) @ "\n") @ ("SetRunAwayDestination:" @ string(MyCreaturePawn.GetTimerRate('SetRunAwayDestination') - MyCreaturePawn.GetTimerCount('SetRunAwayDestination')))) @ ("SetRandDest:" @ string(MyCreaturePawn.GetTimerRate('SetRandDest') - MyCreaturePawn.GetTimerCount('SetRandDest')))) @ "\n") @ ("SetRandDest:" @ string(MyCreaturePawn.GetTimerRate('SetRandDest') - MyCreaturePawn.GetTimerCount('SetRandDest')))) @ ("SetStopDestination:" @ string(MyCreaturePawn.GetTimerRate('SetStopDestination') - MyCreaturePawn.GetTimerCount('SetStopDestination')))) @ "\n") @ ("LookAhead:" @ string(MyCreaturePawn.GetTimerRate('LookAhead') - MyCreaturePawn.GetTimerCount('LookAhead')))) @ "Failure counter:") @ string(MyCreaturePawn.StopFailureCounter)) @ "IsDesiredRotationLocked/InUse:") @ string(MyCreaturePawn.IsDesiredRotationLocked())) @ string(MyCreaturePawn.IsDesiredRotationInUse())) @ "\nRot to desired delta:") @ string(FindDeltaAngle(float(MyCreaturePawn.MyDesiredRotation.Yaw) * 0.0000959, float(MyCreaturePawn.Rotation.Yaw) * 0.0000959));
    //return ReturnValue;    
}
