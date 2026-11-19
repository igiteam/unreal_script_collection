class AdvAI_AztecMummy extends AdvAIController
    config(AI)
    hidecategories(Navigation);

var AdvPawn_Mummy_Base MyAdvPawn_Mummy_Base;

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    //return ReturnValue;    
}

function AddAttackingSpider(Pawn spider)
{
    // End:0x9A
    if(AttackingSpidersCount == 0)
    {
        // End:0x97
        if((Pawn != none) && AdvPawn(Pawn) != none)
        {
            super.AddAttackingSpider(spider);
            AdvPawn(Pawn).DropClothesOnRagdoll(Class'EvilGame.EvilDmgType_Melee', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
        }        
    }
    else
    {
        super.AddAttackingSpider(spider);
    }
    //return;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    MyAdvPawn_Mummy_Base = AdvPawn_Mummy_Base(MyAdvPawn);
    AutoAcquireEnemy();
    SetAttackBehavior(Enemy);
    //return;    
}

function float OnRateStrafeByFlankEnemy(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    local float Rating;

    switch(StrafeData.StrafeDirection)
    {
        // End:0x18B
        case 5:
            // End:0xE6
            if(((CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds) || MyAdvPawn.bOnLightInfluenceFromVolume && !MyAdvPawn.bOnLightInfluenceFromFlashLight)
            {
                StrafeData.DefaultRating = 1.0000000;                
            }
            else
            {
                StrafeData.DefaultRating *= ((MyAdvPawn.IsBurning()) ? 0.0500000 : 0.1000000 * FClamp(FPctByRange(GetEnemyInfo().DistanceToEnemy, EnemyDistance_Melee * 1.5000000, EnemyDistance_Melee * 3.0000000), 0.0000000, 1.0000000));
            }
            // End:0x39A
            break;
        // End:0x26E
        case 4:
            // End:0x1FE
            if((CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds)
            {
                StrafeData.DefaultRating = 0.0000000;
            }
            StrafeData.DefaultRating *= ((MyAdvPawn.bOnLightInfluenceFromFlashLight) ? 1.0000000 * MyEvilPawn.GetHitsPerSec() : 0.0000000);
            // End:0x39A
            break;
        // End:0x273
        case 2:
        // End:0x397
        case 3:
            // End:0x2E6
            if((CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds)
            {
                StrafeData.DefaultRating = 0.0000000;
            }
            StrafeData.DefaultRating *= FMin(2.0000000, 1.0000000 + (Normal(GetEnemyInfo().KnownLocation - StrafeData.StrafePoint) Dot Normal(Vector(Normalize(GetEnemyInfo().Pawn.GetBaseAimRotation())))));
            // End:0x39A
            break;
        // End:0xFFFF
        default:
            break;
    }
    Rating = super(EvilAIController).OnRateStrafeByFlankEnemy(StrafeData, StrafeDataArray);
    return Rating;
    //return ReturnValue;    
}

function bool CanEngageCharge()
{
    return super(EvilAIController).CanEngageCharge();
    //return ReturnValue;    
}

function bool CanStartBurnBehaviour()
{
    local float FrozenAmount;

    return (((super(EvilAIController).CanStartBurnBehaviour() && (MoveAction == none) || MoveAction.bInterruptable) && !MyAdvPawn_Mummy_Base.bHasShield) && !MyAdvPawn_Mummy_Base.IsFrozen(FrozenAmount) || FrozenAmount < 0.2000000) && (CoverFromLightStartTime < 0.0000000) || (CoverFromLightStartTime + CoverFromLightTime) > WorldInfo.TimeSeconds;
    //return ReturnValue;    
}

function bool CanMeleeAttack()
{
    return (super(EvilAIController).CanMeleeAttack() && HasValidEnemy()) && ((!MyAdvPawn.bOnLightInfluenceFromFlashLight || MyAdvPawn_Mummy_Base.bHasShield) || MyAdvPawn_Mummy_Base.bBerserkerMode) || (CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds;
    //return ReturnValue;    
}

function NotifyStartBurn(float InTotalTime, float InDamageInterval, float InFDamageAmount)
{
    super(EvilAIController).NotifyStartBurn(InTotalTime, InDamageInterval, InFDamageAmount);
    // End:0xB1
    if(!MyAdvPawn_Mummy_Base.bBerserkerMode && !MyAdvPawn_Mummy_Base.HasShield())
    {
        MyAdvPawn_Mummy_Base.bShouldWalkFast = true;
        MyAdvPawn_Mummy_Base.ForceLimitedMoveMode(1);
    }
    //return;    
}

function float GetBaseEnemyRating(EvilPawn EnemyP, float Distance)
{
    local float Rating;

    Rating = super(EvilAIController).GetBaseEnemyRating(EnemyP, Distance);
    Rating *= ((EnemyP.bIsInvulnerable && !EnemyP.IsPlayerPawn()) ? 0.0000000 : 1.0000000);
    return Rating;
    //return ReturnValue;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local TraceHitInfo HitInfo;
    local int EnemyIndex;
    local class<EvilDmgType_Base> EvilDamageType;

    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    // End:0x2A2
    if(((EvilDamageType != none) && EvilDamageType.default.bIsLightDmgType) && float(Damage) > 0.0000000)
    {
        ReactionManager.IncomingDamage((((InstigatedBy != none) && InstigatedBy.Pawn != none) ? InstigatedBy.Pawn : none), true, DamageType, HitInfo, (((InstigatedBy != none) && InstigatedBy.Pawn != none) ? InstigatedBy.Pawn.Location : vect(0.0000000, 0.0000000, 0.0000000)), Damage);
        // End:0x2A2
        if(InstigatedBy != none)
        {
            EnemyIndex = GetAIEnemyInfoIdx(InstigatedBy.Pawn);
            // End:0x2A2
            if((EnemyIndex > -1) && EnemyInfoList[EnemyIndex].bInitialized)
            {
                // End:0x2A2
                if(EnemyInfoList[EnemyIndex].RatingModifier < 0.9000000)
                {
                    EnemyInfoList[EnemyIndex].RatingModifier = FMin(0.9000000, EnemyInfoList[EnemyIndex].RatingModifier + 0.4000000);
                    SetEnemy(InstigatedBy.Pawn);
                }
            }
        }
    }
    super(EvilAIController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    //return;    
}

defaultproperties
{
    FinishEnemiesModeDuration=20.0000000
    ChoosingEnenyToFinishDuration=10.0000000
    CoverFromLightTime=4.0000000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'AdvAICmd_Base_Mummy'
    MeleeCommand=Class'AdvAICmd_AztecMummy_Melee'
    BurningCommand=Class'AdvAICmd_CoverFromLight'
    StrafesData=/* Array type was not detected. */
    NumOfCheckedStrafesInRating=8
    StrafeRatingThreshold=0.0000000
    EnemyDistance_Shoot=600.0000000
    EnemyDistance_Melee=250.0000000
    EnemyDistance_MeleeCharge=350.0000000
    EnemyDistance_Finisher=150.0000000
    EnemyDistance_MinimalStrafeDistance=1000.0000000
    DodgeChance=1.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_AztecMummy.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}