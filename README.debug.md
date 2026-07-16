# Persistent Debug Logs

## How a log file is chosen

The chainloader will look for the existence of logfiles in the same
directory as the chainloader executable with  names matching the pattern:

   `PREFIX`steamcl-debug.log

Where `PREFIX` is allowed to be "" (the empty string).

All files matching the pattern above are considered, and the oldest (by
modification timestamp, ie Least Recently Used) one is selected.

If two logfiles have same timestamp then a lexical comparison of their
`PREFIX` values is used as a tie breaker.

Since booting always takes more than two seconds (the BIOS and kernel
phases are each longer than this) this is unlikely to matter in actual
use, but does guarantee a predictable choice of log file.

**NOTE**: `steamcl-debug.log` is from the `PREALLOC_DEBUGLOG` `#define`

## Creating a log file

Any method that creates a log file filled with NULs (or spaces) should
do just fine. For example:

## Fall-back boot path:

  `dd if=/dev/zero of=/esp/efi/boot/steamcl-debug.log bs=4096 count=1`

## SteamOS boot path:

  `dd if=/dev/zero of=/esp/efi/steamos/steamcl-debug.log bs=4096 count=1`

## SteamOS boot path, 3 LRU files:

```
  dir=/esp/efi/steamos
  file=steamcl-debug.log
  for x in "" 01 02; do dd if=/dev/zero of=$dir/$x$file bs=4096 count=1; done
```

## How a log file is used

If a suitably named log file is present the chosen file is treated as a
fixed size file into which to write all debug, warning, and log messages.

Each log messages is numbered (monotonically increasing)

Each log message is timestamped.

If logging reaches the file end, writes wrap to the file start again.

4 KiB of log should be sufficient to avoid wrap around at present,
but if more verbose logging has been added you may need to go to
a larger file.

Files don't have to be in multiples of the filesystem block size
(unless you don't fully trust the VFAT driver in your BIOS, in which
case 4 KiB should _always_ be safe).

## Log file contents

The log will always start with 4 entries like this:

```
000 16:34:08 chainloader/debug.c:debug_log_start_logging@239 initialised @ 2026-07-01 16:34:08
001 16:34:08 chainloader/debug.c:debug_log_start_logging@240 dummy warnings x2 follow (logging tests): EFI_UNSUPPORTED
002 16:34:08 chainloader/debug.c:debug_log_start_logging@241 test: გამარჯობა Вітаю こんにちは 你好: EFI_INVALID_LANGUAGE
003 16:34:08 chainloader/debug.c:debug_log_start_logging@242 test: dummy error: EFI_INVALID_PARAMETER
```

An initialisation stamp, two test warnings, and a test error.

The second test warning also serves to check that the `UCS-2`/`UTF-8`
support in the chainloader is correct.

For a successful run the last log entries in the file should be something like:

```
026 16:34:08 chainloader/bootload.c:exec_bootloader@1329 constructing stage 2 loader device path
027 16:34:08 chainloader/bootload.c:exec_bootloader@1338 loading stage 2 loader to memory
028 16:34:08 chainloader/bootload.c:exec_bootloader@1349 setting loader command line ""
⋮
032 16:34:08 chainloader/bootload.c:exec_bootloader@1357 Executing stage 2 loader at 2026-07-01 16:34:08
```

# Verbose mode

In verbose mode log, warning and debug messages are echoed to the console.

Verbose mode can be triggered by creating a file called `steamcl-verbose`
in the same directory as the chainloader executable.
