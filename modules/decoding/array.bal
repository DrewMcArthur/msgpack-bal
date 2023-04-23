function isFixArray(byte firstByte) returns boolean {
    return (firstByte & 0xf0) == 0x90;
}

function handleFixArray(byte[] data) returns json[]|error {
    int array_length = data[0] & 0x0f;
    json[] output = [];
    byte[] array_data = data.slice(1, data.length());
    foreach int i in 1 ... array_length {
        int item_length = check getItemLength(array_data);
        // todo: this won't work for nested arrays, we need to pop off somehow.
        output.push(check decode(array_data));
        array_data = array_data.slice(item_length, array_data.length());
    }
    return output;
}
