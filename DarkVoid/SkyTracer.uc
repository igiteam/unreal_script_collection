class SkyTracer extends SkyEmitter
    native;

var() float Speed;
var() float MaxSpeed;
var() float AccelRate;
var() Vector AdditionalAcceleration;
var() bool bWaitForEffects;
var() ParticleSystem FlightEffect;
var() float ImpactDepth;
var() float SlowSpeedDist;
var() float FastSpeedDist;
var() float SlowSpeedScale;
var() float FastSpeedScale;
var transient Vector ImpactLocation;

// Export USkyTracer::execInitTracer(FFrame&, void* const)
native simulated function InitTracer(Vector StartLocation, Vector EndLocation);

simulated function ImpactTimer()
{
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x3B
    if(!bWaitForEffects)
    {
        HandleLifeSpanExpired();
    }
    //return;    
}
