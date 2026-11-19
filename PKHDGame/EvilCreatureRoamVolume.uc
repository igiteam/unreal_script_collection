class EvilCreatureRoamVolume extends Volume
    hidecategories(Navigation,Object,Movement,Display,Volume);

var() bool bGroundVolume;
var() float ExtentFraction;
var array<EvilCreatureRoamVolume> AdjacentVolumes;

simulated function PostBeginPlay()
{
    local EvilCreatureRoamVolume CRV;
    local editinline PrimitiveComponent prim;
    local Vector A, B;

    super.PostBeginPlay();
    AdjacentVolumes.AddItem(self);
    prim = BrushComponent;
    // End:0x103
    foreach AllActors(Class'EvilCreatureRoamVolume', CRV)
    {
        // End:0x64
        if(AdjacentVolumes.Find(CRV) >= 0)
        {
            continue;            
        }
        CRV.BrushComponent.ClosestPointOnComponentToComponent(prim, A, B);
        // End:0x102
        if(EncompassesPoint(A))
        {
            AdjacentVolumes.AddItem(CRV);
            CRV.AdjacentVolumes.AddItem(self);
        }        
    }    
    //return;    
}

function Vector GetRandomRoamPoint(Vector PawnExtent)
{
    local Box BBox;
    local int I;
    local Vector centre, extents, Retval, HitLoc, HitNorm;

    GetComponentsBoundingBox(BBox);
    centre = (BBox.Max + BBox.Min) * 0.5000000;
    extents = ((BBox.Max - BBox.Min) * 0.5000000) * ExtentFraction;
    I = 0;
    J0xBF:

    // End:0x28E [Loop If]
    if(I < 10)
    {
        Retval = centre + (VRand() * extents);
        // End:0x260
        if(bGroundVolume)
        {
            // End:0x227
            if(Trace(HitLoc, HitNorm, (vect(1.0000000, 1.0000000, 0.0000000) * Retval) + (vect(0.0000000, 0.0000000, 1.0000000) * BBox.Min.Z), (vect(1.0000000, 1.0000000, 0.0000000) * Retval) + (vect(0.0000000, 0.0000000, 1.0000000) * BBox.Min.Z), false, PawnExtent) == none)
            {
                Retval.Z = BBox.Min.Z;                
            }
            else
            {
                Retval.Z = HitLoc.Z;
            }
        }
        // End:0x280
        if(EncompassesPoint(Retval))
        {
            return Retval;
        }
        ++I;
        // [Loop Continue]
        goto J0xBF;
    }
    return Retval;
    //return ReturnValue;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local EvilCreature EC;
    local float sum;

    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    EC = EvilCreature(Other);
    // End:0x5B
    if(EC == none)
    {
        return;
    }
    EC.LastVolume = self;
    EC.TimeOutsideVolumes += (WorldInfo.TimeSeconds - EC.LastVolumeBoundaryCrossTime);
    sum = EC.TimeInsideVolumes + EC.TimeOutsideVolumes;
    EC.VolumeCoverage = ((sum == float(0)) ? 1.0000000 : EC.TimeInsideVolumes / sum);
    EC.LastVolumeBoundaryCrossTime = WorldInfo.TimeSeconds;
    //return;    
}

event UnTouch(Actor Other)
{
    local EvilCreature EC;
    local float sum;

    super(Actor).UnTouch(Other);
    EC = EvilCreature(Other);
    // End:0x40
    if(EC == none)
    {
        return;
    }
    EC.TimeInsideVolumes += (WorldInfo.TimeSeconds - EC.LastVolumeBoundaryCrossTime);
    sum = EC.TimeInsideVolumes + EC.TimeOutsideVolumes;
    EC.VolumeCoverage = ((sum == float(0)) ? 1.0000000 : EC.TimeInsideVolumes / sum);
    EC.LastVolumeBoundaryCrossTime = WorldInfo.TimeSeconds;
    //return;    
}

defaultproperties
{
    ExtentFraction=0.7000000
    BrushColor=(R=255,G=0,B=255,A=255)
    bColored=true
    // Reference: BrushComponent'Default__EvilCreatureRoamVolume.BrushComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BrushComponent0'
    // Archetype: BrushComponent'Engine.Default__Volume.BrushComponent0'
    begin object name="BrushComponent0"
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}