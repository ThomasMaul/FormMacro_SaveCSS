var $css : 4D:C1709.File
Case of 
	: (Form:C1466.CSSStorage.index=0)  // generic
		$css:=Folder:C1567("/SOURCES").file("styleSheets.css")
	: (Form:C1466.CSSStorage.index=1)  // generic
		$css:=Folder:C1567("/SOURCES").file("styleSheets_mac.css")
	: (Form:C1466.CSSStorage.index=2)  // generic
		$css:=Folder:C1567("/SOURCES").file("styleSheets_windows.css")
	Else 
		return 
End case 

Case of 
	: (Form:C1466.CSSType.index=0)  // class
		If (Form:C1466.name="")
			ALERT:C41("Please enter a class name, to save as CSS class")
			return 
		End if 
		$name:="."+Form:C1466.name
		
	: (Form:C1466.CSSType.index=1)  // type
		$name:=Form:C1466.objecttype
		
	: (Form:C1466.CSSType.index=2)  // name
		$name:="#"+Form:C1466.objectname
End case 

// to get the content, we need to reformat the object
// semicolon at the end of the line (each line)
$content:=JSON Stringify:C1217(Form:C1466.preview)
$content:=Replace string:C233($content; Char:C90(34); "")
$content:=Replace string:C233($content; "{"; "")
$content:=Replace string:C233($content; "}"; "")
$content_col:=Split string:C1554($content; ","; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
$content:="{\n"+$content_col.join(";\n")+";\n}"


If ($css.exists)
	$curCSSText:=$css.getText()
	$regex:="([\\s\\S]*?)\\{([\\s\\S]*?)\\}"  // https://www.jotform.com/blog/writing-a-css-parser-in-javascript/"
	$start:=1
	$found:=False:C215
	While ($start<Length:C16($curCSSText))
		ARRAY LONGINT:C221($pos_found; 0)
		ARRAY LONGINT:C221($length_found; 0)
		$vfound:=Match regex:C1019($regex; $curCSSText; $start; $pos_found; $length_found)
		If (($vFound) && (Size of array:C274($pos_found)>=2))
			$foundString:=Substring:C12($curCSSText; $pos_found{1}; $length_found{1})
			$foundString:=Replace string:C233($foundString; " "; "")
			$foundString:=Replace string:C233($foundString; "\n"; "")
			$foundString:=Replace string:C233($foundString; "\r"; "")
			If ($foundString=$name)
				$curCSSText:=Substring:C12($curCSSText; 1; $pos_found{1}-1)+"\n"+$name+" "+$content+Substring:C12($curCSSText; $pos_found{2}+$length_found{2}+1)
				$found:=True:C214
				break
			End if 
			$start:=$pos_found{0}+$length_found{0}
		Else 
			break
		End if 
	End while 
	If (Not:C34($found))
		$curCSSText+=("\n"+$name+" "+$content)
	End if 
Else 
	$curCSSText:=$name+" "+$content
End if 

$css.setText($curCSSText)



