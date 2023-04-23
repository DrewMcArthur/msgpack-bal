function isPositiveFixInt(byte b) returns boolean {
    return (b & 0x80) == 0x00;
}

function handlePositiveFixInt(byte[] data) returns int {
    return <int>data[0];
}
