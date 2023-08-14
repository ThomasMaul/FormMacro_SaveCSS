/* CSS helper macro
CSS is a very powerful format
but often it is used only for simple style sheetes

This macro helps for simple style sheets. You can store a CSS format such as red bold unterlined

This macro is totally useless if you use all power of CSS, it even might destroy complex CSS documents.
It does not support "cascaded".
It does not support selectors, such as buttons with title OK
it does not support media selectors
just to name some

see https://developer.4d.com/docs/FormEditor/stylesheets#class
"Specific attributes" for examples

If you use complex CSS, don't use this macro

*/


Function onInvoke($editor : Object)->$result : Object
	$old:=Method called on error:C704(ek global:K92:2)
	ON ERR CALL:C155(""; ek global:K92:2)
	
	
	var $name : Text
	
	If ($editor.editor.currentSelection.length#1)
		ALERT:C41("Please, select ONE form object.")
		
	Else 
		$object:=New object:C1471("name"; "")
		$object.CSSStorage:={values: ["Generic"; "Mac"; "Windows"]; index: 0}
		$object.CSSType:={values: ["CSS Class"; "Object Type"; "Object Name"]; index: 0}
		$object.preview:=New object:C1471
		
		$filter:=["$4dId"; "dataSource"; "dataSourceTypeHint"; "events"; "height"; "left"; "top"; "width"; "height"; "type"; "text"; "method"]
		
		$copy:=$editor.editor.currentPage.objects[$editor.editor.currentSelection[0]]
		For each ($attr; $copy)
			If ($filter.indexOf($attr)<0)
				$object.preview[$attr]:=$copy[$attr]
			End if 
		End for each 
		
		$object.objecttype:=$copy.type
		$object.objectname:=$editor.editor.currentSelection[0]
		
		$win:=Open form window:C675("CSS_Macro")
		DIALOG:C40("CSS_Macro"; $object)
		CLOSE WINDOW:C154($win)
		
		ON ERR CALL:C155($old; ek global:K92:2)
		
		
	End if 