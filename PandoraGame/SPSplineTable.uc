class SPSplineTable extends Object
    abstract
    native;

struct native SPDFPathPoint
{
    /** MACROS STRUCT DECLARATIONS */
    var() Vector pos;
    /** MACROS STRUCT DECLARATIONS */
    var() Vector Dir;

    structdefaultproperties
    {
        pos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Dir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SPBezierCurve
{
    var Vector C0;
    var Vector C1;
    var Vector C2;
    var Vector C3;

    structdefaultproperties
    {
        C0=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        C1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        C2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        C3=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SPArcLengthToParametricMap
{
    var float m_distanceFromStart;
    var float m_parametricPosition;

    structdefaultproperties
    {
        m_distanceFromStart=0.0000000
        m_parametricPosition=0.0000000
    }
};

struct native SPArcLengthParametrizedBezierCurve
{
    var SPBezierCurve m_curve;
    var float m_length;
    var Matrix m_positionMatrix;
    var Matrix m_tangentMatrix;
    var array<SPArcLengthToParametricMap> m_distanceToParameterMap;

    structdefaultproperties
    {
        m_curve=(C0=(X=0.0000000,Y=0.0000000,Z=0.0000000),C1=(X=0.0000000,Y=0.0000000,Z=0.0000000),C2=(X=0.0000000,Y=0.0000000,Z=0.0000000),C3=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_length=0.0000000
        m_positionMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_tangentMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_distanceToParameterMap=none
    }
};

struct native SPMultiSplineCurve
{
    var array<SPArcLengthParametrizedBezierCurve> m_curve;
    var float m_length;

    structdefaultproperties
    {
        m_curve=none
        m_length=0.0000000
    }
};

struct native SPQuadraticBezierCurve
{
    var Vector C0;
    var Vector C1;
    var Vector C2;

    structdefaultproperties
    {
        C0=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        C1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        C2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};
