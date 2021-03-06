$path_to_hscreen = "" # the path to your hubstaff dir with screenshots
$pat_to_gallery = "" # the path to your collection created with create_collection.py
$sl = "/"
$img_names = @()
$last_items = @()

function GetRandomItem ($arr) {
	if ($arr.Count -eq $last_items) {$last_items = @()}
	while(1) {
		$item = Get-Random $arr
		if($arr.Contains($item)) {break}
	}
	return $item
}

function GetNameItem ($item) {
	$name = $item.Split(".")[0]
	if ($name.EndsWith("-thumb")){
		$name = $name.Substring(0, $name.LastIndexOf("-thumb"))
	}
	return $name
}

function Rename($arr){
	$path = $arr[0]
	$name = $arr[1]
	Write-Host "Path0: $path"
	$arr = Get-ChildItem -Path $path -Name
	foreach($elem in $arr) {
		if ($elem.EndsWith("-thumb.jpg")) {
			$new_item = $name + "-thumb" +".jpg"
		} else {
			$new_item = $name + ".jpg"
		}
		$path_to_item = $path + $elem
		Rename-Item $path_to_item $new_item
	}
}

$gallery_items = Get-ChildItem -Path $pat_to_gallery -Name

while(1) {
	$screens_items = Get-ChildItem -Path $path_to_hscreen -Name
	if (($screens_items.Count -gt 1) -and -not ($screens_items.Count % 2)) {
		foreach($elem in $screens_items) {
			$temp_name = GetNameItem($elem)
			if ($img_names.Contains($temp_name)) {
				continue
			}
			$temp_item = GetRandomItem($gallery_items)
			$temp_path = $pat_to_gallery + $temp_item + $sl
			Rename($temp_path, $temp_name)
			$temp_path += "*"
			Copy-Item $temp_path -Destination $path_to_hscreen -Recurse
			Write-Host "MOVE $temp_path -> $pat_to_gallery"
			Write-Host "Names: $img_names <- $temp_name"
			$img_names += $temp_name
		}

	}
    Start-Sleep -s 1
}
