class AdvAI_GermanLAWSoldier extends AdvAIController_Cover
    config(AI)
    hidecategories(Navigation);

function BeginFireFromOpenWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    FireFromOpen();
    //return;    
}

simulated function OnStartFire()
{
    local float DistanceSq, BurstTimeMul;

    super.OnStartFire();
    ShotTarget = Enemy;
    // End:0x131
    if(ShotTarget != none)
    {
        DistanceSq = VSizeSq(ShotTarget.Location - MyEvilPawn.Location);
        BurstTimeLeft = BurstFireTimeout + RandRange(-BurstFireSpreadTime, BurstFireSpreadTime);
        BurstTimeMul = (500.0000000 * 500.0000000) / DistanceSq;
        // End:0x11E
        if(BurstTimeMul < 0.4000000)
        {
            FireTime = BurstTimeLeft * BurstTimeMul;
            FireDelay = 1.0000000 - (BurstTimeMul * float(2));            
        }
        else
        {
            FireTime = BurstTimeLeft;
        }
    }
    //return;    
}

defaultproperties
{
    TargettedAimEpsilon=0.9900000
    ProjectileAimHeightModifier=1.5000000
    DefaultCommand=Class'EvilGame.EvilAICmd_Base_Armed'
    EnemyDistance_Shoot=3000.0000000
    EnemyDistance_Melee=150.0000000
    EnemyDistance_HearFootSteps=300.0000000
    SightRadius=5000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_GermanLAWSoldier.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=5.0000000
    MinTimeBetweenFireBurst=4.0000000
    BurstFireTimeout=9.0000000
    BurstFireSpreadTime=0.5000000
    BurstFireLag=0.1000000
}