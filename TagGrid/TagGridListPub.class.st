Class {
	#name : #TagGridListPub,
	#superclass : #TagGridPub,
	#instVars : [
		'lists'
	],
	#category : #TagGrid
}

{ #category : #accessing }
TagGridListPub >> createCell: aTag as: aSymbol [
	^ BrVerticalPane new
		addChild: (BrVerticalPane new
				border: (BlBorder paint: Color lightGray width: 1);
				hMatchParent; vFitContent;
				alignCenter;
				addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude new bold;
							text: aTag asRopedText;
							margin: (BlInsets top: 2))
					as: aSymbol);
		addChild: (BrVerticalPane new addChild:((lists at: (tags indexOf: aTag)) margin: (BlInsets all: 3))
			as: aSymbol , 'List';border: (BlBorder paint: Color lightGray width: 1);matchParent);matchParent
]

{ #category : #accessing }
TagGridListPub >> draw: anInteger [
	| aList listItems pListItems |
	aList := lists at: anInteger.
	pListItems := aList items.

	anInteger = 5
		ifTrue: [ listItems := (self items items
					reject: [ :each | (self items allItemsWithTags: displayedTags) includes: each ])
					collect: [ :each | self itemElementFor: each ] ]
		ifFalse: [ listItems := (self items
					allItemsWithTags: {displayedTags at: anInteger})
					collect: [ :each | self itemElementFor: each ] ].
	listItems
		ifNotEmpty: [ aList items: (listItems sorted: [ :a :b | a text asString < b text asString ]) ]
		ifEmpty: [ pListItems ifNotEmpty: [ aList items: listItems ] ].
	self refreshGridUsingResizer
]

{ #category : #accessing }
TagGridListPub >> initialize [
	super initialize.
	lists := (1 to: 5)
			collect: [ :l | 
				BrGridList new
					items: OrderedCollection new;
					stencil: [ :each | each ] ].
	lists fifth aptitude columnCount: 4.

	rows := {self rowOne.
			self rowTwo.
			self rowThree}.

	self buildGrid
]

{ #category : #accessing }
TagGridListPub >> removeSelectedItem [
	selectedItem
		ifNotNil: [ self items items
				detect: [ :i | i first = (selectedItem userData at: #itemUuid) ]
				ifFound: [ :itemToRemove | 
					self items removeItem: itemToRemove first.
					selectedItem
						topMostParentSuchThat: [ :p | p isKindOf: BrGridList ]
						ifFound: [ :p | self draw: (lists indexOf: p) ]
						ifNone: [  ] ] ]
]

{ #category : #accessing }
TagGridListPub >> rowOne [
	| row rChildren |
	row := BrHorizontalPane new
			border: (BlBorder paint: Color lightGray width: 1);
			matchParent;
			alignTopCenter.
	rChildren := tags size > 1
			ifTrue: [ {self createCell: tags first as:#oneTag "color: (Color lightRed )".
					self createCell: tags second  as:#twoTag }]
			ifFalse: [ {self createCell: 'Tag One' as:#oneTag" color: (Color lightRed )".
					self createCell: 'Tag Two'as:#twoTag } ].
	row
		addChildren: {rChildren first.
				self hResizerFor: rChildren second.
				rChildren second}.
	^ row
]

{ #category : #accessing }
TagGridListPub >> rowThree [
	| row |
	row := BrHorizontalPane new
			border: (BlBorder paint: Color lightGray width: 1);
			matchParent;
			alignTopCenter.

	row
		addChild: (self createCell: 'Everything else' as: #fiveTag).
	^ row
]

{ #category : #accessing }
TagGridListPub >> rowTwo [
	| row rChildren |
 row := BrHorizontalPane new
		border: (BlBorder paint: Color lightGray width: 1);
		matchParent;
		alignTopCenter.
		rChildren := tags size > 3
			ifTrue: [ {self createCell: tags third as:#threeTag .
					self createCell: tags fourth as:#fourTag} ]
			ifFalse: [ {self createCell: 'Tag Three'  as:#threeTag.
					self createCell: 'Tag Four'as:#fourTag} ].
	row
		addChildren: {rChildren first.
				self hResizerFor: rChildren second.
				rChildren second}.
	^ row
		

]
