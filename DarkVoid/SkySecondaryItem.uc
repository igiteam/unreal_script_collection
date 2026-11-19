class SkySecondaryItem extends SkyWeapon
    native
    config(Game);

enum SSI_Using
{
    SSIU_Idle,                      // 0
    SSIU_Charging,                  // 1
    SSIU_Executing,                 // 2
    SSIU_MAX                        // 3
};

var SkySecondaryItem.SSI_Using Using;
var bool UsingMeansAiming;
var() bool BeginExecutes;
var(AI) float BotMinHoldBeforeUseSec;
var(AI) float BotHoldBeforeUseRandSec;
var() float AdditionalZThrow;
var SkyProj_SecondaryItemBase ProjArchetype;
var repnotify SkyProj_SecondaryItemBase HeldItem;
var name AttachedSocket;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        HeldItem, Using;
}

simulated event bool IsInUse()
{
    return int(Using) != int(0);
    //return ReturnValue;    
}

simulated function float GetWeaponRating()
{
    return 2.0000000;
    //return ReturnValue;    
}

simulated function MyEndFire()
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x34
    if(SP != none)
    {
        SP.StopSecondaryItemFire(CurrentFireMode);
    }
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    // End:0x1F
    if(int(Using) == int(2))
    {
        SetItemState(0);        
    }
    else
    {
        // End:0x3B
        if(int(Using) == int(1))
        {
            SetItemState(2);
        }
    }
    super.EndFire(FireModeNum);
    //return;    
}

simulated function SetItemState(SkySecondaryItem.SSI_Using NextState)
{
    Using = NextState;
    //return;    
}

simulated event Release()
{
    RealEndFire();
    //return;    
}

// Export USkySecondaryItem::execDrawWeaponCrosshair(FFrame&, void* const)
native function DrawWeaponCrosshair(HUD HUD);

// Export USkySecondaryItem::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

simulated function HolderDied()
{
    // End:0x2A
    if(HeldItem != none)
    {
        HeldItem.StartingVelocity = 0.0000000;
        Release();
    }
    //return;    
}

simulated event RealEndFire()
{
    SetItemState(0);
    //return;    
}

simulated function AttachItem(name SocketName)
{
    local SkyPawn SP;
    local Vector HandLoc;
    local Rotator HandRot;

    SP = SkyPawn(Owner);
    AttachedSocket = SocketName;
    // End:0x11C
    if((SP != none) && HeldItem != none)
    {
        SP.Mesh.GetSocketWorldLocationAndRotation(SocketName, HandLoc, HandRot);
        HeldItem.SetLocation(HandLoc);
        HeldItem.SetRotation(HandRot);
        HeldItem.SetHardAttach(true);
        HeldItem.SetBase(SP);
        HeldItem.DetachComponent(HeldItem.SkelMesh);
        SP.Mesh.AttachComponentToSocket(HeldItem.SkelMesh, SocketName);
        HeldItem.SkelMesh.SetLightEnvironment(SP.LightEnvironment);
    }
    //return;    
}

simulated event AttachItemNotify(name SocketName)
{
    local Projectile Proj;
    local MaterialInstanceConstant mic;
    local SkyPawn SP;

    // End:0x0D
    if(HeldItem != none)
    {
        return;
    }
    Proj = SkyWeaponProjectileFire();
    // End:0x41
    if(SkyProj_SecondaryItemBase(Proj) != none)
    {
        HeldItem = SkyProj_SecondaryItemBase(Proj);
        bNetDirty = true;
    }
    // End:0x5E
    if(HeldItem != none)
    {
        AttachItem(SocketName);        
    }
    else
    {
        AttachedSocket = SocketName;
    }
    SP = SkyPawn(Owner);
    // End:0x131
    if(((((SP != none) && SkyPlayerController(SP.Controller) != none) && SkyPlayerInput(SkyPlayerController(SP.Controller).PlayerInput) != none) && SkyPlayerInput(SkyPlayerController(SP.Controller).PlayerInput).bIsInForeground) && HeldItem.SkelMesh != none)
    {
        HeldItem.SkelMesh.SetDepthPriorityGroup(2);
    }
    mic = MaterialInstanceConstant(HeldItem.SkelMesh.GetMaterial(GlimmerMaterialIndex));
    // End:0x1A1
    if(mic != none)
    {
        mic.SetVectorParameterValue('itemflash', MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 1.0000000));
    }
    //return;    
}

simulated function bool CanFire()
{
    return true;
    //return ReturnValue;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        ForceEndFire();
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local bool OwnerIsAnNPC;

        // End:0x0F
        if(IsInUse())
        {
            return;
        }
        OwnerIsAnNPC = Instigator.Controller.IsA('SkyBot') || Instigator.IsA('SkyNPC');
        // End:0x78
        if(!OwnerIsAnNPC && BeginExecutes)
        {
            SetTimer(0.0100000, false, 'MyEndFire');
        }
        SetItemState(1);
        super.BeginFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        bWeaponPutDown = true;
        ForceEndFire();
        //return;        
    }
    stop;    
}
