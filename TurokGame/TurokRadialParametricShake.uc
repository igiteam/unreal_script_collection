class TurokRadialParametricShake extends TurokParametricShake
    native
    hidecategories(Object);

var float mFalloffRadius;
var @NULL mSourceActor;

// Export UTurokRadialParametricShake::execComputeDamper(FFrame&, void* const)
native function float ComputeDamper();

static function BroadcastRadialShake(@NULL SourceActor, @NULL Component)
{
    local @NULL Player, PC, Cam, ActorLoc;

    // End:0x1A
    if((SourceActor == none) || Component == none)
    {
        return;
    }
    ActorLoc = SourceActor.Location;
    // End:0x86
    if((int(SourceActor.Physics) == int(12)) && Pawn(SourceActor) != none)
    {
        ActorLoc = Pawn(SourceActor).Mesh.GetBoneLocation('jt_Cog_C');
    }
    // End:0x1F3
    foreach SourceActor.OverlappingActors(Class'TurokPawnPlayer', Player, Component.Radius, ActorLoc)
    {
        // End:0x104
        if((Player.IsInState('CannedAnimation') && Player.IsPlayerPawn()) && Player.IsA('TurokPawnHuman'))
        {
            continue;            
        }
        // End:0x11C
        if(Player.Controller == none)
        {
            continue;            
        }
        PC = PlayerController(Player.Controller);
        // End:0x144
        if(PC == none)
        {
            continue;            
        }
        // End:0x15C
        if(PC.PlayerCamera == none)
        {
            continue;            
        }
        Cam = TurokPlayerCamera(PC.PlayerCamera);
        // End:0x1F2
        if(Cam != none)
        {
            Cam.mShakeModifier.mFalloffRadius = Component.Radius;
            Cam.mShakeModifier.mSourceActor = SourceActor;
            Cam.mShakeModifier.PlayShake(Component, Component.Duration);
        }        
    }    
    //return;    
}

defaultproperties
{
    mFalloffRadius=1024.0000000
    // Reference: TurokParametricShakeComponent'Default__TurokRadialParametricShake.Shakey'
    begin object name=Shakey
    end object
    mShakeComponent=Shakey
    // Reference: TurokSmoothNoise'Default__TurokRadialParametricShake.RotNoise'
    begin object name=RotNoise
    end object
    mRotationNoise=RotNoise
    // Reference: TurokSmoothNoise'Default__TurokRadialParametricShake.TranNoise'
    begin object name=TranNoise
    end object
    mTranslationNoise=TranNoise
}