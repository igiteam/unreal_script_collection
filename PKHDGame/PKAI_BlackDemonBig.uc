class PKAI_BlackDemonBig extends PKAI_BlackDemon
    config(AI)
    hidecategories(Navigation);

function bool HasValidEnemy()
{
    return (Enemy != none) || super(PKAIController).HasValidEnemy();
    //return ReturnValue;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    // End:0xB0
    if(!Other.IsPlayerOwned() && VSizeSq(MyPKPawn.Velocity) > 64.0000000)
    {
        Other.TakeDamage(1000, none, Other.Location, HitNormal * float(400), Class'PKDmgType_InstantGib',, none);
    }
    return super(PKAIController).NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

defaultproperties
{
    EnemyAngleEpsilon_Melee=-1.0000000
    bNavmeshFailForceDirectMove=false
    DefaultCommand=Class'PKAICmd_Base_BlackDemonBig'
    MoveCommand=Class'EvilGame.EvilAICmd_MoveToGoal_DontFixNavMesh'
    EnemyDistance_Melee=500.0000000
    // Reference: EvilAIReactManager'Default__PKAI_BlackDemonBig.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAI_BlackDemon.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    NavMeshPath_SearchExtent_Modifier=(X=40.0000000,Y=40.0000000,Z=-5.0000000)
}