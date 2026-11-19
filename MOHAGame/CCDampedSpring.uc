class CCDampedSpring extends Object
    native
    editinlinenew
    hidecategories(Object);

var() float SpringConstant;
var() float DampingConstant;
var() float Mass;
var transient float Position;
var transient float Velocity;
var transient float Acceleration;
var transient float LastPosition;
var transient float LastVelocity;
var transient float LastAcceleration;

event bool Reset()
{
    Position = 0.0000000;
    Velocity = 0.0000000;
    Acceleration = 0.0000000;
    LastPosition = 0.0000000;
    LastVelocity = 0.0000000;
    LastAcceleration = 0.0000000;
    return true;
    //return ReturnValue;    
}

event float Tick(float DeltaSeconds, float RealPosition)
{
    local float NextPosition;

    // End:0x39
    if((RealPosition - Position) > (float(5) * (Position - LastPosition)))
    {
        Acceleration = 0.0000000;
        Velocity = 0.0000000;
    }
    LastAcceleration = Acceleration;
    LastVelocity = Velocity;
    LastPosition = Position;
    Position = RealPosition;
    Acceleration = (((-1.0000000 * SpringConstant) / Mass) * Position) - ((DampingConstant / Mass) * LastVelocity);
    NextPosition = ((2.0000000 * Position) - LastPosition) + ((DeltaSeconds * DeltaSeconds) * Acceleration);
    Velocity = (NextPosition - LastPosition) / (2.0000000 * DeltaSeconds);
    return NextPosition;
    //return ReturnValue;    
}

defaultproperties
{
    SpringConstant=100.0000000
    DampingConstant=20.0000000
    Mass=1.0000000
}