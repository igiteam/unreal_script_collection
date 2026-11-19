class MOHADemoChargeCSA extends MOHACSASpawnable
    hidecategories(Navigation);

var export editinline StaticMeshComponent PlantChargeMesh;
var const localized string PlantChargeMsg;

function LoadLocalizedStrings()
{
    csaText = PlantChargeMsg;
    //return;    
}

simulated function SetEnabled(bool CSAEnabled)
{
    super(MOHACSA).SetEnabled(CSAEnabled);
    PlantChargeMesh.SetHidden(!CSAEnabled);
    //return;    
}

function AttachToParent(Actor CSAOwner, SkeletalMeshComponent AttachMesh, name AttachSocket)
{
    SetBase(CSAOwner,, AttachMesh, AttachSocket);
    //return;    
}

event bool UsedBy(Pawn User)
{
    local EALADemoCharge demoCharge;
    local MOHAPlayerController LocalPlayer;

    // End:0x0B
    if(bDirty)
    {
        return false;
    }
    LocalPlayer = MOHAPlayerController(User.Controller);
    // End:0xA1
    if(LocalPlayer != none)
    {
        demoCharge = EALADemoCharge(LocalPlayer.Pawn.Weapon);
        // End:0x78
        if((demoCharge != none) && !demoCharge.CanPlaceDemoCharge())
        {
            return false;
        }
        LocalPlayer.DemoChargeCSA = self;
        LocalPlayer.GotoState('PlayerPlacingDemoCharge');
        return true;
    }
    return false;
    //return ReturnValue;    
}

event OnPlacedDemoCharge(Pawn User)
{
    local MOHAPlayerController LocalPlayer;

    LocalPlayer = MOHAPlayerController(User.Controller);
    // End:0x97
    if(LocalPlayer != none)
    {
        LocalPlayer.RemoveCSA(self);
        // End:0x6A
        if(bDisplayed)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveCSA();
            bDisplayed = false;
        }
        // End:0x7D
        if(!bOneShot)
        {
            bEnabled = false;
        }
        TriggerEventClass(Class'SeqEvent_CSAUsed', User, -1);
    }
    SetEnabled(false);
    //return;    
}

simulated function bool IsUsableBy(MOHAPlayerController PlayerController)
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(PlayerController.Pawn);
    // End:0x3E
    if((PlayerPawn != none) && PlayerPawn.IsUpgradeSequenceActive())
    {
        return false;
    }
    // End:0x59
    if(int(PlayerPawn.Physics) != int(1))
    {
        return false;
    }
    return super(MOHACSA).IsUsableBy(PlayerController);
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__MOHADemoChargeCSA.ChargePlantMesh'
    begin object name=ChargePlantMesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'GCm_Wpn_US_CompB.CM_CompB_GlowingRedBox'
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
        NoPhysx=true
    end object
    PlantChargeMesh=ChargePlantMesh
    PlantChargeMsg="Press %b to Place Charge"
    fWeightScale=5.0000000
    // Reference: CylinderComponent'Default__MOHADemoChargeCSA.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=100.0000000
        CollisionRadius=125.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHADemoChargeCSA.Sprite'
    begin object name=Sprite
        HiddenGame=true
        HiddenEditor=true
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    Components[2]=ChargePlantMesh
    bHidden=false
    CollisionComponent=CollisionCylinder
}