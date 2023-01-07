#include <windows.h>
#include <strsafe.h>
#include <iostream>

const LPCTSTR STR_VARNAME = L"PreviousBoot";
const LPCTSTR STR_VARGUID = L"{36d08fa7-cf0b-42f5-8f14-68df73ed3740}";

void ErrorExit() {
	DWORD error = GetLastError();

	LPTSTR errorText = nullptr;
	FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
		nullptr, error, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPTSTR) &errorText, 0, nullptr);
	std::wcerr << L"Error " << error << L": " << errorText << std::endl;
	LocalFree(errorText);
	
	ExitProcess(error);
}


int main(int argc, char** argv) {
	if (argc != 2) {
		std::wcerr << L"Error: Must have exactly one command line argument" << std::endl;
		ExitProcess(1);
	}

	/* get the privileges necessary */
	HANDLE hToken;
	if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken)) {
		ErrorExit();
	}

	TOKEN_PRIVILEGES tkp;
	LookupPrivilegeValue(nullptr, SE_SYSTEM_ENVIRONMENT_NAME, &tkp.Privileges[0].Luid);
	tkp.PrivilegeCount = 1;
	tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
	AdjustTokenPrivileges(hToken, FALSE, &tkp, 0, nullptr, 0);
	if (GetLastError() != ERROR_SUCCESS) {
		ErrorExit();
	}
	
	/* construct the efivar content */
	char* sStr = argv[1];
	DWORD nStrSize = strlen(sStr);
	DWORD nVarSize = 4 + (2 * nStrSize);
	BYTE* lpVarData = (BYTE*)LocalAlloc(LPTR, nVarSize);

	lpVarData[nVarSize - 4] = 0x20;
	for (DWORD i = 0; i < nStrSize; i++) {
		lpVarData[(2 * i)] = sStr[i];
		lpVarData[1 + (2 * i)] = 0x00;
	}

	/* write the efivar contents to the efivar */
	DWORD dwSetResult = SetFirmwareEnvironmentVariable(STR_VARNAME, STR_VARGUID, lpVarData, nVarSize);
	if (!dwSetResult) {
		ErrorExit();
	}
}
