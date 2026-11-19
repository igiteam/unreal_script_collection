class TurokProtectNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

var() @NULL mProtectGroup;
var() class<Class> mPawnClass;
var private float mThreatLevel;
var private @NULL mIntruder;

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas;

    Canvas = HUD.Canvas;
    super(Actor).DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x124
    if(HUD.ShouldDisplayDebug('AI'))
    {
        Canvas.DrawColor.R = 0;
        Canvas.DrawColor.G = byte(255);
        Canvas.DrawColor.B = byte(255);
        Canvas.__NFUN_465__("ThreatLevel: " $ string(mThreatLevel), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Intruder: " $ string(mIntruder), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
    }
    //return;    
}

function float GetThreatLevel()
{
    return mThreatLevel;
    //return ReturnValue;    
}

private final function CalculateThreats()
{
    local @NULL friendlyPawn, TargetPawn, friendlyController;

    mThreatLevel = 0.0000000;
    mIntruder = none;
    // End:0x119
    if(mPawnClass != none)
    {
        // End:0x3D
        foreach WorldInfo.AllPawns(mPawnClass, friendlyPawn)
        {
            // End:0x3D
            break;            
        }        
        // End:0x119
        if(friendlyPawn != none)
        {
            friendlyController = TurokAIController(friendlyPawn.Controller);
            // End:0x119
            if(friendlyController != none)
            {
                // End:0x118
                foreach CollidingActors(Class'TurokPawn', TargetPawn, friendlyPawn.SightRadius)
                {
                    // End:0x117
                    if(friendlyPawn.mTargetingSystem.ConsiderTarget(friendlyPawn, TargetPawn))
                    {
                        // End:0xED
                        if(mProtectGroup != none)
                        {
                            // End:0xED
                            if(mProtectGroup.InsideRouteRadius(TargetPawn.Location))
                            {
                                mIntruder = TargetPawn;
                            }
                        }
                        mThreatLevel += friendlyController.CalculateTargetThreatValueAtLocation(TargetPawn, true, 0.0000000, Location);
                    }                    
                }                
            }
        }
    }
    //return;    
}

auto state TurokProtectNode
{Begin:

    SetTimer(1.0000000, true, 'CalculateThreats');
    GotoState('Guarded');
    stop;            
}

state Guarded
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(1.0000000, true, 'IntruderAlert');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('IntruderAlert');
        //return;        
    }

    function IntruderAlert()
    {
        // End:0x19
        if(mIntruder != none)
        {
            GotoState('Threatened');
        }
        //return;        
    }
Begin:

    stop;                
}

state Threatened
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(1.0000000, true, 'SoundAlert');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('SoundAlert');
        //return;        
    }

    function SoundAlert()
    {
        // End:0x19
        if(mIntruder == none)
        {
            GotoState('Guarded');
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokProtectNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokProtectNode.Sprite3'
    begin object name=Sprite3
        Sprite=Texture2D'TurokEditorResources.TurokProtectNode_Broken'
    end object
    BrokenSprite=Sprite3
    bNoAutoConnect=true
    // Reference: CylinderComponent'Default__TurokProtectNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokProtectNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokProtectNode'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokProtectNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bStatic=false
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokProtectNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    Components[4]=Sprite3
    Components[5]=Sprite4
    // Reference: TurokProtectNodeRenderingComponent'Default__TurokProtectNode.TurokProtectRenderer'
    begin object name=TurokProtectRenderer class=Class'TurokProtectNodeRenderingComponent'
        HiddenGame=false
    end object
    Components[6]=TurokProtectRenderer
    CollisionComponent=CollisionCylinder
}