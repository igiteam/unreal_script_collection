class EvilAIReactCond_CanShootEnemy extends EvilAIReactCond_RandomCallDelegate within EvilAIController;

var() bool bCheckSouldStartShootAttack;

function Initialize()
{
    super(EvilAIReactCondition).Initialize();
    Outer.TimeBetweenFireBurst = RandRange(Outer.MinTimeBetweenFireBurst, Outer.MaxTimeBetweenFireBurst);
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local bool bResult;

    bResult = super.ShouldActivate(InInstigator, OriginatingChannel);
    bResult = bResult && int(Outer.MyEvilPawn.CurrentAimZone) != int(0);
    bResult = ((bResult && !Outer.MyEvilPawn.bMovingToCover) && int(Outer.MyEvilPawn.CoverType) == int(0)) && Outer.MyEvilPawn.HasRangedAttack();
    bResult = ((bResult && !Outer.IsFiring()) && !Outer.MyEvilPawn.IsReloading()) && (int(Outer.MyEvilPawn.PawnAction) == 0) || int(Outer.MyEvilPawn.PawnAction) == 10;
    bResult = bResult && Outer.WorldInfo.TimeSeconds > (Outer.LastFireTime + Outer.TimeBetweenFireBurst);
    bResult = bResult && !(Outer.MyEvilPawn.bInMoveLatent && VSize(Outer.MyEvilPawn.Location - Outer.DestinationPosition.Position) < Outer.EnemyDistance_MinimalStrafeDistance) && (int(Outer.MyEvilPawn.CurrentMoveMode) == int(2)) || Outer.NeedReload();
    bResult = bResult && !bCheckSouldStartShootAttack || Outer.ShouldStartShootAttack();
    return bResult;
    //return ReturnValue;    
}

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super(EvilAIReactCond_GenericCallDelegate).Activate(InInstigator, OriginatingChannel);
    Outer.TimeBetweenFireBurst = RandRange(Outer.MinTimeBetweenFireBurst, Outer.MaxTimeBetweenFireBurst);
    //return;    
}

defaultproperties
{
    bCheckSouldStartShootAttack=true
}