/**
 * Class: GUDToC
 * GUD table of contents.
 * Used by the GUDManager to handle split banks for characters.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GUDToC extends Object
	dependson(GUDTypes)
	native(Sound);


struct native GUDToCEntry
{
	/** */
	var transient init native string	BankName;
	/** Approximate bank memory size, in bytes. */
	var transient init int				ApproxBankSize;
	var transient GUDLoadFlags          LoadFlags;

	structcpptext
	{
		UBOOL operator==(const FGUDToCEntry& Other) const
		{
			return BankName == Other.BankName;
		}

		virtual void Serialize(FArchive& Ar)
		{
			Ar << BankName;
			Ar << ApproxBankSize;
			Ar << LoadFlags.bLoadInMP;
			Ar << LoadFlags.bLoadInSP;
			Ar << LoadFlags.bLoadInHorde;
			Ar << LoadFlags.bLoadInSiege;
		}

		friend FArchive& operator<<(FArchive& Ar, FGUDToCEntry& Entry)
		{
			return Ar << Entry.BankName << Entry.ApproxBankSize << Entry.LoadFlags.bLoadInMP << Entry.LoadFlags.bLoadInSP << Entry.LoadFlags.bLoadInHorde << Entry.LoadFlags.bLoadInSiege;
		}
	}
};

/** 
 *	Struct that holds the information on the break-up/cooked GUDBank.
 */
struct native GUDCollection
{
	/** The root GUD bank. */
	var transient init native GUDToCEntry			RootGUDBank;
	/** The GameType specific GUD banks. */
	var transient init native array<GUDToCEntry>	GameRootGUDBanks;
	/** The 'variety' GUD banks. */
	var transient init native array<GUDToCEntry>	GUDBanks;
	
	structcpptext
	{
		virtual void Serialize(FArchive& Ar)
		{
			Ar << RootGUDBank;
			Ar << GameRootGUDBanks;
			Ar << GUDBanks;
		}

		friend FArchive& operator<<(FArchive& Ar, FGUDCollection& Collection)
		{
			return Ar << Collection.RootGUDBank << Collection.GameRootGUDBanks << Collection.GUDBanks;
		}
	}
};

/**
 *	Maps the GUDBank name to the list of bank packages that it was broken up into.
 */ 
var transient native Map_Mirror		TableOfContents{TMap<FString,FGUDCollection>};

cpptext
{
public:
	static FString ToCPackageName;
	static FName ToCObjectName;

	virtual void AddReferencedObjects( TArray<UObject*>& ObjectArray );
	virtual void Serialize(FArchive& Ar);
}

defaultproperties
{
}
