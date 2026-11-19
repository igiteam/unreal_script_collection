class MOHAPickupCrateCSA extends MOHACSASpawnable
    hidecategories(Navigation);

var MOHAPickupCrate InventoryPickup;
var const localized string PickupCrateMsg;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local string PickupName;
    local MOHAPlayerPawn PlayerPawn;
    local array<string> LocalizedStringVars;

    PlayerPawn = MOHAPlayerPawn(Other);
    // End:0x94
    if(PlayerPawn != none)
    {
        // End:0x3B
        if(false == InventoryPickup.PawnCanUsePickup(PlayerPawn))
        {
            return;
        }
        // End:0x5F
        if(InventoryPickup != none)
        {
            PickupName = InventoryPickup.GetPickupName();
        }
        LocalizedStringVars[LocalizedStringVars.Length] = PickupName;
        csaText = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(PickupCrateMsg, LocalizedStringVars);
    }
    super(MOHACSA).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

event bool UsedBy(Pawn User)
{
    local MOHAPlayerPawn Pawn;
    local MOHAPlayerController LocalPlayer;

    // End:0x0B
    if(bDirty)
    {
        return false;
    }
    Pawn = MOHAPlayerPawn(User);
    // End:0x49
    if(Pawn != none)
    {
        // End:0x49
        if(InventoryPickup != none)
        {
            InventoryPickup.GiveTo(Pawn);
        }
    }
    LocalPlayer = MOHAPlayerController(User.Controller);
    // End:0xB3
    if(LocalPlayer != none)
    {
        LocalPlayer.RemoveCSA(self);
        // End:0xB3
        if(bDisplayed)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveCSA();
            bDisplayed = false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableBy(MOHAPlayerController PlayerController)
{
    // End:0x16
    if(InventoryPickup.CrateMesh == none)
    {
        return false;
    }
    // End:0x59
    if(!FastTrace(PlayerController.Pawn.Location, InventoryPickup.CrateMesh.Bounds.Origin))
    {
        return false;
    }
    return super(MOHACSA).IsUsableBy(PlayerController);
    //return ReturnValue;    
}

defaultproperties
{
    PickupCrateMsg="Hold %b to get %1"
    bLookAt=false
    fWeightScale=1.0000000
    // Reference: CylinderComponent'Default__MOHAPickupCrateCSA.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAPickupCrateCSA.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}