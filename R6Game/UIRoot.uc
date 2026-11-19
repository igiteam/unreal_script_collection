class UIRoot extends Object
    abstract
    native;

const DEFAULT_SIZE_X = 800;
const DEFAULT_SIZE_Y = 600;

enum EMaterialAdjustmentType
{
    ADJUST_None,                    // 0
    ADJUST_Normal,                  // 1
    ADJUST_Bound,                   // 2
    ADJUST_Stretch,                 // 3
    ADJUST_MAX                      // 4
};

enum EPositionEvalType
{
    EVALPOS_None,                   // 0
    EVALPOS_PixelViewport,          // 1
    EVALPOS_PixelScene,             // 2
    EVALPOS_PixelOwner,             // 3
    EVALPOS_PercentageViewport,     // 4
    EVALPOS_PercentageOwner,        // 5
    EVALPOS_PercentageScene,        // 6
    EVALPOS_MAX                     // 7
};

enum ETextClipMode
{
    CLIP_Normal,                    // 0
    CLIP_Ellipsis,                  // 1
    CLIP_Wrap,                      // 2
    CLIP_MAX                        // 3
};

enum EUIAlignment
{
    UIALIGN_Left,                   // 0
    UIALIGN_Center,                 // 1
    UIALIGN_Right,                  // 2
    UIALIGN_MAX                     // 3
};

enum EUIListElementState
{
    ELEMENT_Normal,                 // 0
    ELEMENT_Active,                 // 1
    ELEMENT_Selected,               // 2
    ELEMENT_MAX                     // 3
};

enum EUIOrientation
{
    UIORIENT_Horizontal,            // 0
    UIORIENT_Vertical,              // 1
    UIORIENT_MAX                    // 2
};

enum EUIWidgetFace
{
    UIFACE_Left,                    // 0
    UIFACE_Top,                     // 1
    UIFACE_Right,                   // 2
    UIFACE_Bottom,                  // 3
    UIFACE_MAX                      // 4
};

struct WIDGET_ID extends Guid
{
    structcpptext
    {

	FWIDGET_ID()
	: FGuid()
	{ }

	FWIDGET_ID( const FGuid& Other )
	: FGuid(Other)
	{ }

    }
};

struct STYLE_ID extends Guid
{
    structcpptext
    {

	FSTYLE_ID()
	: FGuid()
	{ }

	FSTYLE_ID( const FGuid& Other )
	: FGuid(Other)
	{ }

    }
};

struct UIScreenValue
{
    structcpptext
    {

	/**
	 * Evaluates the value stored in this UIScreenValue
	 *
	 * @param	OutputType	determines the format of the result.
	 *						EVALPOS_None:
	 *							return value is formatted using this struct's ScaleType
	 *						EVALPOS_PercentageOwner:
	 *						EVALPOS_PercentageScene:
	 *						EVALPOS_PercentageViewport:
	 *							return a value between 0.0 and 1.0, which represents the percentage of the corresponding
	 *							base's actual size.  If OwnerWidget isn't specified, the size of the
	 *							entire viewport is used.
	 *						EVALPOS_Pixels
	 *							return the actual pixel values represented by this UIScreenValue.
	 * @param	OwnerWidget	the widget that contains this screen value
	 *
	 * @return	the actual value for this UIScreenValue, in pixels or percentage.
	 */
	FLOAT GetValue( EPositionEvalType OutputType=EVALPOS_None, class UUIScreenObject* OwnerWidget = NULL );

	/**
	 * Constructors
	 */
	FUIScreenValue()
	{ }

	FUIScreenValue( FLOAT inValue )
	: Value(inValue), ScaleType(EVALPOS_None)
	{ }

	FUIScreenValue( FLOAT inValue, EPositionEvalType inScaleType )
	: Value(inValue), ScaleType(inScaleType)
	{ }

    }

    var() float Value;
    var() UIRoot.EPositionEvalType ScaleType;

    structdefaultproperties
    {
        Value=0.0000000
        ScaleType=0
    }
};

