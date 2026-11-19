class TurokProjStalactiteNative extends TurokProjectile
    config(Projectile)
    hidecategories(Navigation);

var() export editinline @NULL mMesh;
var @NULL mSpin;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x1C
    if(mMesh != none)
    {
        AttachComponent(mMesh);
    }
    //return;    
}

final simulated function InitSpin()
{
    mSpin = RotRand();
    //return;    
}

final simulated function UpdateSpin()
{
    local @NULL R;

    R = rot(0, 2850, 750);
    SetRotation(Rotation + R);
    //return;    
}

simulated function Tick(float dt)
{
    super.Tick(dt);
    UpdateSpin();
    //return;    
}

defaultproperties
{
    // Reference: TurokSoundController'Default__TurokProjStalactiteNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokRadialShakeComponent'Default__TurokProjStalactiteNative.Shakey'
    begin object name=Shakey
    end object
    mExplosionShake=Shakey
    // Reference: CylinderComponent'Default__TurokProjStalactiteNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProjStalactiteNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=TurokSoundControllerComponent
    CollisionComponent=CollisionCylinder
}