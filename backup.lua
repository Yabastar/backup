-- Function to check if a floppy disk is full
local function isFloppyFull(floppy)
  local diskLabel = fs.getDiskLabel(floppy)
  if diskLabel then
    local freeSpace = fs.getFreeSpace(diskLabel)
    return freeSpace == 0
  end
  return false
end

-- Function to copy a file from the computer to the floppy disk
local function copyFileToFloppy(filePath, floppy)
  local fileName = fs.getName(filePath)
  local floppyPath = fs.combine(floppy, fileName)
  fs.copy(filePath, floppyPath)
end

-- Main program
local floppy = peripheral.find("drive")
if not floppy or not peripheral.getType(floppy) == "drive" then
  print("No floppy disk drive found.")
  return
end

while true do
  if isFloppyFull(floppy) then
    print("Floppy disk is full. Please insert a new floppy disk.")
    repeat
      os.pullEvent("peripheral")
      floppy = peripheral.find("drive")
    until floppy and peripheral.getType(floppy) == "drive"
  end

  local files = fs.list("/")
  for _, file in ipairs(files) do
    local filePath = fs.combine("/", file)
    if fs.isFile(filePath) then
      copyFileToFloppy(filePath, floppy)
      print("Copied file: " .. filePath)
    end
  end
end
