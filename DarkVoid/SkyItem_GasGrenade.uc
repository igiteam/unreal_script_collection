class SkyItem_GasGrenade extends SkySecondaryItem
    native
    nativereplication
    config(Game);

// Export USkyItem_GasGrenade::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

simulated function Release()
{
    local Vector StartTrace, AimDir, HandLoc;
    local Rotator HandDir;
    local SkyPawn SP;

    // End:0x12F
    if((int(Role) == int(ROLE_Authority)) && HeldItem != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        AimDir = Vector(GetAdjustedAim(StartTrace));
        AimDir.Z += AdditionalZThrow;
        SP = SkyPawn(Owner);
        // End:0x103
        if(SP != none)
        {
            SP.Mesh.DetachComponent(HeldItem.SkelMesh);
            HeldItem.SetHardAttach(false);
            HeldItem.AttachComponent(HeldItem.SkelMesh);
            SP.Mesh.GetSocketWorldLocationAndRotation(AttachedSocket, HandLoc, HandDir);
        }
        HeldItem.launch(HandLoc, HandDir, AimDir);
        HeldItem = none;
    }
    //return;    
}

simulated event RealEndFire()
{
    //return;    
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
        // End:0x0F
        if(IsInUse())
        {
            return;
        }
        // End:0x1C
        if(AmmoCount <= 0)
        {
            return;
        }
        // End:0x29
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
