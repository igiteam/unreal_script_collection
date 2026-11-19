class UTAutoCrouchVolume extends Volume
    hidecategories(Navigation,Object,Movement,Display);

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local Pawn P;

    P = Pawn(Other);
    // End:0x77
    if((P != none) && P.bCanCrouch)
    {
        SetCrouch(P, 1);
        SetTimer(0.1000000, true, 'CrouchTimer');
    }
    //return;    
}

simulated function SetCrouch(Pawn P, byte bCrouch)
{
    local UTConsolePlayerController PC;
    local Vector Dir, HitLocation, HitNormal;

    PC = UTConsolePlayerController(P.Controller);
    Dir = Vector(P.Rotation) * 5000.0000000;
    // End:0x12E
    if((PC != none) && (int(bCrouch) == int(0)) || TraceComponent(HitLocation, HitNormal, CollisionComponent, P.Location + Dir, P.Location - Dir))
    {
        PC.bDuck = bCrouch;
    }
    //return;    
}

simulated event UnTouch(Actor Other)
{
    local Pawn P;

    P = Pawn(Other);
    // End:0x64
    if((P != none) && P.bCanCrouch)
    {
        SetCrouch(P, 0);
    }
    //return;    
}

simulated function CrouchTimer()
{
    local Pawn P;
    local bool bStillTouching;

    // End:0x5C
    foreach TouchingActors(Class'Engine.Pawn', P)
    {
        // End:0x5B
        if(P.bCanCrouch)
        {
            SetCrouch(P, 1);
            bStillTouching = true;
        }        
    }    
    // End:0x80
    if(!bStillTouching)
    {
        ClearTimer('CrouchTimer');
    }
    //return;    
}

defaultproperties
{
    BrushColor=(R=64,G=64,B=255,A=255)
    bColored=true
    // Reference: BrushComponent'Default__UTAutoCrouchVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    bStatic=false
    CollisionComponent=BrushComponent0
}