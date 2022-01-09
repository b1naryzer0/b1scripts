#######################################################################
# sort mp3 files by timestamp and concatenate them to a big file
# useful when you downloaded single mp3 files but want one big file
# run this in the folder with the mp3 files

Get-ChildItem | sort LastWriteTime | Get-Content -raw | Set-Content FullAlbum.mp3
