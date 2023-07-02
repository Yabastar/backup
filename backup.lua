-- Function to check if a floppy disk is full
local function isFloppyFull()
  if disk.isPresent("top") then
    return not disk.hasData("top")
  end
  return false
end

-- Function to copy a file from the computer to the floppy disk
local function copyFileToFloppy(filePath)
  local fileName = fs.getName(filePath)
  local floppyPath = fs.combine("disk", fileName)
  fs.copy(filePath, floppyPath)
end

-- Main program
while true do
  if isFloppyFull() then
    print("Floppy disk is full. Please insert a new floppy disk.")
    repeat
      os.pullEvent("peripheral")
    until disk.isPresent("top") and disk.hasData("top")
  end

  local files = fs.list("/")
  for _, file in ipairs(files) do
    local filePath = fs.combine("/", file)
    if not fs.isDir(filePath) then
      copyFileToFloppy(filePath)
      print("Copied file: " .. filePath)
    end
  end
end
