###################################
# NAME: Get-MemoryType.ps1
# AUTHOR:  Fritz R.
# COMMENT: 
# VERSION HISTORY:
# 1.0 06.06.2013 - Initial release
###################################

Function Get-PhysicalMemory($computername = ".") {
	$memorytype = "Unknown", "Other", "DRAM", "Synchronous RAM", "Cache DRAM", "EDO", "EDRAM", 
	"VRAM", "SRAM", "RAM", "ROM", "Flash", "EEPROM", "FEPROM", "EPROM", "CDRAM", "3DRAM", "SDRAM", 
	"SGRAM", "RDRAM", "DDR", "DDR-2"
	
	$formfactor = "Unknown", "Other", "SIP", "DIP", "ZIP", "SOJ", "Proprietary", "SIMM", "DIMM", 
	"TSOP", "PGA", "RIMM", "SODIMM", "SMD", "SSMP", "QFP", "TQFP", "SOIC", "LCC", "PLCC", 
	"BGA", "FPBGA", "LGA"
	
	$spalte1 = @{Name='Größe (GB)'; Expression={ $_.Capacity/1GB }}
	$spalte2 = @{Name='Bauart'; Expression={ $_.formfactor[$_.FormFactor] }}
	$spalte3 = @{Name='Speichertyp'; Expression={ $memorytype[$_.MemoryType]}}
	
	# Get-WmiObject Win32_PhysicalMemory -ComputerName $computername | Select-Object BankLabel, $spalte1, $spalte2, $spalte3
	Get-WmiObject Win32_PhysicalMemory
}

Get-PhysicalMemory
