Class {
	#name : #TagGridModelPub,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #TagGrid
}

{ #category : #accessing }
TagGridModelPub >> addItem: aTGItem [ 
	items
		add: aTGItem 

]

{ #category : #accessing }
TagGridModelPub >> addTag: aTag toItemWith: aUuid [
	| anItem |
	anItem := self getItemWithUuid: aUuid.
	anItem
		ifNotNil: [ (anItem third includes: aTag) ifFalse: [ anItem third add: aTag ] ]
]

{ #category : #accessing }
TagGridModelPub >> allItemsWithTags: aTagList [

^items select:[:i|i third includesAny: aTagList]

]

{ #category : #accessing }
TagGridModelPub >> getItemWithUuid: aUuid [

^ items detect: [:i| i first = aUuid] ifFound: [:i | i] ifNone: [nil]
]

{ #category : #accessing }
TagGridModelPub >> initialize [

items := OrderedCollection new.
]

{ #category : #accessing }
TagGridModelPub >> items [

	^ items
]

{ #category : #accessing }
TagGridModelPub >> items: anObject [

	items := anObject
]

{ #category : #accessing }
TagGridModelPub >> removeItem: aUUID [
	| anItem |
	anItem := self getItemWithUuid: aUUID.
	anItem ifNotNil: [ items remove: anItem ]
]

{ #category : #accessing }
TagGridModelPub >> removeTag: aTag fromItemWith: aUuID [
	| anItem |
	anItem := self getItemWithUuid: aUuID.
	anItem ifNotNil: [ anItem third remove: aTag ifAbsent: [  ] ]
]
