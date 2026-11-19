class SPGlassStaticMeshComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Collision,Rendering,Lighting);

const BoundaryLeft = 1;
const BoundaryRight = 2;
const BoundaryBoth = 3;
const Epsilon = 0.0001;
const EpsilonSq = 0.00000001;
const INVALID_INDEX = -1;
const MAX_IMPACTS = 3;

enum GlassState
{
    GlassState_UnBroken,            // 0
    GlassState_Cracked,             // 1
    GlassState_Broken,              // 2
    GlassState_MAX                  // 3
};

struct native SPDSheetSurfaceInfo
{
    var Matrix WorldTransform;
    var Vector Normal;
    var Vector Origin;
    var float Width;
    var float Height;
    var float Width2D;
    var float Height2D;
    var Vector2D Centre;
    var Vector2D Scale;
    var Vector2D Disp;

    structdefaultproperties
    {
        WorldTransform=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Origin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Width=0.0000000
        Height=0.0000000
        Width2D=0.0000000
        Height2D=0.0000000
        Centre=(X=0.0000000,Y=0.0000000)
        Scale=(X=0.0000000,Y=0.0000000)
        Disp=(X=0.0000000,Y=0.0000000)
    }
};

struct native GlassImpactInfo
{
    var Vector Location3D;
    var Vector2D Location;
    var float Radius;
    var Vector Momentum;

