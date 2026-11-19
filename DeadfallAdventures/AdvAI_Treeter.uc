class AdvAI_Treeter extends AdvAI_AztecMummy
    config(AI)
    hidecategories(Navigation);

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local EvilPawn OtherPawn;
    local EvilWeap_Melee_Base Wpn;

    OtherPawn = EvilPawn(Other);
    // End:0x14B
    if(((OtherPawn != none) && !OtherPawn.IsPlayerPawn()) && VSizeSq(MyEvilPawn.Velocity) > 256.0000000)
    {
        Wpn = MyEvilPawn.FindMeleeWeapon();
        Wpn.GiveDamageTo(OtherPawn, OtherPawn.Health, self, OtherPawn.Location, MyEvilPawn.Velocity, Wpn.InstantHitDamageTypes[0]);
    }
    return super.NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

function AdjustEnemyRating(out float out_Rating, EvilPawn EnemyPawn)
{
    // End:0x34
    if(!EnemyPawn.IsPlayerPawn())
    {
        out_Rating *= 0.1000000;
    }
    super(EvilAIController).AdjustEnemyRating(out_Rating, EnemyPawn);
    //return;    
}

defaultproperties
{
    BurningCommand=none
    EnemyDistance_Shoot=2500.0000000
    EnemyDistance_Melee=200.0000000
    EnemyDistance_MeleeCharge=400.0000000
    EnemyDistance_HearFootSteps=1000.0000000
    SightSenseDistanceThreshold=500.0000000
    SightRadius=4000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_Treeter.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=3.5000000
    MinTimeBetweenFireBurst=3.0000000
}