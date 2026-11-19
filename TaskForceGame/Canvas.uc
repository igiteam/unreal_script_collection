//=============================================================================
// Canvas: A drawing canvas.
// This is a built-in Unreal class and it shouldn't be modified.
//
// Notes.
//   To determine size of a drawable object, set Style to STY_None,
//   remember CurX, draw the thing, then inspect CurX and CurYL.
//=============================================================================
class Canvas extends Object
	native
	noexport;

struct TexVert2D
{
	var float x;
	var float y;
	var float u;
	var float v;
};

struct Rectangle
{
	var float Left;
	var float Top;
	var float Right;
	var float Bottom;
};

enum EJustifyHorz
{
	JH_LEFT,
	JH_CENTER,
	JH_RIGHT
};

enum EJustifyVert
{
	JV_TOP,
	JV_CENTER,
	JV_BOTTOM
};

// Modifiable properties.
var font  Font;            // Font for DrawText.
var float SpaceX, SpaceY;  // Spacing for after Draw*.
var float OrgX, OrgY;      // Origin for drawing.
var float ClipX, ClipY;    // Bottom right clipping region.
var int   OffX, OffY;      // Split screen offsets.
var float CurX, CurY;      // Current position for drawing.
var float Z;               // Z location. 1=no screenflash, 2=yes screenflash.
var byte  Style;           // Drawing style STY_None means don't draw.
var float CurYL;           // Largest Y size since DrawText.
var color DrawColor;       // Color for drawing.
var float ForceAlpha;
var bool  bCenter;         // Whether to center the text.
var bool  bNoSmooth;       // Don't bilinear filter.
var float ScaleX, ScaleY;  // Old-school scaling factor.

var const int SizeX, SizeY; // Actual size in pixels.

var float Scale;              // Global scaling factor used for Draw*2 functions. not const since menu zooming needs to change it.
var const float LogSizeX, LogSizeY; // Logical size (ActualSize/Scale).
var const Rectangle SafeFrame;      // Safe frame in logical units.



// [   1   ] 1: Scale = 1.0, Size = 640x480, SafeFrame = 48,36 - 592,444
// [       ]

// [   1   ] 1: Scale = 0.5, Size =1280x480, SafeFrame = 96,72 -1184,444
// [   2   ] 2: Scale = 0.5, Size =1280x480, SafeFrame = 96,36 -1184,408

// [   1   ] 1: Scale = 0.5, Size =1280x480, SafeFrame = 96,72 -1184,444
// [ 2 | 3 ] 2: Scale = 0.5, Size = 640x480, SafeFrame = 96,36 - 592,408
//           3: Scale = 0.5, Size = 640x480, SafeFrame = 48,36 - 544,408

// [ 1 | 4 ] 1: Scale = 0.5, Size = 640x480, SafeFrame = 96,72 - 592,444
// [ 2 | 3 ] 2: Scale = 0.5, Size = 640x480, SafeFrame = 96,36 - 592,408
//           3: Scale = 0.5, Size = 640x480, SafeFrame = 48,36 - 544,408
//           4: Scale = 0.5, Size = 640x480, SafeFrame = 48,72 - 544,444

// Split screen safe frame has half of the normal buffer (in actual pixels) on the interior edges.



//MERGE JP: Added the following vars for Text Scaling
var float TextHeight; // 0 = use "natural" height
var float TextWidth;  // 0 = scale is TextHeight/VSize, otherwise TextWidth/Font.EmSquare

// Stock fonts.
var font TinyFont, SmallFont, MedFont;
var string TinyFontName, SmallFontName, MedFontName;

// Internal.
var const viewport Viewport; // Viewport that owns the canvas.
var const int      pCanvasUtil; 

var Texture WhiteSquare;
var const float Stack[64];  // internal state stack.
var const int StackPos;     // yep.

var float DropShadowOffsetX;
var float DropShadowOffsetY;

// jp - Use to enable/disable font drop shadows (note: only works with DrawText2)
// xOffset & yOffset are multiplied by the current text size to get the pixel offsets
// i.e. you want values like 0.1f, not 2
// defaults to 0.1f if not specified; y defaults to x if x is specified an y isn't
native final function SetDropShadow(
	bool enable, 
	optional float xOffset, 
	optional float yOffset
);


