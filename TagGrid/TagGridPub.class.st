Class {
	#name : #TagGridPub,
	#superclass : #BrVerticalPane,
	#instVars : [
		'tags',
		'items',
		'currentTag',
		'title',
		'rows',
		'selectedItem',
		'displayedTags',
		'currentStatus',
		'note'
	],
	#category : #TagGrid
}

{ #category : #accessing }
TagGridPub >> addItemElement [
	| anEditor |
	anEditor := BrEditor new
			aptitude: BrGlamorousInputFieldSpacingAptitude
					+ (BrGlamorousWithLabelTooltipAptitude new
							text: 'Press Ctrl-S to send item to grid');
			margin: (BlInsets
					left: 5;
					right: 5);
			hExact: 200.
	anEditor editor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryS;
				action: [ :aShortcutEvent | 
					self items
						addItem: (TagGridItemPub new
								model: aShortcutEvent currentTarget editor text asString;
								tags: {self currentTag.
										currentStatus} asOrderedCollection).
					self refreshGrid ]).
	^ BrHorizontalPane new
		addChild: anEditor;
		addChild: self displayedTagSelector;
		hMatchParent
]

{ #category : #accessing }
TagGridPub >> addStateTag: aTag to: anItem [
	anItem addExclusiveTag: aTag from: self stateTags.
	selectedItem text highlight: (self stateColor: anItem tags)
]

{ #category : #accessing }
TagGridPub >> buildDisplayedTagsElement [
	| button1 button2 aWithDropdownAptitude |
	button1 := BrButton new
			icon: BrGlamorousIcons threepanes;
			aptitude: BrGlamorousButtonWithIconCircularAptitude;
			margin: (BlInsets left: 5 right: 5).

	button2 := BrButton new
			icon: BrGlamorousIcons threepanes;
			aptitude: BrGlamorousButtonWithIconCircularAptitude;
			margin: (BlInsets left: 5 right: 5).
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [ self buildDisplayedTagsSelector ]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].

	^ button1
		aptitude: button1 aptitude + aWithDropdownAptitude
				+ (BrGlamorousWithLabelTooltipAptitude new text: 'Change displayed tags');
		yourself
]

{ #category : #accessing }
TagGridPub >> buildDisplayedTagsSelector [
	| dTagPane |
	dTagPane := BrVerticalPane new size: 200 @ 100.
	displayedTags
		do: [ :t | 
			dTagPane
				addChild: (self buildDisplayedTagsSelectorFor: (displayedTags indexOf: t)) ].
	^ dTagPane
]

{ #category : #accessing }
TagGridPub >> buildDisplayedTagsSelectorFor: anInteger [
	| button1 button2 aWithDropdownAptitude |
	button1 := BrButton new
			geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
			label: (displayedTags at: anInteger).
	button2 := BrButton new
			label: (displayedTags at: anInteger);
			aptitude: BrGlamorousButtonWithLabelAptitude.
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [ BrVerticalPane new
					fitContent;
					addChild: (BrSimpleList new
							stencil: [ :aTag | 
								BrButton new
									label: aTag;
									aptitude: BrGlamorousButtonWithLabelAptitude + BrGlamorousButtonFlatExteriorAptitude;
									action: [ button1 label: aTag asRopedText.
										button2 label: aTag asRopedText.
										displayedTags at: anInteger put: aTag.
										(self child: (anInteger asWords , 'Tag') asSymbol) text: aTag.
										self draw: anInteger.
										self draw: 5.
										aWithDropdownAptitude hide ] ];
							items: self tags sorted , self stateTags sorted;
							matchParent;
							yourself) ]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].
	^ button1
		aptitude: BrGlamorousButtonWithLabelAptitude + aWithDropdownAptitude;
		yourself
]

{ #category : #accessing }
TagGridPub >> buildGrid [
	self
		addChildren: {self title.
				rows first.
				self vResizerFor: rows second.
				rows second.
				self vResizerFor: rows third.
				rows third}
]

{ #category : #accessing }
TagGridPub >> buildInspectTagsButton [
	| button1 button2 aWithDropdownAptitude |
	button1 := BrButton new
			margin: (BlInsets left: 5 right: 5);
			label: 'Inspect specific tags';
			icon: BrGlamorousIcons inspect;
			aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousButtonCircularAptitude.

	button2 := BrButton new
			margin: (BlInsets left: 5 right: 5);
			label: 'Inspect specific tags';
			icon: BrGlamorousIcons inspect;
			aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousButtonCircularAptitude.
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [ self buildInspectTagsElement ]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].

	^ button1
		aptitude: button1 aptitude + aWithDropdownAptitude;
		yourself
]

{ #category : #accessing }
TagGridPub >> buildInspectTagsElement [
	| tagList iTagList |
	iTagList := OrderedCollection new.
	^ BrVerticalPane new
		exact: 150 @ 150;
		addChild: (tagList := BrSimpleList new
					border: (BlBorder paint: Color lightGray width: 1);
					items: self tags sorted , self stateTags sorted;
					stencil: [ :each | 
						| aTagEditor |
						aTagEditor := BrEditableLabel new
								hMatchParent;
								aptitude: BrGlamorousEditableLabelAptitude;
								text: each asString;
								when: BrEditorAcceptWish
									do: [ :wish | tags at: (self tags indexOf: each) put: wish text asString ].
						BrHorizontalPane new
							alignCenter;
							fitContent;
							margin: (BlInsets
									left: 5;
									top: 2 bottom: 2);
							addChildren: {BrCheckbox new
										checked: (iTagList includes: each);
										whenCheckedDo: [ iTagList add: each ];
										whenUncheckedDo: [ iTagList remove: each ifAbsent: [  ] ];
										aptitude: BrGlamorousCheckboxAptitude;
										margin: (BlInsets right: 5).
									aTagEditor} ]);
		addChild: (BrButton new
				aptitude: BrGlamorousButtonWithLabelAptitude; 
				margin: (BlInsets all: 5);
				label: 'Inspect';
				action: [ self phlow
						spawnObject: (TagGridListPub new
								titleText: 'Part of ' , self titleText;
								tags: self tags;
								items: (TagGridModelPub new items: (self items allItemsWithTags: iTagList))) ])
]

{ #category : #accessing }
TagGridPub >> buildItemContextElement: cMAptitude [
	| addTagEditor tagList |
	addTagEditor := BrEditableLabel new
			aptitude: BrGlamorousEditableLabelAptitude
					+ (BrGlamorousWithLabelTooltipAptitude new text: 'New Tag');
			margin: (BlInsets
					top: 1;
					bottom: 3;
					left: 2;
					right: 5);
			when: BrEditorAcceptWish
				do: [ :wish | 
					tags add: wish text asString.
					tagList items: self tags sorted ];
			matchParent.

	^ BrVerticalPane new
		exact: 200 @ 200;
		addChild: (tagList := BrSimpleList new
					border: (BlBorder paint: Color lightGray width: 1);
					items: self tags sorted;
					stencil: [ :each | 
						| aTagEditor iUuid |
						selectedItem := cMAptitude widget.
						iUuid := selectedItem userData at: #itemUuid.
						aTagEditor := BrEditableLabel new
								hMatchParent;
								aptitude: BrGlamorousEditableLabelAptitude;
								text: each asString;
								when: BrEditorAcceptWish
									do: [ :wish | tags at: (self tags indexOf: each) put: wish text asString ].
						BrHorizontalPane new
							alignCenter;
							fitContent;
							margin: (BlInsets
									left: 5;
									top: 2 bottom: 5);
							addChildren: {BrCheckbox new
										checked: (self items items
												detect: [ :i | i first = iUuid ]
												ifFound: [ :i | i third includes: each ]
												ifNone: [ false ]);
										whenCheckedDo: [ self items addTag: each toItemWith: iUuid.
											self refreshGrid ];
										whenUncheckedDo: [ self items removeTag: each fromItemWith: iUuid.
											self refreshGrid ];
										aptitude: BrGlamorousCheckboxAptitude;
										margin: (BlInsets right: 5).
									aTagEditor} ]);
		addChild: (BrHorizontalPane new
				margin: (BlInsets all: 4);
				hMatchParent;
				vFitContent;
				addChild: addTagEditor;
				addChild: (BrButton new
						aptitude: BrGlamorousButtonWithIconCircularAptitude;
						icon: BrGlamorousIcons remove;
						margin: (BlInsets
								left: 20;
								right: 0);
						label: 'Remove item';
						action: [ self removeSelectedItem.
							cMAptitude hide.
							self refreshGrid ]))
]

{ #category : #accessing }
TagGridPub >> buildLoadButton [
	| button1 button2 aWithDropdownAptitude |
	button1 := (BrButton new
				margin: (BlInsets left: 5 right: 5);
				label: 'Load';
				icon: BrGlamorousIcons open;
				aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousButtonCircularAptitude).

	button2 :=(BrButton new
				margin: (BlInsets left: 5 right: 5);
				label: 'Load';
						icon: BrGlamorousIcons open;
				aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousButtonCircularAptitude).
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [self buildLoadFileSelector]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].

	^ button1
		aptitude: button1 aptitude + aWithDropdownAptitude;
		yourself				
]

{ #category : #accessing }
TagGridPub >> buildLoadFileSelector [
	| lButton location |
	location := self defaultFileLocation.
	lButton := BrButton new
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: 'Load';
			margin: (BlInsets
					left: 20;
					right: 5).

	^ BrVerticalPane new
		addChild: (BrFileSelector new
				folder: self defaultFileLocation;
				okAction: [ :path | self loadFromFile: path. self formatTitle];
				fileFilterBlock: [ :aFileRef | aFileRef extension = 'tgrid' ];
				buttonLabel: 'Load');
		size: 500 @ 300
]

{ #category : #accessing }
TagGridPub >> buildSaveButton [
	| button1 button2 aWithDropdownAptitude |
	button1 := (BrButton new
				margin: (BlInsets left: 5 right: 5);
				label: 'Save';
				icon: BrGlamorousIcons savetodisk;
				aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousButtonCircularAptitude).

	button2 :=(BrButton new
				margin: (BlInsets left: 5 right: 5);
				label: 'Save';
						icon: BrGlamorousIcons savetodisk;
				aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousButtonCircularAptitude).
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [self buildSaveFileSelector]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].

	^ button1
		aptitude: button1 aptitude + aWithDropdownAptitude;
		yourself				
]

{ #category : #accessing }
TagGridPub >> buildSaveFileSelector [
	| fNLabel fileName sButton location |
	location := self defaultFileLocation asString allButFirst:7.
	sButton := BrButton new
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: 'Save'; margin:(BlInsets left:20 ; right: 5);
			action: [ self saveToFile: ( location asString ,'\', title asString ,'.tgrid') asFileReference].
	fNLabel := BrLabel new
			text: 'File name: ';
			aptitude: BrGlamorousLabelAptitude.
	fileName := BrEditor new
			aptitude: BrGlamorousEditorAptitude + BrGlamorousInputFieldSpacingAptitude;
			text: title;
			margin: (BlInsets left: 5 right:20).
	fileName editor
		when: BrTextEditorModifiedEvent
		do: [ :evt | self titleText: evt currentTarget text ].
	^ BrVerticalPane new
		addChildren: {BrFileSelector new
					folder: self defaultFileLocation;
					okAction: [ :path | location := path ];
					fileFilterBlock: [ :aFileReference | 
						aFileReference isDirectory
							and: [ (FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ];
					buttonLabel: 'Select Folder'.
				BrHorizontalPane new
					addChildren: {fNLabel.
							fileName.
							sButton}; alignCenter;
					hMatchParent};
		size: 400 @ 300
]

{ #category : #accessing }
TagGridPub >> child: aSymbol [
	^ self
		allChildrenBreadthFirstDetect: [ :c |  c id asSymbol = aSymbol  ]
		ifFound: [ :c | c ]
]

{ #category : #accessing }
TagGridPub >> createCell: aTag as: aSymbol [
self subclassResponsibility
]

{ #category : #accessing }
TagGridPub >> createCell: aTag as: aSymbol color: aColor [
	^ BrVerticalPane new
		border: (BlBorder paint: Color lightGray width: 1);
		matchParent;
		alignTopCenter;
		addChild: (BrVerticalPane new
				fitContent;
				background: aColor;
				addChild: (BlTextElement new
							text: aTag asRopedText;
							margin: (BlInsets top: 5))
					as: aSymbol)
]

{ #category : #accessing }
TagGridPub >> createNote [
	| aPage |
	(LeDatabasesRegistry default defaultLogicalDatabase primaryDB
		hasPageNamed: self titleText)
		ifTrue: [ aPage := LeDatabasesRegistry default defaultLogicalDatabase primaryDB
					pageNamed: self titleText ]
		ifFalse: [ aPage := LePage named: self titleText.
			LeDatabasesRegistry default defaultLogicalDatabase primaryDB addPage: aPage ].

	note := aPage uid asString
]

{ #category : #accessing }
TagGridPub >> currentTag [ 
^ currentTag ifNil: ['Everything else'] ifNotNil: [currentTag]
]

{ #category : #accessing }
TagGridPub >> defaultFileLocation [

^ 'C:\TagGrids' asFileReference ensureCreateDirectory
]

{ #category : #accessing }
TagGridPub >> displayedTagSelector [
	| button1 button2 aWithDropdownAptitude tagList |
	button1 := BrButton new
			geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
			label: 'No tag selected'.
	button2 := BrButton new
			label: 'No tag selected';
			aptitude: BrGlamorousButtonWithLabelAptitude.
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [ BrVerticalPane new
					fitContent;
					addChild: (tagList := BrSimpleList new
								stencil: [ :aTag | 
									BrButton new
										label: aTag;
										aptitude: BrGlamorousButtonWithLabelAptitude + BrGlamorousButtonFlatExteriorAptitude;
										action: [ button1 label: aTag asRopedText.
											button2 label: aTag asRopedText.
											currentTag := aTag.
											aWithDropdownAptitude hide ] ];
								items: displayedTags,{'Everything else'};
								matchParent;
								yourself) ]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].
	^ button1
		aptitude: BrGlamorousButtonWithLabelAptitude + aWithDropdownAptitude;
		yourself
]

{ #category : #accessing }
TagGridPub >> draw: anInteger [
self subclassResponsibility
]

{ #category : #accessing }
TagGridPub >> formatTitle [
	^ (title truncate: 30) asRopedText
		fontSize: 15;
		bold
]

{ #category : #accessing }
TagGridPub >> gtString: aView [
	<gtView>
	^ aView explicit
		title: 'String';
		priority: 0;
		stencil: [ BrEditor new
				beReadOnlyWithSelection;
				text: self printWithTagsIndented asRopedText; 
				aptitude: BrGlamorousEditorAptitude;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ] ];
		actionUpdateButton
]

{ #category : #accessing }
TagGridPub >> hResizerFor: aCell [

^BrResizer new
		beLeft;
		target: aCell;
		aptitude: BrGlamorousResizerAptitude;
		when: BlResizerResizedEvent
			do: [ :anEvent | aCell width: anEvent extent x ].
]

{ #category : #accessing }
TagGridPub >> initialize [
	super initialize.
	self defaultFileLocation.
	title := 'Untitled'.
	note :=''.
	self
		tags: (OrderedCollection new
				addAll: {'Tag One'.
						'Tag Two'.
						'Tag Three'.
						'Tag Four'.
						'Everything else'}).
	items := TagGridModelPub new.
	self
		border: (BlBorder paint: Color lightGray width: 1);
		matchParent
]

{ #category : #accessing }
TagGridPub >> itemElementFor: anItem [
	| aShape cMAptitude |
	aShape := BrEditor new.
	cMAptitude := BrGlamorousWithContextMenuAptitude
			handle: [ BlElement new
					size: 5 @ 5;
					background: Color lightCyan;
					geometry: BlEllipseGeometry new ]
			content: [ self
					allChildrenBreadthFirstDetect: [ :c | 
						c userData
							at: #itemUuid
							ifPresent: [ true ]
							ifAbsent: [ false ] ]
					ifFound: [ :fChild | selectedItem := fChild ].
				self buildItemContextElement: cMAptitude ].

	aShape
		margin: (BlInsets all: 3);
		when: BlClickEvent do: [ :cE | selectedItem := cE currentTarget ];
		when: BlFocusOutEvent
			do: [ :anEvent | 
				anEvent consumed: true.
				anEvent currentTarget deselecter
					all;
					deselect.
				selectedItem := nil ];
		hFitContent;
		aptitude: BrEditorAptitude new + BrGlamorousInputFieldSpacingAptitude + cMAptitude;
		text: (anItem second asRopedText highlight: (self stateColor: anItem third)).
	aShape editor
		when: BrTextEditorModifiedEvent
		do: [ :evt | 
			self items items
				detect: [ :i | i first = (aShape userData at: #itemUuid) ]
				ifFound: [ :editedItem | editedItem model: evt currentTarget text asString ] ].
	aShape userData at: #itemUuid put: anItem first.
	^ aShape
]

{ #category : #accessing }
TagGridPub >> items [

^ items
]

{ #category : #accessing }
TagGridPub >> items: aTagGridModelPub [
	(aTagGridModelPub isKindOf: TagGridModelPub)
		ifTrue: [ items := aTagGridModelPub.
			self refreshGrid ]
		ifFalse: [ self inform: 'Invalid TagGrid Model. Items not changed' ]
]

{ #category : #accessing }
TagGridPub >> loadFromFile: aFileRef [
	| fileContents |
	fileContents := STON fromString: aFileRef contents.
	self titleText: fileContents first.
	fileContents size > 2 ifTrue: [ self tags: fileContents third ]."Set up tags before items to prevent errors"
	self items: fileContents second.
	fileContents size > 3
		ifTrue: [ note := fileContents fourth ]
		ifFalse: [ note := '' ]
]

{ #category : #accessing }
TagGridPub >> printWithTagsIndented [
	^ ((self items items flatCollect: [ :i | i tags ])reject: [:t| t isNil]) removeDuplicates sorted
		inject: ''
		into: [ :all :t | 
			all , t , String cr
				, ((self items items select: [ :subItem | subItem tags includes: t ])
						inject: ''
						into: [ :allSel :subItem | 
							String tab
								, (subItem description lines inject: '' into: [ :sAll :sEach | sAll ,' ', sEach ])
								, String cr , allSel ]) , String cr ]
]

{ #category : #accessing }
TagGridPub >> refreshCurrentTag [
]

{ #category : #accessing }
TagGridPub >> refreshDiagram: aSymbol [
	| diag |
	diag := self
			allChildrenBreadthFirstDetect: [ :c | c id asString = aSymbol ]
			ifFound: [ :c | c ].
	diag
		ifNotNil: [ diag root removeAllChildren.
			self items ]
]

{ #category : #accessing }
TagGridPub >> refreshGrid [
	1
		to: 5
		do: [ :aCell | 
			self
				enqueueTask: (BlDelayedTaskAction new
						delay: 0;
						action: [ self draw: aCell ]) ]
]

{ #category : #accessing }
TagGridPub >> refreshGridUsingResizer [
	(self child: #resizer) height: 1.
	(self child: #resizer) height:3
]

{ #category : #accessing }
TagGridPub >> removeSelectedItem [

self subclassResponsibility.

]

{ #category : #accessing }
TagGridPub >> rowOne [
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
TagGridPub >> rowThree [
	| row |
	row := BrHorizontalPane new
			border: (BlBorder paint: Color lightGray width: 1);
			matchParent;
			alignTopCenter.

	row
		addChild: 
				 (self createCell: 'Everything else' as: #fiveTag ).
	^ row
]

{ #category : #accessing }
TagGridPub >> rowTwo [
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

{ #category : #accessing }
TagGridPub >> save [
	^ STON
		toString: {self titleText.
				self items.
				self tags.
				note}
]

{ #category : #accessing }
TagGridPub >> saveToFile [
	self defaultFileLocation , '\' , self titleText , '.tgrid' asFileReference
		writeStreamDo: [ :st | st nextPutAll: self save ]
]

{ #category : #accessing }
TagGridPub >> saveToFile: aFileReference [

aFileReference writeStreamDo: [ :st | st nextPutAll: self save ] 
]

{ #category : #accessing }
TagGridPub >> stateColor: aTagList [
	(aTagList includesAny: self stateTags)
		ifTrue: [ aTagList
				detect: [ :t | self stateTags includes: t ]
				ifFound: [ :t | ^(self stateColors at: t) alpha:0.2 ] ]
		ifFalse: [ ^ Color transparent ]
]

{ #category : #accessing }
TagGridPub >> stateColors [
	^ Dictionary
		newFromPairs: {'Not started'.
				Color white.
				'On hold'.
				Color lightGray.
				'In progress'.
				Color yellow.
				'Done'.
				Color green.
				'Overdue'.
				Color red}
]

{ #category : #accessing }
TagGridPub >> stateTagSelector [
	| button1 button2 aWithDropdownAptitude |
	button1 := BrButton new
			geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
			label: 'Not started'.
	button2 := BrButton new
			label: 'Not started';
			aptitude: BrGlamorousButtonWithLabelAptitude;
			hFitContent.
	aWithDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ button2 ]
			content: [ BrSimpleList new
					stencil: [ :aTag | 
						BrButton new
							label: aTag;
							aptitude: BrGlamorousButtonWithLabelAptitude + BrGlamorousButtonFlatExteriorAptitude;
							action: [ button1 label: aTag asRopedText.
								button2 label: aTag asRopedText.
								currentStatus := aTag.
								selectedItem ifNotNil: [ self addStateTag: aTag to: selectedItem ]. self refreshGrid.
								aWithDropdownAptitude hide ] ];
					items: self stateTags;
					fitContent;
					yourself ]
			aptitudeDo: [ :aDropdownLook | aDropdownLook cornerRadius: 5 ].
currentStatus := 'Not started'.
	^ button1
		aptitude: BrGlamorousButtonWithLabelAptitude + aWithDropdownAptitude;
		yourself
]

{ #category : #accessing }
TagGridPub >> stateTags [
^ {'On hold'.  'Not started'.  'In progress'.  'Done'. 'Overdue'}asOrderedCollection
]

{ #category : #accessing }
TagGridPub >> tags [

	^ tags
]

{ #category : #accessing }
TagGridPub >> tags: aCollection [
"Assumes at least 4 tags in the collection. If less than 4 the tags are not replaced"

	aCollection size >= 4
		ifTrue: [ tags := aCollection asOrderedCollection.
			displayedTags := tags copyFrom: 1 to: 4.

			1
				to: 4
				do: [ :i | 
					self
						allChildrenBreadthFirstDetect: [ :c | c id asString = ('#' , (i asWords , 'Tag')) ]
						ifFound: [ :c | c text: (tags at: i) asRopedText ] ] ]
]

{ #category : #accessing }
TagGridPub >> title [
	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		margin: (BlInsets
				left: 3;
				right: 3);
		alignCenter;
		addChild: (BlTextElement new
				text: self formatTitle;
				id: #title;
				margin: (BlInsets
						left: 5;
						right: 5));
		addChild: (BrSimpleList new
				beHorizontal;
				vFitContent;
				hMatchParent;
				margin: (BlInsets all: 3);
				stencil: [ :each | each ];
				items: {self buildSaveButton.
						self buildLoadButton.
						self addItemElement
							fitContent;
							margin: (BlInsets left: 5 right: 5).
						self stateTagSelector
							fitContent;
							margin: (BlInsets left: 5 right: 5).
						BrButton new
							icon: BrGlamorousIcons refresh;
							label: 'Refresh grid';
							aptitude: BrGlamorousButtonWithIconCircularAptitude;
							action: [ self refreshGrid ];
							margin: (BlInsets left: 5 right: 5).
						BrButton new
							icon: BrGlamorousVectorIcons note;
							label: 'View note';
							action: [ note ifEmpty: [ self createNote ].
								self viewNote ];
							aptitude: BrGlamorousButtonWithIconCircularAptitude;
							margin: (BlInsets left: 5 right: 5).
						self buildDisplayedTagsElement.
						self buildInspectTagsButton})
]

{ #category : #accessing }
TagGridPub >> titleText [
^title
]

{ #category : #accessing }
TagGridPub >> titleText: aString [
title := aString asString.	self
		allChildrenBreadthFirstDetect: [ :c | c id asString = '#title' ]
		ifFound: [ :c | c text: self formatTitle  ]
]

{ #category : #accessing }
TagGridPub >> vResizerFor: aRow [

^BrResizer new
		beTop;
		target: aRow;
		id:(BlElementId named: #resizer);
		aptitude: BrGlamorousResizerAptitude;
		when: BlResizerResizedEvent
			do: [ :anEvent | aRow height: anEvent extent y ].
]

{ #category : #accessing }
TagGridPub >> viewNote [
	note isEmptyOrNil
		ifFalse: [ LeDatabasesRegistry default defaultLogicalDatabase primaryDB
				pageWithID: (UUID fromString: note)
				ifPresent: [ :aPage | self phlow spawnObject: aPage ]
				ifAbsent: [  ] ]
]
