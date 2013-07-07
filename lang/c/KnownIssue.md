# CRLF issue
CR/LF issue in window/mac platform. Under Different platform '\r' might considered to be part of the value.

# All the static alloc buffer are assumed it to be clean as 0.
This is not garenteed.So we should add code to initialize it some day.

#didnt check MaxPathLength (though defined it);

# clear-silver seems using ':' for referrring. And according to les, we don't need refering. so consider refering to be = 
