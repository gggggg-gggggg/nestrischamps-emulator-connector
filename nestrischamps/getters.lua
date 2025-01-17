function getPieceState() -- pieceState is a thing for the current piece about which "routine" it's in, like piece dropping, line checks, line clears, etc
    return memory.readbyte(0x0048)
end

function getGameState() -- gameState is a global thing for which menu/demo/gameplay you're in
    return memory.readbyte(0x00C0)
end

function getScore()
	local letters = {a = 10, b = 11, c = 12, d = 13, e = 14, f = 15}
	local byte = string.format("%02x", memory.readbyte(0x0055))
	local scoreLeft = tonumber(byte)
	if not scoreLeft then
		local left = string.sub(byte, 1, 1)
		local right = string.sub(byte, 2, 2)
		if letters[left] then
			local r = tonumber(right)
			if not r then
				r = letters[right]
			end
			scoreLeft = letters[left] * 10 + r
		elseif letters[right] then
			local l = tonumber(left)
			if not l then
				l = letters[left]
			end
			scoreLeft = l * 10 + letters[right]
		end
	end

	local scoreMiddle = tonumber(string.format("%x", memory.readbyte(0x0054)))

	local scoreRight = tonumber(string.format("%x", memory.readbyte(0x0053)))

	local score = scoreLeft*10000 + scoreMiddle*100 + scoreRight
	return score
end

function getLines()
	local linesLeft = tonumber(string.format("%x", memory.readbyte(0x0051)))
	local linesRight = tonumber(string.format("%x", memory.readbyte(0x0050)))

	local lines = linesLeft*100 + linesRight
	return lines
end

function getLevel()
	return memory.readbyte(0x0044)
end

function getNextPiece()
    return PIECETABLE[memory.readbyte(0x00BF)+1]
end

function getBlock(x, y)
    local address = 0x400 + (x-1) + (y-1)*10

    local block = memory.readbyte(address)

    return PLAYFIELDGRAPHICTABLE[block] or "01"
end

function getCurrentPosition()
    local x = memory.readbyte(0x0040)
    local y = memory.readbyte(0x0041)

    return x, y
end

function getCurrentPiece()
    return memory.readbyte(0x0042)
end

function getLinesBeingCleared()
    local linesBeingCleared = {}

    for i = 0, 3 do
        local num = memory.readbyte(0x004A + i)

        if num ~= 0 then -- I have no idea what happens when you clear line 0x00. It uses 0x00 as "false"...
            table.insert(linesBeingCleared, num+1)
        end
    end

    return linesBeingCleared
end

function getLineClearAnimation()
    return memory.readbyte(0x0052)
end

function getCurtainAnimation()
    return memory.readbyte(0x0058)
end

function getPieceStatistic(pieceNum)
    local address = 0x03F0 + (pieceNum-1)*2

	local statisticLeft = tonumber(string.format("%x", memory.readbyte(address+1)))
	local statisticRight = tonumber(string.format("%x", memory.readbyte(address)))

	local statistic = statisticLeft*100 + statisticRight

    return statistic
end