struct UIScreenValue_Position
{
    structcpptext
    {

	/**
	 * Evaluates the value stored in this UIScreenValue
	 *
	 * @param	Dimension	indicates which element of the Value array to evaluate
	 * @param	OutputType	determines the format of the result.
	 *						EVALPOS_None:
	 *							return value is formatted using this struct's ScaleType
	 *						EVALPOS_PercentageOwner:
	 *						EVALPOS_PercentageScene:
	 *						EVALPOS_PercentageViewport:
	 *							return a value between 0.0 and 1.0, which represents the percentage of the corresponding
	 *							base's actual size.  If OwnerWidget isn't specified, the size of the
	 *							entire viewport is used.
	 *						EVALPOS_Pixels
	 *							return the actual pixel values represented by this UIScreenValue.
	 * @param	OwnerWidget	the widget that contains this screen value
	 *
	 * @return	the actual value for this UIScreenValue, in pixels or percentage, for the dimension specified.
	 */
	FLOAT GetValue( EUIOrientation Dimension, EPositionEvalType OutputType=EVALPOS_None, class UUIScreenObject* OwnerWidget = NULL );

	/**
	 * Constructors
	 */
	FUIScreenValue_Position()
	{}

	FUIScreenValue_Position( FLOAT XValue, FLOAT YValue )
	{
		Value[UIORIENT_Horizontal]	=	XValue;
		Value[UIORIENT_Vertical]	=	YValue;
		for ( INT i = 0; i < UIORIENT_MAX; i++ )
		{
			ScaleType[i] = EVALPOS_None;
		}
	}

	FUIScreenValue_Position( FLOAT XValue, FLOAT YValue, EPositionEvalType XScaleType, EPositionEvalType YScaleType )
	{
		Value[UIORIENT_Horizontal]		=	XValue;
		Value[UIORIENT_Vertical]		=	YValue;

		ScaleType[UIORIENT_Horizontal]	=	XScaleType;
		ScaleType[UIORIENT_Vertical]	=	YScaleType;
	}

    }

    var() float Value[2];
    var() UIRoot.EPositionEvalType ScaleType[2];

    structdefaultproperties
    {
        Value[0]=0.0000000
        Value[1]=0.0000000
        ScaleType[0]=0
        ScaleType[1]=0
    }
};

