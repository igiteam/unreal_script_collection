class TurokDestroyablePartKActor extends KActor
    native
    nativereplication;

struct native ImpactEffect
{
    var(Sound) name mPhysMaterialName;
    var(Sound) @NULL mBounceSound;

    structdefaultproperties
    {
        mPhysMaterialName="None"
        mBounceSound=none
    }
};

var(Sound) float mMinVelocityVol;
var(Sound) float mMaxVelocityVol;
var(Sound) array mImpactEffects;
var export editinline @NULL mSoundController;

function @NULL (@NULL hitMaterial)
{
    local int impactIndex;
    local @NULL physProperty;

    impactIndex = 0;
    // End:0x35
    if(hitMaterial != none)
    {
        physProperty = TurokPhysMatProperty(hitMaterial.GetPhysicalMaterialProperty(Class'TurokPhysMatProperty'));
    }
    // End:0x86
    if((physProperty != none) && physProperty.mPhysMaterialName != 'None')
    {
        impactIndex = Max(0, mImpactEffects.Find(self, @NULL), @NULL, physProperty.mPhysMaterialName);
        return mImpactEffects[impactIndex];
    }
    //return ReturnValue;    
    @NULL
    default.@NULL
    @NULL
}

event RigidBodyCollision(@NULL pHitComponent, @NULL pOtherComponent, const out array pContactInfos, int ContactIndex)
{
    local @NULL velocityVector, relVel;
    local float vel;
    local @NULL Impact;
    local float Volume;

    super(Actor).RigidBodyCollision(pHitComponent, pOtherComponent, pContactInfos, ContactIndex);
    relVel = pContactInfos[0].ContactVelocity[1] - pContactInfos[0].ContactVelocity[0];
    velocityVector = MirrorVectorByNormal(relVel, pContactInfos[0].ContactNormal);
    vel = Abs(VSize(velocityVector));
    Impact = GetImpactEffect(pContactInfos[0].PhysMaterial[ContactIndex]);
    Volume = FClamp(vel - mMinVelocityVol, 0.0000000, mMaxVelocityVol - mMinVelocityVol) / (mMaxVelocityVol - mMinVelocityVol);
    // End:0x11F
    if(Volume > 0.1000000)
    {
        mSoundController.TryPlayLimitedSound('Bounce', Impact.mBounceSound, pContactInfos[0].ContactPosition,,,, Volume);
    }
    //return;    
}

defaultproperties
{
    mMinVelocityVol=1.0000000
    mMaxVelocityVol=300.0000000
    mImpactEffects=/* Array type was not detected. */
    // Reference: TurokSoundController'Default__TurokDestroyablePartKActor.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
        mLimitedSounds=/* Array type was not detected. */
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: StaticMeshComponent'Default__TurokDestroyablePartKActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyablePartKActor.MyLightEnvironment'
        RigidBodyIgnorePawns=true
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=50.0000000
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDestroyablePartKActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bBlockActors=false
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=StaticMeshComponent0
    SupportedEvents=/* Array type was not detected. */
}