local CharacterIndexTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function ToBinary(integer)
    local Remaining = tonumber(integer)
    local BinBits = ""

    for i = 7, 0, -1 do
        local CurrentPower = 2 ^ i

        if Remaining >= CurrentPower then
            BinBits = BinBits .. "1"
            Remaining = Remaining - CurrentPower
        else
            BinBits = BinBits .. "0"
        end
    end

    return BinBits
end

function FromBinary(binbits)
    return tonumber(binbits, 2)
end

function Base64Encode(toencode)
    local BitPattern = ""
    local Encoded = ""
    local Trailing = ""

    for i = 1, string.len(toencode) do
        BitPattern = BitPattern .. ToBinary(string.byte(string.sub(toencode, i, i)))
    end

    if string.len(BitPattern) % 3 == 2 then
        Trailing = "=="
        BitPattern = BitPattern .. "0000000000000000"
    elseif string.len(BitPattern) % 3 == 1 then
        Trailing = "="
        BitPattern = BitPattern .. "00000000"
    end

    for i = 1, string.len(BitPattern), 6 do
        local Byte = string.sub(BitPattern, i, i+5)
        local Offset = tonumber(FromBinary(Byte))
        Encoded = Encoded .. string.sub(CharacterIndexTable, Offset + 1, Offset + 1)
    end

    return string.sub(Encoded, 1, -1 - string.len(Trailing)) .. Trailing
end


function Base64Decode(todecode)
    local Padded = todecode:gsub("%s", "")
    local Unpadded = Padded:gsub("=", "")
    local BitPattern = ""
    local Decoded = ""

    for i = 1, string.len(Unpadded) do
        local Character = string.sub(todecode, i, i)
        local Offset, _ = string.find(CharacterIndexTable, Character)
        if Offset == nil then
            error("Invalid character '" .. char .. "' found.")
        end

        BitPattern = BitPattern .. string.sub(ToBinary(Offset - 1), 3)
    end

    for i = 1, string.len(BitPattern), 8 do
        local Byte = string.sub(BitPattern, i, i+7)
        Decoded = Decoded .. string.char(FromBinary(Byte))
    end

    local PaddingLength = Padded:len() - Unpadded:len()

    if (PaddingLength == 1 or PaddingLength == 2) then
        Decoded = Decoded:sub(1,-2)
    end
    return Decoded
end

return {
    Encode = Base64Encode,
    Decode = Base64Decode
}