struct UIScreenValue_Bounds
{
    structcpptext
    {

	/**
	 * Calculates the origin and extent for the position value of a single widget face
	 *
	 * @param	OwnerWidget		the widget that owns this position
	 * @param	Face			the face to evaluate
	 * @param	Type			indicates how the base values will be used, how they should be formatted
	 * @param	BaseValue		[out] absolute pixel values for the base of this position for the specified face.  For example,
	 *							if the Face is UIFACE_Left, BaseValue will represent the X position of the OwnerWidget's container,
	 *							in absolute pixel values
	 */
	static void CalculateBaseValue( UUIScreenObject* OwnerWidget, EUIWidgetFace Face, EPositionEvalType Type, FLOAT& BaseValue, FLOAT& BaseExtent );

	/**
	 * Evaluates the value stored in this UIScreenValue
	 *
	 * @param	OwnerWidget	the widget that contains this screen value
	 * @param	Face		indicates which element of the Value array to evaluate
	 * @param	OutputType	determines the format of the result.
	 *						EVALPOS_None:
	 *							return value is formatted using this screen position's ScaleType for the specified face
	 *						EVALPOS_PercentageOwner:
	 *						EVALPOS_PercentageScene:
	 *						EVALPOS_PercentageViewport:
	 *							return a value between 0.0 and 1.0, which represents the percentage of the corresponding
	 *							base's actual size.  If OwnerWidget isn't specified, the size of the
	 *							entire viewport is used.
	 *						EVALPOS_PixelOwner
	 *						EVALPOS_PixelScene
	 *						EVALPOS_PixelViewport
	 *							return the actual pixel values represented by this UIScreenValue, relative to the corresponding base.
	 *
	 * @return	the actual value for this UIScreenValue, in pixels or percentage, for the face specified.
	 */
	FLOAT GetValue( class UUIScreenObject* OwnerWidget, EUIWidgetFace Face, EPositionEvalType OutputType=EVALPOS_None );


	/**
	 * Convert the value specified into the appropriate type for this screen value, and set that as the value for the face specified.
	 *
	 * @param	OwnerWidget		the widget that contains this screen value
	 * @param	NewValue		the new value (in pixels or percentage) to use
	 * @param	Face			indicates which element of the Value array to modify
	 * @param	InputType		indicates the format of the input value
	 *							EVALPOS_None:
	 *								NewValue is assumed to be formatted with what this screen position's ScaleType is for the specified face
	 *							EVALPOS_PercentageOwner:
	 *							EVALPOS_PercentageScene:
	 *							EVALPOS_PercentageViewport:
	 *								Indicates that NewValue is a value between 0.0 and 1.0, which represents the percentage of the corresponding
	 *								base's actual size.
	 *							EVALPOS_PixelOwner
	 *							EVALPOS_PixelScene
	 *							EVALPOS_PixelViewport
	 *								Indicates that NewValue is an actual pixel value, relative to the corresponding base.
	 */
	void SetValue( class UUIScreenObject* OwnerWidget, FLOAT NewValue, EUIWidgetFace Face, EPositionEvalType InputType=EVALPOS_PixelOwner );

	/**
	 * Retrieves the value of the width or height of this widget's bounds.
	 *
	 * @param	OwnerWidget	the widget that contains this screen value
	 * @param	Dimension	determines whether width or height is desired.  Specify UIORIENT_Horizontal to get the width, or UIORIENT_Vertical to get the height.
	 * @param	OutputType	determines the format of the result.
	 *						EVALPOS_None:
	 *							return value is formatted using this screen position's ScaleType for the specified face
	 *						EVALPOS_PercentageOwner:
	 *						EVALPOS_PercentageScene:
	 *						EVALPOS_PercentageViewport:
	 *							return a value between 0.0 and 1.0, which represents the percentage of the corresponding
	 *							base's actual size.  If OwnerWidget isn't specified, the size of the
	 *							entire viewport is used.
	 *						EVALPOS_PixelOwner
	 *						EVALPOS_PixelScene
	 *						EVALPOS_PixelViewport
	 *							return the actual pixel values represented by this UIScreenValue, relative to the corresponding base.
	 *
	 * @return	the value of the width/height of this UIScreenValue, in pixels or percentage.
	 */
	FLOAT GetExtent( class UUIScreenObject* OwnerWidget, EUIOrientation Dimension, EPositionEvalType OutputType=EVALPOS_PixelOwner );

	/**
	 * Constructors
	 */
	FUIScreenValue_Bounds()
	{}

	FUIScreenValue_Bounds( FLOAT LeftValue, FLOAT TopValue, FLOAT RightValue, FLOAT BottomValue )
	{
		Value[UIFACE_Left]		=	LeftValue;
		Value[UIFACE_Top]		=	RightValue;
		Value[UIFACE_Right]		=	LeftValue;
		Value[UIFACE_Bottom]	=	RightValue;

		for ( INT i = 0; i < UIFACE_MAX; i++ )
		{
			ScaleType[i] = EVALPOS_None;
		}
	}

	FUIScreenValue_Bounds
	(
		FLOAT LeftValue, FLOAT TopValue, FLOAT RightValue, FLOAT BottomValue,
		EPositionEvalType LeftScaleType, EPositionEvalType TopScaleType, EPositionEvalType RightScaleType, EPositionEvalType BottomScaleType
	)
	{
		Value[UIFACE_Left]			=	LeftValue;
		Value[UIFACE_Top]			=	RightValue;
		Value[UIFACE_Right]			=	LeftValue;
		Value[UIFACE_Bottom]		=	RightValue;
		ScaleType[UIFACE_Left]		=	LeftScaleType;
		ScaleType[UIFACE_Top]		=	TopScaleType;
		ScaleType[UIFACE_Right]		=	RightScaleType;
		ScaleType[UIFACE_Bottom]	=	BottomScaleType;
	}

    }

    var() float Value[4];
    var() UIRoot.EPositionEvalType ScaleType[4];

    structdefaultproperties
    {
        Value[0]=0.0000000
        Value[1]=0.0000000
        Value[2]=1.0000000
        Value[3]=1.0000000
        ScaleType[0]=5
        ScaleType[1]=5
        ScaleType[2]=5
        ScaleType[3]=5
    }
};

struct ScreenPositionRange extends UIScreenValue_Position
{
    structcpptext
    {

	/**
	 * Retrieves the value of the distance between the endpoints of this region
	 *
	 * @param	OutputType	determines the format of the result.
	 *						EVALPOS_None:
	 *							return value is formatted using this struct's ScaleType
	 *						EVALPOS_PercentageOwner:
	 *						EVALPOS_PercentageScene:
	 *						EVALPOS_PercentageViewport:
	 *							return a value between 0.0 and 1.0, which represents the percentage of the corresponding
	 *							base's actual size.  If OwnerWidget isn't specified, the size of the
	 *							entire viewport is used.
	 *						EVALPOS_Pixels
	 *							return the actual pixel values represented by this UIScreenValue.
	 * @param	OwnerWidget	the widget that contains this screen value
	 *
	 * @return	the value of the width of this UIScreenValue, in pixels or percentage.
	 */
	FLOAT GetRegionValue( EPositionEvalType OutputType=EVALPOS_None, class UUIScreenObject* OwnerWidget=NULL );

    }
};

