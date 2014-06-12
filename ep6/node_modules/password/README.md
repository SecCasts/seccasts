A memorable password generator for Node.js
==========================================

`password` is a simple server-side memorable password generator for Node.js

It is based on a list of 21,114 English words, thereby providing about 14 bits of randomness per word. A useful password will therefor require at least 3 words.

The module returns a function which can be called with the desired number of words.

    var password = require('password');
    console.log(password(4));

You can also access the list of words:

    var words = require('password').wordlist;
    console.log(words[352]);
