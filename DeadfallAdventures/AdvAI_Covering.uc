class AdvAI_Covering extends AdvAIController_Cover
    config(AI)
    hidecategories(Navigation);

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    // End:0x5E
    if(!MyAdvPawn.bMovingToCover && !HasValidCover() || !IsAtCover())
    {
        SetAcquireCover(1, string(GetFuncName()));
    }
    super(EvilAIController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    //return;    
}

function bool CanEngageCharge()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    DefaultCommand=Class'AdvAICmd_Base_CoverAI'
    MeleeCommand=Class'AdvAICmd_CoverAI_Base_Melee'
    EnemyDistance_Shoot=1500.0000000
    EnemyDistance_Melee=100.0000000
    EnemyDistance_HearFootSteps=500.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_Covering.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=1.0000000
    MinTimeBetweenFireBurst=0.5000000
    BurstFireTimeout=2.5000000
    BurstFireSpreadTime=0.5000000
    BurstFireLag=0.5000000
}