struct AutoSizePadding extends UIScreenValue_Position
{
};

struct AutoSizeData
{
    var ScreenPositionRange Extent;
    var AutoSizePadding Padding;
    var bool bAutoSizeEnabled;

    structdefaultproperties
    {
        Extent=(Value=0.0000000,Value[1]=0.0000000,ScaleType=0,ScaleType[1]=0)
        Padding=(Value=0.0000000,Value[1]=0.0000000,ScaleType=0,ScaleType[1]=0)
        bAutoSizeEnabled=false
    }
};

struct UITextAttributes
{
    var bool Bold;
    var bool Italic;
    var bool Underline;
    var bool Shadow;
    var bool Strikethrough;

    structdefaultproperties
    {
        Bold=false
        Italic=false
        Underline=false
        Shadow=false
        Strikethrough=false
    }
};

struct InputEventSubscription
{
    var name KeyName;
    var array<UIObject> Subscribers;

    structdefaultproperties
    {
        KeyName="None"
        Subscribers=none
    }
};

struct UIDockingSet
{
    structcpptext
    {

	/**
	 * Evaluate the widget's Position into an absolute pixel value, and store that value in the corresponding
	 * member of the widget's RenderBounds array.
	 * This function assumes that UpdateDockingSet has already been called for the TargetFace of the TargetWidget.
	 * This function should only be called from ResolveScenePositions.
	 *
	 * @param	SourceWidget	the widget to resolve the position for
	 * @param	Face			the face that needs to be resolved
	 */
	void UpdateDockingSet( UUIObject* SourceWidget, EUIWidgetFace Face );

    }

    var() UIObject TargetWidget[4];
    var() float DockPadding[4];
    var() UIRoot.EUIWidgetFace TargetFace[4];

    structdefaultproperties
    {
        TargetWidget[0]=none
        TargetWidget[1]=none
        TargetWidget[2]=none
        TargetWidget[3]=none
        DockPadding[0]=0.0000000
        DockPadding[1]=0.0000000
        DockPadding[2]=0.0000000
        DockPadding[3]=0.0000000
        TargetFace[0]=4
        TargetFace[1]=4
        TargetFace[2]=4
        TargetFace[3]=4
    }
};

struct UIDockingNode
{
    structcpptext
    {

	/**
	 * Comparison operator
	 */
	UBOOL operator==( const FUIDockingNode& Other ) const
	{
		return Widget == Other.Widget && Face == Other.Face;
	}

	/**
	 * Constructors
	 */
	FUIDockingNode( UUIObject* inWidget=NULL, EUIWidgetFace inFace=UIFACE_MAX )
	: Widget(inWidget), Face(inFace)
	{ }

	FUIDockingNode( const FUIDockingNode& Other )
	: Widget(Other.Widget), Face(Other.Face)
	{ }

    }

    var() UIObject Widget;
    var() UIRoot.EUIWidgetFace Face;

    structdefaultproperties
    {
        Widget=none
        Face=0
    }
};

struct UIImageAdjustmentData
{
    var() ScreenPositionRange ProtectedRegion;
    var() UIRoot.EMaterialAdjustmentType AdjustmentType;
    var() UIRoot.EUIAlignment Alignment;

    structdefaultproperties
    {
        ProtectedRegion=(Value=0.0000000,Value[1]=0.0000000,ScaleType=0,ScaleType[1]=0)
        AdjustmentType=1
        Alignment=0
    }
};

struct TextureCoordinates
{
    structcpptext
    {

	/** Constructors */
	FTextureCoordinates()
	{ }

	FTextureCoordinates( INT inU, INT inV, INT inUL, INT inVL )
	: U(inU), V(inV), UL(inUL), VL(inVL)
	{ }

    }

    var() int U;
    var() int V;
    var() int UL;
    var() int VL;

    structdefaultproperties
    {
        U=0
        V=0
        UL=0
        VL=0
    }
};

