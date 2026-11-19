class EvilPawnClothingAssetReplicator extends ReplicationInfo
    hidecategories(Navigation,Movement,Collision);

struct ClothActionParams
{
    var int ClothIndex;
    var bool bHealthStepOcurred;

    structdefaultproperties
    {
        ClothIndex=-1
        bHealthStepOcurred=false
    }
};

struct ClothActionDamageParams extends ClothActionParams
{
    var EvilTypes.EClothAssetSpecialActionOnTakeDamage Action;

    structdefaultproperties
    {
        ClothIndex=0
    }
};

struct ClothActionZeroHealthParams extends ClothActionParams
{
    var EvilTypes.EClothAssetSpecialActionOnZeroHealth Action;

    structdefaultproperties
    {
        ClothIndex=0
    }
};

struct ClothActionRagdollParams extends ClothActionParams
{
    var EvilTypes.EClothAssetSpecialActionOnRagdoll Action;

    structdefaultproperties
    {
        ClothIndex=0
    }
};

struct TryDropOnZeroHealthParams extends ClothActionParams
{
    var class<DamageType> DamageType;
    var Vector HitLocation;
    var Vector Momentum;

    structdefaultproperties
    {
        ClothIndex=0
    }
};

struct TryDropOnRagdollParams extends TryDropOnZeroHealthParams
{
    var bool bPlayingDeath;
};

var EvilPawnClothAssetInterface HeadClothAsset;
var EvilPawnClothAssetInterface EquipmentClothAsset;
var EvilPawnClothAssetInterface ShieldClothAsset;
var array<EvilPawnClothAssetInterface> ClothesAssets;
var EvilPawn PawnOwner;
var repnotify ClothActionDamageParams ReplicatedClothActionDamage;
var repnotify ClothActionZeroHealthParams ReplicatedClothActionZeroHealth;
var repnotify ClothActionRagdollParams ReplicatedClothActionRagdoll;
var repnotify TryDropOnZeroHealthParams ReplicatedDropOnZeroHealth;
var repnotify TryDropOnRagdollParams ReplicatedDropOnRagdoll;

replication
{
    // Pos:0x000
    if(bNetDirty
        ReplicatedClothActionDamage, ReplicatedClothActionRagdoll, 
        ReplicatedClothActionZeroHealth, ReplicatedDropOnRagdoll, 
        ReplicatedDropOnZeroHealth;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x81
        case 'ReplicatedClothActionDamage':
            ClientDoSpecialClothActionOnTakeDamage(ReplicatedClothActionDamage.Action, ReplicatedClothActionDamage.ClothIndex, ReplicatedClothActionDamage.bHealthStepOcurred);
            // End:0x26B
            break;
        // End:0xD2
        case 'ReplicatedClothActionZeroHealth':
            ClientDoSpecialClothActionOnZeroHealth(ReplicatedClothActionZeroHealth.Action, ReplicatedClothActionZeroHealth.ClothIndex);
            // End:0x26B
            break;
        // End:0x123
        case 'ReplicatedClothActionRagdoll':
            ClientDoSpecialClothActionOnRagdoll(ReplicatedClothActionRagdoll.Action, ReplicatedClothActionRagdoll.ClothIndex);
            // End:0x26B
            break;
        // End:0x1AC
        case 'ReplicatedDropOnZeroHealth':
            ClientTryDropOnZeroHealth(ReplicatedDropOnZeroHealth.DamageType, ReplicatedDropOnZeroHealth.HitLocation, ReplicatedDropOnZeroHealth.Momentum, ReplicatedDropOnZeroHealth.ClothIndex);
            // End:0x26B
            break;
        // End:0x252
        case 'ReplicatedDropOnRagdoll':
            ClientTryDropOnRagdoll(ReplicatedDropOnRagdoll.DamageType, ReplicatedDropOnRagdoll.HitLocation, ReplicatedDropOnRagdoll.Momentum, ReplicatedDropOnRagdoll.bPlayingDeath, ReplicatedDropOnRagdoll.ClothIndex);
            // End:0x26B
            break;
        // End:0xFFFF
        default:
            super(Actor).ReplicatedEvent(VarName);
            // End:0x26B
            break;
            break;
    }
    //return;    
}

