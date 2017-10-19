//
//  JCMath.h
//
//  Created by molin.JC on 2017/5/11.

/** 返回10的x次方 */
static inline int pow10x(int x){
    return pow(10, x);
}

/** 返回x的平方 */
static inline CGFloat powX2(CGFloat x){
    return pow(x, 2);
}

/** 返回x的立方 */
static inline CGFloat powX3(CGFloat x){
    return pow(x, 3);
}

/** 保留y位小数 */
static inline CGFloat holdDecimal(CGFloat x, int y) {
    int ins = pow10x(y);
    return ((int)(x * ins)) / (ins * 1.0);
}

/** x按四舍五入保留y位小数 */
static inline CGFloat roundX(CGFloat x,int y){
    int ins = pow10x(y);
    return roundf(x * ins) * 1.0 / ins;
}

/** x按五入保留y位小数 */
static inline CGFloat ceilX(CGFloat x,int y){
    int ins = pow10x(y);
    return ceilf(x * ins) * 1.0 / ins;
}

/** x按四舍保留y位小数 */
static inline CGFloat floorX(CGFloat x,int y){
    int ins = pow10x(y);
    return floorf(x * ins) * 1.0 / ins;
}