struct RenderParameters
{
    structcpptext
    {

	/** Constructors */
	FRenderParameters()
	: DrawX(0.f), DrawY(0.f), DrawXL(0.f), DrawYL(0.f)
	, Scaling(1.f,1.f), DrawFont(NULL), DrawCoords(0,0,0,0)
	{ }

	FRenderParameters( FLOAT inDrawX, FLOAT inDrawY, FLOAT inDrawXL, FLOAT inDrawYL, UFont* inFont=NULL )
	: DrawX(inDrawX), DrawY(inDrawY), DrawXL(inDrawXL), DrawYL(inDrawYL)
	, Scaling(1.f,1.f), DrawFont(inFont), DrawCoords(0,0,0,0)
	{ }

	FRenderParameters( UFont* inFont, FLOAT ScaleX, FLOAT ScaleY )
	: DrawFont(inFont), Scaling(ScaleX,ScaleY)
	, DrawX(0.f), DrawY(0.f), DrawXL(0.f), DrawYL(0.f), DrawCoords(0,0,0,0)
	{}

    }

    var float DrawX;
    var float DrawY;
    var float DrawXL;
    var float DrawYL;
    var Vector2D Scaling;
    var Font DrawFont;
    var TextureCoordinates DrawCoords;

    structdefaultproperties
    {
        DrawX=0.0000000
        DrawY=0.0000000
        DrawXL=0.0000000
        DrawYL=0.0000000
        Scaling=(X=0.0000000,Y=0.0000000)
        DrawFont=none
        DrawCoords=(U=0,V=0,UL=0,VL=0)
    }
};

struct UIStringNode
{
    structcpptext
    {

	/** Constructor */
	FUIStringNode( const TCHAR* inSourceText )
	: SourceText(inSourceText), Extent(0.f,0.f), Scaling(1.f,1.f)
	{}

	/** Destructor */
	virtual ~FUIStringNode() {}

	/**
	 * Initializes this node's style
	 */
	virtual void InitializeStyle( class UUIStyle* CurrentStyle )=0;

	/**
	 * Return the text style for this node.
	 */
	virtual class UUIStyle_Text* GetTextStyle() const
	{
		return NULL;
	}

	/**
	 * Return the image style for this node.
	 */
	virtual class UUIStyle_Image* GetImageStyle() const
	{
		return NULL;
	}

	/**
	 * Calculates the precise extent of this text node, and assigns the result to UITextNode::Extent
	 */
	virtual void CalculateExtent()=0;

	/**
	 * Returns the value of this UIStringNode
	 *
	 * @param	bProcessedValue		indicates whether the raw or processed version of the value is desired
	 *								The raw value will contain any markup; the processed string will be text only.
	 *								Any image tokens are converted to their text counterpart.
	 *
	 * @return	the value of this UIStringNode, or NULL if this node has no value
	 */
	virtual const TCHAR* GetValue( UBOOL bProcessedValue )
	{
		if ( !bProcessedValue )
		{
			return SourceText.Len() ? *SourceText : NULL;
		}

		return NULL;
	}

	/**
	 * Renders this UIStringNode using the parameters specified.
	 *
	 * @param	RI			the FRenderInterface to use for rendering this node
	 * @param	Parameters	the bounds for the region that this node should render to
	 *						the Scaling value of Parameters will be applied against the Scaling
	 *						value for this node.  The DrawXL/YL of the Parameters are used to
	 *						determine whether this node has enough room to render itself completely.
	 */
	virtual void Render_Node( struct FRenderInterface* RI, const struct FRenderParameters& Parameters)=0;

	// UObject interface.
	/**
	 * Callback used to allow object register its direct object references that are not already covered by
	 * the token stream.
	 *
	 * @param Owner			the UIString that owns this node.  used to provide access to UObject::AddReferencedObject
	 * @param ObjectArray	array to add referenced objects to via AddReferencedObject
	 */
	virtual void AddReferencedObjects( class UUIString* Owner, TArray<UObject*>& Objects )=0;

	/** Serializers */
	friend FArchive& operator<<( FArchive& Ar, FUIStringNode& StringNode)
    {
    	Ar << StringNode.SourceText << StringNode.Extent << StringNode.Scaling;
    	StringNode.Serialize(Ar);
    	return Ar;
    }
	virtual void Serialize( FArchive& Ar )=0;

    }

    var() string SourceText;
    var() Vector2D Extent;
    var() Vector2D Scaling;

    structdefaultproperties
    {
        SourceText=""
        Extent=(X=0.0000000,Y=0.0000000)
        Scaling=(X=0.0000000,Y=0.0000000)
    }
};

