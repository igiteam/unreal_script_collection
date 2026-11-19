class SkyBonusPickupFactory extends SkyPickupFactory
    native;

var private native const noexport Pointer VfTable_FCallbackEventDevice;
var(Pickup) export editinline StaticMeshComponent DisplayMesh;
var(Pickup) Surface DisplayIcon;
var(Pickup) float RespawnTime;
var(Bonus) bool bRequiresButtonPress;
var(Bonus) bool bShowIfDisabled;

// Export USkyBonusPickupFactory::execIsUsableAnchorFor(FFrame&, void* const)
native function bool IsUsableAnchorFor(Pawn P);

function SetRespawn()
{
    // End:0x1C
    if(RespawnTime > 0.0000000)
    {
        StartSleeping();        
    }
    else
    {
        GotoState('Disabled');
    }
    //return;    
}

function float GetRespawnTime()
{
    return RespawnTime;
    //return ReturnValue;    
}

// Export USkyBonusPickupFactory::execSetInitialStateCallback(FFrame&, void* const)
native function SetInitialStateCallback();

// Export USkyBonusPickupFactory::execClearInitialStateCallback(FFrame&, void* const)
native function ClearInitialStateCallback();

// Export USkyBonusPickupFactory::execCheckSetInitialState(FFrame&, void* const)
native function CheckSetInitialState(SkyPlayerControllerBase C);

simulated event SetInitialState()
{
    local SkyPlayerControllerBase PC;
    local OnlineProfileSettings Settings;

    // End:0x55
    foreach WorldInfo.AllControllers(Class'SkyPlayerControllerBase', PC)
    {
        Settings = PC.GetProfileSettings();
        // End:0x54
        if(Settings != none)
        {
            CheckSetInitialState(PC);            
            return;
        }        
    }    
    SetInitialStateCallback();
    //return;    
}

simulated function InitializePickup()
{
    bPredictRespawns = false;
    MaxDesireability = 0.0000000;
    bIsSuperItem = false;
    SetPickupMesh();
    //return;    
}

simulated function SetPickupMesh()
{
    super.SetPickupMesh();
    DisplayMesh.SetLightEnvironment(LightEnv);
    //return;    
}

simulated function SetPickupHidden()
{
    super(PickupFactory).SetPickupHidden();
    // End:0x22
    if(DisplayMesh != none)
    {
        DisplayMesh.SetHidden(true);
    }
    //return;    
}

simulated function SetPickupVisible()
{
    super(PickupFactory).SetPickupVisible();
    // End:0x22
    if(DisplayMesh != none)
    {
        DisplayMesh.SetHidden(false);
    }
    //return;    
}

event bool BonusIsValid(SkyPlayerControllerBase C)
{
    return true;
    //return ReturnValue;    
}

event OnPickupBonus(SkyPlayerControllerBase C)
{
    //return;    
}

state Disabled
{
    simulated event BeginState(name PreviousStateName)
    {
        // End:0x16
        if(!bShowIfDisabled)
        {
            super.BeginState(PreviousStateName);
        }
        WorldInfo.RadarNodes.RemoveItem(self);
        //return;        
    }
    stop;    
}

auto state Pickup
{
    function Give(Pawn P)
    {
        // End:0x71
        if((P != none) && P.DrivenVehicle != none)
        {
            // End:0x6E
            if(SkyPlayerControllerBase(P.DrivenVehicle.Controller) != none)
            {
                OnPickupBonus(SkyPlayerControllerBase(P.DrivenVehicle.Controller));
            }            
        }
        else
        {
            // End:0xA9
            if(SkyPlayerControllerBase(P.Controller) != none)
            {
                OnPickupBonus(SkyPlayerControllerBase(P.Controller));
            }
        }
        PickedUpBy(P);
        //return;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;

        P = Pawn(Other);
        // End:0x49
        if((P != none) && ValidTouch(P))
        {
            // End:0x49
            if(!bRequiresButtonPress)
            {
                Give(P);
            }
        }
        //return;        
    }

    function bool ValidTouch(Pawn Other)
    {
        // End:0x27
        if((Other == none) || !Other.bCanPickupInventory)
        {
            return false;            
        }
        else
        {
            // End:0xA3
            if(((Other.DrivenVehicle != none) && Other.DrivenVehicle.Controller == none) || (Other.DrivenVehicle == none) && Other.Controller == none)
            {
                SetTimer(0.2000000, false, 'RecheckValidTouch');
                return false;                
            }
            else
            {
                // End:0xD6
                if(!FastTrace(Other.Location, Location))
                {
                    SetTimer(0.5000000, false, 'RecheckValidTouch');
                    return false;
                }
            }
        }
        // End:0x104
        if(WorldInfo.Game.PickupQuery(Other, InventoryType, self))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    simulated event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        WorldInfo.RadarNodes.AddItem(self);
        //return;        
    }
    stop;    
}
