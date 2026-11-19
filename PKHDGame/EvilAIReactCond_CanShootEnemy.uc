class EvilAIReactCond_CanShootEnemy extends EvilAIReactCond_RandomCallDelegate within EvilAIController;

function Initialize()
{
    super(EvilAIReactCondition).Initialize();
    Outer.TimeBetweenFireBurst = RandRange(Outer.MinTimeBetweenFireBurst, Outer.MaxTimeBetweenFireBurst);
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return (((((((super.ShouldActivate(InInstigator, OriginatingChannel) && !Outer.MyEvilPawn.bMovingToCover) && int(Outer.MyEvilPawn.CoverType) == int(0)) && !Outer.IsFiring()) && !Outer.MyEvilPawn.IsReloading()) && (int(Outer.MyEvilPawn.PawnAction) == 0) || int(Outer.MyEvilPawn.PawnAction) == 10) && Outer.WorldInfo.TimeSeconds > (Outer.LastFireTime + Outer.TimeBetweenFireBurst)) && Outer.ShouldStartShootAttack()) && !(Outer.MyEvilPawn.bInMoveLatent && VSize(Outer.MyEvilPawn.Location - Outer.DestinationPosition.Position) < Outer.EnemyDistance_MinimalStrafeDistance) && (int(Outer.MyEvilPawn.CurrentMoveMode) == int(2)) || Outer.NeedReload();
    //return ReturnValue;    
}

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super(EvilAIReactCond_GenericCallDelegate).Activate(InInstigator, OriginatingChannel);
    Outer.TimeBetweenFireBurst = RandRange(Outer.MinTimeBetweenFireBurst, Outer.MaxTimeBetweenFireBurst);
    //return;    
}
