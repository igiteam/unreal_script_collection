class MOHAAlliedSquad extends MOHASquad
    hidecategories(Navigation);

function float EvaluatePerformanceGiver(MOHAPlayerController PC, MOHAAIController C)
{
    local float fDist;
    local Vector vDir;
    local float fDot, fScore;

    // End:0x1A
    if(C.MountedGun != none)
    {
        return 0.0000000;
    }
    // End:0x5B
    if((MOHAAIPawn(C.Pawn) != none) && MOHAAIPawn(C.Pawn).IsMeleeEnabled)
    {
        return 0.0000000;
    }
    fScore = 0.0000000;
    // End:0x84
    if(C.bInAssignedAffordance)
    {
        fScore += 10000.0000000;
    }
    // End:0xAB
    if(Class'MOHAUtilities'.static.GetAiLodAnimated(C))
    {
        fScore += 500.0000000;
    }
    vDir = C.Pawn.Location - PC.Pawn.Location;
    fDist = VSize(PC.Pawn.Location - C.Pawn.Location);
    // End:0x14A
    if(fDist < 1000.0000000)
    {
        fScore += (float(100) * (1.0000000 - (fDist / float(1000))));
    }
    vDir = Normal(vDir);
    fDot = Vector(PC.Rotation) Dot vDir;
    // End:0x196
    if(fDot > 0.0000000)
    {
        fScore += (400.0000000 * fDot);
    }
    return fScore;
    //return ReturnValue;    
}

defaultproperties
{
    MinAssignedForDispatchPerformance=2
    // Reference: KynapseEntityComponent'Default__MOHAAlliedSquad.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAlliedSquad.ABSS0'
    begin object name=ABSS0
    end object
    ABSS=ABSS0
    Components[0]=KynapseEnt0
    // Reference: SpriteComponent'Default__MOHAAlliedSquad.Sprite'
    begin object name=Sprite
    end object
    Components[1]=Sprite
}