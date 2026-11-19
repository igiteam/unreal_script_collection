class SkyItem_Dynamite extends SkySecondaryItem
    native
    config(Game);

var(SecondaryItem) int LowCoverRightThrowAngleOffset;
var(SecondaryItem) int LowCoverLeftThrowAngleOffset;
var(SecondaryItem) int LowCoverCenterThrowAngleOffset;
var(SecondaryItem) int StandingCoverRightThrowAngleOffset;
var(SecondaryItem) int StandingCoverLeftThrowAngleOffset;
var(SecondaryItem) int ThrowAngleOffset;
var bool bThrowing;
var(SecondaryItem) float SpinRateDegrees;

simulated event ReplicatedEvent(name VarName)
{
    // End:0x3B
    if(VarName == 'HeldItem')
    {
        // End:0x30
        if(HeldItem != none)
        {
            AttachItem(AttachedSocket);            
        }
        else
        {
            bThrowing = false;
        }        
    }
    else
    {
        super(SkyWeaponBase).ReplicatedEvent(VarName);
    }
    //return;    
}

// Export USkyItem_Dynamite::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

function int GetThrowAngleOffset()
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Owner);
    // End:0x13E
    if(SPCU != none)
    {
        // End:0x43
        if(int(SPCU.GetCoverState()) == int(0))
        {
            return ThrowAngleOffset;            
        }
        else
        {
            // End:0xAE
            if(int(SPCU.GetCoverType()) == int(1))
            {
                // End:0x86
                if(int(SPCU.GetPositionInCover()) == int(2))
                {
                    return StandingCoverRightThrowAngleOffset;                    
                }
                else
                {
                    // End:0xAB
                    if(int(SPCU.GetPositionInCover()) == int(1))
                    {
                        return StandingCoverLeftThrowAngleOffset;
                    }
                }                
            }
            else
            {
                // End:0x13E
                if(int(SPCU.GetCoverType()) == int(2))
                {
                    // End:0xF1
                    if(int(SPCU.GetPositionInCover()) == int(0))
                    {
                        return LowCoverCenterThrowAngleOffset;                        
                    }
                    else
                    {
                        // End:0x119
                        if(int(SPCU.GetPositionInCover()) == int(2))
                        {
                            return LowCoverRightThrowAngleOffset;                            
                        }
                        else
                        {
                            // End:0x13E
                            if(int(SPCU.GetPositionInCover()) == int(1))
                            {
                                return LowCoverLeftThrowAngleOffset;
                            }
                        }
                    }
                }
            }
        }
    }
    return ThrowAngleOffset;
    //return ReturnValue;    
}

simulated function Release()
{
    local Vector StartTrace, AimDir, HandLoc;
    local Rotator HandDir;
    local SkyPawn SP;
    local SkyPawnCoverUser SPCU;
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local Vector ExtraVel;
    local SkyAIController SkyAI;

    super.Release();
    // End:0x30B
    if((int(Role) == int(ROLE_Authority)) && HeldItem != none)
    {
        SP = SkyPawn(Owner);
        SPCU = SkyPawnCoverUser(Owner);
        // End:0x28E
        if(SP != none)
        {
            SkyAI = SkyAIController(SP.Controller);
            ExtraVel = vect(0.0000000, 0.0000000, 0.0000000);
            // End:0xB1
            if(SkyAI == none)
            {
                SP.Controller.GetPlayerViewPoint(ViewLocation, ViewRotation);                
            }
            else
            {
                SkyAI.GetSecondaryThrowableDirSpeed(AimDir, ExtraVel);
                ViewRotation = Rotator(AimDir);
            }
            // End:0x145
            if((SPCU == none) || (int(SPCU.GetCoverOrientation()) != int(1)) && int(SPCU.GetCoverOrientation()) != int(2))
            {
                ViewRotation.Pitch += (GetThrowAngleOffset());
            }
            AimDir = Vector(ViewRotation);
            SP.Mesh.DetachComponent(HeldItem.SkelMesh);
            HeldItem.AttachComponent(HeldItem.SkelMesh);
            HeldItem.SetBase(none);
            HeldItem.SetHardAttach(false);
            SP.Mesh.GetSocketWorldLocationAndRotation(AttachedSocket, HandLoc, HandDir);
            ExtraVel += ProjectOnTo(SP.Velocity, AimDir);
            ExtraVel = AddMovingLevelVel(ExtraVel);
            HeldItem.launch(HandLoc, HandDir, AimDir, ExtraVel, (SpinRateDegrees / 360.0000000) * 65536.0000000);
            // End:0x28B
            if(SP.MovingLevel != none)
            {
                HeldItem.SetMovingLevel(SP.MovingLevel);
            }            
        }
        else
        {
            StartTrace = Instigator.GetWeaponStartTraceLocation();
            AimDir = Vector(GetAdjustedAim(StartTrace));
            AimDir.Z += AdditionalZThrow;
            HeldItem.launch(HandLoc, HandDir, AimDir);
        }
        HeldItem = none;
        bThrowing = false;
    }
    //return;    
}

// Export USkyItem_Dynamite::execAddMovingLevelVel(FFrame&, void* const)
native function Vector AddMovingLevelVel(Vector originalVel);

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
        FireAmmunition();
        //return;        
    }
    stop;    
}
