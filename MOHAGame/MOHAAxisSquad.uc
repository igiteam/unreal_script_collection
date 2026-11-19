class MOHAAxisSquad extends MOHASquad
    hidecategories(Navigation);

function float EvaluatePerformanceGiver(MOHAPlayerController PC, MOHAAIController C)
{
    local float fDist;
    local Vector vDir;
    local float fDot, fScore;

    fScore = 0.0000000;
    // End:0x5B
    if((MOHAPlayerInput(PC.PlayerInput) != none) && MOHAPlayerInput(PC.PlayerInput).AimAssistEnemy == C.Pawn)
    {
        return 0.0000000;
    }
    // End:0x75
    if(C.MountedGun != none)
    {
        return 0.0000000;
    }
    // End:0xB6
    if((MOHAAIPawn(C.Pawn) != none) && MOHAAIPawn(C.Pawn).IsMeleeEnabled)
    {
        return 0.0000000;
    }
    // End:0xD4
    if(C.bInAssignedAffordance)
    {
        fScore += 10000.0000000;
    }
    // End:0xFB
    if(Class'MOHAUtilities'.static.GetAiLodAnimated(C))
    {
        fScore += 500.0000000;
    }
    vDir = C.Pawn.Location - PC.Pawn.Location;
    fDist = VSize(PC.Pawn.Location - C.Pawn.Location);
    fScore += (200.0000000 * (fDist / 1000.0000000));
    vDir = Normal(vDir);
    fDot = Vector(PC.Rotation) Dot vDir;
    // End:0x1CF
    if(fDot > 0.0000000)
    {
        fScore += (400.0000000 * fDot);
    }
    return fScore;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: KynapseEntityComponent'Default__MOHAAxisSquad.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAxisSquad.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    Components[0]=KynapseEnt0
    // Reference: SpriteComponent'Default__MOHAAxisSquad.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
}