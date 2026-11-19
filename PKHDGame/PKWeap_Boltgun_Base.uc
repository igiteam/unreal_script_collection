class PKWeap_Boltgun_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var transient bool bShowCrosshairZoom;
var MaterialInterface CrosshairZoomMat;
var Texture2D CrosshairZoomTex;
var int TrackedProjectileKills;

simulated function EndZoomWorker(EvilPlayerController PC)
{
    super(EvilWeap_Base).EndZoomWorker(PC);
    bForceHidden = false;
    bShowCrosshairZoom = false;
    //return;    
}

simulated event SetPosition(UDKPawn Holder)
{
    local Vector VLength;
    local float Length;

    super(EvilWeap_Base).SetPosition(Holder);
    // End:0xAF
    if((int(GetZoomedState()) != int(0)) && int(ZoomedFireModeNum) < int(255))
    {
        VLength = Mesh.Translation - DesiredMeshTranslation;
        Length = VSize(VLength);
        // End:0xAF
        if(Length < float(1))
        {
            bForceHidden = true;
            bShowCrosshairZoom = true;
        }
    }
    //return;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    local PKPlayerController PC;
    local PainGFxHudWrapper H;

    // End:0x231
    if(bShowCrosshairZoom)
    {
        PC = PKPlayerController(Pawn(Owner).Controller);
        // End:0x58
        if(PC == none)
        {
            return;
        }
        H = PainGFxHudWrapper(HUD);
        // End:0xA9
        if((H == none) || PC.bCinematicMode)
        {
            return;
        }
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.SetPos(0.0000000, 0.0000000, 0.0000000);
        H.Canvas.DrawTile(CrosshairZoomTex, H.Canvas.ClipX, H.Canvas.ClipY, 0.0000000, 0.0000000, float(CrosshairZoomTex.SizeX), float(CrosshairZoomTex.SizeY));        
    }
    else
    {
        super.DrawWeaponCrosshair(HUD);
    }
    //return;    
}

simulated function Projectile ProjectileFire()
{
    local Vector RealStartLoc;
    local Projectile SpawnedProjectile;

    // End:0x186
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = GetPhysicalFireStartLoc();
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
        // End:0x126
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Damage = WeaponDamage[int(CurrentFireMode)];
            SpawnedProjectile.MomentumTransfer = WeaponMomentum[int(CurrentFireMode)];
            SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
        }
        // End:0x17C
        if(ClassIsChildOf(SpawnedProjectile.Class, Class'PKProjectile_Bolt_Base'))
        {
            PKProjectile_Bolt_Base(SpawnedProjectile).WeaponFireOwner = self;
        }
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

simulated function CustomFire()
{
    local int I;

    FireOffset = default.FireOffset;
    IncrementFlashCountEvil();
    // End:0x91
    if(int(CurrentFireMode) == int(0))
    {
        HideBolts();
        SetTimer(0.1000000, false, 'CustomFire2ndRow');
        SetTimer(0.2000000, false, 'CustomFire3rdRow');
        FireOffset.Z += float(5);
        ProjectileFire();        
    }
    else
    {
        // End:0x13A
        if(int(CurrentFireMode) == int(1))
        {
            I = 0;
            J0xB0:

            // End:0x13A [Loop If]
            if(I < 10)
            {
                FireOffset.Y = RandRange(-80.0000000, 80.0000000);
                FireOffset.Z = RandRange(-40.0000000, 40.0000000);
                ProjectileFire();
                I++;
                // [Loop Continue]
                goto J0xB0;
            }
        }
    }
    //return;    
}

simulated function CustomFire2ndRow()
{
    FireOffset.Y = default.FireOffset.Y - float(20);
    FireOffset.Z = default.FireOffset.Z;
    ProjectileFire();
    FireOffset.Y += float(40);
    ProjectileFire();
    //return;    
}

simulated function CustomFire3rdRow()
{
    FireOffset.Y = default.FireOffset.Y - float(40);
    FireOffset.Z = default.FireOffset.Z - float(5);
    ProjectileFire();
    FireOffset.Y += float(80);
    ProjectileFire();
    //return;    
}

simulated function ShowBolts()
{
    local SkelControlSingleBone SkelControl;

    SkelControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl('kolki'));
    // End:0x84
    if((SkelControl != none) && AmmoCount > 0)
    {
        SkelControl.SetSkelControlActive(false);
    }
    //return;    
}

simulated function HideBolts()
{
    local SkelControlSingleBone SkelControl;

    SkelControl = SkelControlSingleBone(SkeletalMeshComponent(Mesh).FindSkelControl('kolki'));
    // End:0x95
    if((SkelControl != none) && !bShowCrosshairZoom || AmmoCount <= 0)
    {
        SkelControl.SetSkelControlActive(true);
    }
    //return;    
}

function int AddAmmoForFireMode(byte FireModeNum, int Amount)
{
    local int OldAmmoCount, Result;

    OldAmmoCount = AmmoCount;
    Result = super.AddAmmoForFireMode(FireModeNum, Amount);
    // End:0x79
    if(((int(FireModeNum) == int(0)) && OldAmmoCount <= 0) && Amount > 0)
    {
        ShowBolts();
    }
    return Result;
    //return ReturnValue;    
}

simulated function FireAmmunition()
{
    TrackedProjectileKills = 0;
    super.FireAmmunition();
    //return;    
}

function FiredProjectileKillSomeone()
{
    TrackedProjectileKills++;
    // End:0x7C
    if(TrackedProjectileKills >= 3)
    {
        // End:0x7C
        if(PKPlayerPawn(Owner) != none)
        {
            PKPlayerController(PKPlayerPawn(Owner).Controller).ClientUnlockAchievement(55);
        }
    }
    //return;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        bShowCrosshairZoom = false;
        bForceHidden = false;
        super.WeaponIsDown();
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ShowBolts();
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=true
    MaxAmmoAltCount=250
    LowAmmoCountWarningThreshold=15
    LowAmmoAltCountWarningThreshold=15
    SplitScreenPlayerViewOffset=(X=-6.0000000,Y=0.0000000,Z=-10.0000000)
    MaxAmmoCount=500
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Boltgun_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    bZoomedFireMode=/* Array type was not detected. */
    InventoryGroup=7
    ZoomedTargetFOV=30.0000000
    ZoomedRate=400.0000000
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Boltgun_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Boltgun_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Boltgun"
    CurrentRating=0.8000000
    WeaponFireTypes=/* Array type was not detected. */
    EquipTime=0.0100000
    PutDownTime=0.0100000
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Boltgun_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.8000000
    MaxDesireability=0.8000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Boltgun_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PainWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}