class MPObjectiveSpawnPoint extends MPObjective
    native
    nativereplication
    config(Game)
    placeable
    hidecategories(Navigation);

simulated event ChangeState(MPObjective.EObjectiveState NewState, optional bool bForce = false)
{
    // End:0x17
    if(int(ObjectiveState) == int(2))
    {
        return;
    }
    super.ChangeState(NewState, bForce);
    //return;    
}

simulated function stateChanged()
{
    DetachComponent(Mesh);
    // End:0x53
    if(int(ObjectiveState) == int(4))
    {
        SetHidden(false);
        Mesh = ArmedMesh;
        CountdownTimer = float(MaxCountdownTimer * 60);
        EarnObjectivePoints(int(PointsForObjectiveArm), false);        
    }
    else
    {
        // End:0x8A
        if(int(ObjectiveState) == int(3))
        {
            SetHidden(false);
            Mesh = UnarmedMesh;
            EarnObjectivePoints(int(PointsForObjectiveDisArm), false);            
        }
        else
        {
            SetHidden(true);
            Mesh = none;
        }
    }
    AttachComponent(Mesh);
    // End:0xCF
    if(MOHAGameReplicationInfo(WorldInfo.GRI).RemainingTime > 0)
    {
        TriggerObjectiveKismet();
    }
    //return;    
}

function Trigger(MOHAPlayerController PC)
{
    // End:0x3A
    if(PC.PlayerReplicationInfo.Team.TeamIndex == Team)
    {
        ChangeState(4);        
    }
    else
    {
        ChangeState(3);
    }
    LastKnownActivater = PC;
    LastKnownActivaterTeamIndex = LastKnownActivater.PlayerReplicationInfo.Team.TeamIndex;
    //return;    
}

simulated function ResetToDefualtState()
{
    ChangeState(3, true);
    //return;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__MPObjectiveSpawnPoint.Sprite'
    begin object name=Sprite
    end object
    PlacementSprite=Sprite
    // Reference: StaticMeshComponent'Default__MPObjectiveSpawnPoint.SMComp1'
    begin object name=SMComp1
    end object
    Mesh=SMComp1
    UnarmedMesh=SMComp1
    // Reference: StaticMeshComponent'Default__MPObjectiveSpawnPoint.SMComp2'
    begin object name=SMComp2
    end object
    ArmedMesh=SMComp2
    ObjectiveState=3
    Components[0]=SMComp1
    Components[1]=Sprite
}