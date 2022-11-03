Class {
	#name : #TagGridItemPub,
	#superclass : #Object,
	#instVars : [
		'uid',
		'model',
		'tags',
		'snippetUid'
	],
	#category : #TagGrid
}

{ #category : #accessing }
TagGridItemPub >> addExclusiveTag: aTag from: aTagList [

	(aTagList reject: [ :t | t = aTag ])
		do: [ :r | (self tags includes: r) ifTrue: [ self tags remove: r ] ].
	(self tags includes: aTag) ifFalse:[ self tags add: aTag]
]

{ #category : #accessing }
TagGridItemPub >> description [
^ model asString
]

{ #category : #accessing }
TagGridItemPub >> first [ 

^uid
]

{ #category : #accessing }
TagGridItemPub >> initialize [
uid :=  UUIDGenerator next asString.
tags := OrderedCollection new.
]

{ #category : #accessing }
TagGridItemPub >> model [

	^ model
]

{ #category : #accessing }
TagGridItemPub >> model: anObject [

	model := anObject
]

{ #category : #accessing }
TagGridItemPub >> second [ 
^ self description
]

{ #category : #accessing }
TagGridItemPub >> snippetUid [

	^ snippetUid
]

{ #category : #accessing }
TagGridItemPub >> snippetUid: anObject [

	snippetUid := anObject
]

{ #category : #accessing }
TagGridItemPub >> tags [

	^ tags
]

{ #category : #accessing }
TagGridItemPub >> tags: anObject [

	tags := anObject
]

{ #category : #accessing }
TagGridItemPub >> third [ 

^ tags
]

{ #category : #accessing }
TagGridItemPub >> uid [

	^ uid
]

{ #category : #accessing }
TagGridItemPub >> uid: anObject [

	uid := anObject
]
