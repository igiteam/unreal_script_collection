class TurokMPTeamFlag extends TurokMPObjectiveItem
    abstract
    native
    config(Game)
    hidecategories(Navigation);

var const byte mTeamIndex;
var const export editinline @NULL mFlagParticleComponent;
var protected const export editinline @NULL mFlagMeshComponent;
var protected @NULL mMaterialConstant;
var const config float mSEmssInt;
var const config @NULL mVEmssHue;

// Export UTurokMPTeamFlag::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function Destroyed()
{
    super.Destroyed();
    //return;    
}

function @NULL GetFlagBase()
{
    local @NULL FlagBase;

    FlagBase = TurokMPTeamFlagBase(mMPPickupFactory);
    return FlagBase;
    //return ReturnValue;    
}

function AnnouncePickup(@NULL Other, optional class<Class> pickedUpFrom = none)
{
    local @NULL PRI;

    super(Inventory).AnnouncePickup(Other);
    // End:0x46
    if(pickedUpFrom == Class'TurokDroppedFlagPickup')
    {
        Other.PlaySound(GetFlagBase().mPickupDroppedFlagSound);
    }
    // End:0x9D
    if(TurokFlagGame(WorldInfo.Game) != none)
    {
        PRI = TurokMPPlayerReplicationInfo(Other.PlayerReplicationInfo);
        // End:0x9D
        if(PRI != none)
        {
            PRI.AttachFlag(int(mTeamIndex));
        }
    }
    //return;    
}

function ItemRemovedFromInvManager()
{
    local @NULL PRI, ownerPawn;

    // End:0x6B
    if(TurokFlagGame(WorldInfo.Game) != none)
    {
        ownerPawn = Pawn(Owner);
        // End:0x6B
        if(ownerPawn != none)
        {
            PRI = TurokMPPlayerReplicationInfo(ownerPawn.PlayerReplicationInfo);
            // End:0x6B
            if(PRI != none)
            {
                PRI.DetachFlag();
            }
        }
    }
    super(TurokInventory).ItemRemovedFromInvManager();
    //return;    
}

function ItemDropped(@NULL P, @NULL inst)
{
    local @NULL FlagBase;

    FlagBase = TurokMPTeamFlagBase(mMPPickupFactory);
    // End:0x38
    if(FlagBase != none)
    {
        FlagBase.FlagDropped(TurokPawnPlayer(inst));
    }
    //return;    
}

defaultproperties
{
    // Reference: ParticleSystemComponent'Default__TurokMPTeamFlag.FlagParticleComponent'
    begin object name=FlagParticleComponent class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
    end object
    mFlagParticleComponent=FlagParticleComponent
    // Reference: StaticMeshComponent'Default__TurokMPTeamFlag.FlagMeshComponent'
    begin object name=FlagMeshComponent class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true)
    end object
    mFlagMeshComponent=FlagMeshComponent
    mVEmssHue=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    mHudIconTexture=Texture2D'TurokHudMultiplayer.Inventory.MPHUDIcon_PowerCore_HD'
    PickupSound=none
    DroppedPickupClass=Class'TurokDroppedFlagPickup'
    // Reference: StaticMeshComponent'Default__TurokMPTeamFlag.DroppedFlagMeshComponent'
    begin object name=DroppedFlagMeshComponent class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true)
    end object
    DroppedPickupMesh=DroppedFlagMeshComponent
    PickupFactoryMesh=FlagMeshComponent
    // Reference: SpriteComponent'Default__TurokMPTeamFlag.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}