// kkm--Draws text using the current font, scaling factor, text size and color
native final function DrawText2(
	coerce string Text,          // Text to be drawn. Newline characters are handled correctly
	float X,                     // Leftmost X in logical units
	float Y,                     // Topmost Y in logical units
	optional float XL,           // Lines wider than XL will be wrapped or truncated (0=disable)
	optional float YL,           // Lines starting before X or after X+XL will not be drawn (0=disable)
	optional EJustifyHorz JustH, // Default is JH_LEFT
	optional EJustifyVert JustV, // Default is JV_TOP
	optional bool Truncate,      // Truncate long lines with an ellipsis instead of wrapping
	optional float GlowFactor
);

// kkm--Calculates the extents required to hold text
native final function CalcTextExtents(
	coerce string Text,
	out float XL,
	out float YL
);

// kkm--Calculates the height of wrapped text
native final function float CalcTextHeight(
	coerce string Text,
	float XL
);

// kkm--Draws a tile and takes into account the scaling factor.
native final function DrawTile2( 
	Material Mat, 
	float X, 
	float Y, 
	float XL, 
	float YL, 
	float U, 
	float V, 
	float UL, 
	float VL 
);

// native functions.
native(464) final function StrLen( coerce string String, out float XL, out float YL ); // Wrapped!
native(465) final function DrawText( coerce string Text, optional bool CR, optional int xWrap, optional int xReset );
native(466) final function DrawTile( material Mat, float XL, float YL, float U, float V, float UL, float VL );
native(467) final function DrawActor( Actor A, bool WireFrame, optional bool ClearZ, optional float DisplayFOV );
native(468) final function DrawTileClipped( Material Mat, float XL, float YL, float U, float V, float UL, float VL );
native(469) final function DrawTextClipped( coerce string Text, optional bool bCheckHotKey );
native(470) final function TextSize( coerce string String, out float XL, out float YL ); // Clipped!
native(480) final function DrawPortal( int X, int Y, int Width, int Height, actor CamActor, vector CamLocation, rotator CamRotation, optional int FOV, optional bool ClearZ );

native final function WrapStringToArray(string Text, out array<string> OutArray, float dx, optional string EOL);

native final function SetAngle(float degrees, optional float xOffset, optional float yOffset, optional float zOffset, optional float xReset);

// jmw - These are two helper functions.  The use the whole texture only.  If you need better support, use DrawTile
native final function DrawTileStretched(material Mat, float XL, float YL);
native final function DrawTileJustified(material Mat, byte Justification, float XL, float YL);
native final function DrawTileScaled(material Mat, float XScale, float YScale);
native final function DrawTextJustified(coerce string String, byte Justification, float x1, float y1, float x2, float y2);

//<kris>
native final function DrawTexturedTri( Texture tex, TexVert2D v1, TexVert2D v2, TexVert2D v3 );
native final function DrawTexturedQuad( Texture tex, TexVert2D v1, TexVert2D v2, TexVert2D v3, TexVert2D v4 );
//</kris>

// UnrealScript functions.
event Reset()
{
	Font        = Default.Font;
	SpaceX      = Default.SpaceX;
	SpaceY      = Default.SpaceY;
	OrgX        = Default.OrgX;
	OrgY        = Default.OrgY;
	CurX        = Default.CurX;
	CurY        = Default.CurY;
	Style       = Default.Style;
	DrawColor   = Default.DrawColor;
	CurYL       = Default.CurYL;
	bCenter     = false;
	bNoSmooth   = false;
	Z           = 0.0;
	//MERGE JP: Reset the variables needed for text scaling
	TextHeight	= 0;
	TextWidth	= 0;
	
	DropShadowOffsetX = 0;
	DropShadowOffsetY = 0;
}
final function SetPos( float X, float Y )
{
	CurX = X;
	CurY = Y;
}
final function SetOrigin( float X, float Y )
{
	OrgX = X;
	OrgY = Y;
}
final function SetClip( float X, float Y )
{
	ClipX = X;
	ClipY = Y;
}
final function DrawPattern( material Tex, float XL, float YL, float Scale )
{
	DrawTile( Tex, XL, YL, (CurX-OrgX)*Scale, (CurY-OrgY)*Scale, XL*Scale, YL*Scale );
}
final function DrawIcon( texture Tex, float Scale )
{
	if ( Tex != None )
		DrawTile( Tex, Tex.USize*Scale, Tex.VSize*Scale, 0, 0, Tex.USize, Tex.VSize );
}
final function DrawRect( texture Tex, float RectX, float RectY )
{
	DrawTile( Tex, RectX, RectY, 0, 0, Tex.USize, Tex.VSize );
}

