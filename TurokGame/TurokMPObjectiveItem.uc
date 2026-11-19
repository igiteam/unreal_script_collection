class TurokMPObjectiveItem extends TurokInventory
    abstract
    native
    config(Game)
    hidecategories(Navigation);

var const config bool ScorePointsForKillingCarrier;
var const config bool ScorePointsForKillingProximity;
var const config int DroppedRespawnTime;
var protected const @NULL mHudIconTexture;
var const byte mPickupObjectiveType;
var const byte mCompletedObjectiveType;
var protected @NULL mMPPickupFactory;

function SetMPPickupFactory(@NULL pf)
{
    // DebugMode: 0
    assert(pf != none);
    // DebugMode: 0
    assert(mMPPickupFactory == none);
    mMPPickupFactory = pf;
    //return;    
}

function @NULL GetMPPickupFactory()
{
    return mMPPickupFactory;
    //return ReturnValue;    
}

function @NULL ReleaseFactory()
{
    local @NULL pf;

    pf = mMPPickupFactory;
    mMPPickupFactory = none;
    return pf;
    //return ReturnValue;    
}

function bool CanBePickedUp(@NULL pwn)
{
    local int I;
    local @NULL pf;

    pf = GetMPPickupFactory();
    // DebugMode: 0
    assert(pf != none);
    I = int(pf.GetTeamNum());
    return (I == 255) || I == int(pwn.GetTeamNum());
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0x35
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x35
        if(mMPPickupFactory != none)
        {
            mMPPickupFactory.EnablePickup();
            mMPPickupFactory = none;
        }
    }
    super(Inventory).Destroyed();
    //return;    
}

simulated function RenderOverlays(@NULL H)
{
    local @NULL THud;

    THud = TurokHud(H);
    // End:0x5F
    if((H.bThirdPersonHud == true) && !(int(THud.mCurrentWeaponReticuleType) == int(5)) || int(THud.mCurrentWeaponReticuleType) == int(6))
    {
        return;
    }
    // End:0x135
    if(mHudIconTexture != none)
    {
        H.Canvas.SetDrawColor(byte(255), byte(255), byte(255), byte(TurokHud(H).MPObjectiveItemAlpha));
        H.Canvas.SetPos(H.CenterX - 32.0000000, H.SizeY * (0.8650000 - TurokHud(H).mSafeZoneHalfPcnt));
        H.Canvas.__NFUN_466__(mHudIconTexture, 64.0000000, 64.0000000, 0.0000000, 0.0000000, 64.0000000, 64.0000000);
    }
    //return;    
}

defaultproperties
{
    bRenderOverlays=true
    bDropOnDeath=true
    // Reference: SpriteComponent'Default__TurokMPObjectiveItem.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}