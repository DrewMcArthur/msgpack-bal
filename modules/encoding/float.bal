import ballerina/math;

function encodeFloat(float num) returns byte[]|error {
    // http://javascript.g.hatena.ne.jp/edvakf/20101128/1291000731
    float newnum = num;
    boolean sign = num < 0.0;
    if sign {
        newnum = num * -1;
    }

    // add offset 1023 to ensure positive
    // 0.6931471805599453 = Math.LN2;
    int exp = ((math.log(newnum) / 0.6931471805599453) + 1023) | 0;

    // shift 52 - (exp - 1023) bits to make integer part exactly 53 bits,
    // then throw away trash less than decimal point
    frac = num * Math.pow(2, 52 + 1023 - exp);

    //  S+-Exp(11)--++-----------------Fraction(52bits)-----------------------+
    //  ||          ||                                                        |
    //  v+----------++--------------------------------------------------------+
    //  00000000|00000000|00000000|00000000|00000000|00000000|00000000|00000000
    //  6      5    55  4        4        3        2        1        8        0
    //  3      6    21  8        0        2        4        6
    //
    //  +----------high(32bits)-----------+ +----------low(32bits)------------+
    //  |                                 | |                                 |
    //  +---------------------------------+ +---------------------------------+
    //  3      2    21  1        8        0
    //  1      4    09  6
    low = frac & 0xffffffff;
sign && (exp |= 0x800);
    high = ((frac / 0x100000000) & 0xfffff) | (exp << 20);

    rv.push(0xcb, (high >> 24) & 0xff, (high >> 16) & 0xff,
                            (high >> 8) & 0xff, high & 0xff,
                            (low >> 24) & 0xff, (low >> 16) & 0xff,
                            (low >> 8) & 0xff, low & 0xff);
}
