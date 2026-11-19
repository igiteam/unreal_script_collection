class AdvAI_GermanMG34Soldier extends AdvAIController_Cover
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
        BurstTimeMul = (3000.0000000 * 3000.0000000) / DistanceSq;
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
    DefaultCommand=Class'AdvAICmd_Base_HeavyMG'
    StrafesData=/* Array type was not detected. */
    EnemyDistance_Shoot=3000.0000000
    EnemyDistance_Melee=0.0000000
    EnemyDistance_MeleeCharge=250.0000000
    EnemyDistance_HearFootSteps=300.0000000
    SightRadius=6000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_GermanMG34Soldier.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=0.7000000
    MinTimeBetweenFireBurst=0.3000000
    BurstFireTimeout=3.0000000
    BurstFireSpreadTime=0.7000000
    BurstFireLag=0.4000000
}