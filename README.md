### Introduction
	TagGrid can be used to enter text items and then tag them.  
	You can display and inspect items by tags
	![image](https://github.com/majella67/TagGrid/blob/ce4e8f4ae63d2978a26e44f5dd0f633111532c08/Taggrid.png)

	
### Installation 

Download GlamorousToolkit [here](https://gtoolkit.com/download/).

Open a playground, copy the code below into and execute.

```Smalltalk
Metacello new
	baseline: 'TagGrid';
	repository: 'github://majella67/TagGrid:main/src';
	load.
```

Open a tag grid using the code below in a playground and inspect.

```Smalltalk
aTGL :=TagGridListPub new 
```
