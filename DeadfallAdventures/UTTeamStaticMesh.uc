class UTTeamStaticMesh extends StaticMeshActor
    hidecategories(Navigation);

var() array<MaterialInterface> TeamMaterials;
var() Material NeutralMaterial;

simulated event PreBeginPlay()
{
    local EvilGameObjective O, Best;
    local float Distance, BestDistance;

    // End:0x11E
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        BestDistance = 1000000.0000000;
        // End:0xDF
        foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', O)
        {
            Distance = VSize(Location - O.Location);
            // End:0xDE
            if(Distance < BestDistance)
            {
                BestDistance = Distance;
                Best = O;
            }            
        }        
        // End:0x112
        if(Best != none)
        {
            Best.AddTeamStaticMesh(self);            
        }
        else
        {
            SetTeamNum(255);
        }
    }
    //return;    
}

simulated function SetTeamNum(byte NewTeam)
{
    // End:0xCE
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x96
        if(int(NewTeam) < TeamMaterials.Length)
        {
            // End:0x93
            if(TeamMaterials[int(NewTeam)] != none)
            {
                StaticMeshComponent.SetMaterial(0, TeamMaterials[int(NewTeam)]);
            }            
        }
        else
        {
            // End:0xCE
            if(NeutralMaterial != none)
            {
                StaticMeshComponent.SetMaterial(0, NeutralMaterial);
            }
        }
    }
    //return;    
}

defaultproperties
{
    TeamMaterials[0]=none
    TeamMaterials[1]=none
    // Reference: StaticMeshComponent'Default__UTTeamStaticMesh.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        ReplacementPrimitive=none
    end object
    StaticMeshComponent=StaticMeshComponent0
    Components[0]=StaticMeshComponent0
    bStatic=false
    bTickIsDisabled=true
    CollisionComponent=StaticMeshComponent0
}