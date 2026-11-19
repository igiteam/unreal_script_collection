/**
 * Specific derivation of UIDataStore to expose downloadable content data to the UI.
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMUIDataStore_Content extends UIDataStore
	native(inherit)
	implements(UIListElementProvider)
	transient;

/** Reference to the dataprovider that will provide general stats details for a stats row. */
var transient TMUIDataProvider_InstalledContent InstalledContentProvider;

/** Reference to the dataprovider that will provide content that is available for download. */
var transient TMUIDataProvider_AvailableContent AvailableContentProvider;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** 
 * @param FieldName		Name of the field to return the provider for.
 *
 * @return Returns a stats element provider given its field name. 
 */
event TMUIDataProvider_SimpleElementProvider GetElementProviderFromName(name FieldName)
{
	if(FieldName=='AvailableContent')
	{
		return AvailableContentProvider;
	}
	else if(FieldName=='InstalledContent')
	{
		return InstalledContentProvider;
	}

	return None;
}

