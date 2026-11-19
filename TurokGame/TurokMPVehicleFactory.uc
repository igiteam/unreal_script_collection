class TurokMPVehicleFactory extends TurokMPNavPoint
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;
var(Multiplayer) private const class<Class> mVehicleClass;
var private @NULL mSpawnedVehicle;

simulated function SetInitialState()
{
    super(Actor).SetInitialState();
    // End:0x40
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x32
        if(mVehicleClass == none)
        {
            GotoState('None');            
        }
        else
        {
            GotoState('Spawning');
        }
    }
    //return;    
}

function Reset()
{
    super(Actor).Reset();
    // End:0x24
    if(mSpawnedVehicle != none)
    {
        mSpawnedVehicle.Destroy();
        mSpawnedVehicle = none;
    }
    SetInitialState();
    //return;    
}

function NotifyDeath(@NULL Other)
{
    // End:0x0F
    if(Other == mSpawnedVehicle)
    {
    }
    //return;    
}

state Spawning
{
    protected function bool IsAreaBlocked()
    {
        local @NULL P;

        // End:0x24
        foreach CollidingActors(Class'Engine.Pawn', P, mVehicleClass.default.SpawnRadius)
        {            
            return true;            
        }        
        return false;
        //return ReturnValue;        
    }

    protected function TrySpawnVehicle()
    {
        // End:0x0E
        if(mSpawnedVehicle != none)
        {            
        }
        else
        {
            // End:0x1D
            if(IsAreaBlocked())
            {
                return;
            }
            mSpawnedVehicle = __NFUN_278__(mVehicleClass);
            // End:0x3E
            if(mSpawnedVehicle == none)
            {
                return;
            }
        }
        GotoState('None');
        //return;        
    }
Begin:

    TrySpawnVehicle();
    Sleep(1.0000000);
    goto 'Begin';
    stop;                
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPVehicleFactory.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    bBlockable=true
    // Reference: CylinderComponent'Default__TurokMPVehicleFactory.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=15.0000000
        CollisionRadius=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    GoodSprite=none
    BadSprite=none
    bStatic=false
    bHidden=true
    // Reference: SpriteComponent'Default__TurokMPVehicleFactory.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokSpawnNode'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__TurokMPVehicleFactory.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPVehicleFactory.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    CollisionComponent=CollisionCylinder
}