simulated function ClientInitialize(EvilPawn EP)
{
    SetOwner(EP);
    PawnOwner = EP;
    //return;    
}

simulated function int GetIndexForClothComponent(EvilPawnClothAssetInterface clothComponent)
{
    local int Index;
    local EvilPawnClothAssetInterface TempClothComp;
    local bool bResult;

    Index = -1;
    // End:0x90
    if(NotEqual_InterfaceInterface(HeadClothAsset, EvilPawnClothAssetInterface(none)) && HeadClothAsset.GetObject() == clothComponent.GetObject())
    {
        Index = 0;
        bResult = true;        
    }
    else
    {
        // End:0x111
        if(NotEqual_InterfaceInterface(EquipmentClothAsset, EvilPawnClothAssetInterface(none)) && EquipmentClothAsset.GetObject() == clothComponent.GetObject())
        {
            Index = 1;
            bResult = true;            
        }
        else
        {
            // End:0x193
            if(NotEqual_InterfaceInterface(ShieldClothAsset, EvilPawnClothAssetInterface(none)) && ShieldClothAsset.GetObject() == clothComponent.GetObject())
            {
                Index = 2;
                bResult = true;                
            }
            else
            {
                Index = 2;
                // End:0x216
                foreach ClothesAssets(TempClothComp)
                {
                    Index++;
                    // End:0x215
                    if(TempClothComp.GetObject() == clothComponent.GetObject())
                    {
                        bResult = true;                        
                    }
                    else
                    {                        
                    }
                }                
            }
        }
    }
    return ((bResult) ? Index : -1);
    //return ReturnValue;    
}

simulated function EvilPawnClothAssetInterface GetClothComponentFromIndex(int Index)
{
    local EvilPawnClothAssetInterface clothAsset;

    // End:0x25
    if(Index == 0)
    {
        clothAsset = HeadClothAsset;        
    }
    else
    {
        // End:0x4A
        if(Index == 1)
        {
            clothAsset = EquipmentClothAsset;            
        }
        else
        {
            // End:0x70
            if(Index == 2)
            {
                clothAsset = ShieldClothAsset;                
            }
            else
            {
                Index -= 3;
                clothAsset = ClothesAssets[Index];
            }
        }
    }
    return clothAsset;
    //return ReturnValue;    
}

function DoSpecialClothActionOnTakeDamage(EvilTypes.EClothAssetSpecialActionOnTakeDamage Action, EvilPawnClothAssetInterface clothComponent, bool bHealthStepOcurred)
{
    local int Index;

    Index = GetIndexForClothComponent(clothComponent);
    // End:0x2E
    if(Index < 0)
    {
        return;
    }
    ReplicatedClothActionDamage.Action = Action;
    ReplicatedClothActionDamage.ClothIndex = Index;
    ReplicatedClothActionDamage.bHealthStepOcurred = bHealthStepOcurred;
    bForceNetUpdate = true;
    ClientDoSpecialClothActionOnTakeDamage(Action, GetIndexForClothComponent(clothComponent), bHealthStepOcurred);
    //return;    
}

simulated function ClientDoSpecialClothActionOnTakeDamage(EvilTypes.EClothAssetSpecialActionOnTakeDamage Action, int Index, bool bHealthStepOcurred)
{
    PawnOwner.DoSpecialClothActionOnTakeDamage(Action, GetClothComponentFromIndex(Index), bHealthStepOcurred);
    //return;    
}

function DoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, EvilPawnClothAssetInterface clothComponent)
{
    local int Index;

    Index = GetIndexForClothComponent(clothComponent);
    // End:0x2E
    if(Index < 0)
    {
        return;
    }
    ReplicatedClothActionZeroHealth.Action = Action;
    ReplicatedClothActionZeroHealth.ClothIndex = Index;
    ReplicatedClothActionZeroHealth.bHealthStepOcurred = false;
    bForceNetUpdate = true;
    ClientDoSpecialClothActionOnZeroHealth(Action, Index);
    //return;    
}

