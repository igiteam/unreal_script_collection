class TurokDroppedFlagPickup extends TurokDroppedPickup
    hidecategories(Navigation);

var private @NULL mFlagFlare;
var private export editinline @NULL mFlagParticle;

simulated function SetFlagColor(class<Class> FlagClass, @NULL PickupMesh)
{
    local @NULL MaterialInstanceConstant;

    MaterialInstanceConstant = new (self) Class'Engine.MaterialInstanceConstant';
    MaterialInstanceConstant.SetParent(MeshComponent(PickupMesh).GetMaterial(0));
    MeshComponent(PickupMesh).SetMaterial(0, MaterialInstanceConstant);
    MaterialInstanceConstant.SetVectorParameterValue('VEmssHue', FlagClass.default.mVEmssHue);
    //return;    
}

simulated event SetPickupMesh(@NULL PickupMesh)
{
    local class<Class> FlagClass;

    // End:0x31
    if((int(Role) == int(ROLE_Authority)) && mFlagFlare == none)
    {
        mFlagFlare = __NFUN_278__(Class'TurokProjFlagFlare', self);
    }
    // End:0x80
    if(mFlagParticle == none)
    {
        mFlagParticle = ParticleSystemComponent(class<TurokMPTeamFlag>(InventoryClass).default.mFlagParticleComponent.Clone(self));
        AttachComponent(mFlagParticle);
        mFlagParticle.ActivateSystem();
    }
    FlagClass = class<TurokMPTeamFlag>(InventoryClass);
    SetFlagColor(FlagClass, PickupMesh);
    super.SetPickupMesh(PickupMesh);
    //return;    
}

simulated function Destroyed()
{
    local @NULL B, F;

    // End:0x8A
    if(int(Role) == int(ROLE_Authority))
    {
        F = TurokMPTeamFlag(Inventory);
        // End:0x8A
        if(F != none)
        {
            B = TurokMPTeamFlagBase(F.ReleaseFactory());
            // End:0x8A
            if(B != none)
            {
                B.UpdateFlagStatus(true);
                // End:0x8A
                if(LifeSpan <= 0.0001000)
                {
                    B.FlagAutoReturned();
                }
            }
        }
    }
    // End:0xB6
    if(mFlagParticle != none)
    {
        mFlagParticle.DeactivateSystem();
        DetachComponent(mFlagParticle);
        mFlagParticle = none;
    }
    // End:0xCD
    if(mFlagFlare != none)
    {
        mFlagFlare.Destroy();
    }
    super.Destroyed();
    //return;    
}

state Pickup
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        TurokFlagGame(WorldInfo.Game).UpdateFlagState(int(GetTeamNum()), 3, self);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokDroppedFlagPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    mCylinderCollision=CollisionCylinder
    // Reference: TurokSoundController'Default__TurokDroppedFlagPickup.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDroppedFlagPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}