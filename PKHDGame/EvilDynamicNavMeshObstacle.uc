class EvilDynamicNavMeshObstacle extends NavMeshObstacle
    hidecategories(Navigation);

enum EShape
{
    EShape_None,                    // 0
    EShape_Square,                  // 1
    EShape_Rectangle,               // 2
    EShape_Circle,                  // 3
    EShape_MAX                      // 4
};

var() EvilDynamicNavMeshObstacle.EShape ShapeType;
var() float Width;
var() float Height;
var() float Radius;
var() int Sides;
var bool AlignToRotation;

simulated function PostBeginPlay()
{
    // End:0x2A
    if(int(ShapeType) == int(1))
    {
        SetAsSquare(Width);        
    }
    else
    {
        // End:0x5D
        if(int(ShapeType) == int(2))
        {
            SetAsRectangle(Width, Height);            
        }
        else
        {
            // End:0x8F
            if(int(ShapeType) == int(3))
            {
                SetAsCircle(Radius, float(Sides));
            }
        }
    }
    super(Actor).PostBeginPlay();
    //return;    
}

function SetAsSquare(float NewWidth)
{
    // End:0x32
    if(NewWidth > 0.0000000)
    {
        ShapeType = 1;
        Width = NewWidth;
    }
    //return;    
}

function SetAsRectangle(float NewWidth, float NewHeight)
{
    // End:0x5A
    if((NewWidth > 0.0000000) && NewHeight > 0.0000000)
    {
        ShapeType = 2;
        Width = NewWidth;
        Height = NewHeight;
    }
    //return;    
}

function SetAsCircle(float NewRadius, float NewSides)
{
    // End:0x5A
    if((NewRadius > 0.0000000) && NewSides > float(0))
    {
        ShapeType = 3;
        Radius = NewRadius;
        Sides = int(NewSides);
    }
    //return;    
}

event bool GetObstacleBoudingShape(out array<Vector> Shape)
{
    local Vector Offset;
    local int I, Angle;
    local Rotator R;

    // End:0x3D1
    if(int(ShapeType) == int(1))
    {
        // End:0x210
        if(AlignToRotation)
        {
            Offset.X = Width;
            Offset.Y = Width;
            Shape.AddItem(Location + (Offset >> Rotation));
            Offset.X = -Width;
            Offset.Y = Width;
            Shape.AddItem(Location + (Offset >> Rotation));
            Offset.X = -Width;
            Offset.Y = -Width;
            Shape.AddItem(Location + (Offset >> Rotation));
            Offset.X = Width;
            Offset.Y = -Width;
            Shape.AddItem(Location + (Offset >> Rotation));            
        }
        else
        {
            Offset.X = Width;
            Offset.Y = Width;
            Shape.AddItem(Location + Offset);
            Offset.X = -Width;
            Offset.Y = Width;
            Shape.AddItem(Location + Offset);
            Offset.X = -Width;
            Offset.Y = -Width;
            Shape.AddItem(Location + Offset);
            Offset.X = Width;
            Offset.Y = -Width;
            Shape.AddItem(Location + Offset);
        }
        return true;        
    }
    else
    {
        // End:0x7A2
        if(int(ShapeType) == int(2))
        {
            // End:0x5E1
            if(AlignToRotation)
            {
                Offset.X = Width;
                Offset.Y = Height;
                Shape.AddItem(Location + (Offset >> Rotation));
                Offset.X = -Width;
                Offset.Y = Height;
                Shape.AddItem(Location + (Offset >> Rotation));
                Offset.X = -Width;
                Offset.Y = -Height;
                Shape.AddItem(Location + (Offset >> Rotation));
                Offset.X = Width;
                Offset.Y = -Height;
                Shape.AddItem(Location + (Offset >> Rotation));                
            }
            else
            {
                Offset.X = Width;
                Offset.Y = Height;
                Shape.AddItem(Location + Offset);
                Offset.X = -Width;
                Offset.Y = Height;
                Shape.AddItem(Location + Offset);
                Offset.X = -Width;
                Offset.Y = -Height;
                Shape.AddItem(Location + Offset);
                Offset.X = Width;
                Offset.Y = -Height;
                Shape.AddItem(Location + Offset);
            }
            return true;            
        }
        else
        {
            // End:0x8DE
            if((int(ShapeType) == int(3)) && Sides > 0)
            {
                Angle = 65536 / Sides;
                R = ((AlignToRotation) ? Rotation : rot(0, 0, 0));
                Offset.X = Radius;
                Offset.Y = 0.0000000;
                I = 0;
                J0x863:

                // End:0x8DC [Loop If]
                if(I < Sides)
                {
                    Shape.AddItem(Location + (Offset >> R));
                    R.Yaw += Angle;
                    ++I;
                    // [Loop Continue]
                    goto J0x863;
                }
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    Components[0]=none
    // Reference: DrawBoxComponent'Default__EvilDynamicNavMeshObstacle.DrawBox0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'DrawBox0'
    // Archetype: DrawBoxComponent'Engine.Default__NavMeshObstacle.DrawBox0'
    begin object name="DrawBox0"
        ReplacementPrimitive=none
    end object
    Components[1]=DrawBox0
}