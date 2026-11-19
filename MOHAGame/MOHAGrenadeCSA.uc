class MOHAGrenadeCSA extends MOHACSASpawnable
    hidecategories(Navigation);

var MOHAProj_Explosive explosiveOwner;
var float CollisionHeight;
var float CollisionRadius;
var float kickPitchAngle;
var float kickStrength;
var const SoundCue kickGrenadeSoundCue;
var const localized string KickGrenadeMsg;

function PostBeginPlay()
{
    super(MOHACSA).PostBeginPlay();
    CylinderComponent.SetCylinderSize(CollisionRadius, CollisionHeight);
    //return;    
}

function LoadLocalizedStrings()
{
    csaText = KickGrenadeMsg;
    //return;    
}

event bool UsedBy(Pawn User)
{
    local float pawnSpeed;
    local Rotator kickRotation;
    local MOHAPlayerController LocalPlayer;

    // End:0x0B
    if(bDirty)
    {
        return false;
    }
    // End:0x122
    if(explosiveOwner != none)
    {
        kickRotation = User.Rotation;
        kickRotation.Pitch = int(kickPitchAngle * 182.0000000);
        pawnSpeed = VSize(User.Velocity) * 0.4000000;
        explosiveOwner.Speed = kickStrength + pawnSpeed;
        explosiveOwner.InitRotator(kickRotation);
        PlaySound(kickGrenadeSoundCue);
        explosiveOwner.SetPhysics(2);
        explosiveOwner.Instigator = User;
        explosiveOwner.InstigatorController = User.Controller;
        // End:0x117
        if(explosiveOwner.MyKickedDamageType != none)
        {
            explosiveOwner.MyDamageType = explosiveOwner.MyKickedDamageType;
        }
        bDirty = true;        
    }
    else
    {
        return false;
    }
    LocalPlayer = MOHAPlayerController(User.Controller);
    // End:0x1E0
    if(LocalPlayer != none)
    {
        LocalPlayer.RemoveCSA(self);
        LocalPlayer.OnKickGrenade();
        // End:0x1A1
        if(bDisplayed)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveCSA();
            bDisplayed = false;
        }
        // End:0x1E0
        if(MOHAHUD(LocalPlayer.myHUD) != none)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveGrenadeIndicator(explosiveOwner);
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableBy(MOHAPlayerController PlayerController)
{
    local Vector vGrenadePos;

    // End:0x12
    if(!super(MOHACSA).IsUsableBy(PlayerController))
    {
        return false;
    }
    // End:0x28
    if(explosiveOwner.Mesh == none)
    {
        return false;
    }
    vGrenadePos = explosiveOwner.Mesh.Bounds.Origin + (explosiveOwner.Mesh.Bounds.BoxExtent.Z * vect(0.0000000, 0.0000000, 1.0000000));
    // End:0xB2
    if(!FastTrace(PlayerController.Pawn.Location, vGrenadePos))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    CollisionHeight=200.0000000
    CollisionRadius=200.0000000
    kickPitchAngle=32.5000000
    kickStrength=1400.0000000
    kickGrenadeSoundCue=SoundCue'Aud_GCm_FakeWAV.Grenade.Grenade_Kick'
    KickGrenadeMsg="Press %b to Kick Grenade"
    bLookAt=false
    fWeightScale=5.0000000
    // Reference: CylinderComponent'Default__MOHAGrenadeCSA.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAGrenadeCSA.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}