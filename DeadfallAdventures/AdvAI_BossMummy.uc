class AdvAI_BossMummy extends AdvAIController
    config(AI)
    hidecategories(Navigation);

var bool bCanSpawnSlaves;
var bool bForceSpawnSlaves;
var bool bSpawningSlaves;
var float CumulatedDamage;

function EvadeAwayFromPoint(Vector DangerPoint, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    local Vector EvadePoint, EvadeRotation;
    local float EvadeDistance;

    EvadePoint = GetBestEvadeLocation(FMax(2.0000000 * MyEvilPawn.GetCollisionRadius(), EnemyDistance_Shoot - (EnemyDistance_MeleeCharge + MyEvilPawn.GetCollisionRadius())), DangerPoint, true, bInCombatZones);
    EvadeDistance = VSize(EvadePoint - MyEvilPawn.Location);
    EvadeRotation = (EvadePoint - MyEvilPawn.Location) / EvadeDistance;
    MyEvilPawn.SetRotation(Rotator(EvadeRotation));
    MyEvilPawn.SetLocation(MyEvilPawn.Location + (FClamp(EvadeDistance * 0.2000000, MyEvilPawn.GetCollisionRadius() * float(2), EvadeDistance) * EvadeRotation));
    SetMovePoint(EvadePoint);
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    // End:0x25
    if(!bSpawningSlaves)
    {
        CumulatedDamage += float(Damage);
    }
    // End:0x81
    if(CumulatedDamage > float(MyEvilPawn.HealthMax))
    {
        TriggerEventClass(Class'SeqEvent_MummyBossDamage', MyEvilPawn);
        CumulatedDamage = 0.0000000;
    }
    super(EvilAIController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    //return ReturnValue;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior(Enemy);
    //return;    
}

function OnSpawnSlaves(SeqAct_SpawnSlaves Act)
{
    // End:0x70
    if(Act.InputLinks[0].bHasImpulse)
    {
        bCanSpawnSlaves = true;
        bForceSpawnSlaves = Act.bForceSpawn;        
    }
    else
    {
        // End:0xB3
        if(Act.InputLinks[1].bHasImpulse)
        {
            bSpawningSlaves = false;
        }
    }
    //return;    
}

function bool CanMeleeAttack()
{
    return ((super(EvilAIController).CanMeleeAttack() && !MyEvilPawn.bOnLightInfluenceFromFlashLight) && int(MyEvilPawn.PawnAction) != 55) && MyEvilPawn.bBlockActors;
    //return ReturnValue;    
}

function bool ShouldStopLevitating()
{
    return !bSpawningSlaves;
    //return ReturnValue;    
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'AdvAICmd_Base_BossMummy'
    MeleeCommand=none
    StrafesData=/* Array type was not detected. */
    EnemyDistance_Shoot=2000.0000000
    EnemyDistance_MeleeCharge=600.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_BossMummy.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}