simulated function ClientDoSpecialClothActionOnZeroHealth(EvilTypes.EClothAssetSpecialActionOnZeroHealth Action, int Index)
{
    PawnOwner.DoSpecialClothActionOnZeroHealth(Action, GetClothComponentFromIndex(Index));
    //return;    
}

function DoSpecialClothActionOnRagdoll(EvilTypes.EClothAssetSpecialActionOnRagdoll Action, EvilPawnClothAssetInterface clothComponent)
{
    local int Index;

    Index = GetIndexForClothComponent(clothComponent);
    // End:0x2E
    if(Index < 0)
    {
        return;
    }
    ReplicatedClothActionRagdoll.Action = Action;
    ReplicatedClothActionRagdoll.ClothIndex = Index;
    ReplicatedClothActionRagdoll.bHealthStepOcurred = false;
    bForceNetUpdate = true;
    ClientDoSpecialClothActionOnRagdoll(Action, Index);
    //return;    
}

simulated function ClientDoSpecialClothActionOnRagdoll(EvilTypes.EClothAssetSpecialActionOnRagdoll Action, int Index)
{
    PawnOwner.DoSpecialClothActionOnRagdoll(Action, GetClothComponentFromIndex(Index));
    //return;    
}

function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, EvilPawnClothAssetInterface clothComponent)
{
    local int Index;

    Index = GetIndexForClothComponent(clothComponent);
    // End:0x2E
    if(Index < 0)
    {
        return;
    }
    ReplicatedDropOnZeroHealth.DamageType = DamageType;
    ReplicatedDropOnZeroHealth.HitLocation = HitLocation;
    ReplicatedDropOnZeroHealth.Momentum = Momentum;
    ReplicatedDropOnZeroHealth.ClothIndex = Index;
    bForceNetUpdate = true;
    //return;    
}

simulated function ClientTryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, int Index)
{
    local EvilPawnClothAssetInterface ClothComp;

    ClothComp = GetClothComponentFromIndex(Index);
    // End:0x79
    if(NotEqual_InterfaceInterface(ClothComp, EvilPawnClothAssetInterface(none)))
    {
        ClothComp.TryDropOnZeroHealth(DamageType, HitLocation, Momentum, true);
    }
    //return;    
}

function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath, EvilPawnClothAssetInterface clothComponent)
{
    local int Index;

    Index = GetIndexForClothComponent(clothComponent);
    // End:0x2E
    if(Index < 0)
    {
        return;
    }
    ReplicatedDropOnRagdoll.DamageType = DamageType;
    ReplicatedDropOnRagdoll.HitLocation = HitLocation;
    ReplicatedDropOnRagdoll.Momentum = Momentum;
    ReplicatedDropOnRagdoll.bPlayingDeath = bPlayingDeath;
    ReplicatedDropOnRagdoll.ClothIndex = Index;
    bForceNetUpdate = true;
    //return;    
}

simulated function ClientTryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath, int Index)
{
    local EvilPawnClothAssetInterface ClothComp;

    ClothComp = GetClothComponentFromIndex(Index);
    // End:0x83
    if(NotEqual_InterfaceInterface(ClothComp, EvilPawnClothAssetInterface(none)))
    {
        ClothComp.TryDropOnRagdoll(DamageType, HitLocation, Momentum, bPlayingDeath, true);
    }
    //return;    
}

defaultproperties
{
    ReplicatedClothActionDamage=(Action=EClothAssetSpecialActionOnTakeDamage.ECASATD_None,ClothIndex=-1,bHealthStepOcurred=false)
    ReplicatedClothActionZeroHealth=(Action=EClothAssetSpecialActionOnZeroHealth.ECASAOZH_None,ClothIndex=-1,bHealthStepOcurred=false)
    ReplicatedClothActionRagdoll=(Action=EClothAssetSpecialActionOnRagdoll.ECASAOR_None,ClothIndex=-1,bHealthStepOcurred=false)
    ReplicatedDropOnZeroHealth=(DamageType=none,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000),ClothIndex=-1,bHealthStepOcurred=false)
    ReplicatedDropOnRagdoll=(bPlayingDeath=false,DamageType=none,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000),ClothIndex=-1,bHealthStepOcurred=false)
}