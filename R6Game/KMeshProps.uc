class KMeshProps extends Object
    native
    noexport;

struct KSphereElem
{
    var() Matrix TM;
    var() float Radius;

    structdefaultproperties
    {
        TM=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=1.0000000,Z=0.0000000))
        Radius=1.0000000
    }
};

struct KBoxElem
{
    var() Matrix TM;
    var() float X;
    var() float Y;
    var() float Z;

    structdefaultproperties
    {
        TM=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=1.0000000,Z=0.0000000))
        X=1.0000000
        Y=1.0000000
        Z=1.0000000
    }
};

struct KSphylElem
{
    var() Matrix TM;
    var() float Radius;
    var() float Length;

    structdefaultproperties
    {
        TM=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=1.0000000,Z=0.0000000))
        Radius=1.0000000
        Length=1.0000000
    }
};

struct KConvexElem
{
    var() array<Vector> VertexData;
    var() array<Plane> PlaneData;

    structdefaultproperties
    {
        VertexData=none
        PlaneData=none
    }
};

struct KAggregateGeom
{
    var() array<KSphereElem> SphereElems;
    var() array<KBoxElem> BoxElems;
    var() array<KSphylElem> SphylElems;
    var() array<KConvexElem> ConvexElems;

    structdefaultproperties
    {
        SphereElems=none
        BoxElems=none
        SphylElems=none
        ConvexElems=none
    }
};

var() Vector COMNudge;
var() KAggregateGeom AggGeom;
