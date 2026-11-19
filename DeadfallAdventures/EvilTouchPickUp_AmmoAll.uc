class EvilTouchPickUp_AmmoAll extends EvilUsePickUp_Base
    notplaceable
    hidecategories(Navigation);

var(Pickup) bool GiveMax;
var(Pickup) array<int> AmmoAmount;
var() float CaptionToggleTime;
var EvilPlayerController LastUsedBy;

function Pickup(EvilPawn P)
{
    local array<EvilWeap_Base> Weapons;
    local EvilWeap_Base Weap;
    local bool successed;
    local int I;
    local float AmountModifier;
    local array<int> AmmoAmountMod;

    EvilInventoryManager(P.InvManager).GetWeaponList(Weapons);
    AmountModifier = 1.0000000;
    // End:0x13B
    if(!WorldInfo.GRI.IsMultiplayerGame() && EvilPlayerController(P.Controller) != none)
    {
        AmountModifier = Class'EvilDifficultySettings'.static.GetClassByID(EvilPlayerController(P.Controller).GetFightDifficultyLevel()).default.AmmoDifficultyModifier;
    }
    I = 0;
    J0x146:

    // End:0x1A3 [Loop If]
    if(I < AmmoAmount.Length)
    {
        AmmoAmountMod.AddItem(FCeil(float(AmmoAmount[I]) * AmountModifier));        
        I++;
        // [Loop Continue]
        goto J0x146;
    }
    // End:0x2EE
    foreach Weapons(Weap)
    {
        // End:0x1E2
        if(!Weap.CanUseAmmoBox())
        {
            continue;            
        }
        else
        {
            I = 0;
            J0x1ED:

            // End:0x2ED [Loop If]
            if(I < AmmoAmountMod.Length)
            {
                // End:0x2DF
                if(!Weap.AmmoMaxed(I))
                {
                    // End:0x296
                    if(GiveMax)
                    {
                        Weap.AddAmmoForFireMode(byte(I), Weap.GetMaxAmmoCount(byte(I)));                        
                    }
                    else
                    {
                        Weap.AddAmmoForFireMode(byte(I), AmmoAmountMod[I]);
                    }
                    successed = true;
                }
                I++;
                // [Loop Continue]
                goto J0x1ED;
            }            
        }
    }    
    // End:0x33E
    if(successed)
    {
        EvilPlayerController(P.Controller).bShowAmmoBoxCaption = false;        
    }
    else
    {
        return;
    }
    // End:0x3A8
    if(EvilPlayerController(P.Controller) != none)
    {
        LastUsedBy = EvilPlayerController(P.Controller);
        ToggleCaption();
    }
    super(EvilTouchPickUp_Base).Pickup(P);
    //return;    
}

simulated function ToggleCaption()
{
    // End:0x11
    if(LastUsedBy == none)
    {
        return;
    }
    // End:0x8F
    if(!CaptionComponent.bPostRenderDisabled)
    {
        CaptionComponent.Hide();
        SetTimer(CaptionToggleTime, false, 'ToggleCaption');
        LastUsedBy.SetCaptionComponentVisibility(self, true);        
    }
    else
    {
        CaptionComponent.Show();
        LastUsedBy.SetCaptionComponentVisibility(self, false);
    }
    //return;    
}

function TriggerTouched(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilPawn P;
    local array<EvilWeap_Base> Weapons;
    local EvilWeap_Base Weap;
    local bool bNeedWeaponsRecheck;
    local EvilPlayerController PC;

    // End:0x22
    if((TimeToDestroy > float(0)) || bHidden)
    {
        return;
    }
    super.TriggerTouched(Other, OtherComp, HitLocation, HitNormal);
    P = EvilPawn(Other);
    // End:0x1EC
    if((P != none) && P.IsPlayerPawn())
    {
        PC = EvilPlayerController(P.Controller);
        // End:0x1EC
        if(PC != none)
        {
            EvilInventoryManager(P.InvManager).GetWeaponList(Weapons);
            PC.bShowAmmoBoxCaption = false;
            bNeedWeaponsRecheck = true;
            // End:0x1C2
            foreach Weapons(Weap)
            {
                // End:0x1C1
                if(!Weap.AmmoMaxed(0))
                {
                    PC.bShowAmmoBoxCaption = true;
                    bNeedWeaponsRecheck = false;                    
                }
                else
                {                    
                }
            }            
            PC.SetUsableTriggerCaptionRefreshing(bNeedWeaponsRecheck);
        }
    }
    //return;    
}

function TriggerUnTouched(Actor Other)
{
    local EvilPlayerController PC;

    // End:0x11
    if(Other == none)
    {
        return;
    }
    PC = EvilPlayerController(EvilPawn(Other).Controller);
    // End:0x10E
    if(PC != none)
    {
        // End:0xEE
        if(PC.UsableTrigger != none)
        {
            // End:0xEB
            if(PC.UsableTrigger == PickupTrigger)
            {
                PC.SetUsableTriggerCaptionRefreshing(true);
                PC.bShowAmmoBoxCaption = false;
            }            
        }
        else
        {
            PC.SetUsableTriggerCaptionRefreshing(false);
        }
    }
    //return;    
}

simulated function bool CanBeUsedNow(PlayerController PC)
{
    // End:0x37
    if((PC == none) || PC.Pawn == none)
    {
        return false;
    }
    // End:0x66
    if(!EvilPlayerController(PC).bShowAmmoBoxCaption)
    {
        return false;
    }
    // End:0xBF
    if(!EvilWeap_Base(PC.Pawn.Weapon).CanUseAmmoBox())
    {
        return false;
    }
    return super.CanBeUsedNow(PC);
    //return ReturnValue;    
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    super(EvilTouchPickUp_Base).OnToggleHidden(Action);
    // End:0x60
    if(Action.InputLinks[0].bHasImpulse)
    {
        SetTimer(0.0000000, false, 'ToggleCaption');        
    }
    else
    {
        // End:0x9A
        if(Action.InputLinks[1].bHasImpulse)
        {            
        }
        else
        {
            // End:0xBA
            if(bHidden)
            {
                SetTimer(0.0000000, false, 'ToggleCaption');
            }
        }
    }
    //return;    
}

defaultproperties
{
    GiveMax=true
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    AmmoAmount[2]=0
    CaptionToggleTime=0.5000000
    // Reference: CylinderComponent'Default__EvilTouchPickUp_AmmoAll.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_AmmoAll.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_AmmoAll.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_AmmoAll.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    bNoDelete=true
    CollisionComponent=CollisionCylinder
}