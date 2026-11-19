class SkyItem_AirRemote extends SkySecondaryItem
    native
    nativereplication
    config(Game);

var() SkyVehicle AirRemoteArchetype;
var() float TimeBetweenReleaseAndExpand;

// Export USkyItem_AirRemote::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

simulated function AttachAirRemote()
{
    local SkyPawn SP;
    local Vector HandLoc;
    local Rotator HandRot;

    SP = SkyPawn(Owner);
    // End:0x111
    if((SP != none) && HeldItem != none)
    {
        SP.Mesh.GetSocketWorldLocationAndRotation(AttachedSocket, HandLoc, HandRot);
        HeldItem.SetLocation(HandLoc);
        HeldItem.SetRotation(HandRot);
        HeldItem.SetHardAttach(true);
        HeldItem.SetBase(SP);
        HeldItem.DetachComponent(HeldItem.SkelMesh);
        SP.Mesh.AttachComponentToSocket(HeldItem.SkelMesh, AttachedSocket);
        HeldItem.SkelMesh.SetLightEnvironment(SP.LightEnvironment);
    }
    //return;    
}

simulated function Release()
{
    local Vector StartTrace, AimDir, HandLoc;
    local Rotator HandDir;
    local SkyPawn SP;

    super.Release();
    // End:0x141
    if((int(Role) == int(ROLE_Authority)) && HeldItem != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        AimDir = Vector(GetAdjustedAim(StartTrace));
        AimDir.Z += AdditionalZThrow;
        SP = SkyPawn(Owner);
        // End:0x109
        if(SP != none)
        {
            SP.Mesh.DetachComponent(HeldItem.SkelMesh);
            HeldItem.SetHardAttach(false);
            HeldItem.AttachComponent(HeldItem.SkelMesh);
            SP.Mesh.GetSocketWorldLocationAndRotation(AttachedSocket, HandLoc, HandDir);
        }
        HeldItem.launch(HandLoc, HandDir, AimDir);
        SetTimer(TimeBetweenReleaseAndExpand, false, 'ChangeProjToVehicleAndRide');
    }
    //return;    
}

function ChangeProjToVehicleAndRide()
{
    local SkyVehicle_AirRemote SpawnedRemote;

    SpawnedRemote = Spawn(Class'SkyVehicle_AirRemote', none,, HeldItem.Location, Rotator(HeldItem.Velocity), AirRemoteArchetype);
    // End:0xAE
    if(SpawnedRemote != none)
    {
        SpawnedRemote.Takeoff();
        SpawnedRemote.TryToDrive(Pawn(Owner));
        SpawnedRemote.Mesh.AddImpulse(HeldItem.Velocity, vect(0.0000000, 0.0000000, 0.0000000));
    }
    HeldItem.Destroy();
    HeldItem = none;
    RealEndFire();
    //return;    
}

simulated event AttachItem(name SocketName)
{
    //return;    
}

simulated function bool CanFire()
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x53
    if(SP != none)
    {
        // End:0x37
        if(int(SP.Physics) == int(2))
        {
            return false;
        }
        // End:0x53
        if(int(SP.RocketPackState) != int(0))
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x0D
        if(HeldItem != none)
        {
            return;
        }
        super.BeginFire(FireModeNum);
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        // End:0x1C
        if(int(Using) == int(1))
        {
            SetItemState(2);
        }
        super(SkyWeapon).EndFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        FireAmmunition();
        TimeWeaponFiring(CurrentFireMode);
        AttachAirRemote();
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        super(SkyWeapon).EndFire(FireModeNum);
        // End:0x3F
        if(int(Using) == int(2))
        {
            ClearFlashCount();
            ClearFlashLocation();
            ClearTimer('RefireCheckTimer');
        }
        SetItemState(2);
        GotoState('Active');
        //return;        
    }
    stop;    
}
