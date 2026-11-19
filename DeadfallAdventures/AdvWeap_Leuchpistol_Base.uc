class AdvWeap_Leuchpistol_Base extends AdvWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var Texture2D CrosshairLeuch;

function bool ShouldSaveBetweenLevels()
{
    return false;
    //return ReturnValue;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    local AdvPlayerController PC;
    local AdvGFxHudWrapper H;
    local Vector2D CrosshairSize;
    local float CrosshairAlpha, X, Y;

    // End:0x57F
    if(bDisplayCrosshair)
    {
        PC = AdvPlayerController(Pawn(Owner).Controller);
        // End:0x58
        if(PC == none)
        {
            return;
        }
        H = AdvGFxHudWrapper(HUD);
        // End:0xA9
        if((H == none) || PC.bCinematicMode)
        {
            return;
        }
        CrosshairColor = GetCurrentCrosshairColor(H);
        CrosshairAlpha = FClamp(255.0000000 - ((PC.VisualSpread / CrosshairTotalInvisibilitySpread) * float(255)), 0.0000000, 255.0000000);
        CrosshairSize.X = 256.0000000;
        CrosshairSize.Y = 256.0000000;
        X = (H.Canvas.ClipX * 0.5000000) - (CrosshairSize.X * 0.5000000);
        Y = (H.Canvas.ClipY * 0.5000000) - (CrosshairSize.Y * 0.5000000);
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(X, Y, 0.0000000);
        H.Canvas.DrawTile(CrosshairLeuch, CrosshairSize.X, CrosshairSize.Y + float(1), 0.0000000, 0.0000000, float(CrosshairLeuch.SizeX), float(CrosshairLeuch.SizeY));
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(X, Y, 0.0000000);
        H.Canvas.DrawTile(CrosshairLeuch, CrosshairSize.X - float(1), CrosshairSize.Y, 0.0000000, 0.0000000, float(CrosshairLeuch.SizeX), float(CrosshairLeuch.SizeY));
    }
    //return;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local SkelControlBase SkelControl;

        super.BeginState(PreviousStateName);
        // End:0x8A
        if(IsMagazineEmpty())
        {
            SkelControl = UDKSkeletalMeshComponent(Mesh).FindSkelControl('granat');
            // End:0x8A
            if(SkelControl != none)
            {
                SkelControl.SetSkelControlActive(true);
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bPurchasedWeaponDLC=false
    WeaponStatMP_Damage=10
    WeaponStatMP_Firerate=3
    WeaponStatMP_Accuracy=7
    WeaponStatMP_Magazines=1
    WeaponStatMP_ReloadSpeed=7
    EWeaponType=WeaponType.TYPE_Special
    FlashlightBaseSpotlightOffset=(X=-10.0000000,Y=-16.0000000,Z=-25.0000000)
    FlashlightBaseSpotlightRotOffset=(Pitch=-800,Yaw=1300,Roll=0)
    FlashlightAimingSpotlightOffset=(X=-10.0000000,Y=-16.0000000,Z=-7.0000000)
    FlashlightAimingSpotlightRotOffset=(Pitch=-300,Yaw=0,Roll=0)
    BothHandWeapon=true
    AlwaysBothHandReload=true
    bRecommendSplashDamage=true
    DefaultAmmoCount=6
    MaxAmmoCount=6
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Leuchpistol_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AmmoPickupString="Panzer Wurfkorper Rockets"
    ReloadTime=1.7000000
    InventoryGroup=3
    ZoomedRate=120.0000000
    ZoomingTranslationRate=13.0000000
    ZoomedMeshTranslation=(X=-29.8000000,Y=-12.0786000,Z=-1.4429000)
    ZoomedMeshRotation=(Pitch=-748,Yaw=746,Roll=581)
    ZoomedMeshScale=2.0000000
    DOF_FocusDistance=60.0000000
    GroupWeight=0.4000000
    // Reference: AudioComponent'Default__AdvWeap_Leuchpistol_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Leuchpistol_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Leuchpistol"
    CrouchAnimTime=1.0420000
    StandUpAnimTime=1.0420000
    SprintStartAnimTime=1.2080000
    SprintAnimTime=0.7000000
    PlayerViewOffset=(X=19.9583000,Y=4.5923000,Z=-6.8225000)
    PlayerRotationOffset=(Pitch=182,Yaw=-791,Roll=-546)
    CurrentRating=0.4000000
    WeaponFireTypes=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4000000
    PutDownTime=0.4000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Leuchpistol_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.4000000
    ItemName="Panzer Wurfkorper"
    MaxDesireability=0.4000000
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Leuchpistol_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}