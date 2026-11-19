class EvilTouchPickUp_AmmoBase extends EvilTouchPickUp_Base
    notplaceable
    hidecategories(Navigation);

var(Pickup) class<EvilWeap_Base> WeaponClass;
var(Pickup) array<int> AmmoAmount;

simulated function PostBeginPlay()
{
    local string ClassName;

    super.PostBeginPlay();
    // End:0xC9
    if(CaptionComponent.CaptionText == "")
    {
        ClassName = string(WeaponClass.Name);
        // End:0x8E
        if(Right(ClassName, 5) != "_Base")
        {
            ClassName = ClassName $ "_Base";
        }
        CaptionComponent.SetCaptionLoc("AmmoPickupString", ClassName);
    }
    //return;    
}

function Pickup(EvilPawn P)
{
    local int I;
    local float AmountModifier;
    local array<int> AmmoAmountMod;

    // End:0x4E
    if(!EvilInventoryManager(P.InvManager).NeedsAmmo(WeaponClass))
    {
        return;
    }
    AmountModifier = 1.0000000;
    // End:0x140
    if(!WorldInfo.GRI.IsMultiplayerGame() && EvilPlayerController(P.Controller) != none)
    {
        AmountModifier = Class'EvilDifficultySettings'.static.GetClassByID(EvilPlayerController(P.Controller).GetFightDifficultyLevel()).default.AmmoDifficultyModifier;
    }
    I = 0;
    J0x14B:

    // End:0x1A8 [Loop If]
    if(I < AmmoAmount.Length)
    {
        AmmoAmountMod.AddItem(FCeil(float(AmmoAmount[I]) * AmountModifier));        
        I++;
        // [Loop Continue]
        goto J0x14B;
    }
    I = 0;
    J0x1B3:

    // End:0x23D [Loop If]
    if(I < AmmoAmountMod.Length)
    {
        EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmountMod[I], WeaponClass);
        I++;
        // [Loop Continue]
        goto J0x1B3;
    }
    super.Pickup(P);
    //return;    
}

defaultproperties
{
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    AmmoAmount[2]=0
    // Reference: CylinderComponent'Default__EvilTouchPickUp_AmmoBase.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_AmmoBase.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_AmmoBase.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_AmmoBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    CollisionComponent=CollisionCylinder
}