#ifdef QB64_WINDOWS
std::string ReplaceAll(std::string str, const std::string& from, const std::string& to) {
    size_t start_pos = 0;
    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
    }
    return str;
}

std::string pipecom_buffer;
const char* pipecom(char* cmd){
pipecom_buffer = "";
BOOL ok = TRUE;
HANDLE hStdOutPipeRead = NULL;
HANDLE hStdOutPipeWrite = NULL;
SECURITY_ATTRIBUTES sa = { sizeof(SECURITY_ATTRIBUTES), NULL, TRUE };
    if (CreatePipe(&hStdOutPipeRead, &hStdOutPipeWrite, &sa, 0) == FALSE)
	{
		return "";
	}

    STARTUPINFO si = { };
    si.cb = sizeof(STARTUPINFO);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdError = NULL;
    si.hStdOutput = hStdOutPipeWrite;
    si.hStdInput = NULL;
    PROCESS_INFORMATION pi = { };
    LPSTR lpApplicationName = NULL;
	char * fullcmd = (char *) malloc(1+strlen(cmd)+strlen((LPSTR)"cmd /c "));
	strcpy(fullcmd, (LPSTR)"cmd /c ");
	strcat(fullcmd, cmd);
    LPSTR lpCommandLine = (LPSTR)fullcmd;
    LPSECURITY_ATTRIBUTES lpProcessAttributes = NULL;
    LPSECURITY_ATTRIBUTES lpThreadAttribute = NULL;
    BOOL bInheritHandles = TRUE;
    DWORD dwCreationFlags = CREATE_NO_WINDOW;
    LPVOID lpEnvironment = NULL;
    LPCSTR lpCurrentDirectory = NULL;
    ok = CreateProcess(
        lpApplicationName,
        lpCommandLine,
        lpProcessAttributes,
        lpThreadAttribute,
        bInheritHandles,
        dwCreationFlags,
        lpEnvironment,
        lpCurrentDirectory,
        &si,
        &pi);
    if (ok == FALSE) return "";

    CloseHandle(hStdOutPipeWrite);

    char buf[4096+1] = { };
    DWORD dwRead = 0;
    while (ReadFile(hStdOutPipeRead, &buf, 4096, &dwRead, NULL) && dwRead)
    {
        buf[dwRead] = '\0';
		pipecom_buffer.append(buf);
    }
    CloseHandle(hStdOutPipeRead);
	pipecom_buffer = ReplaceAll(pipecom_buffer, "\r", "\0");
    return pipecom_buffer.c_str();
	}
#else
string pipecom_buffer;
const char* pipecom (char* cmd){
	pipecom_buffer = "";
    FILE* stream;
    const int max_buffer = 256;
    char buffer[max_buffer];
    pipecom_buffer.clear();

    stream = popen(cmd, "r");
    if (stream) {
        while (!feof(stream)) {
            if (fgets(buffer, max_buffer, stream) != NULL) {
                pipecom_buffer.append(buffer);
            }
        }
        pclose(stream);
    }
	return pipecom_buffer.c_str();
}
#endif