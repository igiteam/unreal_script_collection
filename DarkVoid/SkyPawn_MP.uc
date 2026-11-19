class SkyPawn_MP extends SkyPawnPlayerCharacter
    native
    config(Pawn);

var string DeadName;
var SkyItem_RocketPack SecretRocketPackArchetype;
var transient bool bAFK;
var const float InteractionCheckPeriod;
var transient float InteractionCheckTimer;
var repnotify transient byte WeaponState;
var repnotify transient byte SecondaryState;
var repnotify transient byte PReloadState;
var repnotify transient byte SReloadState;
var repnotify transient int WSMFlags;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        DeadName, bAFK;

    // Pos:0x00D
    if(!bNetOwner
        PReloadState, SReloadState, 
        SecondaryState, WSMFlags, 
        WeaponState;
}

function UnPossessed()
{
    // End:0x20
    if(PlayerReplicationInfo != none)
    {
        DeadName = PlayerReplicationInfo.PlayerName;
    }
    super(Pawn).UnPossessed();
    //return;    
}

simulated function string GetHumanReadableName()
{
    // End:0x1E
    if(PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;        
    }
    else
    {
        // End:0x32
        if(Health <= 0)
        {
            return DeadName;            
        }
        else
        {
            // End:0x6E
            if((DrivenVehicle != none) && DrivenVehicle.PlayerReplicationInfo != none)
            {
                return DrivenVehicle.PlayerReplicationInfo.PlayerName;
            }
        }
    }
    return super(Pawn).GetHumanReadableName();
    //return ReturnValue;    
}

simulated function int GetCurrentBounty()
{
    // End:0x2A
    if(SkyPlayerReplicationInfo(PlayerReplicationInfo) != none)
    {
        return int(SkyPlayerReplicationInfo(PlayerReplicationInfo).Score);        
    }
    else
    {
        return -1;
    }
    //return ReturnValue;    
}

exec function GiveRocketpack()
{
    ServerGiveRocketpack();
    //return;    
}

reliable server event ServerSetWeaponState(byte st)
{
    WeaponState = st;
    // End:0x44
    if((Controller != none) && !Controller.IsLocalPlayerController())
    {
        ReplicatedEvent('WeaponState');
    }
    //return;    
}

reliable server event ServerSetSecondaryState(byte st)
{
    SecondaryState = st;
    // End:0x44
    if((Controller != none) && !Controller.IsLocalPlayerController())
    {
        ReplicatedEvent('SecondaryState');
    }
    //return;    
}

reliable server event ServerSetPrimaryReloadState(byte st)
{
    PReloadState = st;
    // End:0x44
    if((Controller != none) && !Controller.IsLocalPlayerController())
    {
        ReplicatedEvent('PReloadState');
    }
    //return;    
}

reliable server event ServerSetSecondaryReloadState(byte st)
{
    SReloadState = st;
    // End:0x44
    if((Controller != none) && !Controller.IsLocalPlayerController())
    {
        ReplicatedEvent('SReloadState');
    }
    //return;    
}

reliable server event ServerSetWSMFlags(byte fl)
{
    WSMFlags = int(fl);
    // End:0x46
    if((Controller != none) && !Controller.IsLocalPlayerController())
    {
        ReplicatedEvent('WSMFlags');
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x51
    if(VarName == 'WeaponState')
    {
        // End:0x4E
        if(int(WeaponState) != int(PrimaryWSM.GetState()))
        {
            PrimaryWSM.ChangeState(WeaponState);
        }        
    }
    else
    {
        // End:0xA2
        if(VarName == 'SecondaryState')
        {
            // End:0x9F
            if(int(SecondaryState) != int(SecondaryWSM.GetState()))
            {
                SecondaryWSM.ChangeState(SecondaryState);
            }            
        }
        else
        {
            // End:0xF3
            if(VarName == 'PReloadState')
            {
                // End:0xF0
                if(int(PReloadState) != int(PrimaryWSM.GetReloadState()))
                {
                    PrimaryWSM.SetReloadState(PReloadState);
                }                
            }
            else
            {
                // End:0x144
                if(VarName == 'SReloadState')
                {
                    // End:0x141
                    if(int(SReloadState) != int(SecondaryWSM.GetReloadState()))
                    {
                        SecondaryWSM.SetReloadState(SReloadState);
                    }                    
                }
                else
                {
                    // End:0x1E0
                    if(VarName == 'WSMFlags')
                    {
                        PrimaryWSM.TargetingInput((WSMFlags & 1) == 1);
                        SecondaryWSM.TargetingInput((WSMFlags & 2) == 2);
                        PrimaryWSM.FiringInput((WSMFlags & 4) == 4);
                        SecondaryWSM.FiringInput((WSMFlags & 8) == 8);                        
                    }
                    else
                    {
                        super(SkyPawnCoverUser).ReplicatedEvent(VarName);
                    }
                }
            }
        }
    }
    //return;    
}

reliable server function ServerGiveRocketpack()
{
    // End:0xB4
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x28
        if(RocketPack != none)
        {
            RocketPack.Destroy();
        }
        RocketPack = SkyItem_RocketPack(CreateInventory(Class'SkyItem_RocketPack', true, SecretRocketPackArchetype));
        // End:0xB4
        if(RocketPack != none)
        {
            RocketPack.AttachTo(Mesh, 'skt_rocketpack');
            Mesh.AttachComponentToSocket(RocketPack.Mesh, 'skt_rocketpack');
            // End:0xB4
            if(RocketPack.bAllowBoost)
            {
                bCanFly = true;
            }
        }
    }
    //return;    
}

simulated event SHoldGameObject(SkyCarriedObject SkyGameObj)
{
    // End:0x5F
    if(IsFirstPerson())
    {
        SkyGameObj.SetBase(self);
        SkyGameObj.SetRelativeRotation(SkyGameObj.GameObjRot1P);
        SkyGameObj.SetRelativeLocation(SkyGameObj.GameObjOffset1P);        
    }
    else
    {
        // End:0xA2
        if(SkyGameObj.GameObjBone3P != 'None')
        {
            SkyGameObj.SetBase(self,, Mesh, SkyGameObj.GameObjBone3P);            
        }
        else
        {
            SkyGameObj.SetBase(self);
        }
        SkyGameObj.SetRelativeRotation(SkyGameObj.GameObjRot3P);
        SkyGameObj.SetRelativeLocation(SkyGameObj.GameObjOffset3P);
    }
    //return;    
}

// Export USkyPawn_MP::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
