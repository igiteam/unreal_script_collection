class AdvInventoryItem_Map extends AdvInventoryItem_Base
    config(Weapon)
    hidecategories(Navigation);

var MaterialInstanceConstant MapMIC;
var TextureRenderTarget2D FlashTextureMap;
var AdvGFxUI_Map GfxPlayer;

function bool ShouldSaveBetweenLevels()
{
    return false;
    //return ReturnValue;    
}

simulated function SetupMapFlashTexture()
{
    local AdvGRI_SP GRI;

    GRI = AdvGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x58
    if(GRI == none)
    {
        return;
    }
    // End:0x9D
    if(FlashTextureMap == none)
    {
        FlashTextureMap = Class'Engine.TextureRenderTarget2D'.static.Create(1024, 1024);
    }
    // End:0x102
    if(GfxPlayer == none)
    {
        GfxPlayer = new Class'AdvGFxUI_Map';
        GfxPlayer.MovieInfo = Class'AdvGFxUI_Map'.static.StaticGetMovieInfoForCurrentLevel();
    }
    GfxPlayer.RenderTexture = FlashTextureMap;
    GfxPlayer.Init(LocalPlayer(AdvPlayerPawn(Instigator).GetPlayerController().Player));
    GfxPlayer.SetupTreasureMapForLevel(byte(GRI.ChapterNum));
    MapMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
    // End:0x238
    if(MapMIC != none)
    {
        MapMIC.SetTextureParameterValue('Map', FlashTextureMap);
    }
    //return;    
}

simulated function CloseMapFlashTexture()
{
    // End:0x5A
    if(GfxPlayer != none)
    {
        GfxPlayer.RenderTexture = none;
        GfxPlayer.Close();
        GfxPlayer = none;
    }
    //return;    
}

simulated event Destroyed()
{
    local EvilPlayer_interface EPI;

    CloseMapFlashTexture();
    EPI = EvilPlayer_interface(Instigator);
    // End:0xB0
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowMapHints(false);
    }
    super(EvilWeap_Base).Destroyed();
    //return;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayer_interface EPI;

        super.BeginState(PreviousStateName);
        SetupMapFlashTexture();
        EPI = EvilPlayer_interface(Instigator);
        // End:0xC3
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowMapHints(true);
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function EndState(name NextStateName)
    {
        local EvilPlayer_interface EPI;

        CloseMapFlashTexture();
        EPI = EvilPlayer_interface(Instigator);
        // End:0xB0
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowMapHints(false);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state QuickHide
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayer_interface EPI;

        super.BeginState(PreviousStateName);
        SetupMapFlashTexture();
        EPI = EvilPlayer_interface(Instigator);
        // End:0xC3
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowMapHints(false);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local EvilPlayer_interface EPI;

        CloseMapFlashTexture();
        EPI = EvilPlayer_interface(Instigator);
        // End:0xB0
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            EvilGFxHudWrapper(EPI.GetPC().myHUD).HudMovie.ShowMapHints(true);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    ControlDOFWhenOffhand=true
    ZoomedCrosshair=true
    UsesOffhand=true
    OffHandDoesNotFire=true
    // Reference: ForceFeedbackWaveform'Default__AdvInventoryItem_Map.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    InventoryGroup=66
    ZoomedMeshTranslation=(X=-5.0000000,Y=5.0000000,Z=2.0000000)
    ZoomedMeshScale=1.3000000
    DOF_FocusDistance=30.0000000
    ZoomedWeaponIdleAnims=/* Array type was not detected. */
    ZoomedWeaponFireAnim=/* Array type was not detected. */
    ZoomedArmIdleAnims=/* Array type was not detected. */
    ZoomedArmFireAnim=/* Array type was not detected. */
    ZoomedMovementSpeedModifier=0.6000000
    ArmsAnimSet=AnimSet'wp_map_01.Anim.as_wp_map_hands'
    // Reference: AudioComponent'Default__AdvInventoryItem_Map.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    WeaponCrouchStartAnim="WeaponCrouchStart"
    ArmCrouchStartAnim="WeaponCrouchStart"
    WeaponCrouchEndAnim="WeaponStandStart"
    ArmCrouchEndAnim="WeaponStandStart"
    WeaponJumpStartAnim="WeaponJumpStart"
    ArmJumpStartAnim="WeaponJumpStart"
    WeaponJumpFlyAnim="WeaponJumpFall"
    ArmJumpFlyAnim="WeaponJumpFall"
    WeaponJumpLandAnim="WeaponJumpLanding"
    ArmJumpLandAnim="WeaponJumpLanding"
    CrouchStartCameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CrouchStart'
    CrouchEndCameraAnim=CameraAnim'an_CameraAnims.Anim.CA_StandStart'
    WeaponPutDownSnd=SoundCue'a_Map.a_MapHide'
    WeaponEquipSnd=SoundCue'a_Map.a_MapDrag'
    // Reference: DynamicLightEnvironmentComponent'Default__AdvInventoryItem_Map.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Map"
    PlayerViewOffset=(X=30.0000000,Y=18.0000000,Z=-9.0000000)
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvInventoryItem_Map.FirstPersonMesh'
    begin object name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'wp_map_01.Mesh.sk_wp_map_01'
        AnimTreeTemplate=AnimTree'wp_map_01.Anim.at_wp_map_01'
        AnimSets[0]=AnimSet'wp_map_01.Anim.as_wp_map_01'
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    ItemName="Map"
    // Reference: SkeletalMeshComponent'Default__AdvInventoryItem_Map.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}