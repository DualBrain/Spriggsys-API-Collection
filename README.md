# Spriggsy's API Collection
## Collection of QB64 code written to interface with numerous APIs (REST/HTTP/WinAPI/C/C++)

## REST, HTTP, HTTPS API (Windows)

* Address Validation API (smartystreets.com)

* Currency Exchange Rate API (exchangerate-api.com)

* Profanity Check/Censor API (purgomalum.com)

* Phone Number Verification API (apilayer.com)

* Insult Generator API (evilinsult.com)

* Sentiment API (sentimapi)

* Breaking News API (newsapi.org)

* Kitten Image Replacer API (placekitten)

* Image from Hash API (robohash)

* Screenshot of Webpage API (screenshotlayer.com)

* NASA Astronomy Pic of the Day API (nasa.gov) Updated 08/20/2020 Updated with source I had posted elsewhere. Much more efficient code.

* DCUO Census API (daybreakcensus)

* Online Movie Database API (omdb) Updated 10/18/2020 (Using Wininet WinAPI for internet connectivity)

* Lyrics API (lyrics.ovh)

* Weather API using GeoLocation from IP Address (various API vendors) Added 08/18/20 since it was missing from collection

* Owlbot Dictionary API Added 08/19/2020

* Genderize API Added 09/20/2020

* QR Tag API Added 09/20/2020

* Gravatar Image from email address hash API (gravatar, wordpress) Updated 10/18/2020 (Using Wininet WinAPI for internet connectivity)

## WinAPI Libraries (Windows)
* UuidCreate, UuidCreateSequential, UuidHash (rpcrt4, Wininet) UUID Creation and MAC Address Lookup (uuidtools and macvendors.com) Updated 10/17/2020

* SHFileOperation (Shell32) Added 09/22/2020

* GetComputerName, GetUsername (Kernel32 , Advapi32) Added 09/22/2020

* FindExecutableA (Shell32) Added 09/26/2020

* ShellAboutA (Shell32) Added 09/26/2020

* mciSendStringA (WINMM) Record and playback audio (updated source with ffmpeg waveform drawing.) Added 09/26/2020

* DoEnvironmentSubstA, GetEnvironmentVariableA, ExpandEnvironmentStringsA (Shell32) (Works similarly to ENVIRON$ but with some extra functionality and speed. Added 09/26/2020

* ExractIcon, DrawIcon (Shell32 , User32) Added 09/27/2020

* SetWindowPos, GetForegroundWindow (User32) Credit to Pete and visionmercer, original post here Added 09/27/2020

* AnimateWindow (User32) Added 09/30/2020

* FlashWindow/FlashWindowEx (User32) Added 10/02/2020

* capCreateCaptureWindow (Avicap32) Records webcam footage to AVI file Added 10/02/2020

* OpenProcess, TerminateProcess (Kernel32) Kill process by name or PID Added 10/05/2020

* MessageBeep (User32) Plays WAV audio for common message sounds Added 10/05/2020

* OpenClipboard, GetClipboardData (User32) Added 10/07/2020

* GetBinaryType (Kernel32) Added 10/09/2020

* GetTempPath, GetTempFileName (Kernel32) Added 10/09/2020

* GetDateFormat, GetCurrencyFormat (Kernel32) Added 10/09/2020

* OpenProcess, ReadProcessMemory, WriteProcessMemory (Kernel32) Complete Rewrite 02/17/21 (Peeping Tom, a powerful PEEK/POKE library for QB64)

* XInputGetState, XInputSetState, XInputGetBatteryInformation (Xinput1_4) Tests an XInput enabled controller Added 10/26/2020

* (Wininet) Various Wininet FTP functions for uploading, downloading, directory listing, etc. Added 11/17/2020

* SHOpenWithDialog (Shell32) Invokes the "Open with" dialog in Windows Added 02/06/2021

* Various Threading functions for Multi-threaded Applications (MSDN Example conversion). Added 5/30/2021

* Parent and Child Process piping (MSDN Example Conversion). Added 5/30/2021

## Cross-Platform Libraries (Windows, Macintosh, and Linux)
* pipecom (pipecom) Header file that pipes console output to QB64. Win (using WinAPI), Mac, and Linux (using C libraries). Added 10/26/2020
  * Updated pipecom! Now it exists as a header and as a pure QB64 include. Both work equally as well. Added 02/12/2021

* encodeBase64, decodeBase64 (Crypt32, base64 (Linux and Mac)) Added 11/05/2020

* mapvar, getmappedvalue (mappedvar) Header file that creates variables mapped to strings. Added 12/20/2020

* (preproc) Header file that allows for usage of multiple preprocessor macros available to us in C++. Added 12/23/2020

## Miscellaneous APIs / Libraries
* hid_read, hid_write (hidapi) Provides HID access to devices over Bluetooth and USB connection (Windows) Test source for interfacing with Nintendo Switch Pro Controller over     Bluetooth HID. Added 12/07/2020.
