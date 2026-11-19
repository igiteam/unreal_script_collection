class PKWeap_Demon extends PainWeap_Base
    config(Weapon)
    hidecategories(Navigation);

simulated function bool AllowSwitchTo(EvilWeap_Base NewWeapon)
{
    return NewWeapon.Class == self.Class;
    //return ReturnValue;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    local Vector2D CrosshairSize;
    local float X, Y, ScreenX, ScreenY;
    local UTHUDBase H;
    local float TargetDist;
    local PKPawn P;
    local PKPlayerController PC;

    P = PKPawn(Owner);
    // End:0x2D
    if(P == none)
    {
        return;
    }
    PC = PKPlayerController(P.Controller);
    // End:0x6F
    if(PC == none)
    {
        return;
    }
    H = UTHUDBase(HUD);
    // End:0xF7
    if(((H == none) || !bDisplayCrosshair) || PC.bCinematicMode && !PC.bFiringOnZipLine)
    {
        return;
    }
    TargetDist = GetTargetDistance();
    X = H.Canvas.ClipX * 0.5000000;
    Y = H.Canvas.ClipY * 0.5000000;
    // End:0x548
    if(Crosshair.DotTex != none)
    {
        CrosshairSize.Y = (((H.ConfiguredCrosshairScaling * CrosshairScaling) * Crosshair.DotCord.VL) * H.Canvas.ClipY) / float(1440);
        CrosshairSize.X = CrosshairSize.Y * (Crosshair.DotCord.UL / Crosshair.DotCord.VL);
        ScreenX = X - (CrosshairSize.X * 0.5000000);
        ScreenY = Y - (CrosshairSize.Y * 0.5000000);
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(Crosshair.DotTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.DotCord.U, Crosshair.DotCord.V, Crosshair.DotCord.UL, Crosshair.DotCord.VL);
    }
    //return;    
}

simulated function Vector InstantFireStartTrace()
{
    return super(EvilWeap_Base).InstantFireStartTrace() - (Vector(Instigator.Rotation) * Instigator.GetCollisionRadius());
    //return ReturnValue;    
}

simulated function ShowLowAmmoWarning()
{
    //return;    
}

simulated function ShowNoAmmoWarning()
{
    //return;    
}

defaultproperties
{
    bSelectable=false
    WeaponHitRange=5600.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    NumberOfShots=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponSpreadMax=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    MoveSpreadMultiplier=1.0000000
    SprintSpreadMultiplier=1.0000000
    JumpSpreadMultiplier=1.0000000
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Demon.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    Crosshair=(DotTex=Texture2D'PKHD_HUD.crosshair_demon_morph',DotCord=(UL=128.0000000,VL=128.0000000))
    CrosshairSpreadMultiplier=0.0000000
    // Reference: AudioComponent'Default__PKWeap_Demon.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    WeaponFireSnd=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Demon.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Demon"
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.0000000
    PutDownTime=0.0000000
    bCanThrow=false
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Demon.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    Priority=0.0000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Demon.PickupMesh'
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