class PainPostDestructibleMethod_SpawnTreasureArchetype extends PostDestructibleMethod
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() PainItem_Treasure_Base TreasureArchetype;
var() int TreasureAmount;

function PostDamage(Actor A)
{
    local PainItem_Treasure_Base SpawnedActor;
    local int I;
    local Vector SpawnLoc, LinearImpulse;
    local Rotator SpawnRot;

    // End:0x4E
    if(A.WorldInfo.GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0x205
    if(TreasureArchetype != none)
    {
        I = 0;
        J0x68:

        // End:0x205 [Loop If]
        if(I < TreasureAmount)
        {
            SpawnLoc = A.Location;
            SpawnLoc += (VRand() * 0.5000000);
            SpawnRot = Rotator(VRand());
            SpawnedActor = A.Spawn(TreasureArchetype.Class,,, SpawnLoc, SpawnRot, TreasureArchetype);
            LinearImpulse = VRand() * float(7);
            LinearImpulse.Z = RandRange(15.0000000, 20.0000000);
            SpawnedActor.CollisionComponent.AddImpulse(LinearImpulse, SpawnLoc);
            SpawnedActor.CollisionComponent.SetRBAngularVelocity(VRand() * 2.0000000);
            I++;
            // [Loop Continue]
            goto J0x68;
        }
    }
    //return;    
}

defaultproperties
{
    TreasureAmount=1
}