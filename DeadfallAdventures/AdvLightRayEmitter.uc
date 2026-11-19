class AdvLightRayEmitter extends Actor
    placeable
    hidecategories(Navigation)
    classgroup(Adventurer);

var() bool bActive;
var private bool bSpawned;
var() private const export editinline ArrowComponent RayDirection;
var private AdvMirrorDynamic AffectedMirror;
var private float CurrentDelay;
var private float CheckDelay;
var AdvLightRay Ray;
var private Vector RayHitLocation;

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

function bool IsActive()
{
    return bActive;
    //return ReturnValue;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x46
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bActive = true;        
    }
    else
    {
        // End:0x8C
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bActive = false;            
        }
        else
        {
            // End:0xDB
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bActive = !bActive;
            }
        }
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local Actor TraceActor;
    local Vector HitNorm, HitLoc, EndTrace;
    local AdvMirrorDynamic Mirror;

    super.Tick(DeltaTime);
    // End:0x3B5
    if(bActive)
    {
        // End:0x2EF
        if(CurrentDelay <= 0.0000000)
        {
            EndTrace = Location + (Normal(Vector(Rotation)) * float(10000));
            // End:0xB6
            if(bSpawned)
            {
                Ray.SetRayDirection(Vector(Rotation));
                Ray.SetLocation(Location);
            }
            // End:0x124
            foreach TraceActors(Class'Engine.Actor', TraceActor, HitLoc, HitNorm, EndTrace, Location)
            {
                Mirror = AdvMirrorDynamic(TraceActor);
                // End:0x123
                if(Mirror != none)
                {
                    // End:0x124
                    break;
                }                
            }            
            // End:0x23B
            if(((Mirror != none) && !Mirror.IsActive()) && (AffectedMirror == none) || AffectedMirror != Mirror)
            {
                // End:0x1B3
                if(AffectedMirror != none)
                {
                    AffectedMirror.Activate(false);
                }
                Mirror.Activate(true);
                Mirror.SetIncomingRay(Vector(Rotation));
                Mirror.SetRayHitLocation(HitLoc);
                AffectedMirror = Mirror;                
            }
            else
            {
                // End:0x289
                if((Mirror == none) && AffectedMirror != none)
                {
                    AffectedMirror.Activate(false);
                    AffectedMirror = none;                    
                }
                else
                {
                    // End:0x2D9
                    if((Mirror != none) && Mirror == AffectedMirror)
                    {
                        Mirror.SetRayHitLocation(HitLoc);
                    }
                }
            }
            CurrentDelay = CheckDelay;            
        }
        else
        {
            CurrentDelay -= DeltaTime;
        }
        // End:0x3B2
        if(!bSpawned)
        {
            CurrentDelay = 0.0000000;
            Ray = Spawn(Class'AdvLightRay', self,, Location, Rotation,, true);
            // End:0x3B2
            if(Ray != none)
            {
                Ray.SetRayDirection(Vector(Rotation));
                Ray.SetOwner(self);
                bSpawned = true;
            }
        }        
    }
    else
    {
        // End:0x41E
        if(Ray != none)
        {
            Ray.Destroy();
            bSpawned = false;
            AffectedMirror = none;
            Ray = none;
            AffectedMirror.Activate(false);
        }
    }
    //return;    
}

defaultproperties
{
    bActive=true
    CheckDelay=0.0010000
    Components[0]=none
    Components[1]=none
}