    structdefaultproperties
    {
        Location3D=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Location=(X=0.0000000,Y=0.0000000)
        Radius=0.0000000
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ImpactManagerType
{
    var array<GlassImpactInfo> Info;
    var int LastSlot;

    structdefaultproperties
    {
        Info=none
        LastSlot=0
    }
};

struct native EdgeVertex
{
    var Vector2D Position;

    structdefaultproperties
    {
        Position=(X=0.0000000,Y=0.0000000)
    }
};

struct native Vertex2d
{
    var Vector Position;
    var Vector2D TexCoord;

    structdefaultproperties
    {
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TexCoord=(X=0.0000000,Y=0.0000000)
    }
};

struct native BreakEdge
{
    var int VertexIndex[2];
    var byte Flags;

    structdefaultproperties
    {
        VertexIndex[0]=0
        VertexIndex[1]=0
        Flags=0
    }
};

struct native SplitEdge
{
    var int Index;
    var Vector2D Intersection;

    structdefaultproperties
    {
        Index=0
        Intersection=(X=0.0000000,Y=0.0000000)
    }
};

struct native Boundary2d
{
    var array<BreakEdge> BoundaryEdge;
    var array<BreakEdge> InternalEdge;
    var array<EdgeVertex> EdgeVertex;
    var transient Vector2D ExtentMin;
    var transient Vector2D ExtentMax;
    var transient array<SplitEdge> SplitEdge;

    structdefaultproperties
    {
        BoundaryEdge=none
        InternalEdge=none
        EdgeVertex=none
        ExtentMin=(X=0.0000000,Y=0.0000000)
        ExtentMax=(X=0.0000000,Y=0.0000000)
        SplitEdge=none
    }
};

struct native EVertex
{
    var Vector2D Vertex;
    var int IncidentEdge;
    var int Flags;

    structdefaultproperties
    {
        Vertex=(X=0.0000000,Y=0.0000000)
        IncidentEdge=0
        Flags=0
    }
};

struct native HalfEdge
{
    var int Origin;
    var int Destination;
    var int Twin;
    var int IncidentFace;
    var int Next;
    var int Prev;
    var float TreeLocation;

    structdefaultproperties
    {
        Origin=0
        Destination=0
        Twin=0
        IncidentFace=0
        Next=0
        Prev=0
        TreeLocation=0.0000000
    }
};

struct native Face
{
    var int OuterComponent;
    var array<int> InnerComponent;
    var array<int> Triangles;
    var int FirstTriIdx;
    var float Area;
    var Vector2D Centre;
    var Vector Centre3D;
    var float Radius;
    var Vector StartLocation;
    var Vector Location;
    var Rotator Rotation;
    var Quat QRotation;
    var Vector AVelocity;
    var Matrix LocalToWorldMatrix;
    var Matrix WorldToLocalMatrix;
    var float StartDelayTime;
    var float Lifetime;
    var Vector Velocity;

    structdefaultproperties
    {
        OuterComponent=0
        InnerComponent=none
        Triangles=none
        FirstTriIdx=0
        Area=0.0000000
        Centre=(X=0.0000000,Y=0.0000000)
        Centre3D=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Radius=0.0000000
        StartLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        QRotation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        AVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LocalToWorldMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        WorldToLocalMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        StartDelayTime=0.0000000
        Lifetime=0.0000000
        Velocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native EdgeTreeElement
{
    var int Idx;
    var float Key;
    var int Parent;
    var int LeftChild;
    var int RightChild;

    structdefaultproperties
    {
        Idx=0
        Key=0.0000000
        Parent=0
        LeftChild=0
        RightChild=0
    }
};

struct native DCEdgeList
{
    var array<EVertex> VertexList;
    var array<Face> FaceList;
    var array<HalfEdge> EdgeList;
    var Vector2D ModelVertexScale;
    var Vector2D ModelVertexDisp;
    var Vector BoxExtents;
    var transient int TreeTop;
    var transient array<EdgeTreeElement> EdgeRef;

    structdefaultproperties
    {
        VertexList=none
        FaceList=none
        EdgeList=none
        ModelVertexScale=(X=0.0000000,Y=0.0000000)
        ModelVertexDisp=(X=0.0000000,Y=0.0000000)
        BoxExtents=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TreeTop=0
        EdgeRef=none
    }
};

/** VARIABLE DECLARATIONS */
var() bool ShowCracks;
var(Debug) transient bool DbgRenderMeshPieces;
var(Debug) transient bool DbgRenderDecl;
var(Debug) transient bool DbgRenderDeclFaces;
var(Debug) transient bool DbgRenderEdges;
var(Debug) transient bool DbgRenderVertices;
var(Debug) transient bool DbgTest;
var transient bool DbgLastTest;
var() BoxSphereBounds ShardBounds;
var transient int ImpactCount;
var transient Actor LastOwner;
var transient SPDSheetSurfaceInfo SheetInfo;
var transient array<Boundary2d> Boundary;
var transient DCEdgeList Subdivision;
/** Damage Data */
var() float HitPoints;
var transient SPGlassStaticMeshComponent.GlassState DamageState;
var transient ImpactManagerType ImpactManager;
/** Render Data */
var() Material OpaqueMaterial;
var() float OpaqueMaterialPixelSize;
var() float Lifetime;
var private const Pointer VertexBuffer;
var private const Pointer VertexFactory;
var private native const transient Pointer RenderData;
/** Debug Checking in without exposing debug variables. They may be exposed by an engineer for test purposes */
var(Debug) transient float DebugSpacing;
var(Debug) array<Vector2D> DebugImpact;

// Export USPGlassStaticMeshComponent::execBuildSheetInfo(FFrame&, void* const)
native function BuildSheetInfo();

// Export USPGlassStaticMeshComponent::execHandleDamage(FFrame&, void* const)
native function HandleDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

// Export USPGlassStaticMeshComponent::execUpdate(FFrame&, void* const)
native function Update(float TimeElapsed);

function Explode(ParticleSystem ParticleSystem)
{
    local Emitter Emitter;
    local editinline ParticleSystemComponent psComp;
    local float NewScale;

    BuildSheetInfo();
    // End:0x17
    if(ParticleSystem == none)
    {
        return;
    }
    // End:0x24
    if(Owner == none)
    {
        return;
    }
    Emitter = Owner.Spawn(Class'Engine.EmitterSpawnable',,, Bounds.Origin, Owner.Rotation + Rotation);
    psComp = Emitter.ParticleSystemComponent;
    NewScale = Bounds.SphereRadius / float(400);
    psComp.SetScale(NewScale);
    psComp.CastShadow = false;
    // End:0x13F
    if(Emitter != none)
    {
        Emitter.SetTemplate(ParticleSystem, true);
        Emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
        Emitter.LifeSpan = 1.0000000;
        Emitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    HandleDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo);
    //return;    
}
