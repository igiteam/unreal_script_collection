class TurokFence extends Actor
    native
    notplaceable
    hidecategories(Navigation);

enum ETrafficDirection
{
    ETD_A,                          // 0
    ETD_B,                          // 1
    ETD_None,                       // 2
    ETD_Both,                       // 3
    ETD_MAX                         // 4
};

var export editinline @NULL mWallData;
var array mPosts;
var() @NULL mFenceMaterial;
var() float mDefaultFenceHeight;
var() byte mTrafficDirection;
var() bool mOwnersOnly;
var() bool mEnabled;
var() bool mBlockPlayers;

simulated function PostBeginPlay()
{
    // End:0x3B
    if((mWallData != none) && mWallData.StaticMesh != none)
    {
        mWallData.StaticMesh.UseSimpleLineCollision = false;
    }
    //return;    
}

// Export UTurokFence::execClearSharedCachedPathInfo(FFrame&, void* const)
private native final function ClearSharedCachedPathInfo();

// Export UTurokFence::execClearIndividualCachedPathInfo(FFrame&, void* const)
private native final function ClearIndividualCachedPathInfo();

function OnToggle(@NULL Action)
{
    // End:0x9B
    if(!self.IsA('TurokMPFence') && WorldInfo.Game.IsA('TurokMPGame'))
    {
        TurokNetLog("Host migration doesn't work for toggled TurokFence actors! Use a TurokMPFence actor instead!");
    }
    // End:0xC4
    if(Action.InputLinks[0].bHasImpulse)
    {
        mEnabled = true;        
    }
    else
    {
        // End:0xED
        if(Action.InputLinks[1].bHasImpulse)
        {
            mEnabled = false;            
        }
        else
        {
            // End:0x11B
            if(Action.InputLinks[2].bHasImpulse)
            {
                mEnabled = !mEnabled;
            }
        }
    }
    // End:0x12F
    if(!mOwnersOnly)
    {
        ClearSharedCachedPathInfo();        
    }
    else
    {
        ClearIndividualCachedPathInfo();
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokFenceMeshComponent'Default__TurokFence.StaticMesh'
    begin object name=StaticMesh class=Class'TurokFenceMeshComponent'
        bAcceptsDecals=false
        bAcceptsLights=false
        BlockRigidBody=false
        bEnableCollisionFilters=true
        bBlockProjectiles=false
        bBlockLargeWeapons=false
        bBlockSmallWeapons=false
        bBlockFriendlyHumanVision=false
        bBlockEnemyHumanVision=false
        bBlockEnemyCreatureVision=false
        bBlockSameActorType=false
        bBlockNavigation=false
        bBlockFootPlacement=false
        AbsoluteTranslation=true
    end object
    mWallData=StaticMesh
    mFenceMaterial=Material'EngineMaterials.MissingCollisionMaterial'
    mDefaultFenceHeight=256.0000000
    mTrafficDirection=2
    mOwnersOnly=true
    mEnabled=true
    mBlockPlayers=true
    bStatic=true
    bWorldGeometry=true
    bMovable=false
    bCollideActors=true
    bBlockActors=true
    bIgnoresVisibilityVolumes=true
    bLockLocation=true
    Components[0]=StaticMesh
    // Reference: TurokFenceRenderingComponent'Default__TurokFence.Connections'
    begin object name=Connections class=Class'TurokFenceRenderingComponent'
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=Connections
    // Reference: SpriteComponent'Default__TurokFence.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokFence'
        HiddenGame=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[2]=Sprite
    CollisionComponent=StaticMesh
}