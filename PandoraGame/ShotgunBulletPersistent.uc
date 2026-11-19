class ShotgunBulletPersistent extends SPBulletPersistent
    native
    nativereplication;

simulated function ScaleTracer(float Time)
{
    //return;    
}

simulated function int GetNumPellets()
{
    //return ReturnValue;    
}

simulated event Init(Vector Direction)
{
    local int I;
    local Rotator pelletRot;
    local Vector pelletDir;
    local int NumPellets;
    local float Spread;
    local SPBulletPersistent SpawnedProjectile;
    local Actor SpawnedActor;
    local bool spawnSimulated;

    super.Init(Direction);
    // End:0x23
    if(int(Role) == int(ROLE_Authority))
    {
        RemoteRole = ROLE_SimulatedProxy;
    }
    NumPellets = GetNumPellets();
    Spread = GetSpread();
    // End:0x6C
    if(Instigator != none)
    {
        SPPawn(Instigator).ShotsPerSec += (NumPellets - 1);
    }
    I = 1;
    J0x73:

    // End:0x1F3 [Loop If]
    if(I < NumPellets)
    {
        // End:0x9D
        if(int(Role) <= int(ROLE_SimulatedProxy))
        {
            spawnSimulated = true;            
        }
        else
        {
            spawnSimulated = false;
        }
        pelletRot = Rotator(pelletDir);
        SpawnedActor = WorldInfo.MyActorPool.GetActorFromPool(Class, 'None', Location, pelletRot, none, true, false, self, Instigator, false, 0, spawnSimulated);
        SpawnedProjectile = SPBulletPersistent(SpawnedActor);
        // End:0x12B
        if(Spread ~= float(0))
        {
            pelletRot = Rotation;            
        }
        else
        {
            pelletRot = AddSpread(I, Spread);
        }
        SpawnedProjectile.SetRotation(pelletRot);
        // End:0x1E9
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Velocity = Speed * Vector(pelletRot);
            // End:0x1C2
            if(Instigator != none)
            {
                SpawnedProjectile.Velocity += Instigator.Velocity;
            }
            SpawnedProjectile.lastFramePosition = Location;
            SpawnedProjectile.bNonSuppressing = true;
        }
        ++I;
        // [Loop Continue]
        goto J0x73;
    }
    //return;    
}

simulated function float GetSpread()
{
    //return ReturnValue;    
}

simulated function Rotator AddSpread(int I, float Spread)
{
    local Vector X, Y, Z;
    local float RandY, RandZ;
    local int fakeRandY, fakeRandZ, fakeRandYRemainder, fakeRandZRemainder, adjustedFakeRandYRemainder, adjustedFakeRandZRemainder;

    GetAxes(Rotation, X, Y, Z);
    fakeRandY = (I * 7) - 1;
    fakeRandZ = (I * I) - 3;
    fakeRandYRemainder = int(float(fakeRandY) % float(10));
    fakeRandZRemainder = int(float(fakeRandZ) % float(10));
    adjustedFakeRandYRemainder = fakeRandYRemainder - 5;
    adjustedFakeRandZRemainder = fakeRandZRemainder - 5;
    RandY = float(adjustedFakeRandYRemainder) / 10.0000000;
    RandZ = float(adjustedFakeRandZRemainder) / 10.0000000;
    return Rotator((X + ((RandY * Spread) * Y)) + ((RandZ * Spread) * Z));
    //return ReturnValue;    
}