final function SetDrawColor(byte R, byte G, byte B, optional byte A)
{
	local Color C;
	
	C.R = R;
	C.G = G;
	C.B = B;
	if ( A == 0 )
		A = 255;
	C.A = A;
	DrawColor = C;
}

static final function Color MakeColor(byte R, byte G, byte B, optional byte A)
{
	local Color C;
	
	C.R = R;
	C.G = G;
	C.B = B;
	if ( A == 0 )
		A = 255;
	C.A = A;
	return C;
}

// Draw a vertical line
final function DrawVertical(float X, float height)
{
    SetPos( X, CurY);
    DrawRect(WhiteSquare, 2, height);
}

// Draw a horizontal line
final function DrawHorizontal(float Y, float width)
{
    SetPos(CurX, Y);
    DrawRect(WhiteSquare, width, 2);
}

// Draw Line is special as it saves it's original position

final function DrawLine(int direction, float size)
{
    local float X, Y;

    // Save current position
    X = CurX;
    Y = CurY;

    switch (direction) 
    {
      case 0:
		  SetPos(X, Y - size);
		  DrawRect(WhiteSquare, 2, size);
		  break;
    
      case 1:
		  DrawRect(WhiteSquare, 2, size);
		  break;

      case 2:
		  SetPos(X - size, Y);
		  DrawRect(WhiteSquare, size, 2);
		  break;
		  
	  case 3:
		  DrawRect(WhiteSquare, size, 2);
		  break;
    }
    // Restore position
    SetPos(X, Y);
}

final simulated function DrawBracket(float width, float height, float bracket_size)
{
    local float X, Y;
    X = CurX;
    Y = CurY;

	Width  = max(width,5);
	Height = max(height,5);
	
    DrawLine(3, bracket_size);
    DrawLine(1, bracket_size);
    SetPos(X + width, Y);
    DrawLine(2, bracket_size);
    DrawLine(1, bracket_size);
    SetPos(X + width, Y + height);
    DrawLine(0, bracket_size);
    DrawLine(2, bracket_size);
    SetPos(X, Y + height);
    DrawLine(3, bracket_size);
    DrawLine( 0, bracket_size);

    SetPos(X, Y);
}

final event function DrawBox(canvas canvas, float width, float height)
{
	local float X, Y;
	X = canvas.CurX;
	Y = canvas.CurY;
	canvas.DrawRect(WhiteSquare, 2, height);
	canvas.DrawRect(WhiteSquare, width, 2);
	canvas.SetPos(X + width, Y);
	canvas.DrawRect(WhiteSquare, 2, height);
	canvas.SetPos(X, Y + height);
	canvas.DrawRect(WhiteSquare, width+1, 2);
	canvas.SetPos(X, Y);
}

//MERGE JP: Defaulted the variables needed for text scaling (TextHeight & TextWidth)

// Decompiled with UE Explorer.
defaultproperties
{
    Style=1
    DrawColor=(R=127,G=127,B=127,A=255)
    ForceAlpha=1.0000000
    TinyFontName="CBT_DYN_Fonts.Verdana24CT"
    SmallFontName="CBT_DYN_Fonts.Verdana24CT"
    MedFontName="CBT_DYN_Fonts.Verdana24CT"
    WhiteSquare=Texture'WhiteSquareTexture'
}