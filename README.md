# NAME

Pod::Perldoc::ToNroff4 - translated pods adds language dependent tmac
to pod2man preamble.

# SYNOPSIS

    $ perldoc -o nroff4 -L XX ...

# BUG

Since the language code is obtained from pod pathname, the module may
not be able to determine it, e.g. perldoc -v. In this cases, use
`__lang=_XX_` for now, as follows:

    $ perldoc -o nroff4 -L XX -w __lang=XX -v '$_'

# SEE ALSO

[Pod::Perldoc::ToNroff](https://metacpan.org/pod/Pod%3A%3APerldoc%3A%3AToNroff), [Pod::Man](https://metacpan.org/pod/Pod%3A%3AMan)

# LICENSE

Copyright (C) KUBO, Koichi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

KUBO, Koichi <k@obuk.org>
