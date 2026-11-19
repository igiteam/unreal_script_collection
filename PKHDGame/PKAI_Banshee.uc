class PKAI_Banshee extends PKAIController
    config(AI)
    hidecategories(Navigation);

var() config float ScreamFreq;
var() config float ScreamDistance;
var() config float ScreamDistanceMax;
var bool bAlreadyUnFading;
var array<Pawn> BansheeScreamAffectedPawnsList;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    //return;    
}

function Fade()
{
    local PKPlayerController PPC;

    // End:0x29
    if(int(MyPKPawn.PawnAction) != 33)
    {
        return;
    }
    bAlreadyUnFading = false;
    // End:0x166
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PPC)
    {
        ProcessStimulus(PPC.Pawn, 3, GetFuncName());
        // End:0x165
        if(((GetAIEnemyInfoIdx(PPC.Pawn)) > -1) && GetEnemyInfo(PPC.Pawn).DistanceToEnemy < ScreamDistanceMax)
        {
            BansheeScreamAffectedPawnsList.AddItem(PPC.Pawn);
            PPC.ToggleBansheeFade();
        }        
    }    
    //return;    
}

function Unfade()
{
    local PKPlayerController PPC;

    // End:0x0F
    if(bAlreadyUnFading)
    {
        return;
    }
    bAlreadyUnFading = true;
    // End:0xD0
    foreach WorldInfo.AllControllers(Class'PKPlayerController', PPC)
    {
        // End:0xCF
        if(BansheeScreamAffectedPawnsList.Find(PPC.Pawn) > -1)
        {
            BansheeScreamAffectedPawnsList.RemoveItem(PPC.Pawn);
            PPC.ToggleBansheeFade(true);
        }        
    }    
    //return;    
}

function PawnDied(Pawn inPawn)
{
    super(EvilAIController).PawnDied(inPawn);
    //return;    
}

defaultproperties
{
    ScreamFreq=0.0500000
    ScreamDistance=280.0000000
    ScreamDistanceMax=1456.0000000
    bAlreadyUnFading=true
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'PKAICmd_Base_Banshee'
    MeleeCommand=none
    EnemyDistance_Melee=150.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Banshee.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}