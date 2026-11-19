class SkyPawn_Dweller extends SkyPawn_Boss
    native
    config(Game);

var(FootDamage) float FootstepDamageRadius;
var(FootDamage) float FootstepDamageAmount;
var(FootDamage) class<DamageType> FootstepDamageType;
var(Sounds) editconst export editinline AudioComponent TurbineSound;
var(Sounds) export editinline AudioComponent ProximityWarningAC;
var(Mesh) export editinline SkeletalMeshComponent WingMesh;
var(Mesh) array<BodyParts> PossibleWingsMeshes;
var(Dweller) float DeathRadius;
var(Dweller) float DeathProximityWarningRadius;
var(Dweller_BullRush) float BullRushDamageLeadDistance;
var(Dweller_BullRush) float BullRushDamageMaxRadius;
var(Dweller_BullRush) float BullRushDamageAmount;
var(Dweller_BullRush) float BullRushPushAwayForce;
var transient float LastBullRushImpactTime;
var(Dweller_BullRush) bool bDebugBullRushCone;
var transient bool bPlayerWasInteracting;
var(Dweller_PushAway) bool bDebugPushAwaySphere;
var transient bool bPushDisabled;
var(Dweller_PushAway) float PushAwayRadius;
var(Dweller_PushAway) name PushAwaySphereSocket;
var(Dweller_PushAway) float PushAwayDamage;
var(Dweller_PushAway) name GroundPushAwayReaction;
var(Dweller_PushAway) name AerialPushAwayReaction;
var(Dweller_PushAway) name PlayerPushAwayReaction;
var(Dweller_PushAway) float TriggerPlayerPushAwayDelay;
var(Dweller_PushAway) float PushAwayForce;
var transient float PlayerPushAwayTimer;

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    super(SkyPawn).DisplayDebug(HUD, out_YL, out_YPos);
    //return;    
}

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    local float AnchorDist;

    // End:0x85
    if(int(Action.newPhysics) == int(1))
    {
        // End:0x44
        if(DrivenVehicle != none)
        {
            DrivenVehicle.DriverLeave(true);
            TurnOffRocketPackThrust();
        }
        StopRocketPack();
        DrivenVehicle = none;
        ExitingVehicle = none;
        AnimDrivingState = 4;
        SetAnchor(GetBestAnchor(self, Location, true, false, AnchorDist));
    }
    super(Actor).OnSetPhysics(Action);
    //return;    
}

event DestroyArmor(SkyPawn.EArmorType ArmorType)
{
    super(SkyPawn).DestroyArmor(ArmorType);
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    TurbineSound.Stop();
    return super(SkyPawn).Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    TurbineSound.Play();
    // End:0xA7
    if(WingMesh != none)
    {
        PickBodyPartMesh(WingMesh, PossibleWingsMeshes);
        // End:0x50
        if(LightEnvironment != none)
        {
            WingMesh.SetLightEnvironment(LightEnvironment);
        }
        WingMesh.SetShadowParent(Mesh);
        WingMesh.CastShadow = true;
        WingMesh.bCastDynamicShadow = true;
        SetupParentAnim(WingMesh);
        CreateMaterialInstanceConstant(WingMesh);
    }
    super.PostBeginPlay();
    Mesh.SetMaterial(0, MatInstConst);
    //return;    
}

simulated event StartDriving(Vehicle V)
{
    super(SkyPawn).StartDriving(V);
    // End:0x35
    if(WingMesh != none)
    {
        WingMesh.SetShadowParent(V.Mesh);
    }
    //return;    
}

simulated event StopDriving(Vehicle V)
{
    super(SkyPawn).StopDriving(V);
    // End:0x2B
    if(WingMesh != none)
    {
        WingMesh.SetShadowParent(Mesh);
    }
    //return;    
}

simulated function SpawnFootstepEffect(Vector SpawnLocation, Rotator SpawnRotation, FootstepImpact Effect)
{
    super(SkyPawn).SpawnFootstepEffect(SpawnLocation, SpawnRotation, Effect);
    HurtRadius(FootstepDamageAmount, FootstepDamageRadius, 0.0000000, FootstepDamageType, 0.0000000, SpawnLocation);
    //return;    
}

simulated function OnDwellerSetPush(SkySeqAct_DwellerSetPush inAction)
{
    bPushDisabled = !inAction.bCanPush;
    //return;    
}