struct UIStringNode_Text extends UIStringNode
{
    structcpptext
    {

	FUIStringNode_Text( const TCHAR* inSourceText )
	: FUIStringNode(inSourceText), NodeStyle(NULL)
	{}

	/**
	 * Initializes this node's style
	 */
	virtual void InitializeStyle( class UUIStyle* CurrentStyle );

	/**
	 * Return the text style for this node.
	 */
	virtual class UUIStyle_Text* GetTextStyle() const;

	/**
	 * Calculates the precise extent of this text node, and assigns the result to UITextNode::Extent
	 */
	virtual void CalculateExtent();

	/**
	 * Assigns the RenderedText to the value specified, and recalculates the extent for this node.
	 */
	void SetRenderText( const TCHAR* NewRenderText );

	/**
	 * Returns the value of this UIStringNode
	 *
	 * @param	bProcessedValue		indicates whether the raw or processed version of the value is desired
	 *								The raw value will contain any markup; the processed string will be text only.
	 *								Any image tokens are converted to their text counterpart.
	 *
	 * @return	the value of this UIStringNode, or NULL if this node has no value
	 */
	virtual const TCHAR* GetValue( UBOOL bProcessedValue )
	{
		if ( bProcessedValue )
		{
			return RenderedText.Len() ? *RenderedText : NULL;
		}
		else
		{
			return FUIStringNode::GetValue(bProcessedValue);
		}
	}

	/**
	 * Renders this UIStringNode using the parameters specified.
	 *
	 * @param	RI			the FRenderInterface to use for rendering this node
	 * @param	Parameters	the bounds for the region that this node should render to
	 *						the Scaling value of Parameters will be applied against the Scaling
	 *						value for this node.  The DrawXL/YL of the Parameters are used to
	 *						determine whether this node has enough room to render itself completely.
	 */
	virtual void Render_Node( struct FRenderInterface* RI, const struct FRenderParameters& Parameters);

	// UObject interface
	/**
	 * Callback used to allow object register its direct object references that are not already covered by
	 * the token stream.
	 *
	 * @param Owner			the UIString that owns this node.  used to provide access to UObject::AddReferencedObject
	 * @param ObjectArray	array to add referenced objects to via AddReferencedObject
	 */
	virtual void AddReferencedObjects( class UUIString* Owner, TArray<UObject*>& Objects );

	/**
	 * Serializer
	 */
	virtual void Serialize( FArchive& Ar )
	{
		Ar << RenderedText << (UObject*&)NodeStyle;
	}

    }

    var() string RenderedText;
    var() UIStyle_Text NodeStyle;

    structdefaultproperties
    {
        Scaling=(X=0.0000000,Y=0.0000000)
    }
};

struct UIStringNode_Image extends UIStringNode
{
    structcpptext
    {

	FUIStringNode_Image( const TCHAR* inSourceText )
	: FUIStringNode(inSourceText), RenderedImage(NULL)
	{}

	/**
	 * Initializes this node's style
	 */
	virtual void InitializeStyle( class UUIStyle* CurrentStyle );

	/**
	 * Return the image style for this node.
	 */
	virtual class UUIStyle_Image* GetImageStyle() const;

	/**
	 * Calculates the precise extent of this text node, and assigns the result to UITextNode::Extent
	 */
	virtual void CalculateExtent();

	/**
	 * Renders this UIStringNode using the parameters specified.
	 *
	 * @param	RI			the FRenderInterface to use for rendering this node
	 * @param	Parameters	the bounds for the region that this node should render to
	 *						the Scaling value of Parameters will be applied against the Scaling
	 *						value for this node.  The DrawXL/YL of the Parameters are used to
	 *						determine whether this node has enough room to render itself completely.
	 */
	virtual void Render_Node( struct FRenderInterface* RI, const struct FRenderParameters& Parameters);

	// UObject interface
	/**
	 * Callback used to allow object register its direct object references that are not already covered by
	 * the token stream.
	 *
	 * @param Owner			the UIString that owns this node.  used to provide access to UObject::AddReferencedObject
	 * @param ObjectArray	array to add referenced objects to via AddReferencedObject
	 */
	virtual void AddReferencedObjects( class UUIString* Owner, TArray<UObject*>& Objects );

	/**
	 * Serializer
	 */
	virtual void Serialize( FArchive& Ar )
	{
		Ar << (UObject*&)RenderedImage;
	}

    }

    var() UITexture RenderedImage;

    structdefaultproperties
    {
        Scaling=(X=0.0000000,Y=0.0000000)
    }
};
