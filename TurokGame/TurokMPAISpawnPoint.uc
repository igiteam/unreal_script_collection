class TurokMPAISpawnPoint extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var(Multiplayer) const @NULL mSpawnTarget;
var(Multiplayer) const class<Class> mPawnClass;
var(Multiplayer) bool mEnabled;

function OnToggle(@NULL Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        mEnabled = true;        
    }
    else
    {
        // End:0x52
        if(Action.InputLinks[1].bHasImpulse)
        {
            mEnabled = false;            
        }
        else
        {
            // End:0x80
            if(Action.InputLinks[2].bHasImpulse)
            {
                mEnabled = !mEnabled;
            }
        }
    }
    //return;    
}

event NotifyMigrated(@NULL MigratedPawn)
{
    // End:0x3B
    if(MigratedPawn != none)
    {
        // DebugMode: 0
        assert(MigratedPawn.GetMPAISpawnPoint() == self);
        TriggerEventClass(Class'TurokSeqEvent_MPAIMigrated', MigratedPawn);
    }
    //return;    
}

defaultproperties
{
    mEnabled=true
    // Reference: SpriteComponent'Default__TurokMPAISpawnPoint.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokMPAISpawnPoint.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    // Reference: CylinderComponent'Default__TurokMPAISpawnPoint.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPAISpawnPoint.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPAISpawnPoint.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bHidden=true
    bMovable=false
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPAISpawnPoint.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPAISpawnPoint.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}